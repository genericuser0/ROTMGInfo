package com.company.assembleegameclient.ui.panels.itemgrids
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.EquipmentTile;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
   import com.company.assembleegameclient.util.EquipmentUtil;
   import com.company.util.ArrayIterator;
   import com.company.util.IIterator;
   import kabam.lib.util.VectorAS3Util;
   
   public class EquippedGrid extends ItemGrid
   {
       
      
      private var tiles:Vector.<EquipmentTile>;
      
      private var _invTypes:Vector.<int>;
      
      public function EquippedGrid(param1:GameObject, param2:Vector.<int>, param3:Player, param4:int = 0)
      {
         super(param1,param3,param4);
         this._invTypes = param2;
         this.init();
      }
      
      private function init() : void
      {
         var _loc3_:EquipmentTile = null;
         var _loc1_:int = EquipmentUtil.NUM_SLOTS;
         this.tiles = new Vector.<EquipmentTile>(_loc1_);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = new EquipmentTile(_loc2_,this,interactive);
            addToGrid(_loc3_,1,_loc2_);
            _loc3_.setType(this._invTypes[_loc2_]);
            this.tiles[_loc2_] = _loc3_;
            _loc2_++;
         }
      }
      
      public function createInteractiveItemTileIterator() : IIterator
      {
         return new ArrayIterator(VectorAS3Util.toArray(this.tiles));
      }
      
      override public function setItems(param1:Vector.<int>, param2:int = 0) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc3_:int = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < this.tiles.length)
         {
            if(_loc4_ + param2 < _loc3_)
            {
               this.tiles[_loc4_].setItem(param1[_loc4_ + param2]);
            }
            else
            {
               this.tiles[_loc4_].setItem(-1);
            }
            this.tiles[_loc4_].updateDim(curPlayer);
            _loc4_++;
         }
      }
      
      public function toggleTierTags(param1:Boolean) : void
      {
         var _loc2_:ItemTile = null;
         for each(_loc2_ in this.tiles)
         {
            _loc2_.toggleTierTag(param1);
         }
      }
   }
}
