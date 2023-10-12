extends RigidBody2D
class_name PlayerBullet

@export var speed: int = 1
@onready var kill_timer = $KillTimer
var direction = Vector2.ZERO


func _ready() -> void:
	kill_timer.start()
	

func _physics_process(delta: float) -> void:
	if(direction != Vector2.ZERO):
		var velocity = direction * speed
		
		global_position += velocity
	
func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()


func _on_kill_timer_timeout():
	queue_free()


func _on_body_entered(body):
	print("on body entered")
	if body.has_method("handle_enemy_hit"):
		body.handle_enemy_hit()
		queue_free()
	if !body.has_method("handle_player_hit"):
		queue_free()
