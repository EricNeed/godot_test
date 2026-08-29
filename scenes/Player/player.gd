extends CharacterBody3D
## master player control script
## contain the code for:
## 		- player movement
##		- camera rotation using mouse input
##		- phisics: jump and fall and movement velocity


@export var speed = 5.0
@export var jump_velocity = 4.5
@export var camera_sensitivity = 0.2

var camera_rotate_x = 0 #current rotation around x axis
var camera_rotate_y = 0 #current rotation around y axis


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		#interpolate the velocity of character to zero
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()



func _update_camera(y:int, x:int):
	rotation_degrees.y = y
	$Camera3D.rotation_degrees.x = x
	
func _unhandled_input(event: InputEvent) -> void:
	#handle mouse input
	if event is InputEventMouseMotion:
		if not (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED): return
		
		#rotate the entire player node around Y axis (left and right)
		camera_rotate_y -= event.relative.x * camera_sensitivity
		#rotate the cramera along its x axis (up and down)
		camera_rotate_x -= event.relative.y * camera_sensitivity
		camera_rotate_x = clamp(camera_rotate_x, -90, 90)
		
		_update_camera(camera_rotate_y, camera_rotate_x)
		
	# handle press escape to free mouse
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("LMB") && Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		return
	
	# mark this input event as handled, even if _unhandled_input() was decleared in another script, it wont process this again
	get_viewport().set_input_as_handled()


# get camera rotation, for other scripts
func get_camera_rotation() -> Vector2:
	return Vector2(camera_rotate_x, camera_rotate_y)
# get camera rotation, for other scripts, eg: force player to look some where
func set_camera_rotation(rotation_x, rotation_y) -> void:
	camera_rotate_y = rotation_y
	camera_rotate_x = rotation_x
	_update_camera(rotation_y, rotation_x)
