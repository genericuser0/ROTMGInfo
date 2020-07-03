package io.decagames.rotmg.pets.utils
{
   import io.decagames.rotmg.pets.components.petIcon.PetIcon;
   import io.decagames.rotmg.pets.components.petIcon.PetIconFactory;
   import io.decagames.rotmg.pets.components.petItem.PetItem;
   import io.decagames.rotmg.pets.data.vo.PetVO;
   
   public class PetItemFactory
   {
       
      
      [Inject]
      public var petIconFactory:PetIconFactory;
      
      public function PetItemFactory()
      {
         super();
      }
      
      public function create(param1:PetVO, param2:int, param3:uint = 5526612, param4:Number = 1) : PetItem
      {
         var _loc5_:PetItem = new PetItem(param3);
         var _loc6_:PetIcon = this.petIconFactory.create(param1,param2);
         _loc5_.setPetIcon(_loc6_);
         _loc5_.setSize(param2);
         _loc5_.setBackground(PetItem.REGULAR,param3,param4);
         return _loc5_;
      }
   }
}
