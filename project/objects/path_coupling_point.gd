extends PathFollow2D

class_name PathCouplingPoint2D

## Node path to the target path's coupling point node
export(NodePath) var coupling_point_path
## Target path coupling point reference
onready var coupling_point : PathFollow2D = get_node(coupling_point_path)

##
export(NodePath) var node_wheel_follow_path
##
onready var node_wheel_follow : PathFollow2D = get_node(node_wheel_follow_path)
