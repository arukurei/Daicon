@tool
class_name DaiconSlots extends RefCounted

## Utility for serializing/deserializing Godot nodes to and from Dictionary form.
## Used by DaiconEntity's "slot" system (whisker/shape/shader_cast) to store a node's
## full state (script, properties, meta, optionally children) so it can be ejected
## from the scene tree and later reconstructed identically.

# Исключаем только взаимоисключающие матрицы 
# (оставляя чистые position/rotation/scale) и служебные поля
const _CONFLICTING_PROPERTIES := {
	"script": true,
	"name": true,
	"transform": true,
	"global_transform": true,
	"global_position": true,
	"global_rotation": true,
	"global_rotation_degrees": true,
	"quaternion": true,
	"basis": true,
	"rotation_edit_mode": true,
	}

static var _auto_name_rx: RegEx


#region API
## Safely reparents a node and preserves editor ownership so it doesn't disappear on save.
static func safe_reparent(node: Node, new_parent: Node) -> void:
	if not node or not new_parent: return
	node.reparent(new_parent, false)
	if Engine.is_editor_hint() and new_parent.owner: _set_owner_recursive(node, new_parent.owner)

## Serializes a node, its script, metadata, and properties into a Dictionary.
## Node references stored in exported properties (e.g. @export var target: Node) are
## dropped — only plain data and Resource values survive the round-trip.
## If [param recursive] is true, child nodes are serialized as a nested tree.
static func serialize_node(node: Node, recursive: bool = false) -> Dictionary:
	if not node: return {} # Защита от пустой ноды
	
	# Получаем путь к кастомному скрипту, если он прикреплен
	var script_path := ""
	var script_res := node.get_script() as Script
	if script_res and not script_res.resource_path.is_empty(): script_path = script_res.resource_path
	
	# Чистим имя ТОЛЬКО если оно строго соответствует автогенерируемому формату Godot (@Class@N).
	# Пользовательские имена с "@" внутри (редкий, но валидный кейс) не трогаем.
	var clean_name: String = node.name
	if _get_auto_name_rx().search(clean_name):
		var at_parts = clean_name.split("@")
		for part in at_parts:
			if not part.is_empty() and not part.is_valid_int():
				clean_name = part
				break
	
	# Базовый паспорт сохраняемой ноды
	var data: Dictionary = {
		"Name": clean_name,
		"Class": node.get_class(),
		"Script": script_path,
		"Properties": {},
		"Meta": {}
		}
	
	# 1: Сохраняем все пользовательские метаданные (set_meta)
	for meta_key in node.get_meta_list():
		if String(meta_key).begins_with("_"): continue # Skip editor-internal meta (e.g. _edit_lock_)
		data.Meta[meta_key] = node.get_meta(meta_key)
	
	# 2: Перебираем и сохраняем свойства ноды
	for prop in node.get_property_list():
		var p_name: String = prop.name
		var p_usage: int = prop.usage
		
		
		if _CONFLICTING_PROPERTIES.has(p_name): continue # Пропускаем конфликтующие матрицы и служебные дубликаты
		if p_usage & PROPERTY_USAGE_READ_ONLY: continue # Пропускаем свойства "только для чтения", чтобы не спамить ошибками
		
		# Сохраняем только то, что настраивается в инспекторе или сохраняется на диск
		if (p_usage & PROPERTY_USAGE_STORAGE) or (p_usage & PROPERTY_USAGE_EDITOR):
			var val = node.get(p_name)
			# Исключаем ссылки на другие ноды сцены (сохраняем только чистые данные и Resource)
			if val != null and not (val is Object and not val is Resource): data.Properties[p_name] = val
	
	# 3: Рекурсивно обходим всех детей, если включен флаг Deep Tree
	if recursive and node.get_child_count() > 0:
		var children_arr: Array[Dictionary] = []
		for child in node.get_children():
			children_arr.append(serialize_node(child, true))
		data["Children"] = children_arr
	
	return data


