package kabam.rotmg.account.core.commands
{
   import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import io.decagames.rotmg.shop.PreparingPurchaseTransactionModal;
   import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
   import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
   import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.model.JSInitializedModel;
   import kabam.rotmg.account.core.model.MoneyConfig;
   import kabam.rotmg.account.web.WebAccount;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.application.api.ApplicationSetup;
   import kabam.rotmg.build.api.BuildData;
   import kabam.rotmg.build.api.BuildEnvironment;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.promotions.model.BeginnersPackageModel;
   import robotlegs.bender.framework.api.ILogger;
   
   public class ExternalOpenMoneyWindowCommand
   {
       
      
      [Inject]
      public var moneyWindowModel:JSInitializedModel;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var moneyConfig:MoneyConfig;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var buildData:BuildData;
      
      [Inject]
      public var openDialogSignal:OpenDialogSignal;
      
      [Inject]
      public var applicationSetup:ApplicationSetup;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var beginnersPackageModel:BeginnersPackageModel;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var showPopup:ShowPopupSignal;
      
      [Inject]
      public var closePopupSignal:ClosePopupSignal;
      
      private var preparingModal:PreparingPurchaseTransactionModal;
      
      private const TESTING_ERROR_MESSAGE:String = "You cannot purchase gold on the testing server";
      
      private const REGISTRATION_ERROR_MESSAGE:String = "You must be registered to buy gold";
      
      public function ExternalOpenMoneyWindowCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         if(this.isGoldPurchaseEnabled() && this.account.isRegistered())
         {
            this.handleValidMoneyWindowRequest();
         }
         else
         {
            this.handleInvalidMoneyWindowRequest();
         }
      }
      
      private function handleInvalidMoneyWindowRequest() : void
      {
         if(!this.isGoldPurchaseEnabled())
         {
            this.openDialogSignal.dispatch(new ErrorDialog(this.TESTING_ERROR_MESSAGE));
         }
         else if(!this.account.isRegistered())
         {
            this.openDialogSignal.dispatch(new ErrorDialog(this.REGISTRATION_ERROR_MESSAGE));
         }
      }
      
      private function handleValidMoneyWindowRequest() : void
      {
         if(this.account is WebAccount && WebAccount(this.account).paymentProvider == "paymentwall")
         {
            this.requestPaymentToken();
         }
         else
         {
            try
            {
               this.openKabamMoneyWindowFromBrowser();
               return;
            }
            catch(e:Error)
            {
               openKabamMoneyWindowFromStandalonePlayer();
               return;
            }
         }
      }
      
      private function openKabamMoneyWindowFromStandalonePlayer() : void
      {
         var _loc1_:String = this.applicationSetup.getAppEngineUrl(true);
         var _loc2_:URLVariables = new URLVariables();
         var _loc3_:URLRequest = new URLRequest();
         _loc2_.naid = this.account.getMoneyUserId();
         _loc2_.signedRequest = this.account.getMoneyAccessToken();
         if(this.beginnersPackageModel.isBeginnerAvailable())
         {
            _loc2_.createdat = this.beginnersPackageModel.getUserCreatedAt();
         }
         else
         {
            _loc2_.createdat = 0;
         }
         _loc3_.url = _loc1_ + "/credits/kabamadd";
         _loc3_.method = URLRequestMethod.POST;
         _loc3_.data = _loc2_;
         navigateToURL(_loc3_,"_blank");
         this.logger.debug("Opening window from standalone player");
      }
      
      private function openPaymentwallMoneyWindowFromStandalonePlayer(param1:String) : void
      {
         var _loc2_:String = this.applicationSetup.getAppEngineUrl(true);
         var _loc3_:URLVariables = new URLVariables();
         var _loc4_:URLRequest = new URLRequest();
         _loc3_.iframeUrl = param1;
         _loc4_.url = _loc2_ + "/credits/pwpurchase";
         _loc4_.method = URLRequestMethod.POST;
         _loc4_.data = _loc3_;
         navigateToURL(_loc4_,"_blank");
         this.logger.debug("Opening window from standalone player");
      }
      
      private function initializeMoneyWindow() : void
      {
         var _loc1_:Number = NaN;
         if(!this.moneyWindowModel.isInitialized)
         {
            if(this.beginnersPackageModel.isBeginnerAvailable())
            {
               _loc1_ = this.beginnersPackageModel.getUserCreatedAt();
            }
            else
            {
               _loc1_ = 0;
            }
            ExternalInterface.call(this.moneyConfig.jsInitializeFunction(),this.account.getMoneyUserId(),this.account.getMoneyAccessToken(),_loc1_);
            this.moneyWindowModel.isInitialized = true;
         }
      }
      
      private function openKabamMoneyWindowFromBrowser() : void
      {
         this.initializeMoneyWindow();
         this.logger.debug("Attempting External Payments via KabamPayment");
         ExternalInterface.call("rotmg.KabamPayment.displayPaymentWall");
      }
      
      private function requestPaymentToken() : void
      {
         this.preparingModal = new PreparingPurchaseTransactionModal();
         this.showPopup.dispatch(this.preparingModal);
         var _loc1_:Object = this.account.getCredentials();
         this.client.sendRequest("/credits/token",_loc1_);
         this.client.complete.addOnce(this.onComplete);
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         var tokenInformation:String = null;
         var isOK:Boolean = param1;
         var data:* = param2;
         this.closePopupSignal.dispatch(this.preparingModal);
         if(isOK)
         {
            tokenInformation = XML(data).toString();
            if(tokenInformation == "-1")
            {
               this.showPopup.dispatch(new ErrorModal(350,"Payment Error","Unable to process payment request. Try again later."));
            }
            else
            {
               try
               {
                  ExternalInterface.call("rotmg.Paymentwall.showPaymentwall",tokenInformation);
               }
               catch(e:Error)
               {
                  openPaymentwallMoneyWindowFromStandalonePlayer(tokenInformation);
               }
            }
         }
         else
         {
            this.showPopup.dispatch(new ErrorModal(350,"Payment Error","Unable to fetch payment information. Try again later."));
         }
      }
      
      private function isGoldPurchaseEnabled() : Boolean
      {
         return this.buildData.getEnvironment() != BuildEnvironment.TESTING || this.playerModel.isAdmin();
      }
   }
}
