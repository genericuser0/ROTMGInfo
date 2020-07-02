package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.map.GroundLibrary;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.util.MoreStringUtil;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   class GroundChooser extends Chooser
   {
       
      
      private var cache:Dictionary;
      
      private var lastSearch:String = "";
      
      function GroundChooser()
      {
         super(Layer.GROUND);
         this._init();
      }
      
      private function _init() : void
      {
         this.cache = new Dictionary();
         addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
      }
      
      public function getLastSearch() : String
      {
         return this.lastSearch;
      }
      
      public function reloadObjects(param1:String, param2:String = "ALL") : void
      {
         var _loc4_:RegExp = null;
         var _loc6_:String = null;
         var _loc7_:XML = null;
         var _loc8_:int = 0;
         var _loc9_:GroundElement = null;
         removeElements();
         this.lastSearch = param1;
         var _loc3_:Vector.<String> = new Vector.<String>();
         if(param1 != "")
         {
            _loc4_ = new RegExp(param1,"gix");
         }
         var _loc5_:Dictionary = GroupDivider.GROUPS["Ground"];
         for each(_loc7_ in _loc5_)
         {
            _loc6_ = String(_loc7_.@id);
            if(!(param2 != "ALL" && !this.runFilter(_loc7_,param2)))
            {
               if(_loc4_ == null || _loc6_.search(_loc4_) >= 0)
               {
                  _loc3_.push(_loc6_);
               }
            }
         }
         _loc3_.sort(MoreStringUtil.cmp);
         for each(_loc6_ in _loc3_)
         {
            _loc8_ = GroundLibrary.idToType_[_loc6_];
            _loc7_ = GroundLibrary.xmlLibrary_[_loc8_];
            if(!this.cache[_loc8_])
            {
               _loc9_ = new GroundElement(_loc7_);
               this.cache[_loc8_] = _loc9_;
            }
            else
            {
               _loc9_ = this.cache[_loc8_];
            }
            addElement(_loc9_);
         }
         hasBeenLoaded = true;
         scrollBar_.setIndicatorSize(HEIGHT,elementContainer_.height,true);
      }
      
      private function runFilter(param1:XML, param2:String) : Boolean
      {
         var _loc3_:int = 0;
         switch(param2)
         {
            case ObjectLibrary.TILE_FILTER_LIST[1]:
               return !param1.hasOwnProperty("NoWalk");
            case ObjectLibrary.TILE_FILTER_LIST[2]:
               return param1.hasOwnProperty("NoWalk");
            case ObjectLibrary.TILE_FILTER_LIST[3]:
               return param1.hasOwnProperty("Speed") && Number(param1.elements("Speed")) < 1;
            case ObjectLibrary.TILE_FILTER_LIST[4]:
               return !param1.hasOwnProperty("Speed") || Number(param1.elements("Speed")) >= 1;
            default:
               return true;
         }
      }
   }
}
