package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.util.MoreStringUtil;
   import flash.utils.Dictionary;
   
   public class DungeonChooser extends Chooser
   {
       
      
      public var currentDungon:String = "";
      
      private var cache:Dictionary;
      
      private var lastSearch:String = "";
      
      public function DungeonChooser()
      {
         super(Layer.OBJECT);
         this.cache = new Dictionary();
      }
      
      public function getLastSearch() : String
      {
         return this.lastSearch;
      }
      
      public function reloadObjects(param1:String, param2:String) : void
      {
         var _loc4_:RegExp = null;
         var _loc6_:String = null;
         var _loc7_:XML = null;
         var _loc8_:int = 0;
         var _loc9_:ObjectElement = null;
         this.currentDungon = param1;
         removeElements();
         this.lastSearch = param2;
         var _loc3_:Vector.<String> = new Vector.<String>();
         if(param2 != "")
         {
            _loc4_ = new RegExp(param2,"gix");
         }
         var _loc5_:Dictionary = GroupDivider.getDungeonsXML(this.currentDungon);
         for each(_loc7_ in _loc5_)
         {
            _loc6_ = String(_loc7_.@id);
            if(_loc4_ == null || _loc6_.search(_loc4_) >= 0)
            {
               _loc3_.push(_loc6_);
            }
         }
         _loc3_.sort(MoreStringUtil.cmp);
         for each(_loc6_ in _loc3_)
         {
            _loc8_ = ObjectLibrary.idToType_[_loc6_];
            _loc7_ = _loc5_[_loc8_];
            if(!this.cache[_loc8_])
            {
               _loc9_ = new ObjectElement(_loc7_);
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
   }
}
