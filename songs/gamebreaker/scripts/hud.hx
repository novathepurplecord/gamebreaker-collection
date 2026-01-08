import FunkinBitmapText;
import funkin.menus.ui.AlphabetAlignment;
import flixel.effects.FlxFlicker;

var curTime:Int;
var time:FunkinBitmapText;

var camSonic = new FlxCamera(0, 0, 1920, 960, 1);

function create() {
    FlxG.cameras.insert(camSonic, members.indexOf(camHUD), false).bgColor = 0;

    add(scoreText = new Alphabet(45, 45, 'SCORE:')).camera = camSonic;
    add(timeText = new Alphabet(scoreText.x, scoreText.y + 65, 'TIME:')).camera = camSonic;
    add(missesText = new Alphabet(scoreText.x, timeText.y + 65, 'MISSES:')).camera = camSonic;

    for (text in [scoreText, timeText, missesText]) {
        text.scale.set(0.8, 0.8);
        text.color = FlxColor.YELLOW;
    }

    add(lifeIcon = new FlxSprite(105, 842, Paths.image("hud/sonicLifeCounter"))).camera = camSonic;
    lifeIcon.scale.set(4, 4);

    add(scoreNum = new Alphabet(scoreText.x + 370, scoreText.y, 'scor', 40)).camera = camSonic;
    add(timeNum = new Alphabet(timeText.x + 180, timeText.y, 'tim', 40)).camera = camSonic;
    add(misesNum = new Alphabet(missesText.x + 340, missesText.y, 'miss', 40)).camera = camSonic;
    add(healthNum = new Alphabet(lifeIcon.x + 60, 820, 'heal', 40)).camera = camSonic;
    add(percent = new Alphabet(0, 820, '%')).camera = camSonic;

    for (num in [scoreNum, timeNum, misesNum, healthNum, percent]) num.scale.set(0.8, 0.8);

}

function update() camSonic.zoom = CoolUtil.fpsLerp(camSonic.zoom, 1, 0.045);

function beatHit(_) if (_ >= 140 && _ % 2 == 0) camSonic.zoom += 0.03;

function postUpdate() {
    curTime = CoolUtil.addZeros(Std.int(Conductor.songPosition / 1000), 3);
    curHealth = Std.string(Std.int(health * 50));

    timeNum.text = curTime;
    scoreNum.text = songScore;
    misesNum.text = misses;
    healthNum.text = curHealth;
    percent.x = healthNum.x + healthNum.width + 10;
}

function onPlayerMiss() FlxFlicker.flicker(missesText, 0, 0.4, true, false);