import flixel.text.FlxTextBorderStyle;

graphicCache.cache(Paths.image("game/splashes/yoshi"));

var scoreWarningText:String = switch(PlayState.SONG.meta.name) {
        case 'gamebreaker', 'impersonator', 'gamebreaker-v2-legacy', 'gamebreaker-v2-oldest': "/!\\ Player used Charter, Score will not be saved";
        case 'gamebreaker-v2-gay': "/!\\ Player is GAY, Score will not be saved";
        case 'gamebreaker-v2-traced': "/!!!!\\ KILL YOURSELF KILL YOURSELF KILL YOURSELF";
    };

function postCreate() if (PlayState.chartingMode) {
    add(scoreWarning = new FunkinText(0, healthBarBG.y - 10, 1280, scoreWarningText));
    scoreWarning.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.RED, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    scoreWarning.antialiasing = true;
    scoreWarning.camera = camHUD;
    scoreWarning.y -= scoreWarning.height;   
}

var scoreWarningAlphaRot:Float = 0;

function update(elapsed:Float) if (PlayState.chartingMode) {
    scoreWarningAlphaRot = (scoreWarningAlphaRot + (elapsed * Math.PI * 0.75)) % (Math.PI * 2);
	scoreWarning.alpha = (2 / 3) + (Math.sin(scoreWarningAlphaRot) / 3);
}

function onPlayerHit(e) e.note.splash = "yoshi";