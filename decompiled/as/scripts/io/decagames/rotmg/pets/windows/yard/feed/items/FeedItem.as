package io.decagames.rotmg.pets.windows.yard.feed.items
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import io.decagames.rotmg.ui.gird.UIGridElement;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.text.view.BitmapTextFactory;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   
   public class FeedItem extends UIGridElement
   {
       
      
      private var _item:InventoryTile;
      
      private var imageBitmap:Bitmap;
      
      private var _feedPower:int;
      
      private var _selected:Boolean;
      
      public function FeedItem(param1:InventoryTile)
      {
         super();
         this._item = param1;
         this.renderBackground(4539717,0.25);
         this.renderItem();
      }
      
      private function renderBackground(param1:uint, param2:Number) : void
      {
         graphics.clear();
         graphics.beginFill(param1,param2);
         graphics.drawRect(0,0,40,40);
      }
      
      private function renderItem() : void
      {
         var _loc4_:XML = null;
         var _loc5_:BitmapData = null;
         var _loc6_:Matrix = null;
         this.imageBitmap = new Bitmap();
         var _loc1_:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this._item.getItemId(),40,true);
         _loc1_ = _loc1_.clone();
         var _loc2_:XML = ObjectLibrary.xmlLibrary_[this._item.getItemId()];
         this._feedPower = _loc2_.feedPower;
         if(ObjectLibrary.usePatchedData)
         {
            _loc4_ = ObjectLibrary.xmlPatchLibrary_[this._item.getItemId()];
            if(_loc4_.hasOwnProperty("feedPower"))
            {
               this._feedPower = _loc4_.feedPower;
            }
         }
         var _loc3_:BitmapTextFactory = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
         if(_loc2_ && _loc2_.hasOwnProperty("Quantity") && _loc3_)
         {
            _loc5_ = _loc3_.make(new StaticStringBuilder(String(_loc2_.Quantity)),12,16777215,false,new Matrix(),true);
            _loc6_ = new Matrix();
            _loc6_.translate(8,7);
            _loc1_.draw(_loc5_,_loc6_);
         }
         this.imageBitmap.bitmapData = _loc1_;
         addChild(this.imageBitmap);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.imageBitmap.bitmapData.dispose();
      }
      
      public function get itemId() : int
      {
         return this._item.getItemId();
      }
      
      public function get feedPower() : int
      {
         return this._feedPower;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         if(param1)
         {
            this.renderBackground(15306295,1);
         }
         else
         {
            this.renderBackground(4539717,0.25);
         }
      }
      
      public function get item() : InventoryTile
      {
         return this._item;
      }
   }
}
