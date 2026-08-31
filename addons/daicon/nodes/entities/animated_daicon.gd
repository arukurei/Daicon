@tool
@icon("res://addons/daicon/icons/animated_daicon.svg")
class_name AnimatedDaicon extends DaiconEntity


#region Animatable Specific Exports
@export var sync_to_physics_3d: bool = true:
	set(value):
		if core: (core as AnimatableBody3D).sync_to_physics = value
		sync_to_physics_3d = value
	get(): return sync_to_physics_3d

@export var physics_material_override_3d: PhysicsMaterial:
	set(material):
		if core: (core as AnimatableBody3D).physics_material_override = material
		physics_material_override_3d = material
	get(): return physics_material_override_3d

@export_custom(PROPERTY_HINT_NONE, "suffix:m/s") var constant_linear_velocity_3d: Vector3 = Vector3.ZERO:
	set(v_3):
		if core: (core as AnimatableBody3D).constant_linear_velocity = v_3
		constant_linear_velocity_3d = v_3
	get(): return constant_linear_velocity_3d

@export_custom(PROPERTY_HINT_NONE, "suffix:°/s") var constant_angular_velocity_3d: Vector3 = Vector3.ZERO:
	set(v_3):
		if core: (core as AnimatableBody3D).constant_angular_velocity = v_3
		constant_angular_velocity_3d = v_3
	get(): return constant_angular_velocity_3d
#endregion


func _create_core() -> CollisionObject3D:
	var body = AnimatableBody3D.new()
	body.name = "AnimatableBody3D"
	body.sync_to_physics = sync_to_physics_3d
	body.physics_material_override = physics_material_override_3d
	body.constant_linear_velocity = constant_linear_velocity_3d
	body.constant_angular_velocity = constant_angular_velocity_3d
	return body

func _process(delta: float) -> void:
	super._process(delta)
	if not Engine.is_editor_hint(): update_pos()
