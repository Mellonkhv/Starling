package  
{
	import starling.events.Event;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Mellonkhv
	 */
	public class GameMenu extends Sprite 
	{
		//=========================================
		// CONSTRUCTOR
		public function GameMenu() 
		{
			super();
			
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
	}

}