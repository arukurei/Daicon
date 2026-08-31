extends Daicon

var position_array: Array[Vector2] = []

func _ready() -> void:
	super._ready()

func _physics_process(_delta: float) -> void:
	shader_target_nodes.sort_custom(func(a, b): return a.z_index < b.z_index)
	shader_trigger_nodes.sort_custom(func(a, b): return a.z_index < b.z_index)
	
	for shader_target in shader_target_nodes:
		if not is_instance_valid(shader_target): continue
		
		var mat: ShaderMaterial = shader_target.material as ShaderMaterial
		if not mat: continue
		
		position_array.clear()
		
		for shader_trigger in shader_trigger_nodes:
			if not is_instance_valid(shader_trigger): continue
			
			var cast = shader_trigger.shader_cast
			if cast and cast.is_colliding() and shader_target.z_index >= shader_trigger.z_index:
				var screen_pos: Vector2 = shader_trigger.get_global_transform_with_canvas().origin
				position_array.append(screen_pos)
		
		mat.set_shader_parameter("CircleCentres", position_array)
		mat.set_shader_parameter("NumCircleCentres", position_array.size())
