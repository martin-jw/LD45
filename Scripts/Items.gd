extends Node

var item_names: Dictionary = {
	"clip": "paperclip",
	"pencil": "pencil",
	"eraser": "eraser",
	"pen": "pen",
	"food": "food",
	"stapler": "stapler",
	"binder": "binder",
	"job": "job",
	"room": "room",
	"clothes_basic": "basic clothes",
	"clothes_formal": "suit",
	"apartment": "apartment",
	"penthouse": "penthouse",
	"villa": "villa",
	"mansion": "mansion",
	"bike": "bike",
	"car": "car",
	"helicopter": "helicopter",
	"yacht": "yacht",
	"building": "building",
	"company": "company",
	"store": "store"
}

var clothes_levels: Dictionary = {
	"clothes_basic": 1,
	"clothes_formal": 2
}

var trades: Dictionary = {
	"pencil": {
		"normal": {
			"received": range(1, 4),
			"min_items": 1,
			"items": { "clip": range(3, 8) }  
		},
		"cheap": {
			"received": range(1, 3),
			"min_items": 1,
			"items": { "clip": range(1, 2) }
		}
	},
	"eraser": {
		"normal": {
			"received": range(1, 4),
			"min_items": 1,
			"items": { "pencil": range(1, 6), "clip": range(2, 9),  }
		},
		"cheap": {
			"received": range(1, 4),
			"min_items": 1,
			"items": { "pencil": range(1, 4), "clip": range(4, 9)}
		}
	},
	"pen": {
		"normal": {
			"received": range(1, 3),
			"min_items": 2,
			"items": { "eraser":  range(1, 4), "pencil": range(1, 6)}
		},
		"cheap": {
			"received": range(1, 3),
			"min_items": 1,
			"items": { "eraser":  range(1, 4), "pencil": range(1, 4) }
		}
	},
	"clothes_basic": {
		"normal": {
			"received": [1],
			"min_items": 3,
			"items": { "food": range(1, 4), "clip": range(0, 10), "pencil": range(0, 3) }
		}
	},
	"stapler": {
		"normal": {
			"received": [1],
			"min_items": 3,
			"items": { "pen": range(1, 5), "pencil": [0, 0, 0, 0, 0] + range(1, 6), "eraser": [0, 0, 0, 0] + range(1, 3)}
		}
	},
	"binder": {
		"normal": {
			"received": range(1, 2),
			"min_items": 3,
			"items": {"pen": range(1, 5), "stapler": range(1, 3), "pencil": range(0, 4), "eraser": range(0, 3)}
		}
	}
}
var vocals = ["a", "e", "i", "y", "o", "u"]
func prefix_amount(item, count):
	var name = item_names[item]
	if count == 1:
		if item == "clothes_basic":
			return name
		if item == "food":
			return name
		else:
			if vocals.has(name.substr(0, 1).to_lower()):
				return str("an ", name)
			else:
				return str("a ", name)
	else:
		return str(count, " ", pluralize(item, count))

func pluralize(item, count):
	if count <= 1:
		return item_names[item]
	else:
		if item == "food":
			return item_names[item]
		return item_names[item] + "s"

var item_textures: Dictionary = {
	"clip": preload("res://Textures/Items/paperclip.png"),
	"pencil": preload("res://Textures/Items/pencil.png"),
	"eraser": preload("res://Textures/Items/eraser.png"),
	"pen": preload("res://Textures/Items/pen.png"),
	"food": preload("res://Textures/Items/food.png"),
	"stapler": preload("res://Textures/Items/stapler.png"),
	"binder": preload("res://Textures/Items/binder.png"),
}

var item_prompts: Dictionary = {
	"clip": [
		["My paperwork is a mess, if you could get me ", " then I'll be willing to part with my ", "."],
		["Quick! I really need ", ". I'll give you ", ". Please, it's an emergency!"],
		["Please, I need my fix! Give me ", ", you'd be my savior! I can trade you ", "."],
		["Have you heard what happens when you put ", " into a time machine? It turns into ", ". Wanna try?"]
	],
	"eraser": [
		["I have problems that need erasing. Get me ", " and I'll get you ", "."],
		["You know what tastes great? ", ". If you can get that to me, I have ", ". Those are not as tasty."],
		["", "! Quickly! You can have my ", " in return."],
	],
	"pencil": [
		["First, give me ", ". Then, I give you ", ". Profit."],
		["I have a test in like 10 minutes! Please, I really need ", ". I can give you ", "!"],
		["Have you heard what happens when you put ", " into a time machine? It turns into ", ". Wanna try?"],
		["Can I have ", "? I especially like the lead in the pencils. Mommy says I shouldn't eat it, but I do it anyways. I can trade you ", "."]
	],
	"pen": [
		["I got important contracts to sign, but I can't do it without ", ". Give it to me, and I'll get you ", "."],
		["Quick! I really need ", ". I'll give you ", ". Please, it's an emergency!"],
		["Have you heard what happens when you put ", " into a time machine? It turns into ", ". Wanna try?"],
		["Haha! Ink! I need ink! Get me ", " so I can have some wonderful ink! You can have ", " that I have been saving for college."]
	],
	"food": [
		["I'm starving! If you could spare ", " I will give you ", ". Please!"],
		["Quick! I really need ", ". I'll give you ", ". Please, it's an emergency!"],
		["Hey, I'm in the middle of a game jam! Can I please have some ", " so I can get back to work? I will give you ", " in return."]
	],
	"stapler": [
		["My mom said I couldn't have a nail gun, so now I'm out looking for ", " instead. If you have what I want, I can trade you ", ". They're no fun."],
		["Please, I need my fix! Give me ", ", you'd be my savior! I can trade you ", "."],
	],
	"binder": [
		["I'm performing a ritual of demonic binding, so naturally I need ", ". I'd give you a piece of the demon for it, but that's too much effort. You can have ", " instead."],
		["First, give me ", ". Then, I give you ", ". Profit."],
		["I need ", ". You need ", "."]
	]
}