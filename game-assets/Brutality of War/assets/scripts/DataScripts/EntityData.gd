extends Resource
class_name entity_data

enum FACTIONS {
	NATO,
	WarsawPact
}

export (FACTIONS) var faction = FACTIONS.NATO
export (int) var cost = 100
export (int) var health = 100
