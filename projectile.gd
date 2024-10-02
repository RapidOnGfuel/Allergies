extends Area2D

# Variables for projectile speed, target, and homing behavior
var speed = 300
var target_position = Vector2.ZERO
var homing_strength = 0.05 # Adjust this for how strong the homing is
var is_homing = true
var lifetime = 5 # Time before the projectile is deleted

func _ready():
	$Sprite2D.texture = load("res://dildo.png")
	# Use await to delete the projectile after its lifetime
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta):
	if is_homing:
		# Gradually turn towards the target (homing behavior)
		var direction_to_target = (target_position - global_position).normalized()
		global_position += direction_to_target * speed * delta
	else:
		# Move in a straight line if not homing
		global_position += (target_position - global_position).normalized() * speed * delta
