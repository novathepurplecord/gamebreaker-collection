var curTime:Int;

function postCreate() {
    camera.zoom = defaultCamZoom;
    healthBar.visible = healthBarBG.visible = iconP1.visible = iconP2.visible = false;
    scoreTxt.visible = accuracyTxt.visible = missesTxt.visible = false;
}

function update() {
    bf.scale.set(camera.zoom * 2.2, camera.zoom * 2.2);
    bf.scrollFactor.set(5, 5);

    if (controls.NOTE_LEFT_P) tracee.visible = !tracee.visible;

    curTime = CoolUtil.addZeros(Std.int(Conductor.songPosition / 1000), 3);
    time.text = curTime;
}

function stepHit(_:Int) {
    switch (_) {
        case 16: camZooming = true;
    }
}

var tracee:FlxSprite;
var time:FunkinText;

function create() {
    add(tracee = new FlxSprite(0, 0, Paths.image('trace2'))).camera = camHUD;
    tracee.scale.set(0.72, 0.72);
    tracee.alpha = 0.5;
    tracee.screenCenter();

    add(time = new FunkinText(0, 0, 0, "gamebreaker"));
    time.camera = camHUD;
    time.screenCenter();
}

function onEvent(_) {
    var e = _.event;
    if (e.name != "Camera Movement") return;
    
    if (e.params[0] == 0) defaultCamZoom = 0.8;
    else defaultCamZoom = 0.6;
}

function onCountdown(e) e.cancel();
