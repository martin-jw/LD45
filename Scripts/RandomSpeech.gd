extends AudioStreamPlayer2D

func _ready():
	find_random_speech()

var speeches = [
	"talk1.wav",
	"talk2.wav",
	"talk3.wav",
	"talk4.wav",
	"talk5.wav",
	"talk6.wav",
	"talk7.wav",
	"talk8.wav",
	"talk9.wav",
	"talk10.wav",
	"talk11.wav",
	"talk12.wav",
	"talk13.wav",
]

func find_random_speech():
	var ind = randi() % speeches.size()
	self.stream = load("res://Audio/speech/" + speeches[ind])