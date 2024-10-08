extends CharacterBody2D

var health = 100
var bullet_scene = preload("res://Bullet.tscn")  # Load the bullet scene (make sure you have a Bullet scene)
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var input = Vector2.ZERO
var friction = 1000
var accel = 2000
var max_speed = 400
var stamina = 100
var sprinting = false
var oneTimeSprint = true
var invis = false
@onready var interactUI = $CanvasLayer/ColorRect
@onready var inventoryUI = $InventoryUI

func _ready():
	Global.setPlayerReference(self)

func _physics_process(delta):
	$CanvasLayer/ProgressBar2.value = health  
	
	if Input.is_action_just_released("openInventory"):
		inventoryUI.visible = !inventoryUI.visible
	
	if stamina > 0 and sprinting == false:
		max_speed = 400
		
	if stamina < 0:
		stamina = 0
	elif stamina > 100:
		stamina = 100
		
	player_movement(delta)

func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if Input.is_action_pressed("Sprint") and stamina > 0:
		if stamina <= 0:
			max_speed = 240
		else:
			sprinting = true
			max_speed = 800
	elif Input.is_action_just_released("Sprint") or stamina == 0:
		sprinting = false
		if stamina <= 0 and max_speed != 100:
			max_speed = 240
		else:
			max_speed = 400
	
	return input.normalized()

func player_movement(delta):
	input = get_input()
	
	if input.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
		
	move_and_slide()

func take_damage(amount):
	if invis == false:
		health -= amount
		print("Player took %d damage, health now: %d" % [amount, health])
		if health <= 0:
			die()
		invis = true
		await get_tree().create_timer(2.0).timeout
		invis = false

func die():
	print("Player has died")

func _on_stamina_timeout():
	if sprinting:
		stamina -= 10
	else:
		stamina += 10
	if stamina <= 0:
		print("Stamina depleted!")
		$Stamina.stop()
		await get_tree().create_timer(3.0).timeout
		$Stamina.start()

# Handle mouse click to shoot a bullet
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		shoot_bullet(event.position)

func shoot_bullet(target_position: Vector2):
	# Create a new bullet instance
	var bullet = bullet_scene.instantiate()  # Use instantiate() instead of instance()

	# Set the bullet's starting position to the player's current position
	bullet.global_position = global_position

	# Pass the target position (where the player clicked) to the bullet
	bullet.target_position = target_position

	# Add the bullet to the scene
	get_parent().add_child(bullet)



#Does nothing for now
func applyEffect(effect):
	max_speed = 800
