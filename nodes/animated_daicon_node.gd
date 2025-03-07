@tool
@icon("res://addons/daicon/icons/animated_daicon.svg")
class_name AnimatedDaicon extends AnimatableBody2D

var d3 : StaticBody3D
var right_whisker : RayCast3D
var left_whisker : RayCast3D
var center_whisker : RayCast3D
var shader_cast : RayCast3D

#region StaticDaicon Exports

@export var tile_size : int:
	set(size):
		if size > 0:
			tile_size = size
		elif size == 0:
			pass
	get():
		return tile_size
@export var y_3d : int:
	set(value):
		if d3:
			d3.position.y = value
			self.position.y = d3.position.z * tile_size - d3.position.y * tile_size
		y_3d = value
	get():
		return y_3d

@export var mesh : MeshInstance3D:
	set(node): 
		if not d3: return
		if node:
			if mesh:
				mesh_properties = {}
			node.reparent(d3)
			d3.move_child(node, 0)
			node.position = Vector3(0, 0, 0) + mesh_and_shape_position
			node.rotation = Vector3(0, 0, 0) + mesh_and_shape_rotation
			node.scale = Vector3(0, 0, 0) + mesh_and_shape_scale
			mesh_properties = {
				"Name" : node.name,
				"Mesh" : node.mesh,
				"Skeleton" : node.skeleton,
				"Skin" : node.skin,
				"MaterialOverride" : node.material_override,
				"MaterialOverlay" : node.material_overlay,
				"Transparency" : node.transparency,
				"CastShadow" : node.cast_shadow,
				"ExtraCullMargin" : node.extra_cull_margin,
				"CustomAABB" : node.custom_aabb,
				"LODBais" : node.lod_bias,
				"IgnoreOcclusionCulling" : node.ignore_occlusion_culling,
				"GIMode" : node.gi_mode,
				"GILightmapScale" : node.gi_lightmap_scale,
				"VisibilityRangeBegin" : node.visibility_range_begin,
				"VisibilityRangeBeginMargin" : node.visibility_range_begin_margin,
				"VisibilityRangeEnd" : node.visibility_range_end,
				"VisibilityRangeEndMargin" : node.visibility_range_end_margin,
				"VisibilityRangeFadeMode" : node.visibility_range_fade_mode,
				"Layers" : node.layers,
				"SortingOffset" : node.sorting_offset,
				"SortingUseAABBCenter" : node.sorting_use_aabb_center,
				"Position" : node.position,
				"Rotation" : node.rotation,
				"Scale" : node.scale,
				"RotationEditMode" : node.rotation_edit_mode,
				"RotationOrder" : node.rotation_order,
				"TopLevel" : node.top_level}
		else:
			mesh_properties = {}
	get():
		if not mesh_properties: return
		return d3.get_node(str(mesh_properties.Name))
@export var shape : Node3D:
	set(node):
		if not d3: return
		if node:
			if node is CollisionShape3D:
				if shape:
					shape_properties = {}
				node.reparent(d3)
				d3.move_child(node, -1)
				node.position = Vector3(0, 0, 0) + mesh_and_shape_position
				node.rotation = Vector3(0, 0, 0) + mesh_and_shape_rotation
				node.scale = Vector3(0, 0, 0) + mesh_and_shape_scale
				shape_properties = {"Name" : node.name,
									"Shape" : node.shape,
									"Disabled" : node.disabled,
									"Position" : node.position,
									"Rotation" : node.rotation,
									"Scale" : node.scale,
									"RotationEditMode" : node.rotation_edit_mode,
									"RotationOrder" : node.rotation_order,
									"TopLevel" : node.top_level}
			elif node is CollisionPolygon3D:
				if shape:
					shape_properties = {}
				node.reparent(d3)
				d3.move_child(node, -1)
				node.position = Vector3(0, 0, 0) + mesh_and_shape_position
				node.rotation = Vector3(0, 0, 0) + mesh_and_shape_rotation
				node.scale = Vector3(0, 0, 0) + mesh_and_shape_scale
				shape_properties = {"Name" : node.name,
									"Depth" : node.depth,
									"Disabled" : node.disabled,
									"Polygon" : node.polygon,
									"Margin" : node.margin,
									"Position" : node.position,
									"Rotation" : node.rotation,
									"Scale" : node.scale,
									"RotationEditMode" : node.rotation_edit_mode,
									"RotationOrder" : node.rotation_order,
									"TopLevel" : node.top_level}
		else:
			shape_properties = {}
	get():
		if not shape_properties: return
		return d3.get_node(str(shape_properties.Name))
