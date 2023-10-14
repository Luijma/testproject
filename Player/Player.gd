extends CharacterBody2D


@export var inventory_data: InventoryData
# @export var bullet_speed = 1000
@export var maximum_health: int
@onready var player_hp = maximum_health #replace this with global player info
@onready var playerAmmo = 0


@onready var equiped_weapon: ItemData = preload("res://Item/items/no_item.tres")
@onready var fire_rate = equiped_weapon.fire_rate

#Custom Player Signals

signal toggle_inventory()
signal player_fired_bullet(bullet, position, direction)

#Custom Player Signals

#Custom Player Variables
const MAX_HEALTH = 10
const SPEED = 150.0
var playerinventory: InventoryData
#Custom Player Variables
# Movement Code
@onready var prev_direction = "down"
@onready var anim = get_node("AnimationPlayer")
# Movement Code

# Firing Code
@onready var bullet_point = $BulletPoint
@onready var gun_direction = $GunDirection
@onready var crosshair_cursor = preload("res://Sprites/crosshair.png")

var aiming_gun = false
var Bullet = preload("res://Player/player_bullet.tscn")
var can_fire = true

# Firing Code

# Interaction Code

@onready var all_interactions = []
@onready var interact_label = $Node2D/InteractLabel

# interaction Code


func _ready():
	update_interactions()

func _unhandled_input(event):
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
	if Input.is_action_just_pressed("interact"):
		execute_interaction()

func _physics_process(delta):
	# FIRING CODE
	if Input.is_action_just_pressed("Aim_Gun") and aiming_gun == false and Game.player_can_move:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		aiming_gun = true
		Input.set_custom_mouse_cursor(crosshair_cursor, Input.CURSOR_ARROW, Vector2(10, 10))
	# SHOOTING CODE
	elif Input.is_action_just_pressed("Aim_Gun") and aiming_gun == true:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		aiming_gun = false
		Input.set_custom_mouse_cursor(null)
	if aiming_gun == true:
		look_at(get_global_mouse_position())
	else:
		rotation_degrees = 0
	if Input.is_action_just_pressed("fire") and aiming_gun == true and equiped_weapon.name == "gun" and can_fire == true:
		shoot()
	
	# MOVEMENT CODE #
	if aiming_gun != true and Game.player_can_move:
		var direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * SPEED
	
		if direction:
			if direction.x == 1:
				anim.play("x_run")
				prev_direction = "side"
				get_node("AnimatedSprite2D").flip_h = false
			if direction.x == -1:
				anim.play("x_run")
				prev_direction = "side"
				get_node("AnimatedSprite2D").flip_h = true
			if direction.y == 1:
				anim.play("down_run")
				prev_direction = "down"
			if direction.y == -1:
				anim.play("up_run")
				prev_direction = "up"
		elif direction.x == 0 and direction.y == 0:
			anim.play(prev_direction + "_Idle")
		
		move_and_slide()
	
func _item_equiped(item_data):
	if(item_data != null and item_data == equiped_weapon):
		equiped_weapon = item_data
		fire_rate = equiped_weapon.fire_rate
		print("fire_rate")
	elif(item_data != equiped_weapon):
		print("Attempted to unequip item that wasn't equiped")
		
# SHOOTING FUNCTIONS
func shoot():
	# check and reduce ammo. Add get setters to player_ammo
	if Input.is_action_just_pressed("fire") and aiming_gun == true:
		print("firing gun")
		var bullet_instance = Bullet.instantiate()
		var direction = gun_direction.global_position - bullet_point.global_position
		
		emit_signal("player_fired_bullet", bullet_instance, bullet_point.global_position, direction)
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true
#SHOOTING FUNCTIONS

func handle_player_hit():
	print("player hit")
	player_hp -= 10
	


# INTERACTION FUNCTIONS

func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	print("entered interaction area")
	update_interactions()


func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	update_interactions()

func update_interactions():
	if all_interactions:
		interact_label.text = all_interactions[0].interact_label
	else:
		interact_label.text = ""
		
func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]
		if(cur_interaction.can_interact):
			cur_interaction.can_interact = false
			await cur_interaction.interact.call()
			cur_interaction
	
