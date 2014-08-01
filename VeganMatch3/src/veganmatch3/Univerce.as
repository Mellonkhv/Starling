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
		private const SPACING:Number = 5;
		private const OFFSET_X:Number = 10;
		private const OFFSET_Y:Number = 10;
		
		//=========================================
		// PUBLIC VARIABLE
		private var _board:Sprite;
		private var _pieces:Vector.<Sprite>; // фишки
		private var _grid:Array; // массив фишек
		private var gameSprite:Sprite /// непонял, разберёмся
		private var firstPice:Sprite /// ссылка на первую кликнутую фишку
		private var isDroping, isSwapping:Boolean; //какие фишки нам надо анимировать в данный момент
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
		private function init(e:Event):void 
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