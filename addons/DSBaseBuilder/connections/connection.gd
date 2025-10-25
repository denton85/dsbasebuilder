## The main connection point for your build components to attach to.
class_name Connection
extends Node3D

var parent: BaseBuildComponent
var enabled: bool = true

@onready var connection_hitbox: ConnectionHitbox = $ConnectionHitbox

## This defines what Components are allowed to be placed on this Connection. These options are defined in the BaseBuilder script inside the enum COMPONENT_REGISTRY.
@export var accepts: Array[BaseBuilder.COMPONENT_TYPE_REGISTRY] = []

func _ready() -> void:
	DsBbGlobal.update_connections.connect(handle_update_connections)

## Checks if this connection can accept the current component type, then sets it's Hitbox monitoring to reflect that.
func handle_update_connections(component: int) -> void:
	if accepts.has(component):
		set_monitor(true)
	else:
		set_monitor(false)

## Sets the Connection to monitor or not depending on the current build component, toggled when DsBBGlobal.update_connections() is called.
func set_monitor(value: bool) -> void:
	connection_hitbox.monitorable = value
	connection_hitbox.monitoring = value
	
