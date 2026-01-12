import flixel.effects.FlxFlicker;
import flixel.util.FlxStringUtil;
import FunkinBitmapText;

var camSonic = new FlxCamera(0, 0, 1920, 960, 1);
var sonicHudFont = FunkinBitmapText.fromXNA('images/hud/FlxBitmapFontSonic1', "ABCDEFGHIJKLM" + "NOPQRSTUVWXYZ" + "0123456789'\"% " + "+$.,");

function create() {
    //new cam for hud
    FlxG.cameras.insert(camSonic, members.indexOf(camHUD), false).bgColor = 0;

    //text (yellow one)
    add(scoreText = new FlxBitmapText(130, 90, 'SCORE', sonicHudFont)).camera = camSonic;
    add(timeText = new FlxBitmapText(scoreText.x - 10, scoreText.y + 65, 'TIME', sonicHudFont)).camera = camSonic;
    add(missesText = new FlxBitmapText(scoreText.x + 15, timeText.y + 60, 'MISSES', sonicHudFont)).camera = camSonic;

    for (text in [scoreText, timeText, missesText]) {
        text.scale.set(4, 4);
        text.color = FlxColor.YELLOW;
    }

    //sonic life icon
    add(lifeIcon = new FlxSprite(105, 842, Paths.image("hud/sonicLifeCounter"))).camera = camSonic;

    //numbers (white ones)
    add(scoreNum = new FlxBitmapText(scoreText.x + 320, scoreText.y, 'scor', sonicHudFont)).camera = camSonic;
    scoreNum.autoSize = false;
    scoreNum.alignment = 'right';
    add(timeNum = new FlxBitmapText(timeText.x + 145, timeText.y, 'tim', sonicHudFont)).camera = camSonic;
    add(misesNum = new FlxBitmapText(missesText.x + 255, missesText.y, 'miss', sonicHudFont)).camera = camSonic;

    //healthbar
    add(healthNum = new FlxBitmapText(lifeIcon.x + 100, 860, 'heal', sonicHudFont)).camera = camSonic;

    for (num in [lifeIcon, scoreNum, timeNum, misesNum, healthNum]) num.scale.set(4, 4);

}

function postCreate() {
    //hidin everything
    healthBar.visible = healthBarBG.visible = iconP1.visible = iconP2.visible = false;
    scoreTxt.visible = accuracyTxt.visible = missesTxt.visible = false;
}

function update() if (curBeat >= 140) camSonic.zoom = CoolUtil.fpsLerp(camSonic.zoom, 1, 0.045);

function beatHit(_) if (_ >= 140 && _ % 2 == 0) camSonic.zoom += 0.03;

function postUpdate() {
    var curTime = FlxStringUtil.formatTime(inst.time / 1000);
    var curHealth = Math.floor(health * 50);
    timeNum.text = curTime;
    scoreNum.text = songScore;
    misesNum.text = misses;
    healthNum.text = curHealth + "%";
}

function onPlayerMiss() FlxFlicker.flicker(missesText, 0, 0.4, true, false);