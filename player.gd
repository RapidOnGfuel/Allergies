extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var input = Vector2.ZERO
var friction = 1000
var accel = 2000
var max_speed = 400
var stamina = 100
var sprinting = false
var oneTimeSprint = true

func _physics_process(delta):
	print(stamina)
	if stamina <0:
		stamina = 0
	elif stamina > 100:
		stamina = 100
	player_movement(delta)

func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if (Input.is_action_pressed("Sprint") && stamina > 0):
		sprinting = true
		max_speed = 800
	elif (Input.is_action_just_released("Sprint") || stamina == 0):
		sprinting = false
		max_speed = 400
	return input.normalized()

func player_movement(delta):
	input = get_input()
	
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
			
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
		
	move_and_slide()



func _on_stamina_timeout():
		if sprinting == true:
			stamina -= 1
		else:
			stamina += 1
		if stamina == 0:
			$Stamina.stop()
			await get_tree().create_timer(3.0).timeout
			$Stamina.start()