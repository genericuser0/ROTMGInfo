package com.greensock.easing
{
   public final class SineOut extends Ease
   {
      
      public static var ease:SineOut = new SineOut();
      
      private static const _HALF_PI:Number = Math.PI / 2;
       
      
      public function SineOut()
      {
         super();
      }
      
      override public function getRatio(param1:Number) : Number
      {
         return Math.sin(param1 * _HALF_PI);
      }
   }
}
