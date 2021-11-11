extends Node

var search_opponent: Dictionary = {
  "id": "search_opponent",
  "data": {
	"user": ""    
  }
}

var opponent_found: Dictionary = {
  "id": "opponent_found",
  "data": {
	"opponent": "",
	"first_player": true
  }
}

var build_battlefield: Dictionary = { # not sure if can be done with opponent _found
  "id": "build_battlefield",
  "data": {}
}

var send_battlefield: Dictionary = {
  "id": "send_battlefield",
  "data": {
	"battlefield": []
  }
}

var start_game: Dictionary = {
  "id": "start_game",
  "data": {}
}

var turn_started: Dictionary = {
  "id": "turn_started",
  "data": {
	"starting_time": 0
  }
}

var initial_turn_finished: Dictionary = {
  "id": "initial_turn_finished",
  "data": {
	"selected_troops": [],
	"castel_position": {
		"x": 0,
		"y": 0
	}
  }
}

var adding_to_queue: Dictionary = {
  "id": "adding_to_queue",
  "data": {
	"troop_type": 0
  }
}

var removing_from_queue: Dictionary = {
  "id": "removing_from_queue",
  "data": {
	"queue_pos": 0
  }
}

var turn_finished: Dictionary = {
  "id": "turn_finished",
  "data": {}
}

var moving_troop: Dictionary = {
  "id": "moving_troop",
  "data": {
	"from": {
		"x": 0,
		"y": 0
	},
	"to": {
		"x": 0,
		"y": 0
	}
  }
}

#Don't think it's necesary update: may it is
#var change_foodpoints: Dictionary = {
#  "id": "",
#  "data": {}
#}
#
#var change_healthpoints: Dictionary = {
#  "id": "",
#  "data": {}
#}

var give_up: Dictionary = {
  "id": "give_up",
  "data": {}
}

var game_over: Dictionary = {
  "id": "game_over",
  "data": {
	"player": ""
	}
}

var detected_cheating: Dictionary = {
  "id": "detected_cheating",
  "data": {
	"snapshot": {}
  }
}
