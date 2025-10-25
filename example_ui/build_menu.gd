class_name BuildMenu
extends Control

@onready var grid_container: GridContainer = $PanelContainer/GridContainer
@export var  base_builder: BaseBuilder
const COMPONENT_BUTTON = preload("res://example_ui/component_button.tscn")

func _ready() -> void:
	for key in base_builder.build_resources:
		var b: ComponentButton = COMPONENT_BUTTON.instantiate()
		b.text = key.to_upper()
		b.build_component = key
		b.base_builder = base_builder
		grid_container.add_child(b)
		
