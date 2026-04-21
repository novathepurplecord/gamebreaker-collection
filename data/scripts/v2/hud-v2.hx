import flixel.effects.FlxFlicker;
import flixel.util.FlxStringUtil;
import FunkinBitmapText;

public var camSonic = new FlxCamera(0, 0, 1920, 960, 1);
var sonicHudFont = FunkinBitmapText.fromXNA('images/hud/hudFont-v2', "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'\"% +-:,");
var sonicHealthFont = FunkinBitmapText.fromMono('images/hud/lifeFont', "0123456789%");

function create() {
    //new cam for hud
    FlxG.cameras.insert(camSonic, members.indexOf(camHUD), false).bgColor = 0;

    //text (yellow one)
    add(scoreText = new FlxBitmapText(68, 68, 'SCORE', sonicHudFont)).camera = camSonic;
    add(timeText = new FlxBitmapText(scoreText.x, scoreText.y + 64, 'TIME', sonicHudFont)).camera = camSonic;
    add(missesText = new FlxBitmapText(scoreText.x, timeText.y + 64, 'MISSES', sonicHudFont)).camera = camSonic;

    for (text in [scoreText, timeText, missesText]) {
        text.scale.set(4, 4);
        text.updateHitbox();
        text.color = FlxColor.YELLOW;
        text.autoSize = false;
        text.alignment = 'left';
    }

    //numbers (white ones)
    add(scoreNum = new FlxBitmapText(scoreText.x + 409, scoreText.y, null, sonicHudFont)).camera = camSonic;
    add(timeNum = new FlxBitmapText(timeText.x + 311, timeText.y, null, sonicHudFont)).camera = camSonic;
    add(missesNum = new FlxBitmapText(missesText.x + 312, missesText.y, null, sonicHudFont)).camera = camSonic;

    for (num in [scoreNum, timeNum, missesNum]) {
        num.scale.set(4, 4);
        num.updateHitbox();
        num.autoSize = false;
        num.alignment = 'right';
    };

    //sonic life icon
    add(lifeIcon = new FlxSprite(scoreText.x, 820, Paths.image("hud/sonicLifeCounter-v2"))).camera = camSonic;

    //healthbar
    add(healthNum = new FlxBitmapText(lifeIcon.x + 136, lifeIcon.y + 46, null, sonicHealthFont)).camera = camSonic;
    healthNum.autoSize = false;
    healthNum.alignment = 'left';

    for (num in [lifeIcon, healthNum]) {
        num.scale.set(4, 4);
        num.updateHitbox();
    }
}

function postCreate() {
    //hidin everything
    healthBar.visible = healthBarBG.visible = iconP1.visible = iconP2.visible = false;
    scoreTxt.visible = accuracyTxt.visible = missesTxt.visible = false;
}

function update() if (curBeat >= 140) camSonic.zoom = CoolUtil.fpsLerp(camSonic.zoom, 1, 0.045);

function beatHit(_) if (_ >= 140 && _ % 2 == 0) camSonic.zoom += 0.03;

function postUpdate() {
    var curTime = FlxStringUtil.formatTime(inst.time * 0.001);
    var curHealth = Math.floor(health * 50);
    timeNum.text = curTime;
    scoreNum.text = Math.max(songScore);
    missesNum.text = misses;
    healthNum.text = curHealth + "%";
}

function onPlayerMiss() FlxFlicker.flicker(missesText, 0, 0.15, true, false, () -> missesText.color = FlxColor.RED, () -> {
    missesText.visible = true;
    missesText.color = (missesText.color == FlxColor.RED) ? FlxColor.YELLOW : FlxColor.RED;
});