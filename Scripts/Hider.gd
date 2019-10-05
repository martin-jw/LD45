extends Sprite

export var y_offset_before_parallax: float = 0

var camera: Camera2D

var tween: Tween
var hiding: bool = false

func _ready():
	tween = Tween.new()
	add_child(tween)
	camera = get_tree().get_root().find_node("Camera", true, false)
	
func _process(delta):
	var y_diff = ((global_position.y - y_offset_before_parallax) - camera.position.y) / 128.0
	
	if y_diff > 0:
		var x_diff = ((get_parent().global_position.x + texture.get_width() * scale.x / 2) - camera.position.x) / 640.0
		
		position.x = y_diff * y_diff * x_diff

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
