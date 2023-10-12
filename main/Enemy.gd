extends Node2D
class_name Enemy

@onready var interaction_area: Interactable = $InteractionArea
@export var MAX_HEALTH = 10
@onready var health: int = MAX_HEALTH:
	set(value):
		health = clamp(value, 0, MAX_HEALTH)
		enemy_updated_health.emit()
signal enemy_updated_health()
signal enemy_died(enemy: Enemy)
signal enemy_shot_by_bullet(enemy: Enemy)

func _ready():
	health = MAX_HEALTH
	interaction_area.interact = Callable(self, "_on_interact")
func _on_interact():
	print("enemy interaction complete!")
	interaction_area.can_interact = true

func handle_enemy_hit():
	print("health prehit: " + str(health))
	enemy_shot_by_bullet.emit(self)
	if(health == 0):
		print("enemy health post hit: " + str(health))
		enemy_died.emit()

func _on_enemy_died(enemy: Enemy):
	queue_free()
func _on_enemy_updated_health():
	print("New enemy health: " + str(health))
	if health == 0:
		enemy_died.emit(self)

