package io.decagames.rotmg.supportCampaign.tab.donate.popup
{
   import flash.text.TextFormatAlign;
   import io.decagames.rotmg.shop.ShopBuyButton;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.labels.UILabel;
   import io.decagames.rotmg.ui.popups.modal.ModalPopup;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import io.decagames.rotmg.ui.texture.TextureParser;
   
   public class DonateConfirmationPopup extends ModalPopup
   {
       
      
      private var _donateButton:ShopBuyButton;
      
      private var supportIcon:SliceScalingBitmap;
      
      private var _gold:int;
      
      public function DonateConfirmationPopup(param1:int, param2:int)
      {
         var _loc6_:SliceScalingBitmap = null;
         super(240,130,"Boost");
         this._gold = param1;
         var _loc3_:UILabel = new UILabel();
         _loc3_.text = "You will receive:";
         DefaultLabelFormat.createLabelFormat(_loc3_,14,10066329,TextFormatAlign.CENTER,false);
         _loc3_.wordWrap = true;
         _loc3_.width = _contentWidth;
         _loc3_.y = 5;
         addChild(_loc3_);
         this.supportIcon = TextureParser.instance.getSliceScalingBitmap("UI","campaign_Points");
         addChild(this.supportIcon);
         var _loc4_:UILabel = new UILabel();
         _loc4_.text = param2.toString();
         DefaultLabelFormat.createLabelFormat(_loc4_,22,15585539,TextFormatAlign.CENTER,true);
         _loc4_.x = _contentWidth / 2 - _loc4_.width / 2 - 10;
         _loc4_.y = 25;
         addChild(_loc4_);
         this.supportIcon.y = _loc4_.y + 3;
         this.supportIcon.x = _loc4_.x + _loc4_.width;
         var _loc5_:UILabel = new UILabel();
         _loc5_.text = "Bonus Points";
         DefaultLabelFormat.createLabelFormat(_loc5_,14,10066329,TextFormatAlign.CENTER,false);
         _loc5_.wordWrap = true;
         _loc5_.width = _contentWidth;
         _loc5_.y = 50;
         addChild(_loc5_);
         _loc6_ = new TextureParser().getSliceScalingBitmap("UI","main_button_decoration",148);
         addChild(_loc6_);
         this._donateButton = new ShopBuyButton(param1);
         this._donateButton.width = _loc6_.width - 45;
         addChild(this._donateButton);
         _loc6_.y = _contentHeight - 50;
         _loc6_.x = Math.round((_contentWidth - _loc6_.width) / 2);
         this._donateButton.y = _loc6_.y + 6;
         this._donateButton.x = _loc6_.x + 22;
      }
      
      public function get donateButton() : ShopBuyButton
      {
         return this._donateButton;
      }
      
      public function get gold() : int
      {
         return this._gold;
      }
   }
}
