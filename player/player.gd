extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var camera_2d = $Camera2D
@onready var muzzle = $Sprite2D/Muzzle
@onready var animation_player = $AnimationPlayer
@onready var death_panel = $GUILayer/GUI/DeathPanel
@onready var label_result = $GUILayer/GUI/DeathPanel/LabelResult
@onready var sound_victory = $GUILayer/GUI/DeathPanel/sound_victory
@onready var sound_lose = $GUILayer/GUI/DeathPanel/sound_lose

@onready var experience_bar = $GUILayer/GUI/ExperienceBar
@onready var label_level = $GUILayer/GUI/ExperienceBar/lbl_level
@onready var collected_weapons = $GUILayer/GUI/CollectedWeapons
@onready var collected_upgrades_gui = $GUILayer/GUI/CollectedUpgrades

@onready var level_up = $GUILayer/GUI/LevelUp
@onready var label_level_up = $GUILayer/GUI/LevelUp/LabelLevelUp
@onready var upgrade_options = $GUILayer/GUI/LevelUp/UpgradeOptions
@onready var sound_level_up = $GUILayer/GUI/LevelUp/sound_level_up
@onready var health_bar = $GUILayer/GUI/HealthBar
@onready var label_timer = $GUILayer/GUI/LabelTimer
@onready var item_container = preload("res://player/gui/item_container.tscn")

@onready var item_options = preload("res://utility/item_option.tscn")

signal player_death

var experience = 0
var experience_level = 0
var collected_experience = 0
var maxhp = 50
var time = 0

var SPEED = 100.0
@export var hp = 50
@export var current_direction = false
var last_movement = Vector2.UP

# Attacks
var blast = preload("res://player/attack/blast.tscn")
var missile = preload("res://player/attack/missile.tscn")
var orbit = preload("res://player/attack/orbit.tscn")
var lipstick = preload("res://player/attack/lipstick.tscn")


# Attack Nodes
@onready var blast_timer = $Attack/BlastTimer
@onready var blast_attack_timer = $Attack/BlastTimer/BlastAttackTimer

@onready var missile_timer = $Attack/MissileTimer
@onready var missile_attack_timer = $Attack/MissileTimer/MissileAttackTimer

@onready var lipstick_timer = $Attack/LipstickTimer
@onready var lipstick_attack_timer = $Attack/LipstickTimer/LipstickAttackTimer

@onready var orbit_timer = $Attack/OrbitTimer
@onready var orbit_attack_timer = $Attack/OrbitTimer/OrbitAttackTimer


#Upgrades
var collected_upgrades = ["blast1"]
var upgrade_options_arr = []
var armor = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0


# Blast
var blast_ammo = 0
var blast_base_ammo = 1
var blast_attack_speed = 1.5
var blast_level = 1

# Missile
var missile_ammo = 0
var missile_base_ammo = 0
var missile_attack_speed = 1.5
var missile_level = 0

# Lipstick
var lipstick_ammo = 0
var lipstick_base_ammo = 0
var lipstick_attack_speed = 1.5
var lipstick_level = 0

# Orbit
var orbit_ammo = 0
var orbit_base_ammo = 0
var orbit_attack_speed = 1.5
var orbit_level = 0

var enemy_close = []


func _ready():
	animation_player.play("idle-left")
	attack()
	health_bar.max_value = maxhp
	health_bar.value = hp


func change_direction(current_x):
	if current_x == 0:
		return
		
	var direction = current_x > 0
	if current_direction != direction:
		current_direction = direction
		# flips children
		sprite.scale.x *= -1
		

func _physics_process(delta):
	movement()
	
	if time >= 600:
		death()

func movement():
	var x_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_direction = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_direction, y_direction)

	
	if velocity != Vector2.ZERO:
		last_movement = mov
		animation_player.play("walk-left")
	else:
		animation_player.play("idle-left")

	velocity = mov.normalized()*SPEED
	change_direction(x_direction)
	move_and_slide()
	
	
