
extends "res://Scripts/NpcSpecial.gd"

export var work_frequency: float = 5.0

var cancel_next: bool = false
var working: bool = false

var player

var item_to_consume
var amount_to_consume

var item_to_offer
var work_time: float = 0

func _ready():
	randomize()
	._ready()
	var f = randf()
	if f < 0.10:
		item_to_offer = "pen"
	elif f < 0.50:
		item_to_offer = "eraser"
	else:
		item_to_offer = "pencil"
		
	f = randf()
	if f < 0.20:
		item_to_consume = "food"
	else:
		item_to_consume = "clip"
	amount_to_consume = round(rand_range(2, 6))

func _process(delta):
	if camera == null:
		z_index = position.y / 128
	else:
		if abs(position.y - camera.position.y) < 3000:
			z_index = position.y - camera.position.y

	if working:
		work_time += delta
		if work_time >= work_frequency:
			if self.player != null:
				if player.inventory.get_count(item_to_consume) >= amount_to_consume:
					player.inventory.remove(item_to_consume, amount_to_consume) 
					player.inventory.add(item_to_offer, 1)
				work_time -= work_frequency

func get_start_conversation(player) -> String:

	cancel_next = false
	return str("I'm addicted to [color=red]", Items.pluralize(item_to_consume, 2), "[/color]. If you could be my supplier, I'll pay you with [color=green]",
			Items.prefix_amount(item_to_offer, 1), "[/color] for every [color=red]", Items.prefix_amount(item_to_consume, amount_to_consume), "[/color] you supply! Deal?")

func response(player, stage: int, accepted: bool):
	if cancel_next:
		emit_signal("respond", END_CONV)
		if working:
			set_process(true)
			add_to_group("DontDisable")
			self.player = player
	elif stage == 0:
		if accepted:
			emit_signal("respond", str(
				"I hope partnership never ends!"
			))
			working = true
			can_converse = false
			cancel_next = true
		else:
			emit_signal("respond", "You sure? I could really use some [color=red]", Items.pluralize(item_to_consume, 2), "[/color]... Please, I'm desperate!")
			cancel_next = true
	else:
		emit_signal("respond", END_CONV)