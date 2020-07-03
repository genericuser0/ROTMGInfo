package io.decagames.rotmg.pets.data.ability
{
   import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
   import io.decagames.rotmg.pets.data.vo.AbilityVO;
   import io.decagames.rotmg.pets.data.vo.IPetVO;
   
   public class AbilitiesUtil
   {
       
      
      public function AbilitiesUtil()
      {
         super();
      }
      
      public static function isActiveAbility(param1:PetRarityEnum, param2:int) : Boolean
      {
         if(param1.ordinal >= PetRarityEnum.LEGENDARY.ordinal)
         {
            return true;
         }
         if(param1.ordinal >= PetRarityEnum.UNCOMMON.ordinal)
         {
            return param2 <= 1;
         }
         return param2 == 0;
      }
      
      public static function abilityPowerToMinPoints(param1:int) : int
      {
         return Math.ceil(AbilityConfig.ABILITY_LEVEL1_POINTS * (1 - Math.pow(AbilityConfig.ABILITY_GEOMETRIC_RATIO,param1 - 1)) / (1 - AbilityConfig.ABILITY_GEOMETRIC_RATIO));
      }
      
      public static function abilityPointsToLevel(param1:int) : int
      {
         var _loc2_:Number = param1 * (AbilityConfig.ABILITY_GEOMETRIC_RATIO - 1) / AbilityConfig.ABILITY_LEVEL1_POINTS + 1;
         return int(Math.log(_loc2_) / Math.log(AbilityConfig.ABILITY_GEOMETRIC_RATIO)) + 1;
      }
      
      public static function simulateAbilityUpgrade(param1:IPetVO, param2:int) : Array
      {
         var _loc5_:AbilityVO = null;
         var _loc6_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < 3)
         {
            _loc5_ = param1.abilityList[_loc4_].clone();
            if(AbilitiesUtil.isActiveAbility(param1.rarity,_loc4_) && _loc5_.level < param1.maxAbilityPower)
            {
               _loc5_.points = _loc5_.points + param2 * AbilityConfig.ABILITY_INDEX_TO_POINT_MODIFIER[_loc4_];
               _loc6_ = abilityPointsToLevel(_loc5_.points);
               if(_loc6_ > param1.maxAbilityPower)
               {
                  _loc6_ = param1.maxAbilityPower;
                  _loc5_.points = abilityPowerToMinPoints(_loc6_);
               }
               _loc5_.level = _loc6_;
            }
            _loc3_.push(_loc5_);
            _loc4_++;
         }
         return _loc3_;
      }
   }
}
