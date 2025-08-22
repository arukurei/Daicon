@tool
extends EditorPlugin

var addon_path = get_script().get_path().get_base_dir()
var template_search_path = ProjectSettings.get('editor/script/templates_search_path')

var pathes = {template_search_path + '/Daicon/' : 'daicon.gd',
			template_search_path + '/KinematicDaicon/' : 'kinematic_daicon.gd',
			template_search_path + '/StaticDaicon/' : 'static_daicon.gd',
			template_search_path + '/AnimatedDaicon/' : 'animated_daicon.gd',
			template_search_path + '/RigidDaicon/' : 'rigid_daicon.gd'}

func _enter_tree() -> void:
	print_debug("Daicon Enabled")
	create_templates()

func create_templates():
	for path in pathes:
		if not DirAccess.dir_exists_absolute(path):
			var dir = DirAccess.open('res://')
			if dir: dir.make_dir_recursive(path)
		if not FileAccess.file_exists(path + pathes.get(path)):
			var source = ResourceLoader.load(addon_path + '/scripts/' + pathes.get(path))
			if source: ResourceSaver.save(source.duplicate(true), path + pathes.get(path))

func _exit_tree() -> void:
	print_debug('Daicon Disabled')
