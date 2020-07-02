package io.decagames.rotmg.dailyQuests.view.popup
{
   import flash.text.TextFormatAlign;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.labels.UILabel;
   import io.decagames.rotmg.ui.popups.modal.ModalPopup;
   
   public class DailyQuestRefreshPopup extends ModalPopup
   {
       
      
      private const TITLE:String = "Refresh Daily Quests";
      
      private const TEXT:String = "Do you want to refresh your Daily Quests? All Daily Quests will be refreshed!";
      
      private const WIDTH:int = 300;
      
      private const HEIGHT:int = 100;
      
      private var _refreshPrice:int;
      
      private var _buyQuestRefreshButton:BuyQuestRefreshButton;
      
      public function DailyQuestRefreshPopup(param1:int)
      {
         super(this.WIDTH,this.HEIGHT,this.TITLE);
         this._refreshPrice = param1;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:UILabel = new UILabel();
         _loc1_.width = 280;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.text = this.TEXT;
         DefaultLabelFormat.defaultSmallPopupTitle(_loc1_,TextFormatAlign.CENTER);
         _loc1_.x = (this.WIDTH - _loc1_.width) / 2;
         _loc1_.y = 10;
         addChild(_loc1_);
         this._buyQuestRefreshButton = new BuyQuestRefreshButton(this._refreshPrice);
         this._buyQuestRefreshButton.x = (this.WIDTH - this._buyQuestRefreshButton.width) / 2;
         this._buyQuestRefreshButton.y = 60;
         addChild(this._buyQuestRefreshButton);
      }
      
      public function get buyQuestRefreshButton() : BuyQuestRefreshButton
      {
         return this._buyQuestRefreshButton;
      }
   }
}
