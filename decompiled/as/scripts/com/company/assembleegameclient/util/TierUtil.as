package com.company.assembleegameclient.util
{
   import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.labels.UILabel;
   
   public class TierUtil
   {
       
      
      public function TierUtil()
      {
         super();
      }
      
      public static function getTierTag(param1:XML, param2:int = 12) : UILabel
      {
         var _loc9_:UILabel = null;
         var _loc10_:Number = NaN;
         var _loc11_:String = null;
         var _loc3_:* = isPet(param1) == false;
         var _loc4_:* = param1.hasOwnProperty("Consumable") == false;
         var _loc5_:* = param1.hasOwnProperty("InvUse") == false;
         var _loc6_:* = param1.hasOwnProperty("Treasure") == false;
         var _loc7_:* = param1.hasOwnProperty("PetFood") == false;
         var _loc8_:Boolean = param1.hasOwnProperty("Tier");
         if(_loc3_ && _loc4_ && _loc5_ && _loc6_ && _loc7_)
         {
            _loc9_ = new UILabel();
            if(_loc8_)
            {
               _loc10_ = 16777215;
               _loc11_ = "T" + param1.Tier;
            }
            else if(param1.hasOwnProperty("@setType"))
            {
               _loc10_ = TooltipHelper.SET_COLOR;
               _loc11_ = "ST";
            }
            else
            {
               _loc10_ = TooltipHelper.UNTIERED_COLOR;
               _loc11_ = "UT";
            }
            _loc9_.text = _loc11_;
            DefaultLabelFormat.tierLevelLabel(_loc9_,param2,_loc10_);
            return _loc9_;
         }
         return null;
      }
      
      public static function isPet(param1:XML) : Boolean
      {
         var activateTags:XMLList = null;
         var itemDataXML:XML = param1;
         activateTags = itemDataXML.Activate.(text() == "PermaPet");
         return activateTags.length() >= 1;
      }
   }
}
