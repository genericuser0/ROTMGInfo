package io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard
{
   import flash.events.Event;
   import io.decagames.rotmg.seasonalEvent.data.LegacySeasonData;
   import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
   import io.decagames.rotmg.seasonalEvent.signals.RequestLegacySeasonSignal;
   import io.decagames.rotmg.seasonalEvent.signals.SeasonalLeaderBoardErrorSignal;
   import io.decagames.rotmg.ui.buttons.BaseButton;
   import io.decagames.rotmg.ui.buttons.SliceScalingButton;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.popups.header.PopupHeader;
   import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
   import io.decagames.rotmg.ui.texture.TextureParser;
   import kabam.rotmg.core.signals.HideTooltipsSignal;
   import kabam.rotmg.core.signals.ShowTooltipSignal;
   import kabam.rotmg.legends.control.FameListUpdateSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class SeasonalLegacyLeaderBoardMediator extends Mediator
   {
       
      
      [Inject]
      public var view:SeasonalLegacyLeaderBoard;
      
      [Inject]
      public var closePopupSignal:ClosePopupSignal;
      
      [Inject]
      public var showTooltipSignal:ShowTooltipSignal;
      
      [Inject]
      public var hideTooltipSignal:HideTooltipsSignal;
      
      [Inject]
      public var seasonalEventModel:SeasonalEventModel;
      
      [Inject]
      public var seasonalLeaderBoardErrorSignal:SeasonalLeaderBoardErrorSignal;
      
      [Inject]
      public var requestLegacySeasonSignal:RequestLegacySeasonSignal;
      
      [Inject]
      public var updateBoardSignal:FameListUpdateSignal;
      
      private var closeButton:SliceScalingButton;
      
      private var _currentSeasonId:String = "";
      
      private var _isActiveSeason:Boolean;
      
      private var _legacyLeaderBoardSeasons:Vector.<LegacySeasonData>;
      
      public function SeasonalLegacyLeaderBoardMediator()
      {
         this._legacyLeaderBoardSeasons = new Vector.<LegacySeasonData>(0);
         super();
      }
      
      override public function initialize() : void
      {
         this.seasonalLeaderBoardErrorSignal.add(this.onLeaderBoardError);
         this.view.header.setTitle("Seasons Leaderboard",480,DefaultLabelFormat.defaultMediumPopupTitle);
         this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","close_button"));
         this.closeButton.clickSignal.addOnce(this.onClose);
         this.view.header.addButton(this.closeButton,PopupHeader.RIGHT_BUTTON);
         this.view.tabs.tabSelectedSignal.add(this.onTabSelected);
         this.setSeasonData();
         this.updateBoardSignal.add(this.updateLeaderBoard);
      }
      
      private function setSeasonData() : void
      {
         var _loc5_:LegacySeasonData = null;
         var _loc1_:Vector.<String> = new Vector.<String>(0);
         var _loc2_:Vector.<LegacySeasonData> = this.seasonalEventModel.legacySeasons;
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_.hasLeaderBoard)
            {
               this._legacyLeaderBoardSeasons.push(_loc5_);
               _loc1_.push(_loc5_.title);
            }
            _loc4_++;
         }
         if(_loc1_.length > 0)
         {
            this._currentSeasonId = "";
            _loc1_.unshift("Click to choose a season!");
            this.view.setDropDownData(_loc1_);
            this.view.dropDown.addEventListener(Event.CHANGE,this.onDropDownChanged);
         }
      }
      
      private function onDropDownChanged(param1:Event) : void
      {
         this.resetLeaderBoard();
         this.showSpinner();
         this._currentSeasonId = this.getSeasonId();
         if(this.isSeasonActive(this._currentSeasonId))
         {
            this.view.tabs.getTabButtonByLabel(SeasonalLeaderBoard.PLAYER_TAB_LABEL).visible = true;
         }
         else
         {
            this.view.tabs.getTabButtonByLabel(SeasonalLeaderBoard.PLAYER_TAB_LABEL).visible = false;
         }
         this.requestLegacySeasonSignal.dispatch(this._currentSeasonId,true);
      }
      
      private function isSeasonActive(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc5_:LegacySeasonData = null;
         var _loc3_:int = this._legacyLeaderBoardSeasons.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._legacyLeaderBoardSeasons[_loc4_];
            if(param1 == _loc5_.seasonId && _loc5_.active)
            {
               _loc2_ = true;
               break;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function resetLeaderBoard() : void
      {
         this.view.clearLeaderBoard();
         this.view.spinner.visible = false;
         this.view.spinner.pause();
         this.seasonalEventModel.leaderboardLegacyTop20ItemDatas = null;
         this.seasonalEventModel.leaderboardLegacyPlayerItemDatas = null;
         this._currentSeasonId = "";
         if(this.view.tabs.currentTabLabel == SeasonalLeaderBoard.PLAYER_TAB_LABEL)
         {
            this.view.tabs.tabSelectedSignal.dispatch(SeasonalLegacyLeaderBoard.TOP_20_TAB_LABEL);
         }
      }
      
      private function getSeasonId() : String
      {
         var _loc1_:String = this.view.dropDown.getValue();
         var _loc2_:String = this.seasonalEventModel.getSeasonIdByTitle(_loc1_);
         return _loc2_;
      }
      
      private function onLeaderBoardError(param1:String) : void
      {
         this.view.clearLeaderBoard();
         this.view.spinner.visible = false;
         this.view.spinner.pause();
         this.view.setErrorMessage(param1);
      }
      
      private function getTimeFormat(param1:Number) : String
      {
         var _loc2_:Date = new Date(param1);
         var _loc3_:String = _loc2_.getHours() > 9?_loc2_.getHours().toString():"0" + _loc2_.getHours();
         var _loc4_:String = _loc2_.getMinutes() > 9?_loc2_.getMinutes().toString():"0" + _loc2_.getMinutes();
         var _loc5_:String = _loc2_.getSeconds() > 9?_loc2_.getSeconds().toString():"0" + _loc2_.getSeconds();
         return _loc3_ + ":" + _loc4_ + ":" + _loc5_;
      }
      
      private function onTabSelected(param1:String) : void
      {
         if(this._currentSeasonId != "")
         {
            this.showSpinner();
            this.updateLeaderBoard();
         }
      }
      
      private function showSpinner() : void
      {
         this.view.spinner.resume();
         this.view.spinner.visible = true;
      }
      
      private function updateLeaderBoard() : void
      {
         if(this.view.tabs.currentTabLabel == SeasonalLeaderBoard.TOP_20_TAB_LABEL)
         {
            if(this.seasonalEventModel.leaderboardLegacyTop20ItemDatas)
            {
               this.upDateTop20();
            }
         }
         else if(this.view.tabs.currentTabLabel == SeasonalLeaderBoard.PLAYER_TAB_LABEL)
         {
            if(this.seasonalEventModel.leaderboardLegacyPlayerItemDatas)
            {
               this.upDatePlayerPosition();
            }
            else
            {
               this.requestLegacySeasonSignal.dispatch(this._currentSeasonId != ""?this._currentSeasonId:this.getSeasonId(),false);
            }
         }
         else
         {
            this.onTabSelected(this.view.tabs.currentTabLabel);
         }
      }
      
      private function upDateTop20() : void
      {
         var _loc2_:SeasonalLeaderBoardItemData = null;
         this.view.clearLeaderBoard();
         this.view.spinner.visible = false;
         this.view.spinner.pause();
         var _loc1_:Vector.<SeasonalLeaderBoardItemData> = this.seasonalEventModel.leaderboardLegacyTop20ItemDatas;
         for each(_loc2_ in _loc1_)
         {
            this.view.addTop20Item(_loc2_);
         }
      }
      
      private function upDatePlayerPosition() : void
      {
         var _loc2_:SeasonalLeaderBoardItemData = null;
         this.view.clearLeaderBoard();
         this.view.spinner.visible = false;
         this.view.spinner.pause();
         var _loc1_:Vector.<SeasonalLeaderBoardItemData> = this.seasonalEventModel.leaderboardLegacyPlayerItemDatas;
         for each(_loc2_ in _loc1_)
         {
            this.view.addPlayerListItem(_loc2_);
         }
      }
      
      override public function destroy() : void
      {
         this.view.dispose();
         this.closeButton.dispose();
         this.seasonalLeaderBoardErrorSignal.remove(this.onLeaderBoardError);
         this.updateBoardSignal.remove(this.updateLeaderBoard);
         if(this.view.dropDown)
         {
            this.view.dropDown.removeEventListener(Event.CHANGE,this.onDropDownChanged);
         }
      }
      
      private function onClose(param1:BaseButton) : void
      {
         this.closePopupSignal.dispatch(this.view);
      }
   }
}
