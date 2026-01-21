function beatHit(_:Int) {
    switch (PlayState.SONG.meta.name) {
        case 'gamebreaker', 'gamebreaker-v2-legacy', 'gamebreaker-v2-oldest':
            switch (_) {
                case 72: for (obj in [bg, hill, trees]) FlxTween.color(obj, 2, 0xFFFFFFFF, 0xFFFFAAAA, {ease: FlxEase.quadInOut});
                case 204: for (obj in stage.stageSprites) obj.color = 0xFFFF3333;
            }
        case 'impersonator':
            switch (_) {
                case 108: for (obj in [bg, hill, trees]) FlxTween.color(obj, 2, 0xFFFFFFFF, 0xFFFFAAAA, {ease: FlxEase.quadInOut});
                case 240: for (obj in stage.stageSprites) obj.color = 0xFFFF3333;
            } 
        case 'gamebreaker-v2-traced':
            switch (_) {
                case 72: for (obj in [bg, hill, trees]) FlxTween.color(obj, 2, 0xFFFFFFFF, 0xFFA89FFC, {ease: FlxEase.quadInOut});
                case 204: for (obj in stage.stageSprites) obj.color = FlxColor.BLUE;
            } 
    }
}

function postCreate() bg.camera = trees.camera = hill.camera = camBG;