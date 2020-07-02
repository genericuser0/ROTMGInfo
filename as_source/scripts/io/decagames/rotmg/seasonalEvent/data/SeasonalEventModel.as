package io.decagames.rotmg.seasonalEvent.data
{
   import com.company.assembleegameclient.screens.LeagueData;
   import io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard.SeasonalLeaderBoardItemData;
   import io.decagames.rotmg.seasonalEvent.config.SeasonalConfig;
   import robotlegs.bender.framework.api.IContext;
   
   public class SeasonalEventModel
   {
       
      
      [Inject]
      public var context:IContext;
      
      private var _isSeasonalMode:Boolean;
      
      private var _leagueDatas:Vector.<LeagueData>;
      
      private var _seasonTitle:String;
      
      private var _isChallenger:int;
      
      private var _rulesAndDescription:String;
      
      private var _scheduledSeasonalEvent:Date;
      
      private var _startTime:Date;
      
      private var _endTime:Date;
      
      private var _accountCreatedBefore:Date;
      
      private var _maxCharacters:int;
      
      private var _maxPetYardLevel:int;
      
      private var _remainingCharacters:int;
      
      private var _leaderboardTop20RefreshTime:Date;
      
      private var _leaderboardTop20CreateTime:Date;
      
      private var _leaderboardPlayerRefreshTime:Date;
      
      private var _leaderboardPlayerCreateTime:Date;
      
      private var _leaderboardTop20ItemDatas:Vector.<SeasonalLeaderBoardItemData>;
      
      private var _leaderboardLegacyTop20ItemDatas:Vector.<SeasonalLeaderBoardItemData>;
      
      private var _leaderboardPlayerItemDatas:Vector.<SeasonalLeaderBoardItemData>;
      
      private var _leaderboardLegacyPlayerItemDatas:Vector.<SeasonalLeaderBoardItemData>;
      
      private var _legacySeasons:Vector.<LegacySeasonData>;
      
      public function SeasonalEventModel()
      {
         super();
      }
      
      public function parseConfigData(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:LeagueData = null;
         var _loc2_:XMLList = param1.Season;
         if(_loc2_.length() > 0)
         {
            this._leagueDatas = new Vector.<LeagueData>(0);
            for each(_loc3_ in _loc2_)
            {
               this._startTime = new Date(int(_loc3_.Start) * 1000);
               this._endTime = new Date(int(_loc3_.End) * 1000);
               this._maxCharacters = _loc3_.MaxLives;
               this._maxPetYardLevel = _loc3_.MaxPetYardLevel;
               this._accountCreatedBefore = new Date(_loc3_.AccountCreatedBefore * 1000);
               if(this.getSecondsToStart(this._startTime) <= 0 && !this.hasSeasonEnded(this._endTime))
               {
                  this._rulesAndDescription = _loc3_.Information;
                  _loc4_ = new LeagueData();
                  _loc4_.maxCharacters = this._maxCharacters;
                  _loc4_.leagueType = SeasonalConstants.CHALLENGER_LEAGUE_TYPE;
                  _loc4_.title = this._seasonTitle = _loc3_.@title;
                  _loc4_.endDate = this._endTime;
                  _loc4_.description = _loc3_.Description;
                  _loc4_.quote = "";
                  _loc4_.panelBackgroundId = SeasonalConstants.CHALLENGER_PANEL_BACKGROUND_ID;
                  _loc4_.characterId = SeasonalConstants.CHALLENGER_CHARACTER_ID;
                  this._leagueDatas.push(_loc4_);
                  this._isSeasonalMode = true;
               }
               else if(this.getSecondsToStart(this._startTime) > 0)
               {
                  this._isSeasonalMode = false;
                  this.setScheduledStartTime(this._startTime);
               }
               else
               {
                  this._isSeasonalMode = false;
               }
            }
            if(this._leagueDatas.length > 0)
            {
               this._leagueDatas.unshift(this.addLegacyLeagueData());
            }
         }
         if(this._isSeasonalMode)
         {
            this.context.configure(SeasonalConfig);
         }
      }
      
      public function parseLegacySeasonsData(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:LegacySeasonData = null;
         var _loc2_:XMLList = param1.Season;
         if(_loc2_.length() > 0)
         {
            this._legacySeasons = new Vector.<LegacySeasonData>(0);
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = new LegacySeasonData();
               _loc4_.seasonId = _loc3_.@id;
               _loc4_.title = _loc3_.Title;
               _loc4_.active = _loc3_.hasOwnProperty("Active");
               _loc4_.timeValid = _loc3_.hasOwnProperty("TimeValid");
               _loc4_.hasLeaderBoard = _loc3_.hasOwnProperty("HasLeaderboard");
               _loc4_.startTime = new Date(int(_loc3_.StartTime) * 1000);
               _loc4_.endTime = new Date(int(_loc3_.EndTime) * 1000);
               this._legacySeasons.push(_loc4_);
            }
         }
      }
      
      public function getSeasonIdByTitle(param1:String) : String
      {
         var _loc5_:LegacySeasonData = null;
         var _loc2_:String = "";
         var _loc3_:int = this._legacySeasons.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._legacySeasons[_loc4_];
            if(_loc5_.title == param1)
            {
               _loc2_ = _loc5_.seasonId;
               break;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function setScheduledStartTime(param1:Date) : void
      {
         this._scheduledSeasonalEvent = param1;
      }
      
      private function getSecondsToStart(param1:Date) : Number
      {
         var _loc2_:Date = new Date();
         return (param1.time - _loc2_.time) / 1000;
      }
      
      private function hasSeasonEnded(param1:Date) : Boolean
      {
         var _loc2_:Date = new Date();
         return (param1.time - _loc2_.time) / 1000 <= 0;
      }
      
      private function addLegacyLeagueData() : LeagueData
      {
         var _loc1_:LeagueData = new LeagueData();
         _loc1_.maxCharacters = -1;
         _loc1_.leagueType = SeasonalConstants.LEGACY_LEAGUE_TYPE;
         _loc1_.title = "Original";
         _loc1_.description = "The original Realm of the Mad God. This is a gathering place for every Hero in the Realm of the Mad God.";
         _loc1_.quote = "The experience you have come to know, all your previous progress and achievements.";
         _loc1_.panelBackgroundId = SeasonalConstants.LEGACY_PANEL_BACKGROUND_ID;
         _loc1_.characterId = SeasonalConstants.LEGACY_CHARACTER_ID;
         return _loc1_;
      }
      
      public function get isSeasonalMode() : Boolean
      {
         return this._isSeasonalMode;
      }
      
      public function set isSeasonalMode(param1:Boolean) : void
      {
         this._isSeasonalMode = param1;
      }
      
      public function get leagueDatas() : Vector.<LeagueData>
      {
         return this._leagueDatas;
      }
      
      public function get isChallenger() : int
      {
         return this._isChallenger;
      }
      
      public function set isChallenger(param1:int) : void
      {
         this._isChallenger = param1;
      }
      
      public function get seasonTitle() : String
      {
         return this._seasonTitle;
      }
      
      public function get rulesAndDescription() : String
      {
         return this._rulesAndDescription;
      }
      
      public function get scheduledSeasonalEvent() : Date
      {
         return this._scheduledSeasonalEvent;
      }
      
      public function get maxCharacters() : int
      {
         return this._maxCharacters;
      }
      
      public function get remainingCharacters() : int
      {
         return this._remainingCharacters;
      }
      
      public function set remainingCharacters(param1:int) : void
      {
         this._remainingCharacters = param1;
      }
      
      public function get accountCreatedBefore() : Date
      {
         return this._accountCreatedBefore;
      }
      
      public function get leaderboardTop20RefreshTime() : Date
      {
         return this._leaderboardTop20RefreshTime;
      }
      
      public function set leaderboardTop20RefreshTime(param1:Date) : void
      {
         this._leaderboardTop20RefreshTime = param1;
      }
      
      public function get leaderboardPlayerRefreshTime() : Date
      {
         return this._leaderboardPlayerRefreshTime;
      }
      
      public function set leaderboardPlayerRefreshTime(param1:Date) : void
      {
         this._leaderboardPlayerRefreshTime = param1;
      }
      
      public function get leaderboardTop20ItemDatas() : Vector.<SeasonalLeaderBoardItemData>
      {
         return this._leaderboardTop20ItemDatas;
      }
      
      public function set leaderboardTop20ItemDatas(param1:Vector.<SeasonalLeaderBoardItemData>) : void
      {
         this._leaderboardTop20ItemDatas = param1;
      }
      
      public function get leaderboardPlayerItemDatas() : Vector.<SeasonalLeaderBoardItemData>
      {
         return this._leaderboardPlayerItemDatas;
      }
      
      public function set leaderboardPlayerItemDatas(param1:Vector.<SeasonalLeaderBoardItemData>) : void
      {
         this._leaderboardPlayerItemDatas = param1;
      }
      
      public function get leaderboardTop20CreateTime() : Date
      {
         return this._leaderboardTop20CreateTime;
      }
      
      public function set leaderboardTop20CreateTime(param1:Date) : void
      {
         this._leaderboardTop20CreateTime = param1;
      }
      
      public function get leaderboardPlayerCreateTime() : Date
      {
         return this._leaderboardPlayerCreateTime;
      }
      
      public function set leaderboardPlayerCreateTime(param1:Date) : void
      {
         this._leaderboardPlayerCreateTime = param1;
      }
      
      public function get maxPetYardLevel() : int
      {
         return this._maxPetYardLevel;
      }
      
      public function get legacySeasons() : Vector.<LegacySeasonData>
      {
         return this._legacySeasons;
      }
      
      public function get leaderboardLegacyTop20ItemDatas() : Vector.<SeasonalLeaderBoardItemData>
      {
         return this._leaderboardLegacyTop20ItemDatas;
      }
      
      public function set leaderboardLegacyTop20ItemDatas(param1:Vector.<SeasonalLeaderBoardItemData>) : void
      {
         this._leaderboardLegacyTop20ItemDatas = param1;
      }
      
      public function get leaderboardLegacyPlayerItemDatas() : Vector.<SeasonalLeaderBoardItemData>
      {
         return this._leaderboardLegacyPlayerItemDatas;
      }
      
      public function set leaderboardLegacyPlayerItemDatas(param1:Vector.<SeasonalLeaderBoardItemData>) : void
      {
         this._leaderboardLegacyPlayerItemDatas = param1;
      }
   }
}
