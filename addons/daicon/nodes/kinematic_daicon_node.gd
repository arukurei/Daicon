@tool
@icon("res://addons/daicon/icons/kinematic_daicon.svg")
class_name KinematicDaicon extends CharacterBody2D

var d3 : CharacterBody3D

var whisker : Area3D
var shader_cast : RayCast3D

#region KinematicDaicon Exports

## Tile Size determines how many pixels equal 1 meter in 3D.[br] (basically it is the tile size per cell size in 3D)
@export var tile_size : int:
	set(size):
		if size > 0:
			tile_size = size
	get():
		return tile_size
## Third-axis position.
@export var y_3d : int:
	set(value):
		if d3:
			d3.position.y = value + offset_3d.y
			self.position.y = ((d3.position.z - offset_3d.z) - (d3.position.y - offset_3d.y)) * tile_size
		y_3d = value
	get():
		return y_3d
## Z-step in sortable system between height levels.
@export var z_step : int = 10:
	set(step):
		z_step = step
	get():
		return z_step
## Mesh 3D
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
				
				"Skin" : node.skin,
				"Skeleton" : node.skeleton,
				
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
				"Quaternion" : node.quaternion,
				"Basis" : node.basis,
				
				"RotationEditMode" : node.rotation_edit_mode,
				"RotationOrder" : node.rotation_order,
				"TopLevel" : node.top_level}
		else:
			mesh_properties = {}
	get():
		if not mesh_properties: return
		return d3.get_node(str(mesh_properties.Name))
## Shape or Polygon 3D.
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
									"Quaternion" : node.quaternion,
									"Basis" : node.basis,
									
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
									"Quaternion" : node.quaternion,
									"Basis" : node.basis,
									
									"RotationEditMode" : node.rotation_edit_mode,
									"RotationOrder" : node.rotation_order,
									"TopLevel" : node.top_level}
		else:
			shape_properties = {}
	get():
		if not shape_properties: return
		return d3.get_node(str(shape_properties.Name))

@export_group("Mesh & Shape")
@export var current_mesh : Mesh:
	set(msh):
		if mesh:
			mesh.mesh = msh
		if mesh_properties:
			mesh_properties["Mesh"] = msh
		current_mesh = msh
	get():
		if not mesh: return
		return mesh.mesh
@export var current_shape : Shape3D:
	set(shape_3D):
		if shape:
			shape.shape = shape_3D
		if shape_properties:
			shape_properties["Shape"] = shape_3D
		current_shape = shape_3D
	get():
		if not shape: return
		return shape.shape
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var mesh_and_shape_position: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		if mesh:
			mesh.position = v_3
		if mesh_properties:
			mesh_properties["Position"] = v_3
		
		if shape:
			shape.position = v_3
		if shape_properties:
			shape_properties["Position"] = v_3
		mesh_and_shape_position = v_3
	get():
		return mesh_and_shape_position
@export_custom(PROPERTY_HINT_RANGE, "-360,360,0.1,or_less,or_greater,radians") var mesh_and_shape_rotation: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		if mesh:
			mesh.rotation = v_3
		if mesh_properties:
			mesh_properties["Rotation"] = v_3
		
		if shape:
			shape.rotation = v_3
		if shape_properties:
			shape_properties["Rotation"] = v_3
		mesh_and_shape_rotation = v_3
	get():
		return mesh_and_shape_rotation
@export_custom(PROPERTY_HINT_LINK, "") var mesh_and_shape_scale: Vector3 = Vector3(1, 1, 1):
	set(v_3):
		if mesh:
			mesh.scale = v_3
		if mesh_properties:
			mesh_properties["Scale"] = v_3
		
		if shape:
			shape.scale = v_3
		if shape_properties:
			shape_properties["Scale"] = v_3
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
			node.reparent(d3)
			d3.move_child(node, 0)
			node.position = Vector3(0, 0, 0)
			node_1_properties = get_node_properties(node)
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
			node.reparent(d3)
			d3.move_child(node, 0)
			node.position = Vector3(0, 0, 0)
			node_2_properties = get_node_properties(node)
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
			node.reparent(d3)
			d3.move_child(node, 0)
			node.position = Vector3(0, 0, 0)
			node_3_properties = get_node_properties(node)
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
			node.reparent(d3)
			d3.move_child(node, 0)
			node.position = Vector3(0, 0, 0)
			node_4_properties = get_node_properties(node)
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
			node.reparent(d3)
			d3.move_child(node, 0)
			node.position = Vector3(0, 0, 0)
			node_5_properties = get_node_properties(node)
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
			mesh.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		mesh_properties = dict
	get():
		return mesh_properties
