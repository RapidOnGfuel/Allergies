extends Sprite2D

var go
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(5.0).timeout
	go = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if go:
		position.x += 50
