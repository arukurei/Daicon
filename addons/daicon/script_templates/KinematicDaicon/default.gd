@tool
extends KinematicDaicon

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		#var body := core as CharacterBody3D
		#LOGIC
	
		#LOGIC END
	
		#body.move_and_slide()
		#update_pos()
		pass

func _validate_property(property: Dictionary) -> void:
	super._validate_property(property)
