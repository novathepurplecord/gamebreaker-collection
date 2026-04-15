function update() {
    for (strums in playerStrums.members) {
        strums.color = CoolUtil.lerpColor(strums.color, 0xFFFFFF, 0.01, true);
        strums.angle = CoolUtil.fpsLerp(strums.angle, 0, 0.01);
    }
}

// function postCreate() for (strums in playerStrums.members) strums.noteAngle = 0;

function onDadHit(e) if (!e.note.isSustainNote) {
    var strum = playerStrums.members[e.direction];
    strum.angle = FlxG.random.bool() ? -360 : 360;
    strum.color = FlxG.random.int(0, Math.POSITIVE_INFINITY);
}