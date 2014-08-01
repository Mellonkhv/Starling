package veganmatch3 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Mellonkhv
	 */
	public class Main extends Sprite 
	{
		//=========================================
		// CONSTRUCTOR
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//=========================================
		// PRIVATE FUNCTION
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var staling:Starling = new Starling(Game, stage);
			staling.start();
		}
		
	}
	
}