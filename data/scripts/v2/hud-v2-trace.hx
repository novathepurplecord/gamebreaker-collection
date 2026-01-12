import flixel.effects.FlxFlicker;
import flixel.util.FlxStringUtil;
import FunkinBitmapText;

var camSonic = new FlxCamera(0, 0, 1920, 960, 1);
var sonicHudFont = FunkinBitmapText.fromXNA('images/hud/FlxBitmapFontSonic-v2', "ABCDEFGHIJKLM" + "NOPQRSTUVWXYZ" + "0123456789  % " + "+-:,");
var sonicHealthFont = FunkinBitmapText.fromMono('images/hud/FlxBitmapFontLifeCounter-trace', "0123456789%");

function create() {
    //new cam for hud
    FlxG.cameras.insert(camSonic, members.indexOf(camHUD), false).bgColor = 0;

    //text (yellow one)
    add(scoreText = new FlxBitmapText(99, 69, 'GA', sonicHudFont)).camera = camSonic;
    add(timeText = new FlxBitmapText(scoreText.x - 20, scoreText.y + 65, 'ME', sonicHudFont)).camera = camSonic;
    add(missesText = new FlxBitmapText(scoreText.x, timeText.y + 60, 'TRACED', sonicHudFont)).camera = camSonic;

    for (text in [scoreText, timeText, missesText]) {
        text.scale.set(1.2, 1.2);
        text.color = FlxColor.fromString("#cceb34");
    }

    //sonic life icon
    add(lifeIcon = new FlxSprite(55, 800, Paths.image("hud/sonicLifeCounter-v2"))).camera = camSonic;

    //numbers (white ones)
    add(scoreNum = new FlxBitmapText(scoreText.x + 450, scoreText.y, 'scor', sonicHudFont)).camera = camSonic;
    scoreNum.autoSize = false;
    scoreNum.alignment = 'left';
    scoreNum.angle = 90;
    add(timeNum = new FlxBitmapText(timeText.x + 175, timeText.y, 'tim', sonicHudFont)).camera = camSonic;
    add(misesNum = new FlxBitmapText(missesText.x + 285, missesText.y + 10, 'miss', sonicHudFont)).camera = camSonic;

    //healthbar
    add(healthNum = new FlxBitmapText(lifeIcon.x + 145, 853, 'heal', sonicHealthFont)).camera = camSonic;
    healthNum.scale.set(0.9, 0.9);

}

function postCreate() {
    //hidin everything
    healthBar.visible = healthBarBG.visible = iconP1.visible = false;
    scoreTxt.visible = missesTxt.visible = false;
}

function update() if (curBeat >= 140) camSonic.zoom = CoolUtil.fpsLerp(camSonic.zoom, 1.03, 0.045);

function beatHit(_) if (_ >= 140 && _ % 2 == 0) camSonic.zoom -= 0.03;

function postUpdate() {
    var time = Math.floor(inst.time / 1000);
    var curHealth = Math.floor(health * 50);
    
    timeNum.text = FlxStringUtil.formatTime(time);
    scoreNum.text = songScore;
    misesNum.text = misses;
    healthNum.text = curHealth + "%";
}

function onPlayerMiss() FlxFlicker.flicker(missesText, 0, 0.15, true, false, () -> missesText.color = FlxColor.BLUE, () -> {
    missesText.visible = true;
    missesText.color = (missesText.color == FlxColor.BLUE) ? FlxColor.fromString("#cceb34") : FlxColor.BLUE;
});