package com.company.assembleegameclient.map.partyoverlay
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.map.Quest;
   import com.company.assembleegameclient.objects.Character;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.tooltip.PortraitToolTip;
   import com.company.assembleegameclient.ui.tooltip.QuestToolTip;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.easing.Expo;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.game.model.QuestModel;
   
   public class QuestArrow extends GameObjectArrow
   {
       
      
      private var questArrowTween:TimelineMax;
      
      private var questModel:QuestModel;
      
      public function QuestArrow(param1:Map)
      {
         super(16352321,12919330,true);
         map_ = param1;
         this.questModel = StaticInjectorContext.getInjector().getInstance(QuestModel);
      }
      
      public function refreshToolTip() : void
      {
         if(this.questArrowTween.isActive())
         {
            this.questArrowTween.pause(0);
            this.scaleX = 1;
            this.scaleY = 1;
         }
         setToolTip(this.getToolTip(go_,getTimer()));
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         super.onMouseOver(param1);
         this.refreshToolTip();
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
         super.onMouseOut(param1);
         this.refreshToolTip();
      }
      
      private function getToolTip(param1:GameObject, param2:int) : ToolTip
      {
         if(param1 == null || param1.texture_ == null)
         {
            return null;
         }
         if(this.shouldShowFullQuest(param2))
         {
            return new QuestToolTip(go_);
         }
         if(Parameters.data_.showQuestPortraits)
         {
            return new PortraitToolTip(param1);
         }
         return null;
      }
      
      private function shouldShowFullQuest(param1:int) : Boolean
      {
         var _loc2_:Quest = map_.quest_;
         return mouseOver_ || _loc2_.isNew(param1);
      }
      
      override public function draw(param1:int, param2:Camera) : void
      {
         var _loc4_:Character = null;
         var _loc5_:String = null;
         var _loc6_:* = false;
         var _loc7_:Boolean = false;
         var _loc3_:GameObject = map_.quest_.getObject(param1);
         if(_loc3_ && _loc3_ is Character)
         {
            _loc4_ = _loc3_ as Character;
            _loc5_ = _loc4_.getName();
            if(_loc5_ != this.questModel.currentQuestHero)
            {
               this.questModel.currentQuestHero = _loc5_;
            }
         }
         if(_loc3_ != go_)
         {
            setGameObject(_loc3_);
            setToolTip(this.getToolTip(_loc3_,param1));
            if(!this.questArrowTween)
            {
               this.questArrowTween = new TimelineMax();
               this.questArrowTween.add(TweenMax.to(this,0.15,{
                  "scaleX":1.6,
                  "scaleY":1.6
               }));
               this.questArrowTween.add(TweenMax.to(this,0.05,{
                  "scaleX":1.8,
                  "scaleY":1.8
               }));
               this.questArrowTween.add(TweenMax.to(this,0.3,{
                  "scaleX":1,
                  "scaleY":1,
                  "ease":Expo.easeOut
               }));
            }
            else
            {
               this.questArrowTween.play(0);
            }
         }
         else if(go_ != null)
         {
            _loc6_ = tooltip_ is QuestToolTip;
            _loc7_ = this.shouldShowFullQuest(param1);
            if(_loc6_ != _loc7_)
            {
               setToolTip(this.getToolTip(_loc3_,param1));
            }
         }
         super.draw(param1,param2);
      }
   }
}
