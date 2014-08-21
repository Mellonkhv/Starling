package veganmatch3 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Mellonkhv
	 */
	public class VVorld extends Sprite 
	{
		static public const FIELD_SIZE:uint = 8;
		static public const TILE_TYPE:uint = 6;
		private var _grid:Array = new Array(FIELD_SIZE*FIELD_SIZE);
		private var _board:Image;
		
		public function VVorld() 
		{
			super();
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			gridGenerate(); /// Генерация поля
			
			_board = new Image(Assets.getTexture("BackGroundImg"));
			addChild(_board);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function gridGenerate():void 
		{
			for (var i:int = 0; i < FIELD_SIZE * FIELD_SIZE; i++) 
			{
				do
				{
					_grid[i] = new Piece();
					_grid[i].type = Math.ceil(Math.random * TILE_TYPE);
				}
				while (isHorizontalMatch(i) || isVerticalMatch(i));
			}
		}
		
		private function isVerticalMatch(i:int):Boolean 
		{
			
		}
		
		private function isHorizontalMatch(i:int):Boolean 
		{
			
		}
		
		private function update(e:Event):void 
		{
			
		}
		
	}

}