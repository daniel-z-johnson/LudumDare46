package entities.enemies;

import audio.BitdecaySoundBank.BitdecaySounds;
import audio.SoundBankAccessor;
import flixel.math.FlxPoint;
import flixel.addons.display.FlxNestedSprite;
import managers.HitboxManager;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.FlxSprite;
import entities.Player;
import entities.Enemy;
import flixel.group.FlxGroup;
import hitbox.HitboxSprite;

class NecroDancer extends Enemy {
	var firepit:FlxSprite;
	var radiusAroundFirePit:Float = 150.0;
	var target:FlxPoint;
	var timer:Float = 0.0;
	var maxTimeToMove:Float = 5.0;
	var attackTimer:Float = 0.0;
	var maxAttackTimer:Float = 6.0;
	var zombieOffset:Float = 20;
	var curZombies:List<FlxSprite>;

	public function new(hitboxMgr:HitboxManager, firepit:FlxSprite) {
		super(hitboxMgr);
		this.firepit = firepit;
		initAnimations(AssetPaths.Necromancer__png);
		name = "necrodancer";
		personalBubble = 50;
		speed = 80;
		attackDistance = 80;
		randomizeStats();
		invulnerableWhileAttacking = false;
		target = new FlxPoint();
		attackTimer = maxAttackTimer;
		curZombies = new List<FlxSprite>();
	}

	override public function randomizeStats() {
		super.randomizeStats();
		maxTimeToMove = randomizeStat(maxTimeToMove);
		maxAttackTimer = randomizeStat(maxAttackTimer);
		zombieOffset = randomizeStat(zombieOffset);
		radiusAroundFirePit = randomizeStat(radiusAroundFirePit);
	}

	override function shouldAttack():Bool {
		if (attackTimer < 0) {
			attackTimer = maxAttackTimer;
			return true;
		}
		return false;
	}

	override function attack():Void {
		super.attack();
		SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.NecromancerRise);
		SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.ZombieGroan);

		var toRemove:List<FlxSprite> = new List<FlxSprite>();
		for (zom in curZombies) {
			if (zom == null || !zom.alive) {
				toRemove.add(zom);
			}
		}
		for (zom in toRemove) {
			curZombies.remove(zom);
		}
		var count = curZombies.length;
		if (count < 4)
			spawnZombie(-zombieOffset, -zombieOffset);
		if (count < 3)
			spawnZombie(zombieOffset, -zombieOffset);
		if (count < 2)
			spawnZombie(zombieOffset, zombieOffset);
		if (count < 1)
			spawnZombie(-zombieOffset, zombieOffset);
	}

	private function spawnZombie(offsetX:Float, offsetY:Float) {
		var e = new SpookySpookySkeleton(hitboxMgr);
		e.x = x + offsetX;
		e.y = y + offsetY;
		e.getKnockedOut();
		hitboxMgr.addEnemy(e);
		curZombies.add(e);
	}

	function randomTarget() {
		target.set(rnd.float(-1, 1) * radiusAroundFirePit, rnd.float(-1, 1) * radiusAroundFirePit);
		target.add(firepit.x, firepit.y);
		timer = maxTimeToMove;
	}

	function moveTowardsTarget():FlxVector {
		var v = new FlxVector(0, 0);
		v.set(target.x - x, target.y - y);
		v.normalize();
		v.scale(speed);
		return v;
	}

	override function update(delta:Float) {
		super.update(delta);
		timer -= delta;
		if (timer < 0) {
			randomTarget();
		}
		attackTimer -= delta;
	}

	override function calculateVelocity() {
		if (enemyState == CHASING) {
			if (FlxMath.distanceToPoint(this, target) <= attackDistance) {
				velocity.set(0, 0);
			} else {
				var move = moveTowardsTarget();
				var keepDistance = keepDistanceFromOtherEnemies();
				velocity.set(move.x + keepDistance.x, move.y + keepDistance.y);
			}
		}
	}

	// every hit is a strong hit against the weak necro dancer
	override public function takeHit(hitterPosition:FlxPoint, force:Float = 1, strong:Bool = false):Void {
		super.takeHit(hitterPosition, force, true);
	}
}
