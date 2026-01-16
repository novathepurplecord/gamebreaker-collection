public var betterDXSustains:Bool = false;
public var betterPicoSustains:Bool = false;

function onNoteHit(e) if (e.noteType == "No Animation") e.animCancelled = true;

function onPlayerMiss(e) e.animCancelled = true;

function onPlayerHit(e) if (betterPicoSustains) {
    if (e.note.isSustainNote) {
        e.animCancelled = true;
        bf.lastHit = Conductor.songPosition;
    }
}

function onDadHit(e) if (betterDXSustains) {
    if (e.note.isSustainNote) {
        e.animCancelled = true;
        dad.lastHit = Conductor.songPosition;
    }
}