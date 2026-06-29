importScript("data/scripts/yoshi");
importScript("data/scripts/v2/hud-v2");
importScript("data/scripts/v2/camFollow-v2");
importScript("data/scripts/betterSustains");

var camDX = new FlxCamera(20, -360, 1460, 1380, 1);
var camChars = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);

var dxShader = new CustomShader("dx");
var hotlineVHS = new CustomShader("hotlineVHS");

public var dx = strumLines.members[0].characters[0];
public var dx2 = strumLines.members[0].characters[1];
public var dx3 = strumLines.members[0].characters[2];

function create() {
    // cameras setup
    FlxG.cameras.insert(camChars, 2, false).bgColor = 0;
    FlxG.cameras.insert(camDX, 1, false).angle = 90;
    camDX.bgColor = 0;
    camDX.addShader(dxShader);

    // character cameras visibility etc
    dx.camera = dx2.camera = dx3.camera = bf.camera = camChars;
    dx2.visible = dx3.visible = false;
}

var bfX:Int = 529;
var bfY:Int = 269;

// post create bf pos, zoom, dx notes pos, etc
function postCreate() {
    camera.zoom = defaultCamZoom; //phuck you cne

    bf.scale.set(2, 2);
    cpuStrums.camera = camDX;

    for (i in [gf, comboGroup]) remove(i);
    for (strums in cpuStrums.members) strums.x += 220;
}

// camera stuff update
function update(elapsed:Float) {
    camDX.scroll.set(camera.scroll.x, camera.scroll.y);
    camDX.zoom = camera.zoom;

    camChars.scroll.set(camera.scroll.x, camera.scroll.y);
    camChars.zoom = camera.zoom;
}

var targetDxBfScale:Int = 2;

function postUpdate() {
    // shader itim
    hotlineVHS.iTime = Conductor.songPosition * 0.001;

    // cam follo
    camera.zoom = CoolUtil.fpsLerp(camera.zoom, defaultCamZoom, 0.05);

    // scale things
    bfScale = CoolUtil.fpsLerp(bf.scale.x, curCameraTarget == 0 ? targetDxBfScale : 1, 0.05);
    bf.scale.set(bfScale, bfScale);
    bf.setPosition(bfX * bfScale, bfY * bfScale);
}

function stepHit(_:Int) {
    // cool bounce
    if (_ >= 558 && _ % 4 == 0) FlxTween.tween(camHUD, {y: 5}, 0.2, {ease: FlxEase.circOut});
    if (_ >= 558 && _ % 4 == 2) FlxTween.tween(camHUD, {y: 15}, 0.2, {ease: FlxEase.sineIn});

    switch (_) {
        case 302: dx.visible = !(dx2.visible = true);
        case 816: dx2.visible = !(dx3.visible = true);
    }
}

var camRight:Bool = true;
var angleTwn:FlxTween;
var zoomTwn:FlxTween;

function beatHit(_:Int) {
    // cool bounce 2
    if (_ >= 140 && _ % 2 == 0) {
        for (twn in [angleTwn, zoomTwn]) twn?.cancel();
        camHUD.zoom += 0.04;
        camHUD.angle = (_ % 4 == 2) ? -0.75 : 0.75;
        angleTwn = FlxTween.tween(camHUD, {angle: 0}, 0.5, {ease: FlxEase.quadInOut});
        zoomTwn = FlxTween.tween(camHUD, {zoom: 1}, 0.75, {ease: FlxEase.quadOut});
    }

    // events stuff
    switch (_) {
        case 156:
            camera.addShader(hotlineVHS);
            camera.flash(FlxColor.RED, 1);
        case 204:
            camBG.flash(FlxColor.RED, 1);
            dxZoom = 0.6; // from camFollow-v2
            dxPos.y = 0; // from camFollow-v2
            targetDxBfScale = 1;
            bf.scrollFactor.y = 1.3;
    }
}

function onNoteCreation(e) if (e.strumLineID == 0) {
    e.cancel();

    var note = e.note;
    var graphic = Paths.image('notes/dx');

    if (note.isSustainNote) {
        note.loadGraphic(graphic, true, 24, 24);
        note.animation.add("hold", [4 + e.strumID]);
        note.animation.add("holdend", [e.strumID]);
    } else {
        note.loadGraphic(graphic, true, 210, 210);
        note.animation.add("scroll", [20.2 + e.strumID]);
        note.scale.set(0.5, 0.5);
    }

    note.updateHitbox();
}

// character strum graphics
function onStrumCreation(e) if (e.player == 0) {
    e.cancel();

    var strum = e.strum;
    strum.loadGraphic(Paths.image('notes/dx'), true, 210, 210);
    strum.animation.add("static", [e.strumID]);
    strum.animation.add("pressed", [4 + e.strumID, 8 + e.strumID], 12, false);
    strum.animation.add("confirm", [12 + e.strumID, 16 + e.strumID], 24, false);
    strum.scale.set(0.5, 0.5);
}

function onCountdown(e) e.cancel();

function onNoteHit(e) e.enableCamZooming = false;

function onPostStrumCreation(e) if (e.player == 0) e.strum.scrollFactor.set(1, 1);