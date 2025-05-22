extends CharacterBody3D

#EXPORTS
@export var walk_speed: float = 5
@export_range(0, 1) var camera_turn_speed: float = 0.6

#ONREADY
@onready var body_mesh: MeshInstance3D = $CollisionShape3D/BodyMesh
@onready var player_camera_node: PlayerCamera = $PlayerCamera



#VARIABLES
var current_speed: float = 0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_speed = walk_speed
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func _process(delta: float) -> void:
	handle_aiming()


func _physics_process(delta: float) -> void:
	handle_movement(delta)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Menu"):
		get_tree().quit()
	handle_camera_rotation(event)


## Function for handling top down movement. Will move the CharacterBody3D node and all children
func handle_movement(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	#We get input directions based on (-1, 1) and (-1, 1) for x and z directions
	var input_direction: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	#We get normalized Vector3 based on the input direction.
	var direction: Vector3 = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	#We move if direction exists and stop if direction doesnt.
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	move_and_slide()


## Function for dealing with aiming. A raycast is made from the mouse position of the camera
## towards a plane surrounding the character body. The body_mesh node is then made
## to look towards the target vector. This way the directionality of the parent node
## is kept the same and movement will not be affected.
func handle_aiming() -> void:
	if player_camera_node and !Input.is_action_pressed("ChangeCameraAngle"):
		var target_plane_mouse: Plane = Plane(Vector3(0, position.y+1, 0), position.y)
		var ray_length: float = 1000
		var mouse_position: Vector2 = get_viewport().get_mouse_position()
		
		var from: Vector3 = player_camera_node.player_camera.project_ray_origin(mouse_position)
		var to: Vector3 = from + player_camera_node.player_camera.project_ray_normal(mouse_position) * ray_length
		
		var cursor_position: Vector3 = target_plane_mouse.intersects_ray(from, to)
		var target_vector: Vector3 = Vector3(cursor_position.x, position.y+1, cursor_position.z)
		body_mesh.look_at(target_vector, Vector3.UP)


func handle_camera_rotation(event: InputEvent) -> void:
	var rotation: float = 0
	if Input.is_action_pressed("ChangeCameraAngle"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if event is InputEventMouseMotion:
			rotation += event.relative.x
			rotate_object_local(Vector3(0, -1, 0), lerpf(0, clampf(rotation, -0.04, 0.04), camera_turn_speed))
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		
