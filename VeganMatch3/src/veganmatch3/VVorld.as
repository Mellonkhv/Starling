package veganmatch3 
{
	import flash.geom.Point;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Mellonkhv
	 */
	public class VVorld extends Sprite 
	{
		static public const FIELD_SIZE:uint = 8;
		static public const TILE_TYPE:uint = 8;
		static public const SPACING:uint = 45;
		static public const OFFSET_X:uint = 10;
		static public const OFFSET_Y:uint = 10;
		private var _grid:Array = new Array(FIELD_SIZE*FIELD_SIZE);
		private var _board:Image;
		private var _gameField:Sprite;
		private var _firstPiece:Piece;
		private var _isSwapping:Boolean;
		private var _isDroping:Boolean;
		
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
			
			//_board = new Image(Assets.getTexture("BackGroundImg"));
			//addChild(_board);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		/// Генерирование игрового поля
		private function gridGenerate():void 
		{
			_isDroping = false;
			_isSwapping = false;
			
			_gameField = new Sprite();
			for (var i:int = 0; i < FIELD_SIZE * FIELD_SIZE; i++) 
			{
				do
				{
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
		/// Возвращает true если фишка с индексом находится в вертикальном "ряду"
		private function isVerticalMatch(i:int):Boolean 
		{
			return rowNumber(i) >= 2 && _grid[i].type == _grid[i - FIELD_SIZE].type && _grid[i].type == _grid[i - 2 * FIELD_SIZE].type;
		}
		/// Возвращает true если фишка с индексом находится в горизонтальном "ряду"
		private function isHorizontalMatch(i:int):Boolean 
		{
			return colNumber(i) >= 2 && _grid[i].type == _grid[i - 1].type && _grid[i].type == _grid[i - 2].type && rowNumber(i) == rowNumber(i - 2);
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
		/// Клик по плиткам
		private function clickTile(e:TouchEvent):void 
		{
			var piece:Piece = Piece(e.currentTarget);
			var touches:Vector.<Touch> = e.getTouches(this, TouchPhase.ENDED);
			if (touches.length == 0) return;
			/// Клик на первой плитке
			if (_firstPiece == null)
			{
				_firstPiece = piece;
				piece.pieceSelect.visible = true;
			}
			/// Клик на первой повторно
			else if (_firstPiece == piece)
			{
				piece.pieceSelect.visible = false;
				_firstPiece = null;
			}
			/// Клик на другой фишке
			else
			{
				_firstPiece.pieceSelect.visible = false;
				/// Тотже ряд, проверяем соседство в колонке
				if (rowNumber(_firstPiece.index) == rowNumber(piece.index) && Math.abs(colNumber(_firstPiece.index) - colNumber(piece.index)) == 1)
				{
					makeSwap(_firstPiece, piece);
					_firstPiece = null;
				}
				/// таже колонка проверяем соседство в ряду
				else if (colNumber(_firstPiece.index) == colNumber(piece.index) && Math.abs(rowNumber(_firstPiece.index) - rowNumber(piece.index)) == 1)
				{
					makeSwap(_firstPiece, piece);
					_firstPiece = null;
				}
				else
				{
					_firstPiece = piece;
					_firstPiece.pieceSelect.visible = true;
				}
			}
		}
		
		private function makeSwap(firstPiece:Piece, secondPiece:Piece):void 
		{
			tweenTile(firstPiece, secondPiece);
			
			trace (isHorizontalMatch(firstPiece.index) + " " + isVerticalMatch(firstPiece.index) + " " + isHorizontalMatch(secondPiece.index) + " " + isVerticalMatch(secondPiece.index));
			trace (firstPiece.index + " " + secondPiece.index);
			
			if ((isHorizontalMatch(firstPiece.index) || isVerticalMatch(firstPiece.index)) || (isHorizontalMatch(secondPiece.index) || isVerticalMatch(secondPiece.index)))
			{
				_isSwapping = true;
			}
			else
			{
				tweenTile(firstPiece, secondPiece);
			}
		}
		
		private function tweenTile(firstPiece:Piece, secondPiece:Piece):void 
		{
			var firstPos:Point = new Point(firstPiece.x, firstPiece.y);
			var secondPos:Point = new Point(secondPiece.x, secondPiece.y);
			var tweenfirst:Tween = new Tween(firstPiece, 0.5, Transitions.EASE_OUT);
			var tweensecond:Tween = new Tween(secondPiece, 0.5, Transitions.EASE_OUT);
			
			tweenfirst.animate("x", secondPos.x);
			tweenfirst.animate("y", secondPos.y);
			
			tweensecond.animate("x", firstPos.x);
			tweensecond.animate("y", firstPos.y);
			
			tweenfirst.onComplete = function():void { swapTiles(firstPiece, secondPiece); }
			
			Starling.juggler.add(tweenfirst);
			Starling.juggler.add(tweensecond);
		}
		
		private function swapTiles(firstPiece:Piece, secondPiece:Piece):void 
		{
			var tempIndex:int = firstPiece.index;
			firstPiece.index = secondPiece.index;
			secondPiece.index = tempIndex;
			trace(tempIndex + " " + firstPiece.index + " " + secondPiece.index);
			/// вот тут косяк
			_grid[firstPiece.index] = firstPiece;
			_grid[secondPiece.index] = secondPiece;
		}
		
		private function update(e:Event):void 
		{
			
		}
		
	}

}