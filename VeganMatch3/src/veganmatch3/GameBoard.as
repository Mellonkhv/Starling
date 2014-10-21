package veganmatch3 
{
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
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
		private var _universe:Universe;
		private var _firstTile:Piece = null;
		
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
			
			_universe = Universe.getInstance();
			
			/// Создаём сетку
			setupGrid();
		}
		
		private function setupGrid():void 
		{
			///Создаём массив сетки
			_universe.grid = [];
			_gridArr = [];
			for (var i:int = 0; i < GRIT_SIZE; i++) 
			{
				_gridArr[i] = [];
				_universe.grid[1] = [];
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
		
		private function clickTile(e:TouchEvent):void 
		{
			var tile:Piece = Piece(e.currentTarget);
			var touches:Vector.<Touch> = e.getTouches(this, TouchPhase.ENDED);
			if (touches.length == 0) return;
			/// Клик по первой плитке
			if (_firstTile == null)
			{
				_firstTile = tile;
				tile.pieceSelect.visible = true;
			}
			/// Клик по первой плитке пвторно
			else if (_firstTile == tile)
			{
				tile.pieceSelect.visible = false
				_firstTile = null;
			}
			/// Второй кликнута любая другая плитка на поле
			else
			{
				_firstTile.pieceSelect.visible = false; /// убираем выделение
				/// Тотже ряд, проверяем соседство в колонке
				if ((_firstTile.row == tile.row) && (Math.abs(_firstTile.col - tile.col) == 1))
				{
					makeSwap(_firstTile, tile);
					_firstTile = null;
				}
				/// та же колонка, проверяем на соседство в ряду
				else if ((_firstTile.col == tile.col) && (Math.abs(_firstTile.row - tile.row) == 1))
				{
					makeSwap(_firstTile, tile);
					_firstTile = null;
				}
				else
				{
					_firstTile = tile;
					tile.pieceSelect.visible = true;
				}
			}
		}
		
		//==============================
		// GETTER & SETTER
	}
}