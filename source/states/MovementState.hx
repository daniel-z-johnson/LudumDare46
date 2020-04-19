package states;

import hitbox.HitboxSprite;
import flixel.math.FlxVector;
import entities.TreeTrunk;
import entities.Tree;
import flixel.util.FlxSort;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxCollision;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import shaders.NightShader;
import entities.PlayerGroup;
import entities.TreeGroup;
import entities.TreeLog;
import flixel.FlxG;
import flixel.FlxState;
import sorting.HitboxSorter;

class MovementState extends FlxState
{
	var playerGroup:PlayerGroup;
	var treeGroup:TreeGroup;
	var itemGroup:FlxGroup;
	var playerHitboxes:FlxTypedGroup<HitboxSprite>;

	var sortGroup:FlxSpriteGroup;
	
	var filters:Array<BitmapFilter> = [];
	var shader = new NightShader();
	
	var increasing:Bool = true;

	override public function create():Void
	{
		super.create();
		// FlxG.debugger.visible = true;
		FlxG.debugger.drawDebug = true;
		
		sortGroup = new FlxSpriteGroup(0);
		add(sortGroup);
		playerHitboxes = new FlxTypedGroup<HitboxSprite>(0);
		add(playerHitboxes);

		playerGroup = new PlayerGroup(sortGroup, playerHitboxes);

		treeGroup = new TreeGroup();
		treeGroup.spawn(2);
		treeGroup.forEach(t -> {
			sortGroup.add(t.trunk);
			sortGroup.add(t.top);
		});

		itemGroup = new FlxGroup(0);
		
		camera.filtersEnabled = true;
		filters.push(new ShaderFilter(shader));
		camera.bgColor = FlxColor.WHITE;
		camera.setFilters(filters);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		sortGroup.sort(HitboxSorter.sort, FlxSort.ASCENDING);
		
		// Environment restrictions
		FlxG.collide(playerGroup, treeGroup);
		FlxG.collide(itemGroup, treeGroup);

		// Environment interactions
		FlxG.collide(playerGroup, itemGroup);
		FlxG.overlap(playerHitboxes, itemGroup, handlePlayerHit);
		FlxG.overlap(playerHitboxes, treeGroup, hitTree);
		
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

	private function hitTree(player: FlxSprite, tree: TreeTrunk) {
		if (tree.hasLog) {
			var interactVector:FlxVector = player.getMidpoint();
			interactVector.subtractPoint(tree.getMidpoint());
			var newLog = tree.spawnLog(interactVector);
			itemGroup.add(newLog);
			sortGroup.add(newLog);
		}
	}

	private static function handlePlayerHit(player: FlxSprite, item: FlxSprite) {
		var interactVector:FlxVector = player.getMidpoint();
			interactVector.subtractPoint(item.getMidpoint());
		if (interactVector.x > 0) {
			item.velocity.x = -300;
		} else {
			item.velocity.x = 300;
		}
	}
}
