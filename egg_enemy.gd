extends CharacterBody2D

var speed = 250  
var player_chase = false
var idle_timer = 0  
var chasing_after_idle = false  
var player = null
var player_attack = false
var invis = false
var health = 1  # Health of the enemy

func _physics_process(delta):
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

func _on_area_2d_body_shape_exited(body):
	if body.is_in_group("player"):
		player = null
		player_chase = false
		chasing_after_idle = false 

func _on_area_2d_body_entered(body):
	print("ChasingPlayer!")
	if body.is_in_group("player"):
		player = body
		idle_timer = 1  
		chasing_after_idle = true  
		print(int(idle_timer))  

# Function to handle taking damage
func take_damage(amount):
	health -= amount  # Reduce health by the damage amount
	print("Egg enemy took damage, health now:", health)
	if health <= 0:
		die()  # Call die if health is zero or less

# Function to handle enemy death
func die():
	print("Egg enemy has died")
	queue_free()  # Remove the enemy from the scene
