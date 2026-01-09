import funkin.backend.system.framerate.Framerate;
import funkin.backend.system.framerate.MemoryCounter;
import openfl.text.TextFormat;

var tracedLines:Int;
var errors:Int;

function new() {
    yoshi = new TextFormat('_sans', 12);
    Framerate.memoryCounter.memoryText.y = -15;
    Framerate.codenameBuildField.y = 33;

    tracedLines = FlxG.random.int(0, 1000);
    errors = FlxG.random.int(0, 1000);
}

function postStateSwitch() {
    Framerate.fpsCounter.fpsNum.defaultTextFormat = Framerate.fpsCounter.fpsLabel.defaultTextFormat = yoshi;
    Framerate.memoryCounter.memoryText.defaultTextFormat = yoshi;
    Framerate.memoryCounter.memoryPeakText.defaultTextFormat = yoshi;
    Framerate.codenameBuildField.defaultTextFormat = yoshi;
}

function postUpdate() {
    Framerate.memoryCounter.memoryText.text = "Memory: " + CoolUtil.getSizeString(MemoryUtil.currentMemUsage());
    Framerate.memoryCounter.memoryPeakText.text = "";
    Framerate.codenameBuildField.text = tracedLines + " traced lines | " + errors + " errors (F5 to open)";
}