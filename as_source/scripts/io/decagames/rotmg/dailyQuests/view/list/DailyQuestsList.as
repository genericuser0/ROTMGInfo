package io.decagames.rotmg.dailyQuests.view.list
{
   import flash.display.Sprite;
   import io.decagames.rotmg.ui.buttons.BaseButton;
   import io.decagames.rotmg.ui.scroll.UIScrollbar;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import io.decagames.rotmg.ui.tabs.TabButton;
   import io.decagames.rotmg.ui.tabs.UITab;
   import io.decagames.rotmg.ui.tabs.UITabs;
   import io.decagames.rotmg.ui.texture.TextureParser;
   
   public class DailyQuestsList extends Sprite
   {
      
      public static const QUEST_TAB_LABEL:String = "Quests";
      
      public static const EVENT_TAB_LABEL:String = "Events";
      
      public static const SCROLL_BAR_HEIGHT:int = 345;
       
      
      private var questLinesPosition:int = 0;
      
      private var eventLinesPosition:int = 0;
      
      private var questsContainer:Sprite;
      
      private var eventsContainer:Sprite;
      
      private var _tabs:UITabs;
      
      private var eventsTab:TabButton;
      
      private var contentTabs:SliceScalingBitmap;
      
      private var contentInset:SliceScalingBitmap;
      
      private var _dailyQuestElements:Vector.<DailyQuestListElement>;
      
      private var _eventQuestElements:Vector.<DailyQuestListElement>;
      
      public function DailyQuestsList()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.createContentTabs();
         this.createContentInset();
         this.createTabs();
      }
      
      private function createTabs() : void
      {
         this._tabs = new UITabs(230,true);
         this._tabs.addTab(this.createQuestsTab(),true);
         this._tabs.addTab(this.createEventsTab());
         this._tabs.y = 1;
         addChild(this._tabs);
      }
      
      private function createContentInset() : void
      {
         this.contentInset = TextureParser.instance.getSliceScalingBitmap("UI","popup_content_inset",230);
         this.contentInset.height = 360;
         this.contentInset.y = 35;
         addChild(this.contentInset);
      }
      
      private function createContentTabs() : void
      {
         this.contentTabs = TextureParser.instance.getSliceScalingBitmap("UI","tab_inset_content_background",230);
         this.contentTabs.height = 45;
         addChild(this.contentTabs);
      }
      
      private function createQuestsTab() : UITab
      {
         var _loc4_:Sprite = null;
         var _loc1_:UITab = new UITab(QUEST_TAB_LABEL);
         var _loc2_:Sprite = new Sprite();
         this.questsContainer = new Sprite();
         this.questsContainer.x = this.contentInset.x;
         this.questsContainer.y = 10;
         _loc2_.addChild(this.questsContainer);
         var _loc3_:UIScrollbar = new UIScrollbar(SCROLL_BAR_HEIGHT);
         _loc3_.mouseRollSpeedFactor = 1;
         _loc3_.scrollObject = _loc1_;
         _loc3_.content = this.questsContainer;
         _loc2_.addChild(_loc3_);
         _loc3_.x = this.contentInset.x + this.contentInset.width - 25;
         _loc3_.y = 7;
         _loc4_ = new Sprite();
         _loc4_.graphics.beginFill(0);
         _loc4_.graphics.drawRect(0,0,230,SCROLL_BAR_HEIGHT);
         _loc4_.x = this.questsContainer.x;
         _loc4_.y = this.questsContainer.y;
         this.questsContainer.mask = _loc4_;
         _loc2_.addChild(_loc4_);
         _loc1_.addContent(_loc2_);
         return _loc1_;
      }
      
      private function createEventsTab() : UITab
      {
         var _loc1_:UITab = null;
         _loc1_ = new UITab("Events");
         var _loc2_:Sprite = new Sprite();
         this.eventsContainer = new Sprite();
         this.eventsContainer.x = this.contentInset.x;
         this.eventsContainer.y = 10;
         _loc2_.addChild(this.eventsContainer);
         var _loc3_:UIScrollbar = new UIScrollbar(SCROLL_BAR_HEIGHT);
         _loc3_.mouseRollSpeedFactor = 1;
         _loc3_.scrollObject = _loc1_;
         _loc3_.content = this.eventsContainer;
         _loc2_.addChild(_loc3_);
         _loc3_.x = this.contentInset.x + this.contentInset.width - 25;
         _loc3_.y = 7;
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.beginFill(0);
         _loc4_.graphics.drawRect(0,0,230,SCROLL_BAR_HEIGHT);
         _loc4_.x = this.eventsContainer.x;
         _loc4_.y = this.eventsContainer.y;
         this.eventsContainer.mask = _loc4_;
         _loc2_.addChild(_loc4_);
         _loc1_.addContent(_loc2_);
         return _loc1_;
      }
      
      public function addIndicator(param1:Boolean) : void
      {
         this.eventsTab = this._tabs.getTabButtonByLabel(EVENT_TAB_LABEL);
         if(this.eventsTab)
         {
            this.eventsTab.showIndicator = param1;
            this.eventsTab.clickSignal.add(this.onEventsClick);
         }
      }
      
      private function onEventsClick(param1:BaseButton) : void
      {
         if(TabButton(param1).hasIndicator)
         {
            TabButton(param1).showIndicator = false;
         }
      }
      
      public function addQuestToList(param1:DailyQuestListElement) : void
      {
         if(!this._dailyQuestElements)
         {
            this._dailyQuestElements = new Vector.<DailyQuestListElement>(0);
         }
         param1.x = 10;
         param1.y = this.questLinesPosition * 35;
         this.questsContainer.addChild(param1);
         this.questLinesPosition++;
         this._dailyQuestElements.push(param1);
      }
      
      public function addEventToList(param1:DailyQuestListElement) : void
      {
         if(!this._eventQuestElements)
         {
            this._eventQuestElements = new Vector.<DailyQuestListElement>(0);
         }
         param1.x = 10;
         param1.y = this.eventLinesPosition * 35;
         this.eventsContainer.addChild(param1);
         this.eventLinesPosition++;
         this._eventQuestElements.push(param1);
      }
      
      public function get list() : Sprite
      {
         return this.questsContainer;
      }
      
      public function get tabs() : UITabs
      {
         return this._tabs;
      }
      
      public function clearQuestLists() : void
      {
         var _loc1_:DailyQuestListElement = null;
         while(this.questsContainer.numChildren > 0)
         {
            _loc1_ = this.questsContainer.removeChildAt(0) as DailyQuestListElement;
            _loc1_ = null;
         }
         this.questLinesPosition = 0;
         this._dailyQuestElements && (this._dailyQuestElements.length = 0);
         while(this.eventsContainer.numChildren > 0)
         {
            _loc1_ = this.eventsContainer.removeChildAt(0) as DailyQuestListElement;
            _loc1_ = null;
         }
         this.eventLinesPosition = 0;
         this._eventQuestElements && (this._eventQuestElements.length = 0);
      }
      
      public function getCurrentlySelected(param1:String) : DailyQuestListElement
      {
         var _loc2_:DailyQuestListElement = null;
         var _loc3_:DailyQuestListElement = null;
         var _loc4_:DailyQuestListElement = null;
         if(param1 == QUEST_TAB_LABEL)
         {
            for each(_loc3_ in this._dailyQuestElements)
            {
               if(_loc3_.isSelected)
               {
                  _loc2_ = _loc3_;
                  break;
               }
            }
         }
         else if(param1 == EVENT_TAB_LABEL)
         {
            for each(_loc4_ in this._eventQuestElements)
            {
               if(_loc4_.isSelected)
               {
                  _loc2_ = _loc4_;
                  break;
               }
            }
         }
         return _loc2_;
      }
   }
}
