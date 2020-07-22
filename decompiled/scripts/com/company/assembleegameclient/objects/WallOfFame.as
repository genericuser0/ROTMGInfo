package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.map.Camera;
   import flash.display.IGraphicsData;
   
   public class WallOfFame extends GameObject
   {
       
      
      public function WallOfFame(param1:XML)
      {
         super(null);
         isInteractive_ = false;
      }
      
      override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void
      {
      }
   }
}
