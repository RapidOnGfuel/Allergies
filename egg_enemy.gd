extends CharacterBody2D

var speed = 200  
var player_chase = false
var idle_timer = 0  
var chasing_after_idle = false  
var invis = false
var health = 100  # Health of the enemy
@onready var player = get_node("../Player")


func _physics_process(delta):
	if player_chase:
		position += (player.position - position).normalized() * speed * delta
		$AnimatedSprite2D.play("egg_walking")
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
			$AnimatedSprite2D.play("egg_idle")

	

func _on_area_2d_body_entered(body):
	print("ChasingPlayer!")
	if body.is_in_group("player"):
		player_chase = true
		idle_timer = 2 
		chasing_after_idle = true  
	
		

# Function to handle taking damage
func take_damage(amount):
	if invis == false:
		health -= amount  # Reduce health by the damage amount
		print("Egg enemy took damage, health now:", health)
		if health <= 0:
			die()  # Call die if health is zero or less
		invis = true
		await get_tree().create_timer(0.75).timeout
		invis = false

# Function to handle enemy death
func die():
	print("Egg enemy has died")
	queue_free()  # Remove the enemy from the scene
	


func _on_area_2d_2_body_entered(body):
	if body.has_method("take_damage"):
		$AnimatedSprite2D.play("egg_Attacking")
		player_chase=false
		await get_tree().create_timer(1.0).timeout
		player_attack();


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_chase = false
		chasing_after_idle = false 
		
func player_attack():
	$attackHitbox/CollisionShape2D.disabled = false
	await get_tree().create_timer(1.0).timeout
	$attackHitbox/CollisionShape2D.disabled = true



func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	print("Hit")
	player.take_damage(10)
