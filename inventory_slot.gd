extends Control


@onready var icon = $ColorRect/ItemIcon
@onready var quantityLabel = $ColorRect/ItemQuantity
@onready var detailsPanel = $DetailsPanel
@onready var itemName =$DetailsPanel/itemName
@onready var itemType = $DetailsPanel/itemType
@onready var itemEffect = $DetailsPanel/itemEffect
@onready var UsagePanel =$UsagePanel

var item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		$Button.size.x = 100
		$Button.size.y = 100
		

func _on_item_button_mouse_entered():
	print("heri")
	if item!= null:
		print("coppo")
		UsagePanel.visible = false
		detailsPanel.visible = true

func _on_item_button_mouse_exited():
		detailsPanel.visible = false


func _on_item_button_pressed():
	print("goewifoie")
	if item!= null:
		UsagePanel.visible = !UsagePanel.visible




func setEmpty():
	icon.texture =null
	quantityLabel.text = ""
	
func setItem(newItem):
	item = newItem

	icon.texture = item["texture"]
	quantityLabel.text = str(item["quantity"])
	itemName.text =  str(item["name"])
	itemType.text = str(item["type"])
	itemEffect.text = str(item["effect"])


func _on_use_button_pressed():
	$UsagePanel.visible = false
	if item != null:
		if Global.player_node:
			Global.player_node.applyEffect(item["effect"])
