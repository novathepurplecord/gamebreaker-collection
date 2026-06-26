import flixel.effects.FlxFlicker;
import flixel.util.FlxStringUtil;
import FunkinBitmapText;

public var camSonic = new FlxCamera(0, 0, 1920, 960, 1);
var sonicHudFont = FunkinBitmapText.fromXNA('images/hud/hudFont', "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'\"% +-.,");

function create() {
    //new cam for hud
    FlxG.cameras.insert(camSonic, members.indexOf(camHUD), false).bgColor = 0;

    //text (yellow one)
    add(scoreText = new FlxBitmapText(67, 67, 'SCORE', sonicHudFont)).camera = camSonic;
    add(timeText = new FlxBitmapText(scoreText.x, scoreText.y + 64.5, 'TIME', sonicHudFont)).camera = camSonic;
    add(missesText = new FlxBitmapText(scoreText.x, timeText.y + 64.5, 'MISSES', sonicHudFont)).camera = camSonic;

    for (text in [scoreText, timeText, missesText]) {
        text.scale.set(4, 4);
        text.updateHitbox();
        text.color = 0xFFCFC00;
        text.autoSize = false;
        text.alignment = 'left';
    }

    //numbers (white ones)
    add(scoreNum = new FlxBitmapText(scoreText.x + 370, scoreText.y, null, sonicHudFont)).camera = camSonic;
    //scoreNum.fieldWidth = FlxG.width;
    add(timeNum = new FlxBitmapText(timeText.x + 245, timeText.y, null, sonicHudFont)).camera = camSonic;
    add(misesNum = new FlxBitmapText(missesText.x + 340, missesText.y, null, sonicHudFont)).camera = camSonic;

    for (num in [scoreNum, timeNum, misesNum]) {
        num.scale.set(4, 4);
        num.updateHitbox();
        num.autoSize = false;
        num.alignment = 'right';
    };

    //sonic life icon
    add(lifeIcon = new FlxSprite(67, 812, Paths.image("hud/sonicLifeCounter"))).camera = camSonic;

    //healthbar
    add(healthNum = new FlxBitmapText(0, lifeIcon.y + 38, null, sonicHudFont)).camera = camSonic;
    healthNum.autoSize = false;
    healthNum.alignment = 'left';

    for (num in [healthNum, lifeIcon]) {
        num.scale.set(4, 4);
        num.updateHitbox();
    }

    healthNum.x = lifeIcon.x + lifeIcon.width;
}

function postCreate() {
    //hidin everything
    healthBar.visible = healthBarBG.visible = iconP1.visible = iconP2.visible = false;
    scoreTxt.visible = accuracyTxt.visible = missesTxt.visible = false;
}

function update() if (curBeat >= 140) camSonic.zoom = CoolUtil.fpsLerp(camSonic.zoom, 1, 0.045);

function beatHit(_) if (_ >= ((PlayState.SONG.meta.name == 'impersonator') ? 146 : 140) && _ % 2 == 0) camSonic.zoom += 0.03;

function postUpdate() {
    var curTime = FlxStringUtil.formatTime(inst.time * 0.001);
    var curHealth = Math.floor(health * 50);
    timeNum.text = curTime;
    scoreNum.text = Math.max(songScore);
    misesNum.text = misses;
    healthNum.text = curHealth + "%";
    if (curHealth <= 25) FlxFlicker.flicker(healthNum, 0, 0.4, true, false);
    else {
        FlxFlicker.stopFlickering(healthNum);
        healthNum.visible = true;
    }
}

function onPlayerMiss() FlxFlicker.flicker(missesText, 0, 0.4, true, false);