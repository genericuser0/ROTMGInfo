package io.decagames.rotmg.seasonalEvent.popups
{
   import flash.events.MouseEvent;
   import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class SeasonalEventInfoPopupMediator extends Mediator
   {
       
      
      [Inject]
      public var view:SeasonalEventInfoPopup;
      
      [Inject]
      public var closePopupSignal:ClosePopupSignal;
      
      public function SeasonalEventInfoPopupMediator()
      {
         super();
      }
      
      override public function destroy() : void
      {
         this.view.okButton.removeEventListener(MouseEvent.CLICK,this.onOK);
      }
      
      override public function initialize() : void
      {
         this.view.okButton.addEventListener(MouseEvent.CLICK,this.onOK);
      }
      
      private function onOK(param1:MouseEvent) : void
      {
         this.view.okButton.removeEventListener(MouseEvent.CLICK,this.onOK);
         this.closePopupSignal.dispatch(this.view);
      }
   }
}
