#example/code/shadow_example_body.gd
@tool
extends KinematicDaicon

const SPEED = 5
const JUMP_VELOCITY = 5
const gravity = 10
const accelaration = 20

var movement_input := Vector2.ZERO

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		var body := core as CharacterBody3D
		if not body: return
		
		movement_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := Vector3(movement_input.x, 0, movement_input.y).normalized()
		
		var y_vel = body.velocity.y
		body.velocity = body.velocity.move_toward(direction * SPEED, accelaration * delta)
		body.velocity.y = y_vel - gravity * delta
		
		if Input.is_action_just_pressed("ui_accept") and body.is_on_floor(): body.velocity.y += JUMP_VELOCITY
		
		body.move_and_slide()
		update_pos()

func _validate_property(property: Dictionary) -> void:
	super._validate_property(property)
