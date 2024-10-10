extends Node

var inventory = []
# Called when the node enters the scene tree for the first time.

@onready var inventorySlotScene = preload("res://inventory_slot.tscn")

signal inventory_updated

var player_node: Node = null

func _ready():
	inventory.resize(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addItem(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["name"] == item["name"]:
			print("heuiw")

			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			return true
		elif inventory[i] == null:
			inventory[i] = item	
			inventory_updated.emit()
			return true
		return false
func removeItem():
	inventory_updated.emit()

func setPlayerReference(player):
	player_node = player
