package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import engine.StateManager;
	import funkin.states.TitleState;
	
	/**
	 * ...
	 * @author YoPhlox
	 */
	public class Main extends Sprite 
	{
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			if (hasEventListener(Event.ADDED_TO_STAGE))
				removeEventListener(Event.ADDED_TO_STAGE, init);				
			trace("Main class initialized!");
			
			addChild(StateManager.Instance);
			StateManager.Instance.switchState(TitleState);
			trace("Switching to the TitleState!");
		}
		
	}
	
}