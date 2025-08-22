@tool
@icon("res://addons/daicon/icons/daicon_shadow.svg")
class_name DaiconShadow extends Sprite2D

var d3 : CharacterBody3D

var start_y : float
var current_y : float

@onready var _initial_alpha : float = self.modulate.a
const GRAVITY : int = 1000 # Y-axis accelaration.

#region DaiconShadow Exports

## The node to which the shadow is attached.
@export var daicon_parent : Node:
	set(node):
		daicon_parent = node
		if daicon_parent:
			if daicon_parent.get("tile_size"): self.tile_size = daicon_parent.get("tile_size")
			if daicon_parent.get("z_step"): self.z_step = daicon_parent.get("z_step")
	get():
		return daicon_parent
## Tile Size determines how many pixels equal 1 meter in 3D.[br](basically it is the tile size per cell size in 3D)[br] [br] [i]Automatically synchronized with parent.[/i]
@export var tile_size : int:
	set(size):
		if size > 0: tile_size = size
	get():
		return tile_size
## Z-step in sortable system between height levels.[br][br][i]Automatically synchronized with parent.[/i]
@export var z_step : int = 10:
	set(step):
		z_step = step
	get():
		return z_step
## The minimal distance to modulate texture (in meters).[br][br]- For Coloration optimal value is 1 and more;[br]- For Discoloration optimal value is below 1.
@export var min_distance : float = 1.0
## The max distance between parent and self (in meters).
@export var max_distance : float = 8.0
## Shadow modulation mode.
@export_enum("Discoloration", "Coloration") var shadow_mode: int = 0:
	set(mode):
		shadow_mode = mode
	get():
		return shadow_mode
## The behavior mode of the physical body core.[br][br]Logic stream checks the state of the body relative to the surface (is_on_floor). Direct does not.
@export_enum("Logic", "Direct") var stream_mode: int = 0:
	set(mode):
		stream_mode = mode
	get():
		return stream_mode
## Shape or Polygon 3D.
@export var shape : Node3D:
	set(node):
		if not d3: return
		if node:
			if node is CollisionShape3D:
				if shape: shape_properties = {}
				node.reparent(d3)
				d3.move_child(node, -1)
				node.position = Vector3(0, 0, 0) + shape_position
				node.rotation = Vector3(0, 0, 0) + shape_rotation
				node.scale = Vector3(0, 0, 0) + shape_scale
				shape_properties = {"Name" : node.name,
									"Shape" : node.shape,
									"Disabled" : node.disabled,
									
									"Position" : node.position,
									"Rotation" : node.rotation,
									"Scale" : node.scale,
									"Quaternion" : node.quaternion,
									"Basis" : node.basis,
									
									"RotationEditMode" : node.rotation_edit_mode,
									"RotationOrder" : node.rotation_order,
									"TopLevel" : node.top_level}
			elif node is CollisionPolygon3D:
				if shape: shape_properties = {}
				node.reparent(d3)
				d3.move_child(node, -1)
				node.position = Vector3(0, 0, 0) + shape_position
				node.rotation = Vector3(0, 0, 0) + shape_rotation
				node.scale = Vector3(0, 0, 0) + shape_scale
				shape_properties = {"Name" : node.name,
									"Depth" : node.depth,
									"Disabled" : node.disabled,
									"Polygon" : node.polygon,
									"Margin" : node.margin,
									
									"Position" : node.position,
									"Rotation" : node.rotation,
									"Scale" : node.scale,
									"Quaternion" : node.quaternion,
									"Basis" : node.basis,
									
									"RotationEditMode" : node.rotation_edit_mode,
									"RotationOrder" : node.rotation_order,
									"TopLevel" : node.top_level}
		else:
			shape_properties = {}
	get():
		if not shape_properties: return
		return d3.get_node(str(shape_properties.Name))

@export_group("Shape")
@export var current_shape : Shape3D:
	set(shape_3D):
		if shape:
			shape.shape = shape_3D
		if shape_properties:
			shape_properties["Shape"] = shape_3D
		current_shape = shape_3D
	get():
		if not shape: return
		return shape.shape
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var shape_position: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		if shape:
			shape.position = v_3
		if shape_properties:
			shape_properties["Position"] = v_3
		shape_position = v_3
	get():
		return shape_position
