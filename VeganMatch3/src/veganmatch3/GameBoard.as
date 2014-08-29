package veganmatch3 
{
	import adobe.utils.CustomActions;
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
		static public const FIELD_SIZE:int = 8;
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
			_grid.length = FIELD_SIZE * FIELD_SIZ
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
		// Клик по плиткам
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
		
		private function makeSwap(firstPiece:Piece, piece:Piece):void 
		{
			
		}
		
		// Возвращает true если фишка с индексом находится в горизонтальном "ряду"
		private function isHorizontalMatch(i:int):Boolean 
		{
			return colNumber(i) >= 2 && _grid[i].type == _grid[i - 1].type && _grid[i].type == _grid[i - 2].type && rowNumber(i) == rowNumber(i - 2);
		}
		// Возвращает true если фишка с индексом находится в вертикальном "ряду"
		private function isVerticalMatch(i:int):Boolean 
		{
			return rowNumber(i) >= 2 && _grid[i].type == _grid[i - FIELD_SIZE].type && _grid[i].type == _grid[i - 2 * FIELD_SIZE].type;
		}
		// Возвращает номер колонки
		private function colNumber(i:int):Number 
		{
			return i % FIELD_SIZE;
		}
		// Возвращает номер строки
		private function rowNumber(i:int):Number 
		{
			return Math.floor(i / FIELD_SIZE);
		}
	}

}