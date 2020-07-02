package com.company.assembleegameclient.account.ui
{
   import flash.events.MouseEvent;
   import kabam.rotmg.text.model.TextKey;
   import org.osflash.signals.Signal;
   
   public class NewChooseNameFrame extends Frame
   {
       
      
      public const choose:Signal = new Signal();
      
      public const cancel:Signal = new Signal();
      
      private var name_:TextInputField;
      
      public function NewChooseNameFrame()
      {
         super("Choose a unique player name","",TextKey.CHOOSE_NAME_CHOOSE,"/newChooseName");
         this.name_ = new TextInputField("Player Name",false);
         this.name_.inputText_.restrict = "A-Za-z";
         var _loc1_:int = 10;
         this.name_.inputText_.maxChars = _loc1_;
         addTextInputField(this.name_);
         addPlainText(TextKey.FRAME_MAX_CHAR,{"maxChars":_loc1_});
         addPlainText(TextKey.FRAME_RESTRICT_CHAR);
         addPlainText(TextKey.CHOOSE_NAME_WARNING);
         rightButton_.addEventListener(MouseEvent.CLICK,this.onChoose);
      }
      
      private function onChoose(param1:MouseEvent) : void
      {
         this.choose.dispatch(this.name_.text());
      }
      
      public function setError(param1:String) : void
      {
         this.name_.setError(param1);
      }
   }
}
