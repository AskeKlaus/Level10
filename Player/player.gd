extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.002
const INTERACTION_DISTANCE = 5.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var interactable_hit: Object = null  # Текущий объект под прицелом

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
    if event is InputEventMouseMotion:
        rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
        $Camera3D.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
        $Camera3D.rotation.x = clamp($Camera3D.rotation.x, -1.2, 1.2)

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= gravity * delta
        
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = JUMP_VELOCITY
    
    var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

    
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)
    
    move_and_slide()
    
    _update_interaction()

func _update_interaction():
    var camera = $Camera3D
    var from = camera.global_position
    var to = from + (-camera.global_transform.basis.z) * INTERACTION_DISTANCE
    var query = PhysicsRayQueryParameters3D.create(from, to)
    query.collide_with_areas = true
    query.collide_with_bodies = true
    
    var result = get_world_3d().direct_space_state.intersect_ray(query)
    var new_hit = null  # Временная переменная для нового объекта

    if result:
        var hit = result.collider
        # Проверяем, есть ли у объекта метод interact()
        if hit.has_method("interact"):
            new_hit = hit

    # Если объект под прицелом изменился
    if new_hit != interactable_hit:
        # Если был старый объект — скрываем подсказку
        if interactable_hit != null:
            _show_interaction_prompt(false)
        # Запоминаем новый объект
        interactable_hit = new_hit
        # Если новый объект есть — показываем подсказку
        if interactable_hit != null:
            _show_interaction_prompt(true)

func _show_interaction_prompt(show: bool):
    if show and interactable_hit:
        print("Подсказка: Нажми E, чтобы взаимодействовать с ", interactable_hit.name)
        # Здесь можно показать UI-элемент
    else:
        print("Подсказка скрыта")
        # Здесь можно скрыть UI-элемент
        
func _process(delta):
    if Input.is_action_just_pressed("interact") and interactable_hit:
        interactable_hit.interact()
    if Input.is_action_just_pressed("menu"):
        get_tree().quit()
    
