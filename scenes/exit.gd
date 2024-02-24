extends Area2D

@onready var sprite_2d = $Sprite2D

func open():
  sprite_2d.frame = 7
  set_collision_layer_value(2, false)
