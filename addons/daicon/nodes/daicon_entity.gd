#addons/daicon/nodes/daicon_entity_node.gd
@tool
@icon("res://addons/daicon/icons/daicon.svg")
class_name DaiconEntity extends Node2D

const MESH := "mesh"
const SHAPE := "shape"
const WHISKER := "whisker"
const WHISKER_SHAPE := "whisker_shape"
const SHADER_CAST := "shader_cast"

var core: Node3D

var mesh: MeshInstance3D
var shape: Node3D
var whisker: Area3D
var whisker_shape: Node3D
var shader_cast: RayCast3D

#region Transform & Projection Exports
## Tile Size determines how many pixels equal 1 meter in 3D.
@export var tile_size: int = 16:
	set(size):
		if size > 0: tile_size = size
	get(): return tile_size

## Third-axis position.
@export var y_3d: float = 0.0:
	set(value):
		if core:
			core.position.y = value + offset_3d.y
			position.y = ((core.position.z - offset_3d.z) - (core.position.y - offset_3d.y)) * tile_size
		y_3d = value
	get(): return y_3d

## Z-step in sortable system between height levels.
@export var z_step: int = 10:
	set(step): z_step = step
	get(): return z_step

## Object max 3D height in blocks (meters). Used in sortable system as coef.
@export var z_sort_coef: float = 1.0:
	set(coef): z_sort_coef = coef
	get(): return z_sort_coef
#endregion


#region Transform 3D Exports
@export_group("Transform 3D")
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var offset_3d: Vector3 = Vector3(0, 0.5, 0):
	set(v_3):
		if core: core.position += v_3 - offset_3d
		offset_3d = v_3
	get(): return offset_3d

@export_custom(PROPERTY_HINT_RANGE, "-360,360,0.1,or_less,or_greater,radians") var rotation_3d: Vector3 = Vector3.ZERO:
	set(v_3):
		if core: core.rotation = v_3
		rotation_3d = v_3
	get(): return rotation_3d

@export_custom(PROPERTY_HINT_LINK, "") var scale_3d: Vector3 = Vector3.ONE:
	set(v_3):
		if core: core.scale = v_3
		scale_3d = v_3
	get(): return scale_3d

@export var quaternion_3d: Quaternion = Quaternion(0, 0, 0, 1.0):
	set(quat):
		if core: core.quaternion = quat
		quaternion_3d = quat
	get(): return quaternion_3d

@export var basis_3d: Basis:
	set(bas):
		if core: core.basis = bas
		basis_3d = bas
	get(): return basis_3d

@export_enum("Euler", "Quaternion", "Basis") var rotation_edit_mode_3d: int = 0:
	set(mode):
		if core:
			core.rotation_edit_mode = mode
			if mode == 0: core.rotation = rotation_3d
			elif mode == 1: core.quaternion = quaternion_3d
			elif mode == 2: core.basis = basis_3d
		rotation_edit_mode_3d = mode
		notify_property_list_changed()
	get(): return rotation_edit_mode_3d

@export var rotation_order_3d: EulerOrder = 2:
	set(order):
		if core: core.rotation_order = order
		rotation_order_3d = order
	get():
		return rotation_order_3d

@export var top_level_3d: bool = false:
	set(value):
		if core: core.top_level = value
		top_level_3d = value
	get():
		return top_level_3d

@export var visible_3d: bool = true:
	set(value):
		if core: core.visible = value
		visible_3d = value
	get(): return visible_3d

const euler_properties: Array[StringName] = [&"quaternion_3d", &"basis_3d"]
const quaternion_properties: Array[StringName] = [&"rotation_3d", &"basis_3d", &"rotation_order_3d"]
const basis_properties: Array[StringName] = [&"rotation_3d", &"scale_3d", &"quaternion_3d", &"rotation_order_3d"]
#endregion


#region Node3D Base Exports
@export_enum("Remove", "Make Static", "Keep Active") var disable_mode_3d: int = 0:
	set(mode):
		if core: core.disable_mode = mode
		disable_mode_3d = mode
	get(): return disable_mode_3d

@export_group("Collision")
@export_flags_3d_physics var layer: int = 1:
	set(collision_layer):
		if core: core.collision_layer = collision_layer
		layer = collision_layer
	get(): return layer

@export_flags_3d_navigation var mask: int = 1:
	set(collision_mask):
		if core: core.collision_mask = collision_mask
		mask = collision_mask
	get(): return mask

@export var priority: float = 1.0:
	set(value):
		if core: core.collision_priority = value
		priority = value
	get(): return priority

@export_group("Input")
@export var ray_pickable: bool = true:
	set(value):
		if core: core.input_ray_pickable = value
		ray_pickable = value
	get(): return ray_pickable

