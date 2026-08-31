@tool
extends EditorPlugin

func _enter_tree() -> void:
	print_rich("[color=#ff9cd5]Daicon Plugin Enabled[/color]")

func _exit_tree() -> void:
	print_rich("[color=gray]Daicon Plugin Disabled[/color]")
