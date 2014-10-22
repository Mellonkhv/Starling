package veganmatch3 
{
	import starling.display.Sprite;
	import starling.events.Event;
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
		static public const SPASING:int = 50;
		
		//==============================
		// PRIVATE VARIABLE
		//private var _gridArr:Array;
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
			//_gridArr = [];
			for (var i:int = 0; i < GRIT_SIZE; i++) 
			{
				//_gridArr[i] = [];
				_universe.grid[i] = [];
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
				if (lookForPossibles() == false) continue;
				/// Конец мучений
				break;
			}
			
			this.addChild(_gameSprite);
		}
		
		/// Непосредственный поиск рядов
		private function lookForMatches():Array 
		{
			var matchList:Array = new Array();
			
			//поиск по горизонту
			for (var row:int = 0; row < 8; row++) 
			{
				for (var col:int = 0; col < 6; col++) 
				{
					var match:Array = getMatchHoriz(col, row);
					if (match.length > 2)
					{
						matchList.push(match);
						col += match.length - 1;
					}
				}
			}
			
			// поиск вертикальных линий
			for (col = 0; col < 8; col++) 
			{
				for (row = 0; row < 6; row++) 
				{
					match = getMatchVert(col, row);
					if (match.length > 2)
					{
						matchList.push(match);
						row += match.length - 1;
					}
				}
			}
			
			return matchList;
		}
		
		// Проверка на возможные ходы
		private function lookForPossibles():Boolean
		{
			for (var col:int = 0; col < 8; col++) 
			{
				for (var row:int = 0; row < 8; row++) 
				{
					// Возможно горизонтальная, две подряд
					if (matchPattern(col, row, [[1, 0]], [[ -2, 0], [ -1, -1], [ -1, 1], [2, -1], [2, 1], [3, 0]]))
					{
						return true;
					}
					// возможна горизонтальная, две по разным сторонам
					if (matchPattern(col, row, [[2, 0]], [[1, -1], [1, 1]] ))
					{
						return true;
					}
					// возможна вертикальная, две подряд
					if (matchPattern(col, row, [[0, 1]], [[0, -2], [ -1, -1], [1, -1], [ -1, 2], [1, 2], [0, 3]]))
					{
						return true;
					}
					// возможна вертикальная, две по разным стьоронам
					if (matchPattern(col, row, [[0, 2]], [[ -1, 1], [1, 1]]))
					{
						return true;
					}
				}
			}
			// не найдено возможных линий 
			return false;
			
		}
		
		/// Проверка на "ряд" от текущей фишки
		private function matchPattern(col:uint, row:uint, mustHave:Array, needOne:Array):Boolean 
		{
			var thisType:int = _universe.grid[col][row].type;
			
			// убедимся, что есть вторая фишка того же типа
			for (var i:int = 0; i < mustHave.length; i++) 
			{
				if (!matchType(col + mustHave[i][0], row + mustHave[i][1], thisType))
				{
					return false;
				}
			}
			// убедимся,  что третья фишка совпадает по типу с двумя другими
			for (i= 0; i < needOne.length; i++) 
			{
				if (matchType(col + needOne[i][0], row + needOne[i][1], thisType))
				{
					return true;
				}
			}
			return false;
		}
		
		/// Проверка совпадения типов
		private function matchType(col:int, row:int, type:int):Boolean 
		{
			if ((col<0) || (col>7)||(row<0)||(row>7)) return false;
			return (_universe.grid[col][row].type == type);
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
		
		/// Выбраные фишки меняются местами
		private function makeSwap(firstTile:Piece, secondTile:Piece):void 
		{
			swapTiles(firstTile, secondTile);
			
			// проверяем, был ли обмен удачным
			if (lookForMatches().length == 0)
			{
				swapTiles(firstTile, secondTile);
			}
			else
			{
				_universe.isSwapping = true;
			}
		}
		
		private function swapTiles(firstTile:Piece, secondTile:Piece):void 
		{
			/// обмениваем значение row и col
			var tempCol:uint = firstTile.col;
			var tempRow:uint = firstTile.row;
			firstTile.col = secondTile.col;
			firstTile.row = secondTile.row;
			
			secondTile.col = tempCol;
			secondTile.row = tempRow;
			
			_universe.grid[_firstTile.col][_firstTile.row] = _firstTile;
			_universe.grid[secondTile.col][secondTile.row] = secondTile;
		}
		
		// поиск горизонтальных линий из заданной точки
		private function getMatchHoriz(col:int, row:int):Array 
		{
			var match:Array = [];
			match.push(_universe.grid[col][row]);
			for (var i:int = 1; col + i < 8; i++) 
			{
				if (_universe.grid[col][row].type == _universe.grid[col + i][row].type)
				{
					match.push(_universe.grid[col + i][row]);
				}
				else return match;
			}
			
			return match;
		}
		
		// поиск вертикальных линий из заданной точки
		private function getMatchVert(col:int, row:int):Array
		{
			var match:Array = [];
			match.push(_universe.grid[col][row]);
			for (var i:int = 1; row + i < 8; i++) 
			{
				if (_universe.grid[col][row].type == _universe.grid[col][row + i].type)
				{
					match.push(_universe.grid[col][row + i]);
				}
				else return match;
			}
			
			return match;
		}
		
		//==============================
		// PUBLIC METODS
		public function destroyEventListener(tile:Piece):void
		{
			tile.removeEventListener(TouchEvent.TOUCH, clickTile);
		}
		
		public function addTile(col:int, row:int):Piece 
		{
			var tile:Piece = new Piece();
			tile.type = Math.ceil(Math.random() * NUM_TILES);
			tile.x = (col * SPASING);
			tile.y = (row * SPASING);
			tile.col = col;
			tile.row = row;
			//_gridArr[col][row] = tile;
			_universe.grid[col][row] = tile;
			tile.addEventListener(TouchEvent.TOUCH, clickTile);
			return tile;
		}
		
		//==============================
		// GETTER & SETTER
		
		
		public function get gameSprite():Sprite 
		{
			return _gameSprite;
		}
		
		public function set gameSprite(value:Sprite):void 
		{
			_gameSprite = value;
		}
	}
}