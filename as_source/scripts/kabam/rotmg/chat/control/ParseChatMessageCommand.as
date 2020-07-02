package kabam.rotmg.chat.control
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.util.MoreObjectUtil;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.build.api.BuildData;
   import kabam.rotmg.chat.model.ChatMessage;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.service.GoogleAnalytics;
   import kabam.rotmg.dailyLogin.model.DailyLoginModel;
   import kabam.rotmg.dialogs.model.PopupNamesConfig;
   import kabam.rotmg.game.signals.AddTextLineSignal;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.ui.model.HUDModel;
   
   public class ParseChatMessageCommand
   {
       
      
      [Inject]
      public var data:String;
      
      [Inject]
      public var hudModel:HUDModel;
      
      [Inject]
      public var addTextLine:AddTextLineSignal;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var buildData:BuildData;
      
      [Inject]
      public var dailyLoginModel:DailyLoginModel;
      
      [Inject]
      public var player:PlayerModel;
      
      [Inject]
      public var tracking:GoogleAnalytics;
      
      public function ParseChatMessageCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:GameObject = null;
         var _loc5_:String = null;
         var _loc6_:* = null;
         switch(this.data)
         {
            case "/resetDailyQuests":
               if(this.player.isAdmin())
               {
                  _loc1_ = {};
                  MoreObjectUtil.addToObject(_loc1_,this.account.getCredentials());
                  this.client.sendRequest("/dailyquest/resetDailyQuestsAdmin",_loc1_);
                  this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME,"Restarting daily quests. Please refresh game."));
               }
               break;
            case "/resetPackagePopup":
               Parameters.data_[PopupNamesConfig.PACKAGES_OFFER_POPUP] = null;
               break;
            case "/h":
            case "/help":
               this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME,TextKey.HELP_COMMAND));
               break;
            case "/c":
            case "/class":
            case "/classes":
               _loc2_ = {};
               _loc3_ = 0;
               for each(_loc4_ in this.hudModel.gameSprite.map.goDict_)
               {
                  if(_loc4_.props_.isPlayer_)
                  {
                     _loc2_[_loc4_.objectType_] = _loc2_[_loc4_.objectType_] != undefined?_loc2_[_loc4_.objectType_] + 1:uint(1);
                     _loc3_++;
                  }
               }
               _loc5_ = "";
               for(_loc6_ in _loc2_)
               {
                  _loc5_ = _loc5_ + (" " + ObjectLibrary.typeToDisplayId_[_loc6_] + ": " + _loc2_[_loc6_]);
               }
               this.addTextLine.dispatch(ChatMessage.make("","Classes online (" + _loc3_ + "):" + _loc5_));
               break;
            default:
               this.hudModel.gameSprite.gsc_.playerText(this.data);
         }
      }
   }
}
