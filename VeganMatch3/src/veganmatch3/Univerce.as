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
		// PUBLIC VARIABLE
		private var _board:Sprite; // TODO: Фон поменять на Image
		private var _pieces:Vector.<Sprite>; // фишки
		private var _grid:Array; // массив фишек
		private var gameSprite:Sprite; // Спрайт для фишек.
		private var firstPice:Piece; /// ссылка на первую кликнутую фишку
		private var isDroping:Boolean; //какие фишки нам надо анимировать в данный момент
		private var isSwapping:Boolean; //какие фишки нам надо анимировать в данный момент
		private var gameScore:int;
		
		
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
			
			startMatchThree();
		}
		
		private function startMatchThree():void 
		{
			_grid = new Array();
			for (var i:int = 0; i < 8; i++) 
			{
				_grid.push(new Array());
			}
			setUpGrid();
			isDroping = false;
			isSwapping = false;
			gameScore = 0;
			this.addEventListener(Event.ENTER_FRAME, movePieces);
		}
		
		private function setUpGrid():void 
		{
			//var check:Boolean = true;
			while (true) 
			{
				// Создаём спрайт
				gameSprite = new Sprite();
				for (var col:int = 0; col < MAP_SIZE; col++) 
				{
					for (var row:int = 0; row < MAP_SIZE; row++) 
					{
						addPiece(col, row);
					}
				}
				// Проверка на "3Вряд" на поле
				//if (lookForMatches().length != 0) continue;// check = false;
				// Проверка на возможность хода
				//if (lookForPossible() == false) continue;// check = false;
				break;
			}
			addChild (gameSprite);
		}
		
		// создаем рандомную фишку, добавляем ее в спрайт и сетку
		private function addPiece(col:int, row:int):void 
		{
			var newPiece:Piece = new Piece();
			newPiece.type = Math.ceil(Math.random() * 6);
			newPiece.x = col * SPACING + OFFSET_X;
			newPiece.y = row * SPACING + OFFSET_Y;
			newPiece.col = col;
			newPiece.row = row;
			gameSprite.addChild(newPiece);
			_grid[col][row] = newPiece;
			newPiece.addEventListener(TouchEvent.TOUCH, clickPiece);
			//newPiece.addEventListener(MouseEvent.CLICK,clickPiece);
			
			/// То что было в оригинале
			/*var newPiece:Piece = new Piece();
			newPiece.x = col * spacing + offsetX;
			newPiece.y = row * spacing + offsetY; 
			
			newPiece.col = col;  
			newPiece.row = row;
			newPiece.type = Math.cell(Math.random()*7);
			newPiece.gotoAndStop(newPiece.type);
			newPiece.select.visible = false;    
			gameSprite.addChild(newPiece);    
			grid[col][row] = newPiece;    
			newPiece.addEventListener(MouseEvent.CLICK,clickPiece);
			return newPiece;*/
		}
		
		private function clickPiece(e:TouchEvent):void 
		{
			var piece:Piece = Piece(e.currentTarget);
			var touches:Vector.<Touch> = e.getTouches(this, TouchPhase.ENDED);
			if (touches.length == 0) return;
			// клик на первой фишке
			if (firstPice == null)
			{
				firstPice = piece;
				piece.pieceSelect.visible = true;
			}
			// Клик на первой фишке повторно
			else if (firstPice == piece)
			{
				piece.pieceSelect.visible = false;
				firstPice = null;
			}
			// Клик на другой фишке
			else
			{
				firstPice.pieceSelect.visible = false;
				// Тотже ряд, проверяем соседство в колонке
				if ((firstPice.row == piece.row) && (Math.abs(firstPice.col - piece.col) == 1))
				{
					makeSwap(firstPice, piece);
					firstPice = null;
				}
				// таже колонка проверяем соседство в ряду
				else if ((firstPice.col = piece.col) && (Math.abs(firstPice.row - piece.row) == 1))
				{
					makeSwap(firstPice, piece);
					firstPice = null;
				}
				else
				{
					firstPice = piece;
					firstPice.pieceSelect.visible = true;
				}
			}
		}
		
		private function makeSwap(firstPice:Piece, secondPiece:Piece):void 
		{
			swapPieces(firstPice, secondPiece);
			
			// проверяем, был ли обмен удачным
			if (lookForMatches().length == 0)
			{
				swapPieces(firstPice, secondPiece);
			}
			else
			{
				isSwapping = true;
			}
		}
		
		// Обмен двух фишек
		private function swapPieces(firstPice:Piece, secondPiece:Piece):void 
		{
			// обмениваем значение row и col
			var tempCol:uint = firstPice.col;
			var tempRow:uint = firstPice.row;
			firstPice.col = secondPiece.col;
			firstPice.row = secondPiece.row;
			secondPiece.col = tempCol;
			secondPiece.row = tempRow;
			
			// измменяем позицию в сетке
			_grid[firstPice.col][firstPice.row] = firstPice;
			_grid[secondPiece.col][secondPiece.row] = secondPiece;
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
						// Смещаем вниз
						if (_grid[col][row].y < _grid[col][row].row * SPACING + OFFSET_Y)
						{
							_grid[col][row].y += 5;
							madeMove = true;
						}
						// Смещаем вверх
						if (_grid[col][row].y > _grid[col][row].row * SPACING + OFFSET_Y)
						{
							_grid[col][row].y += 5;
							madeMove = true;
						}
						// Смещаем вправо
						if (_grid[col][row].x < _grid[col][row].col * SPACING + OFFSET_X)
						{
							_grid[col][row].x += 5;
							madeMove = true;
						}
						// Смещаем влево
						if (_grid[col][row].x > _grid[col][row].col * SPACING + OFFSET_X)
						{
							_grid[col][row].x += 5;
							madeMove = true;
						}
					}
				}
			}
			// Все падения завершены
			if (isDroping && madeMove)
			{
				isDroping = false;
				findAndRemoveMatches();
			}
			// Все обмены завершены
			else if (isSwapping && madeMove)
			{
				isSwapping = false;
				findAndRemoveMatches();
			}
		}
		
		private function findAndRemoveMatches():void 
		{
			// Формируем список линий
			var matches:Array = lookForMatches();
			for (var i:int = 0; i < matches.length; i++) 
			{
				var numPoints:Number = (matches[i].length - 1) * 50;
				for (var j:int = 0; j < matches[i].length; j++)
				{
					if (gameSprite.contains(matches[i][j]))
					{
						var pb = new PointBurst(this, numPoints, matches[i][j].x, matches[i][j].y);
						addScore(numPoints);
						gameSprite.removeChild(matches[i][j]);
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
				if (!lookForPosibles()) endGames();				
			}
		}
		
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
		private function addNewPiece():void
		{
			for (var col:int = 0; col < 8; col++) 
			{
				var missingPieces:int = 0;
				for (var row:int = 7; row >=0; row--) 
				{
					if (_grid[col][row] == null)
					{
						var newPiece:Piece = addPiece(col, row);
						newPiece.y = OFFSET_Y - SPACING - SPACING * missingPieces++;
						isDroping = true;
					}
				}
			}
		}
		
		// Проверка на возможные ходы
		private function lookForPosibles():Boolean
		{
			for (var col:int = 0; col < 8; col++) 
			{
				for (var row:int = 0; row < 8; row++) 
				{
					// Возможно горизонтальная, две подряд
					if (matchPatern(col, row, [[1, 0]], [[ -2, 0], [ -1, -1], [ -1, 1], [2, -1], [2, 1], [3, 0]]))
					{
						return true;
					}
					// возможна горизонтальная, две по разным сторонам
					if (matchPatern(col, row, [[2, 0]], [[1, -1], [1, 1]] ))
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
		
		private function matchPatern(col:uint, row:uint, mustHave:Array, needOne:Array):void 
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
		
		private function matchType(col:int, row:int, type:int):Boolean 
		{
			if ((col<0) || (col>7)||(row<0)||(row>7)) return false;
			return (_grid[col][row].type == type);
		}
		
		private function addScore (numPoints:int):void
		{
			gameScore += numPoints;
			// TODO: Посмотреть как в голодном герое раелизована запись результата
		}
		
		
	}
}