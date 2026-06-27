import FunkinBitmapText;
import funkin.menus.FreeplaySonglist;
import haxe.ds.StringMap;
using StringTools;

var freeplaySongList = FreeplaySonglist.get().songs; // array of song objects
var songVersions:StringMap<Array<ChartMetaData>> = new StringMap(); // key = curVersion, value = array of song metadata objects
var curSelectedType:Int = 0; // int for a type of song like legacy, kade, etc
var curVersion:Array<Any>; // array of song metadata for the currently selected song

var selectCam = new FlxCamera();
var wiggleShader = new CustomShader('wiggle');

// curSelected from gamebreakerState.hx is cur selected preview like v1 or v2

function create() {
	// fucking hell
	songVersions.set('v1', []);
	songVersions.set('v2', []);
    
	for (song in freeplaySongList) songVersions.get(song.name.contains('gamebreaker-v2') ? "v2" : "v1").push(song);
    
    curVersion = songVersions.get(curSelected);
    trace(songVersions);

	var sonicHudFont = FunkinBitmapText.fromXNA('images/hud/hudFont-v2', "ABCDEFGHIJKLM" + "NOPQRSTUVWXYZ" + "0123456789  % " + "+-:,");
	FlxG.cameras.add(selectCam, false).bgColor = 0;

	add(selectBox = new FlxSprite().makeSolid(800, 100, FlxColor.BLACK)).screenCenter();
	selectBox.y -= 5;
	selectBox.alpha = 0.8;
	selectBox.camera = selectCam;

	add(selectText = new FlxBitmapText(0, 0, 'VERSION:' + curVersion[curSelectedType].displayName.toUpperCase(), sonicHudFont)).screenCenter();
	selectText.autoSize = false;
	selectText.alignment = 'left';
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
		curSelectedType = FlxMath.wrap(curSelectedType + (controls.LEFT_P ? -1 : 1), 0, curVersion.length - 1);
		selectText.text = 'VERSION:' + curVersion[curSelectedType].displayName.toUpperCase();
	}

	if (controls.ACCEPT) enterSong(curVersion[curSelectedType].name);

	wiggleShader.iTime = Conductor.songPosition * 0.001;
}

function enterSong(songName:String) {
	PlayState.loadSong(songName, "normal", null, null);
	FlxG.switchState(new PlayState());
}
