extends Node

var DayEnded = false

var CurrentDay = 0
const AdvanceTime = true

const STARTER_BOAT = "Reinforced_motorboat"

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
		"speed":3,
		"turn_speed":3,
		"hp":3,
		"coin_multiplier":1.1 
	},"Basic_canoe":{
		"cost":10,
		"speed":4,
		"turn_speed":5,
		"hp":5,
		"coin_multiplier":1.5
	},"Reinforced_canoe":{
		"cost":15,
		"speed":4,
		"turn_speed":4,
		"hp":8,
		"coin_multiplier":1.5
	}, "Basic_sailboat":{
		"cost":25,
		"speed":6,
		"turn_speed":3,
		"hp":7,
		"coin_multiplier":2.0
	}, "Improved_sailboat":{
		"cost":40,
		"speed":7,
		"turn_speed":4,
		"hp":8,
		"coin_multiplier":2.5
	}, "Basic_motorboat":{
		"cost":90,
		"speed":9,
		"turn_speed":5,
		"hp":10,
		"coin_multiplier":3.0
	}, "Reinforced_motorboat":{
		"cost":130,
		"speed":9,
		"turn_speed":7,
		"hp":15,
		"coin_multiplier":3.5
	}, "Aircraft_carrier":{
		"cost":300,
		"speed":4,
		"turn_speed":3,
		"hp":30,
		"coin_multiplier":5
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
var LevelName = ""
var LevelData = {
	"Engeland":{"StartCoinCount":10, "LengthDays":3},
	"Portugal":{"StartCoinCount":20, "LengthDays":10},
	"KaapdegoedeHoop":{"StartCoinCount":40000,"LengthDays":15},
	"Jakarta":{"StartCoinCount":80,"LengthDays":25},
	"Paaseiland":{"StartCoinCount":80,"LengthDays":30},
}
