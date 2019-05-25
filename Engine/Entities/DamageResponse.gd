class_name DamageResponse

var damage_taken := 0
var reflect_response := 0
var resist := 0

func create(damage_taken := 0, reflect_response := 0, resist := 0) -> void:
    self.damage_taken = damage_taken
    self.reflect_response = reflect_response
    self.resist = resist
