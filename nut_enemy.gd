extends CharacterBody2D

var speed = 250  
var player_chase = false
var player = null
var idle_timer = 0  
var chasing_after_idle = false  

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

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player_chase = false  
		idle_timer = 1  
		chasing_after_idle = true  
		print(int(idle_timer))  

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player = null
		player_chase = false
		chasing_after_idle = false  


func _on_nut_attack_body_entered(body):
	if body.is_in_group("player"):
		player = body


func _on_nut_attack_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
