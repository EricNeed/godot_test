extends CharacterBody3D
## master player control script
## contain the code for:
## 	- player movement
##	- phisics: jump and fall and movement velocity


@export var speed := 3.0
@export var jump_velocity := 4.5
@export var push_force := 1.0


var is_playing_anim = false
@onready var anim_manager = $AnimationTree

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
		if not is_playing_anim:
			anim_manager.start_walking()
			is_playing_anim = true
	else:
		#interpolate the velocity of character to zero
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		if is_playing_anim:
			anim_manager.stop_walking()
			is_playing_anim = false
	move_and_slide()
	
	# Apply force to any RigidBody touched during movement
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		
		if collider is RigidBody3D:
			var push_dir = -collision.get_normal()
			collider.apply_central_impulse(push_dir * push_force)
