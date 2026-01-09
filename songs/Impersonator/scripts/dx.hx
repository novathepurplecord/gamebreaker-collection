public var camBG = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
var camDX = new FlxCamera(140, -390, 1280, 1380, 1);
var camChars = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);

var dxShader = new CustomShader("dx");
var hotlineVHS = new CustomShader("hotlineVHS");
var glitch = new CustomShader("glitch");

public var dxFocused = true;

var bfX:Int = 529;
var bfY:Int = 269;

var dx2 = strumLines.members[0].characters[1];

var tracee:FlxSprite;

function create() {

    FlxG.resizeWindow(1024, 768);
    camera.bgColor = 0;

    FlxG.cameras.insert(camBG, 0, false);
    camBG.bgColor = 0;

    FlxG.cameras.insert(camDX, 1, false);
    camDX.bgColor = 0;
    camDX.angle = 90;
    camDX.addShader(dxShader);

    FlxG.cameras.insert(camChars, members.indexOf(camGame), false).bgColor = 0;

    dx2.visible = false;
    dad.camera = dx2.camera = bf.camera = camChars;

    FlxG.scaleMode.width = 1280;
    FlxG.scaleMode.height = 960;

    // add(tracee = new FlxSprite(0, 0, Paths.image('trace2'))).camera = camHUD;
    // tracee.setGraphicSize(1280, 960);
    // tracee.updateHitbox();
    // //tracee.scale.set(0.72, 0.72);
    // tracee.alpha = 0.5;
    // tracee.screenCenter();
}

function postCreate() {
    bf.setPosition(bfX, bfY);
    bf.scale.set(2, 2);

    camera.zoom = defaultCamZoom;
    strumLines.members[0].camera = camDX;

    //hidin everything
    healthBar.visible = healthBarBG.visible = iconP1.visible = iconP2.visible = false;
    scoreTxt.visible = accuracyTxt.visible = missesTxt.visible = false;

    for (obj in [gf, comboGroup]) remove(obj);
}

function update(elapsed:Float) {

    // if (controls.NOTE_LEFT_P) tracee.visible = !tracee.visible;

    //scrolls camera setup
    camBG.scroll.set(camera.scroll.x, camera.scroll.y);
    camBG.zoom = camera.zoom;

    camDX.scroll.set(camera.scroll.x, camera.scroll.y);
    camDX.zoom = camera.zoom;

    camChars.scroll.set(camera.scroll.x, camera.scroll.y);
    camChars.zoom = camera.zoom;
}

var targetBfScale:Int = 2;
var targetHillScale:Float = 0.525;
var targetTreeScale:Float = 0.64;

var hill = stage.getSprite("hill");
var trees = stage.getSprite("trees");

function postUpdate() {
    //shader itim
    hotlineVHS.iTime = Conductor.songPosition / 1000;
    glitch.iTime = Conductor.songPosition / 1000;

    //cam follo
    camera.zoom = CoolUtil.fpsLerp(camera.zoom, defaultCamZoom, 0.05);

    //scale things
    bfScale = CoolUtil.fpsLerp(bf.scale.x, targetBfScale, 0.05);
    bf.scale.set(bfScale, bfScale);
    bf.setPosition(bfX * bfScale, bfY * bfScale);

    hillScale = CoolUtil.fpsLerp(hill.scale.y, targetHillScale, 0.05);
    hill.scale.set(hillScale, hillScale);
    hill.y = 1 * hillScale;

    treeScale = CoolUtil.fpsLerp(trees.scale.x, targetTreeScale, 0.05);
    trees.scale.set(treeScale, treeScale);
    trees.y = 134 * treeScale; 
}

function stepHit(_:Int) {
    //cool bounce
    if (_ >= 584 && _ % 4 == 0) FlxTween.tween(camHUD, {y: 5}, 0.2, {ease: FlxEase.circOut});
    if (_ >= 584 && _ % 4 == 2) FlxTween.tween(camHUD, {y: 15}, 0.2, {ease: FlxEase.sineIn});

    switch (_) {
        case 448:
            dad.visible = !(dx2.visible = true);
            dx2.shader = glitch;
    }
}

var camRight:Bool = true;
var poopFartShittay:Float = 0.75;

var angleTwn:FlxTween;
var zoomTwn:FlxTween;

function beatHit(_:Int) {
    switch (_) {
        case 128:
            camBG.addShader(hotlineVHS);
            camBG.flash(FlxColor.RED, 1);
        case 176:
            camGame.flash(FlxColor.RED, 1);
    }

    // cool bounce 2
    if (_ >= 146 && _ % 2 == 0){
        angleTwn?.cancel();
        zoomTwn?.cancel();
        if (!camRight){
            poopFartShittay = -0.75;
            camRight = true;
        } else {
            poopFartShittay = 0.75;
            camRight = false;
        }
        camHUD.zoom += 0.04;
        camHUD.angle = poopFartShittay;
        angleTwn = FlxTween.tween(camHUD, {angle: 0}, 0.5, {ease: FlxEase.quadInOut});
        zoomTwn = FlxTween.tween(camHUD, {zoom: 1}, 0.75, {ease: FlxEase.quadOut});
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

function onNoteCreation(e) if (e.strumLineID == 0) e.noteSprite = "notes/sanicNote";

function onCountdown(e) e.cancel();

function onNoteHit(e) e.enableCamZooming = false;

function destroy() FlxG.resizeWindow(1280, 720);