## Reconstructs a Node from a serialized Dictionary.
## [param make_unique]: deep-duplicates Resource/Array/Dictionary values (including
## Resources nested inside arrays/dicts) so the resulting node doesn't share state
## with the source. Resources themselves are duplicated shallowly (sub-resources like
## textures/shaders stay shared) — this avoids accidental memory bloat while still
## giving each node its own Resource instance.
static func deserialize_node(dict: Dictionary, make_unique: bool = false) -> Node:
	if dict.is_empty(): return null # Защита от пустого словаря
	
	var node: Node = null
	var script_path: String = dict.get("Script", "")
	var class_name_str: String = dict.get("Class", "Node")
	
	# 1: Пытаемся создать ноду через кастомный скрипт (если файл есть на диске)
	if not script_path.is_empty() and ResourceLoader.exists(script_path):
		var script_res := load(script_path) as Script
		if script_res and script_res.can_instantiate(): node = script_res.new() as Node
	
	# 2: Безопасный Fallback на базовый класс движка (если скрипта нет на компьютере)
	if not node and not class_name_str.is_empty() and ClassDB.class_exists(class_name_str):
		node = ClassDB.instantiate(class_name_str) as Node
		if not script_path.is_empty(): push_warning("[DaiconSlots] Script missing on disk ('%s'). Safe fallback to '%s'." % [script_path, class_name_str])
	
	# 3: Аварийная заглушка (если даже класс неизвестен)
	if not node: node = Node.new()
	
	node.name = dict.get("Name", "SlotNode") # Восстанавливаем оригинальное чистое имя
	
	# 4: Восстанавливаем все метаданные
	var meta_dict: Dictionary = dict.get("Meta", {})
	for meta_key in meta_dict:
		node.set_meta(meta_key, meta_dict[meta_key])
	
	# 5: Накатываем значения всех сохраненных свойств.
	# Свойства, которых больше нет у целевого класса (скрипт успели отредактировать
	# после сохранения) — пропускаем с предупреждением, а не тихо и не с ошибкой.
	var props: Dictionary = dict.get("Properties", {})
	if not props.is_empty():
		var valid_names := {} # Строим один раз, чтобы не листать property_list на каждое свойство.
		for p in node.get_property_list(): valid_names[p.name] = true
		
		for p_name in props:
			if not valid_names.has(p_name):
				push_warning("[DaiconSlots] '%s' has no property '%s' — stored value skipped (script may have changed)." % [node.get_class(), p_name])
				continue
			
			var val = props[p_name]
			
			# Если включена уникализация — глубоко клонируем ресурсы, массивы и словари
			if make_unique: val = _make_value_unique(val)
			
			node.set(p_name, val)
	
	# 6: Рекурсивно создаем и прикрепляем дочерние ноды
	if dict.has("Children"):
		for child_dict in dict["Children"]:
			var child_node := deserialize_node(child_dict, make_unique)
			if child_node: node.add_child(child_node, true)
	
	return node


## Unpacks a node from Dictionary, attaches it to [param parent], and sets editor ownership recursively.
static func expand_slot(properties: Dictionary, parent: Node, make_unique: bool = false) -> Node:
	if properties.is_empty() or not parent: return null # Защита от пустых данных / отсутствия родителя
	
	# Разворачиваем готовую ноду из данных
	var node := deserialize_node(properties, make_unique)
	if node:
		parent.add_child(node, true) # Добавляем в дерево к родителю (force_readable_name гарантирует чистое имя)
		
		# В режиме редактора рекурсивно назначаем владельца (owner) всей цепочке детей
		if Engine.is_editor_hint() and parent.is_inside_tree():
			var tree := parent.get_tree()
			if tree and tree.edited_scene_root: _set_owner_recursive(node, tree.edited_scene_root)
	
	return node
#endregion


#region Internal
## Lazily compiled regex matching Godot's auto-generated node names ("@ClassName@123").
static func _get_auto_name_rx() -> RegEx:
	if not _auto_name_rx:
		_auto_name_rx = RegEx.new()
		_auto_name_rx.compile("^@.+@\\d+$")
	return _auto_name_rx

## Recursively assigns the editor scene owner to the node and all of its descendants.
static func _set_owner_recursive(node: Node, scene_owner: Node) -> void:
	node.owner = scene_owner
	for child in node.get_children(): _set_owner_recursive(child, scene_owner)


## Deep-copies Array/Dictionary structure and shallow-duplicates any Resource found
## inside (including nested ones). See make_unique doc on deserialize_node above.
static func _make_value_unique(val: Variant) -> Variant:
	if val is Resource:
		return (val as Resource).duplicate(false)
	elif val is Array:
		var arr := val as Array
		var out := []
		out.resize(arr.size())
		for i in arr.size(): out[i] = _make_value_unique(arr[i])
		return out
	elif val is Dictionary:
		var dict := val as Dictionary
		var out := {}
		for k in dict: out[k] = _make_value_unique(dict[k])
		return out
	return val
#endregion
