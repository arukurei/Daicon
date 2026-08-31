@tool
@icon("res://addons/daicon/icons/rigid_daicon.svg")
class_name RigidDaicon extends DaiconEntity


#region Rigid Specific Exports
@export_custom(PROPERTY_HINT_RANGE, "0.001,1000,or_greater,suffix:kg,exp") var mass: float = 1.0:
	set(value):
		if core: (core as RigidBody3D).mass = value
		mass = value
	get(): return mass

@export var physics_material_override: PhysicsMaterial:
	set(material):
		if core: (core as RigidBody3D).physics_material_override = material
		physics_material_override = material
	get(): return physics_material_override

@export_custom(PROPERTY_HINT_RANGE, "-8.0,8.0,or_less,or_greater,exp") var gravity_scale: float = 1.0:
	set(value):
		if core: (core as RigidBody3D).gravity_scale = value
		gravity_scale = value
	get(): return gravity_scale

@export_group("Mass Distribution")
@export_enum("Auto", "Custom") var center_of_mass_mode: int = 0:
	set(mode):
		if mode == 0: center_of_mass = Vector3.ZERO
		if core: (core as RigidBody3D).center_of_mass_mode = mode
		center_of_mass_mode = mode
		notify_property_list_changed()
	get(): return center_of_mass_mode

@export_custom(PROPERTY_HINT_RANGE, "-10,10,0.01,or_less,or_greater,suffix:m") var center_of_mass: Vector3 = Vector3.ZERO:
	set(v_3):
		if center_of_mass_mode == 1:
			if core: (core as RigidBody3D).center_of_mass = v_3
			center_of_mass = v_3
	get(): return center_of_mass

@export_custom(PROPERTY_HINT_RANGE, "0,1000,or_greater,suffix:kg · m^2") var inertia: Vector3 = Vector3.ZERO:
	set(v_3):
		if v_3.x >= 0 and v_3.y >= 0 and v_3.z >= 0:
			if core: (core as RigidBody3D).inertia = v_3
			inertia = v_3
	get(): return inertia

@export_group("Deactivation")
@export var sleeping: bool = false:
	set(value):
		if core: (core as RigidBody3D).sleeping = value
		sleeping = value
	get(): return sleeping

@export var can_sleep: bool = true:
	set(value):
		if core: (core as RigidBody3D).can_sleep = value
		can_sleep = value
	get(): return can_sleep

@export var lock_rotation: bool = false:
	set(value):
		if core: (core as RigidBody3D).lock_rotation = value
		lock_rotation = value
	get(): return lock_rotation

@export var freeze: bool = false:
	set(value):
		if core: (core as RigidBody3D).freeze = value
		freeze = value
	get(): return freeze

@export_enum("Static", "Kinematic") var freeze_mode: int = 0:
	set(mode):
		if core: (core as RigidBody3D).freeze_mode = mode
		freeze_mode = mode
	get(): return freeze_mode

@export_group("Solver")
@export var custom_integrator: bool = false:
	set(value):
		if core: (core as RigidBody3D).custom_integrator = value
		custom_integrator = value
	get(): return custom_integrator

@export var continuous_cd: bool = false:
	set(value):
		if core: (core as RigidBody3D).continuous_cd = value
		continuous_cd = value
	get(): return continuous_cd

@export var contact_monitor: bool = false:
	set(value):
		if core: (core as RigidBody3D).contact_monitor = value
		contact_monitor = value
		notify_property_list_changed()
	get(): return contact_monitor

@export var max_contacts_reported: int = 0:
	set(value):
		if core: (core as RigidBody3D).max_contacts_reported = value
		max_contacts_reported = value
	get(): return max_contacts_reported

@export_group("Linear")
@export_custom(PROPERTY_HINT_NONE, "0,1000,or_less,or_greater,suffix:m/s") var linear_velocity: Vector3 = Vector3.ZERO:
	set(v_3):
		if core: (core as RigidBody3D).linear_velocity = v_3
		linear_velocity = v_3
	get(): return linear_velocity

@export_enum("Combine", "Replace") var linear_damp_mode: int = 0:
	set(mode):
		if core: (core as RigidBody3D).linear_damp_mode = mode
		linear_damp_mode = mode
	get(): return linear_damp_mode

@export_custom(PROPERTY_HINT_RANGE, "0,100,or_greater") var linear_damp: float = 0.0:
	set(value):
		if core: (core as RigidBody3D).linear_damp = value
		linear_damp = value
	get(): return linear_damp

@export_group("Angular")
@export_custom(PROPERTY_HINT_NONE, "0,1000,or_less,or_greater,suffix:°/s") var angular_velocity: Vector3 = Vector3.ZERO:
	set(v_3):
		if core: (core as RigidBody3D).angular_velocity = v_3
		angular_velocity = v_3
	get(): return angular_velocity

@export_enum("Combine", "Replace") var angular_damp_mode: int = 0:
	set(mode):
		if core: (core as RigidBody3D).angular_damp_mode = mode
		angular_damp_mode = mode
	get(): return angular_damp_mode

@export_custom(PROPERTY_HINT_RANGE, "0,100,or_greater") var angular_damp: float = 0.0:
	set(value):
		if core: (core as RigidBody3D).angular_damp = value
		angular_damp = value
	get(): return angular_damp

@export_group("Constant Forces")
@export_custom(PROPERTY_HINT_NONE, "0,1000,or_less,or_greater,suffix:kg · m^2/s") var constant_force: Vector3 = Vector3.ZERO:
	set(v_3):
		if core: (core as RigidBody3D).constant_force = v_3
		constant_force = v_3
	get(): return constant_force

@export_custom(PROPERTY_HINT_NONE, "0,1000,or_less,or_greater,suffix:kg · m^2/s") var constant_torque: Vector3 = Vector3.ZERO:
	set(v_3):
		if core: (core as RigidBody3D).constant_torque = v_3
		constant_torque = v_3
	get(): return constant_torque
#endregion

func _create_core() -> CollisionObject3D:
	var body = RigidBody3D.new()
	body.name = "RigidBody3D"
	body.mass = mass
	body.physics_material_override = physics_material_override
	body.gravity_scale = gravity_scale
	body.center_of_mass_mode = center_of_mass_mode
	body.inertia = inertia
	body.sleeping = sleeping
	body.can_sleep = can_sleep
	body.lock_rotation = lock_rotation
	body.freeze = freeze
	body.freeze_mode = freeze_mode
	body.custom_integrator = custom_integrator
	body.continuous_cd = continuous_cd
	body.contact_monitor = contact_monitor
	body.max_contacts_reported = max_contacts_reported
	body.linear_velocity = linear_velocity
	body.linear_damp_mode = linear_damp_mode
	body.linear_damp = linear_damp
	body.angular_velocity = angular_velocity
	body.angular_damp_mode = angular_damp_mode
	body.angular_damp = angular_damp
	body.constant_force = constant_force
	body.constant_torque = constant_torque
	return body

func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint(): update_pos()

func _validate_property(property: Dictionary) -> void:
	super._validate_property(property)
	if not core: return
	if property.name == "center_of_mass":
		if center_of_mass_mode == 0: property.usage &= ~PROPERTY_USAGE_EDITOR
		elif center_of_mass_mode == 1: property.usage |= PROPERTY_USAGE_EDITOR
	if property.name == "max_contacts_reported":
		if contact_monitor: property.usage |= PROPERTY_USAGE_EDITOR
		else: property.usage &= ~PROPERTY_USAGE_EDITOR