@export var shape_properties : Dictionary:
	set(dict):
		if not dict and shape:
			shape.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		shape_properties = dict
	get():
		return shape_properties
@export var node_1_properties : Dictionary:
	set(dict):
		if not dict and node_1:
			node_1.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		node_1_properties = dict
	get():
		return node_1_properties
@export var node_2_properties : Dictionary:
	set(dict):
		if not dict and node_2:
			node_2.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		node_2_properties = dict
	get():
		return node_2_properties
@export var node_3_properties : Dictionary:
	set(dict):
		if not dict and node_3:
			node_3.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		node_3_properties = dict
	get():
		return node_3_properties
@export var node_4_properties : Dictionary:
	set(dict):
		if not dict and node_4:
			node_4.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		node_4_properties = dict
	get():
		return node_4_properties
@export var node_5_properties : Dictionary:
	set(dict):
		if not dict and node_5:
			node_5.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		node_5_properties = dict
	get():
		return node_5_properties
@export var visible_3d: bool = true:
	set(value):
		if d3: d3.visible = value
		visible_3d = value
	get():
		return visible_3d

#endregion

#region Core Exports

@export_category("KinematicBody3D")
@export_enum("Grounded", "Floating") var motion_mode_3d: int = 0:
	set(mode):
		if d3: d3.motion_mode = mode
		motion_mode_3d = mode
		property_list_changed.emit()
	get():
		return motion_mode_3d
@export var up_direction_3d: Vector3 = Vector3(0, 1, 0):
	set(v_3):
		if d3: d3.up_direction = v_3
		up_direction_3d = v_3
	get():
		return up_direction_3d
@export var slide_and_ceiling_3d: bool = true:
	set(value):
		if d3: d3.slide_on_ceiling = value
		slide_and_ceiling_3d = value
	get():
		return slide_and_ceiling_3d
@export_range(0, 180, 0.1, "radians_as_degrees") var wall_min_slide_ang: float = 0.261799:
	set(angle):
		if d3: d3.wall_min_slide_angle = angle
		wall_min_slide_ang = angle
	get():
		return wall_min_slide_ang

@export_group("Floor 3D")
@export var stop_on_slope_3d: bool = true:
	set(value):
		if d3: d3.floor_stop_on_slope = value
		stop_on_slope_3d = value
	get():
		return stop_on_slope_3d
@export var constant_speed_3d: bool = false:
	set(value):
		if d3: d3.floor_constant_speed = value
		constant_speed_3d = value
	get():
		return constant_speed_3d
@export var block_on_wall_3d: bool = true:
	set(value):
		if d3: d3.floor_block_on_wall = value
		block_on_wall_3d = value
	get():
		return block_on_wall_3d
@export_range(0, 180, 0.1, "radians_as_degrees") var max_angle_3d: float = 0.785398:
	set(angle):
		if d3: d3.floor_max_angle = angle
		max_angle_3d = angle
	get():
		return max_angle_3d
@export_range(0, 1, 0.01, "or_greater", "suffix:m") var snap_length_3d: float = 0.1:
	set(angle):
		if d3: d3.floor_snap_length = angle
		snap_length_3d = angle
	get():
		return snap_length_3d
const grounded_properties : Array[StringName] = [&"up_direction_3d", &"slide_and_ceiling_3d", &"wall_min_slide_ang", &"Floor 3D", &"stop_on_slope_3d", &"constant_speed_3d", &"block_on_wall_3d", &"max_angle_3d", &"snap_length_3d"]
const floating_properties : Array[StringName] = [&"wall_min_slide_ang"]

@export_group("Moving Platform 3D")
@export_enum("Add Velocity", "Add Upward Velocity", "Do Nothing") var on_leave: int = 0:
	set(mode):
		if d3: d3.platform_on_leave = mode
		on_leave = mode
	get():
		return on_leave
@export_flags_3d_physics var floor_layers: int = 0xFFFFFFFF:
	set(layer):
		if d3: d3.platform_floor_layers = layer
		floor_layers = layer
	get():
		return floor_layers
@export_flags_3d_physics var wall_layers: int = 0:
	set(layer):
		if d3: d3.platform_wall_layers = layer
		wall_layers = layer
	get():
		return wall_layers

