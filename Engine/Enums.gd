extends Node
class_name Enums

enum ItemMoveType {
	#entity cannot input movement when item is being used
	NO_MOVE,

	#entity can input movement, but they cannot change the direction they are facing
	STIFF_MOVE,

	#entity can move normally
	MOVE
}

enum CollisionType {
	#Entities
	PLAYER,
	MONSTER,
	NPC,
	
	#Weapons
	SWORD,
	ARROW,
	HAMMER,
	EXPLOSION,
	THROWN_PROJECTILE
}