func attack():
	if blast_level > 0:
		blast_timer.wait_time = blast_attack_speed * (1-spell_cooldown)
		if blast_timer.is_stopped:
			blast_timer.start()
			
	if missile_level > 0:
		missile_timer.wait_time = missile_attack_speed * (1-spell_cooldown)
		if missile_timer.is_stopped:
			missile_timer.start()

	if lipstick_level > 0:
		lipstick_timer.wait_time = lipstick_attack_speed * (1-spell_cooldown)
		if lipstick_timer.is_stopped:
			lipstick_timer.start()
			
	if orbit_level > 0:
		orbit_timer.wait_time = orbit_attack_speed
		if orbit_timer.is_stopped:
			orbit_timer.start()
	

func _on_hurt_box_hurt(damage):
	hp -= clamp(damage - armor, 1.0, 999.0)
	sprite.modulate = Color(0.9512819647789, 0.40952971577644, 0.63419258594513)
	await get_tree().create_timer(.1).timeout
	sprite.modulate = Color(1, 1, 1)
	
	health_bar.max_value = maxhp
	health_bar.value = hp

	if (hp <= 0):
		death()


func death():
	death_panel.visible = true
	emit_signal("player_death")
	get_tree().paused = true
	var tween = death_panel.create_tween()
	tween.tween_property(
		death_panel, 
		"position",
		Vector2(700, 180),
		1.0
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
	if time >= 299:
		label_result.text = "You Win"
		sound_victory.play()
	else:
		label_result.text = "You Lose"
		sound_lose.play()


func _on_blast_timer_timeout():
	blast_ammo += blast_base_ammo + additional_attacks
	blast_attack_timer.start()


func _on_blast_attack_timer_timeout():
	if blast_ammo > 0:
		var blast_attack = blast.instantiate()
		blast_attack.level = blast_level
		blast_attack.position = $Sprite2D/Muzzle.global_position
		blast_attack.direction = -1 if sprite.scale.x < 0 else 1
		get_tree().current_scene.add_child(blast_attack)

		blast_ammo -= 1
		if blast_ammo > 0:
			blast_attack_timer.start()
		else:
			blast_attack_timer.stop()
			
			
func _on_missile_timer_timeout():
	missile_ammo += missile_base_ammo + additional_attacks
	missile_attack_timer.start()


func _on_missile_attack_timer_timeout():
	if missile_ammo > 0:
		var missile_attack = missile.instantiate()
		missile_attack.level = missile_level
		missile_attack.position = $Sprite2D/Muzzle.global_position
		missile_attack.target = get_random_target()
		get_tree().current_scene.add_child(missile_attack)

		missile_ammo -= 1
		if missile_ammo > 0:
			missile_attack_timer.start()
		else:
			missile_attack_timer.stop()


func _on_orbit_timer_timeout():
	orbit_attack_timer.start()


func _on_orbit_attack_timer_timeout():
	if orbit_ammo < orbit_base_ammo:
		var orbit_attack = orbit.instantiate()
		orbit_attack.level = orbit_level
		orbit_attack.angle = 360/orbit_attack.attack_count
		orbit_attack.position.x = orbit_attack.radius
		orbit_attack.position.y = 0
		get_tree().current_scene.add_child(orbit_attack)
		
		orbit_ammo += 1
		
		if orbit_ammo > 0:
			orbit_attack_timer.start()
		else:
			orbit_attack_timer.stop()





func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else: 
		return Vector2.UP

# come back to this for auto targeting
func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
		

func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.grab()
		calculate_experience(gem_exp)
		

func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required:
		collected_experience -= exp_required-experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experiencecap()
		levelup()
	else:
		experience += collected_experience
		collected_experience = 0
	
	set_expbar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level*5
	elif exp_cap < 40:
		exp_cap = 95 + (experience_level-19)*8
	else:
		exp_cap = 255 + (experience_level-39)*12
	return exp_cap
	
func levelup():
	sound_level_up.play()
	label_level.text = str("Level:",experience_level)

	var tween = level_up.create_tween()
	level_up.visible = true
	tween.tween_property(
		level_up,
		"position", 
		Vector2(700, 180),
		.5
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()

	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = item_options.instantiate()
		option_choice.item = get_random_item()
		upgrade_options.add_child(option_choice)
		options += 1

	get_tree().paused = true


func set_expbar(set_value = 1, set_max_value = 100):
	experience_bar.value = set_value
	experience_bar.max_value = set_max_value
	

func upgrade_character(upgrade):
	match upgrade:
		"missile1":
			missile_level = 1
			missile_base_ammo += 1
		"missile2":
			missile_level = 2
			missile_base_ammo += 1
		"missile3":
			missile_level = 3
		"missile4":
			missile_level = 4
			missile_base_ammo += 2
		"lipstick1":
			lipstick_level = 1
			lipstick_base_ammo += 1
		"lipstick2":
			lipstick_level = 2
			lipstick_base_ammo += 1
		"lipstick3":
			lipstick_level = 3
		"lipstick4":
			lipstick_level = 4
			lipstick_base_ammo += 2
		"orbit1":
			orbit_level = 1
			orbit_base_ammo += 1
		"orbit2":
			orbit_level = 2
			orbit_base_ammo += 1
		"orbit3":
			orbit_level = 3
			orbit_base_ammo += 1
		"orbit4":
			orbit_level = 4
			orbit_base_ammo += 1
		"blast1":
			blast_level = 1
			blast_base_ammo += 1
		"blast2":
			blast_level = 2
			blast_base_ammo += 1
		"blast3":
			blast_level = 3
			blast_attack_speed -= 0.5
		"blast4":
			blast_level = 4
			blast_base_ammo += 1
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			SPEED += 30
		"tome1","tome2","tome3","tome4":
			spell_size += .50
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.20
		"ring1","ring2","ring3":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp,0,maxhp)
			
	adjust_gui_collection(upgrade)
	attack()
	
	var option_children = upgrade_options.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options_arr.clear()
	collected_upgrades.append(upgrade)
	
	level_up.visible = false
	level_up.position = Vector2(800, 50)
	get_tree().paused = false
	calculate_experience(0)
	
func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: 
			pass
		elif i in upgrade_options_arr:
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": 
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: 
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					pass
				else:
					dblist.append(i)
		else: #If there are no prequisites
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist[randi_range(0,dblist.size()-1)]
		upgrade_options_arr.append(randomitem)
		return randomitem
	else:
		return null


func change_time(argtime = 0):
	time = argtime
	var get_m = int(time / 60.0)
	var get_s = time % 60
	if get_m < 10:
		get_m = str(0, get_m)
	if get_s < 10:
		get_s = str(0, get_s)
		
	label_timer.text = str(get_m, ':', get_s)
	

func adjust_gui_collection(upgrade):
	var get_upgraded_display_names = UpgradeDb.UPGRADES[upgrade]['displayname']
	var get_type = UpgradeDb.UPGRADES[upgrade]['type']
	
	if get_type != 'item':
		var get_collected_display_names = []
		
		for i in collected_upgrades:
			get_collected_display_names.append(UpgradeDb.UPGRADES[i]['displayname'])
			
		if not get_upgraded_display_names in get_collected_display_names:
			var new_item = item_container.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collected_weapons.add_child(new_item)
				"upgrade":
					collected_upgrades_gui.add_child(new_item)


func _on_button_menu_click_end():
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://title-screen/menu.tscn")


func _on_lipstick_timer_timeout():
	lipstick_ammo += lipstick_base_ammo + additional_attacks
	lipstick_attack_timer.start()


func _on_lipstick_attack_timer_timeout():
	if lipstick_ammo > 0:
		var lipstick_attack = lipstick.instantiate()
		lipstick_attack.level = lipstick_level
		lipstick_attack.position = $Sprite2D/Muzzle.global_position
		lipstick_attack.target = get_random_target()
		get_tree().current_scene.add_child(lipstick_attack)

		lipstick_ammo -= 1
		if lipstick_ammo > 0:
			lipstick_attack_timer.start()
		else:
			lipstick_attack_timer.stop()