@export_group("Mesh & Shape")
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var mesh_and_shape_position: Vector3 = Vector3(0, 0.5, 0):
	set(v_3):
		mesh_and_shape_position = v_3
	get():
		return mesh_and_shape_position
@export_custom(PROPERTY_HINT_RANGE, "-360,360,0.1,or_less,or_greater,radians") var mesh_and_shape_rotation: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		mesh_and_shape_rotation = v_3
	get():
		return mesh_and_shape_rotation
@export_custom(PROPERTY_HINT_LINK, "") var mesh_and_shape_scale: Vector3 = Vector3(1, 1, 1):
	set(v_3):
		mesh_and_shape_scale = v_3
	get():
		return mesh_and_shape_scale

@export_group("Slots")
@export var node_1 : Node:
	set(node):
		if not d3: return
		if node:
			if node_1:
				node_1_properties = {}
			var node_properties = get_node_properties(node)
			node.reparent(d3)
			d3.move_child(node, 0)
			node.position = Vector3(0, 0.5, 0)
			node_1_properties = node_properties
		else:
			node_1_properties = {}
	get():
		if not node_1_properties: return
		return d3.get_node(str(node_1_properties.Name))
@export var node_2 : Node:
	set(node):
		if not d3: return
		if node:
			if node_2:
				node_2_properties = {}
			var node_properties = get_node_properties(node)
			node.reparent(d3)
			d3.move_child(node, 0)
			node.position = Vector3(0, 0.5, 0)
			node_2_properties = node_properties
		else:
			node_2_properties = {}
	get():
		if not node_2_properties: return
		return d3.get_node(str(node_2_properties.Name))
@export var node_3 : Node:
	set(node):
		if not d3: return
		if node:
			if node_3:
				node_3_properties = {}
			var node_properties = get_node_properties(node)
			node.reparent(d3)
			d3.move_child(node, 0)
			node.position = Vector3(0, 0.5, 0)
			node_3_properties = node_properties
		else:
			node_3_properties = {}
	get():
		if not node_3_properties: return
		return d3.get_node(str(node_3_properties.Name))
@export var node_4 : Node:
	set(node):
		if not d3: return
		if node:
			if node_4:
				node_4_properties = {}
			var node_properties = get_node_properties(node)
			node.reparent(d3)
			d3.move_child(node, 0)
			node.position = Vector3(0, 0.5, 0)
			node_4_properties = node_properties
		else:
			node_4_properties = {}
	get():
		if not node_4_properties: return
		return d3.get_node(str(node_4_properties.Name))
@export var node_5 : Node:
	set(node):
		if not d3: return
		if node:
			if node_5:
				node_5_properties = {}
			var node_properties = get_node_properties(node)
			node.reparent(d3)
			d3.move_child(node, 0)
			node.position = Vector3(0, 0.5, 0)
			node_5_properties = node_properties
		else:
			node_5_properties = {}
	get():
		if not node_5_properties: return
		return d3.get_node(str(node_5_properties.Name))

@export_group("Core")
@export var child_count : int:
	set(count):
		pass
	get():
		if not d3: return 0
		return d3.get_child_count()
@export var mesh_properties : Dictionary:
	set(dict):
		if not dict and mesh:
			mesh.position = Vector3(0, 0, 0)
			mesh.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		mesh_properties = dict
	get():
		return mesh_properties
@export var shape_properties : Dictionary:
	set(dict):
		if not dict and shape:
			shape.position = Vector3(0, 0, 0)
			shape.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		shape_properties = dict
	get():
		return shape_properties
@export var node_1_properties : Dictionary:
	set(dict):
		if not dict and node_1:
			node_1.position = Vector3(0, 0, 0)
			node_1.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		node_1_properties = dict
	get():
		return node_1_properties
@export var node_2_properties : Dictionary:
	set(dict):
		if not dict and node_2:
			node_2.position = Vector3(0, 0, 0)
			node_2.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		node_2_properties = dict
	get():
		return node_2_properties
