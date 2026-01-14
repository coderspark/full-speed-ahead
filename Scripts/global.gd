extends Node

const STARTER_BOAT = "basic_raft"

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
		"hp":5,
		"coin_multiplier":1.5
	}, "basic_sailboat":{
		"speed":6,
		"turn_speed":3,
		"hp":7,
		"coin_multiplier":2.0
	}, "improved_sailboat":{
		"speed":7,
		"turn_speed":4,
		"hp":8,
		"coin_multiplier":2.5
	}, "basic_motorboat":{
		"speed":9,
		"turn_speed":4,
		"hp":10,
		"coin_multiplier":3.0
	}, "reinforced_motorboat":{
		"speed":9,
		"turn_speed":3,
		"hp":15,
		"coin_multiplier":3.5
	}
}

var LevelName = ""
