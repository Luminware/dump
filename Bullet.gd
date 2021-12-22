extends KinematicBody2D

var velocity = Vector2(50, 0)

func _physics_process(delta):
	position += velocity * delta
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("Destroy Bullets"):
		queue_free()
