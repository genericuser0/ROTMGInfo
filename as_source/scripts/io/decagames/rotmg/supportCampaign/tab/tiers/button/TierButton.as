package io.decagames.rotmg.supportCampaign.tab.tiers.button
{
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.easing.Expo;
   import flash.display.Sprite;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import io.decagames.rotmg.supportCampaign.tab.tiers.button.status.TierButtonStatus;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.labels.UILabel;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import io.decagames.rotmg.ui.texture.TextureParser;
   import org.osflash.signals.Signal;
   
   public class TierButton extends Sprite
   {
       
      
      private var background:SliceScalingBitmap;
      
      private var _tier:int;
      
      private var _status:int;
      
      private var _selected:Boolean;
      
      private var tierLabel:UILabel;
      
      private var _removeToolTipSignal:Signal;
      
      private var tierTween:TimelineMax;
      
      private var claimTween:TimelineMax;
      
      private const OUTLINE_FILTER:GlowFilter = new GlowFilter(16777215,1,3,3,16,BitmapFilterQuality.HIGH,false,false);
      
      private const GLOW_FILTER:GlowFilter = new GlowFilter(409669,0.4,2,2,16,BitmapFilterQuality.HIGH,false,false);
      
      public function TierButton(param1:int, param2:int)
      {
         this._removeToolTipSignal = new Signal();
         super();
         this._tier = param1;
         this._status = param2;
         this.tierLabel = new UILabel();
         this.tierLabel.autoSize = TextFieldAutoSize.NONE;
         this.tierLabel.multiline = false;
         this.tierLabel.wordWrap = false;
         this.tierLabel.mouseEnabled = false;
         this.updateStatus(param2);
      }
      
      public function updateStatus(param1:int) : void
      {
         if(this.background && this.background.parent)
         {
            removeChild(this.background);
         }
         switch(param1)
         {
            case TierButtonStatus.LOCKED:
               this.background = TextureParser.instance.getSliceScalingBitmap("UI","tier_locked");
               this.background.y = 2;
               addChildAt(this.background,0);
               DefaultLabelFormat.createLabelFormat(this.tierLabel,12,3487029,TextFormatAlign.CENTER,true);
               this.tierLabel.width = this.background.width;
               this.tierLabel.height = this.background.height;
               this.tierLabel.text = this._tier.toString();
               this.tierLabel.y = 6;
               break;
            case TierButtonStatus.UNLOCKED:
               this.background = TextureParser.instance.getSliceScalingBitmap("UI","tier_unlocked");
               this.background.y = 2;
               addChildAt(this.background,0);
               DefaultLabelFormat.createLabelFormat(this.tierLabel,14,16777215,TextFormatAlign.CENTER,true);
               this.tierLabel.width = this.background.width;
               this.tierLabel.height = this.background.height;
               this.tierLabel.text = this._tier.toString();
               this.tierLabel.y = 5;
               this.tierLabel.filters = [this.GLOW_FILTER];
               if(!this.claimTween)
               {
                  this.claimTween = new TimelineMax({"repeat":-1});
                  this.claimTween.add(TweenMax.to(this,0.2,{
                     "tint":null,
                     "ease":Expo.easeIn
                  }));
                  this.claimTween.add(TweenMax.to(this,0.2,{
                     "delay":0.5,
                     "tint":16777215
                  }));
                  this.claimTween.add(TweenMax.to(this,0.5,{
                     "tint":null,
                     "ease":Expo.easeOut
                  }));
               }
               else
               {
                  this.claimTween.play(0);
               }
               break;
            case TierButtonStatus.CLAIMED:
               this.tierLabel.visible = false;
               this.background = TextureParser.instance.getSliceScalingBitmap("UI","tier_claimed");
               this.background.y = 2;
               addChildAt(this.background,0);
               if(this.claimTween)
               {
                  this.claimTween.pause(0);
               }
               this._removeToolTipSignal.dispatch();
         }
         addChild(this.tierLabel);
         this.applySelectFilter();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         this.applySelectFilter();
      }
      
      private function applySelectFilter() : void
      {
         if(this._selected)
         {
            this.background.filters = [this.OUTLINE_FILTER];
            if(!this.tierTween)
            {
               this.tierTween = new TimelineMax();
               this.tierTween.add(TweenMax.to(this,0.05,{
                  "scaleX":0.9,
                  "scaleY":0.9,
                  "x":this.x + this.width * 0.1 / 2,
                  "y":this.y + this.height * 0.1 / 2,
                  "tint":16777215
               }));
               this.tierTween.add(TweenMax.to(this,0.3,{
                  "scaleX":1,
                  "scaleY":1,
                  "x":this.x,
                  "y":this.y,
                  "tint":null,
                  "ease":Expo.easeOut
               }));
            }
            else
            {
               this.tierTween.play(0);
            }
         }
         else
         {
            this.background.filters = [];
         }
      }
      
      public function get label() : UILabel
      {
         return this.tierLabel;
      }
      
      public function get tier() : int
      {
         return this._tier;
      }
      
      public function get status() : int
      {
         return this._status;
      }
      
      public function get removeToolTipSignal() : Signal
      {
         return this._removeToolTipSignal;
      }
   }
}
