package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.ui.panels.PortalPanel;
   import com.company.assembleegameclient.ui.tooltip.IconToolTip;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.service.GoogleAnalytics;
   import kabam.rotmg.core.signals.HideTooltipsSignal;
   import kabam.rotmg.core.signals.ShowTooltipSignal;
   import kabam.rotmg.game.signals.ExitGameSignal;
   import kabam.rotmg.tooltips.HoverTooltipDelegate;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class PortalPanelMediator extends Mediator
   {
       
      
      [Inject]
      public var view:PortalPanel;
      
      [Inject]
      public var exitGameSignal:ExitGameSignal;
      
      [Inject]
      public var googleAnalytics:GoogleAnalytics;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var showTooltipSignal:ShowTooltipSignal;
      
      [Inject]
      public var hideTooltipsSignal:HideTooltipsSignal;
      
      [Inject]
      public var seasonalEventModel:SeasonalEventModel;
      
      private var challengerTooltipDelegate:HoverTooltipDelegate;
      
      public function PortalPanelMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.googleAnalytics = this.googleAnalytics;
         this.view.exitGameSignal.add(this.onExitGame);
         this.view.enterButton_.addEventListener(MouseEvent.CLICK,this.view.onEnterSpriteClick);
      }
      
      private function onExitGame() : void
      {
         this.exitGameSignal.dispatch();
      }
      
      override public function destroy() : void
      {
         this.view.exitGameSignal.remove(this.onExitGame);
         this.challengerTooltipDelegate && this.challengerTooltipDelegate.removeDisplayObject();
         this.challengerTooltipDelegate = null;
      }
      
      private function createChallengerTooltipDelegate(param1:IconToolTip) : void
      {
         this.challengerTooltipDelegate = new HoverTooltipDelegate();
         this.challengerTooltipDelegate.setHideToolTipsSignal(this.hideTooltipsSignal);
         this.challengerTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
         this.challengerTooltipDelegate.setDisplayObject(this.view.enterButton_ as DisplayObject);
         this.challengerTooltipDelegate.tooltip = param1;
      }
   }
}
