extends Node2D
class_name MoveComponent

@export var node: Node2D = null

var can_move := true

var _move_from := Vector2()
var _move_to := Vector2()

signal move_to(direction: Vector2)
signal moved(node: Node2D)

static func get_component(entity: Variant) -> MoveComponent:
  if not is_instance_valid(entity) or not entity is Node:
    return null
  for child in entity.get_children():
    if child is MoveComponent:
      return child as MoveComponent
  return null


func _ready():
  _move_from = node.position
  _move_to = node.position


func moving() -> bool:
  return node.position != _move_to


func move(offset: Vector2):
  _move_from = node.position
  _move_to = node.position + offset
  move_to.emit(offset)
  %Timer.start()


func _on_timer_timeout():
  node.position = _move_to
  moved.emit(node)
