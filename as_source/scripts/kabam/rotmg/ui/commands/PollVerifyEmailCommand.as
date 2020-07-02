package kabam.rotmg.ui.commands
{
   import com.company.util.MoreObjectUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   
   public class PollVerifyEmailCommand
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var closeDialog:CloseDialogsSignal;
      
      private var _pollTimer:Timer;
      
      private var _params:Object;
      
      private var _aeClient:AppEngineClient;
      
      public function PollVerifyEmailCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this._aeClient = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
         this._params = {};
         MoreObjectUtil.addToObject(this._params,this.account.getCredentials());
         this.setupTimer();
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         var _loc3_:XML = new XML(param2);
         var _loc4_:* = _loc3_ == "True";
         if(param1 && _loc4_)
         {
            this._pollTimer.stop();
            this.removeTimerListeners();
            this.account.verify(_loc4_);
            this.closeDialog.dispatch();
         }
      }
      
      private function setupTimer() : void
      {
         this._pollTimer = new Timer(30000,10);
         this._pollTimer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._pollTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this._pollTimer.start();
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         this.removeTimerListeners();
      }
      
      private function removeTimerListeners() : void
      {
         this._pollTimer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this._pollTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this._aeClient.complete.addOnce(this.onComplete);
         this._aeClient.sendRequest("account/isEmailVerified",this._params);
      }
   }
}
