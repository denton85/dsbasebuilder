class_name BaseBuilder
extends Node3D

@export var player: Node3D
@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var snap: Node3D = %Snap
@onready var connection_detect: ConnectionDetect = %ConnectionDetect

## When you add a new component, add it to the registry here so connections can see it.
enum COMPONENT_REGISTRY {foundation, ceiling, wall, deconstruct}

## When you add a new component, give it the same name as in the registry and drag the scene into this exported dictionary.
@export var build_components: Dictionary[String, PackedScene] = {
}

## The current build component selected
@export var current_build_component: PackedScene
var current_build_component_id: COMPONENT_REGISTRY

func _ready() -> void:
	if build_components.size() > 0:
		current_build_component = build_components.values()[0]
		current_build_component_id = 0
		DsBbGlobal.update_connections.emit(current_build_component_id)
		
func _process(delta: float) -> void:
	if connection_detect.current_focused_connection != null:
		snap.global_transform = connection_detect.current_focused_connection.global_transform
	else:
		snap.global_position = global_position
		snap.global_rotation = player.global_rotation

## This is the method to place a component at a connection point. Pass in the component scene, connection, and the node you want the component added as a child of.
func place_component(component: PackedScene, connection: Connection, parent_node: Node3D) -> void:
	if current_build_component == null:
		return
	var comp: BaseBuildComponent = component.instantiate()
	parent_node.add_child(comp)
	comp.global_transform = connection.global_transform
	DsBbGlobal.update_connections.emit(current_build_component_id)
