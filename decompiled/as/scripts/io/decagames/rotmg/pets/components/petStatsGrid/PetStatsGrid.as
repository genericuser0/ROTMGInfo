package io.decagames.rotmg.pets.components.petStatsGrid
{
   import flash.text.TextFormatAlign;
   import io.decagames.rotmg.pets.data.vo.AbilityVO;
   import io.decagames.rotmg.pets.data.vo.IPetVO;
   import io.decagames.rotmg.ui.ProgressBar;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.gird.UIGrid;
   
   public class PetStatsGrid extends UIGrid
   {
       
      
      private var _petVO:IPetVO;
      
      private var abilityBars:Vector.<ProgressBar>;
      
      public function PetStatsGrid(param1:int, param2:IPetVO)
      {
         super(param1,1,3);
         this.abilityBars = new Vector.<ProgressBar>();
         this._petVO = param2;
         if(param2)
         {
            this.refreshAbilities(param2);
         }
      }
      
      public function renderSimulation(param1:Array) : void
      {
         var _loc3_:AbilityVO = null;
         var _loc2_:int = 0;
         for each(_loc3_ in param1)
         {
            this.renderAbilitySimulation(_loc3_,_loc2_);
            _loc2_++;
         }
      }
      
      private function refreshAbilities(param1:IPetVO) : void
      {
         var _loc3_:AbilityVO = null;
         var _loc2_:int = 0;
         for each(_loc3_ in param1.abilityList)
         {
            this.renderAbility(_loc3_,_loc2_);
            _loc2_++;
         }
      }
      
      private function renderAbilitySimulation(param1:AbilityVO, param2:int) : void
      {
         if(param1.getUnlocked())
         {
            this.abilityBars[param2].simulatedValue = param1.level;
         }
      }
      
      private function renderAbility(param1:AbilityVO, param2:int) : void
      {
         var _loc3_:ProgressBar = null;
         if(this.abilityBars.length > param2)
         {
            _loc3_ = this.abilityBars[param2];
            if(_loc3_.maxValue != this._petVO.maxAbilityPower && param1.getUnlocked())
            {
               _loc3_.maxValue = this._petVO.maxAbilityPower;
               _loc3_.value = param1.level;
            }
            if(_loc3_.value != param1.level && param1.getUnlocked())
            {
               _loc3_.dynamicLabelString = "Lvl. " + ProgressBar.DYNAMIC_LABEL_TOKEN + "/" + ProgressBar.MAX_VALUE_TOKEN;
               _loc3_.value = param1.level;
            }
         }
         else
         {
            _loc3_ = new ProgressBar(150,4,param1.name,!!param1.getUnlocked()?"Lvl. " + ProgressBar.DYNAMIC_LABEL_TOKEN + "/" + ProgressBar.MAX_VALUE_TOKEN:"",0,this._petVO.maxAbilityPower,!!param1.getUnlocked()?int(param1.level):0,5526612,15306295,6538829);
            _loc3_.showMaxLabel = true;
            _loc3_.maxColor = 6538829;
            DefaultLabelFormat.petStatLabelLeft(_loc3_.staticLabel,16777215);
            DefaultLabelFormat.petStatLabelRight(_loc3_.dynamicLabel,16777215);
            DefaultLabelFormat.petStatLabelRight(_loc3_.maxLabel,6538829,true);
            _loc3_.simulatedValueTextFormat = DefaultLabelFormat.createTextFormat(12,6538829,TextFormatAlign.RIGHT,true);
            this.abilityBars.push(_loc3_);
            addGridElement(_loc3_);
         }
         if(!param1.getUnlocked())
         {
            _loc3_.alpha = 0.4;
         }
         else
         {
            if(_loc3_.alpha != 1)
            {
               _loc3_.dynamicLabelString = "Lvl. " + ProgressBar.DYNAMIC_LABEL_TOKEN + "/" + ProgressBar.MAX_VALUE_TOKEN;
               _loc3_.maxValue = this._petVO.maxAbilityPower;
               _loc3_.value = param1.level;
            }
            _loc3_.alpha = 1;
         }
      }
      
      public function updateVO(param1:IPetVO) : void
      {
         if(this._petVO != param1)
         {
            this.abilityBars = new Vector.<ProgressBar>();
            clearGrid();
         }
         this._petVO = param1;
         if(this._petVO != null)
         {
            this.refreshAbilities(param1);
         }
      }
      
      public function get petVO() : IPetVO
      {
         return this._petVO;
      }
   }
}
