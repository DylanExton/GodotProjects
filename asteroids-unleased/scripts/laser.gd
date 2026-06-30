extends Area2D

var movement_vec := Vector2(1,0)
@export var speed := 1000.0

func _physics_process(delta: float) -> void:
	global_position += movement_vec.rotated(rotation) * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
func _on_area_entered(area):
	if area is Asteroid:
		var ast = area
		ast.explode()
		queue_free()
