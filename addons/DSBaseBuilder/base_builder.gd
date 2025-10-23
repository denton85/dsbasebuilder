class_name BaseBuilder
extends Node3D

## The Node that this BaseBuilder Scene belongs to. It doesn't have to be called Player, but it is the agent who is controlling the BaseBuilder.
@export var player: Node3D
@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var snap: Node3D = %Snap
@onready var connection_detect: ConnectionDetect = %ConnectionDetect

## When you start a new foundation, it will create a Base Structure to hold all the components of the structure.
const BASE_STRUCTURE = preload("res://addons/DSBaseBuilder/components/base_structure.tscn")

## When you add a new component, add it to the registry here so connections can see it.
enum COMPONENT_REGISTRY {foundation, ceiling, wall, deconstruct}
## When you add a new component, give it the same name as in the registry and drag the scene into this exported dictionary.
@export var build_components: Dictionary[String, PackedScene] = {
	"deconstruct": null
}

## A list of components that are allowed to be placed by themselves without connecting to another component. (Foundations are most common).
@export var foundation_components: Array[COMPONENT_REGISTRY]

## An array of all the component names, used to check if the COMPONENT_REGISTRY is up to date.
var component_names: Array[String] = []

## The current build component selected
@export var current_build_component: String
## The current component id within the enum COMPONENT_REGISTRY, which gets passed to connections to check if they accept the component or not.
#var current_build_component_id: COMPONENT_REGISTRY

func _ready() -> void:
	if build_components.size() > 0:
		for i in build_components.keys():
			component_names.append(i)
		#current_build_component = build_components.key()[0]
		#current_build_component_id = 0
		DsBbGlobal.update_connections.emit(current_build_component)
		for i in component_names:
			assert(i in COMPONENT_REGISTRY.keys(), "Component -->" + i + "<-- not found in the enum COMPONENT_REGISTRY! Please add the component name to the enum in the BaseBuilder Script.")
			
func _process(delta: float) -> void:
	if connection_detect.current_focused_connection != null:
		snap.global_transform = connection_detect.current_focused_connection.global_transform
	else:
		snap.global_position = global_position
		snap.global_rotation = player.global_rotation

## This is the method to place a component at a connection point. Pass in the component scene, connection, and the node you want the component added as a child of.
func place_component(component: String, connection: Connection, parent_node: Node3D) -> void:
	if current_build_component == null:
		return
	if component == "deconstruct":
		deconstruct_component(connection)
		return
	var find_component: PackedScene = build_components.get(component)
	var comp: BaseBuildComponent = find_component.instantiate()
	parent_node.add_child(comp)
	comp.global_transform = connection.global_transform
	DsBbGlobal.update_connections.emit(COMPONENT_REGISTRY[current_build_component])

## Deconstructs the parent of the focused Connection (if that Connection accepts "deconstruct")
func deconstruct_component(connection: Connection) -> void:
	connection.get_parent().deconstruct()

func place_new_structure(component: String, parent_node: Node3D) -> void:
	if component == null:
		return
	if COMPONENT_REGISTRY[component] not in foundation_components:
		return
	var new_structure: BaseStructure = BASE_STRUCTURE.instantiate()
	parent_node.add_child(new_structure)
	new_structure.global_transform = snap.global_transform
	var find_component: PackedScene = build_components.get(component)
	var comp: BaseBuildComponent = find_component.instantiate()
	new_structure.add_child(comp)
	comp.structure = new_structure
	DsBbGlobal.update_connections.emit(COMPONENT_REGISTRY[current_build_component])
