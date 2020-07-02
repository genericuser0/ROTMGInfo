package io.decagames.rotmg.pets.popup.upgradeYard
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.util.Currency;
   import io.decagames.rotmg.pets.data.PetsModel;
   import io.decagames.rotmg.pets.data.vo.requests.UpgradePetYardRequestVO;
   import io.decagames.rotmg.pets.signals.UpgradePetSignal;
   import io.decagames.rotmg.shop.NotEnoughResources;
   import io.decagames.rotmg.ui.buttons.BaseButton;
   import io.decagames.rotmg.ui.buttons.SliceScalingButton;
   import io.decagames.rotmg.ui.popups.header.PopupHeader;
   import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
   import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
   import io.decagames.rotmg.ui.texture.TextureParser;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.game.model.GameModel;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class PetYardUpgradeDialogMediator extends Mediator
   {
       
      
      [Inject]
      public var view:PetYardUpgradeDialog;
      
      [Inject]
      public var closePopupSignal:ClosePopupSignal;
      
      private var closeButton:SliceScalingButton;
      
      [Inject]
      public var gameModel:GameModel;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var showDialog:ShowPopupSignal;
      
      [Inject]
      public var model:PetsModel;
      
      [Inject]
      public var upgradePet:UpgradePetSignal;
      
      public function PetYardUpgradeDialogMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","close_button"));
         this.closeButton.clickSignal.addOnce(this.onClose);
         this.view.header.addButton(this.closeButton,PopupHeader.RIGHT_BUTTON);
         this.view.upgradeFameButton.clickSignal.add(this.onFamePurchase);
         this.view.upgradeGoldButton.clickSignal.add(this.onGoldPurchase);
      }
      
      override public function destroy() : void
      {
         this.closeButton.clickSignal.remove(this.onClose);
         this.closeButton.dispose();
         this.view.upgradeFameButton.clickSignal.remove(this.onFamePurchase);
         this.view.upgradeGoldButton.clickSignal.remove(this.onGoldPurchase);
      }
      
      private function onClose(param1:BaseButton) : void
      {
         this.closePopupSignal.dispatch(this.view);
      }
      
      private function onFamePurchase(param1:BaseButton) : void
      {
         this.purchase(Currency.FAME,this.model.getPetYardUpgradeFamePrice());
      }
      
      private function onGoldPurchase(param1:BaseButton) : void
      {
         this.purchase(Currency.GOLD,this.model.getPetYardUpgradeGoldPrice());
      }
      
      private function purchase(param1:int, param2:int) : void
      {
         if(param1 == Currency.GOLD && this.currentGold < param2)
         {
            this.showDialog.dispatch(new NotEnoughResources(300,Currency.GOLD));
            return;
         }
         if(param1 == Currency.FAME && this.currentFame < param2)
         {
            this.showDialog.dispatch(new NotEnoughResources(300,Currency.FAME));
            return;
         }
         var _loc3_:int = this.model.getPetYardObjectID();
         var _loc4_:UpgradePetYardRequestVO = new UpgradePetYardRequestVO(_loc3_,param1);
         this.closePopupSignal.dispatch(this.view);
         this.upgradePet.dispatch(_loc4_);
      }
      
      private function get currentGold() : int
      {
         var _loc1_:Player = this.gameModel.player;
         if(_loc1_ != null)
         {
            return _loc1_.credits_;
         }
         if(this.playerModel != null)
         {
            return this.playerModel.getCredits();
         }
         return 0;
      }
      
      private function get currentFame() : int
      {
         var _loc1_:Player = this.gameModel.player;
         if(_loc1_ != null)
         {
            return _loc1_.fame_;
         }
         if(this.playerModel != null)
         {
            return this.playerModel.getFame();
         }
         return 0;
      }
   }
}
