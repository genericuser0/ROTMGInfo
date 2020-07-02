package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.util.MoreStringUtil;
   import flash.utils.Dictionary;
   
   class EnemyChooser extends Chooser
   {
       
      
      private var cache:Dictionary;
      
      private var lastSearch:String = "";
      
      private var filterTypes:Dictionary;
      
      function EnemyChooser()
      {
         this.filterTypes = new Dictionary(true);
         super(Layer.OBJECT);
         this.cache = new Dictionary();
         this.filterTypes[ObjectLibrary.ENEMY_FILTER_LIST[0]] = "";
         this.filterTypes[ObjectLibrary.ENEMY_FILTER_LIST[1]] = "MaxHitPoints";
         this.filterTypes[ObjectLibrary.ENEMY_FILTER_LIST[2]] = ObjectLibrary.ENEMY_FILTER_LIST[2];
      }
      
      public function getLastSearch() : String
      {
         return this.lastSearch;
      }
      
      public function reloadObjects(param1:String, param2:String = "", param3:Number = 0, param4:Number = -1) : void
      {
         var _loc7_:XML = null;
         var _loc10_:RegExp = null;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc14_:ObjectElement = null;
         removeElements();
         this.lastSearch = param1;
         var _loc5_:* = true;
         var _loc6_:* = true;
         var _loc8_:Number = -1;
         var _loc9_:Vector.<String> = new Vector.<String>();
         if(param1 != "")
         {
            _loc10_ = new RegExp(param1,"gix");
         }
         if(param2 != "")
         {
            param2 = this.filterTypes[param2];
         }
         var _loc11_:Dictionary = GroupDivider.GROUPS["Enemies"];
         for each(_loc7_ in _loc11_)
         {
            _loc12_ = String(_loc7_.@id);
            if(!(_loc10_ != null && _loc12_.search(_loc10_) < 0))
            {
               if(param2 != "")
               {
                  _loc8_ = !!_loc7_.hasOwnProperty(param2)?Number(Number(_loc7_.elements(param2))):Number(-1);
                  if(_loc8_ < 0)
                  {
                     continue;
                  }
                  _loc5_ = _loc8_ >= param3;
                  _loc6_ = !(param4 > 0 && _loc8_ > param4);
               }
               if(_loc5_ && _loc6_)
               {
                  _loc9_.push(_loc12_);
               }
            }
         }
         _loc9_.sort(MoreStringUtil.cmp);
         for each(_loc12_ in _loc9_)
         {
            _loc13_ = ObjectLibrary.idToType_[_loc12_];
            if(!this.cache[_loc13_])
            {
               _loc14_ = new ObjectElement(ObjectLibrary.xmlLibrary_[_loc13_]);
               this.cache[_loc13_] = _loc14_;
            }
            else
            {
               _loc14_ = this.cache[_loc13_];
            }
            addElement(_loc14_);
         }
         hasBeenLoaded = true;
         scrollBar_.setIndicatorSize(HEIGHT,elementContainer_.height,true);
      }
   }
}
