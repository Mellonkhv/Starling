package veganmatch3 
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author Mellonkhv
	 */
	public class Univerce extends Sprite 
	{
		//=========================================
		// PUBLIC CONSTANTS
		public static const MAP_SIZE:int = 8;
		public static const MAP_CELL_SIZE:int = 45; // 
		
		//=========================================
		// PRIVATE CONSTANTS
		private const NUM_PIECES:uint = 6;
		private const SPACING:Number = 45;
		private const OFFSET_X:Number = 10;
		private const OFFSET_Y:Number = 10;
		
		//=========================================
		// PRIVATE VARIABLE
		private var _board:Image;
		private var _pieces:Vector.<Sprite>; // фишки
		private var _grid:Array; // массив фишек
		private var _gameSprite:Sprite; // Спрайт для фишек.
		private var _firstPice:Piece; /// ссылка на первую кликнутую фишку
		private var _isDroping:Boolean; //какие фишки нам надо анимировать в данный момент
		private var _isSwapping:Boolean; //какие фишки нам надо анимировать в данный момент
		private var _gameScore:int;
		private var _scoreText:TextField;
		//private var _tween:Tween
		
		//=========================================
		// CONSTRUCTOR
		public function Univerce() 
		{
			super();
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//=========================================
		// PRIVATE FUNCTION
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//_board = new Image(Assets.getTexture("BackGroundImg"));
			//this.addChild(_board);
			/// Запуск игры
			startMatchThree();
			
			/// Вывод набраных очков
			addScoreText();
			
			/// Тест анимации
			tweenAnimation();
		}
		
		private function tweenAnimation():void 
		{
			var tween:Tween = new Tween(_grid[0][0], 2.0, Transitions.EASE_IN_OUT);
			tween.animate("x", _grid[0][0].x + 50);
			tween.animate("rotation", deg2rad(45));
			tween.fadeTo(0);
			tween.onComplete = tween_oncomplete;
			
			//tween.onComplete
			Starling.juggler.add(tween);
		}
		
		private function tween_oncomplete():void 
		{
			var tween:Tween = new Tween(_grid[0][0], 2.0, Transitions.EASE_IN_OUT);
			tween.animate("x", _grid[0][0].x - 50);
			tween.animate("rotation", deg2rad(0));
			tween.fadeTo(1);
			Starling.juggler.add(tween);
		}
		
		/// Точка входа в игру (строит сетку и включает слушатель)
		private function startMatchThree():void 
		{
			_grid = new Array();
			for (var i:int = 0; i < 8; i++) 
			{
				_grid.push(new Array());
			}
			setUpGrid();
			_isDroping = false;
			_isSwapping = false;
			_gameScore = 0;
			this.addEventListener(Event.ENTER_FRAME, movePieces);
		}
		/// Создание сетки из случайных фишек и расположение спрайта сетки относительно координат
		private function setUpGrid():void 
		{
			//var check:Boolean = true;
			while (true) 
			{
				// Создаём спрайт
				_gameSprite = new Sprite();
				for (var col:int = 0; col < MAP_SIZE; col++) 
				{
					for (var row:int = 0; row < MAP_SIZE; row++) 
					{
						addPiece(col, row);
					}
				}
				// Проверка на "3Вряд" на поле
				if (lookForMatches().length != 0) continue;
				// Проверка на возможность хода
				if (lookForPossibles() == false) continue;
				break;
			}
			_gameSprite.x = 181;
			_gameSprite.y = 29;
			addChild (_gameSprite);
		}
		
		// создаем рандомную фишку, добавляем ее в спрайт и сетку
		private function addPiece(col:int, row:int):Piece 
		{
			var newPiece:Piece = new Piece();
			newPiece.type = Math.ceil(Math.random() * NUM_PIECES);
			newPiece.x = (col * SPACING) + OFFSET_X + (col * 5);
			newPiece.y = (row * SPACING) + OFFSET_Y + (row * 5);
			newPiece.col = col;
			newPiece.row = row;
			_gameSprite.addChild(newPiece);
			_grid[col][row] = newPiece;
			newPiece.addEventListener(TouchEvent.TOUCH, clickPiece);
			return newPiece;
		}
		
		/// Щелчёк по фишке с проверкой не выбрана ли ещё одна фишка
		private function clickPiece(e:TouchEvent):void 
		{
			var piece:Piece = Piece(e.currentTarget);
			var touches:Vector.<Touch> = e.getTouches(this, TouchPhase.ENDED);
			if (touches.length == 0) return;
			// клик на первой фишке
			if (_firstPice == null)
			{
				_firstPice = piece;
				piece.pieceSelect.visible = true;
			}
			// Клик на первой фишке повторно
			else if (_firstPice == piece)
			{
				piece.pieceSelect.visible = false;
				_firstPice = null;
			}
			// Клик на другой фишке
			else
			{
				_firstPice.pieceSelect.visible = false;
				// Тотже ряд, проверяем соседство в колонке
				if ((_firstPice.row == piece.row) && (Math.abs(_firstPice.col - piece.col) == 1))
				{
					makeSwap(_firstPice, piece);
					_firstPice = null;
				}
				// таже колонка проверяем соседство в ряду
				else if ((_firstPice.col == piece.col) && (Math.abs(_firstPice.row - piece.row) == 1))
				{
					makeSwap(_firstPice, piece);
					_firstPice = null;
				}
				else
				{
					_firstPice = piece;
					_firstPice.pieceSelect.visible = true;
				}
			}
		}
		
		/// Выбраные фишки меняются местами
		private function makeSwap(_firstPice:Piece, secondPiece:Piece):void 
		{
			swapPieces(_firstPice, secondPiece);
			// TODO: Воткнуть анимазию смены положения фишками сюда
			// проверяем, был ли обмен удачным
			if (lookForMatches().length == 0)
			{
				swapPieces(_firstPice, secondPiece);
			}
			else
			{
				_isSwapping = true;
			}
		}
		
		/// Непосредственно сам обмен двух фишек местами
		private function swapPieces(_firstPice:Piece, secondPiece:Piece):void 
		{
			// обмениваем значение row и col
			var tempCol:uint = _firstPice.col;
			var tempRow:uint = _firstPice.row;
			_firstPice.col = secondPiece.col;
			_firstPice.row = secondPiece.row;
			secondPiece.col = tempCol;
			secondPiece.row = tempRow;
			
			// измменяем позицию в сетке
			_grid[_firstPice.col][_firstPice.row] = _firstPice;
			_grid[secondPiece.col][secondPiece.row] = secondPiece;
		}
		
		// TODO: Заменить данную анимацию на Tween
		private function tweenDrop(piece:Piece):void
		{
			var dropPiece:Piece = piece;
			
		}
		// Если фишка не наместе двигаем её на него
		private function movePieces(e:Event):void 
		{
			var madeMove:Boolean = false;
			for (var row:int = 0; row < 8; row++) 
			{
				for (var col:int = 0; col < 8; col++) 
				{
					if (_grid[col][row] != null)
					{
						// Смещаем вни
						if (_grid[col][row].y < _grid[col][row].row * SPACING + OFFSET_Y + row * 5)
						{
							_grid[col][row].y += 5;
							madeMove = true;
						}
						// Смещаем вверх
						else if (_grid[col][row].y > _grid[col][row].row * SPACING + OFFSET_Y + row * 5)
						{
							_grid[col][row].y -= 5;
							madeMove = true;
						}
						// Смещаем вправо
						else if (_grid[col][row].x < _grid[col][row].col * SPACING + OFFSET_X + col * 5)
						{
							_grid[col][row].x += 5;
							madeMove = true;
						}
						// Смещаем влево
						else if (_grid[col][row].x > _grid[col][row].col * SPACING + OFFSET_X + col * 5)
						{
							_grid[col][row].x -= 5;
							madeMove = true;
						}
					}
				}
			}
			// Все падения завершены
			if (_isDroping && madeMove)
			{
				_isDroping = false;
				findAndRemoveMatches();
			}
			// Все обмены завершены
			else if (_isSwapping && madeMove)
			{
				_isSwapping = false;
				findAndRemoveMatches();
			}
		}
		
		/// Поиск и удаление рядов
		private function findAndRemoveMatches():void 
		{
			// Формируем список линий
			var matches:Array = lookForMatches();
			for (var i:int = 0; i < matches.length; i++) 
			{
				var numPoints:Number = (matches[i].length - 1) * 50;
				for (var j:int = 0; j < matches[i].length; j++)
				{
					if (_gameSprite.contains(matches[i][j]))
					{
						//var pb = new PointBurst(this, numPoints, matches[i][j].x, matches[i][j].y);
						addScore(numPoints);
						matches[i][j].removeEventListener(TouchEvent.TOUCH, clickPiece);
						_gameSprite.removeChild(matches[i][j]);
						_grid[matches[i][j].col][matches[i][j].row] = null;
						affectAbove(matches[i][j]);
					}
				}
			}
			// добавляем новую фишку вверху поля
			addNewPieces();
			
			// линий ненайдено проверяем на возможность хода
			if (matches.length == 0)
			{
				if (!lookForPossibles()) endGame();				
			}
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
			for (var col:int = 0; col < 8; col++) 
			{
				for (var row:int = 0; row < 6; row++) 
				{
					var match:Array = getMatchVert(col, row);
					if (match.length > 2)
					{
						matchList.push(match);
						row += match.length - 1;
					}
				}
			}
			
			return matchList;
		}
		
		// поиск горизонтальных линий из заданной точки
		private function getMatchHoriz(col:int, row:int):Array 
		{
			var match:Array = new Array(_grid[col][row]);
			for (var i:int = 1; col + i < 8; i++) 
			{
				if (_grid[col][row].type == _grid[col + i][row].type)
				{
					match.push(_grid[col + i][row]);
				}
				else return match;
			}
			
			return match;
		}
		
		// поиск вертикальных линий из заданной точки
		private function getMatchVert(col:int, row:int):Array
		{
				var match:Array = new Array(_grid[col][row]);
			for (var i:int = 1; row + i < 8; i++) 
			{
				if (_grid[col][row].type == _grid[col][row + i].type)
				{
					match.push(_grid[col][row + i]);
				}
				else return match;
			}
			
			return match;
		}
		
		// заставляет фишки над переданой в функцию двигаться вниз
		private function affectAbove(piece:Piece):void 
		{
			for (var row:int = piece.row - 1; row >=0 ; row--) 
			{
				if (_grid[piece.col][row] != null)
				{
					_grid[piece.col][row].row++;
					_grid[piece.col][row + 1] = _grid[piece.col][row];
					_grid[piece.col][row] = null;
				}
			}
		}
		
		// Если в колонке отсутствует фишка, добавляем новую, падающую сверху
		private function addNewPieces():void
		{
			for (var col:int = 0; col < 8; col++) 
			{
				var missingPieces:int = 0;
				for (var row:int = 7; row >=0; row--) 
				{
					if (_grid[col][row] == null)
					{
						var newPiece:Piece = addPiece(col, row);
						newPiece.y = OFFSET_Y - SPACING - SPACING * missingPieces++ - (row * 5);
						_isDroping = true;
					}
				}
			}
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
			var thisType:int = _grid[col][row].type;
			
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
			return (_grid[col][row].type == type);
		}
		
		/// Отображает количество набраных очков
		private function addScoreText():void 
		{
			_scoreText = new TextField(150, 100, "SCORE: 0", Assets.getFont().name, 24, 0xFFFFFF);
			_scoreText.hAlign = HAlign.LEFT;
			_scoreText.vAlign = VAlign.CENTER;
			_scoreText.x = 20;
			_scoreText.y = 20;
			_scoreText.height = _scoreText.textBounds.height +10;
			this.addChild(_scoreText);
		}
		
		/// Считает количество набраных очков
		private function addScore (numPoints:int):void
		{
			_gameScore += numPoints;
			_scoreText.text = "SCORE: " + _gameScore;
		}
		
		private function endGame()
		{
			//сдвигаем в фон
			setChildIndex(_gameSprite, 0);
			// переходим в экран окончания игры
			// TODO: Требуется доработка
		}
		
		// TODO: привязать функцию к кнопке playAgain
		public function cleanUp()
		{
			_grid = null;
			this.removeChild(_gameSprite);
			_gameSprite = null;
			removeEventListener(Event.ENTER_FRAME, movePieces);
		}
	}
}