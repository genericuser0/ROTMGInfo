package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.appengine.CharacterStats;
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import com.company.assembleegameclient.ui.tooltip.ClassToolTip;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import com.company.assembleegameclient.util.AnimatedChar;
   import com.company.assembleegameclient.util.FameUtil;
   import com.company.rotmg.graphics.FullCharBoxGraphic;
   import com.company.rotmg.graphics.LockedCharBoxGraphic;
   import com.company.rotmg.graphics.StarGraphic;
   import com.company.util.AssetLibrary;
   import com.gskinner.motion.GTween;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import org.osflash.signals.natives.NativeSignal;
   
   public class CharacterBox extends Sprite
   {
      
      private static const fullCT:ColorTransform = new ColorTransform(0.8,0.8,0.8);
      
      private static const emptyCT:ColorTransform = new ColorTransform(0.2,0.2,0.2);
       
      
      public var playerXML_:XML = null;
      
      public var charStats_:CharacterStats;
      
      public var model:PlayerModel;
      
      public var available_:Boolean;
      
      public var characterSelectClicked_:NativeSignal;
      
      private var graphicContainer_:Sprite;
      
      private var graphic_:Sprite;
      
      private var bitmap_:Bitmap;
      
      private var statusText_:TextFieldDisplayConcrete;
      
      private var classNameText_:TextFieldDisplayConcrete;
      
      private var lock_:Bitmap;
      
      private var unlockedText_:TextFieldDisplayConcrete;
      
      public function CharacterBox(param1:XML, param2:CharacterStats, param3:PlayerModel, param4:Boolean = false)
      {
         var _loc5_:Sprite = null;
         super();
         this.model = param3;
         this.playerXML_ = param1;
         this.charStats_ = param2;
         this.available_ = param4 || param3.isLevelRequirementsMet(this.objectType());
         if(!this.available_)
         {
            this.graphic_ = new LockedCharBoxGraphic();
         }
         else
         {
            this.graphic_ = new FullCharBoxGraphic();
         }
         this.graphicContainer_ = new Sprite();
         addChild(this.graphicContainer_);
         this.graphicContainer_.addChild(this.graphic_);
         this.characterSelectClicked_ = new NativeSignal(this.graphicContainer_,MouseEvent.CLICK,MouseEvent);
         this.bitmap_ = new Bitmap(null);
         this.setImage(AnimatedChar.DOWN,AnimatedChar.STAND,0);
         this.graphic_.addChild(this.bitmap_);
         this.classNameText_ = new TextFieldDisplayConcrete().setSize(14).setColor(16777215).setAutoSize(TextFieldAutoSize.CENTER).setTextWidth(this.graphic_.width).setBold(true);
         this.classNameText_.setStringBuilder(new LineBuilder().setParams(ClassToolTip.getDisplayId(this.playerXML_)));
         this.classNameText_.filters = [new DropShadowFilter(0,0,0,1,4,4)];
         this.graphic_.addChild(this.classNameText_);
         this.setStatusButton();
         if(this.available_)
         {
            _loc5_ = this.getStars(FameUtil.numStars(param3.getBestFame(this.objectType())),FameUtil.STARS.length);
            _loc5_.y = 60;
            _loc5_.x = this.graphic_.width / 2 - _loc5_.width / 2;
            _loc5_.filters = [new DropShadowFilter(0,0,0,1,4,4)];
            this.graphicContainer_.addChild(_loc5_);
            this.classNameText_.y = 74;
         }
         else
         {
            this.lock_ = new Bitmap(AssetLibrary.getImageFromSet("lofiInterface2",5));
            this.lock_.scaleX = 2;
            this.lock_.scaleY = 2;
            this.lock_.x = 4;
            this.lock_.y = 8;
            addChild(this.lock_);
            addChild(this.statusText_);
            this.classNameText_.y = 78;
         }
      }
      
      public function objectType() : int
      {
         return int(this.playerXML_.@type);
      }
      
      public function unlock() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:GTween = null;
         if(this.available_ == false)
         {
            this.available_ = true;
            this.graphicContainer_.removeChild(this.graphic_);
            this.graphic_ = new FullCharBoxGraphic();
            this.graphicContainer_.addChild(this.graphic_);
            this.setImage(AnimatedChar.DOWN,AnimatedChar.STAND,0);
            this.graphic_.addChild(this.bitmap_);
            this.graphic_.addChild(this.classNameText_);
            if(contains(this.statusText_))
            {
               removeChild(this.statusText_);
            }
            if(this.lock_ && contains(this.lock_))
            {
               removeChild(this.lock_);
            }
            _loc1_ = this.getStars(FameUtil.numStars(this.model.getBestFame(this.objectType())),FameUtil.STARS.length);
            _loc1_.y = 60;
            _loc1_.x = this.graphic_.width / 2 - _loc1_.width / 2;
            _loc1_.filters = [new DropShadowFilter(0,0,0,1,4,4)];
            addChild(_loc1_);
            this.classNameText_.y = 74;
            if(!this.unlockedText_)
            {
               this.getCharacterUnlockText();
            }
            addChild(this.unlockedText_);
            _loc2_ = new GTween(this.unlockedText_,2.5,{
               "alpha":0,
               "y":-30
            });
            _loc2_.onComplete = this.removeUnlockText;
         }
      }
      
      public function getTooltip() : ToolTip
      {
         return new ClassToolTip(this.playerXML_,this.model,this.charStats_);
      }
      
      public function setOver(param1:Boolean) : void
      {
         if(!this.available_)
         {
            return;
         }
         if(param1)
         {
            transform.colorTransform = new ColorTransform(1.2,1.2,1.2);
         }
         else
         {
            transform.colorTransform = new ColorTransform(1,1,1);
         }
      }
      
      private function removeUnlockText(param1:GTween) : void
      {
         removeChild(this.unlockedText_);
      }
      
      private function setImage(param1:int, param2:int, param3:Number) : void
      {
         this.bitmap_.bitmapData = SavedCharacter.getImage(null,this.playerXML_,param1,param2,param3,this.available_,false);
         this.bitmap_.x = this.graphic_.width / 2 - this.bitmap_.bitmapData.width / 2;
      }
      
      private function getStars(param1:int, param2:int) : Sprite
      {
         var _loc5_:Sprite = null;
         var _loc3_:Sprite = new Sprite();
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         while(_loc4_ < param1)
         {
            _loc5_ = new StarGraphic();
            _loc5_.x = _loc6_;
            _loc5_.transform.colorTransform = fullCT;
            _loc3_.addChild(_loc5_);
            _loc6_ = _loc6_ + _loc5_.width;
            _loc4_++;
         }
         while(_loc4_ < param2)
         {
            _loc5_ = new StarGraphic();
            _loc5_.x = _loc6_;
            _loc5_.transform.colorTransform = emptyCT;
            _loc3_.addChild(_loc5_);
            _loc6_ = _loc6_ + _loc5_.width;
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function setStatusButton() : void
      {
         this.statusText_ = new TextFieldDisplayConcrete().setSize(14).setColor(16711680).setAutoSize(TextFieldAutoSize.CENTER).setBold(true).setTextWidth(this.graphic_.width);
         this.statusText_.setStringBuilder(new LineBuilder().setParams(TextKey.LOCKED));
         this.statusText_.filters = [new DropShadowFilter(0,0,0,1,4,4)];
         this.statusText_.y = 58;
      }
      
      private function getCharacterUnlockText() : void
      {
         this.unlockedText_ = new TextFieldDisplayConcrete().setSize(14).setColor(65280).setBold(true).setAutoSize(TextFieldAutoSize.CENTER);
         this.unlockedText_.filters = [new DropShadowFilter(0,0,0,1,4,4)];
         this.unlockedText_.setStringBuilder(new LineBuilder().setParams(TextKey.UNLOCK_CLASS));
         this.unlockedText_.y = -20;
      }
   }
}
