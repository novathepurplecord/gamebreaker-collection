public var betterDXSustains:Bool = false;
public var betterPicoSustains:Bool = false;

function onNoteHit(e) if (e.noteType == "No Animation") e.animCancelled = true;

function onPlayerMiss(e) if (PlayState.SONG.meta.name != 'gamebreaker' && PlayState.SONG.meta.name != 'impersonator') e.animCancelled = true;

function onPlayerHit(e) if (betterPicoSustains) {
    if (e.note.isSustainNote) {
        e.preventAnim();
        e.character.lastHit = Conductor.songPosition;
    }
}

function onDadHit(e) if (betterDXSustains && e.animSuffix != '-alt') {
    if (e.note.isSustainNote) {
        e.preventAnim();
        e.character.lastHit = Conductor.songPosition;
    }
}

// function update() {
//     for (i in strumLines.members) {
//         for (char in i.characters) {
//             if (char.isAnimFinished()) {
//                 var name = char.getAnimName() + '-loop';
//                 if (char.hasAnim(name)) char.playAnim(name, null, lastAnimContext);
//             }
//         }
//     }
// }