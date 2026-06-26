// this shit doesnt wor k ingore it pelase

function onPostNoteCreation(e) {
    var note = e.note;

    if (note.isSustainNote) {
        note.offset.x -= 5;
        note.offset.y -= 90;
    }

}

function onDadHit(e) e.preventStrumGlow();

function onPlayerHit(e) {
    e.showSplash = false;
    e.preventLastSustainHit();
}

function update(elapsed:Float) {
    for (icon in [iconP1, iconP2]) {
        icon.setGraphicSize(CoolUtil.fpsLerp(150, icon.width, 0.95));
    }
}