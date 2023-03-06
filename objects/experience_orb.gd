extends Area2D


@export var experience = 1

var sprite_green = preload("res://assets/experience/exp_green.png")
var sprite_blue = preload("res://assets/experience/exp_blue.png")
var sprite_red = preload("res://assets/experience/exp_red.png")

var target = null
var speed = -40.0

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $SoundCollected

func _ready():
	if experience < 3:
		pass
	elif experience > 3 && experience < 7:
		sprite.texture = sprite_blue
		pass
	else:
		sprite.texture = sprite_red
		pass
	
	var tween = $Sprite2D.create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.set_loops()
	# contract
	tween.tween_property(
		self,
		"scale",
		Vector2(0.9, 1),
		.25,
	)
	# expand
	tween.tween_property(
		self,
		"scale",
		Vector2(1, .9),
		.25,
	)
	

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, delta*speed)
		speed += 3

func grab():
	sound.play()
	collision.call_deferred("set","disabled", true)
	sprite.visible = false
	return experience
	
func _on_sound_collected_finished():
	queue_free()
