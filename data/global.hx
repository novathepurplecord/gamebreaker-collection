import funkin.backend.system.framerate.Framerate;
import openfl.system.Capabilities as Cap;
import openfl.text.TextFormat;

function new() {
    windowResize(1280, 960, 0.8);
    yoshi = new TextFormat('_sans', 12);
}

function destroy() windowResize(1280, 720, 1);

function postStateSwitch() {
    var tracedLines = FlxG.random.int(0, 500);
    var errors = FlxG.random.int(0, 500);

    
    Framerate.fpsCounter.fpsNum.defaultTextFormat = yoshi;
    Framerate.memoryCounter.memoryText.defaultTextFormat = yoshi;
    Framerate.memoryCounter.memoryPeakText.visible = Framerate.fpsCounter.fpsLabel.visible = false;
    Framerate.codenameBuildField.defaultTextFormat = yoshi;
    
    #if windows
    Framerate.fpsCounter.fpsNum.y = -3;
    Framerate.memoryCounter.memoryText.y = -11;
    Framerate.codenameBuildField.y = 29;
    #end
    
    #if linux
    Framerate.fpsCounter.fpsNum.y = 15;
    Framerate.memoryCounter.memoryText.y = -15;
    Framerate.codenameBuildField.y = 33;
    #end

    Framerate.codenameBuildField.text = tracedLines + " traced lines | " + errors + " errors (F5 to open)";
    
}

function update() {
    Framerate.fpsCounter.fpsNum.text = "FPS: " + Std.string(Math.round(Framerate.fpsCounter.lastFPS));
    Framerate.memoryCounter.memoryText.text = "Memory: " + CoolUtil.getSizeString(Framerate.memoryCounter.memory);
}

public static function windowResize(w, h, ?scale:Float = 1) {
    FlxG.resizeWindow(w * scale, h * scale);
    FlxG.resizeGame(w, h);

    for (c in FlxG.cameras.list) {
        c.width = FlxG.width = FlxG.initialWidth = Main.scaleMode.width = w;
        c.height = FlxG.height = FlxG.initialHeight = Main.scaleMode.height = h;
    }

    window.x = (Cap.screenResolutionX - (w * scale)) / 2;
    window.y = (Cap.screenResolutionY - (h * scale)) / 2;
}