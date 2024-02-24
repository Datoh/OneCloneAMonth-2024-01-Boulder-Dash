extends Area2D

@onready var _auto_move_component = $AutoMoveComponent
@onready var sprite_2d = $Sprite2D

@export var player: Player = null:
  set(val):
    _auto_move_component.player = val
  get:
    return _auto_move_component.player

func _on_move_component_move_to(direction):
  sprite_2d.scale.x = -1.0 if direction.x < 0.0 else 1.0 # flip_h animation
