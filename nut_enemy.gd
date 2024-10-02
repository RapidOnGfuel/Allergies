extends CharacterBody2D

var speed = 250
var player_chase = false
var player = null
var idle_timer = 0
var chasing_after_idle = false
var player_attack = false
<<<<<<< HEAD

func _physics_process(delta):
	if player_attack:
		
		$AnimatedSprite2D.play("attack")
	elif player_chase:
		
		position += (player.position - position).normalized() * speed * delta
		$AnimatedSprite2D.play("walking")
		
		
		$AnimatedSprite2D.flip_h = player.position.x > position.x
=======
var firing_cooldown = 2.0 # Time between firing projectiles
var firing_timer = 0.0 # Tracks time since last projectile
var projectile_timer = 0.0 # Timer for projectile behavior

# Reference to the projectile scene
var projectile_scene = preload("res://Projectile.tscn") # Adjust the path to the correct location

func _physics_process(delta):
	if player != null:
		# Check if the projectile is still in flight
		if projectile_timer > 0:
			projectile_timer -= delta
		else:
			# The projectile has completed its flight
			if player_chase:
				position += (player.position - position).normalized() * speed * delta
				$AnimatedSprite.play("walking")
				$AnimatedSprite.flip_h = player.position.x > position.x
		# Check if we can fire
		if firing_timer <= 0 and projectile_timer <= 0:
			fire_projectile()
			firing_timer = firing_cooldown

>>>>>>> 8ada51c97544ddce8140cc70534d8fb0668c10a0
	else:
		if chasing_after_idle:
			# Idle before chasing
			idle_timer -= delta
			print(int(idle_timer))

			if idle_timer <= 0:
				chasing_after_idle = false
				player_chase = true
				print("Chasing!")
		else:
			$AnimatedSprite.play("idle")

<<<<<<< HEAD
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	idle_timer = 3
	chasing_after_idle = true
	print(int(idle_timer))
	player_attack = false
=======
func fire_projectile():
	# Check if we have a player to fire at
	if player == null:
		return

	# Instantiate a new projectile
	var projectile = projectile_scene.instance()

	# Set the projectile's starting position to the enemy's position
	projectile.global_position = global_position

	# Set the projectile's target to the player's current position
	projectile.target_position = player.position

	# Enable homing behavior for the projectile
	projectile.is_homing = true

	# Add the projectile to the scene tree
	get_parent().add_child(projectile)

	# Set the projectile timer to indicate it is flying
	projectile_timer = 1.5 # Duration for the projectile to fly before enemy chases

# When the player enters the detection area, start firing
func _on_detection_area_body_entered(body):
	if body.name == "Player": # Make sure it's the player
		player = body
		player_chase = false # Do not chase immediately
		idle_timer = 1
		chasing_after_idle = true
		print("Player entered firing range")
>>>>>>> 8ada51c97544ddce8140cc70534d8fb0668c10a0

# When the player exits the detection area, stop firing
func _on_detection_area_body_exited(body):
<<<<<<< HEAD
	player = null
	player_chase = false
	chasing_after_idle = false
	player_attack = false
=======
	if body.name == "Player":
		player = null
		player_chase = false
		chasing_after_idle = false
		print("Player exited firing range")
>>>>>>> 8ada51c97544ddce8140cc70534d8fb0668c10a0

func _on_hurt_player_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(5)
		player_attack = true  
		print("Attacking, dealing 5 damage")
		player_chase = false

func _on_hurt_player_body_exited(body):
	player_attack = false
<<<<<<< HEAD
	player_chase = true 


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
=======
	player_chase = true
>>>>>>> 8ada51c97544ddce8140cc70534d8fb0668c10a0
