package io.decagames.rotmg.dailyQuests.utils
{
   import flash.display.Sprite;
   import io.decagames.rotmg.dailyQuests.data.DailyQuestItemSlotType;
   import io.decagames.rotmg.dailyQuests.view.slot.DailyQuestItemSlot;
   
   public class SlotsRendered
   {
       
      
      public function SlotsRendered()
      {
         super();
      }
      
      public static function renderSlots(param1:Vector.<int>, param2:Vector.<int>, param3:String, param4:Sprite, param5:int, param6:int, param7:int, param8:Vector.<DailyQuestItemSlot>, param9:Boolean = false) : void
      {
         var _loc11_:int = 0;
         var _loc18_:Sprite = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:DailyQuestItemSlot = null;
         var _loc10_:int = 0;
         _loc11_ = 4;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Boolean = false;
         var _loc16_:Sprite = new Sprite();
         var _loc17_:Sprite = new Sprite();
         _loc18_ = _loc16_;
         param4.addChild(_loc16_);
         param4.addChild(_loc17_);
         _loc17_.y = DailyQuestItemSlot.SLOT_SIZE + param6;
         for each(_loc19_ in param1)
         {
            if(!_loc15_)
            {
               _loc13_++;
            }
            else
            {
               _loc14_++;
            }
            _loc22_ = param2.indexOf(_loc19_);
            if(_loc22_ >= 0)
            {
               param2.splice(_loc22_,1);
            }
            _loc23_ = new DailyQuestItemSlot(_loc19_,param3,param3 == DailyQuestItemSlotType.REWARD?false:_loc22_ >= 0,param9);
            _loc23_.x = _loc10_ * (DailyQuestItemSlot.SLOT_SIZE + param6);
            _loc18_.addChild(_loc23_);
            param8.push(_loc23_);
            _loc10_++;
            if(_loc10_ >= _loc11_)
            {
               _loc18_ = _loc17_;
               _loc10_ = 0;
               _loc15_ = true;
            }
         }
         _loc20_ = _loc13_ * DailyQuestItemSlot.SLOT_SIZE + (_loc13_ - 1) * param6;
         _loc21_ = _loc14_ * DailyQuestItemSlot.SLOT_SIZE + (_loc14_ - 1) * param6;
         param4.y = param5;
         if(!_loc15_)
         {
            param4.y = param4.y + Math.round(DailyQuestItemSlot.SLOT_SIZE / 2 + param6 / 2);
         }
         _loc16_.x = Math.round((param7 - _loc20_) / 2);
         _loc17_.x = Math.round((param7 - _loc21_) / 2);
      }
   }
}
