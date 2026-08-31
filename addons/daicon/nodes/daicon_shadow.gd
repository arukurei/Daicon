@tool
@icon("res://addons/daicon/icons/daicon_shadow.svg")
class_name DaiconShadow extends Sprite2D

#region Properties
@export_range(0.05, 2.0, 0.05, "suffix:m") var footprint_radius: float = 0.35:
	set(v):
		footprint_radius = v
		if shape_cast and shape_cast.shape is CylinderShape3D: (shape_cast.shape as CylinderShape3D).radius = footprint_radius

@export_range(0.0, 1.0, 0.05) var shadow_opacity: float = 0.6:
	set(v):
		shadow_opacity = v
		if _debug_layer: _debug_layer.queue_redraw()

@export var max_distance: float = 10.0:
	set(value):
		max_distance = maxf(value, 0.1)
		if shape_cast: shape_cast.target_position = Vector3.DOWN * max_distance

@export var fade_start_distance: float = 1.0

@export_flags_3d_physics var floor_mask: int = 1:
	set(value):
		floor_mask = value
		if shape_cast: shape_cast.collision_mask = floor_mask

@export var pivot_offset: Vector2 = Vector2.ZERO:
	set(v):
		pivot_offset = v
		if is_node_ready(): _update_shadow_projection()

@export_group("Debug")
@export var debug_ray: bool = false:
	set(value): debug_ray = value; _update_debug_overlay()

@export var debug_color: Color = Color("00ffcc"):
	set(value):
		debug_color = value
		if debug_ray and _debug_layer: _debug_layer.queue_redraw()
#endregion

#region Variables
const SHAPE_NAME = "ShadowShapeCast"

var parent_entity: DaiconEntity
var shape_cast: ShapeCast3D
var _debug_layer: Node2D
#endregion

#region Lifecycle
func _ready() -> void:
	z_as_relative = false
	show_behind_parent = true
	_find_entity()
	if parent_entity and parent_entity.core: _inject_shapecast()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PARENTED, NOTIFICATION_UNPARENTED: update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if not DaiconEntity.find_parent_entity(self):  warnings.append("DaiconShadow must be a child node of DaiconEntity!")
	return warnings

func _process(_delta: float) -> void:
	if not parent_entity:
		_find_entity()
		if not parent_entity: return
	
	if not parent_entity.core: return
	
	if not shape_cast or not is_instance_valid(shape_cast) or shape_cast.get_parent() != parent_entity.core: 
		_inject_shapecast()
	
	if Engine.is_editor_hint() and shape_cast: 
		shape_cast.force_shapecast_update()
	
	_update_shadow_projection()
	_update_debug_overlay()
#endregion

#region Core Setup
func _find_entity() -> void: parent_entity = DaiconEntity.find_parent_entity(self)

func _inject_shapecast() -> void:
	if not parent_entity or not parent_entity.core: return
	
	if shape_cast and not is_instance_valid(shape_cast): shape_cast = null
	
	var existing = parent_entity.core.get_node_or_null(SHAPE_NAME)
	if existing is ShapeCast3D:
		shape_cast = existing
	else:
		shape_cast = ShapeCast3D.new()
		shape_cast.name = SHAPE_NAME
		
		var cylinder := CylinderShape3D.new()
		cylinder.radius = footprint_radius
		cylinder.height = 0.1
		shape_cast.shape = cylinder
		
		parent_entity.core.add_child(shape_cast, true)
	
	shape_cast.target_position = Vector3.DOWN * max_distance
	shape_cast.collision_mask = floor_mask
	shape_cast.collide_with_bodies = true
	shape_cast.collide_with_areas = false
	shape_cast.exclude_parent = true
	shape_cast.max_results = 4
	shape_cast.enabled = true
#endregion

#region Projection
func _update_shadow_projection() -> void:
	if not parent_entity or not parent_entity.core: return
	
	var height_size := float(parent_entity.tile_size)
	var core_local_y: float = parent_entity.core.position.y - parent_entity.offset_3d.y
	var floor_y: float = 0.0
	var distance: float = 0.0
	var hit_floor := false
	
	var on_ground := false
	if parent_entity.core is CharacterBody3D:
		on_ground = (parent_entity.core as CharacterBody3D).is_on_floor()
	
	if on_ground:
		floor_y = core_local_y
		distance = 0.0
		hit_floor = true
	elif shape_cast and shape_cast.is_colliding():
		var highest_y := -INF
		var best_point := Vector3.ZERO
		for i in shape_cast.get_collision_count():
			var pt = shape_cast.get_collision_point(i)
			if pt.y > highest_y:
				highest_y = pt.y
				best_point = pt
		floor_y = highest_y
		distance = parent_entity.core.global_position.distance_to(best_point)
		hit_floor = true
	else:
		if Engine.is_editor_hint():
			floor_y = core_local_y
			distance = 0.0
			hit_floor = true
		else:
			floor_y = parent_entity.core.position.y - max_distance
			distance = max_distance
			hit_floor = false
	
	var altitude: float = core_local_y - floor_y
	position = Vector2(pivot_offset.x, altitude * height_size + pivot_offset.y)
	
	if not hit_floor or distance > max_distance:
		visible = false
		modulate.a = 0.0
	else:
		visible = true
		if distance <= fade_start_distance:
			modulate.a = shadow_opacity
		else:
			var t = (distance - fade_start_distance) / maxf(max_distance - fade_start_distance, 0.001)
			modulate.a = lerp(shadow_opacity, 0.0, clampf(t, 0.0, 1.0))
	
	var floor_level := snappedf(floor_y, 0.01) + 1.0
	var step := parent_entity.z_step if parent_entity else 10
	var calculated_z := int(floor_level) * step
	z_index = min(calculated_z, parent_entity.z_index - 1)
#endregion


#region Debug
func _update_debug_overlay() -> void:
	if debug_ray:
		if not _debug_layer or not is_instance_valid(_debug_layer):
			_debug_layer = Node2D.new()
			_debug_layer.name = "ShadowDebugOverlay"
			_debug_layer.z_index = 4096
			_debug_layer.z_as_relative = false
			_debug_layer.draw.connect(_on_debug_draw)
			add_child(_debug_layer)
		_debug_layer.queue_redraw()
	else:
		if _debug_layer and is_instance_valid(_debug_layer):
			_debug_layer.queue_free()
			_debug_layer = null

func _on_debug_draw() -> void:
	if not parent_entity: return
	
	var feet_pos := to_local(parent_entity.global_position)
	
	_debug_layer.draw_line(feet_pos, Vector2.ZERO, Color(1, 0, 0.4, 0.9), 2.0)
	
	var pixel_radius := footprint_radius * float(parent_entity.tile_size)
	_debug_layer.draw_arc(Vector2.ZERO, pixel_radius, 0.0, TAU, 24, Color(debug_color, 0.8), 1.5)
	_debug_layer.draw_circle(Vector2.ZERO, 3.0, debug_color)
#endregion
