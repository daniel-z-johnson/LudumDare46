package entities.enemies;

import managers.HitboxManager;
import entities.Player;
import entities.Enemy;
import flixel.group.FlxGroup;
import hitbox.HitboxSprite;

class RegularAssZombie extends Enemy {
	public function new(hitboxMgr:HitboxManager) {
		super(hitboxMgr);
		initAnimations(AssetPaths.Zombie__png);
		name = "zombie";
		personalBubble = 50;
		speed = 40;
		randomizeStats();
	}
}
