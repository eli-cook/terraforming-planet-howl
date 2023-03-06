extends Area2D

var level = 1
var hp = 100.0
var speed = 300.0
var damage = 5
var attack_size = 1
var knockback_amount = 100
var angle = 0
var radius = 75
var count = 1
var attack_count = 1

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	match level:
		1:
			hp = 1
			speed = 300.0
			damage = 5
			attack_size = 1.0 * (1 + player.spell_size)
			knockback_amount = 100
			attack_count = 1
		2:
			hp = 1
			speed = 300.0
			damage = 5
			attack_size = 1.0 * (1 + player.spell_size)
			knockback_amount = 100
			attack_count = 2
		3:
			hp = 1
			speed = 300.0
			damage = 5
			attack_size = 1.0 * (1 + player.spell_size)
			knockback_amount = 100
			attack_count = 3	
		4:
			hp = 1
			speed = 300.0
			damage = 5
			attack_size = 1.0 * (1 + player.spell_size)
			knockback_amount = 100
			attack_count = 4


func enemy_hit(hit_dmg =1, charge = 1):
	pass
	

func _physics_process(delta):
	rotation += deg_to_rad(5)
	angle += 0.05

	position.x = player.position.x + radius * (cos(angle))
	position.y = player.position.y + radius * (sin(angle))
	

func _on_timer_timeout():
#	queue_free()
	pass
