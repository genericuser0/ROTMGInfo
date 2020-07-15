package kabam.rotmg.messaging.impl.data
{
   import flash.utils.IDataInput;
   
   public class CompressedInt
   {
       
      
      public function CompressedInt()
      {
         super();
      }
      
      public static function Read(param1:IDataInput) : int
      {
         var _loc2_:* = 0;
         var _loc3_:int = param1.readUnsignedByte();
         var _loc4_:* = (_loc3_ & 64) != 0;
         var _loc5_:int = 6;
         _loc2_ = _loc3_ & 63;
         while(_loc3_ & 128)
         {
            _loc3_ = param1.readUnsignedByte();
            _loc2_ = _loc2_ | (_loc3_ & 127) << _loc5_;
            _loc5_ = _loc5_ + 7;
         }
         if(_loc4_)
         {
            _loc2_ = int(-_loc2_);
         }
         return _loc2_;
      }
   }
}
