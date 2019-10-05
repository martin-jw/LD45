extends "res://Scripts/NpcSpecial.gd"

var cancel_next: bool = false
var give_job: bool = false

func get_start_conversation(player) -> String:

    cancel_next = false
    if player.clothes_level < 1:
        cancel_next = true
        return str("At least get some [color=red]", Items.item_names["clothes_basic"], 
        "[/color] before applying for [color=green]", Items.prefix_amount("job", 1), "[/color]!")
    else:
        return str("So you're looking for [color=green]", Items.prefix_amount("job", 1), "[/color], huh? Well, I got one for you.",
            " You want it?")

func response(player, stage: int, accepted: bool):
    if cancel_next:
        emit_signal("respond", END_CONV)
        if give_job:
            player.inventory.add("job", 1)
    elif stage == 0:
        if accepted:
            emit_signal("respond", str(
                "Just sign the contract with [color=red]", Items.prefix_amount("pen", 1), "[/color], no ", Items.pluralize("pencil", 2), " here!"
            ))
        else:
            emit_signal("respond", "Fine then...")
            cancel_next = true
    elif stage == 1:
        if accepted:
            if player.inventory.get_count("pen") == 0:
                emit_signal("respond", str(
                    "You don't have [color=red]", Items.prefix_amount("pen", 1), "[/color]?! Come back when you got one!"
                ))
                cancel_next = true
            else:
                emit_signal("respond", "You're hired!")
                give_job = true
                can_converse = false
                cancel_next = true
        else:
            emit_signal("respond", "You need to sign the contract to get the job!")
            cancel_next = true
    else:
        emit_signal("respond", END_CONV)