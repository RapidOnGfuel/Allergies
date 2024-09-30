extends CharacterBody2D

var speed = 250  
var player_chase = false
var player = null
var idle_timer = 0  
var chasing_after_idle = false  
var player_attack = false 
var attack_damage = 10  # Define attack damage

func _physics_process(delta):
	if player_chase:
		position += (player.position - position).normalized() * speed * delta
		$AnimatedSprite2D.play("walking")
		$AnimatedSprite2D.flip_h = player.position.x < position.x  # Correct flipping condition
	else:
		if chasing_after_idle:
			idle_timer -= delta
			if idle_timer <= 0:
				chasing_after_idle = false 
				player_chase = true  
				print("Chasing!")
		else:
			$AnimatedSprite2D.play("idle")

	# Check if the enemy is attacking
	if player_attack:
		$AnimatedSprite2D.play("attack")
		print("Attacking!")  # Print statement to confirm attacking
	else:
		if not player_chase and not chasing_after_idle:
			player_attack = false

func _on_detection_area_body_entered(body):
	player = body
	player_chase = false  
	idle_timer = 1
	chasing_after_idle = true  
	print(int(idle_timer))  

func _on_detection_area_body_exited(body):
	if player == body:  # Only reset if the exiting body is the current player
		player = null
		player_chase = false
		chasing_after_idle = false 
		player_attack = false  

func _on_hurt_player_body_entered(body):
	player = body
	if body.has_method("take_damage"):  # Assuming your player has a method for taking damage
		body.take_damage(attack_damage)  # Deal damage
		player_attack = true  # Trigger attack animation
		print("Attacking! Damage dealt: ", attack_damage)  # Print statement for damage dealt

func _on_hurt_player_body_exited(body: Node2D) -> void:
	if player == body:
		player_attack = false  # Stop attacking when the player exits the hurt area
		$AnimatedSprite2D.play("idle")  # Switch back to idle animation
