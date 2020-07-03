package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.appengine.SavedCharactersList;
   import com.company.assembleegameclient.constants.ScreenTypes;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.rotmg.graphics.ScreenGraphic;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.service.GoogleAnalytics;
   import kabam.rotmg.game.view.CreditDisplay;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.ui.view.components.ScreenBase;
   import org.osflash.signals.Signal;
   
   public class NewCharacterScreen extends Sprite
   {
       
      
      public var tooltip:Signal;
      
      public var close:Signal;
      
      public var selected:Signal;
      
      private var backButton_:TitleMenuOption;
      
      private var creditDisplay_:CreditDisplay;
      
      private var boxes_:Object;
      
      private var isInitialized:Boolean = false;
      
      public function NewCharacterScreen()
      {
         this.boxes_ = {};
         super();
         this.tooltip = new Signal(Sprite);
         this.selected = new Signal(int);
         this.close = new Signal();
         addChild(new ScreenBase());
         addChild(new AccountScreen());
         addChild(new ScreenGraphic());
      }
      
      public function initialize(param1:PlayerModel) : void
      {
         var _loc2_:int = 0;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:CharacterBox = null;
         if(this.isInitialized)
         {
            return;
         }
         this.isInitialized = true;
         this.backButton_ = new TitleMenuOption(ScreenTypes.BACK,36,false);
         this.backButton_.addEventListener(MouseEvent.CLICK,this.onBackClick);
         this.backButton_.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
         addChild(this.backButton_);
         this.creditDisplay_ = new CreditDisplay();
         this.creditDisplay_.draw(param1.getCredits(),param1.getFame());
         addChild(this.creditDisplay_);
         _loc2_ = 0;
         while(_loc2_ < ObjectLibrary.playerChars_.length)
         {
            _loc4_ = ObjectLibrary.playerChars_[_loc2_];
            _loc5_ = int(_loc4_.@type);
            _loc6_ = _loc4_.@id;
            if(!param1.isClassAvailability(_loc6_,SavedCharactersList.UNAVAILABLE))
            {
               if(_loc6_ != "Bard")
               {
                  _loc7_ = param1.isClassAvailability(_loc6_,SavedCharactersList.UNRESTRICTED);
                  _loc8_ = new CharacterBox(_loc4_,param1.getCharStats()[_loc5_],param1,_loc7_);
                  _loc8_.x = 50 + 140 * int(_loc2_ % 5) + 70 - _loc8_.width / 2;
                  _loc8_.y = 88 + 140 * int(_loc2_ / 5);
                  this.boxes_[_loc5_] = _loc8_;
                  _loc8_.addEventListener(MouseEvent.ROLL_OVER,this.onCharBoxOver);
                  _loc8_.addEventListener(MouseEvent.ROLL_OUT,this.onCharBoxOut);
                  _loc8_.characterSelectClicked_.add(this.onCharBoxClick);
                  addChild(_loc8_);
               }
            }
            _loc2_++;
         }
         this.backButton_.x = stage.stageWidth / 2 - this.backButton_.width / 2;
         this.backButton_.y = 550;
         this.creditDisplay_.x = stage.stageWidth;
         this.creditDisplay_.y = 20;
         var _loc3_:GoogleAnalytics = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
         if(_loc3_)
         {
            _loc3_.trackPageView("/newCharScreen");
         }
      }
      
      private function onBackClick(param1:Event) : void
      {
         this.close.dispatch();
      }
      
      private function onCharBoxOver(param1:MouseEvent) : void
      {
         var _loc2_:CharacterBox = param1.currentTarget as CharacterBox;
         _loc2_.setOver(true);
         this.tooltip.dispatch(_loc2_.getTooltip());
      }
      
      private function onCharBoxOut(param1:MouseEvent) : void
      {
         var _loc2_:CharacterBox = param1.currentTarget as CharacterBox;
         _loc2_.setOver(false);
         this.tooltip.dispatch(null);
      }
      
      private function onCharBoxClick(param1:MouseEvent) : void
      {
         this.tooltip.dispatch(null);
         var _loc2_:CharacterBox = param1.currentTarget.parent as CharacterBox;
         if(!_loc2_.available_)
         {
            return;
         }
         var _loc3_:int = _loc2_.objectType();
         var _loc4_:String = ObjectLibrary.typeToDisplayId_[_loc3_];
         var _loc5_:GoogleAnalytics = StaticInjectorContext.getInjector().getInstance(GoogleAnalytics);
         if(!_loc5_)
         {
         }
         this.selected.dispatch(_loc3_);
      }
      
      public function updateCreditsAndFame(param1:int, param2:int) : void
      {
         this.creditDisplay_.draw(param1,param2);
      }
      
      public function update(param1:PlayerModel) : void
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:CharacterBox = null;
         var _loc2_:int = 0;
         while(_loc2_ < ObjectLibrary.playerChars_.length)
         {
            _loc3_ = ObjectLibrary.playerChars_[_loc2_];
            _loc4_ = int(_loc3_.@type);
            _loc5_ = String(_loc3_.@id);
            if(!param1.isClassAvailability(_loc5_,SavedCharactersList.UNAVAILABLE))
            {
               _loc6_ = param1.isClassAvailability(_loc5_,SavedCharactersList.UNRESTRICTED);
               _loc7_ = this.boxes_[_loc4_];
               if(_loc7_)
               {
                  if(_loc6_ || param1.isLevelRequirementsMet(_loc4_))
                  {
                     _loc7_.unlock();
                  }
               }
            }
            _loc2_++;
         }
      }
   }
}