@export var node_3_properties : Dictionary:
	set(dict):
		if not dict and node_3:
			node_3.position = Vector3(0, 0, 0)
			node_3.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		node_3_properties = dict
	get():
		return node_3_properties
@export var node_4_properties : Dictionary:
	set(dict):
		if not dict and node_4:
			node_4.position = Vector3(0, 0, 0)
			node_4.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		node_4_properties = dict
	get():
		return node_4_properties
@export var node_5_properties : Dictionary:
	set(dict):
		if not dict and node_5:
			node_5.position = Vector3(0, 0, 0)
			node_5.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		node_5_properties = dict
	get():
		return node_5_properties

#endregion

#region Core Exports

@export_category("StaticBody3D")
@export var sync_to_physics_3d: bool = true:
	set(value):
		if d3: d3.sync_to_physics = value
		sync_to_physics_3d = value
	get():
		return sync_to_physics_3d
@export var physics_material_override_3d : PhysicsMaterial:
	set(material):
		pass
	get():
		return physics_material_override_3d
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s") var constant_linear_velocity_3d: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		if d3: d3.constant_linear_velocity = v_3
		constant_linear_velocity_3d = v_3
	get():
		return constant_linear_velocity_3d
@export_custom(PROPERTY_HINT_NONE, "suffix:°/s") var constant_angular_velocity_3d: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		if d3: d3.constant_angular_velocity = v_3
		constant_angular_velocity_3d = v_3
	get():
		return constant_angular_velocity_3d
@export_group("Transorm")
@export_custom(PROPERTY_HINT_RANGE, "-360,360,0.1,or_less,or_greater,radians") var rotation_3d: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		if d3: d3.rotation = v_3
		rotation_3d = v_3
	get():
		return rotation_3d
@export_custom(PROPERTY_HINT_LINK, "") var scale_3d: Vector3 = Vector3(1, 1, 1):
	set(v_3):
		if d3: d3.scale = v_3
		scale_3d = v_3
	get():
		return scale_3d

@export_category("CollisionObject3D")
@export_enum("Remove", "Make Static", "Keep Active") var disable_mode_3d = 0:
	set(mode):
		if d3: d3.disable_mode = mode
		disable_mode_3d = mode
	get():
		return disable_mode_3d
@export_group("Collision")
@export_flags_3d_physics var layer = 1:
	set(collision_layer):
		if d3: d3.collision_layer = collision_layer
		layer = collision_layer
	get():
		return layer
@export_flags_3d_navigation var mask = 1:
	set(collision_mask):
		if d3: d3.collision_mask = collision_mask
		mask = collision_mask
	get():
		return mask
@export var priority: float = 1:
	set(value):
		if d3: d3.collision_priority = value
		priority = value
	get():
		return priority
@export_group("Input")
@export var ray_pickable: bool = true: 
	set(value):
		if d3: d3.input_ray_pickable = value
		ray_pickable = value
	get():
		return ray_pickable
@export var capture_on_drag: bool: 
	set(value):
		if d3: d3.input_capture_on_drag = value
		capture_on_drag = value
	get():
		return capture_on_drag
@export_group("Axis Lock")
@export var linear_x: bool = false:
	set(value):
		if d3: d3.axis_lock_linear_x = value
		linear_x = value
	get():
		return linear_x
@export var linear_y: bool = false:
	set(value):
		if d3: d3.axis_lock_linear_y = value
		linear_y = value
	get():
		return linear_y
@export var linear_z: bool = false:
	set(value):
		if d3: d3.axis_lock_linear_z = value
		linear_z = value
	get():
		return linear_z
@export var angular_x: bool = false:
	set(value):
		if d3: d3.axis_lock_angular_x = value
		angular_x = value
	get():
		return angular_x
@export var angular_y: bool = false:
	set(value):
		if d3: d3.axis_lock_angular_y = value
		angular_y = value
	get():
		return angular_y
@export var angular_z: bool = false:
	set(value):
		if d3: d3.axis_lock_angular_z = value
		angular_z = value
	get():
		return angular_z

#endregion

#region RayCast Exports

@export_category("RayCast")
@export_group("Right Whisker")
@export var right_whisker_enabled: bool = true:
	set(value):
		if right_whisker: right_whisker.enabled = value
		right_whisker_enabled = value
	get():
		return right_whisker_enabled
