extends CharacterBody2D

var speed = 250
var player_chase = false
var player = null
var idle_timer = 0
var chasing_after_idle = false
var player_attack = false

func _physics_process(delta):
	if player_attack:
		
		$AnimatedSprite2D.play("attack")
	elif player_chase:
		
		position += (player.position - position).normalized() * speed * delta
		$AnimatedSprite2D.play("walking")
		
		
		$AnimatedSprite2D.flip_h = player.position.x > position.x
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
			$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body):
	player = body
	player_chase = false
	idle_timer = 3
	chasing_after_idle = true
	print(int(idle_timer))

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	chasing_after_idle = false
	player_attack = true

func _on_hurt_player_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(10)
		player_attack = true  
		print("Attacking, dealing 10 damage")
		player_chase = true

func _on_hurt_player_body_exited(body):
	player_attack = false
	player_chase = true 