@export_group("Collision")
@export_range(0.001, 256, 0.001, "suffix:m") var safe_margin_3d: float = 0.001:
	set(margin):
		if d3: d3.safe_margin = margin
		safe_margin_3d = margin
	get():
		return safe_margin_3d

@export_group("Transorm")
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var offset_3d: Vector3 = Vector3(0, 0.5, 0):
	set(v_3):
		if d3: d3.position += v_3 - offset_3d
		offset_3d = v_3
	get():
		return offset_3d
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

@export var quaternion_3d: Quaternion = Quaternion(0, 0, 0, 1.0):
	set(quat):
		if d3: d3.quaternion = quat
		quaternion_3d = quat
	get():
		return quaternion_3d
@export var basis_3d: Basis:
	set(bas):
		if d3: d3.basis = bas
		basis_3d = bas
	get():
		return basis_3d
@export_enum("Euler", "Quaternion", "Basis") var rotation_edit_mode_3d : int = 0:
	set(mode):
		if d3: 
			d3.rotation_edit_mode = mode
			if mode == 0:
				d3.rotation = rotation_3d
			elif mode == 1:
				d3.quaternion = quaternion_3d
			elif mode == 2:
				d3.basis = basis_3d
		rotation_edit_mode_3d = mode
		property_list_changed.emit()
	get():
		return rotation_edit_mode_3d
@export var rotation_order_3d : EulerOrder = 2:
	set(order):
		if d3: d3.rotation_order = order
		rotation_order_3d = order
	get():
		return rotation_order_3d
@export var top_level_3d : bool = false:
	set(value):
		if d3: d3.top_level = value
		top_level_3d = value
	get():
		return top_level_3d
const euler_properties : Array[StringName] = [&"quaternion_3d", &"basis_3d"]
const quaternion_properties : Array[StringName] = [&"rotation_3d", &"basis_3d", &"rotation_order_3d"]
const basis_properties : Array[StringName] = [&"rotation_3d", &"scale_3d", &"quaternion_3d", &"rotation_order_3d"]


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
#Shader
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
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var shader_cast_position: Vector3 = Vector3(0, 0, 0):
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

#Whisker
@export_group("Whisker")
@export var whisker_shape : Node3D:
	set(node):
		if not d3: return
		if node:
			if node is CollisionShape3D or node is CollisionPolygon3D:
				if whisker_shape:
					whisker_shape_properties = {}
				node.reparent(whisker)
				whisker.move_child(node, 0)
				node.position = Vector3(0, 0, 0)
				whisker_shape_properties = get_node_properties(node)
		else:
			whisker_shape_properties = {}
	get():
		if not whisker_shape_properties: return
		return whisker.get_node(str(whisker_shape_properties.Name))
@export_storage var whisker_shape_properties : Dictionary:
	set(dict):
		if not dict and whisker:
			whisker_shape.reparent(self)
			get_child(-1).owner = get_tree().edited_scene_root
		whisker_shape_properties = dict
	get():
		return whisker_shape_properties

@export var whisker_monitoring: bool = true: 
	set(value):
		if whisker: whisker.monitoring = value
		whisker_monitoring = value
	get():
		return whisker_monitoring
@export var whisker_monitorable: bool = true: 
	set(value):
		if whisker: whisker.monitorable = value
		whisker_monitorable = value
	get():
		return whisker_monitorable

@export_enum("Remove", "Make Static", "Keep Active") var whisker_disable_mode = 0:
	set(mode):
		if whisker: whisker.disable_mode = mode
		whisker_disable_mode = mode
	get():
		return whisker_disable_mode

@export_subgroup("Collision")
@export_flags_3d_physics var whisker_layer = 1:
	set(collision_layer):
		if whisker: whisker.collision_layer = collision_layer
		whisker_layer = collision_layer
	get():
		return whisker_layer
@export_flags_3d_navigation var whisker_mask = 1:
	set(collision_mask):
		if whisker: whisker.collision_mask = collision_mask
		whisker_mask = collision_mask
	get():
		return whisker_mask
@export var whisker_priority: float = 1:
	set(value):
		if whisker: whisker.collision_priority = value
		whisker_priority = value
	get():
		return whisker_priority

@export_subgroup("Input")
@export var whisker_ray_pickable: bool = true: 
	set(value):
		if whisker: whisker.input_ray_pickable = value
		whisker_ray_pickable = value
	get():
		return whisker_ray_pickable
