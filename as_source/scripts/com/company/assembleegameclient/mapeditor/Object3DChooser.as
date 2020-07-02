package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.util.MoreStringUtil;
   import flash.utils.Dictionary;
   
   public class Object3DChooser extends Chooser
   {
       
      
      private var cache:Dictionary;
      
      private var lastSearch:String = "";
      
      public function Object3DChooser()
      {
         super(Layer.OBJECT);
         this.cache = new Dictionary();
      }
      
      public function getLastSearch() : String
      {
         return this.lastSearch;
      }
      
      public function reloadObjects(param1:String = "") : void
      {
         var _loc3_:RegExp = null;
         var _loc5_:String = null;
         var _loc6_:XML = null;
         var _loc7_:int = 0;
         var _loc8_:ObjectElement = null;
         removeElements();
         this.lastSearch = param1;
         var _loc2_:Vector.<String> = new Vector.<String>();
         if(param1 != "")
         {
            _loc3_ = new RegExp(param1,"gix");
         }
         var _loc4_:Dictionary = GroupDivider.GROUPS["3D Objects"];
         for each(_loc6_ in _loc4_)
         {
            _loc5_ = String(_loc6_.@id);
            if(_loc3_ == null || _loc5_.search(_loc3_) >= 0)
            {
               _loc2_.push(_loc5_);
            }
         }
         _loc2_.sort(MoreStringUtil.cmp);
         for each(_loc5_ in _loc2_)
         {
            _loc7_ = ObjectLibrary.idToType_[_loc5_];
            _loc6_ = ObjectLibrary.xmlLibrary_[_loc7_];
            if(!this.cache[_loc7_])
            {
               _loc8_ = new ObjectElement(_loc6_);
               this.cache[_loc7_] = _loc8_;
            }
            else
            {
               _loc8_ = this.cache[_loc7_];
            }
            addElement(_loc8_);
         }
         hasBeenLoaded = true;
         scrollBar_.setIndicatorSize(HEIGHT,elementContainer_.height,true);
      }
   }
}
