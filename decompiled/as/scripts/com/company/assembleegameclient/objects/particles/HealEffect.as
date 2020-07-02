package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   
   public class HealEffect extends ParticleEffect
   {
       
      
      public var go_:GameObject;
      
      public var color1_:uint;
      
      public var color2_:uint;
      
      public function HealEffect(param1:GameObject, param2:uint, param3:uint = 16777215)
      {
         super();
         this.go_ = param1;
         this.color1_ = param2;
         this.color2_ = param3 == 16777215?uint(this.color1_):uint(param3);
      }
      
      override public function update(param1:int, param2:int) : Boolean
      {
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:HealParticle = null;
         if(this.go_.map_ == null)
         {
            return false;
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         var _loc3_:int = 10;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = 2 * Math.PI * (_loc4_ / _loc3_);
            _loc6_ = (3 + int(Math.random() * 5)) * 20;
            _loc7_ = 0.3 + 0.4 * Math.random();
            _loc8_ = new HealParticle(this.color1_,Math.random() * 0.3,_loc6_,1000,0.1 + Math.random() * 0.1,this.go_,_loc5_,_loc7_,this.color2_);
            map_.addObj(_loc8_,x_ + _loc7_ * Math.cos(_loc5_),y_ + _loc7_ * Math.sin(_loc5_));
            _loc4_++;
         }
         return false;
      }
   }
}
