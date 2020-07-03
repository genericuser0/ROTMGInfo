package io.decagames.rotmg.seasonalEvent.tasks
{
   import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import robotlegs.bender.framework.api.ILogger;
   
   public class GetSeasonalEventTask extends BaseTask
   {
       
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var model:SeasonalEventModel;
      
      public function GetSeasonalEventTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.logger.info("GetSeasonalEvent start");
         var _loc1_:Object = this.account.getCredentials();
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/season/getSeasons",_loc1_);
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.onSeasonalEvent(param2);
         }
         else
         {
            this.onTextError(param2);
         }
      }
      
      private function onTextError(param1:String) : void
      {
         this.logger.info("GetSeasonalEvent error");
         completeTask(true);
      }
      
      private function onSeasonalEvent(param1:String) : void
      {
         var xmlData:XML = null;
         var data:String = param1;
         try
         {
            xmlData = new XML(data);
         }
         catch(e:Error)
         {
            logger.error("Error parsing seasonal data: " + data);
            completeTask(true);
            return;
         }
         this.logger.info("GetSeasonalEvent update");
         this.logger.info(xmlData);
         this.model.parseConfigData(xmlData);
         completeTask(true);
      }
   }
}
