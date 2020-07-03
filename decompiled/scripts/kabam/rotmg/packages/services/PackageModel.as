package kabam.rotmg.packages.services
{
   import kabam.rotmg.packages.model.PackageInfo;
   import org.osflash.signals.Signal;
   
   public class PackageModel
   {
      
      public static const TARGETING_BOX_SLOT:int = 100;
       
      
      public var numSpammed:int = 0;
      
      private var models:Object;
      
      private var initialized:Boolean;
      
      private var maxSlots:int = 18;
      
      public const updateSignal:Signal = new Signal();
      
      public function PackageModel()
      {
         this.models = {};
         super();
      }
      
      public function getBoxesForGrid() : Vector.<PackageInfo>
      {
         var _loc2_:PackageInfo = null;
         var _loc1_:Vector.<PackageInfo> = new Vector.<PackageInfo>(this.maxSlots);
         for each(_loc2_ in this.models)
         {
            if(_loc2_.slot != 0 && _loc2_.slot != TARGETING_BOX_SLOT && this.isPackageValid(_loc2_))
            {
               _loc1_[_loc2_.slot - 1] = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function getTargetingBoxesForGrid() : Vector.<PackageInfo>
      {
         var _loc2_:PackageInfo = null;
         var _loc1_:Vector.<PackageInfo> = new Vector.<PackageInfo>(this.maxSlots);
         for each(_loc2_ in this.models)
         {
            if(_loc2_.slot == TARGETING_BOX_SLOT && this.isPackageValid(_loc2_))
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      private function isPackageValid(param1:PackageInfo) : Boolean
      {
         return (param1.unitsLeft == -1 || param1.unitsLeft > 0) && (param1.maxPurchase == -1 || param1.purchaseLeft > 0);
      }
      
      public function startupPackage() : PackageInfo
      {
         var _loc2_:PackageInfo = null;
         var _loc1_:PackageInfo = null;
         for each(_loc2_ in this.models)
         {
            if(_loc2_.slot == TARGETING_BOX_SLOT)
            {
               return _loc2_;
            }
            if(this.isPackageValid(_loc2_) && _loc2_.showOnLogin && _loc2_.popupImage != "")
            {
               if(_loc1_ != null)
               {
                  if(_loc2_.unitsLeft != -1 || _loc2_.maxPurchase != -1)
                  {
                     _loc1_ = _loc2_;
                  }
               }
               else
               {
                  _loc1_ = _loc2_;
               }
            }
         }
         return _loc1_;
      }
      
      public function getInitialized() : Boolean
      {
         return this.initialized;
      }
      
      public function getPackageById(param1:int) : PackageInfo
      {
         return this.models[param1];
      }
      
      public function hasPackage(param1:int) : Boolean
      {
         return param1 in this.models;
      }
      
      public function setPackages(param1:Array) : void
      {
         var _loc2_:PackageInfo = null;
         this.models = {};
         for each(_loc2_ in param1)
         {
            this.models[_loc2_.id] = _loc2_;
         }
         this.updateSignal.dispatch();
         this.initialized = true;
      }
      
      public function canPurchasePackage(param1:int) : Boolean
      {
         var _loc2_:PackageInfo = this.models[param1];
         return _loc2_ != null;
      }
      
      public function getPriorityPackage() : PackageInfo
      {
         var _loc1_:PackageInfo = null;
         return _loc1_;
      }
      
      public function setInitialized(param1:Boolean) : void
      {
         this.initialized = param1;
      }
      
      public function hasPackages() : Boolean
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.models)
         {
            return true;
         }
         return false;
      }
   }
}
