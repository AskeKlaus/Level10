extends CSGBox3D


@export var balls: Array[NodePath]       # Пути к трём шарам
@export var target_level: int = 1        # Какой уровень должен быть у всех шаров (0,1,2)
@export var door: NodePath               # Дверь, которая откроется
@export var indicator: NodePath          # Панель, которая загорится
@export var sound_success: AudioStream   # Звук решения (опционально)

var is_solved: bool = false

func check_solution():
    if is_solved:
        return
    
    var all_correct = true
    for ball_path in balls:
        var ball = get_node(ball_path)
        if ball.current_level != target_level:
            all_correct = false
            break
    
    if all_correct:
        is_solved = true
        _on_puzzle_solved()

func _on_puzzle_solved():
    print("Головоломка решена!")
    
    # 1. Открываем дверь
    #var door_node = get_node(door)
    #if door_node:
        #door_node.visible = false
        # Если дверь CSG-блок, можно и коллизию отключить
        #if door_node.has_method("set_use_collision"):
            #door_node.set_use_collision(false)
    
    # 2. Зажигаем панель (зелёный свет)
    var indicator_node = get_node(indicator)
    if indicator_node:
        print("found")
        var mat = StandardMaterial3D.new()
        mat.albedo_color = Color.GREEN
        mat.emission_enabled = true
        mat.emission = Color.GREEN
        mat.emission_energy = 2.0
        indicator_node.material = mat
        print("Материал применён")
    else:
        print("NOT found")
    
    # 3. Проигрываем звук (если есть)
    #if sound_success:
        #AudioStreamPlayer3D.play_sound(sound_success)
