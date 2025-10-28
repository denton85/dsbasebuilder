class_name ComponentButton
extends Button

var build_component: String
var base_builder: BaseBuilder

func _on_button_down() -> void:
	base_builder.current_build_component = build_component
	var type: BaseBuilder.COMPONENT_TYPE_REGISTRY = base_builder.build_resources.get(build_component).type
	DsBbGlobal.update_connections.emit(type)
	base_builder.set_build_preview()
