package kabam.rotmg.core.commands
{
   import com.company.assembleegameclient.screens.LoadingScreen;
   import flash.display.Sprite;
   import io.decagames.rotmg.pets.tasks.GetOwnedPetSkinsTask;
   import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
   import io.decagames.rotmg.seasonalEvent.tasks.GetLegacySeasonsTask;
   import io.decagames.rotmg.seasonalEvent.tasks.GetSeasonalEventTask;
   import io.decagames.rotmg.supportCampaign.tasks.GetCampaignStatusTask;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.services.GetCharListTask;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.SetScreenSignal;
   import kabam.rotmg.dailyLogin.tasks.FetchPlayerCalendarTask;
   
   public class SetScreenWithValidDataCommand
   {
       
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var setScreen:SetScreenSignal;
      
      [Inject]
      public var view:Sprite;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      [Inject]
      public var task:GetCharListTask;
      
      [Inject]
      public var calendarTask:FetchPlayerCalendarTask;
      
      [Inject]
      public var campaignStatusTask:GetCampaignStatusTask;
      
      [Inject]
      public var petSkinsTask:GetOwnedPetSkinsTask;
      
      [Inject]
      public var getSeasonalEventTask:GetSeasonalEventTask;
      
      [Inject]
      public var getLegacySeasonsTask:GetLegacySeasonsTask;
      
      [Inject]
      public var seasonalEventModel:SeasonalEventModel;
      
      public function SetScreenWithValidDataCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         if(this.model.isInvalidated)
         {
            this.reloadDataThenSetScreen();
         }
         else
         {
            this.setScreen.dispatch(this.view);
         }
      }
      
      private function reloadDataThenSetScreen() : void
      {
         this.setScreen.dispatch(new LoadingScreen());
         var _loc1_:TaskSequence = new TaskSequence();
         _loc1_.add(this.task);
         _loc1_.add(this.calendarTask);
         _loc1_.add(this.petSkinsTask);
         _loc1_.add(this.campaignStatusTask);
         if(!this.seasonalEventModel.isChallenger)
         {
            _loc1_.add(this.getSeasonalEventTask);
         }
         _loc1_.add(new DispatchSignalTask(this.setScreen,this.view));
         this.monitor.add(_loc1_);
         _loc1_.start();
      }
   }
}
