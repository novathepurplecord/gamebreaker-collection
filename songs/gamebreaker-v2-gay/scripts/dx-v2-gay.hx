importScript("data/scripts/yoshi");
importScript("data/scripts/gay/hud-v2");
importScript("data/scripts/v2/camFollow-v2");
importScript("data/scripts/gay/dxMoveNotes");
importScript("data/scripts/betterSustains");

var camDX = new FlxCamera(20, -360, 1460, 1380, 1);
var camChars = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);

var dxShader = new CustomShader("dx");
var hotlineVHS = new CustomShader("hotlineVHS");
var gayShader = new CustomShader("gay");
var glitch = new CustomShader("glitch");

public var dx = strumLines.members[0].characters[0];
public var dxsad = strumLines.members[0].characters[1];
public var dx2 = strumLines.members[0].characters[2];

function create() {
    // cameras setup
    FlxG.cameras.insert(camChars, 2, false).addShader(gayShader);
    FlxG.cameras.insert(camDX, 1, false).angle = 90;
    camDX.addShader(dxShader);
    for (cam in [camDX, camBG, camera]) cam.addShader(gayShader);

    // character cameras visibility etc
    dx.camera = dxsad.camera = dx2.camera = bf.camera = camChars;
    dxsad.visible = dx2.visible = false;
}

var bfX:Int = 529;
var bfY:Int = 269;

// post create bf pos, zoom, dx notes pos, etc
function postCreate() {
    camera.zoom = defaultCamZoom; //phuck you cne

    bf.scale.set(2.2, 2.2);
    cpuStrums.camera = camDX;

    for (i in [gf, comboGroup]) remove(i);
    for (strums in cpuStrums.members) strums.x += 220;
}

// camera tuffs update
function update() {
    camDX.scroll.set(camera.scroll.x, camera.scroll.y);
    camDX.zoom = camera.zoom;

    camChars.scroll.set(camera.scroll.x, camera.scroll.y);
    camChars.zoom = camera.zoom;
}

var targetDxBfScale:Int = 2.2;

function postUpdate() {
    // shader itim
    hotlineVHS.iTime = Conductor.songPosition;
    glitch.iTime = Conductor.songPosition * 0.0001;

    // cam follo
    camera.zoom = CoolUtil.fpsLerp(camera.zoom, defaultCamZoom, 0.1);

    // scale things
    bfScale = CoolUtil.fpsLerp(bf.scale.x, curCameraTarget == 0 ? targetDxBfScale : 1.2, 0.1);
    bf.scale.set(bfScale, bfScale);
    bf.setPosition(bfX * bfScale, bfY * bfScale);
}

function stepHit(_:Int) {
    //cool bounce
    if (_ >= 558 && _ % 4 == 0) FlxTween.tween(camHUD, {y: 5}, 0.2, {ease: FlxEase.circOut});
    if (_ >= 558 && _ % 4 == 2) FlxTween.tween(camHUD, {y: 15}, 0.2, {ease: FlxEase.sineIn});

    switch (_) {
        case 127:
            dx.visible = !(dxsad.visible = true);
        case 278: 
            camChars.flash(FlxColor.RED, 1);
            dxsad.visible = !(dx2.visible = true);
            dx2.shader = glitch;
    }
}

var angleTwn:FlxTween;
var zoomTwn:FlxTween;

function beatHit(_:Int) {
    // cool bounce 2
    if (_ >= 131) {
        for (twn in [angleTwn, zoomTwn]) twn?.cancel();
        camHUD.zoom += 0.04;
        camChars.angle = (_ % 2 == 0) ? -5.75 : 5.75;
        angleTwn = FlxTween.tween(camChars, {angle: 0}, 0.5, {ease: FlxEase.quadInOut});
        zoomTwn = FlxTween.tween(camHUD, {zoom: 1}, 0.75, {ease: FlxEase.quadOut});
    }

    if (_ >= 131 && _ % 2 == 0) dxsad.visible = !(dx2.visible = false);
    else if (_ >= 131) dxsad.visible = !(dx2.visible = true);

    // events stuff
    switch (_) {
        case 131:
            camera.addShader(hotlineVHS);
            camChars.flash(FlxColor.RED, 1);
        case 162:
            camBG.flash(FlxColor.RED, 1);
            dxZoom = 0.6; // from camFollow-v2
            dxPos.y = 0; // from camFollow-v2
            targetDxBfScale = 1;
            bf.scrollFactor.y = 1.3;
    }
}

function onNoteCreation(e) {
	if (e.note.strumLine == playerStrums) return;
    e.cancel();

	var note = e.note;
	var strumID = e.strumID;

    var colors = [FlxColor.RED, FlxColor.BLUE, FlxColor.WHITE];
    note.color = FlxG.random.int(0, Math.POSITIVE_INFINITY);

	if (e.note.isSustainNote) {
		note.loadGraphic(Paths.image('notes/dxNote'), true, 7, 6);
		var maxCol = Math.floor(note.graphic.width / 7);
		note.animation.add("hold", [strumID % maxCol]);
		note.animation.add("holdend", [maxCol + strumID % maxCol]);
	} else {
        var size = FlxG.random.int(27, 38);
		note.loadGraphic(Paths.image('notes/dxNote'), true, size, size);
		var maxCol = Math.floor(note.graphic.width / 23);
		note.animation.add("scroll", [maxCol + strumID % maxCol]);
	}
	note.scale.set(3, 3);
	note.updateHitbox();
	note.antialiasing = false;
}

function onStrumCreation(e) if (e.player == 0) {
    e.cancel();

    var strum = e.strum;
    strum.updateHitbox();
    strum.loadGraphic(Paths.image('notes/dxNote'), true, 64, 64);
    strum.animation.add("static", [e.strumID]);
    strum.animation.add("pressed", [e.strumID + 8], 12, false);
    strum.animation.add("confirm", [e.strumID + 12, e.strumID + 16], 12, false);
    strum.scale.set(1.5, 1.5);
}

function onCountdown(e) e.cancel();

function onNoteHit(e) e.enableCamZooming = false;

function onPostStrumCreation(e) if (e.player == 0) e.strum.scrollFactor.set(1, 1);