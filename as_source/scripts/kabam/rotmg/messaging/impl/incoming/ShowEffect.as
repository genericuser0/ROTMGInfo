package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class ShowEffect extends IncomingMessage
   {
      
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
         this.targetObjectId_ = param1.readInt();
         this.pos1_.parseFromInput(param1);
         this.pos2_.parseFromInput(param1);
         this.color_ = param1.readInt();
         this.duration_ = param1.readFloat();
      }
      
      override public function toString() : String
      {
         return formatToString("SHOW_EFFECT","effectType_","targetObjectId_","pos1_","pos2_","color_","duration_");
      }
   }
}
