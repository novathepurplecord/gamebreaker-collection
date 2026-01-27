importScript("data/scripts/yoshi");
importScript("data/scripts/v2/hud-v2");
importScript("data/scripts/v2/camFollow-v2");
importScript("data/scripts/betterSustains");

public var camBG = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
var camDX = new FlxCamera(140, -390, 1280, 1380, 1);
var camChars = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);

var dxShader = new CustomShader("dx");
var hotlineVHS = new CustomShader("hotlineVHS");

var bfX:Int = 529;
var bfY:Int = 269;

var dx = strumLines.members[0].characters[0];
var dx2 = strumLines.members[0].characters[1];
var dx3 = strumLines.members[0].characters[2];

function create() {
    // window resizing
    FlxG.resizeWindow(1024, 768);
    camera.bgColor = 0;

    // cameras setup
    FlxG.cameras.insert(camBG, 0, false).bgColor = 0;
    FlxG.cameras.insert(camDX, 1, false).bgColor = 0;
    camDX.angle = 90;
    camDX.addShader(dxShader);

    FlxG.cameras.insert(camChars, members.indexOf(camGame), false).bgColor = 0;

    // character cameras visibility etc
    dx2.visible = dx3.visible = false;
    dx.camera = dx2.camera = dx3.camera = bf.camera = camChars;

    // scale mode
    FlxG.scaleMode.width = 1280;
    FlxG.scaleMode.height = 960;
}

// post create bf pos, zoom, dx notes pos, etc
function postCreate() {
    bf.setPosition(bfX, bfY);
    bf.scale.set(2, 2);
    bf.scrollFactor.y = 1.3;

    camera.zoom = defaultCamZoom;
    strumLines.members[0].camera = camDX;

    for (obj in [gf, comboGroup]) remove(obj);
    for (strums in cpuStrums.members) strums.x += 380;
}

// camera stuff update
function update(elapsed:Float) {
    camBG.scroll.set(camera.scroll.x, camera.scroll.y);
    camBG.zoom = camera.zoom;

    camDX.scroll.set(camera.scroll.x, camera.scroll.y);
    camDX.zoom = camera.zoom;

    camChars.scroll.set(camera.scroll.x, camera.scroll.y);
    camChars.zoom = camera.zoom;
}

var targetBfScale:Int = 2;
var targetDxBfScale:Int = 2;
var targetHillScale:Float = 0.525;
var targetTreeScale:Float = 0.64;

var hill = stage.getSprite("hill");
var trees = stage.getSprite("trees");

function postUpdate() {
    // shader itim
    hotlineVHS.iTime = Conductor.songPosition * 0.001;

    // cam follo
    camera.zoom = CoolUtil.fpsLerp(camera.zoom, defaultCamZoom, 0.05);

    // scale things
    bfScale = CoolUtil.fpsLerp(bf.scale.x, targetBfScale, 0.05);
    bf.scale.set(bfScale, bfScale);
    bf.setPosition(bfX * bfScale, bfY * bfScale);

    hillScale = CoolUtil.fpsLerp(hill.scale.y, targetHillScale, 0.05);
    hill.scale.set(hillScale, hillScale);
    hill.y = hillScale;

    treeScale = CoolUtil.fpsLerp(trees.scale.x, targetTreeScale, 0.05);
    trees.scale.set(treeScale, treeScale);
    trees.y = 134 * treeScale; 
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

function beatHit(_:Int) {
    // events stuff
    switch (_) {
        case 156:
            camBG.addShader(hotlineVHS);
            camBG.flash(FlxColor.RED, 1);
        case 204:
            camGame.flash(FlxColor.RED, 1);
            dxZoom = 0.6;
            dxPos = [420, 0];
            targetDxBfScale = 1;
            for (strums in cpuStrums.members) strums.scrollFactor.set(1, 1);
    }

    // cool bounce 2
    if (_ >= 140 && _ % 2 == 0) {
        camRight = !camRight;
        camHUD.zoom += 0.04;
        camHUD.angle = (camRight) ? 0.75 : -0.75;
        FlxTween.tween(camHUD, {angle: 0}, 0.5, {ease: FlxEase.quadInOut});
        FlxTween.tween(camHUD, {zoom: 1}, 0.75, {ease: FlxEase.quadOut});
    }
}

public var dxFocused = true;

// event camera movement
function onEvent(event) {
    var e = event.event;
    if (e.name != "Camera Movement") return;

    var isDX = e.params[0] == 0;
    dxFocused = isDX;
    targetBfScale = isDX ? targetDxBfScale : 1;
    targetHillScale = isDX ? 0.525 : 0.56;
    targetTreeScale = isDX ? 0.64 : 0.66;
}

// character note graphics
function onNoteCreation(e) if (e.strumLineID == 0) {
    e.cancel();

    var note = e.note;
    var graphic = Paths.image('characters/dx');

    if (note.isSustainNote) {
        note.loadGraphic(graphic, true, 24, 24);
        note.animation.add("hold", [4 + e.strumID]);
        note.animation.add("holdend", [e.strumID]);
    } else {
        note.loadGraphic(graphic, true, 210, 210);
        note.animation.add("scroll", [20.2 + e.strumID]);
        note.scale.set(0.5, 0.5);
    }
}

// character strum graphics
function onStrumCreation(e) if (e.player == 0) {
    e.cancel();

    var strum = e.strum;
    strum.loadGraphic(Paths.image('characters/dx'), true, 210, 210);
    strum.animation.add("static", [e.strumID]);
    strum.animation.add("pressed", [4 + e.strumID, 8 + e.strumID], 12, false);
    strum.animation.add("confirm", [12 + e.strumID, 16 + e.strumID], 24, false);
    strum.scale.set(0.5, 0.5);
}

function onCountdown(e) e.cancel();

function onNoteHit(e) e.enableCamZooming = false;

function destroy() FlxG.resizeWindow(1280, 720);