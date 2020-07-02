package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.map.AbstractMap;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFormatAlign;
   import flash.utils.getTimer;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.labels.UILabel;
   import io.decagames.rotmg.ui.texture.TextureParser;
   import kabam.rotmg.game.model.QuestModel;
   
   public class RealmQuestsDisplay extends Sprite
   {
      
      public static const NUMBER_OF_QUESTS:int = 3;
       
      
      private const CONTENT_ALPHA:Number = 0.7;
      
      private const QUEST_DESCRIPTION:String = "Free %s from Oryx\'s Minions!";
      
      private const REQUIREMENT_TEXT_01:String = "Reach <font color=\'#00FF00\'><b>Level 20</b></font> and become stronger.";
      
      private const REQUIREMENT_TEXT_02:String = "Defeat <font color=\'#00FF00\'><b>%d remaining</b></font> Heroes of Oryx.";
      
      private const REQUIREMENT_TEXT_03:String = "Defeat <font color=\'#00FF00\'><b>Oryx the Mad God</b></font> in his Castle.";
      
      private const REQUIREMENTS_TEXTS:Vector.<String> = new <String>[this.REQUIREMENT_TEXT_01,this.REQUIREMENT_TEXT_02,this.REQUIREMENT_TEXT_03];
      
      private var _realmLabel:UILabel;
      
      private var _realmName:String;
      
      private var _isOpen:Boolean;
      
      private var _content:Sprite;
      
      private var _buttonContainer:Sprite;
      
      private var _buttonContainerGraphics:Graphics;
      
      private var _buttonDiamondContainer:Sprite;
      
      private var _buttonNameContainer:Sprite;
      
      private var _buttonContent:Sprite;
      
      private var _arrow:Bitmap;
      
      private var _realmQuestDiamonds:Vector.<Bitmap>;
      
      private var _realmQuestItems:Vector.<RealmQuestItem>;
      
      private var _map:AbstractMap;
      
      private var _requirementsStates:Vector.<Boolean>;
      
      private var _currentQuestHero:String;
      
      public function RealmQuestsDisplay(param1:AbstractMap)
      {
         super();
         this.tabChildren = false;
         this._map = param1;
      }
      
      public function toggleOpenState() : void
      {
         this._isOpen = !this._isOpen;
         this.alphaTweenContent(this.CONTENT_ALPHA);
         this._arrow.scaleY = !!this._isOpen?Number(1):Number(-1);
         this._arrow.y = !!this._isOpen?Number(3):Number(this._arrow.height + 2);
         this._buttonDiamondContainer.visible = !this._isOpen;
         this._buttonNameContainer.visible = this._isOpen;
         this._buttonContent.visible = this._isOpen;
         Parameters.data_.expandRealmQuestsDisplay = this._isOpen;
      }
      
      public function init() : void
      {
         var _loc1_:GameObject = this._map.quest_.getObject(int(getTimer()));
         if(_loc1_)
         {
            this._currentQuestHero = this._map.quest_.getObject(int(getTimer())).name_;
         }
         this.createContainers();
         this.createArrow();
         this.createRealmLabel();
         this.createDiamonds();
         this.createRealmQuestItems();
         if(Parameters.data_.expandRealmQuestsDisplay)
         {
            this.toggleOpenState();
         }
      }
      
      private function createContainers() : void
      {
         this._content = new Sprite();
         this._content.alpha = this.CONTENT_ALPHA;
         this._content.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this._content.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addChild(this._content);
         this._buttonContainer = new Sprite();
         this._buttonContainerGraphics = this._buttonContainer.graphics;
         this._buttonContainer.buttonMode = true;
         this._buttonContainer.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         this._content.addChild(this._buttonContainer);
         this._buttonDiamondContainer = new Sprite();
         this._buttonDiamondContainer.mouseEnabled = false;
         this._buttonContainer.addChild(this._buttonDiamondContainer);
         this._buttonNameContainer = new Sprite();
         this._buttonNameContainer.mouseEnabled = false;
         this._buttonNameContainer.visible = this._isOpen;
         this._buttonContainer.addChild(this._buttonNameContainer);
         this._buttonContent = new Sprite();
         this._buttonContent.mouseEnabled = false;
         this._buttonContent.mouseChildren = false;
         this._buttonContent.visible = this._isOpen;
         this._content.addChild(this._buttonContent);
         this._realmQuestDiamonds = new Vector.<Bitmap>(0);
      }
      
      private function createArrow() : void
      {
         this._arrow = TextureParser.instance.getTexture("UI","spinner_up_arrow");
         this._buttonContainer.addChild(this._arrow);
      }
      
      private function createRealmLabel() : void
      {
         this._realmLabel = new UILabel();
         DefaultLabelFormat.createLabelFormat(this._realmLabel,16,16777215,TextFormatAlign.LEFT,true);
         this._realmLabel.x = 20;
         this._realmLabel.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         this._buttonNameContainer.addChild(this._realmLabel);
      }
      
      private function createDiamonds() : void
      {
         var _loc2_:String = null;
         var _loc3_:Bitmap = null;
         var _loc1_:int = 0;
         while(_loc1_ < NUMBER_OF_QUESTS)
         {
            _loc2_ = !!this._requirementsStates[_loc1_]?"checkbox_filled":"checkbox_empty";
            _loc3_ = TextureParser.instance.getTexture("UI",_loc2_);
            _loc3_.x = _loc1_ * (_loc3_.width + 5) + this._arrow.width + 5;
            this._buttonDiamondContainer.addChild(_loc3_);
            this.setHitArea(this._buttonContainer);
            this._realmQuestDiamonds.push(_loc3_);
            _loc1_++;
         }
      }
      
      private function disposeDiamonds() : void
      {
         var _loc2_:Bitmap = null;
         var _loc1_:int = NUMBER_OF_QUESTS - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = this._realmQuestDiamonds.pop();
            _loc2_.bitmapData.dispose();
            this._buttonDiamondContainer.removeChild(_loc2_);
            _loc2_ = null;
            _loc1_--;
         }
      }
      
      private function createRealmQuestItems() : void
      {
         var _loc3_:RealmQuestItem = null;
         var _loc1_:int = 28;
         this._realmQuestItems = new Vector.<RealmQuestItem>(0);
         var _loc2_:int = 0;
         while(_loc2_ < NUMBER_OF_QUESTS)
         {
            _loc3_ = new RealmQuestItem(this.REQUIREMENTS_TEXTS[_loc2_],this._requirementsStates[_loc2_]);
            _loc3_.updateItemState(false);
            _loc3_.x = 20;
            _loc3_.y = _loc1_ + 5;
            _loc1_ = _loc3_.y + _loc3_.height;
            this._buttonContent.addChild(_loc3_);
            this._realmQuestItems.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function createQuestDescription() : void
      {
         var _loc1_:UILabel = new UILabel();
         _loc1_.x = 20;
         _loc1_.y = 15;
         _loc1_.text = this.QUEST_DESCRIPTION.replace("%s",this._realmName);
         DefaultLabelFormat.createLabelFormat(_loc1_,12,16763904);
         _loc1_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         this._buttonContent.addChild(_loc1_);
      }
      
      private function alphaTweenContent(param1:Number) : void
      {
         if(TweenMax.isTweening(this._content))
         {
            TweenMax.killTweensOf(this._content);
         }
         TweenMax.to(this._content,0.3,{"alpha":param1});
      }
      
      private function setHitArea(param1:Sprite) : void
      {
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.clear();
         _loc2_.graphics.beginFill(16763904,0);
         _loc2_.graphics.drawRect(0,0,param1.width,param1.height);
         param1.addChild(_loc2_);
      }
      
      private function updateDiamonds() : void
      {
         this.disposeDiamonds();
         this.createDiamonds();
      }
      
      private function completeRealmQuestItem(param1:RealmQuestItem) : void
      {
         param1.updateItemState(true);
         param1.updateItemText("<font color=\'#a8a8a8\'>" + param1.label.text + "</font>");
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         this.toggleOpenState();
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         if(TweenMax.isTweening(this._content))
         {
            TweenMax.killTweensOf(this._content);
         }
         TweenMax.to(this._content,0.3,{"alpha":1});
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this.alphaTweenContent(this.CONTENT_ALPHA);
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         if(Parameters.isGpuRender())
         {
            this._map.mapHitArea.dispatchEvent(param1);
         }
         else
         {
            this._map.dispatchEvent(param1);
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         if(Parameters.isGpuRender())
         {
            this._map.mapHitArea.dispatchEvent(param1);
         }
         else
         {
            this._map.dispatchEvent(param1);
         }
      }
      
      public function set realmName(param1:String) : void
      {
         this._realmName = param1;
         this._realmLabel.text = this._realmName;
         this.setHitArea(this._buttonNameContainer);
         this.createQuestDescription();
      }
      
      public function set level(param1:int) : void
      {
         var _loc2_:RealmQuestItem = this._realmQuestItems[QuestModel.LEVEL_REQUIREMENT];
         var _loc3_:* = param1 == 20;
         this._requirementsStates[QuestModel.LEVEL_REQUIREMENT] = _loc3_;
         if(_loc3_)
         {
            this.completeRealmQuestItem(_loc2_);
         }
         else
         {
            _loc2_.updateItemState(false);
         }
         this.updateDiamonds();
      }
      
      public function set remainingHeroes(param1:int) : void
      {
         var _loc2_:RealmQuestItem = this._realmQuestItems[QuestModel.REMAINING_HEROES_REQUIREMENT];
         _loc2_.updateItemText(this.REQUIREMENT_TEXT_02.replace("%d",param1));
         var _loc3_:* = param1 == 0;
         this._requirementsStates[QuestModel.REMAINING_HEROES_REQUIREMENT] = _loc3_;
         if(_loc3_)
         {
            this.completeRealmQuestItem(_loc2_);
         }
         else
         {
            _loc2_.updateItemState(false);
         }
         this.updateDiamonds();
      }
      
      public function setOryxCompleted() : void
      {
         this._requirementsStates[QuestModel.ORYX_KILLED] = true;
         var _loc1_:RealmQuestItem = this._realmQuestItems[QuestModel.ORYX_KILLED];
         this.completeRealmQuestItem(_loc1_);
         this.updateDiamonds();
      }
      
      public function set requirementsStates(param1:Vector.<Boolean>) : void
      {
         this._requirementsStates = param1;
      }
      
      public function get requirementsStates() : Vector.<Boolean>
      {
         return this._requirementsStates;
      }
   }
}
