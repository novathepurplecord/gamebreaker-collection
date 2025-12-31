function new() windowResize(1024, 768, 1);

function destroy() windowResize(1280, 720, 1);

function windowResize(w, h, ?scale:Float = 1) {
    FlxG.resizeWindow(w * scale, h * scale);
    FlxG.resizeGame(w, h);

    for (c in FlxG.cameras.list) {
        c.width = FlxG.width = FlxG.initialWidth = Main.scaleMode.width = w;
        c.height = FlxG.height = FlxG.initialHeight = Main.scaleMode.height = h;
    }

    window.x = (Cap.screenResolutionX - (w * scale)) / 2;
    window.y = (Cap.screenResolutionY - (h * scale)) / 2;

    Shader.doResizeFix = true;
    Shader.fixSpritesShadersSizes();
}