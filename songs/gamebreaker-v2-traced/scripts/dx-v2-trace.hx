importScript("data/scripts/v2/yoshi-trace");
importScript("data/scripts/v2/hud-v2-trace");
importScript("data/scripts/v2/camFollow-v2");

public var camBG = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
var camDX = new FlxCamera(-140, -190, 1880, 880, 1);
var camChars = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);

var dxShader = new CustomShader("dx");
var hotlineVHS = new CustomShader("hotlineVHS");

public var dxFocused = true;

var bfX:Int = 529;
var bfY:Int = 269;

var dx2 = strumLines.members[0].characters[1];
var dx3 = strumLines.members[0].characters[2];

function create() {
    FlxG.resizeWindow(1024, 768);
    camera.bgColor = 0;

    FlxG.cameras.insert(camBG, 0, false).bgColor = 0;
    FlxG.cameras.insert(camDX, 1, false).bgColor = 0;
    camDX.addShader(dxShader);

    FlxG.cameras.insert(camChars, members.indexOf(camGame), false).bgColor = 0;

    dx2.visible = dx3.visible = false;
    dad.camera = dx2.camera = dx3.camera = bf.camera = camChars;

    FlxG.scaleMode.width = 1280;
    FlxG.scaleMode.height = 960;
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

    for (i => strums in cpuStrums.members) cpuStrums.members[i].x += 50;
}

function update(elapsed:Float) {
    //scrolls camera setup
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
    //shader itim
    hotlineVHS.iTime = Conductor.songPosition / 1000;

    //cam follo
    camera.zoom = CoolUtil.fpsLerp(camera.zoom, defaultCamZoom, 0.06);

    //scale things
    bfScale = CoolUtil.fpsLerp(bf.scale.x, targetBfScale, 0.02);
    bf.scale.set(bfScale, bfScale);
    bf.setPosition(bfX * bfScale, bfY * bfScale);

    hillScale = CoolUtil.fpsLerp(hill.scale.y, targetHillScale, 0.04);
    hill.scale.set(hillScale, hillScale);
    hill.y = 1 * hillScale;

    treeScale = CoolUtil.fpsLerp(trees.scale.x, targetTreeScale, 0.05);
    trees.scale.set(treeScale, treeScale);
    trees.y = 134 * treeScale; 
}

function stepHit(_:Int) {
    //cool bounce
    if (_ >= 558 && _ % 4 == 0) FlxTween.tween(camHUD, {y: 5}, 0.2, {ease: FlxEase.circOut});
    if (_ >= 558 && _ % 4 == 2) FlxTween.tween(camHUD, {y: 15}, 0.2, {ease: FlxEase.sineIn});

    switch (_) {
        case 302: dad.visible = !(dx2.visible = true);
        case 816: dx2.visible = !(dx3.visible = true);
    }
}

var camRight:Bool = true;

function beatHit(_:Int) {
    switch (_) {
        case 156:
            camDX.addShader(hotlineVHS);
            camBG.flash(FlxColor.BLUE, 1);
        case 204:
            camGame.flash(FlxColor.BLUE, 1);
            dxZoom = 0.5;
            dxPos = [320, 0];
            targetDxBfScale = 0.2;
            bf.scrollFactor.y = 2.4;
            for (i => strums in cpuStrums.members) cpuStrums.members[i].scrollFactor.set(3, 3);
    }

    // cool bounce 2
    if (_ >= 140 && _ % 2 == 0) {
        camRight = !camRight;
        camHUD.zoom += 0.09;
        camHUD.angle = (camRight) ? 0.85 : -10.65;
        FlxTween.tween(camHUD, {angle: 0}, 0.5, {ease: FlxEase.quadInOut});
        FlxTween.tween(camHUD, {zoom: 1}, 0.45, {ease: FlxEase.quadOut});
    }
}

function onEvent(_) {
    var e = _.event;
    if (e.name != "Camera Movement") return;

    if (e.params[0] == 0) { //dx turn
        dxFocused = true;
        //targets
        targetBfScale = targetDxBfScale;
        targetHillScale = 1.525;
        targetTreeScale = 0.64;
    } else { //picos turn
        dxFocused = false;
        //targets
        targetBfScale = 1;
        targetHillScale = 0.46;
        targetTreeScale = 0.96;
    }
}

function onNoteCreation(e) {
    if (e.strumLineID == 0) {
        e.cancel();

        var note = e.note;

        //randomness
        var colors = [FlxColor.GREEN, FlxColor.PURPLE, FlxColor.WHITE];
        note.color = colors[FlxG.random.int(0, colors.length - 1)];

        var graphic = Paths.image('notes/dxNote');

        if (note.isSustainNote) {
            note.loadGraphic(graphic, true, 100, 100);
            note.animation.add("hold", [e.strumID]);
            note.animation.add("holdend", [e.strumID]);
            note.alpha = 0.1;
        } else {
            var size = FlxG.random.int(56, 130);
            note.loadGraphic(graphic, true, size, size);
            note.animation.add("scroll", [e.strumID]);
            note.scale.set(1.5, 1.5);
        }
    } else if (e.strumLineID == 1) {
        e.noteSprite = 'notes/xtdwg';
    }
}

function onStrumCreation(event) {
    if (event.player == 0) {
        event.cancel();

        var strum = event.strum;
        
        strum.loadGraphic(Paths.image('notes/dxNote'), true, 64, 64);
        strum.animation.add("static", [event.strumID]);
        strum.animation.add("pressed", [4 + event.strumID, 8 + event.strumID], 12, false);
        strum.animation.add("confirm", [12 + event.strumID, 16 + event.strumID], 24, false);
        strum.scale.set(1.5, 1.5);
    } else if (event.player == 1) {
        event.sprite = 'notes/xtdwg';
    }
}

function onCountdown(e) e.cancel();

function onNoteHit(e) for (char in e.characters) {
    e.enableCamZooming = false;
    if (e.note.isSustainNote) {
        e.animCancelled = true;
        char.lastHit = Conductor.songPosition;
    }
}

function destroy() FlxG.resizeWindow(1280, 720);