extends Node

const SEARCH_OPPONENT = "search_opponent"
const OPPONENT_FOUND = "opponent_found"
const BUILD_BATTLEFIELD = "build_battlefield"
const SEND_BATTLEFIELD = "send_battlefield"
const START_GAME = "start_game"
const TURN_STARTED = "turn_started"
const INITIAL_TURN_FINISHED = "initial_turn_finished"
const ADDING_TO_QUEUE = "adding_to_queue"
const REMOVING_FROM_QUEUE = "removing_from_queue"
const TURN_FINISHED = "turn_finished"
const MOVING_TROOP = "moving_troop"
const GIVE_UP = "give_up"
const GAME_OVER = "game_over"
const DETECTED_CHEATING = "detected_cheating"

const VALID_REQUEST_IDS: Array = [
	SEARCH_OPPONENT,
	SEND_BATTLEFIELD,
	START_GAME,
	TURN_STARTED,
	INITIAL_TURN_FINISHED,
	ADDING_TO_QUEUE,
	REMOVING_FROM_QUEUE,
	TURN_FINISHED,
	MOVING_TROOP,
	GAME_OVER,
	GIVE_UP,
	DETECTED_CHEATING
]

const VALID_RESPONSE_IDS: Array = [
	OPPONENT_FOUND,
	BUILD_BATTLEFIELD,
	SEND_BATTLEFIELD,
	START_GAME,
	TURN_STARTED,
	INITIAL_TURN_FINISHED,
	ADDING_TO_QUEUE,
	REMOVING_FROM_QUEUE,
	TURN_FINISHED,
	MOVING_TROOP,
	GAME_OVER
]
