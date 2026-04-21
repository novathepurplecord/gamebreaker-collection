import flixel.effects.FlxFlicker;
import flixel.util.FlxStringUtil;
import FunkinBitmapText;
import funkin.backend.utils.DiscordUtil;

public var camSonic = new FlxCamera(0, 0, 1920, 960, 1);
var sonicHudFont = FunkinBitmapText.fromXNA('images/hud/hudFont-v2', "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'\"% +-:,");
var sonicHealthFont = FunkinBitmapText.fromMono('images/hud/lifeFont', "0123456789%");

var gayShader2 = new CustomShader("gay");

function create() {
    //new cam for hud
    FlxG.cameras.insert(camSonic, members.indexOf(camHUD), false).bgColor = 0;
    camSonic.addShader(gayShader2);

    //text (yellow one)
    add(scoreText = new FlxBitmapText(67, 67, 'YOU', sonicHudFont)).camera = camSonic;
    add(timeText = new FlxBitmapText(scoreText.x, scoreText.y + 44.5, 'ARE', sonicHudFont)).camera = camSonic;
    add(missesText = new FlxBitmapText(scoreText.x, timeText.y + 44.5, 'GAY', sonicHudFont)).camera = camSonic;

    for (text in [scoreText, timeText, missesText]) {
        text.scale.set(4, 4);
        text.updateHitbox();
        text.color = FlxColor.YELLOW;
        text.autoSize = false;
        text.alignment = 'left';
    }

    //numbers (white ones)
    add(scoreNum = new FlxBitmapText(scoreText.x + 210, scoreText.y, null, sonicHudFont)).camera = camSonic;
    scoreNum.fieldWidth = 1710;
    add(timeNum = new FlxBitmapText(timeText.x + 210, timeText.y, null, sonicHudFont)).camera = camSonic;
    add(misesNum = new FlxBitmapText(missesText.x + 210, missesText.y, null, sonicHudFont)).camera = camSonic;

    for (num in [scoreNum, timeNum, misesNum]) {
        num.scale.set(4, 4);
        num.updateHitbox();
        //num.autoSize = false;
        num.alignment = 'center';
    };

    //sonic life icon
    add(lifeIcon = new FlxSprite(67, 820, Paths.image("hud/gay/sonicLifeCounter-v2-gay"))).camera = camSonic;
    if (DiscordUtil.ready) add(youaregay = new FlxSprite(67, 820).loadGraphic(DiscordUtil.user.getAvatar())).camera = camSonic;
    youaregay.scale.set(0.25, 0.25);
    youaregay.updateHitbox();

    //healthbar
    add(healthNum = new FlxBitmapText(lifeIcon.x + 136, lifeIcon.y + 45, null, sonicHealthFont)).camera = camSonic;
    healthNum.autoSize = false;
    healthNum.alignment = 'left';
    healthNum.fieldWidth = 400;
    healthNum.scale.set(3.95, 3.95);
    healthNum.updateHitbox();

    for (num in [lifeIcon]) {
        num.scale.set(4, 4);
        num.updateHitbox();
    }
}

function postCreate() healthBar.visible = healthBarBG.visible = iconP1.visible = iconP2.visible = false;

function update() if (curBeat >= 131) camSonic.zoom = CoolUtil.fpsLerp(camSonic.zoom, 1, 0.045);

function beatHit(_) if (_ >= 131) {
    camSonic.zoom += 0.03;
    scoreNum.text = FlxG.random.int(100, 200) + ":"  + FlxG.random.int(100, 200) + ":" + FlxG.random.int(0, 3) + ":" + FlxG.random.int(0, 3);
}

function postUpdate() {
    var curTime = FlxStringUtil.formatTime(Conductor.songPosition);
    var curHealth = Math.floor(health * 50);
    timeNum.text = curTime;
    if (curBeat <= 130) scoreNum.text = Math.max(songScore);
    misesNum.text = "BREAKER " + misses;
    healthNum.text = 69 + curHealth + "%";

    scoreTxt.text = "SCORE: GAY";
    accuracyTxt.text = "ACCURACY: GAY";
    missesTxt.text = "MISSES: GAY";
}

function onPlayerMiss() FlxFlicker.flicker(missesText, 0, 0.15, true, false, () -> missesText.color = FlxColor.RED, () -> {
    missesText.visible = true;
    missesText.color = (missesText.color == FlxColor.RED) ? FlxColor.YELLOW : FlxColor.RED;
});