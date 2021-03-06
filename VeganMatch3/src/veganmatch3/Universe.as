package veganmatch3 
{
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author Mellonkhv
	 */
	public class Universe extends Sprite 
	{
		//=========================================
		// PUBLIC CONSTANTS
		public static const MAP_SIZE:int = 8;
		public static const MAP_CELL_SIZE:int = 45; // 
		
		//=========================================
		// PRIVATE CONSTANTS
		private const NUM_PIECES:uint = 6;
		private const SPACING:Number = 50;
		private const OFFSET_X:Number = 0;
		private const OFFSET_Y:Number = 0;
		
		//=========================================
		// PRIVATE VARIABLE
		private static var _instance:Universe;
		private var _board:Image;
		private var _pieces:Vector.<Sprite>; // фишки
		private var _grid:Array; // массив фишек
		
		private var _gameBoard:GameBoard; //класс доски с плитками
		//private var _gameSprite:Sprite; // Спрайт для фишек.
		
		private var _firstPiece:Piece; /// ссылка на первую кликнутую фишку
		private var _isDroping:Boolean; //какие фишки нам надо анимировать в данный момент
		private var _isSwapping:Boolean; //какие фишки нам надо анимировать в данный момент
		private var _gameScore:int;
		private var _scoreText:TextField;
		private var _mouseX:Number = 0;
		private var _mouseY:Number = 0;
		private var _superSpell:Boolean = false;
		private var _spellType:String = null;
		
		//=========================================
		// CONSTRUCTOR
		public function Universe() 
		{
			super();
			
			if (_instance != null)
			{
				throw("Error: Мир уже существует. Используйте Universe.getInstance();");
			}
			_instance = this;
			
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//=========================================
		// PRIVATE FUNCTION
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_board = new Image(Assets.getTexture("BackGroundImg"));
			this.addChild(_board);
			
			/// Запуск игры
			_gameBoard = new GameBoard();
			this.addChild(_gameBoard);
			_gameBoard.x = 191;
			_gameBoard.y = 39;
			//startMatchThree();
			
			_isDroping = false;
			_isSwapping = false;
			
			/// Вывод набраных очков
			addScoreText();			
			
			//addButtons();
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		/*private function addButtons():void
		{
			var crazyButton:Button = new Button(Assets.getAtlas().getTexture("title_20"));
			crazyButton.x = 10;
			crazyButton.y = 480 - 55;
			crazyButton.addEventListener(Event.TRIGGERED, cutFullMatch);
			this.addChild(crazyButton);
		}
		
		private function cutFullMatch(e:Event):void 
		{
			_gameSprite.addEventListener(TouchEvent.TOUCH, moveMouse);
			_superSpell = true;
			_spellType = "cutFullMatch";
		}*/
		
		/*private function moveMouse(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(_gameSprite);
			if (touch != null)
			{
				var location:Point = touch.getLocation(_gameSprite);
				_mouseX = location.x;
				_mouseY = location.y;
			}
		}*/
		
		private function spellLocation(spellType:String):void
		{
			
		}
		
		/// Точка входа в игру (строит сетку и включает слушатель)
		/*private function startMatchThree():void 
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
			_gameSprite.x = 191;
			_gameSprite.y = 39;
			addChild (_gameSprite);
		}
		
		// создаем рандомную фишку, добавляем ее в спрайт и сетку
		private function addPiece(col:int, row:int):Piece 
		{
			var newPiece:Piece = new Piece();
			newPiece.type = Math.ceil(Math.random() * NUM_PIECES);
			newPiece.x = (col * SPACING); //+ OFFSET_X + (col );
			newPiece.y = (row * SPACING);// + OFFSET_Y + (row );
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
			if (_firstPiece == null)
			{
				_firstPiece = piece;
				piece.pieceSelect.visible = true;
			}
			// Клик на первой фишке повторно
			else if (_firstPiece == piece)
			{
				piece.pieceSelect.visible = false;
				_firstPiece = null;
			}
			// Клик на другой фишке
			else
			{
				_firstPiece.pieceSelect.visible = false;
				// Тотже ряд, проверяем соседство в колонке
				if ((_firstPiece.row == piece.row) && (Math.abs(_firstPiece.col - piece.col) == 1))
				{
					makeSwap(_firstPiece, piece);
					_firstPiece = null;
				}
				// таже колонка проверяем соседство в ряду
				else if ((_firstPiece.col == piece.col) && (Math.abs(_firstPiece.row - piece.row) == 1))
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
		
		/// Выбраные фишки меняются местами
		private function makeSwap(firstPiece:Piece, secondPiece:Piece):void 
		{
			swapPieces(firstPiece, secondPiece);
			
			// проверяем, был ли обмен удачным
			if (lookForMatches().length == 0)
			{
				swapPieces(firstPiece, secondPiece);
			}
			else
			{
				_isSwapping = true;
			}
		}
		
		/// Непосредственно сам обмен двух фишек местами
		private function swapPieces(firstPiece:Piece, secondPiece:Piece):void 
		{
			// обмениваем значение row и col
			var tempCol:uint = firstPiece.col;
			var tempRow:uint = firstPiece.row;
			firstPiece.col = secondPiece.col;
			firstPiece.row = secondPiece.row;
			secondPiece.col = tempCol;
			secondPiece.row = tempRow;
			
			// измменяем позицию в сетке
			_grid[_firstPiece.col][_firstPiece.row] = _firstPiece;
			_grid[secondPiece.col][secondPiece.row] = secondPiece;
		}*/
		
		// Если фишка не наместе двигаем её на него
		private function update(e:EnterFrameEvent):void 
		{
			//trace(_mouseX + " " + _mouseY);
			if (_superSpell)
			{
				spellLocation(_spellType);
			}
			var madeMove:Boolean = false;
			for (var row:int = 0; row < 8; row++) 
			{
				for (var col:int = 0; col < 8; col++) 
				{
					if (_grid[col][row] != null)
					{
						// Смещаем вниз
						if (_grid[col][row].y < _grid[col][row].row * SPACING)
						{
							_grid[col][row].y += 5;
							madeMove = true;
						}
						// Смещаем вверх
						else if (_grid[col][row].y > _grid[col][row].row * SPACING)
						{
							_grid[col][row].y -= 5;
							madeMove = true;
						}
						// Смещаем вправо
						else if (_grid[col][row].x < _grid[col][row].col * SPACING)
						{	
							_grid[col][row].x += 5;
							madeMove = true;
						}
						// Смещаем влево
						else if (_grid[col][row].x > _grid[col][row].col * SPACING)
						{
							_grid[col][row].x -= 5;
							madeMove = true;
						}
					}
				}
			}
			// Все падения завершены
			if (_isDroping && !madeMove)
			{
				_isDroping = false;
				findAndRemoveMatches();
			}
			// Все обмены завершены
			else if (_isSwapping && !madeMove)
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
					if (_gameBoard.contains(matches[i][j]))
					{
						//var pb = new PointBurst(this, numPoints, matches[i][j].x, matches[i][j].y);
						addScore(numPoints);
						//matches[i][j].removeEventListener(TouchEvent.TOUCH, clickPiece);
						_gameBoard.destroyEventListener(matches[i][j]);
						//_gameSprite.removeChild(matches[i][j]);
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
						var newPiece:Piece = _gameBoard.addTile(col, row);
						newPiece.y = -SPACING - SPACING * missingPieces++ ;
						_isDroping = true;
						
						_gameBoard.gameSprite.addChild(newPiece);
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
		
		private function endGame():void
		{
			//сдвигаем в фон
			//setChildIndex(_gameSprite, 0);
			// переходим в экран окончания игры
			// TODO: Требуется доработка
		}
		
		//=========================================
		// PUBLIC FUNCTION
		// TODO: привязать функцию к кнопке playAgain
		/*public function cleanUp():void
		{
			_grid = null;
			this.removeChild(_gameSprite);
			_gameSprite = null;
			removeEventListener(Event.ENTER_FRAME, update);
		}*/
		
		public static function getInstance():Universe
		{
			return (_instance == null) ? new Universe() : _instance;
		}
		
		//=========================================
		// GETTER & SETTER
		public function get grid():Array 
		{
			return _grid;
		}
		
		public function set grid(value:Array):void 
		{
			_grid = value;
		}
		
		public function get isSwapping():Boolean 
		{
			return _isSwapping;
		}
		
		public function set isSwapping(value:Boolean):void 
		{
			_isSwapping = value;
		}
		
		public function get isDroping():Boolean 
		{
			return _isDroping;
		}
		
		public function set isDroping(value:Boolean):void 
		{
			_isDroping = value;
		}
	}
}
