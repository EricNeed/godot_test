extends Camera3D
## camera functions
##	- camera rotation using mouse input


@export var camera_sensitivity := 0.2
var camera_rotate_x := 0.0 #current rotation around x axis
var camera_rotate_y := 0.0 #current rotation around y axis


## this function should only be called from the main input manager
func process_mouse_delta(event: InputEvent) -> void:
	#rotate the entire player node around Y axis (left and right)
		camera_rotate_y -= event.screen_relative.x * camera_sensitivity
		#rotate the cramera along its x axis (up and down)
		camera_rotate_x -= event.screen_relative.y * camera_sensitivity
		camera_rotate_x = clampf(camera_rotate_x, -90.0, 90.0)
		
		_update_camera(camera_rotate_y, camera_rotate_x)


# get camera rotation, for other scripts
func get_camera_rotation() -> Vector2:
	return Vector2(camera_rotate_x, camera_rotate_y)
# get camera rotation, for other scripts, eg: force player to look some where
func set_camera_rotation(rotation_x, rotation_y) -> void:
	camera_rotate_y = rotation_y
	camera_rotate_x = rotation_x
	_update_camera(rotation_y, rotation_x)


@onready var player := $".."
func _update_camera(y:float, x:float):
	player.rotation_degrees.y = y
	rotation_degrees.x = x
