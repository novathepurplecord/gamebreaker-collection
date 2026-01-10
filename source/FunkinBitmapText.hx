import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText.FlxTextAlign;

class FunkinBitmapText extends FlxBitmapText {
	public var size(default, set):Float;

	public static inline function fromMono(Graphic:String, Used:String, ?PointX:Float, ?PointY:Float) {
		var pX:Int = (PointX == null) ? (Assets.getBitmapData(Graphic + '.png').width / Used.length) : PointX;
		var pY:Int = (PointY == null) ? Assets.getBitmapData(Graphic + '.png').height : PointY;
        FlxBitmapFont.fromMonospace(Assets.getBitmapData(Graphic + '.png', true, false), Used, FlxPoint.weak(pX, pY));
	}

	public static inline function fromAngel(Graphic:String, ?Font:String){
		if(Font == null && Assets.exists(Graphic + '.png')) Font = Graphic;
		FlxBitmapFont.fromAngelCode(Assets.getBitmapData(Graphic + '.png'), Font + '.fnt');
	}

	public static inline function fromXNA(Graphic:String, Used:String) FlxBitmapFont.fromXNA(Assets.getBitmapData(Graphic + '.png', true, false), Used);

    public function new(X:Float = 0, Y:Float = 0, Text:String, lol:FlxBitmapFont, ?Size:Float = 32.0){
        super(X, Y, Text, lol);

		size = Size;
    }

	public function setFormat(Size:Float = 8, Color:FlxColor = FlxColor.WHITE, ?Alignment:FlxTextAlign){
		size = Size;
		color = Color;
		if (Alignment != null) alignment = Alignment;
		return this;
	}

	public function set_size(value:Float){
		if(value <= 0) return;
		var sizeMath:Float = (value * (numLines * (lineSpacing + 1)))/ frameHeight;
		scale.set(sizeMath, sizeMath);
		updateHitbox();
	}

}