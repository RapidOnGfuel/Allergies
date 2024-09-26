@tool
extends Node2D

@export var item_type = ""
@export var item_name = ""
@export var item_texture = Texture
@export var item_effect = ""
var scene_path: String ="res://inventory_item.tscn"

var playerIsInRange = false

@onready var icon_sprite = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
	if playerIsInRange and Input.is_action_just_pressed("pickUpItem"):
		print("pressed")
		pickup_item()

func pickup_item():
	var item = {
		"quantity" = 1,
		"type" = item_type,
		"name" = item_name,
		"texture" = item_texture,
		"effect" = item_effect,
		"scene_path" = scene_path
	}
	if Global.player_node:
		Global.addItem(item)
		self.queue_free()




func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		playerIsInRange = true
		body.interactUI.visible = true



func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		playerIsInRange = false
		body.interactUI.visible = false	