@export var capture_on_drag: bool = false:
	set(value):
		if core: core.input_capture_on_drag = value
		capture_on_drag = value
	get(): return capture_on_drag

@export_group("Axis Lock")
@export var linear_x: bool = false:
	set(value):
		if core: core.axis_lock_linear_x = value
		linear_x = value
	get(): return linear_x

@export var linear_y: bool = false:
	set(value):
		if core: core.axis_lock_linear_y = value
		linear_y = value
	get(): return linear_y

@export var linear_z: bool = false:
	set(value):
		if core: core.axis_lock_linear_z = value
		linear_z = value
	get(): return linear_z

@export var angular_x: bool = false:
	set(value):
		if core: core.axis_lock_angular_x = value
		angular_x = value
	get(): return angular_x

@export var angular_y: bool = false:
	set(value):
		if core: core.axis_lock_angular_y = value
		angular_y = value
	get(): return angular_y

@export var angular_z: bool = false:
	set(value):
		if core: core.axis_lock_angular_z = value
		angular_z = value
	get(): return angular_z
#endregion


#region Exports: Slots
@export_group("Slots")
@export var mesh_node: MeshInstance3D:
	set(node): _update_slot(node, "mesh_properties", MESH)
	get(): return _get_slot(MESH, mesh_properties)
@export_storage var mesh_properties: Dictionary

@export var shape_node: Node3D:
	set(node): _update_slot(node, "shape_properties", SHAPE)
	get(): return _get_slot(SHAPE, shape_properties)
@export_storage var shape_properties: Dictionary

@export var whisker_node: Area3D:
	set(node): _update_slot(node, "whisker_properties", WHISKER)
	get(): return _get_slot(WHISKER, whisker_properties)
@export_storage var whisker_properties: Dictionary

@export var whisker_shape_node: Node3D:
	set(node): _update_slot(node, "whisker_shape_properties", WHISKER_SHAPE)
	get(): return _get_slot(WHISKER_SHAPE, whisker_shape_properties)
@export_storage var whisker_shape_properties: Dictionary

@export var shader_cast_node: RayCast3D:
	set(node): _update_slot(node, "shader_cast_properties", SHADER_CAST)
	get(): return _get_slot(SHADER_CAST, shader_cast_properties)
@export_storage var shader_cast_properties: Dictionary

## Dynamic custom slots (holds any 3D node serialized tree)
@export_storage var custom_slots: Array[Dictionary] = []
#endregion


#region Lifecycle & Position Sync
func _ready() -> void:
	if tile_size <= 0: tile_size = 16
	self.set_y_sort_enabled(true)
	self.z_index = 1
	_expand()
	if core: core.set_meta("z_index", self.z_index)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if not core: _expand()
		if position.x != (core.position.x - offset_3d.x) * tile_size: core.position.x = (position.x / tile_size) + offset_3d.x
		if position.y != ((core.position.z - offset_3d.z) - (core.position.y - offset_3d.y)) * tile_size: core.position.z = ((position.y / tile_size) + (core.position.y - offset_3d.y)) + offset_3d.z


func update_pos(coef: float = 0.0) -> void:
	if coef == 0.0:  coef = z_sort_coef
	
	position.x = (core.position.x - offset_3d.x) * tile_size
	position.y = ((core.position.z - offset_3d.z) - (core.position.y - offset_3d.y)) * tile_size
	
	if whisker and whisker.get_overlapping_bodies():
		var bodies = whisker.get_overlapping_bodies()
		if not bodies.is_empty():
			var first_body = bodies[0]
			if first_body.has_meta("z_index"):
				z_index = first_body.get_meta("z_index") - 1
			else:
				var snapped_y := snappedf(core.position.y, 0.01)
				z_index = int(snapped_y + (offset_3d.y * 1.1)) * z_step - 1
	else:
		var snapped_local_y := snappedf(core.position.y - offset_3d.y, 0.01)
		z_index = int((snapped_local_y + coef) * z_step + 2)
	
	core.set_meta("z_index", z_index)


func _validate_property(property: Dictionary) -> void:
	if not core: return
	if property.name in quaternion_properties and rotation_edit_mode_3d == 1: property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name in euler_properties and rotation_edit_mode_3d == 0: property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name in basis_properties and rotation_edit_mode_3d == 2: property.usage &= ~PROPERTY_USAGE_EDITOR
#endregion


#region Slot Management
func _update_slot(input_node: Node, storage_name: String, slot_name: String) -> void:
	var current_node = get(slot_name)
	if input_node == current_node: return
	if input_node and core and core.is_ancestor_of(input_node): return
	_init_core()
	_eject_current_slot(current_node, storage_name, slot_name)
	_inject_new_slot(input_node, storage_name, slot_name)


