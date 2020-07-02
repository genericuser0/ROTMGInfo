package kabam.rotmg.mysterybox.services
{
   import com.company.assembleegameclient.util.TimeUtil;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.fortune.model.FortuneInfo;
   import kabam.rotmg.fortune.services.FortuneModel;
   import kabam.rotmg.language.model.LanguageModel;
   import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
   import robotlegs.bender.framework.api.ILogger;
   
   public class GetMysteryBoxesTask extends BaseTask
   {
      
      private static var version:String = "0";
       
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var mysteryBoxModel:MysteryBoxModel;
      
      [Inject]
      public var fortuneModel:FortuneModel;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var languageModel:LanguageModel;
      
      [Inject]
      public var openDialogSignal:OpenDialogSignal;
      
      public function GetMysteryBoxesTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         var _loc1_:Object = this.account.getCredentials();
         _loc1_.language = this.languageModel.getLanguage();
         _loc1_.version = version;
         this.client.sendRequest("/mysterybox/getBoxes",_loc1_);
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
            this.logger.warn("GetMysteryBox.onComplete: Request failed.");
            completeTask(true);
         }
         reset();
      }
      
      private function handleOkay(param1:*) : void
      {
         version = XML(param1).attribute("version").toString();
         var _loc2_:XMLList = XML(param1).child("MysteryBox");
         var _loc3_:XMLList = XML(param1).child("SoldCounter");
         if(_loc3_.length() > 0)
         {
            this.updateSoldCounters(_loc3_);
         }
         if(_loc2_.length() > 0)
         {
            this.parse(_loc2_);
         }
         else if(this.mysteryBoxModel.isInitialized())
         {
            this.mysteryBoxModel.updateSignal.dispatch();
         }
         var _loc4_:XMLList = XML(param1).child("FortuneGame");
         if(_loc4_.length() > 0)
         {
            this.parseFortune(_loc4_);
         }
         completeTask(true);
      }
      
      private function hasNoBoxes(param1:*) : Boolean
      {
         var _loc2_:XMLList = XML(param1).children();
         var _loc3_:* = _loc2_.length() == 0;
         return _loc3_;
      }
      
      private function parseFortune(param1:XMLList) : void
      {
         var _loc2_:FortuneInfo = new FortuneInfo();
         _loc2_.id = param1.attribute("id").toString();
         _loc2_.title = param1.attribute("title").toString();
         _loc2_.weight = param1.attribute("weight").toString();
         _loc2_.description = param1.Description.toString();
         _loc2_.contents = param1.Contents.toString();
         _loc2_.priceFirstInGold = param1.Price.attribute("firstInGold").toString();
         _loc2_.priceFirstInToken = param1.Price.attribute("firstInToken").toString();
         _loc2_.priceSecondInGold = param1.Price.attribute("secondInGold").toString();
         _loc2_.iconImageUrl = param1.Icon.toString();
         _loc2_.infoImageUrl = param1.Image.toString();
         _loc2_.startTime = TimeUtil.parseUTCDate(param1.StartTime.toString());
         _loc2_.endTime = TimeUtil.parseUTCDate(param1.EndTime.toString());
         _loc2_.parseContents();
         this.fortuneModel.setFortune(_loc2_);
      }
      
      private function updateSoldCounters(param1:XMLList) : void
      {
         var _loc2_:XML = null;
         var _loc3_:MysteryBoxInfo = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = this.mysteryBoxModel.getBoxById(_loc2_.attribute("id").toString());
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
      
      private function parse(param1:XMLList) : void
      {
         var _loc4_:XML = null;
         var _loc5_:MysteryBoxInfo = null;
         var _loc2_:Array = [];
         var _loc3_:Boolean = false;
         for each(_loc4_ in param1)
         {
            _loc5_ = new MysteryBoxInfo();
            _loc5_.id = _loc4_.attribute("id").toString();
            _loc5_.title = _loc4_.attribute("title").toString();
            _loc5_.weight = _loc4_.attribute("weight").toString();
            _loc5_.description = _loc4_.Description.toString();
            _loc5_.contents = _loc4_.Contents.toString();
            _loc5_.priceAmount = int(_loc4_.Price.attribute("amount").toString());
            _loc5_.priceCurrency = _loc4_.Price.attribute("currency").toString();
            if(_loc4_.hasOwnProperty("Sale"))
            {
               _loc5_.saleAmount = _loc4_.Sale.attribute("price").toString();
               _loc5_.saleCurrency = _loc4_.Sale.attribute("currency").toString();
            }
            if(_loc4_.hasOwnProperty("Left"))
            {
               _loc5_.unitsLeft = _loc4_.Left;
            }
            if(_loc4_.hasOwnProperty("Total"))
            {
               _loc5_.totalUnits = _loc4_.Total;
            }
            if(_loc4_.hasOwnProperty("Slot"))
            {
               _loc5_.slot = _loc4_.Slot;
            }
            if(_loc4_.hasOwnProperty("Jackpots"))
            {
               _loc5_.jackpots = _loc4_.Jackpots;
            }
            if(_loc4_.hasOwnProperty("DisplayedItems"))
            {
               _loc5_.displayedItems = _loc4_.DisplayedItems;
            }
            if(_loc4_.hasOwnProperty("Rolls"))
            {
               _loc5_.rolls = int(_loc4_.Rolls);
            }
            if(_loc4_.hasOwnProperty("Tags"))
            {
               _loc5_.tags = _loc4_.Tags;
            }
            if(_loc4_.hasOwnProperty("MaxPurchase"))
            {
               _loc5_.maxPurchase = _loc4_.MaxPurchase;
            }
            if(_loc4_.hasOwnProperty("PurchaseLeft"))
            {
               _loc5_.purchaseLeft = int(_loc4_.PurchaseLeft);
            }
            _loc5_.iconImageUrl = _loc4_.Icon.toString();
            _loc5_.infoImageUrl = _loc4_.Image.toString();
            _loc5_.startTime = TimeUtil.parseUTCDate(_loc4_.StartTime.toString());
            if(_loc4_.EndTime.toString())
            {
               _loc5_.endTime = TimeUtil.parseUTCDate(_loc4_.EndTime.toString());
            }
            _loc5_.parseContents();
            if(!_loc3_ && (_loc5_.isNew() || _loc5_.isOnSale()))
            {
               _loc3_ = true;
            }
            _loc2_.push(_loc5_);
         }
         this.mysteryBoxModel.setMysetryBoxes(_loc2_);
         this.mysteryBoxModel.isNew = _loc3_;
      }
   }
}
