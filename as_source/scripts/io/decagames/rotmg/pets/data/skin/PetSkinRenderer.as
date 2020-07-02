package io.decagames.rotmg.pets.data.skin
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.util.AnimatedChar;
   import com.company.assembleegameclient.util.AnimatedChars;
   import com.company.assembleegameclient.util.MaskedImage;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class PetSkinRenderer
   {
       
      
      protected var _skinType:int;
      
      protected var skin:AnimatedChar;
      
      public function PetSkinRenderer()
      {
         super();
      }
      
      public function getSkinBitmap() : Bitmap
      {
         this.makeSkin();
         if(this.skin == null)
         {
            return null;
         }
         var _loc1_:MaskedImage = this.skin.imageFromAngle(0,AnimatedChar.STAND,0);
         var _loc2_:int = this.skin.getHeight() == 16?40:80;
         var _loc3_:BitmapData = TextureRedrawer.resize(_loc1_.image_,_loc1_.mask_,_loc2_,true,0,0);
         _loc3_ = GlowRedrawer.outlineGlow(_loc3_,0);
         return new Bitmap(_loc3_);
      }
      
      protected function makeSkin() : void
      {
         var _loc1_:XML = ObjectLibrary.getXMLfromId(ObjectLibrary.getIdFromType(this._skinType));
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:String = _loc1_.AnimatedTexture.File;
         var _loc3_:int = _loc1_.AnimatedTexture.Index;
         this.skin = AnimatedChars.getAnimatedChar(_loc2_,_loc3_);
      }
      
      public function getSkinMaskedImage() : MaskedImage
      {
         this.makeSkin();
         return !!this.skin?this.skin.imageFromAngle(0,AnimatedChar.STAND,0):null;
      }
   }
}
