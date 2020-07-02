package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.servers.api.Server;
   
   public class ServerBoxes extends Sprite
   {
       
      
      private var boxes_:Vector.<ServerBox>;
      
      private var _isChallenger:Boolean;
      
      public function ServerBoxes(param1:Vector.<Server>, param2:Boolean = false)
      {
         var _loc3_:ServerBox = null;
         var _loc5_:Server = null;
         var _loc6_:String = null;
         this.boxes_ = new Vector.<ServerBox>();
         super();
         this._isChallenger = param2;
         _loc3_ = new ServerBox(null);
         _loc3_.setSelected(true);
         _loc3_.x = ServerBox.WIDTH / 2 + 2;
         _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addChild(_loc3_);
         this.boxes_.push(_loc3_);
         var _loc4_:int = 2;
         for each(_loc5_ in param1)
         {
            _loc3_ = new ServerBox(_loc5_);
            _loc6_ = !!this._isChallenger?Parameters.data_.preferredChallengerServer:Parameters.data_.preferredServer;
            if(_loc5_.name == _loc6_)
            {
               this.setSelected(_loc3_);
            }
            _loc3_.x = _loc4_ % 2 * (ServerBox.WIDTH + 4);
            _loc3_.y = int(_loc4_ / 2) * (ServerBox.HEIGHT + 4);
            _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            addChild(_loc3_);
            this.boxes_.push(_loc3_);
            _loc4_++;
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:ServerBox = param1.currentTarget as ServerBox;
         if(_loc2_ == null)
         {
            return;
         }
         this.setSelected(_loc2_);
         var _loc3_:String = _loc2_.value_;
         if(this._isChallenger)
         {
            Parameters.data_.preferredChallengerServer = _loc3_;
         }
         else
         {
            Parameters.data_.preferredServer = _loc3_;
         }
         Parameters.save();
      }
      
      private function setSelected(param1:ServerBox) : void
      {
         var _loc2_:ServerBox = null;
         for each(_loc2_ in this.boxes_)
         {
            _loc2_.setSelected(false);
         }
         param1.setSelected(true);
      }
   }
}
