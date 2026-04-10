public var camBG = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);

function create() FlxG.cameras.insert(camBG, 0, false);

function postCreate() bg.camera = trees.camera = hill.camera = camBG;

function postUpdate() {
    hillScale = CoolUtil.fpsLerp(hill.scale.y, curCameraTarget == 0 ? 0.525 : 0.56, 0.05);
    hill.scale.set(hillScale, hillScale);
    hill.y = hillScale;

    treeScale = CoolUtil.fpsLerp(trees.scale.x, curCameraTarget == 0 ? 0.64 : 0.66, 0.05);
    trees.scale.set(treeScale, treeScale);
    trees.y = treeScale * 143;

    camBG.scroll.set(camera.scroll.x, camera.scroll.y);
    camBG.zoom = camera.zoom;
}

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