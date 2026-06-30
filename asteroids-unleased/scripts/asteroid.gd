class_name Asteroid extends Area2D

signal exploded(position,size)

enum AsteroidSize{LRG,SML}
var movement_vector := Vector2(0,-1)
var speed := 50.0

@export var size := AsteroidSize.LRG
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D

func _ready() -> void:
	rotation = randf_range(0,2*PI)
	
	match size:
		AsteroidSize.LRG:
			speed = randf_range(50,100)
			sprite.texture = preload("res://assets/meteor_large.png")
			cshape.shape = preload("res://resources/asteroid_cshape_lrg.tres")
		AsteroidSize.SML:
			speed = randf_range(100,200)
			sprite.texture = preload("res://assets/meteor_small.png")
			cshape.shape = preload("res://resources/asteroid_cshape_sml.tres")


func _physics_process(delta: float) -> void:
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	var screen_size = get_viewport_rect().size
	var radius = cshape.shape.radius
	if global_position.y < 0 - radius:
		global_position.y = screen_size.y + radius
	elif global_position.y > screen_size.y + radius:
		global_position.y = 0 - radius
	if global_position.x < 0 - radius: 
		global_position.x = screen_size.x + radius
	elif global_position.x > screen_size.x + radius:
		global_position.x = 0 - radius

func explode():
	emit_signal("exploded",global_position, size)
	queue_free()
	
