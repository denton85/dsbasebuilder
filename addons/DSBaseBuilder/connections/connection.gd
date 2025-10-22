@tool
class_name Connection
extends Node3D

var parent: BaseBuildComponent
var enabled: bool = true

@onready var connection_hitbox: ConnectionHitbox = $ConnectionHitbox
@export var accepts: Array[BaseBuilder.COMPONENT_REGISTRY] = []

func _ready() -> void:
	DsBbGlobal.update_connections.connect(handle_update_connections)

func handle_update_connections(component: int) -> void:
	if accepts.has(component):
		set_monitor(true)
		print("Has: ")
		print(component)
	else:
		set_monitor(false)

func set_monitor(value: bool) -> void:
	connection_hitbox.monitorable = value
	connection_hitbox.monitoring = value
