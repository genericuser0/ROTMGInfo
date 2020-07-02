package io.decagames.rotmg.dailyQuests.view.info
{
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import io.decagames.rotmg.dailyQuests.model.DailyQuest;
   import io.decagames.rotmg.dailyQuests.model.DailyQuestsModel;
   import io.decagames.rotmg.dailyQuests.signal.LockQuestScreenSignal;
   import io.decagames.rotmg.dailyQuests.signal.SelectedItemSlotsSignal;
   import io.decagames.rotmg.dailyQuests.signal.ShowQuestInfoSignal;
   import io.decagames.rotmg.dailyQuests.view.list.DailyQuestsList;
   import io.decagames.rotmg.dailyQuests.view.popup.DailyQuestExpiredPopup;
   import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
   import kabam.rotmg.core.signals.HideTooltipsSignal;
   import kabam.rotmg.core.signals.ShowTooltipSignal;
   import kabam.rotmg.dailyLogin.model.DailyLoginModel;
   import kabam.rotmg.game.view.components.BackpackTabContent;
   import kabam.rotmg.game.view.components.InventoryTabContent;
   import kabam.rotmg.messaging.impl.data.SlotObjectData;
   import kabam.rotmg.tooltips.HoverTooltipDelegate;
   import kabam.rotmg.ui.model.HUDModel;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class DailyQuestInfoMediator extends Mediator
   {
       
      
      [Inject]
      public var showInfoSignal:ShowQuestInfoSignal;
      
      [Inject]
      public var view:DailyQuestInfo;
      
      [Inject]
      public var model:DailyQuestsModel;
      
      [Inject]
      public var hud:HUDModel;
      
      [Inject]
      public var lockScreen:LockQuestScreenSignal;
      
      [Inject]
      public var selectedItemSlotsSignal:SelectedItemSlotsSignal;
      
      [Inject]
      public var showTooltipSignal:ShowTooltipSignal;
      
      [Inject]
      public var hideTooltipsSignal:HideTooltipsSignal;
      
      [Inject]
      public var dailyLoginModel:DailyLoginModel;
      
      [Inject]
      public var showPopupSignal:ShowPopupSignal;
      
      private var tooltip:TextToolTip;
      
      private var hoverTooltipDelegate:HoverTooltipDelegate;
      
      public function DailyQuestInfoMediator()
      {
         this.hoverTooltipDelegate = new HoverTooltipDelegate();
         super();
      }
      
      override public function initialize() : void
      {
         this.showInfoSignal.add(this.showQuestInfo);
         this.tooltip = new TextToolTip(3552822,10197915,"","You must select a reward first!",190,null);
         this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipsSignal);
         this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
         this.hoverTooltipDelegate.tooltip = this.tooltip;
         this.view.completeButton.addEventListener(MouseEvent.CLICK,this.onCompleteButtonClickHandler);
         this.selectedItemSlotsSignal.add(this.itemSelectedHandler);
      }
      
      private function itemSelectedHandler(param1:int) : void
      {
         this.view.completeButton.disabled = !!this.model.currentQuest.completed?true:this.model.selectedItem == -1?true:!DailyQuestInfo.hasAllItems(this.model.currentQuest.requirements,this.model.playerItemsFromInventory);
         if(this.model.selectedItem == -1)
         {
            this.hoverTooltipDelegate.setDisplayObject(this.view.completeButton);
         }
         else
         {
            this.hoverTooltipDelegate.removeDisplayObject();
         }
      }
      
      override public function destroy() : void
      {
         this.view.completeButton.removeEventListener(MouseEvent.CLICK,this.onCompleteButtonClickHandler);
         this.showInfoSignal.remove(this.showQuestInfo);
         this.selectedItemSlotsSignal.remove(this.itemSelectedHandler);
      }
      
      private function showQuestInfo(param1:String, param2:int, param3:String) : void
      {
         if(param1 != "" && param2 != -1)
         {
            this.setupQuestInfo(param1);
            if(this.view.hasEventListener(Event.ENTER_FRAME))
            {
               this.view.removeEventListener(Event.ENTER_FRAME,this.updateQuestAvailable);
            }
         }
         else if(param3 == DailyQuestsList.QUEST_TAB_LABEL)
         {
            this.view.dailyQuestsCompleted();
            this.view.addEventListener(Event.ENTER_FRAME,this.updateQuestAvailable);
         }
         else
         {
            this.view.eventQuestsCompleted();
         }
      }
      
      private function updateQuestAvailable(param1:Event) : void
      {
         var _loc2_:String = "New quests available in " + this.dailyLoginModel.getFormatedQuestRefreshTime();
         this.view.setQuestAvailableTime(_loc2_);
      }
      
      private function setupQuestInfo(param1:String) : void
      {
         this.model.selectedItem = -1;
         this.view.dailyQuestsCompleted();
         this.model.currentQuest = this.model.getQuestById(param1);
         this.view.show(this.model.currentQuest,this.model.playerItemsFromInventory);
         if(!this.view.completeButton.completed && this.model.currentQuest.itemOfChoice)
         {
            this.view.completeButton.disabled = true;
            this.hoverTooltipDelegate.setDisplayObject(this.view.completeButton);
         }
      }
      
      private function tileToSlot(param1:InventoryTile) : SlotObjectData
      {
         var _loc2_:SlotObjectData = new SlotObjectData();
         _loc2_.objectId_ = param1.ownerGrid.owner.objectId_;
         _loc2_.objectType_ = param1.getItemId();
         _loc2_.slotId_ = param1.tileId;
         return _loc2_;
      }
      
      private function onCompleteButtonClickHandler(param1:MouseEvent) : void
      {
         if(this.checkIfQuestHasExpired())
         {
            this.showPopupSignal.dispatch(new DailyQuestExpiredPopup());
         }
         else
         {
            this.completeQuest();
         }
      }
      
      private function completeQuest() : void
      {
         var _loc1_:Vector.<SlotObjectData> = null;
         var _loc2_:BackpackTabContent = null;
         var _loc3_:InventoryTabContent = null;
         var _loc4_:Vector.<int> = null;
         var _loc5_:Vector.<InventoryTile> = null;
         var _loc6_:int = 0;
         var _loc7_:InventoryTile = null;
         if(!this.view.completeButton.disabled && !this.view.completeButton.completed)
         {
            _loc1_ = new Vector.<SlotObjectData>();
            _loc2_ = this.hud.gameSprite.hudView.tabStrip.getTabView(BackpackTabContent);
            _loc3_ = this.hud.gameSprite.hudView.tabStrip.getTabView(InventoryTabContent);
            _loc4_ = this.model.currentQuest.requirements.concat();
            _loc5_ = new Vector.<InventoryTile>();
            if(_loc2_)
            {
               _loc5_ = _loc5_.concat(_loc2_.backpack.tiles);
            }
            if(_loc3_)
            {
               _loc5_ = _loc5_.concat(_loc3_.storage.tiles);
            }
            for each(_loc6_ in _loc4_)
            {
               for each(_loc7_ in _loc5_)
               {
                  if(_loc7_.getItemId() == _loc6_)
                  {
                     _loc5_.splice(_loc5_.indexOf(_loc7_),1);
                     _loc1_.push(this.tileToSlot(_loc7_));
                     break;
                  }
               }
            }
            this.lockScreen.dispatch();
            this.hud.gameSprite.gsc_.questRedeem(this.model.currentQuest.id,_loc1_,this.model.selectedItem);
            if(!this.model.currentQuest.repeatable)
            {
               this.model.currentQuest.completed = true;
            }
            this.view.completeButton.completed = true;
            this.view.completeButton.disabled = true;
         }
      }
      
      private function checkIfQuestHasExpired() : Boolean
      {
         var _loc3_:* = false;
         var _loc1_:DailyQuest = this.model.currentQuest;
         var _loc2_:Date = new Date();
         if(_loc1_.expiration != "")
         {
            _loc3_ = Number(_loc1_.expiration) - _loc2_.time / 1000 < 0;
         }
         return _loc3_;
      }
   }
}
