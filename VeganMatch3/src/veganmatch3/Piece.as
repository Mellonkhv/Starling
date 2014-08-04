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
		
		public function Piece(type:int) 
		{
			super();
			
			this._type = type;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			createPieceArt();
		}
		
		private function createPieceArt():void 
		{
			_pieceImage = new Image(Assets.getAtlas().getTexture("tile_0" + _type));
			_pieceImage.x = 0;
			_pieceImage.y = 0;
			this.addChild(_pieceImage);
		}
		
	}

}