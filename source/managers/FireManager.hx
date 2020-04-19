package managers;

import flixel.FlxG;
import flixel.FlxSprite;
import entities.Fire;
import screens.GameScreen;

class FireManager {
	var game:GameScreen;
	var fire:Fire;
	var hitboxMgr:HitboxManager;

	public function new(game:GameScreen, hitboxMgr:HitboxManager) {
		var fireX = hitboxMgr.getPlayer().getPosition().x;
		var fireY = hitboxMgr.getPlayer().getPosition().y - 80;

		this.game = game;
		this.hitboxMgr = hitboxMgr;

		fire = new Fire(fireX, fireY, 30);
	
		game.add(fire);
		fire.start();
	}

	public function getSprite():FlxSprite {
		return fire.fireArt;
	}

	public function update(delta:Float) {
		var screenPos = fire.fireArt.getMidpoint();
		// var screenPos = hitboxMgr.getPlayer().getMidpoint();
		// trace("Raw pos: " + screenPos);
		// trace("Cam scroll: " + FlxG.camera.scroll);
		screenPos.subtract(FlxG.camera.scroll.x , FlxG.camera.scroll.y );
		// trace("Adjust pos: " + screenPos);
		// trace(FlxG.height);
		// trace(FlxG.width);
		screenPos.x /= FlxG.height;
		screenPos.y /= FlxG.width;
		// trace("Shader pos: " + screenPos);
		game.shader.firePos.value = [screenPos.x, screenPos.y];

	}
}
