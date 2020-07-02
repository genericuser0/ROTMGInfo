package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.util.FameUtil;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   
   public class RankText extends Sprite
   {
       
      
      public var background:Sprite = null;
      
      public var largeText_:Boolean;
      
      private var numStars_:int = -1;
      
      private var starBg_:int;
      
      private var prefix_:TextFieldDisplayConcrete = null;
      
      private var waiter:SignalWaiter;
      
      private var icon:Sprite;
      
      public function RankText(param1:int, param2:Boolean, param3:Boolean, param4:int = 0)
      {
         this.waiter = new SignalWaiter();
         super();
         this.largeText_ = param2;
         if(param3)
         {
            this.prefix_ = this.makeText();
            this.prefix_.setStringBuilder(new LineBuilder().setParams(TextKey.RANK_TEXT_RANK));
            this.prefix_.filters = [new DropShadowFilter(0,0,0)];
            this.prefix_.textChanged.addOnce(this.position);
            addChild(this.prefix_);
         }
         mouseEnabled = false;
         mouseChildren = false;
         this.draw(param1,param4);
      }
      
      public function makeText() : TextFieldDisplayConcrete
      {
         var _loc1_:int = !!this.largeText_?18:16;
         var _loc2_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
         _loc2_.setSize(_loc1_).setColor(11776947);
         _loc2_.setBold(this.largeText_);
         return _loc2_;
      }
      
      public function draw(param1:int, param2:int) : void
      {
         var text:TextFieldDisplayConcrete = null;
         var onTextChanged:Function = null;
         var numStars:int = param1;
         var starBg:int = param2;
         onTextChanged = function():void
         {
            icon.x = text.width + 2;
            text.y = !!largeText_?Number(icon.y + text.height + 4):Number(icon.y + text.height);
            var _loc1_:int = icon.x + icon.width;
            background.graphics.clear();
            background.graphics.beginFill(0,0.4);
            var _loc2_:Number = icon.height;
            var _loc3_:int = icon.y;
            background.graphics.drawRoundRect(-2,_loc3_,_loc1_ + 6,_loc2_,12,12);
            background.graphics.endFill();
            position();
         };
         if(numStars == this.numStars_ && starBg == this.starBg_)
         {
            return;
         }
         this.numStars_ = numStars;
         this.starBg_ = starBg >= 0?int(starBg):0;
         if(this.background != null && contains(this.background))
         {
            removeChild(this.background);
         }
         if(this.numStars_ < 0)
         {
            return;
         }
         this.background = new Sprite();
         text = this.makeText();
         text.setVerticalAlign(TextFieldDisplayConcrete.BOTTOM);
         text.setStringBuilder(new StaticStringBuilder(this.numStars_.toString()));
         text.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         this.background.addChild(text);
         this.icon = !!this.largeText_?FameUtil.numStarsToBigImage(this.numStars_,this.starBg_):FameUtil.numStarsToImage(this.numStars_,this.starBg_);
         this.background.addChild(this.icon);
         text.textChanged.addOnce(onTextChanged);
         addChild(this.background);
         if(this.prefix_ != null)
         {
            this.positionWhenTextIsReady();
         }
      }
      
      private function positionWhenTextIsReady() : void
      {
         if(this.waiter.isEmpty())
         {
            this.position();
         }
         else
         {
            this.waiter.complete.addOnce(this.position);
         }
      }
      
      private function position() : void
      {
         if(this.prefix_)
         {
            this.background.x = this.prefix_.width;
            this.prefix_.y = this.icon.y - 3;
            if(!this.largeText_ && this.starBg_ > 0)
            {
               this.background.y = this.background.y - 3;
            }
         }
      }
   }
}
