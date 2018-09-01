extends Node

static func draw_circle(object, radius):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	var color = Color(1, 1, 1, .5)
	for i in range(nb_points + 1):
		var angle_point = deg2rad(i * 360 / nb_points - 90)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * radius)
	for index_point in range(nb_points):
		object.z_index = 1
		object.draw_line(points_arc[index_point], points_arc[index_point + 1], color)
