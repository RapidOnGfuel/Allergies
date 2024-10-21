extends Node2D

# The speed of the bullet
var speed = 600
# The position the bullet is aiming at
var target_position: Vector2
# The path to the bullet texture
var bullet_texture_path = "res://mcweenie.png"

@onready var sprite = $Sprite2D

func _ready():
	# Load the bullet texture from the specified path
	var texture = load(bullet_texture_path)
	if texture:
		sprite.texture = texture
		# Resize the sprite to be 1/16th of its original size
		sprite.scale = Vector2(0.0625, 0.0625)  # 1/16th scale
	else:
		print("Error: Could not load bullet texture at path:", bullet_texture_path)

func _process(delta):
	if target_position:
		# Calculate the direction to move toward the target
		var direction = (target_position - global_position).normalized()
		# Move the bullet in the direction of the target
		global_position += direction * speed * delta

		# Check if the bullet has reached or passed its target (using a small threshold)
		if global_position.distance_to(target_position) < 10:
			queue_free()  # Remove the bullet from the scene




func _on_area_2d_body_entered(body):
	# Check if the bullet hits an egg_enemy
	if body.name == "egg_enemy":
		# If the bullet hits the enemy, deal 2 damage
		body.take_damage(10)  # Deal 2 damage
		print("Egg enemy hit by bullet!")
		queue_free()
