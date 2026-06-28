extends CSGSphere3D

@export var interaction_prompt: String = "[E]"

@export var min_height: float = 0.5      # Нижняя позиция по Y
@export var max_height: float = 2.5      # Верхняя позиция по Y
@export var step: float = 1.0            # Шаг перемещения (0.5, 1.0, и т.д.)
@export var puzzle_manager: NodePath     # Ссылка на менеджер

var current_level: int = 0
var positions: Array = []

func _ready():
    # Заполняем массив возможных позиций
    var pos = min_height
    while pos <= max_height + 0.01:
        positions.append(pos)
        pos += step
    
    # Стартовая позиция — случайная
    current_level = randi() % positions.size()
    update_position()

func interact():
    print("Шар ", name, " активирован. Текущий уровень: ", current_level)
    # Следующий уровень (циклически)
    current_level = (current_level + 1) % positions.size()
    update_position()
    
    # Уведомляем менеджер, что шар изменил позицию
    get_node(puzzle_manager).check_solution()

func update_position():
    position.y = positions[current_level]
