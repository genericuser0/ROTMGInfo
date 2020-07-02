package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import kabam.lib.math.easing.Back;
   
   public class InspireEffect extends ParticleEffect
   {
      
      private static const LIFETIME:int = 1000;
       
      
      public var go_:GameObject;
      
      public var parts1_:Vector.<InspireParticle>;
      
      public var parts2_:Vector.<InspireParticle>;
      
      public var startTime_:int = -1;
      
      private var percentageDone:Number = 0;
      
      public function InspireEffect(param1:GameObject, param2:uint, param3:int)
      {
         var _loc4_:InspireParticle = null;
         this.parts1_ = new Vector.<InspireParticle>();
         this.parts2_ = new Vector.<InspireParticle>();
         super();
         this.go_ = param1;
         var _loc5_:int = 0;
         while(_loc5_ < param3)
         {
            _loc4_ = new InspireParticle(param2,100);
            this.parts1_.push(_loc4_);
            _loc4_ = new InspireParticle(param2,100);
            this.parts2_.push(_loc4_);
            _loc5_++;
         }
      }
      
      override public function update(param1:int, param2:int) : Boolean
      {
         if(this.go_.map_ == null)
         {
            this.endEffect();
            return false;
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         if(this.startTime_ < 0)
         {
            this.startTime_ = param1;
         }
         var _loc3_:Number = (param1 - this.startTime_) / LIFETIME;
         if(_loc3_ >= 1)
         {
            this.endEffect();
            return false;
         }
         this.updateSwirl(this.parts1_,1,0,_loc3_);
         this.updateSwirl(this.parts2_,1,Math.PI,_loc3_);
         return true;
      }
      
      private function endEffect() : void
      {
         var _loc1_:InspireParticle = null;
         for each(_loc1_ in this.parts1_)
         {
            _loc1_.alive_ = false;
         }
         for each(_loc1_ in this.parts2_)
         {
            _loc1_.alive_ = false;
         }
      }
      
      public function updateSwirl(param1:Vector.<InspireParticle>, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:int = 0;
         var _loc6_:InspireParticle = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = param1[_loc5_];
            _loc6_.z_ = Back.easeOut(param4) * 2 - 1 + _loc5_ / param1.length;
            if(_loc6_.z_ >= 0)
            {
               if(_loc6_.z_ > 1)
               {
                  _loc6_.alive_ = false;
               }
               else
               {
                  _loc7_ = param2 * (2 * Math.PI * (_loc5_ / param1.length) + 2 * Math.PI * Back.easeOut(param4) + param3);
                  _loc8_ = this.go_.x_ + 0.5 * Math.cos(_loc7_);
                  _loc9_ = this.go_.y_ + 0.5 * Math.sin(_loc7_);
                  if(_loc6_.map_ == null)
                  {
                     map_.addObj(_loc6_,_loc8_,_loc9_);
                  }
                  else
                  {
                     _loc6_.moveTo(_loc8_,_loc9_);
                  }
               }
            }
            _loc5_++;
         }
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;

class InspireParticle extends Particle
{
    
   
   public var alive_:Boolean = true;
   
   function InspireParticle(param1:uint, param2:int)
   {
      super(param1,0,param2);
   }
   
   override public function update(param1:int, param2:int) : Boolean
   {
      return this.alive_;
   }
}
