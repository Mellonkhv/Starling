package veganmatch3 
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Mellonkhv
	 */
	public class VVorld extends Sprite 
	{
		
		public function VVorld() 
		{
			super();
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
	}

}