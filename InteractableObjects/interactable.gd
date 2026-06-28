extends Area3D

signal interacted

@export var interaction_prompt: String = "[E]"
@export var is_active: bool = true

func _ready():
    connect("body_entered", _on_body_entered)
    connect("body_exited", _on_body_exited)

func _on_body_entered(body):
    if body.name == "Player" and is_active:
     body.interactable = self
        # Здесь можно показать подсказку на UI
    print(interaction_prompt)

func _on_body_exited(body):
    if body.name == "Player":
        body.interactable = null
        # Скрыть подсказку

func interact():
    if is_active:
        print("Взаимодействие с: ", name)
        interacted.emit()
        var parent = get_parent()
        if parent.has_method("interact"):
            parent.interact()
