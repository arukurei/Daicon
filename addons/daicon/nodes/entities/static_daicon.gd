@tool
@icon("res://addons/daicon/icons/static_daicon.svg")
class_name StaticDaicon extends DaiconEntity


#region Static Specific Exports
@export var physics_material_override_3d: PhysicsMaterial:
	set(material):
		if core: (core as StaticBody3D).physics_material_override = material
		physics_material_override_3d = material
	get(): return physics_material_override_3d

@export_custom(PROPERTY_HINT_NONE, "suffix:m/s") var constant_linear_velocity_3d: Vector3 = Vector3.ZERO:
	set(v_3):
		if core: (core as StaticBody3D).constant_linear_velocity = v_3
		constant_linear_velocity_3d = v_3
	get(): return constant_linear_velocity_3d

@export_custom(PROPERTY_HINT_NONE, "suffix:°/s") var constant_angular_velocity_3d: Vector3 = Vector3.ZERO:
	set(v_3):
		if core: (core as StaticBody3D).constant_angular_velocity = v_3
		constant_angular_velocity_3d = v_3
	get(): return constant_angular_velocity_3d
#endregion

func _create_core() -> CollisionObject3D:
	var body = StaticBody3D.new()
	body.name = "StaticBody3D"
	body.physics_material_override = physics_material_override_3d
	body.constant_linear_velocity = constant_linear_velocity_3d
	body.constant_angular_velocity = constant_angular_velocity_3d
	return body

func _process(delta: float) -> void:
	super._process(delta)
	if not Engine.is_editor_hint(): update_pos()
