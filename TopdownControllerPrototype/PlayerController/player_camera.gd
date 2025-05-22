class_name PlayerCamera
extends Node3D

#EXPORTS
@export var player: CharacterBody3D
@export var vertical_offset: float = 5
@export var horizontal_offset: float = 5

#ONREADYS
@onready var player_camera: Camera3D = $PlayerCamera


#VARIABLES

func _ready() -> void:
	player_camera.position.y = vertical_offset
	player_camera.position.z = horizontal_offset
#
#
func _process(delta: float) -> void:
	if player:
			look_at_player()


func look_at_player() -> void:
	player_camera.look_at(player.global_position)


