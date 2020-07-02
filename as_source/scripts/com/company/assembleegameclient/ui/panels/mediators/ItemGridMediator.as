package com.company.assembleegameclient.ui.panels.mediators
{
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.objects.Container;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.OneWayContainer;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.sound.SoundEffectLibrary;
   import com.company.assembleegameclient.ui.panels.itemgrids.ContainerGrid;
   import com.company.assembleegameclient.ui.panels.itemgrids.InventoryGrid;
   import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTileEvent;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import com.company.assembleegameclient.util.DisplayHierarchy;
   import flash.utils.getTimer;
   import io.decagames.rotmg.pets.data.PetsModel;
   import kabam.rotmg.chat.model.ChatMessage;
   import kabam.rotmg.constants.ItemConstants;
   import kabam.rotmg.core.model.MapModel;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.ShowTooltipSignal;
   import kabam.rotmg.game.model.PotionInventoryModel;
   import kabam.rotmg.game.signals.AddTextLineSignal;
   import kabam.rotmg.game.view.components.TabStripView;
   import kabam.rotmg.messaging.impl.GameServerConnection;
   import kabam.rotmg.ui.model.HUDModel;
   import kabam.rotmg.ui.model.TabStripModel;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class ItemGridMediator extends Mediator
   {
       
      
      [Inject]
      public var view:ItemGrid;
      
      [Inject]
      public var mapModel:MapModel;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var potionInventoryModel:PotionInventoryModel;
      
      [Inject]
      public var hudModel:HUDModel;
      
      [Inject]
      public var tabStripModel:TabStripModel;
      
      [Inject]
      public var showToolTip:ShowTooltipSignal;
      
      [Inject]
      public var petsModel:PetsModel;
      
      [Inject]
      public var addTextLine:AddTextLineSignal;
      
      public function ItemGridMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.addEventListener(ItemTileEvent.ITEM_MOVE,this.onTileMove);
         this.view.addEventListener(ItemTileEvent.ITEM_SHIFT_CLICK,this.onShiftClick);
         this.view.addEventListener(ItemTileEvent.ITEM_DOUBLE_CLICK,this.onDoubleClick);
         this.view.addEventListener(ItemTileEvent.ITEM_CTRL_CLICK,this.onCtrlClick);
         this.view.addToolTip.add(this.onAddToolTip);
      }
      
      private function onAddToolTip(param1:ToolTip) : void
      {
         this.showToolTip.dispatch(param1);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      private function onTileMove(param1:ItemTileEvent) : void
      {
         var _loc4_:InteractiveItemTile = null;
         var _loc5_:TabStripView = null;
         var _loc6_:int = 0;
         var _loc2_:InteractiveItemTile = param1.tile;
         if(this.swapTooSoon())
         {
            _loc2_.resetItemPosition();
            return;
         }
         var _loc3_:* = DisplayHierarchy.getParentWithTypeArray(_loc2_.getDropTarget(),TabStripView,InteractiveItemTile,Map);
         if(_loc2_.getItemId() == PotionInventoryModel.HEALTH_POTION_ID || _loc2_.getItemId() == PotionInventoryModel.MAGIC_POTION_ID)
         {
            this.onPotionMove(param1);
            return;
         }
         if(_loc3_ is InteractiveItemTile)
         {
            _loc4_ = _loc3_ as InteractiveItemTile;
            if(this.view.curPlayer.lockedSlot[_loc4_.tileId] == 0)
            {
               if(this.canSwapItems(_loc2_,_loc4_))
               {
                  this.swapItemTiles(_loc2_,_loc4_);
               }
            }
            else
            {
               this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,"You cannot put items into this slot right now."));
            }
         }
         else if(_loc3_ is TabStripView)
         {
            _loc5_ = _loc3_ as TabStripView;
            _loc6_ = _loc2_.ownerGrid.curPlayer.nextAvailableInventorySlot();
            if(_loc6_ != -1)
            {
               GameServerConnection.instance.invSwap(this.view.curPlayer,_loc2_.ownerGrid.owner,_loc2_.tileId,_loc2_.itemSprite.itemId,this.view.curPlayer,_loc6_,ItemConstants.NO_ITEM);
               _loc2_.setItem(ItemConstants.NO_ITEM);
               _loc2_.updateUseability(this.view.curPlayer);
            }
         }
         else if(_loc3_ is Map || this.hudModel.gameSprite.map.mouseX < 300)
         {
            this.dropItem(_loc2_);
         }
         _loc2_.resetItemPosition();
      }
      
      private function petFoodCancel(param1:InteractiveItemTile) : Function
      {
         var itemSlot:InteractiveItemTile = param1;
         return function():void
         {
            itemSlot.blockingItemUpdates = false;
         };
      }
      
      private function onPotionMove(param1:ItemTileEvent) : void
      {
         var _loc2_:InteractiveItemTile = param1.tile;
         var _loc3_:* = DisplayHierarchy.getParentWithTypeArray(_loc2_.getDropTarget(),TabStripView,Map);
         if(_loc3_ is TabStripView)
         {
            this.addToPotionStack(_loc2_);
         }
         else if(_loc3_ is Map || this.hudModel.gameSprite.map.mouseX < 300)
         {
            this.dropItem(_loc2_);
         }
         _loc2_.resetItemPosition();
      }
      
      private function addToPotionStack(param1:InteractiveItemTile) : void
      {
         if(!GameServerConnection.instance || !this.view.interactive || !param1 || this.potionInventoryModel.getPotionModel(param1.getItemId()).maxPotionCount <= this.hudModel.gameSprite.map.player_.getPotionCount(param1.getItemId()))
         {
            return;
         }
         GameServerConnection.instance.invSwapPotion(this.view.curPlayer,this.view.owner,param1.tileId,param1.itemSprite.itemId,this.view.curPlayer,PotionInventoryModel.getPotionSlot(param1.getItemId()),ItemConstants.NO_ITEM);
         param1.setItem(ItemConstants.NO_ITEM);
         param1.updateUseability(this.view.curPlayer);
      }
      
      private function canSwapItems(param1:InteractiveItemTile, param2:InteractiveItemTile) : Boolean
      {
         if(!param1.canHoldItem(param2.getItemId()))
         {
            return false;
         }
         if(!param2.canHoldItem(param1.getItemId()))
         {
            return false;
         }
         if(ItemGrid(param2.parent).owner is OneWayContainer)
         {
            return false;
         }
         if(param1.blockingItemUpdates || param2.blockingItemUpdates)
         {
            return false;
         }
         return true;
      }
      
      private function dropItem(param1:InteractiveItemTile) : void
      {
         var _loc5_:Container = null;
         var _loc6_:Vector.<int> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Boolean = ObjectLibrary.isSoulbound(param1.itemSprite.itemId);
         var _loc3_:Boolean = ObjectLibrary.isDropTradable(param1.itemSprite.itemId);
         var _loc4_:Container = this.view.owner as Container;
         if(this.view.owner == this.view.curPlayer || _loc4_ && _loc4_.ownerId_ == this.view.curPlayer.accountId_ && !_loc2_)
         {
            _loc5_ = this.mapModel.currentInteractiveTarget as Container;
            if(_loc5_ && !(!_loc5_.canHaveSoulbound_ && !_loc3_ || _loc5_.canHaveSoulbound_ && _loc5_.isLoot_ && _loc3_))
            {
               _loc6_ = _loc5_.equipment_;
               _loc7_ = _loc6_.length;
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  if(_loc6_[_loc8_] < 0)
                  {
                     break;
                  }
                  _loc8_++;
               }
               if(_loc8_ < _loc7_)
               {
                  this.dropWithoutDestTile(param1,_loc5_,_loc8_);
               }
               else
               {
                  GameServerConnection.instance.invDrop(this.view.owner,param1.tileId,param1.getItemId());
               }
            }
            else
            {
               GameServerConnection.instance.invDrop(this.view.owner,param1.tileId,param1.getItemId());
            }
         }
         else if(_loc4_.canHaveSoulbound_ && _loc4_.isLoot_ && _loc3_)
         {
            GameServerConnection.instance.invDrop(this.view.owner,param1.tileId,param1.getItemId());
         }
         param1.setItem(-1);
      }
      
      private function swapItemTiles(param1:ItemTile, param2:ItemTile) : Boolean
      {
         if(!GameServerConnection.instance || !this.view.interactive || !param1 || !param2)
         {
            return false;
         }
         GameServerConnection.instance.invSwap(this.view.curPlayer,this.view.owner,param1.tileId,param1.itemSprite.itemId,param2.ownerGrid.owner,param2.tileId,param2.itemSprite.itemId);
         var _loc3_:int = param1.getItemId();
         param1.setItem(param2.getItemId());
         param2.setItem(_loc3_);
         param1.updateUseability(this.view.curPlayer);
         param2.updateUseability(this.view.curPlayer);
         return true;
      }
      
      private function dropWithoutDestTile(param1:ItemTile, param2:Container, param3:int) : void
      {
         if(!GameServerConnection.instance || !this.view.interactive || !param1 || !param2)
         {
            return;
         }
         GameServerConnection.instance.invSwap(this.view.curPlayer,this.view.owner,param1.tileId,param1.itemSprite.itemId,param2,param3,-1);
         param1.setItem(ItemConstants.NO_ITEM);
      }
      
      private function onShiftClick(param1:ItemTileEvent) : void
      {
         var _loc2_:InteractiveItemTile = param1.tile;
         if(_loc2_.ownerGrid is InventoryGrid || _loc2_.ownerGrid is ContainerGrid)
         {
            GameServerConnection.instance.useItem_new(_loc2_.ownerGrid.owner,_loc2_.tileId);
         }
      }
      
      private function onCtrlClick(param1:ItemTileEvent) : void
      {
         var _loc2_:InteractiveItemTile = null;
         var _loc3_:int = 0;
         if(this.swapTooSoon())
         {
            return;
         }
         if(Parameters.data_.inventorySwap)
         {
            _loc2_ = param1.tile;
            if(_loc2_.ownerGrid is InventoryGrid)
            {
               _loc3_ = _loc2_.ownerGrid.curPlayer.swapInventoryIndex(this.tabStripModel.currentSelection);
               if(_loc3_ != -1)
               {
                  GameServerConnection.instance.invSwap(this.view.curPlayer,_loc2_.ownerGrid.owner,_loc2_.tileId,_loc2_.itemSprite.itemId,this.view.curPlayer,_loc3_,ItemConstants.NO_ITEM);
                  _loc2_.setItem(ItemConstants.NO_ITEM);
                  _loc2_.updateUseability(this.view.curPlayer);
               }
            }
         }
      }
      
      private function onDoubleClick(param1:ItemTileEvent) : void
      {
         if(this.swapTooSoon())
         {
            return;
         }
         var _loc2_:InteractiveItemTile = param1.tile;
         if(this.isStackablePotion(_loc2_))
         {
            this.addToPotionStack(_loc2_);
         }
         else if(_loc2_.ownerGrid is ContainerGrid)
         {
            this.equipOrUseContainer(_loc2_);
         }
         else
         {
            this.equipOrUseInventory(_loc2_);
         }
         this.view.refreshTooltip();
      }
      
      private function isStackablePotion(param1:InteractiveItemTile) : Boolean
      {
         return param1.getItemId() == PotionInventoryModel.HEALTH_POTION_ID || param1.getItemId() == PotionInventoryModel.MAGIC_POTION_ID;
      }
      
      private function pickUpItem(param1:InteractiveItemTile) : void
      {
         var _loc2_:int = this.view.curPlayer.nextAvailableInventorySlot();
         if(_loc2_ != -1)
         {
            GameServerConnection.instance.invSwap(this.view.curPlayer,this.view.owner,param1.tileId,param1.itemSprite.itemId,this.view.curPlayer,_loc2_,ItemConstants.NO_ITEM);
         }
      }
      
      private function equipOrUseContainer(param1:InteractiveItemTile) : void
      {
         var _loc2_:GameObject = param1.ownerGrid.owner;
         var _loc3_:Player = this.view.curPlayer;
         var _loc4_:int = this.view.curPlayer.nextAvailableInventorySlot();
         if(_loc4_ != -1)
         {
            GameServerConnection.instance.invSwap(_loc3_,this.view.owner,param1.tileId,param1.itemSprite.itemId,this.view.curPlayer,_loc4_,ItemConstants.NO_ITEM);
         }
         else
         {
            GameServerConnection.instance.useItem_new(_loc2_,param1.tileId);
         }
      }
      
      private function equipOrUseInventory(param1:InteractiveItemTile) : void
      {
         var _loc2_:GameObject = param1.ownerGrid.owner;
         var _loc3_:Player = this.view.curPlayer;
         var _loc4_:int = ObjectLibrary.getMatchingSlotIndex(param1.getItemId(),_loc3_);
         if(_loc4_ != -1)
         {
            GameServerConnection.instance.invSwap(_loc3_,_loc2_,param1.tileId,param1.getItemId(),_loc3_,_loc4_,_loc3_.equipment_[_loc4_]);
         }
         else
         {
            GameServerConnection.instance.useItem_new(_loc2_,param1.tileId);
         }
      }
      
      private function swapTooSoon() : Boolean
      {
         var _loc1_:int = getTimer();
         if(this.view.curPlayer.lastSwap_ + 600 > _loc1_)
         {
            SoundEffectLibrary.play("error");
            return true;
         }
         this.view.curPlayer.lastSwap_ = _loc1_;
         return false;
      }
   }
}
