extends BaseState
class_name EnemyIdle

@export var enemy: CharacterBody3D
@export var movement_speed: float = 5
@export var aggro_range: float = 8

var player: CharacterBody3D

var move_direction: Vector3
var wander_time: float

func randomize_wander() -> void:
	move_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
	wander_time = randf_range(1, 3)


func enter_state() -> void:
	player = get_tree().get_first_node_in_group("Player")
	randomize_wander()

func update(delta: float) -> void:
	if wander_time > 0:
		wander_time -= delta
	else: 
		randomize_wander()

func physics_update(delta: float) -> void:
	if enemy:
		enemy.velocity.x = move_direction.x * movement_speed
		enemy.velocity.z = move_direction.z * movement_speed
	if player:
		var direction: Vector3 = player.global_position - enemy.global_position
		if direction.length() < aggro_range:
			leave_state.emit(self, "enemychasing")
	