@export var whisker_capture_on_drag: bool: 
	set(value):
		if whisker: whisker.input_capture_on_drag = value
		whisker_capture_on_drag = value
	get():
		return whisker_capture_on_drag

@export_subgroup("Transform")
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var whisker_position: Vector3 = Vector3(0, 0, 1.1):
	set(v_3):
		if whisker: whisker.position = v_3
		whisker_position = v_3
	get():
		return whisker_position
@export_custom(PROPERTY_HINT_RANGE, "-360,360,0.1,or_less,or_greater,radians") var whisker_rotation: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		if whisker: whisker.rotation = v_3
		whisker_rotation = v_3
	get():
		return whisker_rotation
@export_custom(PROPERTY_HINT_LINK, "") var whisker_scale: Vector3 = Vector3(1, 1, 1):
	set(v_3):
		if whisker: whisker.scale = v_3
		whisker_scale = v_3
	get():
		return whisker_scale

#endregion

func _ready() -> void:
	if tile_size == 0:
		self.set_y_sort_enabled(true)
		self.z_index = 1
		tile_size = 16
	_expand()
	d3.set_meta("z_index", self.z_index)
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if not d3:
			_expand()
		if self.position.x != (d3.position.x - offset_3d.x) * tile_size:
			d3.position.x = (self.position.x / tile_size) + offset_3d.x
		if self.position.y != ((d3.position.z - offset_3d.z) - (d3.position.y - offset_3d.y)) * tile_size:
			d3.position.z = ((self.position.y / tile_size) + (d3.position.y - offset_3d.y)) + offset_3d.z

func update_pos(coef = 1):
	self.position.x = (d3.position.x - offset_3d.x) * tile_size
	self.position.y = ((d3.position.z - offset_3d.z) - (d3.position.y - offset_3d.y)) * tile_size
	
	if whisker.get_overlapping_bodies():
		if whisker.get_overlapping_bodies()[0].has_meta("z_index"):
			self.z_index = whisker.get_overlapping_bodies()[0].get_meta("z_index") - 1
		else:
			self.z_index = (int(d3.position.y + (offset_3d.y * 1.1))) * z_step - 1
	else:
		self.z_index = ((d3.position.y - offset_3d.y) + coef) * z_step + 2
	
	d3.set_meta("z_index", self.z_index)

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
func _validate_property(property: Dictionary) -> void:
	if not d3: return
	
	#motion mode
	if property.name in grounded_properties:
		if motion_mode_3d == 0:
			property.usage |= PROPERTY_USAGE_EDITOR
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name in floating_properties:
		if motion_mode_3d == 1:
			property.usage |= PROPERTY_USAGE_EDITOR
	
	#rotation mode
	if property.name in quaternion_properties:
		if rotation_edit_mode_3d == 1:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name in euler_properties:
		if rotation_edit_mode_3d == 0:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name in basis_properties:
		if rotation_edit_mode_3d == 2:
			property.usage &= ~PROPERTY_USAGE_EDITOR

#region Expand

func _expand() -> void:
	_expand_d3()
	_expand_ray_cast()
	if mesh_properties:
		_expand_mesh()
	if shape_properties:
		_expand_shape()
	_expand_slots()

func _expand_d3() -> void:
	d3 = CharacterBody3D.new()
	d3.set_name("KinematicBody3D")
	add_child(d3)
	move_child(d3, 0)
	d3 = get_child(0)
	
	d3.motion_mode = motion_mode_3d
	d3.up_direction = up_direction_3d
	d3.slide_on_ceiling = slide_and_ceiling_3d
	d3.wall_min_slide_angle = wall_min_slide_ang
	
	d3.floor_stop_on_slope = stop_on_slope_3d
	d3.floor_constant_speed = constant_speed_3d
	d3.floor_block_on_wall = block_on_wall_3d
	d3.floor_max_angle = max_angle_3d
	d3.floor_snap_length = snap_length_3d
	
	d3.platform_on_leave = on_leave
	d3.platform_floor_layers = floor_layers
	d3.platform_wall_layers = wall_layers
	
	d3.safe_margin = safe_margin_3d
	
	d3.axis_lock_linear_x = linear_x
	d3.axis_lock_linear_y = linear_y
	d3.axis_lock_linear_z = linear_z
	d3.axis_lock_angular_x = angular_x
	d3.axis_lock_angular_y = angular_y
	d3.axis_lock_angular_z = angular_z
	
	d3.disable_mode = disable_mode_3d
	d3.collision_layer = layer
	d3.collision_mask = mask
	d3.collision_priority = priority
	
	d3.input_ray_pickable = ray_pickable
	d3.input_capture_on_drag = capture_on_drag
	
	d3.position.y = y_3d + offset_3d.y
	d3.position.x = (self.position.x / tile_size) + offset_3d.x
	d3.position.z = ((self.position.y / tile_size) + (d3.position.y - offset_3d.y)) + offset_3d.z
	
	d3.scale = scale_3d
	
	if rotation_edit_mode_3d == 0:
		d3.rotation = rotation_3d
	elif rotation_edit_mode_3d == 1:
		d3.quaternion = quaternion_3d
	elif rotation_edit_mode_3d == 2:
		d3.basis = basis_3d
	d3.rotation_edit_mode = rotation_edit_mode_3d
	d3.top_level = top_level_3d
	d3.visible = visible_3d
