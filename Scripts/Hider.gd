extends Node2D

var tween: Tween
var hiding: bool = false

func _ready():
	tween = Tween.new()
	add_child(tween)

func _on_area_entered(area):
	
	if area.is_in_group("ShouldHide") and !hiding:
		tween.interpolate_property(self, "modulate", 
			Color(1.0, 1.0, 1.0, 1.0), 
			Color(1.0, 1.0, 1.0, 0.0), 
			0.5,Tween.TRANS_LINEAR, 
			Tween.EASE_IN_OUT)
		
		tween.start()
		hiding = true

func _on_area_exited(area):
	
	if area.is_in_group("ShouldHide") and hiding:
		tween.interpolate_property(self, "modulate", 
			Color(1.0, 1.0, 1.0, 0.0), 
			Color(1.0, 1.0, 1.0, 1.0), 
			0.5,Tween.TRANS_LINEAR, 
			Tween.EASE_IN_OUT)
		
		tween.start()
		hiding = false
