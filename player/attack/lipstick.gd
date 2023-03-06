extends Area2D


var level = 1
var hp = 100.0
var speed = 300.0
var damage = 5
var attack_size = 1
var knockback_amount = 100

var angle = Vector2.ZERO
var target = Vector2.ZERO
var rotate_angle = 0

signal remove_from_array(object)

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(180)
	
	match level:
		1:
			hp = 1
			speed = 100.0
			damage = 5
			attack_size = 1.0 * (1 + player.spell_size)
			knockback_amount = 100
		2:
			hp = 1
			speed = 300.0
			damage = 10
			attack_size = 1.0 * (1 + player.spell_size)
			knockback_amount = 100
		3:
			hp = 5
			speed = 500.0
			damage = 15
			attack_size = 1.0 * (1 + player.spell_size)
			knockback_amount = 100
		4:
			hp = 10
			speed = 800.0
			damage = 20
			attack_size = 1.0 * (1 + player.spell_size)
			knockback_amount = 100

	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()


func enemy_hit(hit_dmg, charge = 1):
	hp -= charge	
	if hit_dmg < 8:
		damage = 0

	if hp <= 0:
		# remove attack after it hits an enemy
		queue_free()

func _physics_process(delta):
	position += angle*speed*delta


func _on_timer_timeout():
	queue_free()
