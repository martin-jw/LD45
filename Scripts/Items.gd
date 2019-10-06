extends Node

var item_names: Dictionary = {
	"clip": "paperclip",
	"pencil": "pencil",
	"eraser": "eraser",
	"pen": "pen",
	"food": "food",
	"stapler": "stapler",
	"binder": "binder",
	"desk": "desk",
	"office": "office",
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
	"city": "city",
	"company": "company",
	"store": "store"
}

var clothes_levels: Dictionary = {
	"clothes_basic": 1,
	"clothes_formal": 2
}

var trades: Dictionary = {
	"desk": {
		"normal": {
			"received": range(1, 4),
			"min_items": 2,
			"items": { "binder": range(1, 4), "stapler": range(1, 4) }
		}
	},
	"office": {
		"normal": {
			"received": range(1, 3),
			"min_items": 3,
			"items": { "desk": [1], "stapler": [0, 0] + range(0, 3), "binder": [0, 0] + range(0, 3)}
		}
	},
	"room": {
		"normal": {
			"received": [1],
			"min_items": 1,
			"items": {"office": [1], "job": [1]}
		}
	},
	"apartment": {
		"normal": {
			"received": [1],
			"min_items": 1,
			"items": {"room": range(2, 5)}
		}
	},
	"penthouse": {
		"normal": {
			"received": [1],
			"min_items": 1,
			"items": {"apartment": range(3, 6) }
		}
	},
	"building": {
		"normal": {
			"received": [1],
			"min_items": 2,
			"items": {"apartment": range(2, 6), "penthouse": [1]}
		}
	},
	"city": {
		"normal": {
			"received": [1],
			"min_items": 1,
			"items": {"building": range(10, 16)}
		}
	},
	"pencil": {
		"normal": {
			"received": range(2, 6),
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
			"received": range(2, 6),
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
			"received": range(1, 5),
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
			"received": range(1, 6),
			"min_items": 3,
			"items": { "pen": range(1, 5), "pencil": [0, 0, 0, 0, 0] + range(1, 6), "eraser": [0, 0, 0, 0] + range(1, 3)}
		}
	},
	"binder": {
		"normal": {
			"received": range(1, 5),
			"min_items": 3,
			"items": {"pen": range(1, 5), "stapler": range(1, 3), "pencil": range(0, 4), "food": range(0, 3)}
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
	"job": preload("res://Textures/Items/job.png"),
	"desk": preload("res://Textures/Items/desk.png"),
	"office": preload("res://Textures/Items/office.png"),
	"room": preload("res://Textures/Items/room.png"),
	"apartment": preload("res://Textures/Items/apartment.png"),
	"penthouse": preload("res://Textures/Items/penthouse.png"),
	"city": preload("res://Textures/Items/city.png"),
}

var item_prompts: Dictionary = {
	"clip": [
		["My paperwork is a mess, if you could get me ", " I'd be willing to part with ", "."],
		["Quick! I really need ", ". I'll give you ", ". Please, it's an emergency!"],
		["Please, I need my fix! Give me ", ", you'd be my savior! I can trade you ", "."],
		["Have you heard what happens when you put ", " into a time machine? It turns into ", ". Wanna try?"]
	],
	"eraser": [
		["I have problems that need erasing. Get me ", " and I'll get you ", "."],
		["You know what tastes great? ", ". If you can get that to me, I have ", ". Those are not as tasty."],
		["", "! Quickly! You can have ", " in return."],
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
		["Hey, I'm in the middle of a game jam! Can I please have ", " so I can get back to work? I will give you ", " in return."]
	],
	"stapler": [
		["My mom said I couldn't have a nail gun, so now I'm out looking for ", " instead. If you have what I want, I can trade you ", ". They're no fun."],
		["Please, I need my fix! Give me ", ", you'd be my savior! I can trade you ", "."],
	],
	"binder": [
		["I'm performing a ritual of demonic binding, so naturally I need ", ". I'd give you a piece of the demon for it, but that's too much effort. You can have ", " instead."],
		["First, give me ", ". Then, I give you ", ". Profit."],
		["I need ", ". You need ", "."]
	],
	"desk": [
		["First, give me ", ". Then, I give you ", ". Profit."],
		["I need ", ". You need ", "."],
		["Quick! I really need ", ". I'll give you ", ". Please, it's an emergency!"],
	],
	"office": [
		["I'm looking to start a new company, I could really use ", ". If you'd hook me up, I'd give you ", "."],
		["I really love this special TV show, it has inspired me to get ", ". I'd be willing to part with ", " for it."]
	],
	"job": [
		["I've been pretty down on my luck and could really do with ", ". I'll give you all I own: ", "."],
		["Quick! I really need ", ". I'll give you ", ". Please, it's an emergency!"],
		["I have problems that need erasing. Get me ", " and I'll get you ", "."]
	],
	"room": [
		["I got almost no storage space left. Get me ", " and I'll get you ", ". I'm not allowed to store things there."],
		["Hey, I'm moving to this city, so I really need ", ". You can have ", " in my hometown."],
	],
	"apartment": [
		["Quick! I really need ", ". I'll give you ", ". Please, it's an emergency!"],
		["Have you heard what happens when you put ", " into a time machine? It turns into ", ". Wanna try?"],
		["", "! Quickly! You can have ", " in return."],
		["First, give me ", ". Then, I give you ", ". Profit."],
	],
	"penthouse": [
		["I got so many buildings, but I would really love ", ". If you can get me that, I'll give you ", " of mine."],
		["Quick! I really need ", ". I'll give you ", ". Please, it's an emergency!"],
	],
	"building": [
		["I hate being mayor of a city, I knew I should've gone into real estate. Get me ", " and I'll give you ", "."],
		["First, give me ", ". Then, I give you ", ". Profit."],
	]
}