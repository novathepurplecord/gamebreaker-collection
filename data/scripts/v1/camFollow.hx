var offsetPico:Int = 10;
var offsetDX:Int = 30;

public var dxFocused = true;

function onEvent(e) {
    var e = e.event;
    if (e.name != "Camera Movement") return;
    dxFocused = e.params[0] == 0;
}

function postUpdate() {
    var offset = dxFocused ? offsetDX : offsetPico;
    var character = dxFocused ? dad : boyfriend;
    
    camFollow.setPosition(dxFocused ? 420 : 520, dxFocused ? 444 : 480);
    defaultCamZoom = dxFocused ? 1.3 : 0.97;
    
    switch (character.animation.curAnim.name) {
        case "singLEFT": camFollow.x -= offset;
        case "singRIGHT": camFollow.x += offset;
        case "singUP": camFollow.y -= offset;
        case "singDOWN": camFollow.y += offset;
    }
}