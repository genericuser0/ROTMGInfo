package com.company.assembleegameclient.ui.panels.itemgrids
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
   
   public class InventoryGrid extends ItemGrid
   {
       
      
      private const NUM_SLOTS:uint = 8;
      
      private var _tiles:Vector.<InventoryTile>;
      
      private var isBackpack:Boolean;
      
      public function InventoryGrid(param1:GameObject, param2:Player, param3:int = 0, param4:Boolean = false)
      {
         var _loc6_:InventoryTile = null;
         super(param1,param2,param3);
         this._tiles = new Vector.<InventoryTile>(this.NUM_SLOTS);
         this.isBackpack = param4;
         var _loc5_:int = 0;
         while(_loc5_ < this.NUM_SLOTS)
         {
            _loc6_ = new InventoryTile(_loc5_ + indexOffset,this,interactive);
            _loc6_.addTileNumber(_loc5_ + 1);
            addToGrid(_loc6_,2,_loc5_);
            this._tiles[_loc5_] = _loc6_;
            _loc5_++;
         }
      }
      
      public function getItemById(param1:int) : InventoryTile
      {
         var _loc2_:InventoryTile = null;
         for each(_loc2_ in this._tiles)
         {
            if(_loc2_.getItemId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      override public function setItems(param1:Vector.<int>, param2:int = 0) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1)
         {
            _loc3_ = false;
            _loc4_ = param1.length;
            _loc5_ = 0;
            while(_loc5_ < this.NUM_SLOTS)
            {
               if(_loc5_ + indexOffset < _loc4_)
               {
                  if(this._tiles[_loc5_].setItem(param1[_loc5_ + indexOffset]))
                  {
                     _loc3_ = true;
                  }
               }
               else if(this._tiles[_loc5_].setItem(-1))
               {
                  _loc3_ = true;
               }
               _loc5_++;
            }
            if(_loc3_)
            {
               refreshTooltip();
            }
         }
      }
      
      public function get tiles() : Vector.<InventoryTile>
      {
         return this._tiles.concat();
      }
      
      public function toggleTierTags(param1:Boolean) : void
      {
         var _loc2_:ItemTile = null;
         for each(_loc2_ in this._tiles)
         {
            _loc2_.toggleTierTag(param1);
         }
      }
   }
}
