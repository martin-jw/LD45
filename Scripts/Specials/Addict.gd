
extends "res://Scripts/NpcSpecial.gd"

var cancel_next: bool = false
var working: bool = false

var item_to_consume
var amount_to_consume

var item_to_offer

var possible_combinations: Array = [
	["clip", "pencil"],
	["clip", "eraser"],
	["food", "eraser"],
	["food", "pencil"],
	["pencil", "pen"],
	["eraser", "pen"],
	["pen", "stapler"],
	["pen", "binder"],
	["stapler", "binder"],
	["binder", "stapler"],
	["binder", "desk"],
	["stapler", "desk"],
	["desk", "office"],
	["office", "room"],
	["job", "room"],
	["room", "apartment"],
	["apartment", "penthouse"],
]

func _ready():
	randomize()
	._ready()
	
	var ind = randi() % possible_combinations.size()
	var comb = possible_combinations[ind]

	item_to_offer = comb[1]
	item_to_consume = comb[0]
	amount_to_consume = round(rand_range(2, 5))

func _process(delta):
	if camera == null:
		z_index = position.y / 128
	else:
		if abs(position.y - camera.position.y) < 3000:
			z_index = position.y - camera.position.y

func get_start_conversation(player) -> String:

	cancel_next = false
	if player.inventory.get_count(item_to_offer) < (6 - amount_to_consume):
		cancel_next = true
		return str("Go away, I'm busy! Talk to me when you got some more [color=red]", Items.pluralize(item_to_offer, 2), "[/color] at hand.")
	else:
		return str("I really need [color=red]", Items.pluralize(item_to_consume, 2), "[/color]. If you could be my supplier, I'll pay you with [color=green]",
			Items.prefix_amount(item_to_offer, 1), "[/color] for every [color=red]", Items.prefix_amount(item_to_consume, amount_to_consume), "[/color] you supply! Deal?")

func response(player, stage: int, accepted: bool):
	print("responding")
	print(stage)
	if cancel_next:
		emit_signal("respond", END_CONV)
		if working:
			player.add_trade(item_to_consume, amount_to_consume, item_to_offer)
	elif stage == 0:
		print("We're here!")
		if accepted:
			emit_signal("respond", str(
				"I hope our partnership never ends!"
			))
			working = true
			can_converse = false
			traded = true
			cancel_next = true
		else:
			emit_signal("respond", str("You sure? I could really use some [color=red]", Items.pluralize(item_to_consume, 2), "[/color]... Please, I'm desperate!"))
			cancel_next = true
	else:
		emit_signal("respond", END_CONV)