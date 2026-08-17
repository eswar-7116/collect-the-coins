extends RigidBody2D

var start_pos: Vector2
var needs_reset: bool
var start_rot := 0.0



func _ready() -> void:
	start_pos = position
	start_rot = rotation


func reset() -> void:
	needs_reset = true
	freeze = false

	constant_force = Vector2.ZERO
	constant_torque = 0.0


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if needs_reset:
		state.transform = Transform2D(start_rot, start_pos)
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0

		needs_reset = false
