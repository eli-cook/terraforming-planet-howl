extends Resource

class_name SpawnInfo

@export var name:String
@export var time_start:int
@export var time_end:int
@export var enemy:Resource
@export var enemy_num:int
@export var enemy_spawn_delay:int
@export var active:bool = true

var spawn_delay_counter = 0
