var offsetPico:Int = 10;
var offsetDX:Int = 30;

function postUpdate() {
    if (dxFocused) {
        camFollow.setPosition(420, 444);
        defaultCamZoom = 1.3;
        switch(dad.animation.curAnim.name) {
            case "singLEFT": camFollow.x -= offsetDX;
            case "singRIGHT": camFollow.x += offsetDX;
            case "singUP": camFollow.y -= offsetDX;
            case "singDOWN": camFollow.y += offsetDX;
        }
    } else {
        camFollow.setPosition(520, 480);
        defaultCamZoom = 0.97;
        switch(boyfriend.animation.curAnim.name) {
            case "singLEFT": camFollow.x -= offsetPico;
            case "singRIGHT": camFollow.x += offsetPico;
            case "singUP": camFollow.y -= offsetPico;
            case "singDOWN": camFollow.y += offsetPico;
        }
    }
}