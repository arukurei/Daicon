@tool
extends EditorPlugin

var addon_path = get_script().get_path().get_base_dir()

var template_search_path = ProjectSettings.get('editor/script/templates_search_path')
var daicon_path = template_search_path + '/Daicon/'
var kinematic_daicon_path = template_search_path + '/KinematicDaicon/'

var daicon_template = 'daicon.gd'
var kinematic_dicon_tamplate = 'kinematic_daicon.gd'

func _enter_tree() -> void:
	print_debug("Daicon Enabled")
	create_templates()

func create_templates():
	if not DirAccess.dir_exists_absolute(daicon_path):
		var dir = DirAccess.open('res://')
		if dir: dir.make_dir_recursive(daicon_path)
	if not DirAccess.dir_exists_absolute(kinematic_daicon_path):
		var dir = DirAccess.open('res://')
		if dir: dir.make_dir_recursive(kinematic_daicon_path)
	
	if not FileAccess.file_exists(daicon_path + daicon_template):
		var source = ResourceLoader.load(addon_path + '/scripts/' + daicon_template)
		if source: ResourceSaver.save(source.duplicate(true), daicon_path + daicon_template)
	if not FileAccess.file_exists(kinematic_daicon_path + kinematic_dicon_tamplate):
		var source = ResourceLoader.load(addon_path + '/scripts/' + kinematic_dicon_tamplate)
		if source: ResourceSaver.save(source.duplicate(true), kinematic_daicon_path + kinematic_dicon_tamplate)

func _exit_tree() -> void:
	print_debug('Daicon Disabled')
