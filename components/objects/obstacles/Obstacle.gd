extends StaticBody2D

@onready var polygon = $Polygon2D


func _ready():
	if BiomeManager.is_surface_biome():
		polygon.modulate = "#57d5ff"
