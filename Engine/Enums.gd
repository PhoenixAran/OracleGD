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

enum TileType {
	WATER,
	OCEAN,
	HOLE,
	LAVA
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

#Generic AI states that monster scripts can switch case on. 
enum EnemyState {
	DEAD,
	IDLE,
	HURT,
	MOVING,
	SEEKING,
	ATTACKING,
	IN_HITSTUN,
	IN_KNOCKBACK
}
