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

var trades: Dictionary = {
    "pencil": {
        "normal": {
            "received": range(1, 4),
            "min_items": 1,
            "items": { "clip": range(3, 8), "eraser": range(1, 2) }  
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
            "items": { "pencil": range(1, 6), "pen": range(0, 2) }
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
            "items": { "eraser":  range(1, 4), "pencil": range(1, 6) }
        },
        "cheap": {
            "received": range(1, 3),
            "min_items": 1,
            "items": { "eraser":  range(1, 4), "pencil": range(1, 4) }
        }
    }
}

var item_textures: Dictionary = {
    "clip": preload("res://Textures/Items/paperclip.png"),
    "pencil": preload("res://Textures/Items/pencil.png"),
    "eraser": preload("res://Textures/Items/eraser.png"),
    "pen": preload("res://Textures/Items/pen.png")
}