extends Node

var DayEnded : bool = false

var SaveFileLoaded = false
var SaveFile : SaveLoadData = null

var CurrentDay = 1
var Coins = 0
var BroughtCoins = 0
var LevelSelecting = false
const AdvanceTime = true

const STARTER_BOAT = "Basic_raft"

const SAVE_PATH = "user://save/"
const SAVE_NAME = "Save.tres"

const BOAT_SCALE_MODIFIERS : Dictionary = {
	"Basic_raft": 0.5,
	"Reinforced_raft": 0.5,
	"Aircraft_carrier": 0.5
}
const BOAT_STATS = {
	"Basic_raft":{
		"cost":0,
		"speed":3,
		"turn_speed":5,
		"hp":1,
		"coin_multiplier":1.0
	},"Reinforced_raft":{
		"cost":5,
		"speed":4,
		"turn_speed":4,
		"hp":3,
		"coin_multiplier":1.1 
	},"Basic_canoe":{
		"cost":10,
		"speed":4,
		"turn_speed":5,
		"hp":5,
		"coin_multiplier":1.5
	},"Reinforced_canoe":{
		"cost":25,
		"speed":5,
		"turn_speed":6,
		"hp":8,
		"coin_multiplier":1.5
	}, "Basic_sailboat":{
		"cost":40,
		"speed":5,
		"turn_speed":8,
		"hp":10,
		"coin_multiplier":2.0
	}, "Improved_sailboat":{
		"cost":60,
		"speed":6,
		"turn_speed":9,
		"hp":15,
		"coin_multiplier":2.5
	}, "Basic_motorboat":{
		"cost":90,
		"speed":7,
		"turn_speed":8,
		"hp":15,
		"coin_multiplier":3.0
	}, "Reinforced_motorboat":{
		"cost":130,
		"speed":7,
		"turn_speed":9,
		"hp":20,
		"coin_multiplier":3.5
	}, "Aircraft_carrier":{
		"cost":300,
		"speed":6,
		"turn_speed":4,
		"hp":60,
		"coin_multiplier":10
	}
}
var FoodItems = {
	"Beer":[0.2],
	"Gin":[0.3],
	"Wine":[0.5],
	"Gray_peas":[1],
	"Green_peas":[1],
	"Meat":[1],
	"Stockfish":[1],
	"Pickles":[1],
	"White_beans":[1],
	"Rice":[1],
	"Plums":[1],
	"Sauerkraut":[1],
	"Bacon":[1]
}
var Recipies = [
	["Beer","Green_peas","Stockfish"],
	["Wine","White_beans","Bacon","Pickles"],
	["Gin","Rice","Plums"],
	["Wine","Sauerkraut","Meat"],
	["Gin","Green_peas","Bacon"],
	["Beer","Plums","Rice"],
	["Gin","Meat","Gray_peas","Pickles"],
]

var RecipeBuffs = [
	[0.1,-0.1,0.0,0.0], # Speed, TurnSpeed, Health, CoinMultiplier
	[0.0,0.1,0.0,-0.1],
	[-0.05,0.0,0.0,0.1],
	[0.0,0.0,1.0,-0.1],
	[-0.05,0.1,0.0,0.0],
	[0.0,-0.05,0.0,0.1],
	[-0.05,0.0,2.0,0.0],
]
var LastRecipe = -1

var LevelName = "Tutorial"
var LevelData = {
	"Engeland":{"StartCoinCount":10, "LengthTiles":10, "Intermissions":[]},
	"Portugal":{"StartCoinCount":20, "LengthTiles":25, "Intermissions":[]},
	"KaapdegoedeHoop":{"StartCoinCount":35,"LengthTiles":60, "Intermissions":[25]},
	"Jakarta":{"StartCoinCount":80,"LengthTiles":100, "Intermissions":[25,60]},
	"Paaseiland":{"StartCoinCount":80,"LengthTiles":150, "Intermissions":[25,100]},
	"Tutorial":{"StartCoinCount":20,"LengthTiles":13, "Intermissions":[11]},
}

var Settings = {
	"MasterVolume":1.0,
	"MusicVolume":1.0,
}
