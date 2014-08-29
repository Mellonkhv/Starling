package veganmatch3 
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Mellonkhv
	 */
	public class GameBoard extends Sprite 
	{
		
		static public const FIELD_SIZE:int = 8;
		
		//==============================
		// PRIVATE WARIABLE
		private var _isDroping:Boolean;
		private var _isSwapping:Boolean;
		private var _gameField:Sprite;
		
		public function GameBoard() 
		{
			super();
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			generateGrid();
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function generateGrid():void 
		{
			_isDroping = false;
			_isSwapping = false;
			
			_gameField = new Sprite();
			for (var i:int = 0; i < FIELD_SIZE * FIELD_SIZE; i++) 
			{
				do {
					_grid[i] = new Piece();
					_grid[i].type = Math.ceil((Math.random() * TILE_TYPE));
				}
				while (isHorizontalMatch(i) || isVerticalMatch(i));
				
				_grid[i].x = (colNumber(i) * SPACING) + OFFSET_X + (colNumber(i) * 5);
				_grid[i].y = (rowNumber(i) * SPACING) + OFFSET_X + (rowNumber(i) * 5);
				_grid[i].index = i;
				_grid[i].addEventListener(TouchEvent.TOUCH, clickTile);
				
				_gameField.addChild(_grid[i]);
			}
			_gameField.x = 181;
			_gameField.y = 29;
			this.addChild(_gameField);
		}
		
		private function update(e:Event):void 
		{
			
		}
		
	}

}