var offsetPico:Int = 10;
var offsetDX:Int = 30;

public var dxZoom:Int = 1.3;
public var dxPos:Array<Int> = [420, 444];

function postUpdate() {
    if (dxFocused) { //dx
        camFollow.setPosition(dxPos[0], dxPos[1]);
        defaultCamZoom = dxZoom;
        switch(dad.animation.curAnim.name) {
            case "singLEFT": camFollow.x -= offsetDX;
            case "singRIGHT": camFollow.x += offsetDX;
            case "singUP": camFollow.y -= offsetDX;
            case "singDOWN": camFollow.y += offsetDX;
        }
    } else { //pico
        camFollow.setPosition(520, 480);
        defaultCamZoom = 0.7;
        switch(boyfriend.animation.curAnim.name) {
            case "singLEFT": camFollow.x -= offsetPico;
            case "singRIGHT": camFollow.x += offsetPico;
            case "singUP": camFollow.y -= offsetPico;
            case "singDOWN": camFollow.y += offsetPico;
        }
    }
}