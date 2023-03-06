extends Area2D

var level = 1
var hp = 1
var speed = 400
var damage = 10
var knock_amount = 100
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO
var direction = 1

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	match level:
		1:
			hp = 1
			speed = 400
			damage = 10
			knock_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 1
			speed = 400
			damage = 10
			knock_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 100
			speed = 400
			damage = 13
			knock_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 100
			speed = 400
			damage = 13
			knock_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
	scale = Vector2(1.0,1.0)*attack_size

func _physics_process(delta):
	position.x -= speed * direction * delta


func enemy_hit(hit_dmg, charge = 1):
	hp -= charge
	if hit_dmg < 13:
		damage = 0

	if hp <= 0:
		# remove attack after it hits an enemy
		queue_free()


func _on_timer_timeout():
	# remove attack after x seconds
	queue_free()
