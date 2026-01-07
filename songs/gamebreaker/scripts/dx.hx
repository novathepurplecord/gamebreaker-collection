var tracee:FlxSprite;
var time:FunkinText;

public var camBG = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
var camDX = new FlxCamera(140, -390, 1280, 1380, 1);

var dxShader = new CustomShader("dx");
var hotlineVHS = new CustomShader("hotlineVHS");

public var dxFocused = true;

var bfX:Int = 529;
var bfY:Int = 269;

function create() {
    FlxG.resizeWindow(1024, 768);

    camera.bgColor = 0x0;

    FlxG.cameras.insert(camBG, 0, false);
    camBG.bgColor = 0x0;

    FlxG.cameras.insert(camDX, 1, false);
    camDX.bgColor = 0x0;
    camDX.angle = 90;
    camDX.addShader(dxShader);

    FlxG.scaleMode.width = 1280;
    FlxG.scaleMode.height = 960;
}

function postCreate() {
    boyfriend.setPosition(bfX, bfY);

    camera.zoom = defaultCamZoom;
    strumLines.members[0].camera = camDX;

    //hidin everything
    healthBar.visible = healthBarBG.visible = iconP1.visible = iconP2.visible = false;
    scoreTxt.visible = accuracyTxt.visible = missesTxt.visible = false;

    for (obj in [gf, comboGroup]) remove(obj);
}

function update(elapsed:Float) {
    camBG.scroll.set(camera.scroll.x, camera.scroll.y);
    camBG.zoom = camera.zoom;

    camDX.scroll.set(camera.scroll.x, camera.scroll.y);
    camDX.zoom = camera.zoom;
}

var targetBfScale:Float = 2;

function postUpdate() {
    dxShader.iTime = Conductor.songPosition / 1000;

    //cam follo
    camera.zoom = CoolUtil.fpsLerp(camera.zoom, defaultCamZoom, 0.05);

    bfScale = CoolUtil.fpsLerp(bf.scale.x, targetBfScale, 0.05);
    bf.scale.set(bfScale, bfScale);

    bf.x = bfX * bfScale;
    bf.y = bfY * bfScale;
}

function beatHit(_:Int) {
    switch (_) {
        
    }
}

function onEvent(_) {
    var e = _.event;
    if (e.name != "Camera Movement") return;
    
    if (e.params[0] == 0) { //dx turn
        dxFocused = true;
        //targets
        targetBfScale = 2;
        targetHillScale = 0.525;
        targetTreeScale = 0.64;
    } else { //picos turn
        dxFocused = false;
        //targets
        targetBfScale = 1;
        targetHillScale = 0.56;
        targetTreeScale = 0.66;
    }
}

function onNoteCreation(e) if (e.strumLineID == 0) e.noteSprite = "game/notes/evil";

function onCountdown(e) e.cancel();

function onNoteHit(e) e.enableCamZooming = false;

function destroy() FlxG.resizeWindow(1280, 720);
