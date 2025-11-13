@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("DsBbGlobal", "res://addons/DSBaseBuilder/DsBBGlobal.gd")

func _exit_tree() -> void:
	remove_autoload_singleton("DsBbGlobal")
