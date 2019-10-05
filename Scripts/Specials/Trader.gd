extends "res://Scripts/NpcSpecial.gd"

export var work_frequency: float = 5.0

var cancel_next: bool = false
var working: bool = false

var item_to_offer

func _ready():
	._ready()
	var f = randf()
	if f < 0.1:
		item_to_offer = "pencil"
	elif f < 0.30:
		item_to_offer = "food"
	else:
		item_to_offer = "clip"

func get_start_conversation(player) -> String:

	cancel_next = false
	return str("I hate being unemployed. If you could get me [color=red]", Items.prefix_amount("job", 1), 
	"[/color] I'd be forever in your debt. Maybe I could repay you with a steady stream of [color=green]", Items.pluralize(item_to_offer, 2), "[/color]?")

func response(player, stage: int, accepted: bool):
	if cancel_next:
		emit_signal("respond", END_CONV)
		if working:
			player.inventory.remove("job", 1)
			player.add_item_per_second(item_to_offer, 1.0 / work_frequency)
	elif stage == 0:
		if accepted:
			if player.inventory.get_count("job") > 0:
				emit_signal("respond", str(
					"Really?! Awesome! You won't regret it."
				))
				working = true
				can_converse = false
			else:
				emit_signal("respond", str(
					"Oh, you're unemployed too? It sucks, doesn't it?"
				))
			cancel_next = true
		else:
			emit_signal("respond", "Oh, okay...")
			cancel_next = true
	else:
		emit_signal("respond", END_CONV)