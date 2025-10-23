class_name ConnectionDetect
extends Area3D

## A property to disable or enable this detector
var enabled: bool = true

## An array of all the connections this detector is currently intersecting with
var next_focused_connections: Array[Connection] = []
## The current connection that this detector is focused on
var current_focused_connection: Connection = null

func _init() -> void:
	collision_layer = 16
	collision_mask = 16
	
func _ready() -> void:
	area_entered.connect(add_to_current_focused_connections)
	area_exited.connect(remove_from_current_focused_connections)

func add_to_current_focused_connections(area: ConnectionHitbox) -> void:
	if area is ConnectionHitbox:
		if area.connection.enabled == false:
			return
		if current_focused_connection != null:
			next_focused_connections.append(area.connection)
		else:
			current_focused_connection = area.connection
	
func remove_from_current_focused_connections(area: ConnectionHitbox) -> void:
	if area is ConnectionHitbox:
		if current_focused_connection == area.connection:
			current_focused_connection = null
			if next_focused_connections.is_empty():
				return
			else:
				current_focused_connection = next_focused_connections[0]
				next_focused_connections.remove_at(0)
		else:
			var index = next_focused_connections.find(area.connection)
			if index > -1:
				next_focused_connections.remove_at(index)
