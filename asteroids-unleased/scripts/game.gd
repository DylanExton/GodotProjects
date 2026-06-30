extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $Asteroids

var asteroid_scene = preload("res://scenes/asteroid.tscn")

func _ready() -> void:
	player.connect("laser_shot", _on_player_laser_shot)
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
func _on_player_laser_shot(laser):
	lasers.add_child(laser)

func _on_asteroid_exploded(pos,size):
	for num in range(randi_range(0,5)):
		match size:
			Asteroid.AsteroidSize.LRG:
				spawn_asteroid(pos, Asteroid.AsteroidSize.SML)
			Asteroid.AsteroidSize.SML:
				pass
		
func spawn_asteroid(pos,size):
	var ast = asteroid_scene.instantiate()
	ast.global_position = pos
	ast.size = size
	ast.connect("exploded",_on_asteroid_exploded)
	asteroids.call_deferred("add_child",ast)
