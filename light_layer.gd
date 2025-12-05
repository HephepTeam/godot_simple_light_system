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
	$BlackPoint.material.set_shader_parameter("black_point", shadow_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_get_lights_data()
	
	%DrawOn.queue_redraw()
	
func _update_draw():
	#drawing in 2 passes to have the RED color above all the green color
	#when lights merge
	for light in lights_data:
		if light.spread < 360:
			draw_slice(light.position,light.radius, light.direction - (light.spread / 2), light.direction + (light.spread / 2), Color.GREEN)
		else:
			$%DrawOn.draw_circle(light.position, light.radius, Color.GREEN, true)

	for light in lights_data:
		
		if custom_light_outline_size > 0.0:
			inner_radius = light.radius - custom_light_outline_size
		else:
			inner_radius = light.radius*0.8 
			
		if light.spread < 360:
			draw_slice(light.position,inner_radius, light.direction - (light.spread / 2), light.direction + (light.spread / 2), Color.RED)
		else:
			$%DrawOn.draw_circle(light.position, inner_radius, Color.RED, true)
			


func _get_lights_data():
	lights_data = []
	var lights = get_tree().get_nodes_in_group("Lights")
	for light in lights:
		lights_data.append(light.get_light_data())
		
func draw_slice(center: Vector2, radius: float, angle_from: float, angle_to: float, color: Color) -> void:
	var nb_points: int = max(6, (angle_to-angle_from) / 3)
	var outer_arc: Array[Vector2] = []
	var inner_arc: Array[Vector2] = []

	inner_arc.push_back(center)
	
	for i in range(nb_points + 1):
		var angle_point: float = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points)
		outer_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	$%DrawOn.draw_colored_polygon(inner_arc + outer_arc, color)
