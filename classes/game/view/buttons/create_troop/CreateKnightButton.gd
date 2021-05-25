extends CreateTroopButton

func _ready():
	self.troop_type = TroopType.KNIGHT
	set_hint()
