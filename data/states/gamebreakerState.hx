import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;
import funkin.menus.ui.effects.WaveEffect;
import flixel.addons.display.FlxBackdrop;
import openfl.display.BlendMode;

var gameBreakings:Array<String> = ['v1', 'v2'];
var realBreakings:FlxSpriteGroup;

var dxBackdropCam:FlxCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);

var fishEye:CustomShader = new CustomShader("fisheye");

function create() {
    FlxG.mouse.visible = true;
    CoolUtil.playMusic(Paths.music('gamebreakMusic'));

    FlxG.camera.bgColor = 0;

    FlxG.cameras.insert(dxBackdropCam, members.indexOf(FlxG.camera), false).bgColor = 0;
    dxBackdropCam.addShader(fishEye);
    fishEye.max_power = 0.2;

    add(dxBackBackdrop = new FlxBackdrop(Paths.image('characters/v1/2dx'), null, 0, 0));
    dxBackBackdrop.alpha = 0.7;
    dxBackBackdrop.camera = dxBackdropCam;
    dxBackBackdrop.scale.set(0.5, 0.5);

    add(selectTxt = new Alphabet(0, 70, 'SELECT YOUR GAMEBREAKER')).screenCenter(FlxAxes.X);
    selectTxt.effects = [new WaveEffect()];
    selectTxt.scale.set(0.9, 0.9);

    add(optionsTxt = new Alphabet(0, FlxG.height - 140, 'OPTIONS')).screenCenter(FlxAxes.X);
    optionsTxt.scale.set(0.9, 0.9);

    add(realBreakings = new FlxSpriteGroup());

    for (i => songName in gameBreakings) {
        add(songName = new FlxSprite(0, 0, Paths.image('previews/' + songName)));
        CoolUtil.setSpriteSize(songName, 500, 400);
        songName.x = 110 + (i * 550);
        songName.screenCenter(FlxAxes.Y);
        realBreakings.add(songName);
    }

    add(dxBackdrop = new FlxBackdrop(Paths.image('notes/dx')));
    dxBackdrop.velocity.set(50, 50);
    dxBackdrop.alpha = 0.2;
    dxBackdrop.blend = BlendMode.ADD;
}

var targetVelDxBack:Int = -100;

function update() {
    optionsTxt.color = FlxG.mouse.overlaps(optionsTxt) ? FlxColor.YELLOW : FlxColor.WHITE;
    if (FlxG.mouse.overlaps(optionsTxt) && FlxG.mouse.justPressed) {
        CoolUtil.playMenuSFX(2).persist = true;
        FlxG.switchState(new OptionsMenu());
    }

    for (i => obj in realBreakings.members) {
        obj.setGraphicSize(FlxG.mouse.overlaps(obj) ? 520 : 500, FlxG.mouse.overlaps(obj) ? 420 : 400);
        if (FlxG.mouse.overlaps(obj) && FlxG.mouse.justPressed) superOpenSubState('substates/selectThingy', gameBreakings[i]);
    }

    if (controls.SWITCHMOD || controls.DEV_ACCESS) {
        openSubState((controls.SWITCHMOD) ? new ModSwitchMenu() : new EditorPicker());
        persistentUpdate = !(persistentDraw = true);
    }

    dxBackdrop.scale.x = 0.5 + FlxMath.fastSin(Conductor.songPosition * 0.001) * 0.05;
    dxBackdrop.scale.y = 0.5 + FlxMath.fastCos(Conductor.songPosition * 0.001) * 0.05;

    targetVelDxBack = CoolUtil.fpsLerp(targetVelDxBack, -100, 0.1);
    dxBackBackdrop.velocity.set(targetVelDxBack, targetVelDxBack);

    FlxG.camera.zoom = CoolUtil.fpsLerp(FlxG.camera.zoom, 1, 0.1);
    dxBackdropCam.zoom = FlxG.camera.zoom;
}

function beatHit(_:Int) {
    targetVelDxBack -= 300;
    (_ % 2 == 0) ? FlxG.camera.zoom += 0.02 : FlxG.camera.zoom -= 0.02;
    // ignore % 1 == 0 its placeholder i know that it'll always be true
    if (_ >= 32 && _ % 1 == 0) FlxTween.tween(dxBackBackdrop, {angle: dxBackBackdrop.angle + 90}, (Conductor.stepCrochet * 0.001) * 8, {ease: FlxEase.sineOut});
}

function superOpenSubState(_:Int, stateData:String) {
    openSubState(new ModSubState(_, stateData));
    CoolUtil.playMenuSFX(1);
    FlxTween.cancelTweensOf(dxBackBackdrop);
    persistentUpdate = !(persistentDraw = true);
}