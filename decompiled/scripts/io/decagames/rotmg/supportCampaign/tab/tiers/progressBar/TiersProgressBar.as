package io.decagames.rotmg.supportCampaign.tab.tiers.progressBar
{
   import flash.display.Sprite;
   import io.decagames.rotmg.supportCampaign.data.vo.RankVO;
   import io.decagames.rotmg.supportCampaign.tab.tiers.button.TierButton;
   import io.decagames.rotmg.supportCampaign.tab.tiers.button.status.TierButtonStatus;
   import io.decagames.rotmg.ui.ProgressBar;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import io.decagames.rotmg.ui.texture.TextureParser;
   
   public class TiersProgressBar extends Sprite
   {
       
      
      private var _ranks:Vector.<RankVO>;
      
      private var _componentWidth:int;
      
      private var _currentRank:int;
      
      private var _claimed:int;
      
      private var buttonAreReady:Boolean;
      
      private var _buttons:Vector.<TierButton>;
      
      private var _progressBar:ProgressBar;
      
      private var _points:int;
      
      private var supportIcon:SliceScalingBitmap;
      
      public function TiersProgressBar(param1:Vector.<RankVO>, param2:int)
      {
         super();
         this._ranks = param1;
         this._componentWidth = param2;
         this._buttons = new Vector.<TierButton>();
         this.supportIcon = TextureParser.instance.getSliceScalingBitmap("UI","campaign_Points");
      }
      
      public function show(param1:int, param2:int, param3:int) : void
      {
         this._currentRank = param2;
         this._claimed = param3;
         this._points = param1;
         if(!this.buttonAreReady)
         {
            this.renderProgressBar();
            this.renderButtons();
         }
         this.updateProgressBar();
         this.updateButtons();
      }
      
      private function getStatusByTier(param1:int) : int
      {
         if(this._claimed >= param1)
         {
            return TierButtonStatus.CLAIMED;
         }
         if(this._currentRank >= param1)
         {
            return TierButtonStatus.UNLOCKED;
         }
         return TierButtonStatus.LOCKED;
      }
      
      private function updateButtons() : void
      {
         var _loc2_:TierButton = null;
         var _loc1_:Boolean = false;
         for each(_loc2_ in this._buttons)
         {
            _loc2_.updateStatus(this.getStatusByTier(_loc2_.tier));
            if(!_loc1_ && this.getStatusByTier(_loc2_.tier) == TierButtonStatus.UNLOCKED)
            {
               _loc1_ = true;
               _loc2_.selected = true;
            }
            else
            {
               _loc2_.selected = false;
            }
         }
         if(!_loc1_)
         {
            if(this._currentRank != 0)
            {
               for each(_loc2_ in this._buttons)
               {
                  if(this._currentRank == _loc2_.tier)
                  {
                     _loc1_ = true;
                     _loc2_.selected = true;
                  }
               }
            }
         }
         if(!_loc1_)
         {
            this._buttons[0].selected = true;
         }
      }
      
      private function updateProgressBar() : void
      {
         var _loc1_:int = this._points;
         if(this._progressBar.value != _loc1_)
         {
            if(_loc1_ > this._progressBar.maxValue - this._progressBar.minValue)
            {
               this._progressBar.value = this._progressBar.maxValue - this._progressBar.minValue;
            }
            else
            {
               this._progressBar.value = _loc1_;
            }
         }
      }
      
      private function renderProgressBar() : void
      {
         this._progressBar = new ProgressBar(this._componentWidth,4,"","",0,this._ranks[this._ranks.length - 1].points,0,5526612,1029573);
         this._progressBar.y = 7;
         this._progressBar.shouldAnimate = false;
         addChild(this._progressBar);
         this.supportIcon.x = -4;
         this.supportIcon.y = 5;
         addChild(this.supportIcon);
      }
      
      private function renderButtons() : void
      {
         var _loc2_:RankVO = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TierButton = null;
         var _loc8_:TierButton = null;
         var _loc1_:int = 1;
         for each(_loc2_ in this._ranks)
         {
            _loc7_ = new TierButton(_loc1_,this.getStatusByTier(_loc1_));
            this._buttons.push(_loc7_);
            _loc1_++;
         }
         _loc3_ = this._buttons.length;
         _loc4_ = this._componentWidth / _loc3_;
         _loc5_ = 1;
         _loc6_ = _loc3_ - 1;
         while(_loc6_ >= 0)
         {
            _loc8_ = this._buttons[_loc6_];
            _loc8_.x = this._componentWidth - _loc5_ * _loc4_;
            addChild(_loc8_);
            _loc5_++;
            _loc6_--;
         }
         this.buttonAreReady = true;
      }
   }
}
