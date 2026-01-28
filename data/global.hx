import funkin.backend.system.framerate.Framerate;
import openfl.text.TextFormat;

function new() {
    yoshi = new TextFormat('_sans', 12);
}

function postStateSwitch() {
    var tracedLines = FlxG.random.int(0, 500);
    var errors = FlxG.random.int(0, 500);

    Framerate.codenameBuildField.text = tracedLines + " traced lines | " + errors + " errors (F5 to open)";

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
}

function update() {
    Framerate.fpsCounter.fpsNum.text = "FPS: " + Std.string(Math.round(Framerate.fpsCounter.lastFPS));
    Framerate.memoryCounter.memoryText.text = "Memory: " + CoolUtil.getSizeString(Framerate.memoryCounter.memory);
}