@export var right_whisker_exclude_parent: bool = true:
	set(value):
		if right_whisker: right_whisker.exclude_parent = value
		right_whisker_exclude_parent = value
	get():
		return right_whisker_exclude_parent
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var right_whisker_target_position: Vector3 = Vector3(0, 0, 2):
	set(v_3):
		if right_whisker: right_whisker.target_position = v_3
		right_whisker_target_position = v_3
	get():
		return right_whisker_target_position
@export_flags_3d_navigation var right_whisker_collision_mask = 1:
	set(collision_mask):
		if right_whisker: right_whisker.collision_mask = collision_mask
		right_whisker_collision_mask = collision_mask
	get():
		return right_whisker_collision_mask
@export var right_whisker_hit_from_inside: bool = false:
	set(value):
		if right_whisker: right_whisker.hit_from_inside = value
		right_whisker_hit_from_inside = value
	get():
		return right_whisker_hit_from_inside
@export var right_whisker_hit_back_faces: bool = true:
	set(value):
		if right_whisker: right_whisker.hit_back_faces = value
		right_whisker_hit_back_faces = value
	get():
		return right_whisker_hit_back_faces
@export_subgroup("Collide With")
@export var right_whisker_areas: bool = false:
	set(value):
		if right_whisker: right_whisker.collide_with_areas = value
		right_whisker_areas = value
	get():
		return right_whisker_areas
@export var right_whisker_bodies: bool = true:
	set(value):
		if right_whisker: right_whisker.collide_with_bodies = value
		right_whisker_bodies = value
	get():
		return right_whisker_bodies
@export_subgroup("Transform")
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var right_whisker_position: Vector3 = Vector3(0.5, 0, 0):
	set(v_3):
		if right_whisker: right_whisker.position = v_3
		right_whisker_position = v_3
	get():
		return right_whisker_position
@export_custom(PROPERTY_HINT_RANGE, "-360,360,0.1,or_less,or_greater,radians") var right_whisker_rotation: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		if right_whisker: right_whisker.rotation = v_3
		right_whisker_rotation = v_3
	get():
		return right_whisker_rotation
@export_custom(PROPERTY_HINT_LINK, "") var right_whisker_scale: Vector3 = Vector3(1, 1, 1):
	set(v_3):
		if right_whisker: right_whisker.scale = v_3
		right_whisker_scale = v_3
	get():
		return right_whisker_scale

@export_group("Left Whisker")
@export var left_whisker_enabled: bool = true:
	set(value):
		if left_whisker: left_whisker.enabled = value
		left_whisker_enabled = value
	get():
		return left_whisker_enabled
@export var left_whisker_exclude_parent: bool = true:
	set(value):
		if left_whisker: left_whisker.exclude_parent = value
		left_whisker_exclude_parent = value
	get():
		return left_whisker_exclude_parent
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var left_whisker_target_position: Vector3 = Vector3(0, 0, 2):
	set(v_3):
		if left_whisker: left_whisker.target_position = v_3
		left_whisker_target_position = v_3
	get():
		return left_whisker_target_position
@export_flags_3d_navigation var left_whisker_collision_mask = 1:
	set(collision_mask):
		if left_whisker: left_whisker.collision_mask = collision_mask
		left_whisker_collision_mask = collision_mask
	get():
		return left_whisker_collision_mask
@export var left_whisker_hit_from_inside: bool = false:
	set(value):
		if left_whisker: left_whisker.hit_from_inside = value
		left_whisker_hit_from_inside = value
	get():
		return left_whisker_hit_from_inside
@export var left_whisker_hit_back_faces: bool = true:
	set(value):
		if left_whisker: left_whisker.hit_back_faces = value
		left_whisker_hit_back_faces = value
	get():
		return left_whisker_hit_back_faces
@export_subgroup("Collide With")
@export var left_whisker_areas: bool = false:
	set(value):
		if left_whisker: left_whisker.collide_with_areas = value
		left_whisker_areas = value
	get():
		return left_whisker_areas
@export var left_whisker_bodies: bool = true:
	set(value):
		if left_whisker: left_whisker.collide_with_bodies = value
		left_whisker_bodies = value
	get():
		return left_whisker_bodies
@export_subgroup("Transform")
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var left_whisker_position: Vector3 = Vector3(-0.5, 0, 0):
	set(v_3):
		if left_whisker: left_whisker.position = v_3
		left_whisker_position = v_3
	get():
		return left_whisker_position
