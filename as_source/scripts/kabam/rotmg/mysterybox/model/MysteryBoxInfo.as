package kabam.rotmg.mysterybox.model
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import io.decagames.rotmg.shop.genericBox.data.GenericBoxInfo;
   import kabam.display.Loader.LoaderProxy;
   import kabam.display.Loader.LoaderProxyConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class MysteryBoxInfo extends GenericBoxInfo
   {
       
      
      public var _iconImageUrl:String;
      
      private var _iconImage:DisplayObject;
      
      public var _infoImageUrl:String;
      
      private var _infoImage:DisplayObject;
      
      private var _loader:LoaderProxy;
      
      private var _infoImageLoader:LoaderProxy;
      
      public var _rollsWithContents:Vector.<Vector.<int>>;
      
      public var _rollsWithContentsUnique:Vector.<int>;
      
      private var _rollsContents:Vector.<Vector.<int>>;
      
      private var _rolls:int;
      
      private var _jackpots:String = "";
      
      private var _displayedItems:String = "";
      
      public function MysteryBoxInfo()
      {
         this._loader = new LoaderProxyConcrete();
         this._infoImageLoader = new LoaderProxyConcrete();
         this._rollsWithContents = new Vector.<Vector.<int>>();
         this._rollsWithContentsUnique = new Vector.<int>();
         this._rollsContents = new Vector.<Vector.<int>>();
         super();
      }
      
      public function get iconImageUrl() : *
      {
         return this._iconImageUrl;
      }
      
      public function set iconImageUrl(param1:String) : void
      {
         this._iconImageUrl = param1;
         this.loadIconImageFromUrl(this._iconImageUrl);
      }
      
      private function loadIconImageFromUrl(param1:String) : void
      {
         this._loader && this._loader.unload();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR,this.onError);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,this.onError);
         this._loader.load(new URLRequest(param1));
      }
      
      private function onError(param1:IOErrorEvent) : void
      {
      }
      
      private function onComplete(param1:Event) : void
      {
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR,this.onError);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.onError);
         this._iconImage = DisplayObject(this._loader);
      }
      
      public function get iconImage() : DisplayObject
      {
         return this._iconImage;
      }
      
      public function get infoImageUrl() : *
      {
         return this._infoImageUrl;
      }
      
      public function set infoImageUrl(param1:String) : void
      {
         this._infoImageUrl = param1;
         this.loadInfomageFromUrl(this._infoImageUrl);
      }
      
      private function loadInfomageFromUrl(param1:String) : void
      {
         this.loadImageFromUrl(param1,this._infoImageLoader);
      }
      
      private function loadImageFromUrl(param1:String, param2:LoaderProxy) : void
      {
         param2 && param2.unload();
         param2.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onInfoComplete);
         param2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onInfoError);
         param2.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR,this.onInfoError);
         param2.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,this.onInfoError);
         param2.load(new URLRequest(param1));
      }
      
      private function onInfoError(param1:IOErrorEvent) : void
      {
      }
      
      private function onInfoComplete(param1:Event) : void
      {
         this._infoImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onInfoComplete);
         this._infoImageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onInfoError);
         this._infoImageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR,this.onInfoError);
         this._infoImageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.onInfoError);
         this._infoImage = DisplayObject(this._infoImageLoader);
      }
      
      public function parseContents() : void
      {
         var _loc4_:String = null;
         var _loc5_:Vector.<int> = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc1_:Array = _contents.split(";");
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:int = 0;
         for each(_loc4_ in _loc1_)
         {
            _loc5_ = new Vector.<int>();
            _loc6_ = _loc4_.split(",");
            for each(_loc7_ in _loc6_)
            {
               if(_loc2_[int(_loc7_)] == null)
               {
                  _loc2_[int(_loc7_)] = true;
                  this._rollsWithContentsUnique.push(int(_loc7_));
               }
               _loc5_.push(int(_loc7_));
            }
            this._rollsWithContents.push(_loc5_);
            this._rollsContents[_loc3_] = _loc5_;
            _loc3_++;
         }
      }
      
      public function get currencyName() : String
      {
         switch(_priceCurrency)
         {
            case "0":
               return LineBuilder.getLocalizedStringFromKey("Currency.gold").toLowerCase();
            case "1":
               return LineBuilder.getLocalizedStringFromKey("Currency.fame").toLowerCase();
            default:
               return "";
         }
      }
      
      public function get infoImage() : DisplayObject
      {
         return this._infoImage;
      }
      
      public function set infoImage(param1:DisplayObject) : void
      {
         this._infoImage = param1;
      }
      
      public function get loader() : LoaderProxy
      {
         return this._loader;
      }
      
      public function set loader(param1:LoaderProxy) : void
      {
         this._loader = param1;
      }
      
      public function get infoImageLoader() : LoaderProxy
      {
         return this._infoImageLoader;
      }
      
      public function set infoImageLoader(param1:LoaderProxy) : void
      {
         this._infoImageLoader = param1;
      }
      
      public function get jackpots() : String
      {
         return this._jackpots;
      }
      
      public function set jackpots(param1:String) : void
      {
         this._jackpots = param1;
      }
      
      public function get rolls() : int
      {
         return this._rolls;
      }
      
      public function set rolls(param1:int) : void
      {
         this._rolls = param1;
      }
      
      public function get rollsContents() : Vector.<Vector.<int>>
      {
         return this._rollsContents;
      }
      
      public function get displayedItems() : String
      {
         return this._displayedItems;
      }
      
      public function set displayedItems(param1:String) : void
      {
         this._displayedItems = param1;
      }
   }
}
