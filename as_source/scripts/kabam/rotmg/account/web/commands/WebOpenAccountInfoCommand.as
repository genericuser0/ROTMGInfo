package kabam.rotmg.account.web.commands
{
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.web.view.WebAccountDetailDialog;
   import kabam.rotmg.account.web.view.WebRegisterDialog;
   import kabam.rotmg.account.web.view.WebVerifyEmailDialog;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   
   public class WebOpenAccountInfoCommand
   {
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      public function WebOpenAccountInfoCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         if(this.account.isRegistered() && this.account.isVerified())
         {
            this.openDialog.dispatch(new WebAccountDetailDialog());
         }
         else if(this.account.isRegistered() && !this.account.isVerified())
         {
            this.openDialog.dispatch(new WebVerifyEmailDialog());
         }
         else
         {
            this.openDialog.dispatch(new WebRegisterDialog());
         }
      }
   }
}
