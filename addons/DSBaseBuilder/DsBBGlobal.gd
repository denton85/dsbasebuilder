extends Node

signal update_connections

## Global toggle to show the connection previews. Set to false by default, but can be enabled globally here. This is just a little rod that sticks up visibly to show which connections are active, useful for debugging.
@export var show_previews: bool = false

var total_structures: Array[BaseStructure]

## This is the function you can call to disable or enable connection previews.
func toggle_connection_previews(value: bool) -> void:
	show_previews = value
