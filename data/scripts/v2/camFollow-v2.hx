var offsetPico:Int = 10;
var offsetDX:Int = 30;

public var dxZoom:Float = 1.3;
public var dxPos = {x: 420, y: 444};

public var picoZoom:Float = 0.7;
public var picoPos = {x: 510, y: 480};

function postUpdate() {
    var dxFocused = curCameraTarget == 0;
    var offset = dxFocused ? offsetDX : offsetPico;
    var character = dxFocused ? dx2 : boyfriend;

    var pos = dxFocused ? dxPos : picoPos;
    camFollow.setPosition(pos.x, pos.y);
    defaultCamZoom = dxFocused ? dxZoom : picoZoom;

    switch (character.animation.curAnim.name) {
        case "singLEFT": camFollow.x -= offset;
        case "singRIGHT": camFollow.x += offset;
        case "singUP": camFollow.y -= offset;
        case "singDOWN": camFollow.y += offset;
    }
}