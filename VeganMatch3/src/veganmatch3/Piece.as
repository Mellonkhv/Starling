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
		private var _index:int;
		private var _col:uint;
		private var _row:uint;
		
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
			
			_pieceImage = new Image(Assets.getAtlas().getTexture("title_" + _type));
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
		
		public function get col():uint 
		{
			return _col;
		}
		
		public function set col(value:uint):void 
		{
			_col = value;
		}
		
		public function get row():uint 
		{
			return _row;
		}
		
		public function set row(value:uint):void 
		{
			_row = value;
		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set index(value:int):void 
		{
			_index = value;
		}
		
	}

}