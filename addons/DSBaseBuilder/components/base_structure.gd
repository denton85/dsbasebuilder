class_name BaseStructure
extends Node3D

## A list of all the components living in this structure.
var children: Array[BaseBuildComponent] = []

## If you need multiplayer, something like this could be edited to fit your permissions for who can build on this structure.
@export var owners: Array[Player] = []
