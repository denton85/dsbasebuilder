extends Node

signal update_connections

## Global toggle to show the connection previews. Set to true by default, but can be disabled globally here.
@export var show_previews: bool = true

## This is the function you can call to disable or enable connection previews.
func toggle_connection_previews(value: bool) -> void:
	show_previews = value
