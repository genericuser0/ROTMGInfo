package kabam.rotmg.account.core.view
{
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
   import kabam.rotmg.account.web.WebAccount;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.ui.signals.NameChangedSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class AccountInfoMediator extends Mediator
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var view:AccountInfoView;
      
      [Inject]
      public var update:UpdateAccountInfoSignal;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var nameChanged:NameChangedSignal;
      
      public function AccountInfoMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.nameChanged.add(this.onNameChanged);
         this.view.setInfo(this.account.getUserName(),this.account.isRegistered());
         this.updateDisplayName();
         this.update.add(this.updateLogin);
      }
      
      private function onNameChanged(param1:String) : void
      {
         this.updateDisplayName();
      }
      
      private function updateDisplayName() : void
      {
         var _loc1_:String = null;
         var _loc2_:WebAccount = null;
         if(this.account is WebAccount)
         {
            _loc2_ = this.account as WebAccount;
            if(_loc2_ == null)
            {
               return;
            }
            _loc1_ = this.playerModel.getName();
            if(!_loc1_ && _loc2_.userDisplayName != null && _loc2_.userDisplayName.length > 0)
            {
               _loc1_ = _loc2_.userDisplayName;
            }
            this.view.setInfo(_loc1_,this.account.isRegistered());
         }
      }
      
      override public function destroy() : void
      {
         this.update.remove(this.updateLogin);
      }
      
      private function updateLogin() : void
      {
         this.view.setInfo(this.account.getUserName(),this.account.isRegistered());
         this.updateDisplayName();
      }
   }
}
