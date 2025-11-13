class_name DSComponentResource
extends Resource


## Your component title. Currently not used for anything, but may be useful in your own code.
@export var title: String

## This is your component type. To add custom types, edit the enum COMPONENT_TYPE_REGISTRY in the /addons/DSBaseBuilder/base_builder.gd script. Be careful when adding custom types, you need to use a unique default integer and without reusing old deleted integer values (otherwise your Connections may all need to be updated). 
@export var type: BaseBuilder.COMPONENT_TYPE_REGISTRY

## This is your component scene.
@export var scene: PackedScene

## This holds the preview of your component if you want to display that before building.
@export var preview_scene: PackedScene

## This defines whether the component should be able to be rotated before being placed.
@export var is_rotatable: bool = false
## This defines the amount of rotation it will recieve every time the rotate action happens.
@export var degrees_of_rotation: float = 0