@export_custom(PROPERTY_HINT_RANGE, "-360,360,0.1,or_less,or_greater,radians") var shape_rotation: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		if shape:
			shape.rotation = v_3
		if shape_properties:
			shape_properties["Rotation"] = v_3
		shape_rotation = v_3
	get():
		return shape_rotation
@export_custom(PROPERTY_HINT_LINK, "") var shape_scale: Vector3 = Vector3(1, 1, 1):
	set(v_3):
		if shape:
			shape.scale = v_3
		if shape_properties:
			shape_properties["Scale"] = v_3
		shape_scale = v_3
	get():
		return shape_scale
@export var shape_properties : Dictionary:
	set(dict):
		if not dict and shape:
			shape.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		shape_properties = dict
	get():
		return shape_properties

#endregion

#region Core Exports

@export_category("KinematicBody3D")
@export_enum("Grounded", "Floating") var motion_mode_3d: int = 0:
	set(mode):
		if d3: d3.motion_mode = mode
		motion_mode_3d = mode
		property_list_changed.emit()
	get():
		return motion_mode_3d
@export var up_direction_3d: Vector3 = Vector3(0, 1, 0):
	set(v_3):
		if d3: d3.up_direction = v_3
		up_direction_3d = v_3
	get():
		return up_direction_3d
@export var slide_and_ceiling_3d: bool = true:
	set(value):
		if d3: d3.slide_on_ceiling = value
		slide_and_ceiling_3d = value
	get():
		return slide_and_ceiling_3d
@export_range(0, 180, 0.1, "radians_as_degrees") var wall_min_slide_ang: float = 0.261799:
	set(angle):
		if d3: d3.wall_min_slide_angle = angle
		wall_min_slide_ang = angle
	get():
		return wall_min_slide_ang

@export_group("Floor 3D")
@export var stop_on_slope_3d: bool = true:
	set(value):
		if d3: d3.floor_stop_on_slope = value
		stop_on_slope_3d = value
	get():
		return stop_on_slope_3d
@export var constant_speed_3d: bool = false:
	set(value):
		if d3: d3.floor_constant_speed = value
		constant_speed_3d = value
	get():
		return constant_speed_3d
@export var block_on_wall_3d: bool = true:
	set(value):
		if d3: d3.floor_block_on_wall = value
		block_on_wall_3d = value
	get():
		return block_on_wall_3d
@export_range(0, 180, 0.1, "radians_as_degrees") var max_angle_3d: float = 0.785398:
	set(angle):
		if d3: d3.floor_max_angle = angle
		max_angle_3d = angle
	get():
		return max_angle_3d
@export_range(0, 1, 0.01, "or_greater", "suffix:m") var snap_length_3d: float = 0.1:
	set(angle):
		if d3: d3.floor_snap_length = angle
		snap_length_3d = angle
	get():
		return snap_length_3d
const grounded_properties : Array[StringName] = [&"up_direction_3d", &"slide_and_ceiling_3d", &"wall_min_slide_ang", &"Floor 3D", &"stop_on_slope_3d", &"constant_speed_3d", &"block_on_wall_3d", &"max_angle_3d", &"snap_length_3d"]
const floating_properties : Array[StringName] = [&"wall_min_slide_ang"]

@export_group("Moving Platform 3D")
@export_enum("Add Velocity", "Add Upward Velocity", "Do Nothing") var on_leave: int = 0:
	set(mode):
		if d3: d3.platform_on_leave = mode
		on_leave = mode
	get():
		return on_leave
@export_flags_3d_physics var floor_layers: int = 0xFFFFFFFF:
	set(layer):
		if d3: d3.platform_floor_layers = layer
		floor_layers = layer
	get():
		return floor_layers
@export_flags_3d_physics var wall_layers: int = 0:
	set(layer):
		if d3: d3.platform_wall_layers = layer
		wall_layers = layer
	get():
		return wall_layers

@export_group("Collision")
@export_range(0.001, 256, 0.001, "suffix:m") var safe_margin_3d: float = 0.001:
	set(margin):
		if d3: d3.safe_margin = margin
		safe_margin_3d = margin
	get():
		return safe_margin_3d

