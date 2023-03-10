extends ColorRect

@onready var lbl_name = $LabelName
@onready var lbl_desription = $LabelDescription
@onready var lbl_level = $LabelLevel
@onready var itemIcon = $ColorRect/TextureRect

@onready var player = get_tree().get_first_node_in_group("player")

var mouse_over = false
var item = null

signal selected_upgrade(upgrade)


func _ready():
	connect("selected_upgrade", Callable(player, "upgrade_character"))
	if item == null:
		item = "food"
	lbl_name.text = UpgradeDb.UPGRADES[item]["displayname"]
	lbl_desription.text = UpgradeDb.UPGRADES[item]["details"]
	lbl_level.text = UpgradeDb.UPGRADES[item]["level"]
	itemIcon.texture = load(UpgradeDb.UPGRADES[item]["icon"])


func _input(event):
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade", item)


func _on_mouse_entered():
	mouse_over = true


func _on_mouse_exited():
	mouse_over = false
