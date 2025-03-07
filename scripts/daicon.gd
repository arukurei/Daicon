extends Daicon

var PositionArray : Array[Vector2] = []

func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	shader_target_nodes.sort_custom(func(a, b): return a.z_index < b.z_index)
	for shader_target in shader_target_nodes:
		PositionArray.clear()
		shader_trigger_nodes.sort_custom(func(a, b): return a.z_index < b.z_index)
		for shader_trigger in shader_trigger_nodes:
			if shader_trigger.shader_cast.is_colliding() and shader_target.z_index >= shader_trigger.z_index:
				PositionArray.append(get_viewport().get_final_transform() * shader_trigger.get_global_transform_with_canvas() * Vector2(0,0))
		shader_target.material.set_shader_parameter("CircleCentres", PositionArray)
		shader_target.material.set_shader_parameter("NumCircleCentres", PositionArray.size())
