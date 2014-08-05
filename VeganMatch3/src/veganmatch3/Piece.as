package veganmatch3 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Mellonkhv
	 */
	public class Piece extends Sprite 
	{
		private var _type:int;
		private var _pieceImage:Image;
		
		public var pieceSelect:Image;
		
		public function Piece() 
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//if (_type == null) throw("Олень тупой тип указать забыл!");
			createPieceArt();
		}
		
		private function createPieceArt():void 
		{
			pieceSelect = new Image(Assets.getAtlas().getTexture("select"));
			pieceSelect.x = 0;
			pieceSelect.y = 0;
			pieceSelect.visible = false;
			this.addChild(pieceSelect);
			
			_pieceImage = new Image(Assets.getAtlas().getTexture("title_0" + _type));
			_pieceImage.x = 0;
			_pieceImage.y = 0;
			this.addChild(_pieceImage);
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function set type(value:int):void 
		{
			_type = value;
		}
		
	}

}