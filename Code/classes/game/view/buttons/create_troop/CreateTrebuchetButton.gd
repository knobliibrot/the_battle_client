extends CreateTroopButton

func _ready():
	self.troop_type = TroopType.TREBUCHET
	set_hint()
