importScript("data/scripts/yoshi");
importScript("data/scripts/v1/hud");
importScript("data/scripts/v1/camFollow");
importScript("data/scripts/betterSustains");

var camDX = new FlxCamera(140, -390, 1280, 1380, 1);
var camChars = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);

var dxShader = new CustomShader("dx");
var hotlineVHS = new CustomShader("hotlineVHS");
var glitch = new CustomShader("glitch");

var dx2 = strumLines.members[0].characters[1];

function create() {
    FlxG.cameras.insert(camChars, members.indexOf(camGame), false);
    FlxG.cameras.insert(camDX, 1, false).angle = 90;
    camDX.addShader(dxShader);

    dad.camera = dx2.camera = bf.camera = camChars;
    dx2.visible = false;
}

var bfX:Int = 529;
var bfY:Int = 269;

function postCreate() {
    camera.zoom = defaultCamZoom; //phuck you cne

    bf.scale.set(2, 2);
    cpuStrums.camera = camDX;

    for (i in [gf, comboGroup]) remove(i);
    for (strums in cpuStrums.members) strums.x += 134;
}

function update() {
    //scrolls camera setup
    camDX.scroll.set(camera.scroll.x, camera.scroll.y);
    camDX.zoom = camera.zoom;

    camChars.scroll.set(camera.scroll.x, camera.scroll.y);
    camChars.zoom = camera.zoom;
}

function postUpdate() {
    //shader itim
    hotlineVHS.iTime = Conductor.songPosition * 0.001;
    glitch.iTime = Conductor.songPosition * 0.001;

    //cam follo
    camera.zoom = CoolUtil.fpsLerp(camera.zoom, defaultCamZoom, 0.05);

    //scale things
    bfScale = CoolUtil.fpsLerp(bf.scale.x, curCameraTarget == 0 ? 2 : 1, 0.05);
    bf.scale.set(bfScale, bfScale);
    bf.setPosition(bfX * bfScale, bfY * bfScale);
}

function stepHit(_:Int) {
    //cool bounce
    if (_ >= 581 && _ % 4 == 0) FlxTween.tween(camHUD, {y: 5}, 0.2, {ease: FlxEase.circOut});
    if (_ >= 581 && _ % 4 == 2) FlxTween.tween(camHUD, {y: 15}, 0.2, {ease: FlxEase.sineIn});

    switch (_) {
        case 448:
            dad.visible = !(dx2.visible = true);
            dx2.shader = glitch;
    }
}

var angleTwn:FlxTween;
var zoomTwn:FlxTween;

function beatHit(_:Int) {
    // cool bounce 2
    if (_ >= 146 && _ % 2 == 0) {
        for (twn in [angleTwn, zoomTwn]) twn?.cancel();
        camHUD.zoom += 0.04;
        camHUD.angle = (_ % 4 == 2) ? -0.75 : 0.75;
        angleTwn = FlxTween.tween(camHUD, {angle: 0}, 0.5, {ease: FlxEase.quadInOut});
        zoomTwn = FlxTween.tween(camHUD, {zoom: 1}, 0.75, {ease: FlxEase.quadOut});
    }

    switch (_) {
        case 176:
            camera.addShader(hotlineVHS);
            camera.flash(FlxColor.RED, 1);
        case 240:
            camBG.flash(FlxColor.RED, 1);
    }
}

function onNoteCreation(e) if (e.strumLineID == 0) e.noteSprite = "notes/sanicNote";

function onPostStrumCreation(e) if (e.player == 0) e.strum.scrollFactor.set(1, 1);

function onCountdown(e) e.cancel();

function onNoteHit(e) e.enableCamZooming = false;