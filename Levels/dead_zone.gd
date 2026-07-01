extends Area3D

func _ready():
    connect("body_entered", _on_body_entered)

func _on_body_entered(body):
    if body.name == "Player":
        print("Игрок упал! Перезапуск уровня...")
        call_deferred("restart_level")



func restart_level():
        get_tree().reload_current_scene()
