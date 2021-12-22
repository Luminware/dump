extends KinematicBody2D

export (int) var speed = 25

var velocity = Vector2()
var reloaded = true

signal shoot(bullet, direction, rotation)

onready var Bullet = preload("res://Bullet.tscn")
onready var timer = $Timer

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_right"):
		rotation_degrees = 0
		shoot()
	if Input.is_action_pressed("ui_left"):
		rotation_degrees = 180
		shoot()
	if Input.is_action_pressed("ui_up"):
		rotation_degrees = 270
		shoot()
	if Input.is_action_pressed("ui_down"):
		rotation_degrees = 90
		shoot()
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	
func shoot():
	if reloaded == true:
		emit_signal("shoot", Bullet, rotation, position)
		timer.start()
		reloaded = false

func _on_Timer_timeout():
	reloaded = true