@export_custom(PROPERTY_HINT_RANGE, "-360,360,0.1,or_less,or_greater,radians") var left_whisker_rotation: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		if left_whisker: left_whisker.rotation = v_3
		left_whisker_rotation = v_3
	get():
		return left_whisker_rotation
@export_custom(PROPERTY_HINT_LINK, "") var left_whisker_scale: Vector3 = Vector3(1, 1, 1):
	set(v_3):
		if left_whisker: left_whisker.scale = v_3
		left_whisker_scale = v_3
	get():
		return left_whisker_scale

@export_group("Center Whisker")
@export var center_whisker_enabled: bool = true:
	set(value):
		if center_whisker: center_whisker.enabled = value
		center_whisker_enabled = value
	get():
		return center_whisker_enabled
@export var center_whisker_exclude_parent: bool = true:
	set(value):
		if center_whisker: center_whisker.exclude_parent = value
		center_whisker_exclude_parent = value
	get():
		return center_whisker_exclude_parent
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var center_whisker_target_position: Vector3 = Vector3(0, 0, 2):
	set(v_3):
		if center_whisker: center_whisker.target_position = v_3
		center_whisker_target_position = v_3
	get():
		return center_whisker_target_position
@export_flags_3d_navigation var center_whisker_collision_mask = 1:
	set(collision_mask):
		if center_whisker: center_whisker.collision_mask = collision_mask
		center_whisker_collision_mask = collision_mask
	get():
		return center_whisker_collision_mask
@export var center_whisker_hit_from_inside: bool = false:
	set(value):
		if center_whisker: center_whisker.hit_from_inside = value
		center_whisker_hit_from_inside = value
	get():
		return center_whisker_hit_from_inside
@export var center_whisker_hit_back_faces: bool = true:
	set(value):
		if center_whisker: center_whisker.hit_back_faces = value
		center_whisker_hit_back_faces = value
	get():
		return center_whisker_hit_back_faces
@export_subgroup("Collide With")
@export var center_whisker_areas: bool = false:
	set(value):
		if center_whisker: center_whisker.collide_with_areas = value
		center_whisker_areas = value
	get():
		return center_whisker_areas
@export var center_whisker_bodies: bool = true:
	set(value):
		if center_whisker: center_whisker.collide_with_bodies = value
		center_whisker_bodies = value
	get():
		return center_whisker_bodies
@export_subgroup("Transform")
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var center_whisker_position: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		if center_whisker: center_whisker.position = v_3
		center_whisker_position = v_3
	get():
		return center_whisker_position
@export_custom(PROPERTY_HINT_RANGE, "-360,360,0.1,or_less,or_greater,radians") var center_whisker_rotation: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		if center_whisker: center_whisker.rotation = v_3
		center_whisker_rotation = v_3
	get():
		return center_whisker_rotation
@export_custom(PROPERTY_HINT_LINK, "") var center_whisker_scale: Vector3 = Vector3(1, 1, 1):
	set(v_3):
		if center_whisker: center_whisker.scale = v_3
		center_whisker_scale = v_3
	get():
		return center_whisker_scale

@export_group("Shader Cast")
@export var shader_cast_enabled: bool = true:
	set(value):
		if shader_cast: shader_cast.enabled = value
		shader_cast_enabled = value
	get():
		return shader_cast_enabled
@export var shader_cast_exclude_parent: bool = true:
	set(value):
		if shader_cast: shader_cast.exclude_parent = value
		shader_cast_exclude_parent = value
	get():
		return shader_cast_exclude_parent
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var shader_cast_target_position: Vector3 = Vector3(0, 20, 16):
	set(v_3):
		if shader_cast: shader_cast.target_position = v_3
		shader_cast_target_position = v_3
	get():
		return shader_cast_target_position
@export_flags_3d_navigation var shader_cast_collision_mask = 1:
	set(collision_mask):
		if shader_cast: shader_cast.collision_mask = collision_mask
		shader_cast_collision_mask = collision_mask
	get():
		return shader_cast_collision_mask
@export var shader_cast_hit_from_inside: bool = false:
	set(value):
		if shader_cast: shader_cast.hit_from_inside = value
		shader_cast_hit_from_inside = value
	get():
		return shader_cast_hit_from_inside
