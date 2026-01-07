
function beatHit(_:Int) {
    switch (_) {
        case 72:
            for (obj in [bg, hill, trees])
                FlxTween.color(obj, 2, 0xFFFFFFFF, 0xFFFFAAAA, {ease: FlxEase.quadInOut});
        case 204:
            for (obj in stage.stageSprites) obj.color = 0xFFFF3333;
    }
}

function postCreate() {
    bg.camera = trees.camera = hill.camera = camBG;
}

function postUpdate() {
    
}