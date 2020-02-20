extends CreateTroopButton

func _ready():
	self.troop_type = TroopType.CATAPULT
	set_hint()
