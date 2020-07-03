package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.util.FilterUtil;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import io.decagames.rotmg.ui.buttons.InfoButton;
   import kabam.rotmg.core.signals.LeagueItemSignal;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.ui.view.ButtonFactory;
   import kabam.rotmg.ui.view.components.MenuOptionsBar;
   import kabam.rotmg.ui.view.components.ScreenBase;
   import org.osflash.signals.Signal;
   
   public class CharacterTypeSelectionScreen extends Sprite
   {
       
      
      public var close:Signal;
      
      public var leagueItemSignal:LeagueItemSignal;
      
      private const DROP_SHADOW:DropShadowFilter = new DropShadowFilter(0,0,0,1,8,8);
      
      private var nameText:TextFieldDisplayConcrete;
      
      private var backButton:TitleMenuOption;
      
      private var _leagueDatas:Vector.<LeagueData>;
      
      private var _leagueItems:Vector.<LeagueItem>;
      
      private var _leagueContainer:Sprite;
      
      private var _infoButton:InfoButton;
      
      private var _buttonFactory:ButtonFactory;
      
      public function CharacterTypeSelectionScreen()
      {
         this.leagueItemSignal = new LeagueItemSignal();
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._buttonFactory = new ButtonFactory();
         addChild(new ScreenBase());
         addChild(new AccountScreen());
         this.createDisplayAssets();
      }
      
      private function createDisplayAssets() : void
      {
         this.createNameText();
         this.makeMenuOptionsBar();
         this._leagueContainer = new Sprite();
         addChild(this._leagueContainer);
      }
      
      private function makeMenuOptionsBar() : void
      {
         this.backButton = this._buttonFactory.getBackButton();
         this.close = this.backButton.clicked;
         var _loc1_:MenuOptionsBar = new MenuOptionsBar();
         _loc1_.addButton(this.backButton,MenuOptionsBar.CENTER);
         addChild(_loc1_);
      }
      
      private function createNameText() : void
      {
         this.nameText = new TextFieldDisplayConcrete().setSize(22).setColor(11776947);
         this.nameText.setBold(true).setAutoSize(TextFieldAutoSize.CENTER);
         this.nameText.filters = [this.DROP_SHADOW];
         this.nameText.y = 24;
         this.nameText.x = (this.getReferenceRectangle().width - this.nameText.width) / 2;
         addChild(this.nameText);
      }
      
      function getReferenceRectangle() : Rectangle
      {
         var _loc1_:Rectangle = new Rectangle();
         if(stage)
         {
            _loc1_ = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
         }
         return _loc1_;
      }
      
      public function setName(param1:String) : void
      {
         this.nameText.setStringBuilder(new StaticStringBuilder(param1));
         this.nameText.x = (this.getReferenceRectangle().width - this.nameText.width) * 0.5;
      }
      
      public function set leagueDatas(param1:Vector.<LeagueData>) : void
      {
         this._leagueDatas = param1;
         this.createLeagues();
         this.createInfoButton();
      }
      
      private function createInfoButton() : void
      {
         this._infoButton = new InfoButton(10);
         this._infoButton.x = this._leagueContainer.width - this._infoButton.width - 18;
         this._infoButton.y = this._infoButton.height + 16;
         this._leagueContainer.addChild(this._infoButton);
      }
      
      private function createLeagues() : void
      {
         var _loc3_:LeagueItem = null;
         if(!this._leagueItems)
         {
            this._leagueItems = new Vector.<LeagueItem>(0);
         }
         else
         {
            this._leagueItems.length = 0;
         }
         var _loc1_:int = this._leagueDatas.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = new LeagueItem(this._leagueDatas[_loc2_]);
            _loc3_.x = _loc2_ * (_loc3_.width + 20);
            _loc3_.buttonMode = true;
            _loc3_.addEventListener(MouseEvent.CLICK,this.onLeagueItemClick);
            _loc3_.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
            _loc3_.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
            this._leagueItems.push(_loc3_);
            this._leagueContainer.addChild(_loc3_);
            _loc2_++;
         }
         this._leagueContainer.x = (this.width - this._leagueContainer.width) / 2;
         this._leagueContainer.y = (this.height - this._leagueContainer.height) / 2;
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         var _loc2_:LeagueItem = param1.currentTarget as LeagueItem;
         if(_loc2_)
         {
            _loc2_.filters = [];
            _loc2_.characterDance(false);
         }
         else
         {
            param1.currentTarget.filters = [];
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         var _loc2_:LeagueItem = param1.currentTarget as LeagueItem;
         if(_loc2_)
         {
            _loc2_.characterDance(true);
         }
         else
         {
            param1.currentTarget.filters = FilterUtil.getLargeGlowFilter();
         }
      }
      
      private function onLeagueItemClick(param1:MouseEvent) : void
      {
         this.removeLeagueItemListeners();
         this.leagueItemSignal.dispatch((param1.currentTarget as LeagueItem).leagueType);
      }
      
      private function removeLeagueItemListeners() : void
      {
         var _loc1_:int = this._leagueItems.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._leagueItems[_loc2_].removeEventListener(MouseEvent.CLICK,this.onLeagueItemClick);
            this._leagueItems[_loc2_].removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
            this._leagueItems[_loc2_].removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
            _loc2_++;
         }
      }
      
      public function get infoButton() : InfoButton
      {
         return this._infoButton;
      }
   }
}