func _eject_current_slot(current_node: Node, storage_name: String, slot_name: String) -> void:
	var stored_properties: Dictionary = get(storage_name)
	if not stored_properties.is_empty():
		if current_node and is_instance_valid(current_node):
			current_node.name = "_freed_" + str(current_node.get_instance_id())
			if slot_name == WHISKER and whisker_shape and is_instance_valid(whisker_shape): whisker_shape.reparent(core, false)
			current_node.queue_free()
			set(slot_name, null)
		
		DaiconSlots.expand_slot(stored_properties, self)
		set(storage_name, {})


func _inject_new_slot(input_node: Node, storage_name: String, slot_name: String) -> void:
	if not input_node or not core: return
	
	var new_properties := DaiconSlots.serialize_node(input_node, true)
	set(storage_name, new_properties)
	
	var target_parent: Node = core
	if slot_name == WHISKER_SHAPE and is_instance_valid(whisker) and whisker.is_inside_tree():  target_parent = whisker
	
	var new_node := DaiconSlots.expand_slot(new_properties, target_parent)
	if not new_node: return
	
	set(slot_name, new_node)
	
	if slot_name == WHISKER and is_instance_valid(whisker_shape) and whisker_shape.is_inside_tree():
		if whisker_shape.get_parent() != new_node: 
			DaiconSlots.safe_reparent(whisker_shape, new_node)
	
	input_node.queue_free()


func _expand_slot(properties: Dictionary, node_name: String, parent: Node) -> void:
	var node := DaiconSlots.expand_slot(properties, parent)
	if node: set(node_name, node)


func _get_slot(node_name: String, properties: Dictionary) -> Node:
	var slot = get(node_name)
	if slot and is_instance_valid(slot): return slot
	if core and properties.has("Name"):
		var found_slot = core.find_child(properties["Name"], true, false)
		if found_slot:
			set(node_name, found_slot)
			return found_slot
	return null
#endregion


#region Core Setup & Expand
func _create_core() -> Node3D: return Node3D.new()


func _init_core() -> void:
	if core and is_instance_valid(core): return
	core = _create_core()
	add_child(core)
	move_child(core, 0)
	core = get_child(0)
	
	core.disable_mode = disable_mode_3d
	core.collision_layer = layer
	core.collision_mask = mask
	core.collision_priority = priority
	
	core.input_ray_pickable = ray_pickable
	core.input_capture_on_drag = capture_on_drag
	
	core.axis_lock_linear_x = linear_x
	core.axis_lock_linear_y = linear_y
	core.axis_lock_linear_z = linear_z
	core.axis_lock_angular_x = angular_x
	core.axis_lock_angular_y = angular_y
	core.axis_lock_angular_z = angular_z
	
	core.position.y = y_3d + offset_3d.y
	core.position.x = (position.x / tile_size) + offset_3d.x
	core.position.z = ((position.y / tile_size) + (core.position.y - offset_3d.y)) + offset_3d.z
	core.scale = scale_3d
	
	if rotation_edit_mode_3d == 0:   core.rotation = rotation_3d
	elif rotation_edit_mode_3d == 1: core.quaternion = quaternion_3d
	elif rotation_edit_mode_3d == 2: core.basis = basis_3d
	
	core.rotation_edit_mode = rotation_edit_mode_3d
	core.top_level = top_level_3d
	core.visible = visible_3d


func _expand() -> void:
	_init_core()
	if not mesh_properties.is_empty(): _expand_slot(mesh_properties, MESH, core)
	if not shape_properties.is_empty(): _expand_slot(shape_properties, SHAPE, core)
	if not whisker_properties.is_empty(): _expand_slot(whisker_properties, WHISKER, core)
	if not whisker_shape_properties.is_empty():
		var target = whisker if is_instance_valid(whisker) else core
		_expand_slot(whisker_shape_properties, WHISKER_SHAPE, target)
	if not shader_cast_properties.is_empty(): _expand_slot(shader_cast_properties, SHADER_CAST, core)
	
	for slot_dict in custom_slots:
		if not slot_dict.is_empty(): DaiconSlots.expand_slot(slot_dict, core)
#endregion


#region Utility
## Walks up the parent chain and returns the first DaiconEntity ancestor, or null.
static func find_parent_entity(node: Node) -> DaiconEntity:
	var curr: Node = node.get_parent()
	while curr:
		if curr is DaiconEntity: return curr as DaiconEntity
		curr = curr.get_parent()
	return null
#endregion
