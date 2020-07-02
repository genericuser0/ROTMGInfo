package com.greensock
{
   import com.greensock.core.Animation;
   import com.greensock.easing.Ease;
   import com.greensock.events.TweenEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class TimelineMax extends TimelineLite implements IEventDispatcher
   {
      
      protected static var _easeNone:Ease = new Ease(null,null,1,0);
      
      public static const version:String = "12.1.5";
      
      protected static var _listenerLookup:Object = {
         "onCompleteListener":TweenEvent.COMPLETE,
         "onUpdateListener":TweenEvent.UPDATE,
         "onStartListener":TweenEvent.START,
         "onRepeatListener":TweenEvent.REPEAT,
         "onReverseCompleteListener":TweenEvent.REVERSE_COMPLETE
      };
       
      
      protected var _dispatcher:EventDispatcher;
      
      protected var _yoyo:Boolean;
      
      protected var _hasUpdateListener:Boolean;
      
      protected var _cycle:int = 0;
      
      protected var _locked:Boolean;
      
      protected var _repeatDelay:Number;
      
      protected var _repeat:int;
      
      public function TimelineMax(param1:Object = null)
      {
         super(param1);
         _repeat = int(this.vars.repeat) || 0;
         _repeatDelay = Number(this.vars.repeatDelay) || Number(0);
         _yoyo = this.vars.yoyo == true;
         _dirty = true;
         if(this.vars.onCompleteListener || this.vars.onUpdateListener || this.vars.onStartListener || this.vars.onRepeatListener || this.vars.onReverseCompleteListener)
         {
            _initDispatcher();
         }
      }
      
      protected static function _getGlobalPaused(param1:Animation) : Boolean
      {
         while(param1)
         {
            if(param1._paused)
            {
               return true;
            }
            param1 = param1._timeline;
         }
         return false;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return _dispatcher == null?false:Boolean(_dispatcher.dispatchEvent(param1));
      }
      
      public function currentLabel(param1:String = null) : *
      {
         if(!arguments.length)
         {
            return getLabelBefore(_time + 1.0e-8);
         }
         return seek(param1,true);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return _dispatcher == null?false:Boolean(_dispatcher.hasEventListener(param1));
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         if(_dispatcher != null)
         {
            _dispatcher.removeEventListener(param1,param2,param3);
         }
      }
      
      public function addCallback(param1:Function, param2:*, param3:Array = null) : TimelineMax
      {
         return add(TweenLite.delayedCall(0,param1,param3),param2) as TimelineMax;
      }
      
      public function tweenFromTo(param1:*, param2:*, param3:Object = null) : TweenLite
      {
         param3 = param3 || {};
         param1 = _parseTimeOrLabel(param1);
         param3.startAt = {
            "onComplete":seek,
            "onCompleteParams":[param1]
         };
         param3.immediateRender = param3.immediateRender !== false;
         var _loc4_:TweenLite = tweenTo(param2,param3);
         return _loc4_.duration(Number(Math.abs(_loc4_.vars.time - param1) / _timeScale) || Number(0.001)) as TweenLite;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         if(_dispatcher == null)
         {
            _dispatcher = new EventDispatcher(this);
         }
         if(param1 == TweenEvent.UPDATE)
         {
            _hasUpdateListener = true;
         }
         _dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function tweenTo(param1:*, param2:Object = null) : TweenLite
      {
         var p:String = null;
         var duration:Number = NaN;
         var t:TweenLite = null;
         var position:* = param1;
         var vars:Object = param2;
         vars = vars || {};
         var copy:Object = {
            "ease":_easeNone,
            "overwrite":(!!vars.delay?2:1),
            "useFrames":usesFrames(),
            "immediateRender":false
         };
         for(p in vars)
         {
            copy[p] = vars[p];
         }
         copy.time = _parseTimeOrLabel(position);
         duration = Number(Math.abs(Number(copy.time) - _time) / _timeScale) || Number(0.001);
         t = new TweenLite(this,duration,copy);
         copy.onStart = function():void
         {
            t.target.paused(true);
            if(t.vars.time != t.target.time() && duration === t.duration())
            {
               t.duration(Math.abs(t.vars.time - t.target.time()) / t.target._timeScale);
            }
            if(vars.onStart)
            {
               vars.onStart.apply(null,vars.onStartParams);
            }
         };
         return t;
      }
      
      public function repeat(param1:Number = 0) : *
      {
         if(!arguments.length)
         {
            return _repeat;
         }
         _repeat = param1;
         return _uncache(true);
      }
      
      public function getLabelBefore(param1:Number = NaN) : String
      {
         if(!param1)
         {
            if(param1 != 0)
            {
               param1 = _time;
            }
         }
         var _loc2_:Array = getLabelsArray();
         var _loc3_:int = _loc2_.length;
         while(--_loc3_ > -1)
         {
            if(_loc2_[_loc3_].time < param1)
            {
               return _loc2_[_loc3_].name;
            }
         }
         return null;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return _dispatcher == null?false:Boolean(_dispatcher.willTrigger(param1));
      }
      
      override public function totalProgress(param1:Number = NaN, param2:Boolean = true) : *
      {
         return !arguments.length?_totalTime / totalDuration():totalTime(totalDuration() * param1,param2);
      }
      
      public function getLabelsArray() : Array
      {
         var _loc3_:* = null;
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         for(_loc3_ in _labels)
         {
            _loc1_[_loc2_++] = {
               "time":_labels[_loc3_],
               "name":_loc3_
            };
         }
         _loc1_.sortOn("time",Array.NUMERIC);
         return _loc1_;
      }
      
      override public function render(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc12_:Animation = null;
         var _loc13_:Boolean = false;
         var _loc14_:Animation = null;
         var _loc15_:Number = NaN;
         var _loc16_:String = null;
         var _loc17_:Boolean = false;
         var _loc18_:Number = NaN;
         var _loc19_:* = false;
         var _loc20_:* = false;
         var _loc21_:Number = NaN;
         var _loc22_:int = 0;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         if(_gc)
         {
            _enabled(true,false);
         }
         var _loc4_:Number = !_dirty?Number(_totalDuration):Number(totalDuration());
         var _loc5_:Number = _time;
         var _loc6_:Number = _totalTime;
         var _loc7_:Number = _startTime;
         var _loc8_:Number = _timeScale;
         var _loc9_:Number = _rawPrevTime;
         var _loc10_:Boolean = _paused;
         var _loc11_:int = _cycle;
         if(param1 >= _loc4_)
         {
            if(!_locked)
            {
               _totalTime = _loc4_;
               _cycle = _repeat;
            }
            if(!_reversed)
            {
               if(!_hasPausedChild())
               {
                  _loc13_ = true;
                  _loc16_ = "onComplete";
                  if(_duration === 0)
                  {
                     if(param1 === 0 || _rawPrevTime < 0 || _rawPrevTime === _tinyNum)
                     {
                        if(_rawPrevTime !== param1 && _first != null)
                        {
                           _loc17_ = true;
                           if(_rawPrevTime > _tinyNum)
                           {
                              _loc16_ = "onReverseComplete";
                           }
                        }
                     }
                  }
               }
            }
            _rawPrevTime = _duration || !param2 || param1 !== 0 || _rawPrevTime === param1?Number(param1):Number(_tinyNum);
            if(_yoyo && (_cycle & 1) != 0)
            {
               _time = param1 = 0;
            }
            else
            {
               _time = _duration;
               param1 = _duration + 0.0001;
            }
         }
         else if(param1 < 1.0e-7)
         {
            if(!_locked)
            {
               _totalTime = _cycle = 0;
            }
            _time = 0;
            if(_loc5_ !== 0 || _duration === 0 && _rawPrevTime !== _tinyNum && (_rawPrevTime > 0 || param1 < 0 && _rawPrevTime >= 0) && !_locked)
            {
               _loc16_ = "onReverseComplete";
               _loc13_ = _reversed;
            }
            if(param1 < 0)
            {
               _active = false;
               if(_rawPrevTime >= 0 && _first)
               {
                  _loc17_ = true;
               }
               _rawPrevTime = param1;
            }
            else
            {
               _rawPrevTime = _duration || !param2 || param1 !== 0 || _rawPrevTime === param1?Number(param1):Number(_tinyNum);
               param1 = 0;
               if(!_initted)
               {
                  _loc17_ = true;
               }
            }
         }
         else
         {
            if(_duration === 0 && _rawPrevTime < 0)
            {
               _loc17_ = true;
            }
            _time = _rawPrevTime = param1;
            if(!_locked)
            {
               _totalTime = param1;
               if(_repeat != 0)
               {
                  _loc18_ = _duration + _repeatDelay;
                  _cycle = _totalTime / _loc18_ >> 0;
                  if(!§§pop())
                  {
                     if(_cycle === _totalTime / _loc18_)
                     {
                        _cycle--;
                     }
                  }
                  _time = _totalTime - _cycle * _loc18_;
                  if(_yoyo)
                  {
                     if((_cycle & 1) != 0)
                     {
                        _time = _duration - _time;
                     }
                  }
                  if(_time > _duration)
                  {
                     _time = _duration;
                     param1 = _duration + 0.0001;
                  }
                  else if(_time < 0)
                  {
                     _time = param1 = 0;
                  }
                  else
                  {
                     param1 = _time;
                  }
               }
            }
         }
         if(_cycle != _loc11_)
         {
            if(!_locked)
            {
               _loc19_ = Boolean(_yoyo && (_loc11_ & 1) !== 0);
               _loc20_ = _loc19_ == (_yoyo && (_cycle & 1) !== 0);
               _loc21_ = _totalTime;
               _loc22_ = _cycle;
               _loc23_ = _rawPrevTime;
               _loc24_ = _time;
               _totalTime = _loc11_ * _duration;
               if(_cycle < _loc11_)
               {
                  _loc19_ = !_loc19_;
               }
               else
               {
                  _totalTime = _totalTime + _duration;
               }
               _time = _loc5_;
               _rawPrevTime = _loc9_;
               _cycle = _loc11_;
               _locked = true;
               _loc5_ = !!_loc19_?Number(0):Number(_duration);
               render(_loc5_,param2,false);
               if(!param2)
               {
                  if(!_gc)
                  {
                     if(vars.onRepeat)
                     {
                        vars.onRepeat.apply(null,vars.onRepeatParams);
                     }
                     if(_dispatcher)
                     {
                        _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REPEAT));
                     }
                  }
               }
               if(_loc20_)
               {
                  _loc5_ = !!_loc19_?Number(_duration + 0.0001):Number(-0.0001);
                  render(_loc5_,true,false);
               }
               _locked = false;
               if(_paused && !_loc10_)
               {
                  return;
               }
               _time = _loc24_;
               _totalTime = _loc21_;
               _cycle = _loc22_;
               _rawPrevTime = _loc23_;
            }
         }
         if((_time == _loc5_ || !_first) && !param3 && !_loc17_)
         {
            if(_loc6_ !== _totalTime)
            {
               if(_onUpdate != null)
               {
                  if(!param2)
                  {
                     _onUpdate.apply(vars.onUpdateScope || this,vars.onUpdateParams);
                  }
               }
            }
            return;
         }
         if(!_initted)
         {
            _initted = true;
         }
         if(!_active)
         {
            if(!_paused && _totalTime !== _loc6_ && param1 > 0)
            {
               _active = true;
            }
         }
         if(_loc6_ == 0)
         {
            if(_totalTime != 0)
            {
               if(!param2)
               {
                  if(vars.onStart)
                  {
                     vars.onStart.apply(this,vars.onStartParams);
                  }
                  if(_dispatcher)
                  {
                     _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
                  }
               }
            }
         }
         if(_time >= _loc5_)
         {
            _loc12_ = _first;
            while(_loc12_)
            {
               _loc14_ = _loc12_._next;
               if(_paused && !_loc10_)
               {
                  break;
               }
               if(_loc12_._active || _loc12_._startTime <= _time && !_loc12_._paused && !_loc12_._gc)
               {
                  if(!_loc12_._reversed)
                  {
                     _loc12_.render((param1 - _loc12_._startTime) * _loc12_._timeScale,param2,param3);
                  }
                  else
                  {
                     _loc12_.render((!_loc12_._dirty?_loc12_._totalDuration:_loc12_.totalDuration()) - (param1 - _loc12_._startTime) * _loc12_._timeScale,param2,param3);
                  }
               }
               _loc12_ = _loc14_;
            }
         }
         else
         {
            _loc12_ = _last;
            while(_loc12_)
            {
               _loc14_ = _loc12_._prev;
               if(_paused && !_loc10_)
               {
                  break;
               }
               if(_loc12_._active || _loc12_._startTime <= _loc5_ && !_loc12_._paused && !_loc12_._gc)
               {
                  if(!_loc12_._reversed)
                  {
                     _loc12_.render((param1 - _loc12_._startTime) * _loc12_._timeScale,param2,param3);
                  }
                  else
                  {
                     _loc12_.render((!_loc12_._dirty?_loc12_._totalDuration:_loc12_.totalDuration()) - (param1 - _loc12_._startTime) * _loc12_._timeScale,param2,param3);
                  }
               }
               _loc12_ = _loc14_;
            }
         }
         if(_onUpdate != null)
         {
            if(!param2)
            {
               _onUpdate.apply(null,vars.onUpdateParams);
            }
         }
         if(_hasUpdateListener)
         {
            if(!param2)
            {
               _dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
            }
         }
         if(_loc16_)
         {
            if(!_locked)
            {
               if(!_gc)
               {
                  if(_loc7_ === _startTime || _loc8_ !== _timeScale)
                  {
                     if(_time === 0 || _loc4_ >= totalDuration())
                     {
                        if(_loc13_)
                        {
                           if(_timeline.autoRemoveChildren)
                           {
                              _enabled(false,false);
                           }
                           _active = false;
                        }
                        if(!param2)
                        {
                           if(vars[_loc16_])
                           {
                              vars[_loc16_].apply(null,vars[_loc16_ + "Params"]);
                           }
                           if(_dispatcher)
                           {
                              _dispatcher.dispatchEvent(new TweenEvent(_loc16_ == "onComplete"?TweenEvent.COMPLETE:TweenEvent.REVERSE_COMPLETE));
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function removeCallback(param1:Function, param2:* = null) : TimelineMax
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         if(param1 != null)
         {
            if(param2 == null)
            {
               _kill(null,param1);
            }
            else
            {
               _loc3_ = getTweensOf(param1,false);
               _loc4_ = _loc3_.length;
               _loc5_ = _parseTimeOrLabel(param2);
               while(--_loc4_ > -1)
               {
                  if(_loc3_[_loc4_]._startTime === _loc5_)
                  {
                     _loc3_[_loc4_]._enabled(false,false);
                  }
               }
            }
         }
         return this;
      }
      
      public function yoyo(param1:Boolean = false) : *
      {
         if(!arguments.length)
         {
            return _yoyo;
         }
         _yoyo = param1;
         return this;
      }
      
      override public function progress(param1:Number = NaN, param2:Boolean = false) : *
      {
         return !arguments.length?_time / duration():totalTime(duration() * (_yoyo && (_cycle & 1) !== 0?1 - param1:param1) + _cycle * (_duration + _repeatDelay),param2);
      }
      
      public function repeatDelay(param1:Number = 0) : *
      {
         if(!arguments.length)
         {
            return _repeatDelay;
         }
         _repeatDelay = param1;
         return _uncache(true);
      }
      
      override public function time(param1:Number = NaN, param2:Boolean = false) : *
      {
         if(!arguments.length)
         {
            return _time;
         }
         if(_dirty)
         {
            totalDuration();
         }
         if(param1 > _duration)
         {
            param1 = _duration;
         }
         if(_yoyo && (_cycle & 1) !== 0)
         {
            param1 = _duration - param1 + _cycle * (_duration + _repeatDelay);
         }
         else if(_repeat != 0)
         {
            param1 = param1 + _cycle * (_duration + _repeatDelay);
         }
         return totalTime(param1,param2);
      }
      
      protected function _initDispatcher() : Boolean
      {
         var _loc2_:* = null;
         var _loc1_:Boolean = false;
         for(_loc2_ in _listenerLookup)
         {
            if(_loc2_ in vars)
            {
               if(vars[_loc2_] is Function)
               {
                  if(_dispatcher == null)
                  {
                     _dispatcher = new EventDispatcher(this);
                  }
                  _dispatcher.addEventListener(_listenerLookup[_loc2_],vars[_loc2_],false,0,true);
                  _loc1_ = true;
               }
            }
         }
         return _loc1_;
      }
      
      override public function invalidate() : *
      {
         _yoyo = Boolean(this.vars.yoyo == true);
         _repeat = int(this.vars.repeat) || 0;
         _repeatDelay = Number(this.vars.repeatDelay) || Number(0);
         _hasUpdateListener = false;
         _initDispatcher();
         _uncache(true);
         return super.invalidate();
      }
      
      public function getActive(param1:Boolean = true, param2:Boolean = true, param3:Boolean = false) : Array
      {
         var _loc8_:int = 0;
         var _loc9_:Animation = null;
         var _loc4_:Array = [];
         var _loc5_:Array = getChildren(param1,param2,param3);
         var _loc6_:int = 0;
         var _loc7_:int = _loc5_.length;
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc9_ = _loc5_[_loc8_];
            if(!_loc9_._paused)
            {
               if(_loc9_._timeline._time >= _loc9_._startTime)
               {
                  if(_loc9_._timeline._time < _loc9_._startTime + _loc9_._totalDuration / _loc9_._timeScale)
                  {
                     if(!_getGlobalPaused(_loc9_._timeline))
                     {
                        _loc4_[_loc6_++] = _loc9_;
                     }
                  }
               }
            }
            _loc8_++;
         }
         return _loc4_;
      }
      
      public function getLabelAfter(param1:Number = NaN) : String
      {
         var _loc4_:int = 0;
         if(!param1)
         {
            if(param1 != 0)
            {
               param1 = _time;
            }
         }
         var _loc2_:Array = getLabelsArray();
         var _loc3_:int = _loc2_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_[_loc4_].time > param1)
            {
               return _loc2_[_loc4_].name;
            }
            _loc4_++;
         }
         return null;
      }
      
      override public function totalDuration(param1:Number = NaN) : *
      {
         if(!arguments.length)
         {
            if(_dirty)
            {
               super.totalDuration();
               _totalDuration = _repeat == -1?Number(999999999999):Number(_duration * (_repeat + 1) + _repeatDelay * _repeat);
            }
            return _totalDuration;
         }
         return _repeat == -1?this:duration((param1 - _repeat * _repeatDelay) / (_repeat + 1));
      }
   }
}
