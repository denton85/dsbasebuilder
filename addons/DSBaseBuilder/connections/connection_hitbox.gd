class_name ConnectionHitbox
extends Area3D

@export var connection: Connection

func _init() -> void:
	collision_layer = 16
	collision_mask = 16
