extends "res://Scripts/Npc.gd"

signal conversation_started(converser, text)
signal respond(text)

const END_CONV = "END"

var can_converse: bool = true

func get_start_conversation(player) -> String:
	return "HI!"

func interact(player: Player):
	if can_converse:
		trading = true
		player.trading = true
		emit_signal("conversation_started", self, get_start_conversation(player))
	
func response(player, stage: int, accepted: bool):
	if stage == 0:
		if accepted:
			emit_signal("respond", "Pleasure to meet you!".to_upper())
		else:
			emit_signal("respond", "Okay...".to_upper())
	else:
		emit_signal("respond", END_CONV)

func _ready():
	._ready()
	remove_from_group("NPC")
	rect.color = Color.black
	set_physics_process(false)
	set_process(false)

func _process(delta):
	set_physics_process(false)
	if camera == null:
		z_index = position.y / 128
	else:
		z_index = position.y - camera.position.y
	