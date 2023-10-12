extends Resource
class_name ItemData

@export var name: String = ""
@export_multiline var description: String = ""

@export var stackable: bool = false
@export var is_weapon: bool = false
@export var fire_rate: int
@export var hp_value: int

@export var texture: AtlasTexture
