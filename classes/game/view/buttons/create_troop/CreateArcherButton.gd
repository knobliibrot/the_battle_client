extends CreateTroopButton

func _ready():
	self.troop_type = TroopType.ARCHER
	set_hint()
