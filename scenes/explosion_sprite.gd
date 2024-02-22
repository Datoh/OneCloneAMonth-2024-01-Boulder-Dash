extends Sprite2D

signal animation_finished()

func _on_animation_player_animation_finished(_anim_name):
  animation_finished.emit()
