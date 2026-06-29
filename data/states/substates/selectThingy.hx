import FunkinBitmapText;
import funkin.menus.FreeplaySonglist;
import haxe.ds.StringMap;
using StringTools;

var songs = FreeplaySonglist.get().songs; // array of song objects
var songVersions:StringMap<Array<ChartMetaData>> = new StringMap(); // key = selectedVersion, value = array of song metadata objects
var selectedIndex:Int = 0; // index of the currently selected song version
var curVersionSongs:Array<ChartMetaData>; // array of song metadata for the selected version like [legacy, kade, etc]

var selectCam = new FlxCamera();
var wiggleShader = new CustomShader('wiggle');

var selectedVersion:String = data; // data - var from gamebreakerState.hx, like v1 or v2

function create() {
	// fucking hell
	if (!songVersions.exists("v1")) songVersions.set("v1", []);
	if (!songVersions.exists("v2")) songVersions.set("v2", []);
    
	for (song in songs) songVersions.get(song.name.contains('gamebreaker-v2') ? "v2" : "v1").push(song);
    
    curVersionSongs = songVersions.get(selectedVersion);

	var sonicHudFont = FunkinBitmapText.fromXNA('images/hud/hudFont-v2', "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'\"% +-:,<>");
	FlxG.cameras.add(selectCam, false).bgColor = 0;

	add(selectBox = new FlxSprite().makeSolid(860, 100, FlxColor.BLACK)).screenCenter();
	selectBox.y -= 5;
	selectBox.alpha = 0.8;
	selectBox.camera = selectCam;

	add(selectText = new FlxBitmapText(0, 0, '<VERSION:' + curVersionSongs[selectedIndex].displayName.toUpperCase() + '>', sonicHudFont)).screenCenter();
	selectText.autoSize = false;
	selectText.alignment = 'center';
	selectText.scale.set(4, 4);
	selectText.camera = selectCam;

	selectCam.addShader(wiggleShader);
}

function update() {
	var left = controls.LEFT_P;
    var right = controls.RIGHT_P;
    var scroll = FlxG.mouse.wheel;

    if (left || right || scroll != 0) changeItem((left ? -1 : 0) + (right ? 1 : 0) - scroll);

	if (controls.ACCEPT) enterSong(curVersionSongs[selectedIndex].name);

	if (controls.BACK) {
		CoolUtil.playMenuSFX(2);
		close();
	}

	wiggleShader.iTime = Conductor.songPosition * 0.001;
}

function changeItem(control:Int = 0) {
    selectedIndex = FlxMath.wrap(selectedIndex + control, 0, curVersionSongs.length - 1);
	selectText.text = '<VERSION:' + curVersionSongs[selectedIndex].displayName.toUpperCase() + '>';
    trace("Current Selected: " + curVersionSongs[selectedIndex].name);
    CoolUtil.playMenuSFX('0', 0.7);
}

function enterSong(songName:String) {
	CoolUtil.playMenuSFX(1).persist = true;
	PlayState.loadSong(songName, "normal", null, null);
	FlxG.switchState(new PlayState());
}
