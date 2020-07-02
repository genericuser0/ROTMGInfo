package io.decagames.rotmg.shop.packages.contentPopup
{
   import flash.utils.Dictionary;
   import io.decagames.rotmg.shop.mysteryBox.contentPopup.ItemBox;
   import io.decagames.rotmg.shop.mysteryBox.contentPopup.SlotBox;
   import io.decagames.rotmg.ui.buttons.BaseButton;
   import io.decagames.rotmg.ui.buttons.SliceScalingButton;
   import io.decagames.rotmg.ui.gird.UIGrid;
   import io.decagames.rotmg.ui.popups.header.PopupHeader;
   import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
   import io.decagames.rotmg.ui.texture.TextureParser;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class PackageBoxContentPopupMediator extends Mediator
   {
       
      
      [Inject]
      public var view:PackageBoxContentPopup;
      
      [Inject]
      public var closePopupSignal:ClosePopupSignal;
      
      private var closeButton:SliceScalingButton;
      
      private var contentGrids:UIGrid;
      
      public function PackageBoxContentPopupMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","close_button"));
         this.closeButton.clickSignal.addOnce(this.onClose);
         this.view.header.addButton(this.closeButton,PopupHeader.RIGHT_BUTTON);
         this.addContentList(this.view.info.contents,this.view.info.charSlot,this.view.info.vaultSlot,this.view.info.gold);
      }
      
      private function addContentList(param1:String, param2:int, param3:int, param4:int) : void
      {
         var _loc7_:Array = null;
         var _loc8_:Dictionary = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc12_:ItemBox = null;
         var _loc13_:SlotBox = null;
         var _loc14_:SlotBox = null;
         var _loc15_:SlotBox = null;
         var _loc5_:int = 5;
         var _loc6_:Number = 260 - _loc5_;
         this.contentGrids = new UIGrid(_loc6_,1,2);
         if(param1 != "")
         {
            _loc7_ = param1.split(",");
            _loc8_ = new Dictionary();
            for each(_loc9_ in _loc7_)
            {
               if(_loc8_[_loc9_])
               {
                  _loc8_[_loc9_]++;
               }
               else
               {
                  _loc8_[_loc9_] = 1;
               }
            }
            _loc10_ = [];
            for each(_loc11_ in _loc7_)
            {
               if(_loc10_.indexOf(_loc11_) == -1)
               {
                  _loc12_ = new ItemBox(_loc11_,_loc8_[_loc11_],true,"",false);
                  this.contentGrids.addGridElement(_loc12_);
                  _loc10_.push(_loc11_);
               }
            }
         }
         if(param2 > 0)
         {
            _loc13_ = new SlotBox(SlotBox.CHAR_SLOT,param2,true,"",false);
            this.contentGrids.addGridElement(_loc13_);
         }
         if(param3 > 0)
         {
            _loc14_ = new SlotBox(SlotBox.VAULT_SLOT,param3,true,"",false);
            this.contentGrids.addGridElement(_loc14_);
         }
         if(param4 > 0)
         {
            _loc15_ = new SlotBox(SlotBox.GOLD_SLOT,param4,true,"",false);
            this.contentGrids.addGridElement(_loc15_);
         }
         this.contentGrids.y = this.view.infoLabel.textHeight + 8;
         this.contentGrids.x = 10;
         this.view.addChild(this.contentGrids);
      }
      
      override public function destroy() : void
      {
         this.closeButton.clickSignal.remove(this.onClose);
         this.closeButton.dispose();
         this.contentGrids.dispose();
         this.contentGrids = null;
      }
      
      private function onClose(param1:BaseButton) : void
      {
         this.closePopupSignal.dispatch(this.view);
      }
   }
}
