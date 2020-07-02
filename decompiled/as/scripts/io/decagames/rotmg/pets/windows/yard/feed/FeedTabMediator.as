package io.decagames.rotmg.pets.windows.yard.feed
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
   import com.company.assembleegameclient.util.Currency;
   import io.decagames.rotmg.pets.data.PetsModel;
   import io.decagames.rotmg.pets.data.vo.PetVO;
   import io.decagames.rotmg.pets.data.vo.requests.FeedPetRequestVO;
   import io.decagames.rotmg.pets.signals.SelectFeedItemSignal;
   import io.decagames.rotmg.pets.signals.SelectPetSignal;
   import io.decagames.rotmg.pets.signals.SimulateFeedSignal;
   import io.decagames.rotmg.pets.signals.UpgradePetSignal;
   import io.decagames.rotmg.pets.utils.FeedFuseCostModel;
   import io.decagames.rotmg.pets.windows.yard.feed.items.FeedItem;
   import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
   import io.decagames.rotmg.shop.NotEnoughResources;
   import io.decagames.rotmg.ui.buttons.BaseButton;
   import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
   import io.decagames.rotmg.ui.popups.signals.RemoveLockFade;
   import io.decagames.rotmg.ui.popups.signals.ShowLockFade;
   import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.game.model.GameModel;
   import kabam.rotmg.game.view.components.InventoryTabContent;
   import kabam.rotmg.messaging.impl.PetUpgradeRequest;
   import kabam.rotmg.messaging.impl.data.SlotObjectData;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.ui.model.HUDModel;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class FeedTabMediator extends Mediator
   {
       
      
      [Inject]
      public var view:FeedTab;
      
      [Inject]
      public var hud:HUDModel;
      
      [Inject]
      public var model:PetsModel;
      
      [Inject]
      public var selectFeedItemSignal:SelectFeedItemSignal;
      
      [Inject]
      public var selectPetSignal:SelectPetSignal;
      
      [Inject]
      public var gameModel:GameModel;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var showPopup:ShowPopupSignal;
      
      [Inject]
      public var upgradePet:UpgradePetSignal;
      
      [Inject]
      public var showFade:ShowLockFade;
      
      [Inject]
      public var removeFade:RemoveLockFade;
      
      [Inject]
      public var simulateFeed:SimulateFeedSignal;
      
      [Inject]
      public var seasonalEventModel:SeasonalEventModel;
      
      private var currentPet:PetVO;
      
      private var items:Vector.<FeedItem>;
      
      public function FeedTabMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.currentPet = !!this.model.activeUIVO?this.model.activeUIVO:this.model.getActivePet();
         this.selectPetSignal.add(this.onPetSelected);
         this.items = new Vector.<FeedItem>();
         this.selectFeedItemSignal.add(this.refreshFeedPower);
         this.view.feedGoldButton.clickSignal.add(this.purchaseGold);
         this.view.feedFameButton.clickSignal.add(this.purchaseFame);
         this.view.displaySignal.add(this.showHideSignal);
         this.renderItems();
         this.refreshFeedPower();
      }
      
      override public function destroy() : void
      {
         this.items = new Vector.<FeedItem>();
         this.selectFeedItemSignal.remove(this.refreshFeedPower);
         this.selectPetSignal.remove(this.onPetSelected);
         this.view.feedGoldButton.clickSignal.remove(this.purchaseGold);
         this.view.feedFameButton.clickSignal.remove(this.purchaseFame);
         this.view.displaySignal.remove(this.showHideSignal);
      }
      
      private function showHideSignal(param1:Boolean) : void
      {
         var _loc2_:FeedItem = null;
         if(!param1)
         {
            for each(_loc2_ in this.items)
            {
               _loc2_.selected = false;
            }
            this.refreshFeedPower();
         }
      }
      
      private function renderItems() : void
      {
         var _loc3_:InventoryTile = null;
         var _loc4_:int = 0;
         var _loc5_:FeedItem = null;
         this.view.clearGrid();
         this.items = new Vector.<FeedItem>();
         var _loc1_:InventoryTabContent = this.hud.gameSprite.hudView.tabStrip.getTabView(InventoryTabContent);
         var _loc2_:Vector.<InventoryTile> = new Vector.<InventoryTile>();
         if(_loc1_)
         {
            _loc2_ = _loc2_.concat(_loc1_.storage.tiles);
         }
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.getItemId();
            if(_loc4_ != -1 && this.hasFeedPower(_loc4_))
            {
               _loc5_ = new FeedItem(_loc3_);
               this.items.push(_loc5_);
               this.view.addItem(_loc5_);
            }
         }
      }
      
      private function refreshFeedPower() : void
      {
         var _loc3_:FeedItem = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         for each(_loc3_ in this.items)
         {
            if(_loc3_.selected)
            {
               _loc1_ = _loc1_ + _loc3_.feedPower;
               _loc2_++;
            }
         }
         if(this.currentPet)
         {
            this.view.feedGoldButton.price = !!Boolean(this.seasonalEventModel.isChallenger)?0:int(FeedFuseCostModel.getFeedGoldCost(this.currentPet.rarity) * _loc2_);
            this.view.feedFameButton.price = !!Boolean(this.seasonalEventModel.isChallenger)?0:int(FeedFuseCostModel.getFeedFameCost(this.currentPet.rarity) * _loc2_);
            this.view.updateFeedPower(_loc1_,this.currentPet.maxedAvailableAbilities());
         }
         else
         {
            this.view.feedGoldButton.price = 0;
            this.view.feedFameButton.price = 0;
            this.view.updateFeedPower(0,false);
         }
         this.simulateFeed.dispatch(_loc1_);
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
      
      private function hasFeedPower(param1:int) : Boolean
      {
         var _loc3_:XML = null;
         var _loc2_:XML = ObjectLibrary.xmlLibrary_[param1];
         if(ObjectLibrary.usePatchedData)
         {
            _loc3_ = ObjectLibrary.xmlPatchLibrary_[param1];
            if(_loc3_ && _loc3_.hasOwnProperty("feedPower"))
            {
               return true;
            }
         }
         return _loc2_.hasOwnProperty("feedPower");
      }
      
      private function purchaseFame(param1:BaseButton) : void
      {
         this.purchase(PetUpgradeRequest.FAME_PAYMENT_TYPE,this.view.feedFameButton.price);
      }
      
      private function purchaseGold(param1:BaseButton) : void
      {
         this.purchase(PetUpgradeRequest.GOLD_PAYMENT_TYPE,this.view.feedGoldButton.price);
      }
      
      private function purchase(param1:int, param2:int) : void
      {
         var _loc4_:FeedItem = null;
         var _loc5_:FeedPetRequestVO = null;
         var _loc6_:SlotObjectData = null;
         if(!this.checkYardType())
         {
            return;
         }
         if(param1 == PetUpgradeRequest.GOLD_PAYMENT_TYPE && this.currentGold < param2)
         {
            this.showPopup.dispatch(new NotEnoughResources(300,Currency.GOLD));
            return;
         }
         if(param1 == PetUpgradeRequest.FAME_PAYMENT_TYPE && this.currentFame < param2)
         {
            this.showPopup.dispatch(new NotEnoughResources(300,Currency.FAME));
            return;
         }
         var _loc3_:Vector.<SlotObjectData> = new Vector.<SlotObjectData>();
         for each(_loc4_ in this.items)
         {
            if(_loc4_.selected)
            {
               _loc6_ = new SlotObjectData();
               _loc6_.objectId_ = _loc4_.item.ownerGrid.owner.objectId_;
               _loc6_.objectType_ = _loc4_.item.getItemId();
               _loc6_.slotId_ = _loc4_.item.tileId;
               _loc3_.push(_loc6_);
            }
         }
         this.currentPet.abilityUpdated.addOnce(this.abilityUpdated);
         this.showFade.dispatch();
         _loc5_ = new FeedPetRequestVO(this.currentPet.getID(),_loc3_,param1);
         this.upgradePet.dispatch(_loc5_);
      }
      
      private function abilityUpdated() : void
      {
         var _loc1_:FeedItem = null;
         this.removeFade.dispatch();
         this.renderItems();
         for each(_loc1_ in this.items)
         {
            _loc1_.selected = false;
         }
         this.refreshFeedPower();
      }
      
      private function onPetSelected(param1:PetVO) : void
      {
         var _loc2_:FeedItem = null;
         this.currentPet = param1;
         for each(_loc2_ in this.items)
         {
            _loc2_.selected = false;
         }
         this.refreshFeedPower();
      }
      
      private function checkYardType() : Boolean
      {
         if(this.currentPet.rarity.ordinal >= this.model.getPetYardType())
         {
            this.showPopup.dispatch(new ErrorModal(350,"Feed Pets",LineBuilder.getLocalizedStringFromKey("server.upgrade_petyard_first")));
            return false;
         }
         return true;
      }
   }
}
