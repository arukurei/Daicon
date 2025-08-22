@tool
extends RigidDaicon

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if not Engine.is_editor_hint():
		#LOGIC
	
		#LOGIC END
		pass

func _validate_property(property: Dictionary) -> void:
	super._validate_property(property)
