package entities;

import flixel.FlxG;
import constants.GameConstants;
import flixel.math.FlxPoint;
import managers.HitboxManager;
import flixel.group.FlxGroup;

using extensions.FlxObjectExt;

class PlayerGroup extends FlxGroup {
	var hitboxMgr:HitboxManager;

	public var player:Player;
	public var activelyCarrying:Bool = false;
	
	var carryingObject:Throwable;

	public function new(hitboxMgr:HitboxManager) {
		super(0);
		this.hitboxMgr = hitboxMgr;
		player = new Player(this, hitboxMgr);
		player.x = GameConstants.GAME_START_X;
		player.y = GameConstants.GAME_START_Y;
		FlxG.watch.add(player, "x", "PlayerX: ");
		FlxG.watch.add(player, "y", "PlayerY: ");
		add(player);
		hitboxMgr.addGeneral(player);
	}

	public function pickUp(thing:Throwable) {
		if (activelyCarrying) {
			return;
		}

		carryingObject = thing;
		activelyCarrying = true;
		thing.pickUp(new FlxPoint(thing.width/2, player.offset.y + 29));
		update(0);
		player.hoist();
	}

	public function throwThing() {
		var dir = player.getThrowDir();
		carryingObject.getThrown(dir.scale(300), 100);
		activelyCarrying = false;
		player.chuck();
	}

	override public function update(delta:Float) {
		if (activelyCarrying) {
			carryingObject.setMidpoint(player.getMidpoint().x, player.getMidpoint().y);
		}
	}
}