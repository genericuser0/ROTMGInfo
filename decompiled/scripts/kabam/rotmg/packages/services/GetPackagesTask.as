package kabam.rotmg.packages.services
{
   import com.company.assembleegameclient.util.TimeUtil;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.language.model.LanguageModel;
   import kabam.rotmg.packages.model.PackageInfo;
   import robotlegs.bender.framework.api.ILogger;
   
   public class GetPackagesTask extends BaseTask
   {
      
      private static var version:String = "0";
       
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var packageModel:PackageModel;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var languageModel:LanguageModel;
      
      public function GetPackagesTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         var _loc1_:Object = this.account.getCredentials();
         _loc1_.language = this.languageModel.getLanguage();
         _loc1_.version = version;
         this.client.sendRequest("/package/getPackages",_loc1_);
         this.client.complete.addOnce(this.onComplete);
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.handleOkay(param2);
         }
         else
         {
            this.logger.warn("GetPackageTask.onComplete: Request failed.");
            completeTask(true);
         }
         reset();
      }
      
      private function handleOkay(param1:*) : void
      {
         version = XML(param1).attribute("version").toString();
         var _loc2_:XMLList = XML(param1).child("Package");
         var _loc3_:XMLList = XML(param1).child("SoldCounter");
         if(_loc3_.length() > 0)
         {
            this.updateSoldCounters(_loc3_);
         }
         if(_loc2_.length() > 0)
         {
            this.parse(_loc2_);
         }
         else if(this.packageModel.getInitialized())
         {
            this.packageModel.updateSignal.dispatch();
         }
         completeTask(true);
      }
      
      private function updateSoldCounters(param1:XMLList) : void
      {
         var _loc2_:XML = null;
         var _loc3_:PackageInfo = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = this.packageModel.getPackageById(_loc2_.attribute("id").toString());
            if(_loc3_ != null)
            {
               if(_loc2_.attribute("left") != "-1")
               {
                  _loc3_.unitsLeft = _loc2_.attribute("left");
               }
               if(_loc2_.attribute("purchaseLeft") != "-1")
               {
                  _loc3_.purchaseLeft = _loc2_.attribute("purchaseLeft");
               }
            }
         }
      }
      
      private function hasNoPackage(param1:*) : Boolean
      {
         var _loc2_:XMLList = XML(param1).children();
         var _loc3_:* = _loc2_.length() == 0;
         return _loc3_;
      }
      
      private function parse(param1:XMLList) : void
      {
         var _loc3_:XML = null;
         var _loc4_:PackageInfo = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc4_ = new PackageInfo();
            _loc4_.id = _loc3_.attribute("id").toString();
            _loc4_.title = _loc3_.attribute("title").toString();
            _loc4_.weight = _loc3_.attribute("weight").toString();
            _loc4_.description = _loc3_.Description.toString();
            _loc4_.contents = _loc3_.Contents.toString();
            _loc4_.priceAmount = int(_loc3_.Price.attribute("amount").toString());
            _loc4_.priceCurrency = _loc3_.Price.attribute("currency").toString();
            if(_loc3_.hasOwnProperty("Sale"))
            {
               _loc4_.saleAmount = int(_loc3_.Sale.attribute("price").toString());
               _loc4_.saleCurrency = int(_loc3_.Sale.attribute("currency").toString());
            }
            if(_loc3_.hasOwnProperty("Left"))
            {
               _loc4_.unitsLeft = _loc3_.Left;
            }
            if(_loc3_.hasOwnProperty("MaxPurchase"))
            {
               _loc4_.maxPurchase = _loc3_.MaxPurchase;
            }
            if(_loc3_.hasOwnProperty("PurchaseLeft"))
            {
               _loc4_.purchaseLeft = _loc3_.PurchaseLeft;
            }
            if(_loc3_.hasOwnProperty("ShowOnLogin"))
            {
               _loc4_.showOnLogin = int(_loc3_.ShowOnLogin) == 1;
            }
            if(_loc3_.hasOwnProperty("Total"))
            {
               _loc4_.totalUnits = _loc3_.Total;
            }
            if(_loc3_.hasOwnProperty("Slot"))
            {
               _loc4_.slot = _loc3_.Slot;
            }
            if(_loc3_.hasOwnProperty("Tags"))
            {
               _loc4_.tags = _loc3_.Tags;
            }
            if(_loc3_.StartTime.toString())
            {
               _loc4_.startTime = TimeUtil.parseUTCDate(_loc3_.StartTime.toString());
            }
            if(_loc3_.EndTime.toString())
            {
               _loc4_.endTime = TimeUtil.parseUTCDate(_loc3_.EndTime.toString());
            }
            _loc4_.image = _loc3_.Image.toString();
            _loc4_.charSlot = int(_loc3_.CharSlot.toString());
            _loc4_.vaultSlot = int(_loc3_.VaultSlot.toString());
            _loc4_.gold = int(_loc3_.Gold.toString());
            if(_loc3_.PopupImage.toString() != "")
            {
               _loc4_.popupImage = _loc3_.PopupImage.toString();
            }
            _loc2_.push(_loc4_);
         }
         this.packageModel.setPackages(_loc2_);
      }
   }
}
