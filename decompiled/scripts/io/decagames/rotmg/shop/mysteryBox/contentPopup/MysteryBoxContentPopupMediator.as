package io.decagames.rotmg.shop.mysteryBox.contentPopup
{
   import flash.utils.Dictionary;
   import io.decagames.rotmg.ui.buttons.BaseButton;
   import io.decagames.rotmg.ui.buttons.SliceScalingButton;
   import io.decagames.rotmg.ui.gird.UIGrid;
   import io.decagames.rotmg.ui.popups.header.PopupHeader;
   import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
   import io.decagames.rotmg.ui.texture.TextureParser;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class MysteryBoxContentPopupMediator extends Mediator
   {
       
      
      [Inject]
      public var view:MysteryBoxContentPopup;
      
      [Inject]
      public var closePopupSignal:ClosePopupSignal;
      
      private var closeButton:SliceScalingButton;
      
      private var contentGrids:Vector.<UIGrid>;
      
      private var jackpotsNumber:int = 0;
      
      private var jackpotsHeight:int = 0;
      
      private var jackpotUI:JackpotContainer;
      
      public function MysteryBoxContentPopupMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","close_button"));
         this.closeButton.clickSignal.addOnce(this.onClose);
         this.view.header.addButton(this.closeButton,PopupHeader.RIGHT_BUTTON);
         this.addJackpots(this.view.info.jackpots);
         this.addContentList(this.view.info.contents,this.view.info.jackpots);
      }
      
      private function addJackpots(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:UIGrid = null;
         var _loc10_:UIItemContainer = null;
         var _loc11_:int = 0;
         var _loc2_:Array = param1.split("|");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.split(",");
            _loc5_ = [];
            _loc6_ = [];
            for each(_loc7_ in _loc4_)
            {
               _loc8_ = _loc5_.indexOf(_loc7_);
               if(_loc8_ == -1)
               {
                  _loc5_.push(_loc7_);
                  _loc6_.push(1);
               }
               else
               {
                  _loc6_[_loc8_] = _loc6_[_loc8_] + 1;
               }
            }
            if(param1.length > 0)
            {
               _loc9_ = new UIGrid(220,5,4);
               _loc9_.centerLastRow = true;
               for each(_loc7_ in _loc5_)
               {
                  _loc10_ = new UIItemContainer(int(_loc7_),4737096,0,40);
                  _loc10_.showTooltip = true;
                  _loc9_.addGridElement(_loc10_);
                  _loc11_ = _loc6_[_loc5_.indexOf(_loc7_)];
                  if(_loc11_ > 1)
                  {
                     _loc10_.showQuantityLabel(_loc11_);
                  }
               }
               this.jackpotUI = new JackpotContainer();
               this.jackpotUI.x = 10;
               this.jackpotUI.y = 55 + this.jackpotsHeight - 22;
               if(this.jackpotsNumber == 0)
               {
                  this.jackpotUI.diamondBackground();
               }
               else if(this.jackpotsNumber == 1)
               {
                  this.jackpotUI.goldBackground();
               }
               else if(this.jackpotsNumber == 2)
               {
                  this.jackpotUI.silverBackground();
               }
               this.jackpotUI.addGrid(_loc9_);
               this.view.addChild(this.jackpotUI);
               this.jackpotsHeight = this.jackpotsHeight + (this.jackpotUI.height + 5);
               this.jackpotsNumber++;
            }
         }
      }
      
      private function addContentList(param1:String, param2:String) : void
      {
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:String = null;
         var _loc16_:Boolean = false;
         var _loc17_:String = null;
         var _loc18_:Array = null;
         var _loc19_:UIGrid = null;
         var _loc20_:Array = null;
         var _loc21_:Vector.<ItemBox> = null;
         var _loc22_:Dictionary = null;
         var _loc23_:String = null;
         var _loc24_:Array = null;
         var _loc25_:String = null;
         var _loc26_:ItemsSetBox = null;
         var _loc27_:ItemBox = null;
         var _loc3_:Array = param1.split("|");
         var _loc4_:Array = param2.split("|");
         var _loc5_:Array = [];
         var _loc6_:int = 0;
         for each(_loc7_ in _loc3_)
         {
            _loc13_ = [];
            _loc14_ = _loc7_.split(";");
            for each(_loc15_ in _loc14_)
            {
               _loc16_ = false;
               for each(_loc17_ in _loc4_)
               {
                  if(_loc17_ == _loc15_)
                  {
                     _loc16_ = true;
                     break;
                  }
               }
               if(!_loc16_)
               {
                  _loc18_ = _loc15_.split(",");
                  _loc13_.push(_loc18_);
               }
            }
            _loc5_[_loc6_] = _loc13_;
            _loc6_++;
         }
         _loc8_ = 486 - 11;
         _loc9_ = 30;
         if(this.jackpotsNumber > 0)
         {
            _loc8_ = _loc8_ - (this.jackpotsHeight + 10);
            _loc9_ = _loc9_ + (this.jackpotsHeight + 10);
         }
         this.contentGrids = new Vector.<UIGrid>(0);
         var _loc10_:int = 5;
         var _loc11_:Number = (260 - _loc10_ * (_loc5_.length - 1)) / _loc5_.length;
         for each(_loc12_ in _loc5_)
         {
            _loc19_ = new UIGrid(_loc11_,1,5);
            for each(_loc20_ in _loc12_)
            {
               _loc21_ = new Vector.<ItemBox>();
               _loc22_ = new Dictionary();
               for each(_loc23_ in _loc20_)
               {
                  if(_loc22_[_loc23_])
                  {
                     _loc22_[_loc23_]++;
                  }
                  else
                  {
                     _loc22_[_loc23_] = 1;
                  }
               }
               _loc24_ = [];
               for each(_loc25_ in _loc20_)
               {
                  if(_loc24_.indexOf(_loc25_) == -1)
                  {
                     _loc27_ = new ItemBox(_loc25_,_loc22_[_loc25_],_loc5_.length == 1,"",false);
                     _loc27_.clearBackground();
                     _loc21_.push(_loc27_);
                     _loc24_.push(_loc25_);
                  }
               }
               _loc26_ = new ItemsSetBox(_loc21_);
               _loc19_.addGridElement(_loc26_);
            }
            _loc19_.y = _loc9_;
            _loc19_.x = 10 + _loc11_ * this.contentGrids.length + _loc10_ * this.contentGrids.length;
            this.view.addChild(_loc19_);
            this.contentGrids.push(_loc19_);
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:UIGrid = null;
         this.closeButton.dispose();
         for each(_loc1_ in this.contentGrids)
         {
            _loc1_.dispose();
         }
         this.contentGrids = null;
      }
      
      private function onClose(param1:BaseButton) : void
      {
         this.closePopupSignal.dispatch(this.view);
      }
   }
}