@export_category("CollisionObject3D")
@export_enum("Remove", "Make Static", "Keep Active") var disable_mode_3d = 0:
	set(mode):
		if d3: d3.disable_mode = mode
		disable_mode_3d = mode
	get():
		return disable_mode_3d

@export_group("Collision")
@export_flags_3d_physics var layer = 1:
	set(collision_layer):
		if d3: d3.collision_layer = collision_layer
		layer = collision_layer
	get():
		return layer
@export_flags_3d_navigation var mask = 1:
	set(collision_mask):
		if d3: d3.collision_mask = collision_mask
		mask = collision_mask
	get():
		return mask
@export var priority: float = 1:
	set(value):
		if d3: d3.collision_priority = value
		priority = value
	get():
		return priority

@export_group("Input")
@export var ray_pickable: bool = true: 
	set(value):
		if d3: d3.input_ray_pickable = value
		ray_pickable = value
	get():
		return ray_pickable
@export var capture_on_drag: bool: 
	set(value):
		if d3: d3.input_capture_on_drag = value
		capture_on_drag = value
	get():
		return capture_on_drag

@export_group("Axis Lock")
@export var linear_x: bool = false:
	set(value):
		if d3: d3.axis_lock_linear_x = value
		linear_x = value
	get():
		return linear_x
@export var linear_y: bool = false:
	set(value):
		if d3: d3.axis_lock_linear_y = value
		linear_y = value
	get():
		return linear_y
@export var linear_z: bool = false:
	set(value):
		if d3: d3.axis_lock_linear_z = value
		linear_z = value
	get():
		return linear_z
@export var angular_x: bool = false:
	set(value):
		if d3: d3.axis_lock_angular_x = value
		angular_x = value
	get():
		return angular_x
@export var angular_y: bool = false:
	set(value):
		if d3: d3.axis_lock_angular_y = value
		angular_y = value
	get():
		return angular_y
@export var angular_z: bool = false:
	set(value):
		if d3: d3.axis_lock_angular_z = value
		angular_z = value
	get():
		return angular_z

#endregion

func _ready() -> void:
	start_y = position.y
	if tile_size == 0:
		self.set_y_sort_enabled(true)
		self.set_z_as_relative(false)
		tile_size = 16
	_expand()
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if not d3: _expand()
		
		if self.position.x != d3.position.x * tile_size:
			d3.position.x = self.position.x / tile_size
		if self.position.y != (d3.position.z - d3.position.y) * tile_size:
			d3.position.z = (self.position.y / tile_size) + d3.position.y
	elif not Engine.is_editor_hint():
		if daicon_parent and not d3.get_collision_exceptions().has(daicon_parent.d3):
			var distance := d3.position.distance_to(daicon_parent.d3.global_position - daicon_parent.offset_3d)
			_update_modulation(distance)
			d3.add_collision_exception_with(daicon_parent.d3)
func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if daicon_parent and daicon_parent.d3:
			var distance := d3.position.distance_to(daicon_parent.d3.global_position - daicon_parent.offset_3d)
			
			if stream_mode:
				#direct
				_update_direct_position(distance)
			elif not stream_mode:
				#logic
				_update_position(distance, delta)

func _update_modulation(distance):
	if shadow_mode:
		#coloration
		if distance > min_distance:
			self.modulate.a = _initial_alpha
		else:
			self.modulate.a = lerp(0.0, _initial_alpha, distance / min_distance)
	elif not shadow_mode:
		#discoloration
		if distance > min_distance:
			self.modulate.a = lerp(0.0, _initial_alpha, min_distance / distance)
		else:
			self.modulate.a = _initial_alpha
func _update_position(distance, delta):
	if daicon_parent.d3.is_on_floor():
		self.visible = true
		_update_modulation(distance)
		
		self.position.y = start_y
		d3.position = daicon_parent.d3.position - daicon_parent.offset_3d
		self.z_index = (round(d3.position.y + 0.3) * z_step) + 1
	else:
		if distance < max_distance:
			d3.velocity.y -= GRAVITY * delta
		else:
			self.visible = false
			d3.position = daicon_parent.d3.position - daicon_parent.offset_3d
		
		if d3.is_on_floor():
			self.visible = true
			_update_modulation(distance)
			self.position.y = start_y + (distance * tile_size)
			self.z_index = (round(d3.position.y + 0.3) * z_step) + 1
			d3.position = daicon_parent.d3.position - daicon_parent.offset_3d
	d3.move_and_slide()
