package veganmatch3 
{
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	
	/**
	 * ...
	 * @author Mellonkhv
	 */
	public class GameBoard extends Sprite 
	{
		//==============================
		// CONSTANTS
		static public const GRIT_SIZE:int = 8;
		static public const NUM_TILES:int = 6;
		
		//==============================
		// PRIVATE VARIABLE
		private var _gridArr:Array;
		private var _isDroping:Boolean;
		private var _isSwapping:Boolean;
		private var _gameSprite:Sprite;
		
		//==============================
		// CONSTRUCTOR
		public function GameBoard() 
		{
			super();
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//==============================
		// PRIVATE METODS
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			/// Создаём сетку
			setupGrid();
		}
		
		private function setupGrid():void 
		{
			///Создаём массив сетки
			_gridArr = [];
			for (var i:int = 0; i < GRIT_SIZE; i++) 
			{
				_gridArr[i] = [];
			}
			
			/// создаём спрайт сетки
			_gameSprite = new Sprite();
			/// Заполняем сетку
			while (true)
			{
				for (var col:int = 0; col < GRIT_SIZE; col++) 
				{
					for (var row:int = 0; row < GRIT_SIZE; row++) 
					{
						_gameSprite.addChild(addTile(col, row));
					}
				}
				/// Проверка поля на "3Вряд"
				if (lookForMatches().length != 0) continue;
				/// Проверка на возможность хода
				if (lookForPosibles() == false) continue;
				/// Конец мучений
				break;
			}
			
			_isDroping = false;
			_isSwapping = false;
			
			this.addChild(_gameSprite);
		}
		
		private function addTile(col:int, row:int):Piece 
		{
			var tile:Piece = new Piece();
			tile.type = Math.ceil(Math.random() * NUM_TILES);
			tile.x = (col * SPASING);
			tile.y = (row * SPASING);
			tile.col = col;
			tile.row = row;
			_gridArr[col][row] = tile;
			tile.addEventListener(TouchEvent.TOUCH, clickTile);
			return tile;
		}
		
		//==============================
		// GETTER & SETTER
	}
}