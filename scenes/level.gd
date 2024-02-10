extends Node2D

var _gem_collected = 0
var _node_up: Node2D = null

func _ready():
  await get_tree().process_frame
  for player in get_tree().get_nodes_in_group("player"):
    player.area_entered.connect(_on_player_area_entered)
    player.move.connect(_on_player_move)
    player.moved.connect(_on_player_moved)
  for move_component in get_tree().get_nodes_in_group("can_move"):
    (move_component as MoveComponent).moved.connect(_on_moved)
  for fall_component in get_tree().get_nodes_in_group("can_fall"):
    (fall_component as FallComponent).update()


func _on_player_area_entered(area: Area2D):
  if area.is_in_group("gem"):
    _gem_collected += 1
    area.queue_free()
  elif area.is_in_group("boulder"):
    area.queue_free()
  elif area.is_in_group("dirt"):
    area.queue_free()


func _get_move_component(node: Node2D) -> MoveComponent:
  if not node:
    return null
  for component in node.get_children():
    if component is MoveComponent:
      return component as MoveComponent
  return null


func _on_player_move(_node: Node2D, node_up: Node2D):
  _node_up = node_up


func _on_player_moved(_node: Node2D, node_up: Node2D):
  var previous_node_up_move_component := _get_move_component(_node_up) if is_instance_valid(_node_up) else null
  if previous_node_up_move_component:
    previous_node_up_move_component.can_move = true
  var node_up_move_component := _get_move_component(node_up) if is_instance_valid(node_up) else null
  if node_up_move_component:
    node_up_move_component.can_move = false


func _on_moved(_node: Node2D):
  for fall_component in get_tree().get_nodes_in_group("can_fall"):
    (fall_component as FallComponent).update()
