package kabam.rotmg.servers.model
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import com.company.assembleegameclient.parameters.Parameters;
   import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.servers.api.LatLong;
   import kabam.rotmg.servers.api.Server;
   import kabam.rotmg.servers.api.ServerModel;
   
   public class LiveServerModel implements ServerModel
   {
       
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var seasonalEventModel:SeasonalEventModel;
      
      private var _descendingFlag:Boolean;
      
      private const servers:Vector.<Server> = new Vector.<Server>(0);
      
      private var availableServers:Vector.<Server>;
      
      public function LiveServerModel()
      {
         super();
      }
      
      public function setServers(param1:Vector.<Server>) : void
      {
         var _loc2_:Server = null;
         this.servers.length = 0;
         for each(_loc2_ in param1)
         {
            this.servers.push(_loc2_);
         }
         this._descendingFlag = false;
         this.servers.sort(this.compareServerName);
      }
      
      public function getServers() : Vector.<Server>
      {
         return this.servers;
      }
      
      public function getServer() : Server
      {
         var _loc2_:Boolean = false;
         var _loc10_:Server = null;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc1_:Boolean = this.model.isAdmin();
         var _loc3_:SavedCharacter = this.model.getCharacterById(this.model.currentCharId);
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
         var _loc5_:LatLong = this.model.getMyPos();
         var _loc6_:Server = null;
         var _loc7_:Number = Number.MAX_VALUE;
         var _loc8_:int = int.MAX_VALUE;
         var _loc9_:String = !!_loc2_?Parameters.data_.preferredChallengerServer:Parameters.data_.preferredServer;
         for each(_loc10_ in this.availableServers)
         {
            if(!(_loc10_.isFull() && !_loc1_))
            {
               if(_loc10_.name == _loc9_)
               {
                  return _loc10_;
               }
               _loc11_ = _loc10_.priority();
               _loc12_ = LatLong.distance(_loc5_,_loc10_.latLong);
               if(_loc11_ < _loc8_ || _loc11_ == _loc8_ && _loc12_ < _loc7_)
               {
                  _loc6_ = _loc10_;
                  _loc7_ = _loc12_;
                  _loc8_ = _loc11_;
                  if(_loc2_)
                  {
                     Parameters.data_.bestChallengerServer = _loc6_.name;
                  }
                  else
                  {
                     Parameters.data_.bestServer = _loc6_.name;
                  }
                  Parameters.save();
               }
            }
         }
         return _loc6_;
      }
      
      public function getServerNameByAddress(param1:String) : String
      {
         var _loc2_:Server = null;
         for each(_loc2_ in this.servers)
         {
            if(_loc2_.address == param1)
            {
               return _loc2_.name;
            }
         }
         return "";
      }
      
      public function isServerAvailable() : Boolean
      {
         return this.servers.length > 0;
      }
      
      private function compareServerName(param1:Server, param2:Server) : int
      {
         if(param1.name < param2.name)
         {
            return !!this._descendingFlag?-1:1;
         }
         if(param1.name > param2.name)
         {
            return !!this._descendingFlag?1:-1;
         }
         return 0;
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
   }
}