@export var shader_cast_hit_back_faces: bool = true:
	set(value):
		if shader_cast: shader_cast.hit_back_faces = value
		shader_cast_hit_back_faces = value
	get():
		return shader_cast_hit_back_faces
@export_subgroup("Collide With")
@export var shader_cast_areas: bool = false:
	set(value):
		if shader_cast: shader_cast.collide_with_areas = value
		shader_cast_areas = value
	get():
		return shader_cast_areas
@export var shader_cast_bodies: bool = true:
	set(value):
		if shader_cast: shader_cast.collide_with_bodies = value
		shader_cast_bodies = value
	get():
		return shader_cast_bodies
@export_subgroup("Transform")
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var shader_cast_position: Vector3 = Vector3(0, 0.5, 0):
	set(v_3):
		if shader_cast: shader_cast.position = v_3
		shader_cast_position = v_3
	get():
		return shader_cast_position
@export_custom(PROPERTY_HINT_RANGE, "-360,360,0.1,or_less,or_greater,radians") var shader_cast_rotation: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		if shader_cast: shader_cast.rotation = v_3
		shader_cast_rotation = v_3
	get():
		return shader_cast_rotation
@export_custom(PROPERTY_HINT_LINK, "") var shader_cast_scale: Vector3 = Vector3(1, 1, 1):
	set(v_3):
		if shader_cast: shader_cast.scale = v_3
		shader_cast_scale = v_3
	get():
		return shader_cast_scale

#endregion

func _ready() -> void:
	if tile_size == 0:
		self.set_y_sort_enabled(true)
		self.z_index = 1
		tile_size = 16
	_expand()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if not d3:
			_expand()
		if position.x != d3.position.x * tile_size:
			d3.position.x = position.x / tile_size
		if position.y != d3.position.z * tile_size - d3.position.y * tile_size:
			d3.position.z = position.y / tile_size + d3.position.y

func update_pos(first_coef = 1.1, second_coef = 2.1):
	self.position.x = d3.position.x * tile_size
	self.position.y = d3.position.z * tile_size - d3.position.y * tile_size
	if right_whisker.is_colliding() or left_whisker.is_colliding() or center_whisker.is_colliding():
		self.z_index = d3.position.y + first_coef
	else:
		self.z_index = d3.position.y + second_coef

func get_node_properties(node: Node) -> Dictionary:
	var properties : Dictionary = {
		"Name" : node.name,
		"Class" : node.get_class(),
		"Properties" : {}
	}
	for prop in node.get_property_list():
		if prop.usage & PROPERTY_USAGE_STORAGE:
			properties.Properties[prop.name] = node.get(prop.name)
	return properties

#region Expand

func _expand()  -> void:
	_expand_d3()
	_expand_ray_cast()
	if mesh_properties:
		_expand_mesh()
	if shape_properties:
		_expand_shape()
	_expand_slots()

func _expand_d3() -> void:
	d3 = StaticBody3D.new()
	d3.set_name("StaticBody3D")
	add_child(d3)
	move_child(d3, 0)
	d3 = get_child(0)
	
	d3.sync_to_physics = sync_to_physics_3d
	d3.physics_material_override = physics_material_override_3d
	d3.constant_linear_velocity = constant_linear_velocity_3d
	d3.constant_angular_velocity = constant_angular_velocity_3d
	d3.rotation = rotation_3d
	d3.scale = scale_3d
	
	d3.disable_mode = disable_mode_3d
	d3.collision_layer = layer
	d3.collision_mask = mask
	d3.collision_priority = priority
	d3.input_ray_pickable = ray_pickable
	d3.input_capture_on_drag = capture_on_drag
	
	d3.axis_lock_linear_x = linear_x
	d3.axis_lock_linear_y = linear_y
	d3.axis_lock_linear_z = linear_z
	d3.axis_lock_angular_x = angular_x
	d3.axis_lock_angular_y = angular_y
	d3.axis_lock_angular_z = angular_z
	
	d3.position.y = y_3d
	d3.position.x = position.x / tile_size
	d3.position.z = position.y / tile_size + d3.position.y

