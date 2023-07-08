extends CanvasLayer

func setup(color, size):
	get_node("Node2D").scale.x *= size
	get_node("Node2D").scale.y *= size
	get_node("Node2D/Splash").set_color(color)

func set_position(pos):
	get_node("Node2D").position = pos

func _ready():
	# Render on top of other ink splatters
	layer = get_parent().get_child_count() * -1
	# Randomize texture
	var i = randi()%3+1
	var tex = load("res://assets/images/splash"+var2str(i)+".png")
	tex.set_flags(0)
	get_node("Node2D/Splash").set_texture(tex)
	get_node("Node2D/AnimationPlayer").play("Spread")
