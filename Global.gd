extends Node

var inventory = []
# Called when the node enters the scene tree for the first time.

signal inventory_updated

var player_node: Node = null

func _ready():
	inventory.resize(10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addItem():
	inventory_updated.emit()
	
func removeItem():
	inventory_updated.emit()

func setPlayerReference(player):
	player_node = player
