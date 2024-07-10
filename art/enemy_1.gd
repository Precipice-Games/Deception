extends Area2D

@export var speed = 130
var direction = -1
var velocity = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#velocity.y += 980 * delta
	
	velocity.x = direction * speed
	position.x += velocity.x * delta
	
	if not $FloorCheck.is_colliding():
		direction *= -1
		$FloorCheck.position.x *= -1
		if $AnimatedSprite2D.flip_h == false:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
