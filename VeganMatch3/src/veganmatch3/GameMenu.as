import veganmatch3.Game;
package veganmatch3  
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
		// PRIVATE VARIABLE
		private var _game:Game;
		//=========================================
		// CONSTRUCTOR
		public function GameMenu() 
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
			
		}
		
	}

}