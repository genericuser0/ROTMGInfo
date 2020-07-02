package com.company.assembleegameclient.util.redrawers
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.PointUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.GradientType;
   import flash.display.Shape;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   
   public class GlowRedrawer
   {
      
      private static const GRADIENT_MAX_SUB:uint = 2631720;
      
      private static const GLOW_FILTER:GlowFilter = new GlowFilter(0,0.3,12,12,2,BitmapFilterQuality.LOW,false,false);
      
      private static const GLOW_FILTER_ALT:GlowFilter = new GlowFilter(0,0.5,16,16,3,BitmapFilterQuality.LOW,false,false);
      
      private static const GLOW_FILTER_SUPPORT:GlowFilter = new GlowFilter(0,0.3,12,12,3,BitmapFilterQuality.LOW,false,false);
      
      private static const GLOW_FILTER_SUPPORT_DARK:GlowFilter = new GlowFilter(0,0.4,6,6,2,BitmapFilterQuality.LOW,false,false);
      
      private static const GLOW_FILTER_SUPPORT_OUTLINE:GlowFilter = new GlowFilter(0,1,2,2,255,BitmapFilterQuality.LOW,false,false);
      
      private static const GLOW_FILTER_SUPPORT_ALT:GlowFilter = new GlowFilter(0,0.3,12,12,4,BitmapFilterQuality.LOW,false,false);
      
      private static const GLOW_FILTER_SUPPORT_DARK_ALT:GlowFilter = new GlowFilter(0,0.4,6,6,2,BitmapFilterQuality.LOW,false,false);
      
      private static const GLOW_FILTER_SUPPORT_OUTLINE_ALT:GlowFilter = new GlowFilter(0,1,2,2,255,BitmapFilterQuality.LOW,false,false);
      
      private static var tempMatrix_:Matrix = new Matrix();
      
      private static var gradient_:Shape = getGradient();
      
      private static var glowHashes:Dictionary = new Dictionary();
       
      
      public function GlowRedrawer()
      {
         super();
      }
      
      public static function outlineGlow(param1:BitmapData, param2:uint, param3:Number = 1.4, param4:Boolean = false, param5:int = 0, param6:Boolean = false) : BitmapData
      {
         var _loc7_:String = getHash(param2,param3,param5);
         if(param4 && isCached(param1,_loc7_))
         {
            return glowHashes[param1][_loc7_];
         }
         var _loc8_:BitmapData = param1.clone();
         tempMatrix_.identity();
         tempMatrix_.scale(param1.width / 256,param1.height / 256);
         _loc8_.draw(gradient_,tempMatrix_,null,BlendMode.SUBTRACT);
         var _loc9_:Bitmap = new Bitmap(param1);
         _loc8_.draw(_loc9_,null,null,BlendMode.ALPHA);
         TextureRedrawer.OUTLINE_FILTER.blurX = param3;
         TextureRedrawer.OUTLINE_FILTER.blurY = param3;
         TextureRedrawer.OUTLINE_FILTER.color = param5;
         _loc8_.applyFilter(_loc8_,_loc8_.rect,PointUtil.ORIGIN,TextureRedrawer.OUTLINE_FILTER);
         if(param2 != 4294967295)
         {
            if(Parameters.isGpuRender() && param2 != 0)
            {
               if(!param6)
               {
                  GLOW_FILTER_ALT.color = param2;
                  _loc8_.applyFilter(_loc8_,_loc8_.rect,PointUtil.ORIGIN,GLOW_FILTER_ALT);
               }
               else
               {
                  GLOW_FILTER_SUPPORT_ALT.color = param2;
                  GLOW_FILTER_SUPPORT_DARK_ALT.color = param2 - 2385408;
                  GLOW_FILTER_SUPPORT_OUTLINE_ALT.color = param2;
                  _loc8_.applyFilter(_loc8_,_loc8_.rect,PointUtil.ORIGIN,GLOW_FILTER_SUPPORT_OUTLINE_ALT);
                  _loc8_.applyFilter(_loc8_,_loc8_.rect,PointUtil.ORIGIN,GLOW_FILTER_SUPPORT_DARK_ALT);
                  _loc8_.applyFilter(_loc8_,_loc8_.rect,PointUtil.ORIGIN,GLOW_FILTER_SUPPORT_ALT);
               }
            }
            else if(!param6)
            {
               GLOW_FILTER.color = param2;
               _loc8_.applyFilter(_loc8_,_loc8_.rect,PointUtil.ORIGIN,GLOW_FILTER);
            }
            else
            {
               GLOW_FILTER_SUPPORT.color = param2;
               GLOW_FILTER_SUPPORT_DARK.color = param2 - 2385408;
               GLOW_FILTER_SUPPORT_OUTLINE.color = param2;
               _loc8_.applyFilter(_loc8_,_loc8_.rect,PointUtil.ORIGIN,GLOW_FILTER_SUPPORT_OUTLINE);
               _loc8_.applyFilter(_loc8_,_loc8_.rect,PointUtil.ORIGIN,GLOW_FILTER_SUPPORT_DARK);
               _loc8_.applyFilter(_loc8_,_loc8_.rect,PointUtil.ORIGIN,GLOW_FILTER_SUPPORT);
            }
         }
         if(param4)
         {
            cache(param1,param2,param3,_loc8_,param5);
         }
         return _loc8_;
      }
      
      private static function cache(param1:BitmapData, param2:uint, param3:Number, param4:BitmapData, param5:int) : void
      {
         var _loc7_:Object = null;
         var _loc6_:String = getHash(param2,param3,param5);
         if(param1 in glowHashes)
         {
            glowHashes[param1][_loc6_] = param4;
         }
         else
         {
            _loc7_ = {};
            _loc7_[_loc6_] = param4;
            glowHashes[param1] = _loc7_;
         }
      }
      
      private static function isCached(param1:BitmapData, param2:String) : Boolean
      {
         var _loc3_:Object = null;
         if(param1 in glowHashes)
         {
            _loc3_ = glowHashes[param1];
            if(param2 in _loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      private static function getHash(param1:uint, param2:Number, param3:int) : String
      {
         return int(param2 * 10).toString() + param1 + param3;
      }
      
      private static function getGradient() : Shape
      {
         var _loc1_:Shape = new Shape();
         var _loc2_:Matrix = new Matrix();
         _loc2_.createGradientBox(256,256,Math.PI / 2,0,0);
         _loc1_.graphics.beginGradientFill(GradientType.LINEAR,[0,GRADIENT_MAX_SUB],[1,1],[127,255],_loc2_);
         _loc1_.graphics.drawRect(0,0,256,256);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
   }
}
