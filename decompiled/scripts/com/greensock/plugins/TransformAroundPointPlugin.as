package com.greensock.plugins
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   
   public class TransformAroundPointPlugin extends TweenPlugin
   {
      
      private static var _classInitted:Boolean;
      
      private static var _isFlex:Boolean;
      
      public static const API:Number = 2;
       
      
      protected var _yRound:Boolean;
      
      protected var _useAddElement:Boolean;
      
      protected var _local:Point;
      
      protected var _proxy:DisplayObject;
      
      protected var _target:DisplayObject;
      
      protected var _point:Point;
      
      protected var _xRound:Boolean;
      
      protected var _pointIsLocal:Boolean;
      
      protected var _proxySizeData:Object;
      
      protected var _shortRotation:ShortRotationPlugin;
      
      public function TransformAroundPointPlugin()
      {
         super("transformAroundPoint,transformAroundCenter,x,y",-1);
      }
      
      private static function _applyMatrix(param1:Point, param2:Matrix) : Point
      {
         var _loc5_:Number = NaN;
         var _loc3_:Number = param1.x * param2.a + param1.y * param2.c + param2.tx;
         var _loc4_:Number = param1.x * param2.b + param1.y * param2.d + param2.ty;
         _loc3_ = !!(_loc5_ = Number(_loc3_ - (_loc3_ = Number(_loc3_ | 0))))?Number((_loc5_ < 0.3?0:_loc5_ < 0.7?0.5:1) + _loc3_):Number(_loc3_);
         _loc4_ = !!(_loc5_ = Number(_loc4_ - (_loc4_ = Number(_loc4_ | 0))))?Number((_loc5_ < 0.3?0:_loc5_ < 0.7?0.5:1) + _loc4_):Number(_loc4_);
         return new Point(_loc3_,_loc4_);
      }
      
      override public function _kill(param1:Object) : Boolean
      {
         if(_shortRotation != null)
         {
            _shortRotation._kill(param1);
            if(_shortRotation._overwriteProps.length == 0)
            {
               param1.shortRotation = true;
            }
         }
         return super._kill(param1);
      }
      
      override public function setRatio(param1:Number) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Matrix = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(_proxy != null && _proxy.parent != null)
         {
            if(_useAddElement)
            {
               Object(_proxy.parent).addElement(_target.parent);
            }
            else
            {
               _proxy.parent.addChild(_target.parent);
            }
         }
         if(_pointIsLocal)
         {
            _loc2_ = _applyMatrix(_local,_target.transform.matrix);
            if(Math.abs(_loc2_.x - _point.x) > 0.5 || Math.abs(_loc2_.y - _point.y) > 0.5)
            {
               _point = _loc2_;
            }
         }
         super.setRatio(param1);
         _loc3_ = _target.transform.matrix;
         _loc4_ = _local.x * _loc3_.a + _local.y * _loc3_.c + _loc3_.tx;
         _loc5_ = _local.x * _loc3_.b + _local.y * _loc3_.d + _loc3_.ty;
         _target.x = !_xRound?Number(_target.x + _point.x - _loc4_):(_loc6_ = Number(_target.x + _point.x - _loc4_)) > 0?Number(_loc6_ + 0.5 >> 0):Number(_loc6_ - 0.5 >> 0);
         _target.y = !_yRound?Number(_target.y + _point.y - _loc5_):(_loc6_ = Number(_target.y + _point.y - _loc5_)) > 0?Number(_loc6_ + 0.5 >> 0):Number(_loc6_ - 0.5 >> 0);
         if(_proxy != null)
         {
            _loc7_ = _target.rotation;
            _proxy.rotation = _target.rotation = 0;
            if(_proxySizeData.width != null)
            {
               _proxy.width = _target.width = _proxySizeData.width;
            }
            if(_proxySizeData.height != null)
            {
               _proxy.height = _target.height = _proxySizeData.height;
            }
            _proxy.rotation = _target.rotation = _loc7_;
            _loc3_ = _target.transform.matrix;
            _loc4_ = _local.x * _loc3_.a + _local.y * _loc3_.c + _loc3_.tx;
            _loc5_ = _local.x * _loc3_.b + _local.y * _loc3_.d + _loc3_.ty;
            _proxy.x = !_xRound?Number(_target.x + _point.x - _loc4_):(_loc6_ = Number(_target.x + _point.x - _loc4_)) > 0?Number(_loc6_ + 0.5 >> 0):Number(_loc6_ - 0.5 >> 0);
            _proxy.y = !_yRound?Number(_target.y + _point.y - _loc5_):(_loc6_ = Number(_target.y + _point.y - _loc5_)) > 0?Number(_loc6_ + 0.5 >> 0):Number(_loc6_ - 0.5 >> 0);
            if(_proxy.parent != null)
            {
               if(_useAddElement)
               {
                  Object(_proxy.parent).removeElement(_target.parent);
               }
               else
               {
                  _proxy.parent.removeChild(_target.parent);
               }
            }
         }
      }
      
      override public function _roundProps(param1:Object, param2:Boolean = true) : void
      {
         if("transformAroundPoint" in param1)
         {
            _xRound = _yRound = param2;
         }
         else if("x" in param1)
         {
            _xRound = param2;
         }
         else if("y" in param1)
         {
            _yRound = param2;
         }
      }
      
      override public function _onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         var matrixCopy:Matrix = null;
         var p:String = null;
         var short:ShortRotationPlugin = null;
         var sp:String = null;
         var point:Point = null;
         var b:Rectangle = null;
         var s:Sprite = null;
         var container:Sprite = null;
         var enumerables:Object = null;
         var endX:Number = NaN;
         var endY:Number = NaN;
         var target:Object = param1;
         var value:* = param2;
         var tween:TweenLite = param3;
         if(!(value.point is Point))
         {
            return false;
         }
         _target = target as DisplayObject;
         var m:Matrix = _target.transform.matrix;
         if(value.pointIsLocal == true)
         {
            _pointIsLocal = true;
            _local = value.point.clone();
            _point = _applyMatrix(_local,m);
         }
         else
         {
            _point = value.point.clone();
            matrixCopy = m.clone();
            matrixCopy.invert();
            _local = _applyMatrix(_point,matrixCopy);
         }
         if(!_classInitted)
         {
            try
            {
               _isFlex = Boolean(getDefinitionByName("mx.managers.SystemManager"));
            }
            catch(e:Error)
            {
               _isFlex = false;
            }
            _classInitted = true;
         }
         if((!isNaN(value.width) || !isNaN(value.height)) && _target.parent != null)
         {
            point = _target.parent.globalToLocal(_target.localToGlobal(new Point(100,100)));
            _target.width = _target.width * 2;
            if(point.x == _target.parent.globalToLocal(_target.localToGlobal(new Point(100,100))).x)
            {
               _proxy = _target;
               _target.rotation = 0;
               _proxySizeData = {};
               if(!isNaN(value.width))
               {
                  _addTween(_proxySizeData,"width",_target.width / 2,value.width,"width");
               }
               if(!isNaN(value.height))
               {
                  _addTween(_proxySizeData,"height",_target.height,value.height,"height");
               }
               b = _target.getBounds(_target);
               s = new Sprite();
               container = !!_isFlex?new getDefinitionByName("mx.core.UIComponent")():new Sprite();
               container.addChild(s);
               container.visible = false;
               _useAddElement = Boolean(_isFlex && _proxy.parent.hasOwnProperty("addElement"));
               if(_useAddElement)
               {
                  Object(_proxy.parent).addElement(container);
               }
               else
               {
                  _proxy.parent.addChild(container);
               }
               _target = s;
               s.graphics.beginFill(255,0.4);
               s.graphics.drawRect(b.x,b.y,b.width,b.height);
               s.graphics.endFill();
               _proxy.width = _proxy.width / 2;
               s.transform.matrix = _target.transform.matrix = m;
            }
            else
            {
               _target.width = _target.width / 2;
               _target.transform.matrix = m;
            }
         }
         for(p in value)
         {
            if(!(p == "point" || p == "pointIsLocal"))
            {
               if(p == "shortRotation")
               {
                  _shortRotation = new ShortRotationPlugin();
                  _shortRotation._onInitTween(_target,value[p],tween);
                  _addTween(_shortRotation,"setRatio",0,1,"shortRotation");
                  for(sp in value[p])
                  {
                     _overwriteProps[_overwriteProps.length] = sp;
                  }
               }
               else if(p == "x" || p == "y")
               {
                  _addTween(_point,p,_point[p],value[p],p);
               }
               else if(p == "scale")
               {
                  _addTween(_target,"scaleX",_target.scaleX,value.scale,"scaleX");
                  _addTween(_target,"scaleY",_target.scaleY,value.scale,"scaleY");
                  _overwriteProps[_overwriteProps.length] = "scaleX";
                  _overwriteProps[_overwriteProps.length] = "scaleY";
               }
               else if(!((p == "width" || p == "height") && _proxy != null))
               {
                  _addTween(_target,p,_target[p],value[p],p);
                  _overwriteProps[_overwriteProps.length] = p;
               }
            }
         }
         if(tween != null)
         {
            enumerables = tween.vars;
            if("x" in enumerables || "y" in enumerables)
            {
               if("x" in enumerables)
               {
                  endX = typeof enumerables.x == "number"?Number(enumerables.x):Number(_target.x + Number(enumerables.x.split("=").join("")));
               }
               if("y" in enumerables)
               {
                  endY = typeof enumerables.y == "number"?Number(enumerables.y):Number(_target.y + Number(enumerables.y.split("=").join("")));
               }
               tween._kill({
                  "x":true,
                  "y":true,
                  "_tempKill":true
               },_target);
               this.setRatio(1);
               if(!isNaN(endX))
               {
                  _addTween(_point,"x",_point.x,_point.x + (endX - _target.x),"x");
               }
               if(!isNaN(endY))
               {
                  _addTween(_point,"y",_point.y,_point.y + (endY - _target.y),"y");
               }
               this.setRatio(0);
            }
         }
         return true;
      }
   }
}
