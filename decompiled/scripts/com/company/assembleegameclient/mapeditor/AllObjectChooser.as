package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.util.MoreStringUtil;
   import flash.utils.Dictionary;
   
   class AllObjectChooser extends Chooser
   {
      
      public static const GROUP_NAME_MAP_OBJECTS:String = "All Map Objects";
      
      public static const GROUP_NAME_GAME_OBJECTS:String = "All Game Objects";
       
      
      private var cache:Dictionary;
      
      private var lastSearch:String = "";
      
      function AllObjectChooser()
      {
         super(Layer.OBJECT);
         this.cache = new Dictionary();
      }
      
      public function getLastSearch() : String
      {
         return this.lastSearch;
      }
      
      public function reloadObjects(param1:String = "", param2:String = "All Map Objects") : void
      {
         var _loc4_:RegExp = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:XML = null;
         var _loc9_:int = 0;
         var _loc10_:ObjectElement = null;
         removeElements();
         this.lastSearch = param1;
         var _loc3_:Vector.<String> = new Vector.<String>();
         if(param1 != "")
         {
            _loc4_ = new RegExp(param1,"gix");
         }
         var _loc5_:Dictionary = GroupDivider.GROUPS[param2];
         for each(_loc8_ in _loc5_)
         {
            _loc6_ = String(_loc8_.@id);
            _loc7_ = int(_loc8_.@type);
            if(_loc4_ == null || _loc6_.search(_loc4_) >= 0 || _loc7_ == int(param1))
            {
               _loc3_.push(_loc6_);
            }
         }
         _loc3_.sort(MoreStringUtil.cmp);
         for each(_loc6_ in _loc3_)
         {
            _loc9_ = ObjectLibrary.idToType_[_loc6_];
            _loc8_ = ObjectLibrary.xmlLibrary_[_loc9_];
            if(!this.cache[_loc9_])
            {
               _loc10_ = new ObjectElement(_loc8_);
               if(param2 == GROUP_NAME_GAME_OBJECTS)
               {
                  _loc10_.downloadOnly = true;
               }
               this.cache[_loc9_] = _loc10_;
            }
            else
            {
               _loc10_ = this.cache[_loc9_];
            }
            addElement(_loc10_);
         }
         hasBeenLoaded = true;
         scrollBar_.setIndicatorSize(HEIGHT,elementContainer_.height,true);
      }
   }
}
