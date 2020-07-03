package io.decagames.rotmg.pets.components.petIcon
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import io.decagames.rotmg.pets.data.vo.IPetVO;
   import io.decagames.rotmg.pets.data.vo.PetVO;
   
   public class PetIconFactory
   {
       
      
      public var outlineSize:Number = 1.4;
      
      public function PetIconFactory()
      {
         super();
      }
      
      public function create(param1:PetVO, param2:int) : PetIcon
      {
         var _loc3_:BitmapData = this.getPetSkinTexture(param1,param2);
         var _loc4_:Bitmap = new Bitmap(_loc3_);
         var _loc5_:PetIcon = new PetIcon(param1);
         _loc5_.setBitmap(_loc4_);
         return _loc5_;
      }
      
      public function getPetSkinTexture(param1:IPetVO, param2:int, param3:uint = 0) : BitmapData
      {
         var _loc5_:Number = NaN;
         var _loc6_:BitmapData = null;
         var _loc4_:BitmapData = !!param1.getSkinMaskedImage()?param1.getSkinMaskedImage().image_:null;
         if(_loc4_)
         {
            _loc5_ = 5 * (16 / _loc4_.width);
            _loc6_ = TextureRedrawer.resize(_loc4_,param1.getSkinMaskedImage().mask_,param2,true,0,0,_loc5_);
            _loc6_ = GlowRedrawer.outlineGlow(_loc6_,param3,this.outlineSize);
            return _loc6_;
         }
         return new BitmapDataSpy(param2,param2);
      }
   }
}
