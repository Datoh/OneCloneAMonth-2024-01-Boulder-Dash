extends CanvasLayer

func set_gems(gems: int):
  %Gems.text = str(gems)


func set_level(level: int):
  %Level.text = str(level)


func show_die():
  %PanelContainerDie.visible = true
  %PanelContainerWin.visible = false
  %PanelContainerFinish.visible = false


func show_won():
  %PanelContainerDie.visible = false
  %PanelContainerWin.visible = true
  %PanelContainerFinish.visible = false


func show_finished():
  %PanelContainerDie.visible = false
  %PanelContainerWin.visible = false
  %PanelContainerFinish.visible = true
