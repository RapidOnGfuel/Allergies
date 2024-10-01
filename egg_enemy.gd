extends CharacterBody2D


const speed = 25
var motion
var player_chase = false
@onready var player = get_node("../Player")
func _physics_process(delta):
	motion = Vector2.ZERO
	if player_chase:
		position += (player.position - position)/speed



	move_and_slide()


func _on_area_2d_body_entered(body):
	#if body.name == "Player":
		print("hewi")
		player_chase = true
		


func _on_area_2d_body_shape_exited(body):
	if body.is_in_group("player"):
		player_chase = false
