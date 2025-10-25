class_name BaseBuilder
extends Node3D

## The Node that this BaseBuilder Scene belongs to. It doesn't have to be called Player, but it is the agent who is controlling the BaseBuilder.
@export var player: Node3D
@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var snap: Node3D = %Snap
@onready var connection_detect: ConnectionDetect = %ConnectionDetect

## When you start a new foundation, it will create a Base Structure to hold all the components of the structure.
const BASE_STRUCTURE = preload("res://addons/DSBaseBuilder/components/base_structure.tscn")

## The types of components your Connections accept. You don't need one for each component, just for specific types. For example, if a Wall and a Doorway component are always going to be added to the same type of Connection, you can just make both of them be the type: Wall. You can remove some of these and create your own types, but "deconstruct" shouldn't be deleted unless you want to custom code the "place_component" function to fix the errors that will come up.
enum COMPONENT_TYPE_REGISTRY { foundation, wall, ceiling, deconstruct }

## All your build components live here. Name your component, then give it a resource that includes the title, type and scene. Currently the title might not do anything but it could be useful in your own code.
@export var build_resources: Dictionary[String, DSComponentResource] = {
	"deconstruct": null
}

## A list of components that are allowed to be placed by themselves without connecting to another component. (Foundations are most common).
@export var foundation_components: Array[COMPONENT_TYPE_REGISTRY]

## An array of all the component names, used to check if the COMPONENT_REGISTRY is up to date.
var component_names: Array[String] = []

## The current build component selected. This is a String, the name of the component in the build_components dictionary and the COMPONENT_REGISTRY enum.
@export var current_build_component: String

func _ready() -> void:
	if build_resources.size() > 0:
		DsBbGlobal.update_connections.emit(current_build_component)
			
func _process(delta: float) -> void:
	if connection_detect.current_focused_connection != null:
		snap.global_transform = connection_detect.current_focused_connection.global_transform
		snap.visible = true
	else:
		snap.global_position = global_position
		snap.global_rotation = player.global_rotation
		snap.visible = false
		

## This is the method to place a component at a connection point. Pass in the component scene, connection, and the node you want the component added as a child of.
func place_component(component: String, connection: Connection, parent_node: Node3D, degrees_of_rotation: float = 0.0) -> void:
	if current_build_component == null:
		return
	if component == "deconstruct":
		deconstruct_component(connection)
		return
	var find_component: PackedScene = build_resources.get(component).scene
	var comp: BaseBuildComponent = find_component.instantiate()
	parent_node.add_child(comp)
	comp.global_transform = connection.global_transform
	comp.global_rotation.y += degrees_of_rotation
	DsBbGlobal.update_connections.emit(build_resources.get(component).type)

## Deconstructs the parent of the focused Connection (if that Connection accepts "deconstruct")
func deconstruct_component(connection: Connection) -> void:
	connection.get_parent().deconstruct()

## This function creates a new Structure in an area not connected to another Structure. You can define which components are allowed to be placed in empty space in the exported Foundation Components array in the BaseBuilder (not connected to another Connection). For example, a Foundation component should be allowed to be placed without the need of an existing structure.
func place_new_structure(component: String, parent_node: Node3D, degrees_of_rotation: float = 0.0) -> void:
	if component == null:
		return
	if COMPONENT_TYPE_REGISTRY[build_resources.get(component).type] not in foundation_components:
		return
	var new_structure: BaseStructure = BASE_STRUCTURE.instantiate()
	parent_node.add_child(new_structure)
	new_structure.global_transform = snap.global_transform
	var find_component: PackedScene = build_resources.get(component).scene
	var comp: BaseBuildComponent = find_component.instantiate()
	new_structure.add_child(comp)
	comp.global_rotation.y += degrees_of_rotation
	comp.structure = new_structure
	DsBbGlobal.update_connections.emit(build_resources.get(component).type)
