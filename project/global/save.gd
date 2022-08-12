extends Node

## Default save data
const DEFAULT_DATA := {
	"position" : Vector2.ZERO,
	"level_path" : "res://levels/level_intro.tscn"
}

## File name that will be used to write the save to a file
const FILE_NAME := "save.dat"

## Save data that is written and read from a file
var _data : Dictionary

## Save data that is directly manipulated by game objects
var data : Dictionary

## Sets save data to default
func reset() -> void:
	_data = DEFAULT_DATA.duplicate(true)
	data = DEFAULT_DATA.duplicate(true)

func save() -> void:
	_data = data.duplicate(true)

func collect_save_write() -> void:
	if Game.player:
		data.level_path = LevelManager.get_current_level_path()
		data.position = Game.player.global_position
		save()
		write()

func load() -> void:
	data = _data.duplicate(true)

func read() -> void:
	var _f := File.new()
	_f.open(FILE_NAME, File.READ)
	
	if !_f.is_open():
		printerr("Save: Couldn't read file. Aborting")
		return
	
	_data = str2var(_f.get_as_text())
	_f.close()

func write() -> void:
	var _f := File.new()
	_f.open(FILE_NAME, File.WRITE)
	_f.store_string(var2str(_data))
	_f.close()

func exists() -> bool:
	return File.new().file_exists(FILE_NAME)

func _ready() -> void:
	reset()

