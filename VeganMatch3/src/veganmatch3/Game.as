package veganmatch3
{
	import starling.events.Event;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Mellonkhv
	 */
	public class Game extends Sprite
	{
		//=========================================
		// PRIVATE VARIABLE
		private var _universe:Univerce;
		//private var _world:VVorld;
		//private var _gameBourd:GameBoard;
		
		//=========================================
		// CONSTRUCTOR
		public function Game()
		{
			super();
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//=========================================
		// PRIVATE FUNCTION
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_universe = Universe.getInstance();
			addChild(_universe);
			//_world = new VVorld();
			//addChild(_world);
			//_gameBourd = new GameBoard();
			//addChild(_gameBourd);
		}
	}

}