func _expand_ray_cast() -> void:
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
	
	#Whisker
	whisker = Area3D.new()
	whisker.set_name("Whisker")
	d3.add_child(whisker)
	whisker = d3.get_node("Whisker")
	
	whisker.monitoring = whisker_monitoring
	whisker.monitorable = whisker_monitorable
	
	whisker.disable_mode = whisker_disable_mode
	whisker.collision_layer = whisker_layer
	whisker.collision_mask = whisker_mask
	whisker.collision_priority = whisker_priority
	
	whisker.input_ray_pickable = whisker_ray_pickable
	whisker.input_capture_on_drag = whisker_capture_on_drag
	
	whisker.position = whisker_position
	whisker.rotation = whisker_rotation
	whisker.scale = whisker_scale
	
	if whisker_shape_properties and ClassDB.class_exists(whisker_shape_properties.Class):
		var node = ClassDB.instantiate(whisker_shape_properties.Class)
		node.set_name(whisker_shape_properties.Name)
		whisker.add_child(node)
		
		for prop in whisker_shape_properties.Properties:
			node.set(prop, whisker_shape_properties.Properties[prop])
func _expand_mesh() -> void:
	var _mesh = MeshInstance3D.new()
	_mesh.set_name(mesh_properties.Name)
	d3.add_child(_mesh)
	
	_mesh.mesh = mesh_properties["Mesh"]
	
	_mesh.skin = mesh_properties["Skin"]
	_mesh.skeleton = mesh_properties["Skeleton"]
	
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
	_mesh.scale = mesh_properties["Scale"]
	_mesh.rotation_edit_mode = mesh_properties["RotationEditMode"]
		
	if mesh_properties["RotationEditMode"] == 0:
		_mesh.rotation = mesh_properties["Rotation"]
	elif mesh_properties["RotationEditMode"] == 1:
		_mesh.quaternion = mesh_properties["Quaternion"]
	elif mesh_properties["RotationEditMode"] ==2:
		_mesh.basis = mesh_properties["Basis"]
	
	_mesh.rotation_order = mesh_properties["RotationOrder"]
	_mesh.top_level = mesh_properties["TopLevel"]
func _expand_shape() -> void:
	if len(shape_properties) == 11:
		var _shape = CollisionShape3D.new()
		_shape.set_name(shape_properties.Name)
		d3.add_child(_shape)
		
		_shape.shape = shape_properties["Shape"]
		_shape.disabled = shape_properties["Disabled"]
		
		_shape.position = shape_properties["Position"]
		_shape.scale = shape_properties["Scale"]
		_shape.rotation_edit_mode = shape_properties["RotationEditMode"]
		
		if shape_properties["RotationEditMode"] == 0:
			_shape.rotation = shape_properties["Rotation"]
		elif shape_properties["RotationEditMode"] == 1:
			_shape.quaternion = shape_properties["Quaternion"]
		elif shape_properties["RotationEditMode"] ==2:
			_shape.basis = shape_properties["Basis"]
		
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
		_shape.scale = shape_properties["Scale"]
		_shape.rotation_edit_mode = shape_properties["RotationEditMode"]
		
		if shape_properties["RotationEditMode"] == 0:
			_shape.rotation = shape_properties["Rotation"]
		elif shape_properties["RotationEditMode"] == 1:
			_shape.quaternion = shape_properties["Quaternion"]
		elif shape_properties["RotationEditMode"] ==2:
			_shape.basis = shape_properties["Basis"]
		
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
