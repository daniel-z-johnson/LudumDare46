package managers;

import flixel.FlxBasic;
import entities.Enemy;
import entities.enemies.ConfusedZombie;
import entities.enemies.RegularAssZombie;
import entities.enemies.HardworkingFirefighter;
import flixel.math.FlxRandom;
import entities.Player;
import audio.SoundBankAccessor;
import audio.BitdecaySoundBank;
import hitbox.HitboxSprite;
import flixel.math.FlxVector;
import entities.TreeTrunk;
import flixel.util.FlxSort;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import shaders.NightShader;
import entities.PlayerGroup;
import entities.TreeGroup;
import flixel.FlxG;
import sorting.HitboxSorter;
import screens.GameScreen;
import managers.FireManager;
import entities.EnemyFlock;

class GameManager extends FlxBasic {
	var filters:Array<BitmapFilter> = [];
	var shader = new NightShader();

	var increasing:Bool = true;

	public var bitdecaySoundBank:BitdecaySoundBank;

	public function new(game:GameScreen, hitboxMgr:HitboxManager):Void {
		super();
		game.add(this);

		game.camera.filtersEnabled = true;
		filters.push(new ShaderFilter(shader));
		game.camera.bgColor = FlxColor.WHITE;
		game.camera.setFilters(filters);
		game.camera.zoom = 2;
		game.camera.follow(hitboxMgr.getPlayer());

		bitdecaySoundBank = new BitdecaySoundBank();
	}

	override public function update(elapsed:Float):Void {
		elapsed *= 0.1;
		if (increasing) {
			shader.time.value[0] = shader.time.value[0] + elapsed;
			if (shader.time.value[0] >= 1) {
				increasing = false;
			}
		} else {
			shader.time.value[0] = shader.time.value[0] - elapsed;
			if (shader.time.value[0] <= 0) {
				increasing = true;
			}
		}
	}
}
