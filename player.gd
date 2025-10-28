class_name Player
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 6.5
const decel = 0.25
@onready var camera: Camera3D = %Camera3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_sensitivity: float = 0.001
var is_building: bool = true

@onready var build_menu: Control = $BuildMenu
@onready var connection_detect: ConnectionDetect = $Camera3D/BaseBuilder/ConnectionDetect
@onready var base_builder: BaseBuilder = $Camera3D/BaseBuilder

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	movement(delta)
	
	if Input.is_action_just_pressed("toggle_build_state"):
		is_building = !is_building
		if is_building == false:
			DsBbGlobal.update_connections.emit(400000)
		else:
			if base_builder.build_resources.get(base_builder.current_build_component) != null:
				DsBbGlobal.update_connections.emit(base_builder.build_resources.get(base_builder.current_build_component).type)
		
	if Input.is_action_just_pressed("toggle_build_menu"):
		toggle_build_menu()
		
	if is_building == false:
		base_builder.hide()
	else:
		base_builder.show()
		
	if Input.is_action_just_pressed("left_click"):
		if build_menu.visible == true or is_building == false:
			return
		if connection_detect.current_focused_connection == null:
			base_builder.place_new_structure(base_builder.current_build_component, Global.main)
		else:
			base_builder.place_component(base_builder.current_build_component, connection_detect.current_focused_connection, Global.main)
		
func movement(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		pass
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# Direction is only not zero when it has an input
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#
#	# CHANGE LATER to fix the deceleration stuff
#
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, decel)
		velocity.z = move_toward(velocity.z, 0, decel)

	if direction == Vector3.ZERO and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, decel * 100)
		velocity.z = move_toward(velocity.z, 0, decel * 100)

	move_and_slide()

func toggle_build_menu() -> void:
	build_menu.visible = !build_menu.visible
	if build_menu.visible == true:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_object_local(Vector3.UP, -event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(90), deg_to_rad(90))
