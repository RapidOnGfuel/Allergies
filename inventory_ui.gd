extends Control

@onready var gridContainer = $GridContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.inventory_updated.connect(onInventoryUpdated)
	onInventoryUpdated()

func onInventoryUpdated():
	clearGridContainer()
	for item in Global.inventory:
		var slot = Global.inventorySlotScene.instantiate()
		gridContainer.add_child(slot)
		if item != null:
			slot.setItem(item)
		else:
			slot.setEmpty()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func clearGridContainer():
	while gridContainer.get_child_count() > 0:
		var child = gridContainer.get_child(0)
		gridContainer.remove_child(child)
		child.queue_free()
