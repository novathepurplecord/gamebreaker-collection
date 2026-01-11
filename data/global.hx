import funkin.backend.system.framerate.Framerate;
import funkin.backend.system.framerate.MemoryCounter;
import openfl.text.TextFormat;

var tracedLines:Int;
var errors:Int;

function new() {
    yoshi = new TextFormat('_sans', 12);
}

function postStateSwitch() {
    tracedLines = FlxG.random.int(0, 500);
    errors = FlxG.random.int(0, 500);

    Framerate.codenameBuildField.text = tracedLines + " traced lines | " + errors + " errors (F5 to open)";

    Framerate.fpsCounter.fpsNum.defaultTextFormat = Framerate.fpsCounter.fpsLabel.defaultTextFormat = yoshi;
    Framerate.memoryCounter.memoryText.defaultTextFormat = yoshi;
    Framerate.memoryCounter.memoryPeakText.visible = false;
    Framerate.codenameBuildField.defaultTextFormat = yoshi;

    Framerate.memoryCounter.memoryText.y = -15;
    Framerate.codenameBuildField.y = 33;
}