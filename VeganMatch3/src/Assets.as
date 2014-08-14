package  
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author Mellonkhv
	 */
	public class Assets 
	{
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		
		// Фон
		[Embed(source = "Assets/Image/Background.png")]
		public static const BackGroundImg:Class;
		
		// Текстурная карта
		[Embed(source = "Assets/Image/sprites.png")]
		public static const AtlasTextureGame:Class;
		[Embed(source = "Assets/Image/sprites.xml", mimeType = "application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		// Шрифт
		/*[Embed(source = "Assets/fonts/embedded/BADABB__.TTF", fontFamily = "VeganFontName", embedAsCFF = "false")]
		public static var MyFont:Class;*/
		
		[Embed(source = "Assets/Image/myGlyphs.png")]
		public static const FontTexture:Class;
		[Embed(source = "Assets/Image/myGlyphs.fnt", mimeType = "application/octet-stream")]
		public static const FontXML:Class;
		
		public static var myFont:BitmapFont;
		
		public static function getFont():BitmapFont
		{
			var fontTexture:Texture = Texture.fromBitmap(new FontTexture());
			var fontXML:XML = XML(new FontXML());
			
			var font:BitmapFont = new BitmapFont(fontTexture, fontXML);
			TextField.registerBitmapFont(font);
			
			return font;
		}
		
		public static function getAtlas():TextureAtlas
		{
			if (gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML = XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
		}
		
		static public function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
		
		
		
	}

}