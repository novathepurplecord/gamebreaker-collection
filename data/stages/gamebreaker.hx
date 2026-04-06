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

var targetHillScale:Float = 0.525;
var targetTreeScale:Float = 0.64;

function postUpdate() {
    hillScale = CoolUtil.fpsLerp(hill.scale.y, targetHillScale, 0.05);
    hill.scale.set(hillScale, hillScale);
    hill.y = hillScale;

    treeScale = CoolUtil.fpsLerp(trees.scale.x, targetTreeScale, 0.05);
    trees.scale.set(treeScale, treeScale);
    trees.y = 134 * treeScale; 
}

function onEvent(e) {
    var e = e.event;
    if (e.name != "Camera Movement") return;

    targetHillScale = dxFocused ? 0.525 : 0.56;
    targetTreeScale = dxFocused ? 0.64 : 0.66;
}

function postCreate() bg.camera = trees.camera = hill.camera = camBG;