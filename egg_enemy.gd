extends CharacterBody2D

var speed = 250  
var player_chase = false
var idle_timer = 0  
var chasing_after_idle = false  
var player = null
var player_attack = false
var invis =  false


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
	#if body.name == "Player":
	print("ChasingPlayer!")
	if body.is_in_group("player"):
		player = body
		idle_timer = 1  
		chasing_after_idle = true  
		print(int(idle_timer))  
		
func _on_Attack_Radius_2d_body_entered(body):
	#yabadabado
	print("Attacking Player")
	if body.has_method("take_damage"):
		body.take_damage(10)
		player_attack = true  
		print("Attacking, dealing 10 damage")
		player_chase = false
		await get_tree().create_timer(3.0).timeout
		player_chase = true
