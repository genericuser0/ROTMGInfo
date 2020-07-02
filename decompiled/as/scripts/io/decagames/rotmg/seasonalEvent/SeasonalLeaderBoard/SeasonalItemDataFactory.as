package io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard
{
   import com.company.util.ConversionUtil;
   import kabam.rotmg.assets.services.CharacterFactory;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.core.model.PlayerModel;
   
   public class SeasonalItemDataFactory
   {
       
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var classesModel:ClassesModel;
      
      [Inject]
      public var factory:CharacterFactory;
      
      private var seasonalLeaderBoardItemDatas:Vector.<SeasonalLeaderBoardItemData>;
      
      public function SeasonalItemDataFactory()
      {
         super();
      }
      
      public function createSeasonalLeaderBoardItemDatas(param1:XML) : Vector.<SeasonalLeaderBoardItemData>
      {
         this.seasonalLeaderBoardItemDatas = new Vector.<SeasonalLeaderBoardItemData>(0);
         this.createItemsFromList(param1.FameListElem);
         return this.seasonalLeaderBoardItemDatas;
      }
      
      private function createItemsFromList(param1:XMLList) : void
      {
         var _loc2_:XML = null;
         var _loc3_:SeasonalLeaderBoardItemData = null;
         for each(_loc2_ in param1)
         {
            if(!this.seasonalLeaderBoardItemDatasContains(_loc2_))
            {
               _loc3_ = this.createSeasonalLeaderBoardItemData(_loc2_);
               _loc3_.isOwn = _loc2_.Name == this.playerModel.getName();
               this.seasonalLeaderBoardItemDatas.push(_loc3_);
            }
         }
      }
      
      private function seasonalLeaderBoardItemDatasContains(param1:XML) : Boolean
      {
         var _loc2_:SeasonalLeaderBoardItemData = null;
         for each(_loc2_ in this.seasonalLeaderBoardItemDatas)
         {
            if(_loc2_.accountId == param1.@accountId && _loc2_.charId == param1.@charId)
            {
               return true;
            }
         }
         return false;
      }
      
      public function createSeasonalLeaderBoardItemData(param1:XML) : SeasonalLeaderBoardItemData
      {
         var _loc2_:int = param1.ObjectType;
         var _loc3_:int = param1.Texture;
         var _loc4_:CharacterClass = this.classesModel.getCharacterClass(_loc2_);
         var _loc5_:CharacterSkin = _loc4_.skins.getSkin(_loc3_);
         var _loc6_:int = !!param1.hasOwnProperty("Tex1")?int(param1.Tex1):0;
         var _loc7_:int = !!param1.hasOwnProperty("Tex2")?int(param1.Tex2):0;
         var _loc8_:int = !!_loc5_.is16x16?50:100;
         var _loc9_:SeasonalLeaderBoardItemData = new SeasonalLeaderBoardItemData();
         _loc9_.rank = param1.Rank;
         _loc9_.accountId = param1.@accountId;
         _loc9_.charId = param1.@charId;
         _loc9_.name = param1.Name;
         _loc9_.totalFame = param1.TotalFame;
         _loc9_.character = this.factory.makeIcon(_loc5_.template,_loc8_,_loc6_,_loc7_,_loc9_.rank <= 10);
         _loc9_.equipmentSlots = _loc4_.slotTypes;
         _loc9_.equipment = ConversionUtil.toIntVector(param1.Equipment);
         return _loc9_;
      }
   }
}
