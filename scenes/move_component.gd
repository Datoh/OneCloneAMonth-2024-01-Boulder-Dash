extends Node2D
class_name MoveComponent

@export var node: Node2D = null

const _TIME_MOVE = 0.5

var can_move := true

var _move_from := Vector2()
var _move_to := Vector2()
var _move_timestamp = 0.0

signal move_to(direction: Vector2)
signal moved(node: Node2D)

func _ready():
  _move_from = node.position
  _move_to = node.position


func _physics_process(delta: float):
  if not can_move:
    return

  var was_moved := moving()
  if was_moved:
    _move_timestamp += delta * (1.0 / _TIME_MOVE)
    node.position = _move_from.lerp(_move_to, min(_move_timestamp, 1.0))

  if was_moved and not moving():
    moved.emit(node)


func moving() -> bool:
  return node.position != _move_to


func move(offset: Vector2):
  _move_from = node.position
  _move_to = node.position + offset
  _move_timestamp = 0
  move_to.emit(offset)
