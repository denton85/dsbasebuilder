class_name BaseBuilder
extends Node3D

## The Node that this BaseBuilder Scene belongs to. It doesn't have to be called Player, but it is the agent who is controlling the BaseBuilder.
@export var player: Node3D
#@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var snap: Node3D = %Snap
@onready var connection_detect: ConnectionDetect = %ConnectionDetect

## When you start a new foundation, it will create a Base Structure to hold all the components of the structure.
const BASE_STRUCTURE = preload("res://addons/DSBaseBuilder/components/base_structure.tscn")

## The types of components your Connections accept. Deconstruct NEEDS to remain to not error, the rest can be removed if you don't want those base types. Just make sure as you add Types or remove them, assign them an integer value and don't reuse an old integer value unless you want to go back and change a bunch of Connection nodes.
enum COMPONENT_TYPE_REGISTRY { foundation=0, wall=1, ceiling=2, triangle_foundation=3, triangle_ceiling=4, deconstruct=5 }

## All your build components live here. Name your component, then give it a resource that includes the title, type and scene. Currently the title might not do anything but it could be useful in your own code.
@export var build_resources: Dictionary[String, DSComponentResource] = {
	"deconstruct": null
}

## A list of components that are allowed to be placed by themselves without connecting to another component. (Foundations are most common).
@export var foundation_components: Array[COMPONENT_TYPE_REGISTRY]

## The current build component selected. This is a String, the name of the component in the build_resources dictionary..
@export var current_build_component: String
@export var current_preview_scene: ComponentPreview

func _ready() -> void:
	if build_resources.size() > 0:
		DsBbGlobal.update_connections.emit(current_build_component)
			
func _process(delta: float) -> void:
	if connection_detect.current_focused_connection != null:
		snap.global_transform = connection_detect.current_focused_connection.global_transform
	else:
		snap.global_position = global_position
		snap.global_rotation = player.global_rotation
		

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
	if build_resources.get(component).type not in foundation_components:
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

func set_build_preview() -> void:
	for child in snap.get_children():
		if child is ComponentPreview:
			child.queue_free()
			current_preview_scene = null
	var prev: PackedScene = build_resources.get(current_build_component).preview_scene
	if prev == null:
		return
	current_preview_scene = prev.instantiate()
	snap.add_child(current_preview_scene)
	
