package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
   import com.company.assembleegameclient.util.FilterUtil;
   import com.company.assembleegameclient.util.TierUtil;
   import com.company.util.GraphicsUtil;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import io.decagames.rotmg.ui.labels.UILabel;
   import kabam.rotmg.constants.ItemConstants;
   
   public class ItemTile extends Sprite
   {
      
      public static const WIDTH:int = 40;
      
      public static const HEIGHT:int = 40;
      
      public static const BORDER:int = 4;
       
      
      public var itemSprite:ItemTileSprite;
      
      public var tileId:int;
      
      public var ownerGrid:ItemGrid;
      
      public var blockingItemUpdates:Boolean;
      
      private var fill_:GraphicsSolidFill;
      
      private var path_:GraphicsPath;
      
      private var graphicsData_:Vector.<IGraphicsData>;
      
      private var restrictedUseIndicator:Shape;
      
      private var tierText:UILabel;
      
      private var itemContainer:Sprite;
      
      private var tagContainer:Sprite;
      
      private var isItemUsable:Boolean;
      
      public function ItemTile(param1:int, param2:ItemGrid)
      {
         this.fill_ = new GraphicsSolidFill(this.getBackgroundColor(),1);
         this.path_ = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
         this.graphicsData_ = new <IGraphicsData>[this.fill_,this.path_,GraphicsUtil.END_FILL];
         super();
         this.tileId = param1;
         this.ownerGrid = param2;
         this.init();
      }
      
      private function init() : void
      {
         this.restrictedUseIndicator = new Shape();
         addChild(this.restrictedUseIndicator);
         this.setItemSprite(new ItemTileSprite());
      }
      
      public function drawBackground(param1:Array) : void
      {
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,param1,this.path_);
         graphics.clear();
         graphics.drawGraphicsData(this.graphicsData_);
         var _loc2_:GraphicsSolidFill = new GraphicsSolidFill(6036765,1);
         GraphicsUtil.clearPath(this.path_);
         var _loc3_:Vector.<IGraphicsData> = new <IGraphicsData>[_loc2_,this.path_,GraphicsUtil.END_FILL];
         GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,param1,this.path_);
         this.restrictedUseIndicator.graphics.drawGraphicsData(_loc3_);
         this.restrictedUseIndicator.cacheAsBitmap = true;
         this.restrictedUseIndicator.visible = false;
      }
      
      public function setItem(param1:int) : Boolean
      {
         if(param1 == this.itemSprite.itemId)
         {
            return false;
         }
         if(this.blockingItemUpdates)
         {
            return true;
         }
         this.itemSprite.setType(param1);
         this.setTierTag();
         this.updateUseability(this.ownerGrid.curPlayer);
         return true;
      }
      
      public function setItemSprite(param1:ItemTileSprite) : void
      {
         if(!this.itemContainer)
         {
            this.itemContainer = new Sprite();
            addChild(this.itemContainer);
         }
         this.itemSprite = param1;
         this.itemSprite.x = WIDTH / 2;
         this.itemSprite.y = HEIGHT / 2;
         this.itemContainer.addChild(this.itemSprite);
      }
      
      public function updateUseability(param1:Player) : void
      {
         var _loc2_:int = this.itemSprite.itemId;
         if(this.itemSprite.itemId != ItemConstants.NO_ITEM)
         {
            this.restrictedUseIndicator.visible = !ObjectLibrary.isUsableByPlayer(_loc2_,param1);
         }
         else
         {
            this.restrictedUseIndicator.visible = false;
         }
      }
      
      public function canHoldItem(param1:int) : Boolean
      {
         return true;
      }
      
      public function resetItemPosition() : void
      {
         this.setItemSprite(this.itemSprite);
      }
      
      public function getItemId() : int
      {
         return this.itemSprite.itemId;
      }
      
      protected function getBackgroundColor() : int
      {
         return 5526612;
      }
      
      public function setTierTag() : void
      {
         this.clearTierTag();
         var _loc1_:XML = ObjectLibrary.xmlLibrary_[this.itemSprite.itemId];
         if(_loc1_)
         {
            this.tierText = TierUtil.getTierTag(_loc1_);
            if(this.tierText)
            {
               if(!this.tagContainer)
               {
                  this.tagContainer = new Sprite();
                  addChild(this.tagContainer);
               }
               this.tierText.filters = FilterUtil.getTextOutlineFilter();
               this.tierText.x = WIDTH - this.tierText.width;
               this.tierText.y = HEIGHT / 2 + 5;
               this.toggleTierTag(Parameters.data_.showTierTag);
               this.tagContainer.addChild(this.tierText);
            }
         }
      }
      
      private function clearTierTag() : void
      {
         if(this.tierText && this.tagContainer && this.tagContainer.contains(this.tierText))
         {
            this.tagContainer.removeChild(this.tierText);
            this.tierText = null;
         }
      }
      
      public function toggleTierTag(param1:Boolean) : void
      {
         if(this.tierText)
         {
            this.tierText.visible = param1;
         }
      }
      
      protected function toggleDragState(param1:Boolean) : void
      {
         if(this.tierText && Parameters.data_.showTierTag)
         {
            this.tierText.visible = param1;
         }
         if(!this.isItemUsable && !param1)
         {
            this.restrictedUseIndicator.visible = param1;
         }
      }
   }
}
