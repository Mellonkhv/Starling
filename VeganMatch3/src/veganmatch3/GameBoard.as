package veganmatch3 
{
	import adobe.utils.CustomActions;
	import flash.geom.Point;
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
		// PUBLIC CONSTANTS
		static public const FIELD_SIZE:uint = 8;
		static public const TILE_TYPE:uint = 8;
		static public const SPACING:int = 45;
		static public const OFFSET_X:uint = 10;
		static public const OFFSET_Y:uint = 10;
		
		//==============================
		// PRIVATE WARIABLE
		private var _isDroping:Boolean;
		private var _isSwapping:Boolean;
		private var _gameField:Sprite;
		private var _grid:Vector.<Piece> = new Vector.<Piece>;
		private var _firstPiece:Piece;
		
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
			
			generateGrid();
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		/// Генерирование игровой сетки
		private function generateGrid():void 
		{
			_isDroping = false;
			_isSwapping = false;
			_grid.length = FIELD_SIZE * FIELD_SIZE;
			_gameField = new Sprite();
			for (var i:int = 0; i < FIELD_SIZE * FIELD_SIZE; i++) 
			{
				do {
					_grid[i] = new Piece();
					_grid[i].type = Math.ceil((Math.random() * TILE_TYPE));
				}
				while (isHorizontalMatch(i) || isVerticalMatch(i));
				
				_grid[i].x = (colNumber(i) * SPACING) + OFFSET_X + (colNumber(i) * 5);
				_grid[i].y = (rowNumber(i) * SPACING) + OFFSET_Y + (rowNumber(i) * 5);
				_grid[i].index = i;
				_grid[i].addEventListener(TouchEvent.TOUCH, clickTile);
				
				_gameField.addChild(_grid[i]);
			}
			_gameField.x = 181;
			_gameField.y = 29;
			this.addChild(_gameField);
		}
		/// Обновление состояния плиток
		private function update(e:Event):void 
		{
			var madeMove:Boolean = false;
			for (var i:int = 0; i < FIELD_SIZE * FIELD_SIZE; i++) 
			{
				if (_grid[i] != null)
				{
					// Смещаем вниз
					var xx:int = ((rowNumber(i) * SPACING) + OFFSET_Y + (rowNumber(i) * 5));
					trace(xx);
					if (_grid[i].y < ((rowNumber(i) * SPACING) + OFFSET_Y + (rowNumber(i) * 5)))
					{
						_grid[i].y += 5;
						madeMove = true;
					}
					// Смещаем в верх
					else if (_grid[i].y > ((rowNumber(i) * SPACING) + OFFSET_Y + (rowNumber(i) * 5)))
					{
						_grid[i].y -= 5;
						madeMove = true;
					}
					if (_grid[i].x < ((colNumber(i) * SPACING) + OFFSET_X + (colNumber(i) * 5)))
					{
						_grid[i].x += 5;
						madeMove = true;
					}
					else if (_grid[i].x > ((colNumber(i) * SPACING) + OFFSET_X + (colNumber(i) * 5)))
					{
						_grid[i].x -= 5;
						madeMove = true;
					}
					
				}
			}
			// Если все падения завершены
			if (isDropping && !madeMove) {
				isDropping = false;
				findAndRemoveMatches();
				
			// Если все замены завершены
			} else if (isSwapping && !madeMove) {
				isSwapping = false;
				findAndRemoveMatches();
			}
		}
		
		/// Поиск и удаление рядов
		private function findAndRemoveMatches():void 
		{
			// получаем список линий
			var matchs:Array = lookForMatches();
			for (var i:int = 0; i < matchs.length; i++) 
			{
				var numPoints:Number = (matchs[i].length - 1) * 50;
				for (var j:int = 0; j < matchs[i].length; j++) 
				{
					if (_gameField.contains(matchs[i][j]))
					{
						//var pb = new PointBurst(this,numPoints,matches[i][j].x,matches[i][j].y);
						addScore(numPoints);
						_gameField.removeChild(matchs[i][j]);
						_grid[matchs[i][j].index] = null;
						affectAbove(matchs[i][j]);
					}
				}
			}
			
			// Добавляем новые плитки на верх поля
			addNewTiles();
			
			// Нет ниодной линии, возможно игра закончилась?
			if (matchs.length == 0)
			{
				if (!lookForPossibles())
				{
					endGame();
				}
			}
		}
		
		/// Возвращает массив всех найденых линий
		private function lookForMatches():Array 
		{
			var matchList:Array = [];
			// поиск горизонтальных и вертикальных линий (похоже тут будет спагетикод или нет)
			for (var i:int = 0; i < FIELD_SIZE * FIELD_SIZE; i++) 
			{
				var match:Array = getMatch(i);
			}
		}
		
		private function lookForPossibles():Boolean 
		{
			
		}
		
		private function addNewTiles():void 
		{
			
		}
		
		/// Клик по плиткам
		private function clickTile(e:TouchEvent):void 
		{
			var piece:Piece = Piece(e.currentTarget);
			var touch:Touch = e.getTouch(piece, TouchPhase.ENDED);
			if (touch == null) return;
			// Клик по первой плитке
			if (_firstPiece == null)
			{
				piece.pieceSelect.visible = true;
				_firstPiece = piece;
			}
			// Повторный клик по первой плитке
			else if (_firstPiece == piece)
			{
				piece.pieceSelect.visible = false;
				_firstPiece = null;
			}
			// Клил по второй плитке
			else if (_firstPiece != null && _firstPiece != piece)
			{
				_firstPiece.pieceSelect.visible = false;
				// Тотже ряд, проверка на соседство в колонке
				if ((rowNumber(_firstPiece.index) == rowNumber(piece.index)) && (Math.abs(colNumber(_firstPiece.index) - colNumber(piece.index)) == 1))
				{
					makeSwap(_firstPiece, piece);
					_firstPiece = null;
				}
				// Таже колонка, проверка на соседство в ряду
				else if ((colNumber(_firstPiece.index) == colNumber(piece.index)) && (Math.abs(rowNumber(_firstPiece.index) - rowNumber(piece.index)) == 1))
				{
					makeSwap(_firstPiece, piece);
					_firstPiece = null;
				}
				// Нет соседства
				else
				{
					_firstPiece = piece;
					_firstPiece.pieceSelect.visible = true;
				}				
			}
		}
		/// Начало обмена 2х фишек
		private function makeSwap(firstPiece:Piece, secondPiece:Piece):void 
		{
			swapTiles(firstPiece, secondPiece);
			
			// проверка был ли обмен удачным
			if (lookForMatches().length == 0)
			{
				swapTiles(firstPiece, secondPiece);
			}
			else
			{
				_isSwapping = true;
			}
		}
		/// Непосредственный обмен 2х фишек
		private function swapTiles(firstPiece:Piece, secondPiece:Piece):void 
		{
			var tempIndex:int = firstPiece.index;
			firstPiece.index = secondPiece.index;
			secondPiece.index = tempIndex;
			
			_grid[firstPiece.index] = firstPiece;
			_grid[secondPiece.index] = secondPiece;
		}
		
		/// Возвращает true если фишка с индексом находится в горизонтальном "ряду"
		private function isHorizontalMatch(i:int):Boolean 
		{
			return colNumber(i) >= 2 && _grid[i].type == _grid[i - 1].type && _grid[i].type == _grid[i - 2].type && rowNumber(i) == rowNumber(i - 2);
		}
		/// Возвращает true если фишка с индексом находится в вертикальном "ряду"
		private function isVerticalMatch(i:int):Boolean 
		{
			return rowNumber(i) >= 2 && _grid[i].type == _grid[i - FIELD_SIZE].type && _grid[i].type == _grid[i - 2 * FIELD_SIZE].type;
		}
		/// Возвращает номер колонки
		private function colNumber(i:int):Number 
		{
			return i % FIELD_SIZE;
		}
		/// Возвращает номер строки
		private function rowNumber(i:int):Number 
		{
			return Math.floor(i / FIELD_SIZE);
		}
	}

}