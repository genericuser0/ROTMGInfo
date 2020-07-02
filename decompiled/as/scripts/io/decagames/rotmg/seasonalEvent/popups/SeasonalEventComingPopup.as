package io.decagames.rotmg.seasonalEvent.popups
{
   import flash.text.TextFieldAutoSize;
   import io.decagames.rotmg.ui.buttons.SliceScalingButton;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.labels.UILabel;
   import io.decagames.rotmg.ui.popups.modal.ModalPopup;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import io.decagames.rotmg.ui.texture.TextureParser;
   import io.decagames.rotmg.utils.date.TimeLeft;
   
   public class SeasonalEventComingPopup extends ModalPopup
   {
       
      
      private const WIDTH:int = 330;
      
      private const HEIGHT:int = 100;
      
      private var _okButton:SliceScalingButton;
      
      private var _scheduledDate:Date;
      
      public function SeasonalEventComingPopup(param1:Date)
      {
         var _loc2_:SliceScalingBitmap = null;
         super(this.WIDTH,this.HEIGHT,"Seasonal Event coming!",DefaultLabelFormat.defaultSmallPopupTitle);
         this._scheduledDate = param1;
         _loc2_ = new TextureParser().getSliceScalingBitmap("UI","main_button_decoration",186);
         addChild(_loc2_);
         _loc2_.y = 40;
         _loc2_.x = Math.round((this.WIDTH - _loc2_.width) / 2);
         this._okButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
         this._okButton.setLabel("OK",DefaultLabelFormat.questButtonCompleteLabel);
         this._okButton.width = 130;
         this._okButton.x = Math.round((this.WIDTH - 130) / 2);
         this._okButton.y = 46;
         addChild(this._okButton);
         var _loc3_:String = TimeLeft.getStartTimeString(param1);
         var _loc4_:UILabel = new UILabel();
         DefaultLabelFormat.defaultSmallPopupTitle(_loc4_);
         _loc4_.width = this.WIDTH;
         _loc4_.autoSize = TextFieldAutoSize.CENTER;
         _loc4_.text = "Seasonal Event starting in: " + _loc3_;
         _loc4_.y = 10;
         addChild(_loc4_);
      }
      
      public function get okButton() : SliceScalingButton
      {
         return this._okButton;
      }
   }
}
