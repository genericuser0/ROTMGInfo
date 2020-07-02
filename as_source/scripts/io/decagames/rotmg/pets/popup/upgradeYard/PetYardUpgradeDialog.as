package io.decagames.rotmg.pets.popup.upgradeYard
{
   import com.company.assembleegameclient.util.Currency;
   import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
   import io.decagames.rotmg.shop.ShopBuyButton;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.labels.UILabel;
   import io.decagames.rotmg.ui.popups.modal.ModalPopup;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import io.decagames.rotmg.ui.texture.TextureParser;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class PetYardUpgradeDialog extends ModalPopup
   {
       
      
      private var _upgradeGoldButton:ShopBuyButton;
      
      private var _upgradeFameButton:ShopBuyButton;
      
      private var upgradeButtonsMargin:int = 20;
      
      public function PetYardUpgradeDialog(param1:PetRarityEnum, param2:int, param3:int)
      {
         var _loc4_:SliceScalingBitmap = null;
         var _loc5_:UILabel = null;
         var _loc6_:UILabel = null;
         super(270,0,"Upgrade Pet Yard");
         _loc4_ = TextureParser.instance.getSliceScalingBitmap("UI","petYard_" + LineBuilder.getLocalizedStringFromKey("{" + param1.rarityKey + "}"));
         _loc4_.x = Math.round((contentWidth - _loc4_.width) / 2);
         addChild(_loc4_);
         _loc5_ = new UILabel();
         DefaultLabelFormat.petYardUpgradeInfo(_loc5_);
         _loc5_.x = 50;
         _loc5_.y = _loc4_.height + 10;
         _loc5_.width = 170;
         _loc5_.wordWrap = true;
         _loc5_.text = LineBuilder.getLocalizedStringFromKey("YardUpgraderView.info");
         addChild(_loc5_);
         _loc6_ = new UILabel();
         DefaultLabelFormat.petYardUpgradeRarityInfo(_loc6_);
         _loc6_.y = _loc5_.y + _loc5_.textHeight + 8;
         _loc6_.width = contentWidth;
         _loc6_.wordWrap = true;
         _loc6_.text = LineBuilder.getLocalizedStringFromKey("{" + param1.rarityKey + "}");
         addChild(_loc6_);
         this._upgradeGoldButton = new ShopBuyButton(param2,Currency.GOLD);
         this._upgradeFameButton = new ShopBuyButton(param3,Currency.FAME);
         this._upgradeGoldButton.width = this._upgradeFameButton.width = 120;
         this._upgradeGoldButton.y = this._upgradeFameButton.y = _loc6_.y + _loc6_.height + 15;
         var _loc7_:int = (contentWidth - (this._upgradeGoldButton.width + this._upgradeFameButton.width + this.upgradeButtonsMargin)) / 2;
         this._upgradeGoldButton.x = _loc7_;
         this._upgradeFameButton.x = this._upgradeGoldButton.x + this._upgradeGoldButton.width + this.upgradeButtonsMargin;
         addChild(this._upgradeGoldButton);
         addChild(this._upgradeFameButton);
      }
      
      public function get upgradeGoldButton() : ShopBuyButton
      {
         return this._upgradeGoldButton;
      }
      
      public function get upgradeFameButton() : ShopBuyButton
      {
         return this._upgradeFameButton;
      }
   }
}
