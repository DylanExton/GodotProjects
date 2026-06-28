extends CharacterBody2D

signal laser_shot(laser)

@export var acceleration := 15.0
@export var max_speed := 500.0
@export var deceleration := 10.0

@onready var muzzle = $Muzzle

var laser_scn = preload("res://scenes/laser.tscn")

var fire_rate = 0.25
var shoot_cooldown = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		if !shoot_cooldown:
			shoot_laser()
			shoot_cooldown = true
			await get_tree().create_timer(fire_rate).timeout
			shoot_cooldown = false

func _physics_process(delta: float) -> void:
	
	var mouse_pos := get_global_mouse_position();
	var direction = (mouse_pos - position).normalized()
	
	if Input.is_action_pressed("move_forward"):
		velocity += acceleration * direction
	
	elif Input.is_action_pressed("move_backward"):
		velocity -= acceleration * direction
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration)
		
	var mouse_pos_rotation := get_local_mouse_position()
	rotation += mouse_pos_rotation.angle()* 0.1
	
	velocity = velocity.limit_length(max_speed)
	move_and_slide()

## Screen Wrapping, will replace later with an Out Of Bounds screen
	var screen_size = get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0

func shoot_laser():
	var l = laser_scn.instantiate()
	l.global_position = muzzle.global_position
	l.rotation = rotation
	emit_signal("laser_shot", l)
	
