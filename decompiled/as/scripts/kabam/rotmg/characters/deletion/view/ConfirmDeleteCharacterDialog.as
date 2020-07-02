package kabam.rotmg.characters.deletion.view
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import flash.display.Sprite;
   import flash.events.Event;
   import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.text.model.TextKey;
   import org.osflash.signals.Signal;
   
   public class ConfirmDeleteCharacterDialog extends Sprite
   {
       
      
      private const CANCEL_EVENT:String = Dialog.LEFT_BUTTON;
      
      private const DELETE_EVENT:String = Dialog.RIGHT_BUTTON;
      
      public var deleteCharacter:Signal;
      
      public var cancel:Signal;
      
      public function ConfirmDeleteCharacterDialog()
      {
         super();
         this.deleteCharacter = new Signal();
         this.cancel = new Signal();
      }
      
      public function setText(param1:String, param2:String) : void
      {
         var _loc3_:Boolean = StaticInjectorContext.getInjector().getInstance(SeasonalEventModel).isChallenger;
         var _loc4_:String = !!_loc3_?"It will cost you a character life to delete {name} the {displayID} - Are you really sure you want to?":TextKey.CONFIRMDELETECHARACTERDIALOG;
         var _loc5_:Dialog = new Dialog(TextKey.CONFIRMDELETE_VERIFYDELETION,"",TextKey.CONFIRMDELETE_CANCEL,TextKey.CONFIRMDELETE_DELETE,"/deleteDialog");
         _loc5_.setTextParams(_loc4_,{
            "name":param1,
            "displayID":param2
         });
         _loc5_.addEventListener(this.CANCEL_EVENT,this.onCancel);
         _loc5_.addEventListener(this.DELETE_EVENT,this.onDelete);
         addChild(_loc5_);
      }
      
      private function onCancel(param1:Event) : void
      {
         this.cancel.dispatch();
      }
      
      private function onDelete(param1:Event) : void
      {
         this.deleteCharacter.dispatch();
      }
   }
}
