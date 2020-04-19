package entities;

import flixel.FlxSprite;

class TreeLog extends Throwable {

	public function new() {
		super();
		super.loadGraphic(AssetPaths.itemsNobjects__png, true, 30, 40);
		
		var hurtboxWidth = 20;
		var hurtboxHeight = 6;

		offset.set((width / 2) - (hurtboxWidth / 2), height - hurtboxHeight);
		setSize(hurtboxWidth, hurtboxHeight);

		animation.add("log", [0], 0);
		animation.play("log");

		state = PICKUPABLE;
	}
}