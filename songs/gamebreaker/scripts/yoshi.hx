import flixel.text.FlxTextBorderStyle;

function postCreate() {
    add(scoreWarning = new FunkinText(0, healthBarBG.y - 10, 1280, '/!\\ Player used Charter, Score will not be saved'));
    scoreWarning.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.RED, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    scoreWarning.antialiasing = true;
    scoreWarning.camera = camHUD;
    scoreWarning.y -= scoreWarning.height;   
}

var scoreWarningAlphaRot:Float = 0;

function update(elapsed:Float) {
    scoreWarningAlphaRot = (scoreWarningAlphaRot + (elapsed * Math.PI * 0.75)) % (Math.PI * 2);
	scoreWarning.alpha = (2 / 3) + (Math.sin(scoreWarningAlphaRot) / 3);
}