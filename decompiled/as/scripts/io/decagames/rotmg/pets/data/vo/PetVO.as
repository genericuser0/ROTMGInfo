package io.decagames.rotmg.pets.data.vo
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import io.decagames.rotmg.pets.data.PetsModel;
   import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
   import io.decagames.rotmg.pets.data.skin.PetSkinRenderer;
   import kabam.rotmg.core.StaticInjectorContext;
   import org.osflash.signals.Signal;
   
   public class PetVO extends PetSkinRenderer implements IPetVO
   {
       
      
      private var staticData:XML;
      
      private var id:int;
      
      private var type:int;
      
      private var _rarity:PetRarityEnum;
      
      private var _name:String;
      
      private var _maxAbilityPower:int;
      
      private var _abilityList:Array;
      
      private var _updated:Signal;
      
      private var _abilityUpdated:Signal;
      
      private var _ownedSkin:Boolean;
      
      private var _family:String = "";
      
      public function PetVO(param1:int = undefined)
      {
         this._abilityList = [new AbilityVO(),new AbilityVO(),new AbilityVO()];
         this._updated = new Signal();
         this._abilityUpdated = new Signal();
         super();
         this.id = param1;
         this.staticData = <data/>;
         this.listenToAbilities();
      }
      
      private static function getPetDataDescription(param1:int) : String
      {
         return ObjectLibrary.getPetDataXMLByType(param1).Description;
      }
      
      private static function getPetDataDisplayId(param1:int) : String
      {
         return ObjectLibrary.getPetDataXMLByType(param1).@id;
      }
      
      public static function clone(param1:PetVO) : PetVO
      {
         var _loc2_:PetVO = new PetVO(param1.id);
         return _loc2_;
      }
      
      public function get updated() : Signal
      {
         return this._updated;
      }
      
      private function listenToAbilities() : void
      {
         var _loc1_:AbilityVO = null;
         for each(_loc1_ in this._abilityList)
         {
            _loc1_.updated.add(this.onAbilityUpdate);
         }
      }
      
      public function maxedAvailableAbilities() : Boolean
      {
         var _loc1_:AbilityVO = null;
         for each(_loc1_ in this._abilityList)
         {
            if(_loc1_.getUnlocked() && _loc1_.level < this.maxAbilityPower)
            {
               return false;
            }
         }
         return true;
      }
      
      public function totalAbilitiesLevel() : int
      {
         var _loc2_:AbilityVO = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._abilityList)
         {
            if(_loc2_.getUnlocked() && _loc2_.level)
            {
               _loc1_ = _loc1_ + _loc2_.level;
            }
         }
         return _loc1_;
      }
      
      public function get totalMaxAbilitiesLevel() : int
      {
         var _loc2_:AbilityVO = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._abilityList)
         {
            if(_loc2_.getUnlocked())
            {
               _loc1_ = _loc1_ + this._maxAbilityPower;
            }
         }
         return _loc1_;
      }
      
      public function maxedAllAbilities() : Boolean
      {
         var _loc2_:AbilityVO = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._abilityList)
         {
            if(_loc2_.getUnlocked() && _loc2_.level == this.maxAbilityPower)
            {
               _loc1_++;
            }
         }
         return _loc1_ == this._abilityList.length;
      }
      
      private function onAbilityUpdate(param1:AbilityVO) : void
      {
         this._updated.dispatch();
         this._abilityUpdated.dispatch();
      }
      
      public function apply(param1:XML) : void
      {
         this.extractBasicData(param1);
         this.extractAbilityData(param1);
      }
      
      private function extractBasicData(param1:XML) : void
      {
         param1.@instanceId && this.setID(param1.@instanceId);
         param1.@type && this.setType(param1.@type);
         param1.@skin && this.setSkin(param1.@skin);
         param1.@name && this.setName(param1.@name);
         param1.@rarity && this.setRarity(param1.@rarity);
         param1.@maxAbilityPower && this.setMaxAbilityPower(param1.@maxAbilityPower);
      }
      
      public function extractAbilityData(param1:XML) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:AbilityVO = null;
         var _loc5_:int = 0;
         var _loc3_:uint = this._abilityList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this._abilityList[_loc2_];
            _loc5_ = param1.Abilities.Ability[_loc2_].@type;
            _loc4_.name = getPetDataDisplayId(_loc5_);
            _loc4_.description = getPetDataDescription(_loc5_);
            _loc4_.level = param1.Abilities.Ability[_loc2_].@power;
            _loc4_.points = param1.Abilities.Ability[_loc2_].@points;
            _loc2_++;
         }
      }
      
      public function get family() : String
      {
         var _loc1_:SkinVO = this.skinVO;
         if(_loc1_)
         {
            return _loc1_.family;
         }
         return this.staticData.Family;
      }
      
      public function setID(param1:int) : void
      {
         this.id = param1;
      }
      
      public function getID() : int
      {
         return this.id;
      }
      
      public function setType(param1:int) : void
      {
         this.type = param1;
         this.staticData = ObjectLibrary.xmlLibrary_[this.type];
      }
      
      public function getType() : int
      {
         return this.type;
      }
      
      public function setRarity(param1:uint) : void
      {
         this._rarity = PetRarityEnum.selectByOrdinal(param1);
         this.unlockAbilitiesBasedOnPetRarity(param1);
         this._updated.dispatch();
      }
      
      private function unlockAbilitiesBasedOnPetRarity(param1:uint) : void
      {
         this._abilityList[0].setUnlocked(true);
         this._abilityList[1].setUnlocked(param1 >= PetRarityEnum.UNCOMMON.ordinal);
         this._abilityList[2].setUnlocked(param1 >= PetRarityEnum.LEGENDARY.ordinal);
      }
      
      public function get rarity() : PetRarityEnum
      {
         return this._rarity;
      }
      
      public function get skinVO() : SkinVO
      {
         return StaticInjectorContext.getInjector().getInstance(PetsModel).getSkinVOById(_skinType);
      }
      
      public function setName(param1:String) : void
      {
         this._name = ObjectLibrary.typeToDisplayId_[_skinType];
         if(this._name == null || this._name == "")
         {
            this._name = ObjectLibrary.typeToDisplayId_[this.getType()];
         }
         this._updated.dispatch();
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function setMaxAbilityPower(param1:int) : void
      {
         this._maxAbilityPower = param1;
         this._updated.dispatch();
      }
      
      public function get maxAbilityPower() : int
      {
         return this._maxAbilityPower;
      }
      
      public function setSkin(param1:int) : void
      {
         _skinType = param1;
         this._updated.dispatch();
      }
      
      public function get skinType() : int
      {
         return _skinType;
      }
      
      public function get ownedSkin() : Boolean
      {
         return this._ownedSkin;
      }
      
      public function set ownedSkin(param1:Boolean) : void
      {
         this._ownedSkin = param1;
      }
      
      public function setFamily(param1:String) : void
      {
         this._family = param1;
      }
      
      public function get abilityList() : Array
      {
         return this._abilityList;
      }
      
      public function set abilityList(param1:Array) : void
      {
         this._abilityList = param1;
      }
      
      public function get isOwned() : Boolean
      {
         return false;
      }
      
      public function get abilityUpdated() : Signal
      {
         return this._abilityUpdated;
      }
      
      public function get isNew() : Boolean
      {
         return false;
      }
      
      public function set isNew(param1:Boolean) : void
      {
      }
   }
}