func _expand_ray_cast() -> void:
	#Right Whisker
	right_whisker = RayCast3D.new()
	right_whisker.set_name("RightWhisker")
	d3.add_child(right_whisker)
	right_whisker = d3.get_node("RightWhisker")
	
	right_whisker.enabled = right_whisker_enabled
	right_whisker.exclude_parent = right_whisker_exclude_parent
	right_whisker.target_position = right_whisker_target_position
	right_whisker.collision_mask = right_whisker_collision_mask
	right_whisker.hit_from_inside = right_whisker_hit_from_inside
	right_whisker.hit_back_faces = right_whisker_hit_back_faces
	
	right_whisker.collide_with_areas = right_whisker_areas
	right_whisker.collide_with_bodies = right_whisker_bodies
	
	right_whisker.position = right_whisker_position
	right_whisker.rotation = right_whisker_rotation
	right_whisker.scale = right_whisker_scale
	
	#Left Whisker
	left_whisker = RayCast3D.new()
	left_whisker.set_name("LeftWhisker")
	d3.add_child(left_whisker)
	left_whisker = d3.get_node("LeftWhisker")
	
	left_whisker.enabled = left_whisker_enabled
	left_whisker.exclude_parent = left_whisker_exclude_parent
	left_whisker.target_position = left_whisker_target_position
	left_whisker.collision_mask = left_whisker_collision_mask
	left_whisker.hit_from_inside = left_whisker_hit_from_inside
	left_whisker.hit_back_faces = left_whisker_hit_back_faces
	
	left_whisker.collide_with_areas = left_whisker_areas
	left_whisker.collide_with_bodies = left_whisker_bodies
	
	left_whisker.position = left_whisker_position
	left_whisker.rotation = left_whisker_rotation
	left_whisker.scale = left_whisker_scale
	
	#Center Whisker
	center_whisker = RayCast3D.new()
	center_whisker.set_name("CenterWhisker")
	d3.add_child(center_whisker)
	center_whisker = d3.get_node("CenterWhisker")
	
	center_whisker.enabled = center_whisker_enabled
	center_whisker.exclude_parent = center_whisker_exclude_parent
	center_whisker.target_position = center_whisker_target_position
	center_whisker.collision_mask = center_whisker_collision_mask
	center_whisker.hit_from_inside = center_whisker_hit_from_inside
	center_whisker.hit_back_faces = center_whisker_hit_back_faces
	
	center_whisker.collide_with_areas = center_whisker_areas
	center_whisker.collide_with_bodies = center_whisker_bodies
	
	center_whisker.position = center_whisker_position
	center_whisker.rotation = center_whisker_rotation
	center_whisker.scale = center_whisker_scale
	
	#Shader Cast
	shader_cast = RayCast3D.new()
	shader_cast.set_name("ShaderCast")
	d3.add_child(shader_cast)
	shader_cast = d3.get_node("ShaderCast")
	
	shader_cast.enabled = shader_cast_enabled
	shader_cast.exclude_parent = shader_cast_exclude_parent
	shader_cast.target_position = shader_cast_target_position
	shader_cast.collision_mask = shader_cast_collision_mask
	shader_cast.hit_from_inside = shader_cast_hit_from_inside
	shader_cast.hit_back_faces = shader_cast_hit_back_faces
	
	shader_cast.collide_with_areas = shader_cast_areas
	shader_cast.collide_with_bodies = shader_cast_bodies
	
	shader_cast.position = shader_cast_position
	shader_cast.rotation = shader_cast_rotation
	shader_cast.scale = shader_cast_scale

