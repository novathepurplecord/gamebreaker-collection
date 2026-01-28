import FunkinBitmapText;

var songVersions = [
    "gamebreaker" => ["gamebreaker", "impersonator"],
    "gamebreaker-v2" => ["legacy", "oldest", "traced"]
];

var curSelectedType:Int = 0;

var selectCam = new FlxCamera();

var wiggleShader = new CustomShader('wiggle');

function create() {
    var sonicHudFont = FunkinBitmapText.fromXNA('images/hud/hudFont-v2-test', "ABCDEFGHIJKLM" + "NOPQRSTUVWXYZ" + "0123456789  % " + "+-:,");
    FlxG.cameras.add(selectCam, false).bgColor = 0;

    add(selectBox = new FlxSprite().makeSolid(800, 100, FlxColor.BLACK)).screenCenter();
    selectBox.y -= 5;
    selectBox.alpha = 0.8;
    selectBox.camera = selectCam;

    add(selectText = new FlxBitmapText(0, 0, 'VERSION:' + songVersions[curSelected][curSelectedType].toUpperCase(), sonicHudFont)).screenCenter();
    selectText.scale.set(3.7, 3.7);
    selectText.camera = selectCam;

    selectCam.addShader(wiggleShader);
}

function update() {
    if (controls.BACK) {
        close();
        persistentUpdate = !(persistentDraw = true);
    }

    if (controls.LEFT_P || controls.RIGHT_P) {
        CoolUtil.playMenuSFX(0);
        curSelectedType = (controls.LEFT_P) ? FlxMath.wrap(curSelectedType - 1, 0, songVersions[curSelected].length - 1) : FlxMath.wrap(curSelectedType + 1, 0, songVersions[curSelected].length - 1);
        selectText.text = 'VERSION:' + songVersions[curSelected][curSelectedType].toUpperCase();
        selectText.screenCenter();
    }

    if (controls.ACCEPT) (curSelected == 'gamebreaker') ? enterSong(songVersions[curSelected][curSelectedType]) : enterSong(curSelected + '-' + songVersions[curSelected][curSelectedType]);

    wiggleShader.iTime = Conductor.songPosition * 0.001;
}

function enterSong(_:Int) {
    PlayState.loadSong(_, "normal", null, null); 
    FlxG.switchState(new PlayState());
}