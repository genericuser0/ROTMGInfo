package io.decagames.rotmg.supportCampaign.tab
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import com.company.assembleegameclient.util.Currency;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   import io.decagames.rotmg.shop.NotEnoughResources;
   import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
   import io.decagames.rotmg.supportCampaign.data.SupporterFeatures;
   import io.decagames.rotmg.supportCampaign.signals.TierSelectedSignal;
   import io.decagames.rotmg.supportCampaign.signals.UpdateCampaignProgress;
   import io.decagames.rotmg.ui.buttons.BaseButton;
   import io.decagames.rotmg.ui.imageLoader.ImageLoader;
   import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
   import io.decagames.rotmg.ui.popups.signals.RemoveLockFade;
   import io.decagames.rotmg.ui.popups.signals.ShowLockFade;
   import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.HideTooltipsSignal;
   import kabam.rotmg.core.signals.ShowTooltipSignal;
   import kabam.rotmg.game.model.GameModel;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.tooltips.HoverTooltipDelegate;
   import kabam.rotmg.ui.model.HUDModel;
   import kabam.rotmg.ui.signals.HUDModelInitialized;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class SupporterShopTabMediator extends Mediator
   {
       
      
      [Inject]
      public var view:SupporterShopTabView;
      
      [Inject]
      public var model:SupporterCampaignModel;
      
      [Inject]
      public var gameModel:GameModel;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var initHUDModelSignal:HUDModelInitialized;
      
      [Inject]
      public var hudModel:HUDModel;
      
      [Inject]
      public var showTooltipSignal:ShowTooltipSignal;
      
      [Inject]
      public var hideTooltipSignal:HideTooltipsSignal;
      
      [Inject]
      public var showPopup:ShowPopupSignal;
      
      [Inject]
      public var showFade:ShowLockFade;
      
      [Inject]
      public var removeFade:RemoveLockFade;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var updatePointsSignal:UpdateCampaignProgress;
      
      [Inject]
      public var selectedSignal:TierSelectedSignal;
      
      private var infoToolTip:TextToolTip;
      
      private var hoverTooltipDelegate:HoverTooltipDelegate;
      
      private var _loader:Loader;
      
      private var _imageLoader:ImageLoader;
      
      public function SupporterShopTabMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.updatePointsSignal.add(this.onPointsUpdate);
         var _loc1_:DisplayObject = this.model.getCampaignImageByUrl(this.model.campaignBannerUrl);
         if(_loc1_)
         {
            this.showCampaignView(_loc1_);
         }
         else
         {
            this._imageLoader = new ImageLoader();
            this._imageLoader.loadImage(this.model.campaignBannerUrl,this.onBannerLoaded);
         }
      }
      
      private function initView() : void
      {
         if(!this.model.isStarted)
         {
            this.view.addEventListener(Event.ENTER_FRAME,this.updateStartCountdown);
         }
         if(this.model.isUnlocked)
         {
            this.updateCampaignInformation();
         }
         if(this.view.unlockButton)
         {
            this.view.unlockButton.clickSignal.add(this.unlockClick);
         }
      }
      
      private function onBannerLoaded(param1:Event) : void
      {
         this._imageLoader.removeLoaderListeners();
         var _loc2_:DisplayObject = this._imageLoader.loader;
         this.model.addCampaignImageByUrl(this.model.campaignBannerUrl,_loc2_);
         this.showCampaignView(_loc2_);
      }
      
      private function showCampaignView(param1:DisplayObject) : void
      {
         this.view.show(this.hudModel.getPlayerName(),this.model.isUnlocked,this.model.isStarted,this.model.unlockPrice,this.model.donatePointsRatio,this.model.isEnded,param1);
         this.initView();
      }
      
      private function updateCampaignInformation() : void
      {
         this.view.updatePoints(this.model.points,this.model.rank);
         this.view.drawProgress(this.model.points,this.model.rankConfig,this.model.rank,this.model.claimed);
         this.updateInfoTooltip();
         this.showCampaignTier();
         this.view.updateTime(this.model.endDate.time - new Date().time);
      }
      
      private function showCampaignTier() : void
      {
         var _loc1_:String = this.model.getCampaignPictureUrlByRank(this.model.nextClaimableTier);
         var _loc2_:DisplayObject = this.model.getCampaignImageByUrl(_loc1_);
         if(_loc2_)
         {
            this.showTier(_loc2_);
         }
         else
         {
            this._imageLoader = new ImageLoader();
            this._imageLoader.loadImage(_loc1_,this.onCampaignTierImageLoaded);
         }
      }
      
      private function onCampaignTierImageLoaded(param1:Event) : void
      {
         this._imageLoader.removeLoaderListeners();
         var _loc2_:DisplayObject = this._imageLoader.loader;
         this.model.addCampaignImageByUrl(this.model.getCampaignPictureUrlByRank(this.model.nextClaimableTier),_loc2_);
         this.showTier(_loc2_);
      }
      
      private function showTier(param1:DisplayObject) : void
      {
         this.view.showTier(this.model.nextClaimableTier,this.model.ranks,this.model.rank,this.model.claimed,param1);
      }
      
      private function updateStartCountdown(param1:Event) : void
      {
         var _loc2_:String = this.model.getStartTimeString();
         if(_loc2_ == "")
         {
            this.view.removeEventListener(Event.ENTER_FRAME,this.updateStartCountdown);
            this.view.unlockButton.disabled = false;
         }
         this.view.updateStartCountdown(_loc2_);
      }
      
      override public function destroy() : void
      {
         this.updatePointsSignal.remove(this.onPointsUpdate);
         if(this.view.unlockButton)
         {
            this.view.unlockButton.clickSignal.remove(this.unlockClick);
         }
         this.view.removeEventListener(Event.ENTER_FRAME,this.updateStartCountdown);
      }
      
      private function onPointsUpdate() : void
      {
         this.view.updatePoints(this.model.points,this.model.rank);
         this.showCampaignTier();
         this.view.drawProgress(this.model.points,this.model.rankConfig,this.model.rank,this.model.claimed);
         this.updateInfoTooltip();
         this.selectedSignal.dispatch(this.model.nextClaimableTier);
         var _loc1_:Player = this.gameModel.player;
         if(_loc1_.hasSupporterFeature(SupporterFeatures.GLOW))
         {
            _loc1_.supporterPoints = this.model.points;
            _loc1_.clearTextureCache();
         }
      }
      
      private function updateInfoTooltip() : void
      {
         if(this.view.infoButton)
         {
            if(this.model.hasMaxRank())
            {
               this.infoToolTip = new TextToolTip(3552822,15585539,"Bonus Points","You have reached the maximum rank and therefore completed the Bonus Campaign - Congratulation!",220);
            }
            else
            {
               this.infoToolTip = new TextToolTip(3552822,10197915,"Bonus Points","This is the amount of Bonus Points you have collected so far. Collect more Points " + "and claim Rewards!",220);
            }
            this.hoverTooltipDelegate = new HoverTooltipDelegate();
            this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
            this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
            this.hoverTooltipDelegate.setDisplayObject(this.view.infoButton);
            this.hoverTooltipDelegate.tooltip = this.infoToolTip;
         }
      }
      
      private function unlockClick(param1:BaseButton) : void
      {
         if(this.currentGold < this.model.unlockPrice)
         {
            this.showPopup.dispatch(new NotEnoughResources(300,Currency.GOLD));
            return;
         }
         this.showFade.dispatch();
         var _loc2_:Object = this.account.getCredentials();
         this.client.sendRequest("/supportCampaign/unlock",_loc2_);
         this.client.complete.addOnce(this.onUnlockComplete);
      }
      
      private function onUnlockComplete(param1:Boolean, param2:*) : void
      {
         var xml:XML = null;
         var errorMessage:XML = null;
         var message:String = null;
         var isOK:Boolean = param1;
         var data:* = param2;
         this.removeFade.dispatch();
         if(isOK)
         {
            try
            {
               xml = new XML(data);
               if(xml.hasOwnProperty("Gold"))
               {
                  this.updateUserGold(int(xml.Gold));
               }
               this.view.show(null,true,this.model.isStarted,this.model.unlockPrice,this.model.donatePointsRatio,this.model.isEnded,this._loader);
               this.model.parseUpdateData(xml);
               this.updateCampaignInformation();
            }
            catch(e:Error)
            {
               showPopup.dispatch(new ErrorModal(300,"Campaign Error","General campaign error."));
            }
         }
         else
         {
            try
            {
               errorMessage = new XML(data);
               message = LineBuilder.getLocalizedStringFromKey(errorMessage.toString(),{});
               this.showPopup.dispatch(new ErrorModal(300,"Campaign Error",message == ""?errorMessage.toString():message));
               return;
            }
            catch(e:Error)
            {
               showPopup.dispatch(new ErrorModal(300,"Campaign Error","General campaign error."));
               return;
            }
         }
      }
      
      private function updateUserGold(param1:int) : void
      {
         var _loc2_:Player = this.gameModel.player;
         if(_loc2_ != null)
         {
            _loc2_.setCredits(param1);
         }
         else
         {
            this.playerModel.setCredits(param1);
         }
      }
      
      private function get currentGold() : int
      {
         var _loc1_:Player = this.gameModel.player;
         if(_loc1_ != null)
         {
            return _loc1_.credits_;
         }
         if(this.playerModel != null)
         {
            return this.playerModel.getCredits();
         }
         return 0;
      }
   }
}