func _update_direct_position(distance):
	if distance < max_distance:
		d3.velocity.y = -GRAVITY
	else:
		self.visible = false
		d3.position = daicon_parent.d3.position - daicon_parent.offset_3d
	
	if d3.is_on_floor():
		self.visible = true
		_update_modulation(distance)
		self.position.y = start_y + (distance * tile_size)
		self.z_index = (round(d3.position.y + 0.3) * z_step) + 1
		d3.position = daicon_parent.d3.position - daicon_parent.offset_3d
	d3.move_and_slide()

func _validate_property(property: Dictionary) -> void:
	if not d3: return
	
	#motion mode
	if property.name in grounded_properties:
		if motion_mode_3d == 0:
			property.usage |= PROPERTY_USAGE_EDITOR
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name in floating_properties:
		if motion_mode_3d == 1:
			property.usage |= PROPERTY_USAGE_EDITOR

#region Expand

func _expand() -> void:
	_expand_d3()
	if shape_properties:
		_expand_shape()

func _expand_d3() -> void:
	d3 = CharacterBody3D.new()
	d3.set_name("KinematicBody3D")
	add_child(d3)
	move_child(d3, 0)
	d3 = get_child(0)
	
	d3.motion_mode = motion_mode_3d
	d3.up_direction = up_direction_3d
	d3.slide_on_ceiling = slide_and_ceiling_3d
	d3.wall_min_slide_angle = wall_min_slide_ang
	
	d3.floor_stop_on_slope = stop_on_slope_3d
	d3.floor_constant_speed = constant_speed_3d
	d3.floor_block_on_wall = block_on_wall_3d
	d3.floor_max_angle = max_angle_3d
	d3.floor_snap_length = snap_length_3d
	
	d3.platform_on_leave = on_leave
	d3.platform_floor_layers = floor_layers
	d3.platform_wall_layers = wall_layers
	
	d3.safe_margin = safe_margin_3d
	
	d3.axis_lock_linear_x = linear_x
	d3.axis_lock_linear_y = linear_y
	d3.axis_lock_linear_z = linear_z
	d3.axis_lock_angular_x = angular_x
	d3.axis_lock_angular_y = angular_y
	d3.axis_lock_angular_z = angular_z
	
	d3.disable_mode = disable_mode_3d
	d3.collision_layer = layer
	d3.collision_mask = mask
	d3.collision_priority = priority
	
	d3.input_ray_pickable = ray_pickable
	d3.input_capture_on_drag = capture_on_drag
func _expand_shape() -> void:
	if len(shape_properties) == 11:
		var _shape = CollisionShape3D.new()
		_shape.set_name(shape_properties.Name)
		d3.add_child(_shape)
		
		_shape.shape = shape_properties["Shape"]
		_shape.disabled = shape_properties["Disabled"]
		
		_shape.position = shape_properties["Position"]
		_shape.rotation = shape_properties["Rotation"]
		_shape.scale = shape_properties["Scale"]
		_shape.quaternion = shape_properties["Quaternion"]
		_shape.basis = shape_properties["Basis"]
		
		_shape.rotation_edit_mode = shape_properties["RotationEditMode"]
		_shape.rotation_order = shape_properties["RotationOrder"]
		_shape.top_level = shape_properties["TopLevel"]
	else:
		var _shape = CollisionPolygon3D.new()
		_shape.set_name(shape_properties.Name)
		d3.add_child(_shape)
		
		_shape.depth = shape_properties["Depth"]
		_shape.disabled = shape_properties["Disabled"]
		_shape.polygon = shape_properties["Polygon"]
		_shape.margin = shape_properties["Margin"]
		
		_shape.position = shape_properties["Position"]
		_shape.rotation = shape_properties["Rotation"]
		_shape.scale = shape_properties["Scale"]
		_shape.quaternion = shape_properties["Quaternion"]
		_shape.basis = shape_properties["Basis"]
		
		_shape.rotation_edit_mode = shape_properties["RotationEditMode"]
		_shape.rotation_order = shape_properties["RotationOrder"]
		_shape.top_level = shape_properties["TopLevel"]

#endregion
