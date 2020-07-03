package io.decagames.rotmg.pets.components.petSkinsCollection
{
   import io.decagames.rotmg.pets.data.family.PetFamilyColors;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.gird.UIGridElement;
   import io.decagames.rotmg.ui.labels.UILabel;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import io.decagames.rotmg.ui.texture.TextureParser;
   import io.decagames.rotmg.utils.colors.Tint;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class PetFamilyContainer extends UIGridElement
   {
       
      
      public function PetFamilyContainer(param1:String, param2:int, param3:int)
      {
         var _loc5_:SliceScalingBitmap = null;
         var _loc6_:UILabel = null;
         var _loc7_:SliceScalingBitmap = null;
         super();
         var _loc4_:uint = PetFamilyColors.KEYS_TO_COLORS[param1];
         _loc5_ = TextureParser.instance.getSliceScalingBitmap("UI","content_divider_white",320);
         Tint.add(_loc5_,_loc4_,1);
         addChild(_loc5_);
         _loc5_.x = 10;
         _loc5_.y = 3;
         _loc6_ = new UILabel();
         DefaultLabelFormat.petFamilyLabel(_loc6_,16777215);
         _loc6_.text = LineBuilder.getLocalizedStringFromKey(param1);
         _loc6_.y = 0;
         _loc6_.x = 320 / 2 - _loc6_.width / 2 + 10;
         _loc7_ = TextureParser.instance.getSliceScalingBitmap("UI","content_divider_smalltitle_white",_loc6_.width + 20);
         Tint.add(_loc7_,_loc4_,1);
         addChild(_loc7_);
         _loc7_.x = 320 / 2 - _loc7_.width / 2 + 10;
         _loc7_.y = 0;
         addChild(_loc6_);
      }
   }
}
