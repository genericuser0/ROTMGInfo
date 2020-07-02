package io.decagames.rotmg.social.widgets
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.events.MouseEvent;
   import io.decagames.rotmg.social.config.FriendsActions;
   import io.decagames.rotmg.social.model.FriendRequestVO;
   import io.decagames.rotmg.social.model.SocialModel;
   import io.decagames.rotmg.social.signals.FriendActionSignal;
   import io.decagames.rotmg.social.signals.RefreshListSignal;
   import io.decagames.rotmg.ui.buttons.BaseButton;
   import io.decagames.rotmg.ui.popups.modal.ConfirmationModal;
   import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
   import io.decagames.rotmg.ui.popups.signals.CloseCurrentPopupSignal;
   import io.decagames.rotmg.ui.popups.signals.RemoveLockFade;
   import io.decagames.rotmg.ui.popups.signals.ShowLockFade;
   import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
   import kabam.rotmg.chat.control.ShowChatInputSignal;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.game.model.GameInitData;
   import kabam.rotmg.game.signals.PlayGameSignal;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.ui.signals.EnterGameSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class FriendListItemMediator extends Mediator
   {
       
      
      [Inject]
      public var view:FriendListItem;
      
      [Inject]
      public var showPopupSignal:ShowPopupSignal;
      
      [Inject]
      public var showFade:ShowLockFade;
      
      [Inject]
      public var friendsAction:FriendActionSignal;
      
      [Inject]
      public var showPopup:ShowPopupSignal;
      
      [Inject]
      public var removeFade:RemoveLockFade;
      
      [Inject]
      public var model:SocialModel;
      
      [Inject]
      public var refreshSignal:RefreshListSignal;
      
      [Inject]
      public var chatSignal:ShowChatInputSignal;
      
      [Inject]
      public var closeCurrentPopup:CloseCurrentPopupSignal;
      
      [Inject]
      public var enterGame:EnterGameSignal;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var playGame:PlayGameSignal;
      
      public function FriendListItemMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         if(this.view.removeButton)
         {
            this.view.removeButton.addEventListener(MouseEvent.CLICK,this.onRemoveClick);
         }
         if(this.view.acceptButton)
         {
            this.view.acceptButton.addEventListener(MouseEvent.CLICK,this.onAcceptClick);
         }
         if(this.view.rejectButton)
         {
            this.view.rejectButton.addEventListener(MouseEvent.CLICK,this.onRejectClick);
         }
         if(this.view.messageButton)
         {
            this.view.messageButton.addEventListener(MouseEvent.CLICK,this.onMessageClick);
         }
         if(this.view.teleportButton)
         {
            this.view.teleportButton.addEventListener(MouseEvent.CLICK,this.onTeleportClick);
         }
         if(this.view.blockButton)
         {
            this.view.blockButton.addEventListener(MouseEvent.CLICK,this.onBlockClick);
         }
      }
      
      private function onMessageClick(param1:MouseEvent) : void
      {
         this.chatSignal.dispatch(true,"/tell " + this.view.getLabelText() + " ");
         this.closeCurrentPopup.dispatch();
      }
      
      override public function destroy() : void
      {
         if(this.view.removeButton)
         {
            this.view.removeButton.removeEventListener(MouseEvent.CLICK,this.onRemoveClick);
         }
         if(this.view.acceptButton)
         {
            this.view.acceptButton.removeEventListener(MouseEvent.CLICK,this.onAcceptClick);
         }
         if(this.view.rejectButton)
         {
            this.view.rejectButton.removeEventListener(MouseEvent.CLICK,this.onRejectClick);
         }
         if(this.view.messageButton)
         {
            this.view.messageButton.removeEventListener(MouseEvent.CLICK,this.onMessageClick);
         }
         if(this.view.teleportButton)
         {
            this.view.teleportButton.removeEventListener(MouseEvent.CLICK,this.onTeleportClick);
         }
         if(this.view.blockButton)
         {
            this.view.blockButton.removeEventListener(MouseEvent.CLICK,this.onBlockClick);
         }
      }
      
      private function onTeleportClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
         if(_loc3_)
         {
            _loc2_ = Boolean(int(_loc3_.charXML_.IsChallenger));
         }
         if(_loc2_)
         {
            Parameters.data_.preferredChallengerServer = this.view.vo.getServerName();
         }
         else
         {
            Parameters.data_.preferredServer = this.view.vo.getServerName();
         }
         Parameters.save();
         this.enterGame.dispatch();
         var _loc4_:GameInitData = new GameInitData();
         _loc4_.createCharacter = false;
         _loc4_.charId = _loc3_.charId();
         _loc4_.isNewGame = true;
         this.playGame.dispatch(_loc4_);
         this.closeCurrentPopup.dispatch();
      }
      
      private function onRemoveConfirmed(param1:BaseButton) : void
      {
         var _loc2_:FriendRequestVO = new FriendRequestVO(FriendsActions.REMOVE,this.view.getLabelText(),this.onRemoveCallback);
         this.friendsAction.dispatch(_loc2_);
         this.showFade.dispatch();
      }
      
      private function onBlockConfirmed(param1:BaseButton) : void
      {
         var _loc2_:FriendRequestVO = new FriendRequestVO(FriendsActions.BLOCK,this.view.getLabelText(),this.onBlockCallback);
         this.friendsAction.dispatch(_loc2_);
         this.showFade.dispatch();
      }
      
      private function onRemoveCallback(param1:Boolean, param2:Object, param3:String) : void
      {
         if(param1)
         {
            this.model.removeFriend(param3);
         }
         else
         {
            this.showPopup.dispatch(new ErrorModal(350,"Friends List Error",LineBuilder.getLocalizedStringFromKey(String(param2))));
         }
         this.removeFade.dispatch();
         this.refreshSignal.dispatch(RefreshListSignal.CONTEXT_FRIENDS_LIST,param1);
      }
      
      private function onBlockCallback(param1:Boolean, param2:Object, param3:String) : void
      {
         if(param1)
         {
            this.model.removeInvitation(param3);
         }
         else
         {
            this.showPopup.dispatch(new ErrorModal(350,"Friends List Error",LineBuilder.getLocalizedStringFromKey(String(param2))));
         }
         this.removeFade.dispatch();
         this.refreshSignal.dispatch(RefreshListSignal.CONTEXT_FRIENDS_LIST,param1);
      }
      
      private function onAcceptCallback(param1:Boolean, param2:Object, param3:String) : void
      {
         if(param1)
         {
            this.model.removeInvitation(param3);
            this.model.seedFriends(XML(param2));
         }
         else
         {
            this.showPopup.dispatch(new ErrorModal(350,"Friends List Error",LineBuilder.getLocalizedStringFromKey(String(param2))));
         }
         this.removeFade.dispatch();
         this.refreshSignal.dispatch(RefreshListSignal.CONTEXT_FRIENDS_LIST,param1);
      }
      
      private function onRejectCallback(param1:Boolean, param2:Object, param3:String) : void
      {
         if(param1)
         {
            this.model.removeInvitation(param3);
         }
         else
         {
            this.showPopup.dispatch(new ErrorModal(350,"Friends List Error",LineBuilder.getLocalizedStringFromKey(String(param2))));
         }
         this.removeFade.dispatch();
         this.refreshSignal.dispatch(RefreshListSignal.CONTEXT_FRIENDS_LIST,param1);
      }
      
      private function onRemoveClick(param1:MouseEvent) : void
      {
         var _loc2_:ConfirmationModal = new ConfirmationModal(350,LineBuilder.getLocalizedStringFromKey(TextKey.FRIEND_REMOVE_TITLE),LineBuilder.getLocalizedStringFromKey(TextKey.FRIEND_REMOVE_TEXT,{"name":this.view.getLabelText()}),LineBuilder.getLocalizedStringFromKey(TextKey.FRIEND_REMOVE_BUTTON),LineBuilder.getLocalizedStringFromKey(TextKey.FRAME_CANCEL),130);
         _loc2_.confirmButton.clickSignal.addOnce(this.onRemoveConfirmed);
         this.showPopupSignal.dispatch(_loc2_);
      }
      
      private function onAcceptClick(param1:MouseEvent) : void
      {
         var _loc2_:FriendRequestVO = new FriendRequestVO(FriendsActions.ACCEPT,this.view.getLabelText(),this.onAcceptCallback);
         this.friendsAction.dispatch(_loc2_);
         this.showFade.dispatch();
      }
      
      private function onRejectClick(param1:MouseEvent) : void
      {
         var _loc2_:FriendRequestVO = new FriendRequestVO(FriendsActions.REJECT,this.view.getLabelText(),this.onRejectCallback);
         this.friendsAction.dispatch(_loc2_);
         this.showFade.dispatch();
      }
      
      private function onBlockClick(param1:MouseEvent) : void
      {
         var _loc2_:ConfirmationModal = new ConfirmationModal(350,LineBuilder.getLocalizedStringFromKey(TextKey.FRIEND_BLOCK_TITLE),LineBuilder.getLocalizedStringFromKey(TextKey.FRIEND_BLOCK_TEXT,{"name":this.view.getLabelText()}),LineBuilder.getLocalizedStringFromKey(TextKey.FRIEND_BLOCK_BUTTON),LineBuilder.getLocalizedStringFromKey(TextKey.FRAME_CANCEL),130);
         _loc2_.confirmButton.clickSignal.addOnce(this.onBlockConfirmed);
         this.showPopupSignal.dispatch(_loc2_);
      }
   }
}
