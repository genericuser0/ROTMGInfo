package kabam.rotmg.mysterybox.services
{
   import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
   import org.osflash.signals.Signal;
   
   public class MysteryBoxModel
   {
       
      
      private var models:Object;
      
      private var initialized:Boolean = false;
      
      private var _isNew:Boolean = false;
      
      private var maxSlots:int = 18;
      
      public const updateSignal:Signal = new Signal();
      
      public function MysteryBoxModel()
      {
         super();
      }
      
      public function getBoxesOrderByWeight() : Object
      {
         return this.models;
      }
      
      public function getBoxesForGrid() : Vector.<MysteryBoxInfo>
      {
         var _loc2_:MysteryBoxInfo = null;
         var _loc1_:Vector.<MysteryBoxInfo> = new Vector.<MysteryBoxInfo>(this.maxSlots);
         for each(_loc2_ in this.models)
         {
            if(_loc2_.slot != 0 && this.isBoxValid(_loc2_))
            {
               _loc1_[_loc2_.slot - 1] = _loc2_;
            }
         }
         return _loc1_;
      }
      
      private function isBoxValid(param1:MysteryBoxInfo) : Boolean
      {
         return (param1.unitsLeft == -1 || param1.unitsLeft > 0) && (param1.maxPurchase == -1 || param1.purchaseLeft > 0);
      }
      
      public function getBoxById(param1:String) : MysteryBoxInfo
      {
         var _loc2_:MysteryBoxInfo = null;
         for each(_loc2_ in this.models)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function setMysetryBoxes(param1:Array) : void
      {
         var _loc2_:MysteryBoxInfo = null;
         this.models = {};
         for each(_loc2_ in param1)
         {
            this.models[_loc2_.id] = _loc2_;
         }
         this.updateSignal.dispatch();
         this.initialized = true;
      }
      
      public function isInitialized() : Boolean
      {
         return this.initialized;
      }
      
      public function setInitialized(param1:Boolean) : void
      {
         this.initialized = param1;
      }
      
      public function get isNew() : Boolean
      {
         return this._isNew;
      }
      
      public function set isNew(param1:Boolean) : void
      {
         this._isNew = param1;
      }
   }
}
