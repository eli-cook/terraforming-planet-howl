extends CharacterBody2D

@export var move_speed = 60.0
@export var hp = 10
@export var experience = 1
@export var enemy_damage = 1

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var sprite = $Sprite2D

var exp_gem = preload("res://objects/experience_orb.tscn")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * move_speed
	
	move_and_slide()
	
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.y < 0:
		sprite.flip_h = false
		
		
func spawn_exp_gem():
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child", new_gem)

func _on_hurt_box_hurt(damage):
	hp -= damage
	sprite.modulate = Color(0.9512819647789, 0.40952971577644, 0.63419258594513)
	await get_tree().create_timer(.1).timeout
	sprite.modulate = Color(1, 1, 1)
	
	if hp <= 0:
		spawn_exp_gem()
		queue_free()
