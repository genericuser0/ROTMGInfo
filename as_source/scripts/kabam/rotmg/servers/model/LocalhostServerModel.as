package kabam.rotmg.servers.model
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import com.company.assembleegameclient.parameters.Parameters;
   import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.servers.api.Server;
   import kabam.rotmg.servers.api.ServerModel;
   
   public class LocalhostServerModel implements ServerModel
   {
       
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var seasonalEventModel:SeasonalEventModel;
      
      private var localhost:Server;
      
      private var servers:Vector.<Server>;
      
      private var availableServers:Vector.<Server>;
      
      public function LocalhostServerModel()
      {
         var _loc2_:String = null;
         var _loc3_:Server = null;
         super();
         this.servers = new Vector.<Server>(0);
         var _loc1_:int = 0;
         while(_loc1_ < 40)
         {
            _loc2_ = _loc1_ % 2 == 0?"localhost":"C_localhost" + _loc1_;
            _loc3_ = new Server().setName(_loc2_).setAddress("localhost").setPort(Parameters.PORT);
            this.servers.push(_loc3_);
            _loc1_++;
         }
      }
      
      public function setAvailableServers(param1:int) : void
      {
         var _loc2_:Server = null;
         var _loc3_:Server = null;
         if(!this.availableServers)
         {
            this.availableServers = new Vector.<Server>(0);
         }
         else
         {
            this.availableServers.length = 0;
         }
         if(param1 != 0)
         {
            for each(_loc2_ in this.servers)
            {
               if(_loc2_.name.charAt(0) == "C")
               {
                  this.availableServers.push(_loc2_);
               }
            }
         }
         else
         {
            for each(_loc3_ in this.servers)
            {
               if(_loc3_.name.charAt(0) != "C")
               {
                  this.availableServers.push(_loc3_);
               }
            }
         }
      }
      
      public function getAvailableServers() : Vector.<Server>
      {
         return this.availableServers;
      }
      
      public function getServer() : Server
      {
         var _loc2_:Boolean = false;
         var _loc6_:Server = null;
         var _loc7_:String = null;
         var _loc1_:Boolean = this.playerModel.isAdmin();
         var _loc3_:SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
         if(_loc3_)
         {
            _loc2_ = Boolean(int(_loc3_.charXML_.IsChallenger));
         }
         else
         {
            _loc2_ = Boolean(this.seasonalEventModel.isChallenger);
         }
         var _loc4_:int = !!_loc2_?int(Server.CHALLENGER_SERVER):int(Server.NORMAL_SERVER);
         this.setAvailableServers(_loc4_);
         var _loc5_:Server = null;
         for each(_loc6_ in this.availableServers)
         {
            if(!(_loc6_.isFull() && !_loc1_))
            {
               _loc7_ = !!_loc2_?Parameters.data_.preferredChallengerServer:Parameters.data_.preferredServer;
               if(_loc6_.name == _loc7_)
               {
                  return _loc6_;
               }
               _loc5_ = this.availableServers[0];
               if(_loc2_)
               {
                  Parameters.data_.bestChallengerServer = _loc5_.name;
               }
               else
               {
                  Parameters.data_.bestServer = _loc5_.name;
               }
               Parameters.save();
            }
         }
         return _loc5_;
      }
      
      public function isServerAvailable() : Boolean
      {
         return true;
      }
      
      public function setServers(param1:Vector.<Server>) : void
      {
      }
      
      public function getServers() : Vector.<Server>
      {
         return this.servers;
      }
   }
}
