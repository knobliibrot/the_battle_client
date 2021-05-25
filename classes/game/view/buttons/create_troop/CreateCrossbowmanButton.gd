extends CreateTroopButton

func _ready():
	self.troop_type = TroopType.CROSSBOWMAN
	set_hint()
