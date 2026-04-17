function create() {
    trace("hi");
}

function update(elapsed:Float) {
    if (FlxG.keys.justPressed.FOUR) FlxG.switchState(new ModState("gamebreakerState"));
}