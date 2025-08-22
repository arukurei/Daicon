@tool
@icon("res://addons/daicon/icons/daicon_map_layer.svg")
class_name DaiconMapLayer extends TileMapLayer

var grid_map : GridMap

#region DaiconMapLayer Exports

@export var mesh_library : MeshLibrary:
	set(library):
		if grid_map: grid_map.mesh_library = library
		mesh_library = library
	get():
		return mesh_library
@export var physics_material : PhysicsMaterial:
	set(library):
		if grid_map: grid_map.physics_material = library
		physics_material = library
	get():
		return physics_material
@export var visible_3d: bool = true:
	set(value):
		if grid_map: grid_map.visible = value
		visible_3d = value
	get():
		return visible_3d

@export_group("Cell")
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var size: Vector3 = Vector3(1, 1, 1):
	set(v_3):
		if grid_map: grid_map.cell_size = v_3
		size = v_3
	get():
		return size

@export_group("Collision")
@export_flags_3d_physics var layer: int = 1:
	set(collision_layer):
		if grid_map: grid_map.collision_layer = collision_layer
		layer = collision_layer
	get():
		return layer
@export_flags_3d_navigation var mask: int = 1:
	set(collision_mask):
		if grid_map: grid_map.collision_mask = collision_mask
		mask = collision_mask
	get():
		return mask
@export_group("Navigation")
@export var bake_navigation: bool = false:
	set(value):
		if grid_map: grid_map.bake_navigation = value
		bake_navigation = value
	get():
		return bake_navigation
@export_group("Transorm")
@export_custom(PROPERTY_HINT_RANGE, "-360,360,0.1,or_less,or_greater,radians") var rotation_3d: Vector3 = Vector3(0, 0, 0):
	set(v_3):
		if grid_map: grid_map.rotation = v_3
		rotation_3d = v_3
	get():
		return rotation_3d
@export_custom(PROPERTY_HINT_LINK, "") var scale_3d: Vector3 = Vector3(1, 1, 1):
	set(v_3):
		if grid_map: grid_map.scale = v_3
		scale_3d = v_3
	get():
		return scale_3d

#endregion

func _ready() -> void:
	if not tile_set:
		self.set_y_sort_enabled(true)
		self.tile_set = TileSet.new()
		self.tile_set.add_custom_data_layer(0)
		self.tile_set.set_custom_data_layer_name(0, "Item")
		self.tile_set.set_custom_data_layer_type(0, TYPE_INT)
	#Expand GridMap
	grid_map = GridMap.new()
	grid_map.set_name("GridMap")
	add_child(grid_map)
	move_child(grid_map, 0)
	
	grid_map.position.z = -0.5
	grid_map = get_child(0)
	
	grid_map.mesh_library = mesh_library
	grid_map.physics_material = physics_material
	grid_map.cell_size = size
	grid_map.collision_layer = layer
	grid_map.collision_mask = mask
	grid_map.bake_navigation = bake_navigation
	
	grid_map.rotation = rotation_3d
	grid_map.scale = scale_3d
	
	update_grid_map()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if len(get_used_cells()) != len(grid_map.get_used_cells()):
			update_grid_map()
		if position.x != grid_map.position.x * tile_set.tile_size.x:
			grid_map.position.x = position.x / tile_set.tile_size.x
		if position.y != grid_map.position.z * tile_set.tile_size.y:
			grid_map.position.z = position.y / tile_set.tile_size.y -0.5

func update_grid_map():
	grid_map.clear()
	for tile in get_used_cells():
		var tile_data = get_cell_tile_data(Vector2(tile.x, tile.y))
		grid_map.set_cell_item(Vector3(tile.x, z_index-1, tile.y+z_index), tile_data.get_custom_data("Item"))
