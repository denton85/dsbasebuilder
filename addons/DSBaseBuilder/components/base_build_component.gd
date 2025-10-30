@tool
class_name BaseBuildComponent
extends Node3D

## This is the BaseStructure node that this is a part of.
var structure: BaseStructure

## This defines whether the component should be able to be rotated before being placed.
@export var is_rotatable: bool = false
## This defines the amount of rotation it will recieve every time the rotate action happens.
@export var degrees_of_rotation: float = 0
## This defines the component type, so connections know whether to activate (ie, Connections that accept Walls should accept this if the type is specified as "Wall")
@export var COMPONENT_TYPE: BaseBuilder.COMPONENT_TYPE_REGISTRY
## The Connection this component is placed on, if any.
@export var parent_connection: Connection
## This lets the connections know that this is a free floating component (the first placed in a new Structure) so the connections can know to not enable on top of this component.

## This is the function to deconstruct the component.
func deconstruct() -> void:
	if parent_connection != null:
		parent_connection.current_components.erase(self)
		parent_connection.enabled = true
	structure.children.erase(self)
	if structure.first_foundation == self:
		structure.first_foundation = null
	queue_free()
