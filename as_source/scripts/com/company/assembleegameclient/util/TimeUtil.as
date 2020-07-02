package com.company.assembleegameclient.util
{
   public class TimeUtil
   {
      
      public static const DAY_IN_MS:int = 86400000;
      
      public static const DAY_IN_S:int = 86400;
      
      public static const HOUR_IN_S:int = 3600;
      
      public static const MIN_IN_S:int = 60;
       
      
      public function TimeUtil()
      {
         super();
      }
      
      public static function secondsToDays(param1:Number) : Number
      {
         return param1 / DAY_IN_S;
      }
      
      public static function secondsToHours(param1:Number) : Number
      {
         return param1 / HOUR_IN_S;
      }
      
      public static function secondsToMins(param1:Number) : Number
      {
         return param1 / MIN_IN_S;
      }
      
      public static function parseUTCDate(param1:String) : Date
      {
         var _loc2_:Array = param1.match(/(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d)/);
         var _loc3_:Date = new Date();
         _loc3_.setUTCFullYear(int(_loc2_[1]),int(_loc2_[2]) - 1,int(_loc2_[3]));
         _loc3_.setUTCHours(int(_loc2_[4]),int(_loc2_[5]),int(_loc2_[6]),0);
         return _loc3_;
      }
      
      public static function humanReadableTime(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc6_ = param1 >= 0?int(param1):0;
         _loc3_ = _loc6_ / DAY_IN_S;
         _loc6_ = _loc6_ % DAY_IN_S;
         _loc4_ = _loc6_ / HOUR_IN_S;
         _loc6_ = _loc6_ % HOUR_IN_S;
         _loc5_ = _loc6_ / MIN_IN_S;
         _loc2_ = _getReadableTime(param1,_loc3_,_loc4_,_loc5_);
         return _loc2_;
      }
      
      private static function _getReadableTime(param1:int, param2:int, param3:int, param4:int) : String
      {
         var _loc5_:String = null;
         if(param1 >= DAY_IN_S)
         {
            if(param3 == 0 && param4 == 0)
            {
               _loc5_ = param2.toString() + (param2 > 1?"days":"day");
               return _loc5_;
            }
            if(param4 == 0)
            {
               _loc5_ = param2.toString() + (param2 > 1?" days":" day");
               _loc5_ = _loc5_ + (", " + param3.toString() + (param3 > 1?" hours":" hour"));
               return _loc5_;
            }
            _loc5_ = param2.toString() + (param2 > 1?" days":" day");
            _loc5_ = _loc5_ + (", " + param3.toString() + (param3 > 1?" hours":" hour"));
            _loc5_ = _loc5_ + (" and " + param4.toString() + (param4 > 1?" minutes":" minute"));
            return _loc5_;
         }
         if(param1 >= HOUR_IN_S)
         {
            if(param4 == 0)
            {
               _loc5_ = param3.toString() + (param3 > 1?" hours":" hour");
               return _loc5_;
            }
            _loc5_ = param3.toString() + (param3 > 1?" hours":" hour");
            _loc5_ = _loc5_ + (" and " + param4.toString() + (param4 > 1?" minutes":" minute"));
            return _loc5_;
         }
         _loc5_ = param4.toString() + (param4 > 1?" minutes":" minute");
         return _loc5_;
      }
   }
}
