package com.company.assembleegameclient.util
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.rotmg.graphics.StarGraphic;
   import com.company.util.AssetLibrary;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import io.decagames.rotmg.ui.texture.TextureParser;
   
   public class FameUtil
   {
      
      public static const MAX_STARS:int = 80;
      
      public static const STARS:Vector.<int> = new <int>[20,150,400,800,2000];
      
      private static const lightBlueCT:ColorTransform = new ColorTransform(138 / 255,152 / 255,222 / 255);
      
      private static const darkBlueCT:ColorTransform = new ColorTransform(49 / 255,77 / 255,219 / 255);
      
      private static const redCT:ColorTransform = new ColorTransform(193 / 255,39 / 255,45 / 255);
      
      private static const orangeCT:ColorTransform = new ColorTransform(247 / 255,147 / 255,30 / 255);
      
      private static const yellowCT:ColorTransform = new ColorTransform(255 / 255,255 / 255,0 / 255);
      
      public static const COLORS:Vector.<ColorTransform> = new <ColorTransform>[lightBlueCT,darkBlueCT,redCT,orangeCT,yellowCT];
       
      
      public function FameUtil()
      {
         super();
      }
      
      public static function maxStars() : int
      {
         return ObjectLibrary.playerChars_.length * STARS.length;
      }
      
      public static function numStars(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < STARS.length && param1 >= STARS[_loc2_])
         {
            _loc2_++;
         }
         return _loc2_;
      }
      
      public static function nextStarFame(param1:int, param2:int) : int
      {
         var _loc3_:int = Math.max(param1,param2);
         var _loc4_:int = 0;
         while(_loc4_ < STARS.length)
         {
            if(STARS[_loc4_] > _loc3_)
            {
               return STARS[_loc4_];
            }
            _loc4_++;
         }
         return -1;
      }
      
      public static function numAllTimeStars(param1:int, param2:int, param3:XML) : int
      {
         var _loc6_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         for each(_loc6_ in param3.ClassStats)
         {
            if(param1 == int(_loc6_.@objectType))
            {
               _loc5_ = int(_loc6_.BestFame);
            }
            else
            {
               _loc4_ = _loc4_ + FameUtil.numStars(_loc6_.BestFame);
            }
         }
         _loc4_ = _loc4_ + FameUtil.numStars(Math.max(_loc5_,param2));
         return _loc4_;
      }
      
      public static function numStarsToBigImage(param1:int, param2:int = 0) : Sprite
      {
         var _loc3_:Sprite = numStarsToImage(param1,param2);
         _loc3_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         _loc3_.scaleX = 1.4;
         _loc3_.scaleY = 1.4;
         return _loc3_;
      }
      
      public static function numStarsToImage(param1:int, param2:int = 0) : Sprite
      {
         var _loc3_:Sprite = null;
         var _loc4_:Sprite = null;
         if(param2 >= 0 && param2 <= 4)
         {
            _loc3_ = new Sprite();
            _loc3_.addChild(challengerStarBackground(param2));
            _loc4_ = getStar(param1);
            _loc4_.x = (_loc3_.width - _loc4_.width) / 2;
            _loc4_.y = (_loc3_.height - _loc4_.height) / 2;
            _loc3_.addChild(_loc4_);
            return _loc3_;
         }
         return getStar(param1);
      }
      
      private static function getStar(param1:int) : Sprite
      {
         var _loc2_:Sprite = new StarGraphic();
         if(param1 < ObjectLibrary.playerChars_.length)
         {
            _loc2_.transform.colorTransform = lightBlueCT;
         }
         else if(param1 < ObjectLibrary.playerChars_.length * 2)
         {
            _loc2_.transform.colorTransform = darkBlueCT;
         }
         else if(param1 < ObjectLibrary.playerChars_.length * 3)
         {
            _loc2_.transform.colorTransform = redCT;
         }
         else if(param1 < ObjectLibrary.playerChars_.length * 4)
         {
            _loc2_.transform.colorTransform = orangeCT;
         }
         else if(param1 < ObjectLibrary.playerChars_.length * 5)
         {
            _loc2_.transform.colorTransform = yellowCT;
         }
         return _loc2_;
      }
      
      public static function challengerStarBackground(param1:int) : SliceScalingBitmap
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case 0:
               _loc2_ = "original_allStar";
               break;
            case 1:
               _loc2_ = "challenger_firstPlace";
               break;
            case 2:
               _loc2_ = "challenger_secondPlace";
               break;
            case 3:
               _loc2_ = "challenger_thirdPlace";
               break;
            case 4:
               _loc2_ = "challenger_topPlace";
         }
         var _loc3_:SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI",_loc2_);
         return _loc3_;
      }
      
      public static function numStarsToIcon(param1:int, param2:int = 0) : Sprite
      {
         var _loc3_:Sprite = numStarsToImage(param1,param2);
         var _loc4_:Sprite = new Sprite();
         _loc4_.addChild(_loc3_);
         _loc4_.filters = [new DropShadowFilter(0,0,0,0.5,6,6,1)];
         return _loc4_;
      }
      
      public static function getFameIcon() : BitmapData
      {
         var _loc1_:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",224);
         return TextureRedrawer.redraw(_loc1_,40,true,0);
      }
   }
}
