extends CharacterBody2D

@export var speed = 200
@export var player:CharacterBody2D
var can_attack = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_player_in_line_of_sight() and can_attack == true:
		velocity = $PlayerDetector.target_position.normalized()
		velocity *= speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()


func is_player_in_line_of_sight():
	$PlayerDetector.target_position = player.position - self.position
	return $PlayerDetector.is_colliding()
	


func _on_area_2d_body_entered(body):
	can_attack = true
