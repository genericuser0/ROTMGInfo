package io.decagames.rotmg.social.widgets
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.icons.IconButton;
   import com.company.assembleegameclient.util.TimeUtil;
   import flash.events.Event;
   import io.decagames.rotmg.social.data.SocialItemState;
   import io.decagames.rotmg.social.model.FriendVO;
   import kabam.rotmg.text.model.TextKey;
   
   public class FriendListItem extends BaseListItem
   {
       
      
      public var teleportButton:IconButton;
      
      public var messageButton:IconButton;
      
      public var removeButton:IconButton;
      
      public var acceptButton:IconButton;
      
      public var rejectButton:IconButton;
      
      public var blockButton:IconButton;
      
      private var _vo:FriendVO;
      
      public function FriendListItem(param1:FriendVO, param2:int)
      {
         super(param2);
         this._vo = param1;
         this.init();
      }
      
      override protected function init() : void
      {
         super.init();
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         this.setState();
         createListLabel(this._vo.getName());
         createListPortrait(this._vo.getPortrait());
      }
      
      private function onRemoved(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         this.teleportButton && this.teleportButton.destroy();
         this.messageButton && this.messageButton.destroy();
         this.removeButton && this.removeButton.destroy();
         this.acceptButton && this.acceptButton.destroy();
         this.rejectButton && this.rejectButton.destroy();
         this.blockButton && this.blockButton.destroy();
      }
      
      private function setState() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:* = null;
         switch(_state)
         {
            case SocialItemState.ONLINE:
               _loc1_ = this._vo.getServerName();
               _loc2_ = !!Parameters.data_.preferredServer?Parameters.data_.preferredServer:Parameters.data_.bestServer;
               if(_loc2_ != _loc1_)
               {
                  _loc3_ = "Your friend is playing on server: " + _loc1_ + ". " + "Clicking this will take you to this server.";
                  this.teleportButton = addButton("lofiInterface2",3,230,12,TextKey.FRIEND_TELEPORT_TITLE,_loc3_);
               }
               this.messageButton = addButton("lofiInterfaceBig",21,255,12,TextKey.PLAYERMENU_PM);
               this.removeButton = addButton("lofiInterfaceBig",12,280,12,TextKey.FRIEND_REMOVE_BUTTON);
               break;
            case SocialItemState.OFFLINE:
               hoverTooltipDelegate.setDisplayObject(_characterContainer);
               setToolTipTitle("Last Seen:");
               setToolTipText(TimeUtil.humanReadableTime(this._vo.lastLogin) + " ago!");
               this.removeButton = addButton("lofiInterfaceBig",12,280,12,TextKey.FRIEND_REMOVE_BUTTON,TextKey.FRIEND_REMOVE_BUTTON_DESC);
               break;
            case SocialItemState.INVITE:
               this.acceptButton = addButton("lofiInterfaceBig",11,230,12,TextKey.GUILD_ACCEPT);
               this.rejectButton = addButton("lofiInterfaceBig",12,255,12,TextKey.GUILD_REJECTION);
               this.blockButton = addButton("lofiInterfaceBig",8,280,12,TextKey.FRIEND_BLOCK_BUTTON,TextKey.FRIEND_BLOCK_BUTTON_DESC);
         }
      }
      
      public function get vo() : FriendVO
      {
         return this._vo;
      }
   }
}
