extends Node

const STARTER_BOAT = "reinforced_canoe"

const BOAT_STATS = {
	"basic_raft":{
		"speed":2,
		"turn_speed":5,
		"hp":3,
		"coin_multiplier":1.0
	},"steel_raft":{
		"speed":2,
		"turn_speed":3,
		"hp":5,
		"coin_multiplier":1.1 
	},"canoe":{
		"speed":4,
		"turn_speed":5,
		"hp":2,
		"coin_multiplier":1.5
	},"reinforced_canoe":{
		"speed":4,
		"turn_speed":5,
		"hp":4,
		"coin_multiplier":1.5
	},
}

var LevelName = ""
