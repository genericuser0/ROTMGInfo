package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   import kabam.rotmg.messaging.impl.data.CompressedInt;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class ShowEffect extends IncomingMessage
   {
      
      private static const EFFECT_BIT_COLOR:int = 1 << 0;
      
      private static const EFFECT_BIT_POS1_X:int = 1 << 1;
      
      private static const EFFECT_BIT_POS1_Y:int = 1 << 2;
      
      private static const EFFECT_BIT_POS2_X:int = 1 << 3;
      
      private static const EFFECT_BIT_POS2_Y:int = 1 << 4;
      
      private static const EFFECT_BIT_POS1:int = EFFECT_BIT_POS1_X | EFFECT_BIT_POS1_Y;
      
      private static const EFFECT_BIT_POS2:int = EFFECT_BIT_POS2_X | EFFECT_BIT_POS2_Y;
      
      private static const EFFECT_BIT_DURATION:int = 1 << 5;
      
      private static const EFFECT_BIT_ID:int = 1 << 6;
      
      public static const UNKNOWN_EFFECT_TYPE:int = 0;
      
      public static const HEAL_EFFECT_TYPE:int = 1;
      
      public static const TELEPORT_EFFECT_TYPE:int = 2;
      
      public static const STREAM_EFFECT_TYPE:int = 3;
      
      public static const THROW_EFFECT_TYPE:int = 4;
      
      public static const NOVA_EFFECT_TYPE:int = 5;
      
      public static const POISON_EFFECT_TYPE:int = 6;
      
      public static const LINE_EFFECT_TYPE:int = 7;
      
      public static const BURST_EFFECT_TYPE:int = 8;
      
      public static const FLOW_EFFECT_TYPE:int = 9;
      
      public static const RING_EFFECT_TYPE:int = 10;
      
      public static const LIGHTNING_EFFECT_TYPE:int = 11;
      
      public static const COLLAPSE_EFFECT_TYPE:int = 12;
      
      public static const CONEBLAST_EFFECT_TYPE:int = 13;
      
      public static const JITTER_EFFECT_TYPE:int = 14;
      
      public static const FLASH_EFFECT_TYPE:int = 15;
      
      public static const THROW_PROJECTILE_EFFECT_TYPE:int = 16;
      
      public static const SHOCKER_EFFECT_TYPE:int = 17;
      
      public static const SHOCKEE_EFFECT_TYPE:int = 18;
      
      public static const RISING_FURY_EFFECT_TYPE:int = 19;
      
      public static const NOVA_NO_AOE_EFFECT_TYPE:int = 20;
      
      public static const INSPIRED_EFFECT_TYPE:int = 21;
      
      public static const HOLY_BEAM_EFFECT_TYPE:int = 22;
      
      public static const CIRCLE_TELEGRAPH_EFFECT_TYPE:int = 23;
      
      public static const CHAOS_BEAM_EFFECT_TYPE:int = 24;
      
      public static const TELEPORT_MONSTER_EFFECT_TYPE:int = 25;
      
      public static const METEOR_EFFECT_TYPE:int = 26;
      
      public static const GILDED_BUFF_EFFECT_TYPE:int = 27;
      
      public static const JADE_BUFF_EFFECT_TYPE:int = 28;
      
      public static const CHAOS_BUFF_EFFECT_TYPE:int = 29;
      
      public static const THUNDER_BUFF_EFFECT_TYPE:int = 30;
      
      public static const STATUS_FLASH_EFFECT_TYPE:int = 31;
      
      public static const FIRE_ORB_BUFF_EFFECT_TYPE:int = 32;
       
      
      public var effectType_:uint;
      
      public var targetObjectId_:int;
      
      public var pos1_:WorldPosData;
      
      public var pos2_:WorldPosData;
      
      public var color_:int;
      
      public var duration_:Number;
      
      public function ShowEffect(param1:uint, param2:Function)
      {
         this.pos1_ = new WorldPosData();
         this.pos2_ = new WorldPosData();
         super(param1,param2);
      }
      
      override public function parseFromInput(param1:IDataInput) : void
      {
         this.effectType_ = param1.readUnsignedByte();
         var _loc2_:uint = param1.readUnsignedByte();
         if(_loc2_ & EFFECT_BIT_ID)
         {
            this.targetObjectId_ = CompressedInt.Read(param1);
         }
         else
         {
            this.targetObjectId_ = 0;
         }
         if(_loc2_ & EFFECT_BIT_POS1_X)
         {
            this.pos1_.x_ = param1.readFloat();
         }
         else
         {
            this.pos1_.x_ = 0;
         }
         if(_loc2_ & EFFECT_BIT_POS1_Y)
         {
            this.pos1_.y_ = param1.readFloat();
         }
         else
         {
            this.pos1_.y_ = 0;
         }
         if(_loc2_ & EFFECT_BIT_POS2_X)
         {
            this.pos2_.x_ = param1.readFloat();
         }
         else
         {
            this.pos2_.x_ = 0;
         }
         if(_loc2_ & EFFECT_BIT_POS2_Y)
         {
            this.pos2_.y_ = param1.readFloat();
         }
         else
         {
            this.pos2_.y_ = 0;
         }
         if(_loc2_ & EFFECT_BIT_COLOR)
         {
            this.color_ = param1.readInt();
         }
         else
         {
            this.color_ = 4294967295;
         }
         if(_loc2_ & EFFECT_BIT_DURATION)
         {
            this.duration_ = param1.readFloat();
         }
         else
         {
            this.duration_ = 1;
         }
      }
      
      override public function toString() : String
      {
         return formatToString("SHOW_EFFECT","effectType_","targetObjectId_","pos1_","pos2_","color_","duration_");
      }
   }
}
