package io.decagames.rotmg.pets.windows.yard.fuse
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.util.Currency;
   import flash.events.MouseEvent;
   import io.decagames.rotmg.pets.components.petItem.PetItem;
   import io.decagames.rotmg.pets.data.PetsModel;
   import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
   import io.decagames.rotmg.pets.data.vo.PetVO;
   import io.decagames.rotmg.pets.data.vo.requests.FusePetRequestVO;
   import io.decagames.rotmg.pets.signals.EvolvePetSignal;
   import io.decagames.rotmg.pets.signals.NewAbilitySignal;
   import io.decagames.rotmg.pets.signals.SelectFusePetSignal;
   import io.decagames.rotmg.pets.signals.SelectPetSignal;
   import io.decagames.rotmg.pets.signals.UpgradePetSignal;
   import io.decagames.rotmg.pets.utils.FeedFuseCostModel;
   import io.decagames.rotmg.pets.utils.FusionCalculator;
   import io.decagames.rotmg.pets.utils.PetItemFactory;
   import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
   import io.decagames.rotmg.shop.NotEnoughResources;
   import io.decagames.rotmg.ui.buttons.BaseButton;
   import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
   import io.decagames.rotmg.ui.popups.signals.RemoveLockFade;
   import io.decagames.rotmg.ui.popups.signals.ShowLockFade;
   import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.game.model.GameModel;
   import kabam.rotmg.messaging.impl.EvolvePetInfo;
   import kabam.rotmg.messaging.impl.PetUpgradeRequest;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class FuseTabMediator extends Mediator
   {
       
      
      [Inject]
      public var view:FuseTab;
      
      [Inject]
      public var model:PetsModel;
      
      [Inject]
      public var petIconFactory:PetItemFactory;
      
      [Inject]
      public var selectPetSignal:SelectPetSignal;
      
      [Inject]
      public var selectFusePetSignal:SelectFusePetSignal;
      
      [Inject]
      public var upgradePet:UpgradePetSignal;
      
      [Inject]
      public var showFade:ShowLockFade;
      
      [Inject]
      public var removeFade:RemoveLockFade;
      
      [Inject]
      public var newAbilityUnlocked:NewAbilitySignal;
      
      [Inject]
      public var evolvePetSignal:EvolvePetSignal;
      
      [Inject]
      public var showPopup:ShowPopupSignal;
      
      [Inject]
      public var gameModel:GameModel;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var seasonalEventModel:SeasonalEventModel;
      
      private var petsList:Vector.<PetItem>;
      
      private var currentSelectedPet:PetVO;
      
      private var fusePet:PetVO;
      
      public function FuseTabMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.petsList = new Vector.<PetItem>();
         this.renderFusePets(!!this.model.activeUIVO?this.model.activeUIVO:this.model.getActivePet());
         this.selectPetSignal.add(this.onPetSelected);
         this.toggleButtons(false);
         this.view.setStrengthPercentage(-1,this.currentSelectedPet && this.currentSelectedPet.rarity.ordinal == PetRarityEnum.DIVINE.ordinal);
         this.view.fuseFameButton.clickSignal.add(this.purchaseFame);
         this.view.fuseGoldButton.clickSignal.add(this.purchaseGold);
         this.view.displaySignal.add(this.showHideSignal);
      }
      
      override public function destroy() : void
      {
         this.clearGrid();
         this.view.fuseFameButton.clickSignal.remove(this.purchaseFame);
         this.view.fuseGoldButton.clickSignal.remove(this.purchaseGold);
         this.newAbilityUnlocked.remove(this.abilityUnlocked);
         this.evolvePetSignal.remove(this.evolvePetHandler);
         this.selectPetSignal.remove(this.onPetSelected);
         this.view.displaySignal.remove(this.showHideSignal);
      }
      
      private function showHideSignal(param1:Boolean) : void
      {
         var _loc2_:PetItem = null;
         if(!param1)
         {
            this.view.setStrengthPercentage(-1);
            this.toggleButtons(false);
            for each(_loc2_ in this.petsList)
            {
               _loc2_.selected = false;
            }
         }
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
      
      private function evolvePetHandler(param1:EvolvePetInfo) : void
      {
         this.evolvePetSignal.remove(this.evolvePetHandler);
         this.removeFade.dispatch();
         this.onPetSelected(null);
      }
      
      private function abilityUnlocked(param1:int) : void
      {
         this.newAbilityUnlocked.remove(this.abilityUnlocked);
         this.removeFade.dispatch();
         this.onPetSelected(this.currentSelectedPet);
      }
      
      private function purchase(param1:int, param2:int) : void
      {
         var _loc3_:FusePetRequestVO = null;
         if(this.checkYardType())
         {
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
            this.newAbilityUnlocked.add(this.abilityUnlocked);
            this.evolvePetSignal.add(this.evolvePetHandler);
            _loc3_ = new FusePetRequestVO(this.currentSelectedPet.getID(),this.fusePet.getID(),param1);
            this.showFade.dispatch();
            this.upgradePet.dispatch(_loc3_);
         }
      }
      
      private function purchaseFame(param1:BaseButton) : void
      {
         this.purchase(PetUpgradeRequest.FAME_PAYMENT_TYPE,this.view.fuseFameButton.price);
      }
      
      private function purchaseGold(param1:BaseButton) : void
      {
         this.purchase(PetUpgradeRequest.GOLD_PAYMENT_TYPE,this.view.fuseGoldButton.price);
      }
      
      private function checkYardType() : Boolean
      {
         if(this.currentSelectedPet.rarity.ordinal + 1 >= this.model.getPetYardType())
         {
            this.showPopup.dispatch(new ErrorModal(350,"Fuse Pets",LineBuilder.getLocalizedStringFromKey("server.upgrade_petyard_first")));
            return false;
         }
         return true;
      }
      
      private function onPetSelected(param1:PetVO) : void
      {
         this.clearGrid();
         this.renderFusePets(param1);
         this.toggleButtons(false);
         this.view.setStrengthPercentage(-1,param1 && param1.rarity.ordinal == PetRarityEnum.DIVINE.ordinal);
      }
      
      private function clearGrid() : void
      {
         var _loc1_:PetItem = null;
         for each(_loc1_ in this.petsList)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onFusePetSelected);
         }
         this.view.clearGrid();
      }
      
      private function renderFusePets(param1:PetVO) : void
      {
         var _loc2_:PetVO = null;
         var _loc3_:PetItem = null;
         if(param1 == null)
         {
            return;
         }
         this.currentSelectedPet = param1;
         if(param1.rarity.ordinal == PetRarityEnum.DIVINE.ordinal)
         {
            this.view.setStrengthPercentage(-1,param1.rarity.ordinal == PetRarityEnum.DIVINE.ordinal);
            return;
         }
         for each(_loc2_ in this.model.getAllPets(param1.family,param1.rarity))
         {
            if(_loc2_ != param1)
            {
               _loc3_ = this.petIconFactory.create(_loc2_,40,5526612,1);
               _loc3_.addEventListener(MouseEvent.CLICK,this.onFusePetSelected);
               this.petsList.push(_loc3_);
               this.view.addPet(_loc3_);
            }
         }
      }
      
      private function onFusePetSelected(param1:MouseEvent) : void
      {
         var _loc2_:PetItem = PetItem(param1.currentTarget);
         this.selectFusePetSignal.dispatch(_loc2_.getPetVO());
         this.selectPet(_loc2_);
         this.fusePet = _loc2_.getPetVO();
         this.toggleButtons(true);
         this.view.fuseFameButton.price = !!Boolean(this.seasonalEventModel.isChallenger)?0:int(FeedFuseCostModel.getFuseFameCost(this.currentSelectedPet.rarity));
         this.view.fuseGoldButton.price = !!Boolean(this.seasonalEventModel.isChallenger)?0:int(FeedFuseCostModel.getFuseGoldCost(this.currentSelectedPet.rarity));
         this.view.setStrengthPercentage(FusionCalculator.getStrengthPercentage(this.currentSelectedPet,_loc2_.getPetVO()),this.currentSelectedPet && this.currentSelectedPet.rarity.ordinal == PetRarityEnum.DIVINE.ordinal);
      }
      
      private function toggleButtons(param1:Boolean) : void
      {
         this.view.fuseGoldButton.disabled = !param1;
         this.view.fuseFameButton.disabled = !param1;
         this.view.fuseFameButton.alpha = !!param1?Number(1):Number(0);
         this.view.fuseGoldButton.alpha = !!param1?Number(1):Number(0);
      }
      
      private function selectPet(param1:PetItem) : void
      {
         var _loc2_:PetItem = null;
         for each(_loc2_ in this.petsList)
         {
            _loc2_.selected = _loc2_ == param1;
         }
      }
   }
}
