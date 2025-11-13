## The main connection point for your build components to attach to.
class_name Connection
extends Node3D

@onready var preview_node: CSGBox3D = $PreviewNode

## The Parent Build Component (This is needed to be set, or make sure the Connection is a direct child of the component so the ready function will grab it.).
@export var parent: BaseBuildComponent
var enabled: bool = true
## The current components placed on this connection.
var current_components: Array[BaseBuildComponent]
## The maximum amount of components this connection can hold. A connection can only hold one component of a specific type, but potentially more of different types if needed.
@export var max_components: int = 1
## The Connections this Connection overlaps with.
var current_overlapping_connections: Array[Connection]

@onready var connection_hitbox: ConnectionHitbox = $ConnectionHitbox

## This defines what Components are allowed to be placed on this Connection. These options are defined in the BaseBuilder script inside the enum COMPONENT_REGISTRY.
@export var accepts: Array[BaseBuilder.COMPONENT_TYPE_REGISTRY] = []

func _ready() -> void:
	if get_parent() is BaseBuildComponent and parent == null:
		parent = get_parent()
	DsBbGlobal.update_connections.connect(handle_update_connections)
	connection_hitbox.area_entered.connect(merge_connections)
	connection_hitbox.area_exited.connect(unmerge_connections)

## Checks if this connection can accept the current component type, then sets it's Hitbox monitoring to reflect that.
func handle_update_connections(component: int) -> void:
	if accepts.has(component):
		set_monitor(true)
		update_current_connections()
		toggle_connection_previews(true)
	else:
		set_monitor(false)
		toggle_connection_previews(false)

func toggle_connection_previews(value: bool) -> void:
	if DsBbGlobal.show_previews == true:
		if value == true:
			preview_node.show()
		else:
			preview_node.hide()

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
		if c in current_overlapping_connections:
			pass
		else:
			current_overlapping_connections.append(c)
			
		update_current_connections()
	
func unmerge_connections(area: Area3D) -> void:
	if area is ConnectionHitbox:
		var c = area.connection
		var same: bool = false
		for i in accepts:
			if c.accepts.has(i):
				same = true
		if same == false:
			return
		if c in current_overlapping_connections:
			current_overlapping_connections.erase(c)
			
		update_current_connections()
	
func update_current_connections() -> void:
	for i in current_overlapping_connections:
		if i == null:
			current_overlapping_connections.erase(i)
			
	enabled = true
	
	if current_components.size() > 0:
		enabled = false
	else:
		for i in current_overlapping_connections:
			if i == null: continue
			if i.current_components.size() > 0:
				enabled = false
				break
	
	if parent != null:
		## This basically checks to disable a connection if it was built from the first foundation which wont have a connection overlap.
		if parent.structure.first_foundation != null and parent.structure.first_foundation.COMPONENT_TYPE in accepts:
			var distance: float = 0.2
			if global_position.distance_to(parent.structure.first_foundation.global_position) < distance:
				enabled = false
