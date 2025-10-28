## The main connection point for your build components to attach to.
class_name Connection
extends Node3D

var parent: BaseBuildComponent
var enabled: bool = true
## The current components placed on this connection.
var current_components: Array[BaseBuildComponent]
## The maximum amount of components this connection can hold. A connection can only hold one component of a specific type, but potentially more of different types if needed.
@export var max_components: int = 1

@onready var connection_hitbox: ConnectionHitbox = $ConnectionHitbox

## This defines what Components are allowed to be placed on this Connection. These options are defined in the BaseBuilder script inside the enum COMPONENT_REGISTRY.
@export var accepts: Array[BaseBuilder.COMPONENT_TYPE_REGISTRY] = []

func _ready() -> void:
	DsBbGlobal.update_connections.connect(handle_update_connections)
	connection_hitbox.area_entered.connect(merge_connections)
	#connection_hitbox.area_exited.connect(merge_connections)

## Checks if this connection can accept the current component type, then sets it's Hitbox monitoring to reflect that.
func handle_update_connections(component: int) -> void:
	if accepts.has(component):
		set_monitor(true)
	else:
		set_monitor(false)
	for i in current_components:
		if i == null:
			continue
		if i.COMPONENT_TYPE == component:
			set_monitor(false)
			break

## Sets the Connection to monitor or not depending on the current build component, toggled when DsBBGlobal.update_connections() is called.
func set_monitor(value: bool) -> void:
	connection_hitbox.monitorable = value
	connection_hitbox.monitoring = value


## This will make sure connections do not allow for placing multiple of the same type of component on the same connection (when two connections overlap). UNFINISHED
func merge_connections(area: Area3D) -> void:
	if area is ConnectionHitbox:
		var c = area.connection
		var same: bool = false
		for i in accepts:
			if c.accepts.has(i):
				same = true
		if same == false:
			return
		for i in current_components:
			if c.current_components.has(i):
				continue
			else:
				c.current_components.append(i)
