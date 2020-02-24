#Autoload
extends Node

enum ItemMoveType {
	#entity cannot input movement when item is being used
	NO_MOVE,

	#entity can input movement, but they cannot change the direction they are facing
	STIFF_MOVE,

	#entity can move normally
	MOVE
}

enum TileType {
	GROUND,
	SHALLOW_WATER,
	DEEP_WATER,
	HOLE,
	LAVA,
	LADDER
}

enum CollisionType {
	#Entities
	PLAYER,
	MONSTER,
	NPC,
	
	#Weapons
	BOMB_EXPLOSION,
	SWORD,
	ARROW,
	HAMMER,
	EXPLOSION,
	THROWN_PROJECTILE,
	SHIELD,
	
	#Other
	TILE_ATTRACTER,
	WIND
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

enum RoomTransitionType {
	PUSH,
	FADE, 
	LEVEL_CHANGE
}

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}
