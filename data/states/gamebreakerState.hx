import FunkinBitmapText;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;
import funkin.menus.ui.effects.WaveEffect;
import flixel.addons.display.FlxBackdrop;
import openfl.display.BlendMode;

static var gameBreakings:Array<String> = ['gamebreaker', 'gamebreaker-v2'];
var realBreakings:FlxSpriteGroup;

static var curSelected:String;

var dxBackdropCam:FlxCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);

var fishEye:CustomShader = new CustomShader("fisheye");

function create() {
    FlxG.mouse.visible = true;
    CoolUtil.playMusic(Paths.music('gamebreakMusic'));

    FlxG.camera.bgColor = 0;

    FlxG.cameras.insert(dxBackdropCam, members.indexOf(FlxG.camera), false).bgColor = 0;
    dxBackdropCam.addShader(fishEye);
    fishEye.max_power = 0.2;

    add(dxBackBackdrop = new FlxBackdrop(Paths.image('characters/2dx'), null, 0, 0));
    dxBackBackdrop.alpha = 0.7;
    dxBackBackdrop.camera = dxBackdropCam;
    dxBackBackdrop.scale.set(0.5, 0.5);

    add(selectTxt = new Alphabet(0, 40, 'SELECT YOUR GAMEBREAKER')).screenCenter(FlxAxes.X);
    selectTxt.effects = [new WaveEffect()];
    selectTxt.scale.set(0.9, 0.9);

    add(optionsTxt = new Alphabet(0, 620, 'OPTIONS')).screenCenter(FlxAxes.X);
    optionsTxt.scale.set(0.9, 0.9);

    add(realBreakings = new FlxSpriteGroup());

    for (i => songName in gameBreakings) {
        add(songName = new FlxSprite(0, 0, Paths.image('previews/' + songName)));
        CoolUtil.setSpriteSize(songName, 500, 400);
        songName.x = 110 + (i * 550);
        songName.screenCenter(FlxAxes.Y);
        realBreakings.add(songName);
    }

    add(dxBackdrop = new FlxBackdrop(Paths.image('characters/dx2-v2-spritemap/spritemap1')));
    dxBackdrop.velocity.set(50, 50);
    dxBackdrop.alpha = 0.2;
    dxBackdrop.blend = BlendMode.ADD;
}

var targetVelDxBack:Int = -100;

function update() {
    if (FlxG.mouse.overlaps(optionsTxt)) {
        optionsTxt.color = FlxColor.YELLOW;
        if (FlxG.mouse.justPressed) FlxG.switchState(new OptionsMenu());
    }
    else optionsTxt.color = FlxColor.WHITE;

    for (i => obj in realBreakings.members) {
        if (FlxG.mouse.overlaps(obj)) {
            obj.setGraphicSize(520, 420);
            if (FlxG.mouse.justPressed) {
                curSelected = gameBreakings[i];
                superOpenSubState('substates/selectThingy');
            }
        }
        else obj.setGraphicSize(500, 400);
    }

    if (controls.SWITCHMOD || controls.DEV_ACCESS) {
		openSubState((controls.SWITCHMOD) ? new ModSwitchMenu() : new EditorPicker());
		persistentUpdate = !(persistentDraw = true);
	}

    dxBackdrop.scale.x = 0.5 + Math.sin(Conductor.songPosition * 0.001) * 0.05;
    dxBackdrop.scale.y = 0.5 + Math.cos(Conductor.songPosition * 0.001) * 0.05;

    targetVelDxBack = CoolUtil.fpsLerp(targetVelDxBack, -100, 0.1);
    dxBackBackdrop.velocity.set(targetVelDxBack, targetVelDxBack);

    FlxG.camera.zoom = CoolUtil.fpsLerp(FlxG.camera.zoom, 1, 0.1);
    dxBackdropCam.zoom = FlxG.camera.zoom;
}

function beatHit(_:Int) {
    targetVelDxBack -= 300;
    (_ % 2 == 0) ? FlxG.camera.zoom += 0.02 : FlxG.camera.zoom -= 0.02;
    if (_ == 32) FlxTween.tween(dxBackBackdrop, {angle: 90}, 1, {ease: FlxEase.sineOut, type: FlxTween.PINGPONG, delay: 1});
}


function superOpenSubState(_:Int) {
    openSubState(new ModSubState(_));
    CoolUtil.playMenuSFX(1);
    persistentUpdate = !(persistentDraw = true);
}