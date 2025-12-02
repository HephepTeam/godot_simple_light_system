extends CanvasLayer

@export var custom_light_outline_size: float = -1.0
@export var shadow_color : Color
const light_zone_color: Color = Color.RED
const light_zone_outline_color: Color = Color.GREEN

var lights_data := []
var inner_radius: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()
	$%DrawOn.draw.connect(_update_draw)
	$Surface.material.set_shader_parameter("shadow_color", shadow_color)
	$Surface.material.set_shader_parameter("light_zone_color", light_zone_color)
	$Surface.material.set_shader_parameter("light_outline_color", light_zone_outline_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_get_lights_data()
	
	%DrawOn.queue_redraw()
	
func _update_draw():
	#drawing in 2 passes to have the RED color above all the green color
	#when lights merge
	for light in lights_data:
		$%DrawOn.draw_circle(light.position, light.radius, Color.GREEN, true)

	for light in lights_data:
		
		if custom_light_outline_size > 0.0:
			inner_radius = light.radius - custom_light_outline_size
		else:
			inner_radius = light.radius*0.8 
			
		$%DrawOn.draw_circle(light.position, inner_radius, Color.RED, true)


func _get_lights_data():
	lights_data = []
	var lights = get_tree().get_nodes_in_group("Lights")
	for light in lights:
		lights_data.append(light.get_light_data())