func _expand_mesh() -> void:
	var _mesh = MeshInstance3D.new()
	_mesh.set_name(mesh_properties.Name)
	d3.add_child(_mesh)
	
	_mesh.mesh = mesh_properties["Mesh"]
	_mesh.skeleton = mesh_properties["Skeleton"]
	_mesh.skin = mesh_properties["Skin"]
	_mesh.material_override = mesh_properties["MaterialOverride"]
	_mesh.material_overlay = mesh_properties["MaterialOverlay"]
	_mesh.transparency = mesh_properties["Transparency"]
	_mesh.cast_shadow = mesh_properties["CastShadow"]
	_mesh.extra_cull_margin = mesh_properties["ExtraCullMargin"]
	_mesh.custom_aabb = mesh_properties["CustomAABB"]
	_mesh.lod_bias = mesh_properties["LODBais"]
	_mesh.ignore_occlusion_culling = mesh_properties["IgnoreOcclusionCulling"]
	_mesh.gi_mode = mesh_properties["GIMode"]
	_mesh.gi_lightmap_scale = mesh_properties["GILightmapScale"]
	_mesh.visibility_range_begin = mesh_properties["VisibilityRangeBegin"]
	_mesh.visibility_range_begin_margin = mesh_properties["VisibilityRangeBeginMargin"]
	_mesh.visibility_range_end = mesh_properties["VisibilityRangeEnd"]
	_mesh.visibility_range_end_margin = mesh_properties["VisibilityRangeEndMargin"]
	_mesh.visibility_range_fade_mode = mesh_properties["VisibilityRangeFadeMode"]
	_mesh.layers = mesh_properties["Layers"]
	_mesh.sorting_offset = mesh_properties["SortingOffset"]
	_mesh.sorting_use_aabb_center = mesh_properties["SortingUseAABBCenter"]
	_mesh.position = mesh_properties["Position"]
	_mesh.rotation = mesh_properties["Rotation"]
	_mesh.scale = mesh_properties["Scale"]
	_mesh.rotation_edit_mode = mesh_properties["RotationEditMode"]
	_mesh.rotation_order = mesh_properties["RotationOrder"]
	_mesh.top_level = mesh_properties["TopLevel"]
func _expand_shape() -> void:
	if len(shape_properties) == 9:
		var _shape = CollisionShape3D.new()
		_shape.set_name(shape_properties.Name)
		d3.add_child(_shape)
		
		_shape.shape = shape_properties["Shape"]
		_shape.disabled = shape_properties["Disabled"]
		_shape.position = shape_properties["Position"]
		_shape.rotation = shape_properties["Rotation"]
		_shape.scale = shape_properties["Scale"]
		_shape.rotation_edit_mode = shape_properties["RotationEditMode"]
		_shape.rotation_order = shape_properties["RotationOrder"]
		_shape.top_level = shape_properties["TopLevel"]
	else:
		var _shape = CollisionPolygon3D.new()
		_shape.set_name(shape_properties.Name)
		d3.add_child(_shape)
		
		_shape.depth = shape_properties["Depth"]
		_shape.disabled = shape_properties["Disabled"]
		_shape.polygon = shape_properties["Polygon"]
		_shape.margin = shape_properties["Margin"]
		_shape.position = shape_properties["Position"]
		_shape.rotation = shape_properties["Rotation"]
		_shape.scale = shape_properties["Scale"]
		_shape.rotation_edit_mode = shape_properties["RotationEditMode"]
		_shape.rotation_order = shape_properties["RotationOrder"]
		_shape.top_level = shape_properties["TopLevel"]

func _expand_slots() -> void:
	if node_1_properties and ClassDB.class_exists(node_1_properties.Class):
		var node = ClassDB.instantiate(node_1_properties.Class)
		node.set_name(node_1_properties.Name)
		d3.add_child(node)
		
		for prop in node_1_properties.Properties:
			node.set(prop, node_1_properties.Properties[prop])
	
	if node_2_properties and ClassDB.class_exists(node_2_properties.Class):
		var node = ClassDB.instantiate(node_2_properties.Class)
		node.set_name(node_2_properties.Name)
		d3.add_child(node)
		
		for prop in node_2_properties.Properties:
			node.set(prop, node_2_properties.Properties[prop])
	
	if node_3_properties and ClassDB.class_exists(node_3_properties.Class):
		var node = ClassDB.instantiate(node_3_properties.Class)
		node.set_name(node_3_properties.Name)
		d3.add_child(node)
		
		for prop in node_3_properties.Properties:
			node.set(prop, node_3_properties.Properties[prop])
	
	if node_4_properties and ClassDB.class_exists(node_4_properties.Class):
		var node = ClassDB.instantiate(node_4_properties.Class)
		node.set_name(node_4_properties.Name)
		d3.add_child(node)
		
		for prop in node_4_properties.Properties:
			node.set(prop, node_4_properties.Properties[prop])
	
	if node_5_properties and ClassDB.class_exists(node_5_properties.Class):
		var node = ClassDB.instantiate(node_5_properties.Class)
		node.set_name(node_5_properties.Name)
		d3.add_child(node)
		
		for prop in node_5_properties.Properties:
			node.set(prop, node_5_properties.Properties[prop])

#endregion
