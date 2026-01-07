var curTime:Int;

function create() {
    add(time = new FunkinText(0, 0, 0, "gamebreaker"));
    time.camera = camHUD;
    time.screenCenter();
}

function update() {
    curTime = CoolUtil.addZeros(Std.int(Conductor.songPosition / 1000), 3);
    time.text = curTime;
}