class_name ComponentButton
extends Button

var build_component: String
var base_builder: BaseBuilder

func _on_button_down() -> void:
	base_builder.current_build_component = base_builder.build_components[build_component]
	base_builder.current_build_component_id = base_builder.COMPONENT_REGISTRY[build_component]
	DsBbGlobal.update_connections.emit(base_builder.current_build_component_id)
