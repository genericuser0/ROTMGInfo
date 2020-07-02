package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import flash.events.MouseEvent;
   import kabam.rotmg.core.signals.HideTooltipsSignal;
   import kabam.rotmg.core.signals.ShowTooltipSignal;
   import kabam.rotmg.packages.model.PackageInfo;
   import kabam.rotmg.packages.services.PackageModel;
   import kabam.rotmg.tooltips.HoverTooltipDelegate;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class ShopDisplayMediator extends Mediator
   {
       
      
      [Inject]
      public var view:ShopDisplay;
      
      [Inject]
      public var packageBoxModel:PackageModel;
      
      [Inject]
      public var showTooltipSignal:ShowTooltipSignal;
      
      [Inject]
      public var hideTooltipSignal:HideTooltipsSignal;
      
      private var toolTip:TextToolTip = null;
      
      private var hoverTooltipDelegate:HoverTooltipDelegate;
      
      public function ShopDisplayMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         var _loc3_:PackageInfo = null;
         if(this.view.shopButton && this.view.isOnNexus)
         {
            this.view.shopButton.addEventListener(MouseEvent.CLICK,this.view.onShopClick);
            this.toolTip = new TextToolTip(3552822,10197915,null,"Click to open!",95);
            this.hoverTooltipDelegate = new HoverTooltipDelegate();
            this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
            this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
            this.hoverTooltipDelegate.setDisplayObject(this.view.shopButton);
            this.hoverTooltipDelegate.tooltip = this.toolTip;
         }
         var _loc1_:Vector.<PackageInfo> = this.packageBoxModel.getTargetingBoxesForGrid().concat(this.packageBoxModel.getBoxesForGrid());
         var _loc2_:Date = new Date();
         _loc2_.setTime(Parameters.data_["packages_indicator"]);
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_ != null && (!_loc3_.endTime || _loc3_.getSecondsToEnd() > 0))
            {
               if(_loc3_.isNew() && (_loc3_.startTime.getTime() > _loc2_.getTime() || !Parameters.data_["packages_indicator"]))
               {
                  this.view.newIndicator(true);
               }
            }
         }
      }
   }
}
