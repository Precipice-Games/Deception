extends CharacterBody2D

@export var walkSPEED = 300.0
@export var sprintSPEED = 500.0
@export var JUMP_VELOCITY = -400.0
@export var dash_distance = 100
@export var dash_duration = 0.1

var dashing = false
var SPEED = walkSPEED
var canDash = true
var isrunning = false
var direction = 0
var fall = 1000
var target_position = Vector2()
var dash_timer = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var sprint = false

func _ready():
	target_position = position  # Initialize target position

func _physics_process(delta):
	if global_position.y > fall:
		print(global_position.y, " ", fall)
		game_over()

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle dashing
	if dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			dashing = false
			canDash = false
			$canDashTimer.start()  # Start cooldown timer
		else:
			# Ensure horizontal travel same distance every time
			if direction != 0:
				velocity.x = direction * (dash_distance / dash_duration)
	
	# Apply horizontal movement based on input
	if not dashing:
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			# Increase the deceleration rate to reduce sliding
			velocity.x = move_toward(velocity.x, 0, SPEED * 5 * delta)

	# Check if character lands on the ground
	if is_on_floor() and not dashing:
		SPEED = sprintSPEED if sprint else walkSPEED  # Reset speed to sprint or walk when lands on the ground

	move_and_slide()

	# Handle input for direction and movement
	handle_input(delta)

func handle_input(delta):
	if Input.is_action_pressed("move_left"):
		direction = -1
		isrunning = true
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("runbig")
		if Input.is_action_pressed("shift") and is_on_floor():
			SPEED = sprintSPEED
		if Input.is_action_just_pressed("jump") and SPEED==sprintSPEED:
			SPEED = sprintSPEED
		if not Input.is_action_pressed("shift") and is_on_floor():
			SPEED = walkSPEED

	elif Input.is_action_pressed("move_right"):
		direction = 1
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("runbig")
		isrunning = true
		if Input.is_action_pressed("shift") and is_on_floor():
			SPEED = sprintSPEED
			print("here1")
		if Input.is_action_just_pressed("jump") and SPEED==sprintSPEED:
			SPEED = sprintSPEED
			print("here2")
		if not Input.is_action_pressed("shift") and is_on_floor():
			SPEED = walkSPEED
	else:
		direction = 0
		if not dashing:
			$AnimatedSprite2D.play("idle3")

	if Input.is_action_just_pressed("punch"):
		$AnimatedSprite2D.play("punch")

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("Jump3")
		$JumpTimer.start()

	# Handle dashing
	if Input.is_action_just_pressed("dash") and not is_on_floor() and canDash:
		start_dash()

func start_dash():
	dashing = true
	dash_timer = dash_duration
	velocity.x = (dash_distance / dash_duration) * (1 if direction >= 0 else -1)  # Set dash velocity

func game_over():
	get_tree().reload_current_scene()

func _on_can_dash_timer_timeout():
	canDash = true

func _on_damage_detector_area_entered(area):
	if area.is_in_group("harmful"):
		game_over()

func _on_direction_sprint_timer_timeout():
	if not Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		SPEED = walkSPEED
		isrunning = false

func _on_jump_timer_timeout():
	$AnimatedSprite2D.play("idle3")

func _on_area_2d_body_entered(body):
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")
