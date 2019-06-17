extends Node
class_name Combat

#combat state variables
var current_intangibility_time := 0
var current_hitstun_time := 0
var current_knockback_time := 0
var current_knockback_speed := 0.0

#temporary storage for combat state mutation
var hitstun_time := 0
var knockback_time := 0
var intangibility_time := 0

func _physics_process(delta : float) -> void:
	update_combat_variables()

func is_intangible() -> bool:
	return (current_knockback_time > 0 and current_intangibility_time < intangibility_time)

func in_hitstun() -> bool:
	return (hitstun_time > 0 and current_hitstun_time < hitstun_time)

func in_knockback() -> bool:
	return (knockback_time > 0 and current_knockback_time < knockback_time)
	
func reset_combat_variables() -> void:
	hitstun_time = 0
	knockback_time = 0
	intangibility_time = 0
	
	current_intangibility_time = 0
	current_hitstun_time = 0
	current_knockback_time = 0
	current_knockback_speed = 0
	
func update_combat_variables() -> void:
	if is_intangible():
		current_intangibility_time += 1
	if in_hitstun():
		current_hitstun_time += 1
	if in_knockback():
		current_knockback_time += 1

func set_combat_variables(variables : Dictionary) -> void:
	intangibility_time = variables.intangibility_time
	hitstun_time = variables.hitstun_time
	knockback_time = variables.knockback_time
	current_knockback_speed = variables.knockback_speed
