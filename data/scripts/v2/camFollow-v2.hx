var offsetPico:Int = 10;
var offsetDX:Int = 30;

public var dxZoom:Float = 1.3;
public var dxPos:Array<Int> = [420, 444];
public var picoZoom:Float = 0.7;
public var picoPos:Array<Int> = [520, 480];

function postUpdate() {
    var offset = dxFocused ? offsetDX : offsetPico;
    var character = dxFocused ? dad : boyfriend;
    
    var pos = dxFocused ? dxPos : picoPos;
    camFollow.setPosition(pos[0], pos[1]);
    defaultCamZoom = dxFocused ? dxZoom : picoZoom;
    
    switch(character.animation.curAnim.name) {
        case "singLEFT": camFollow.x -= offset;
        case "singRIGHT": camFollow.x += offset;
        case "singUP": camFollow.y -= offset;
        case "singDOWN": camFollow.y += offset;
    }
}