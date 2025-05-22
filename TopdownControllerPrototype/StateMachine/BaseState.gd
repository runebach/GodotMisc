class_name BaseState
extends Node

signal leave_state

## A function that will be run once when the state is entered
func enter_state() -> void:
	pass

## A function that will be run once when the state is exited
func exit_state() -> void:
	pass

## A process function that will control non physics behavior during state
func update(delta: float) -> void:
	pass

## A process function that will control physics based behavior during state
func physics_update(delta: float) -> void:
	pass
