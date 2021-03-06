package entities;

import flixel.FlxG;
import screens.GameScreen;
import audio.BitdecaySoundBank.BitdecaySounds;
import audio.SoundBankAccessor;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import entities.Throwable;

class FireArt extends FlxSprite {
    public var currentAnimation = "raging";

    var hasParent:Bool = false;

    var hurtboxSize:FlxPoint = new FlxPoint(28, 16);
    var parent:Fire;
    public var onConsume:Throwable->Void;

    public function new(x:Float, y:Float, parent:Fire) {
        super(x, y);
        this.parent = parent;
        immovable = true;

        if (parent != null) {
            hasParent = true;
        }

        super.loadGraphic(AssetPaths.Fire__png, true, 32, 48);

        // an extra -2 on the y to help account for empty space at the bottom of the sprites
		offset.set(width / 2 - hurtboxSize.x / 2, height - hurtboxSize.y - 2);
        setSize(hurtboxSize.x, hurtboxSize.y);
        
        animation.add("tiny", [0, 1, 2, 3], 15);
		animation.add("regular", [4, 5, 6, 7], 15);
		animation.add("raging", [8, 9, 10, 11], 15);
        animation.play(currentAnimation);
    }

    public function consume(thing:Throwable) {
        // Global lookups are da best
		try {
            var gameState = cast(FlxG.state, GameScreen);
            if (gameState.isMainSongPlaying){
                // FlxG.camera.flash(0.05);
                FlxG.camera.shake(0.002, .1);
            }
			gameState.victoryMgr.logAdded();
		} catch (msg:String) {}


        try {
            var throwable:Throwable = cast(thing, Throwable);
            SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.CampfireIgnite);
            if (throwable.name == "zombie") {
                SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.ZombieAttack);
            } else if (throwable.name != "log" && throwable.name != "skeleton") {
                SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.HumanBurn);
            }
        } catch( msg : String ) {
            throw 'Tried to consume something that wasn\'t throwable';
        }

        // TODO: maybe tweak things based on what hits the flame
        if (hasParent) {
            parent.addTime(5);
        }

        trace("fire.consume");
        if (onConsume != null) {
            trace("calling onConsume");
            onConsume(thing);
        } else {
            trace("killing in the name of");
            thing.kill();
        }
    }

    public function switchAnimation(newAnimation:String) {
        if (currentAnimation != newAnimation) {
            trace("switch to: " + newAnimation);
            if (newAnimation == "none") {
                kill();
            } else {
                animation.play(newAnimation);
            }
            currentAnimation = newAnimation;    
        }
    }

    override public function update(delta:Float):Void {
		super.update(delta);
    }
}