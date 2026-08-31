@tool
@icon("res://addons/daicon/icons/kinematic_daicon.svg")
class_name KinematicDaicon extends DaiconEntity


#region Kinematic Specific Exports
@export_enum("Grounded", "Floating") var motion_mode_3d: int = 0:
	set(mode):
		if core: (core as CharacterBody3D).motion_mode = mode
		motion_mode_3d = mode
		notify_property_list_changed()
	get(): return motion_mode_3d

@export var up_direction_3d: Vector3 = Vector3(0, 1, 0):
	set(v_3):
		if core: (core as CharacterBody3D).up_direction = v_3
		up_direction_3d = v_3
	get(): return up_direction_3d

@export var slide_and_ceiling_3d: bool = true:
	set(value):
		if core: (core as CharacterBody3D).slide_on_ceiling = value
		slide_and_ceiling_3d = value
	get(): return slide_and_ceiling_3d

@export_range(0, 180, 0.1, "radians_as_degrees") var wall_min_slide_ang: float = 0.261799:
	set(angle):
		if core: (core as CharacterBody3D).wall_min_slide_angle = angle
		wall_min_slide_ang = angle
	get(): return wall_min_slide_ang

@export_group("Floor 3D")
@export var stop_on_slope_3d: bool = true:
	set(value):
		if core: (core as CharacterBody3D).floor_stop_on_slope = value
		stop_on_slope_3d = value
	get(): return stop_on_slope_3d

@export var constant_speed_3d: bool = false:
	set(value):
		if core: (core as CharacterBody3D).floor_constant_speed = value
		constant_speed_3d = value
	get(): return constant_speed_3d

@export var block_on_wall_3d: bool = true:
	set(value):
		if core: (core as CharacterBody3D).floor_block_on_wall = value
		block_on_wall_3d = value
	get(): return block_on_wall_3d

@export_range(0, 180, 0.1, "radians_as_degrees") var max_angle_3d: float = 0.785398:
	set(angle):
		if core: (core as CharacterBody3D).floor_max_angle = angle
		max_angle_3d = angle
	get(): return max_angle_3d

@export_range(0, 1, 0.01, "or_greater", "suffix:m") var snap_length_3d: float = 0.1:
	set(angle):
		if core: (core as CharacterBody3D).floor_snap_length = angle
		snap_length_3d = angle
	get(): return snap_length_3d

const grounded_properties: Array[StringName] = [
	&"up_direction_3d", &"slide_and_ceiling_3d", &"wall_min_slide_ang",
	&"Floor 3D", &"stop_on_slope_3d", &"constant_speed_3d",
	&"block_on_wall_3d", &"max_angle_3d", &"snap_length_3d"
	]
const floating_properties: Array[StringName] = [&"wall_min_slide_ang"]

@export_group("Moving Platform 3D")
@export_enum("Add Velocity", "Add Upward Velocity", "Do Nothing") var on_leave: int = 0:
	set(mode):
		if core: (core as CharacterBody3D).platform_on_leave = mode
		on_leave = mode
	get(): return on_leave

@export_flags_3d_physics var floor_layers: int = 0xFFFFFFFF:
	set(layer_flag):
		if core: (core as CharacterBody3D).platform_floor_layers = layer_flag
		floor_layers = layer_flag
	get(): return floor_layers

@export_flags_3d_physics var wall_layers: int = 0:
	set(layer_flag):
		if core: (core as CharacterBody3D).platform_wall_layers = layer_flag
		wall_layers = layer_flag
	get(): return wall_layers

@export_group("Collision")
@export_range(0.001, 256, 0.001, "suffix:m") var safe_margin_3d: float = 0.001:
	set(margin):
		if core: (core as CharacterBody3D).safe_margin = margin
		safe_margin_3d = margin
	get(): return safe_margin_3d
#endregion


func _create_core() -> CollisionObject3D:
	var body = CharacterBody3D.new()
	body.name = "KinematicBody3D"
	body.motion_mode = motion_mode_3d
	body.up_direction = up_direction_3d
	body.slide_on_ceiling = slide_and_ceiling_3d
	body.wall_min_slide_angle = wall_min_slide_ang
	body.floor_stop_on_slope = stop_on_slope_3d
	body.floor_constant_speed = constant_speed_3d
	body.floor_block_on_wall = block_on_wall_3d
	body.floor_max_angle = max_angle_3d
	body.floor_snap_length = snap_length_3d
	body.platform_on_leave = on_leave
	body.platform_floor_layers = floor_layers
	body.platform_wall_layers = wall_layers
	body.safe_margin = safe_margin_3d
	return body

func _validate_property(property: Dictionary) -> void:
	super._validate_property(property)
	if not core: return
	if property.name in grounded_properties:
		if motion_mode_3d == 0: property.usage |= PROPERTY_USAGE_EDITOR
		else: property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name in floating_properties and motion_mode_3d == 1: property.usage |= PROPERTY_USAGE_EDITOR
