extends Node2D

# Variables for projectile speed, target, and homing behavior
var speed = 300
var target_position = Vector2.ZERO
var homing_strength = 0.05 # Adjust this for how strong the homing is
var is_homing = true
var lifetime = 5 # Time before the projectile is deleted
@onready var player = get_node("../Player")
func _ready():

	# Use await to delete the projectile after its lifetime
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta):
	if is_homing:
		# Gradually turn towards the target (homing behavior)
		var direction_to_target = (player.position - position).normalized() 
		position += direction_to_target * speed * delta
	else:
		# Move in a straight line if not homing
		position += (target_position - global_position).normalized() * speed * delta
