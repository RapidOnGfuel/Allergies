extends CharacterBody2D

var speed = 250
var player_chase = false
var idle_timer = 0
var chasing_after_idle = false
var player_attack = false
var is_alive = true  # New variable to check if the enemy is alive

@onready var player = get_node("../Player")

func _physics_process(delta):
	if !is_alive:
		return  # Stop processing if the enemy is dead

	if player_attack:
		$AnimatedSprite2D.play("attack")
		position += (player.position - position).normalized() * speed * delta
		$AnimatedSprite2D.flip_h = player.position.x > position.x
	else:
		if player_chase:
			position += (player.position - position).normalized() * speed * delta
			$AnimatedSprite2D.play("walking")
			$AnimatedSprite2D.flip_h = player.position.x > position.x
		else:
			if chasing_after_idle:
				idle_timer -= delta
				print(int(idle_timer))
				if idle_timer <= 0:
					chasing_after_idle = false
					player_chase = true
					print("Chasing!")
			else:
				$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body):
	if body.name == "Player" and is_alive:  # Ensure it's the player and the enemy is alive
		player = body
		player_chase = true
		idle_timer = 3
		chasing_after_idle = true
		print(int(idle_timer))
		player_attack = false

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		player = null
		player_chase = false
		chasing_after_idle = false
		player_attack = false

func _on_hurt_player_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(5)  # Apply damage to the player
		player_attack = true  
		print("Attacking, dealing 5 damage")
		player_chase = false
		is_alive = false  # Mark the enemy as dead
		$AnimatedSprite2D.play("die")  # Wait for the animation to finish
		queue_free()  # Remove the enemy from the scene


func _on_hurt_player_body_exited(body):
	player_attack = false
	player_chase = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Check if the body is the player
		if body.has_method("take_damage"):
			body.take_damage(5)  # Deal damage
			print("Player hurt! Dealing 5 damage")

func _on_area_2d_body_exited(body: Node2D) -> void:
	# Logic when the attack area exits
	player_attack = false
	player_chase = true
