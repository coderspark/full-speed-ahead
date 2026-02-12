extends Resource
class_name SaveLoadData

@export var Settings = []

@export var IsInGame = false
@export var CurrentLevelData = {
	"Name":"",
	"Inventory":{},
	"PlayerPos":Vector2(),
	"PlayerRot":0,
	"Health":3,
	"IntermissionsReached":[],
	"BoatName":"",
	"LevelCoins":0,
	"Time":700,
	"Day":1,
	"Seed":1,
}

@export var SaveData = {
	"Coins":10,
}
