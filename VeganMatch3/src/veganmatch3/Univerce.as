package veganmatch3 
{
	import starling.display.Sprite;
	import starling.events.Event;
	
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
		private var gameSprite:Sprite // Спрайт для фишек.
		private var firstPice:Sprite /// ссылка на первую кликнутую фишку
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
		
		// TODO: 1.Создание случайно-генерируемого игрового поля.
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
			var newPiece:Piece = new Piece(Math.ceil(Math.random() * 6));
			newPiece.x = col * SPACING + OFFSET_X;
			newPiece.y = row * SPACING + OFFSET_Y;
			//newPiece.col = col;  
			//newPiece.row = row;
			gameSprite.addChild(newPiece);
			_grid[col][row] = newPiece;
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
		
		private function movePieces(e:Event):void 
		{
			
		}
		
		// TODO: 2.Проверка на линии.
		// TODO: 3.Проверка на возможность первого хода.
		// TODO: 4.Игрок выбирает 2 фишки.
		// TODO: 5.Фишки меняются местами
		// TODO: 6.Проверка на линии.
		// TODO: 7.При нахождении линии вознаграждаем игрока очками.
		// TODO: 8.Убираем линии с поля.
		// TODO: 9.Сдвигаем верхние фишки на место исчезнувших.
		// TODO: 10.Заполняем образовавшиеся пустоты.
		// TODO: 11.Снова проверяем на линии. Возвращаемся к пункту 6.
		// TODO: 12.Проверка на возможность хода.
	}

}