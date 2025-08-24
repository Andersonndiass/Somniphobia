# ItemData.gd
extends Resource
class_name ItemData
 
@export var item_name: String
@export var icon: Texture2D = preload("res://assets/png/icon.svg")
@export var mesh_scene: PackedScene
#@export var interactable_scene : PackedScene = preload("res://scenes/interactables.tscn")
@export var is_flashlight: bool = false
@export var is_victory_item: bool = false # Para identificar a pílula
@export var is_usable: bool = false

# --- LINHAS ADICIONADAS ---
# Adicionamos um grupo para organizar melhor no Inspector
@export_group("Empilhamento") 
# Esta "caixinha" vai nos dizer se o item pode ou não ser empilhado.
@export var is_stackable: bool = false
# Se ele puder ser empilhado, qual o limite? Para a pilha, será 5.
@export var max_stack_size: int = 1

# Esta variável vai guardar a quantidade de itens NESTE slot do inventário.
# Não precisa de @export, pois será controlada pelo código.
var quantity: int = 1
