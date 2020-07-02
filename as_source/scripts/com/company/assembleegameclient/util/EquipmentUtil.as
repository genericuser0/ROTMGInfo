package com.company.assembleegameclient.util
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import kabam.rotmg.constants.ItemConstants;
   
   public class EquipmentUtil
   {
      
      public static const NUM_SLOTS:uint = 4;
       
      
      public function EquipmentUtil()
      {
         super();
      }
      
      public static function getEquipmentBackground(param1:int, param2:Number = 1.0) : Bitmap
      {
         var _loc3_:Bitmap = null;
         var _loc4_:BitmapData = ItemConstants.itemTypeToBaseSprite(param1);
         if(_loc4_ != null)
         {
            _loc3_ = new Bitmap(_loc4_);
            _loc3_.scaleX = param2;
            _loc3_.scaleY = param2;
         }
         return _loc3_;
      }
   }
}
