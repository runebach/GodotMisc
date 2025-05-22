extends BaseState
class_name EnemyChasing

@export var enemy: CharacterBody3D
@export var chase_speed: float = 5
@export var chase_range: float = 10

var player: CharacterBody3D

func enter_state() -> void:
	player = get_tree().get_first_node_in_group("Player")

func physics_update(delta: float) -> void:
	var direction: Vector3 = player.global_position - enemy.global_position
	print(direction.x)
	
	if direction.length() > 20:
		enemy.velocity.x = direction.x * chase_speed
		enemy.velocity.z = direction.z * chase_speed
	else:
		enemy.velocity = Vector3()
	
	if direction.length() > chase_range:
		leave_state.emit(self, "enemyidle")
