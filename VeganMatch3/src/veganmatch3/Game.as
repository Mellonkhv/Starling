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
			_universe = new Univerce();
			addChild(_universe);
		}
	}

}