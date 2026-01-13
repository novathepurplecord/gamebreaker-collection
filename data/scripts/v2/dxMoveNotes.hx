function update() {
    for (strums in playerStrums.members) {
        strums.alpha = CoolUtil.fpsLerp(strums.alpha, 1, 0.1);
        strums.angle = CoolUtil.fpsLerp(strums.angle, 0, 0.1);
    }
}

function postCreate() for (strums in playerStrums.members) strums.noteAngle = 0;

function onDadHit(e) if (!e.note.isSustainNote) {
    var strum = playerStrums.members[e.direction];
    strum.angle = FlxG.random.bool() ? -10 : 10;
    strum.alpha -= 0.2;
}