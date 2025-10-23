@tool
class_name BaseBuildComponent
extends Node3D

## This is the BaseStructure node that this is a part of.
var structure: BaseStructure

## This defines whether the component should be able to be rotated before being placed.
@export var is_rotatable: bool = false
## This defines the amount of rotation it will recieve every time the rotate action happens.
@export var degrees_of_rotation: float = 0
