extends Node2D
class_name Light

@export var radius: float = 50.0
@export var light_flickering: bool = false
#@export var light_flickering_rate: float
#@export var light_flickering_strength: float

var base_radius

func _ready():
	base_radius = radius
	if light_flickering:
		_update_radius()

# Accessor to the light data
func get_light_data() -> LightData:
	var light_data = LightData.new()
	light_data.position = global_position
	light_data.radius = radius
	return light_data
	
	
# If you want to mimick a flickering light light flames light,
# you can use this basic implementation or make your own to 
# make the radius (and maybe position?) change over time a little
func _update_radius():
	if light_flickering:
		var new_radius = randf_range(0.96,1.03)*base_radius
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(self, "radius", new_radius,randf_range(0.05, 0.2))
		tween.tween_interval(randf_range(0.1, 0.8))
		tween.tween_callback(_update_radius)
