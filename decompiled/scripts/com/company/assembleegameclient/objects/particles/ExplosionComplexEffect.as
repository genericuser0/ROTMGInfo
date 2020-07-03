package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   
   public class ExplosionComplexEffect extends ParticleEffect
   {
       
      
      public var go_:GameObject;
      
      public var color_:uint;
      
      public var rise_:Number;
      
      public var minRad_:Number;
      
      public var maxRad_:Number;
      
      public var lastUpdate_:int = -1;
      
      public var amount_:int;
      
      public var maxLife_:int;
      
      public var speed_:Number;
      
      public var bInitialized_:Boolean = false;
      
      public function ExplosionComplexEffect(param1:GameObject, param2:EffectProperties)
      {
         super();
         this.go_ = param1;
         this.color_ = param2.color;
         this.rise_ = param2.rise;
         this.minRad_ = param2.minRadius;
         this.maxRad_ = param2.maxRadius;
         this.amount_ = param2.amount;
         this.maxLife_ = param2.life * 1000;
         size_ = param2.size;
      }
      
      private function run(param1:int, param2:int, param3:int) : Boolean
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:ExplosionComplexParticle = null;
         var _loc4_:int = 0;
         while(_loc4_ < param3)
         {
            _loc5_ = Math.random() * Math.PI * 2;
            _loc6_ = this.minRad_ + Math.random() * (this.maxRad_ - this.minRad_);
            _loc7_ = _loc6_ * Math.cos(_loc5_) / (0.008 * this.maxLife_);
            _loc8_ = _loc6_ * Math.sin(_loc5_) / (0.008 * this.maxLife_);
            _loc9_ = Math.random() * Math.PI;
            _loc10_ = 0;
            _loc11_ = new ExplosionComplexParticle(this.color_,0.2,size_,this.maxLife_,_loc7_,_loc8_,_loc10_);
            map_.addObj(_loc11_,x_,y_);
            _loc4_++;
         }
         return false;
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean
      {
         return this.run(param1,param2,this.amount_);
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean
      {
         return this.run(param1,param2,this.amount_ / 6);
      }
   }
}

import com.company.assembleegameclient.objects.particles.Particle;
import flash.geom.Vector3D;

class ExplosionComplexParticle extends Particle
{
   
   public static var total_:int = 0;
    
   
   public var lifetime_:int;
   
   public var timeLeft_:int;
   
   protected var moveVec_:Vector3D;
   
   private var deleted:Boolean = false;
   
   function ExplosionComplexParticle(param1:uint, param2:Number, param3:int, param4:int, param5:Number, param6:Number, param7:Number)
   {
      this.moveVec_ = new Vector3D();
      super(param1,param2,param3);
      this.timeLeft_ = this.lifetime_ = param4;
      this.moveVec_.x = param5;
      this.moveVec_.y = param6;
      this.moveVec_.z = param7;
      total_++;
   }
   
   override public function update(param1:int, param2:int) : Boolean
   {
      this.timeLeft_ = this.timeLeft_ - param2;
      if(this.timeLeft_ <= 0)
      {
         if(!this.deleted)
         {
            total_--;
            this.deleted = true;
         }
         return false;
      }
      x_ = x_ + this.moveVec_.x * param2 * 0.008;
      y_ = y_ + this.moveVec_.y * param2 * 0.008;
      z_ = z_ + this.moveVec_.z * param2 * 0.008;
      return true;
   }
}
