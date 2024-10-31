extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var chasing = false
var exploding = false
var canMove = true
@onready var player = get_node("../Player")
var ShrapnelScene = preload("res://nut_shrapnel.tscn")
func _ready():
	$AnimatedSprite2D.play("Idle")
func _physics_process(delta):

	# Add the gravity.
	movement(delta)



func movement(delta):
	if chasing && canMove:
		print("hi")
		var direction = (player.position - self.position).normalized()
		velocity.x = direction.x * SPEED 
		velocity.y = direction.y * SPEED 
		move_and_slide()


func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		chasing = true


func _on_start_detonation_timer_area_body_entered(body):
	if body.is_in_group("player"):
		if !exploding:
			exploding = true
			$AnimatedSprite2D.play("Detonate")
			await get_tree().create_timer(2.0).timeout
			canMove = false
			await get_tree().create_timer(1.0).timeout
			explode()
func explode():
	$AnimatedSprite2D.play("explode")
	await get_tree().create_timer(0.1).timeout
	queue_free()
	var rng =  RandomNumberGenerator.new()
	var ShrapnelAmount = rng.randi_range(4, 6)
	var i = 0
	var staticDegrees = 360/ShrapnelAmount
	while (i < ShrapnelAmount):
		i += 1
		var randomDegreeModifer = rng.randi_range(-20, 20)
		print(randomDegreeModifer)
		createShrapnel(staticDegrees * i + randomDegreeModifer)
func createShrapnel(degrees):
	var theta = (degrees * 3.14)/180

	var shrapnel = ShrapnelScene.instantiate()
	get_parent().add_child(shrapnel)
	shrapnel.position = self.position
	shrapnel.direction.x = cos(theta)
	shrapnel.direction.y = sin(theta)


func _on_timer_timeout():
	pass
