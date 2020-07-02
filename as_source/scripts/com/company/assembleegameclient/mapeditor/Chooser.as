package com.company.assembleegameclient.mapeditor
{
   import com.adobe.images.PNGEncoder;
   import com.company.assembleegameclient.ui.Scrollbar;
   import com.company.util.GraphicsUtil;
   import flash.display.BitmapData;
   import flash.display.CapsStyle;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.FileReference;
   import flash.utils.ByteArray;
   
   class Chooser extends Sprite
   {
      
      public static const WIDTH:int = 136;
      
      public static const HEIGHT:int = 430;
      
      public static const SCROLLBAR_WIDTH:int = 20;
       
      
      public var layer_:int;
      
      public var selected_:Element;
      
      protected var elementContainer_:Sprite;
      
      protected var scrollBar_:Scrollbar;
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.lineStyle_,this.backgroundFill_,this.path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
      
      private var elements_:Vector.<Element>;
      
      private var outlineFill_:GraphicsSolidFill;
      
      private var lineStyle_:GraphicsStroke;
      
      private var backgroundFill_:GraphicsSolidFill;
      
      private var path_:GraphicsPath;
      
      private var _hasBeenLoaded:Boolean;
      
      function Chooser(param1:int)
      {
         this.elements_ = new Vector.<Element>();
         this.outlineFill_ = new GraphicsSolidFill(16777215,1);
         this.lineStyle_ = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.outlineFill_);
         this.backgroundFill_ = new GraphicsSolidFill(3552822,1);
         this.path_ = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
         super();
         this.layer_ = param1;
         this.init();
      }
      
      public function selectedType() : int
      {
         return this.selected_.type_;
      }
      
      public function setSelectedType(param1:int) : void
      {
         var _loc2_:Element = null;
         for each(_loc2_ in this.elements_)
         {
            if(_loc2_.type_ == param1)
            {
               this.setSelected(_loc2_);
               return;
            }
         }
      }
      
      protected function addElement(param1:Element) : void
      {
         var _loc2_:int = this.elements_.length;
         param1.x = _loc2_ % 2 == 0?Number(0):Number(2 + Element.WIDTH);
         param1.y = int(_loc2_ / 2) * Element.HEIGHT + 6;
         this.elementContainer_.addChild(param1);
         if(_loc2_ == 0)
         {
            this.setSelected(param1);
         }
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.elements_.push(param1);
      }
      
      protected function removeElements() : void
      {
         this.elementContainer_.removeChildren();
         if(!this.elements_)
         {
            this.elements_ = new Vector.<Element>();
         }
         else
         {
            this.cleanupElements();
         }
         this._hasBeenLoaded = false;
      }
      
      private function cleanupElements() : void
      {
         var _loc2_:Element = null;
         var _loc1_:int = this.elements_.length - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = this.elements_.pop();
            _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            _loc1_--;
         }
      }
      
      protected function setSelected(param1:Element) : void
      {
         if(this.selected_ != null)
         {
            this.selected_.setSelected(false);
         }
         this.selected_ = param1;
         this.selected_.setSelected(true);
      }
      
      private function init() : void
      {
         this.drawBackground();
         this.elementContainer_ = new Sprite();
         this.elementContainer_.x = 4;
         this.elementContainer_.y = 6;
         addChild(this.elementContainer_);
         this.scrollBar_ = new Scrollbar(SCROLLBAR_WIDTH,HEIGHT - 8,0.1,this);
         this.scrollBar_.x = WIDTH - SCROLLBAR_WIDTH - 6;
         this.scrollBar_.y = 4;
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(0);
         _loc1_.graphics.drawRect(0,2,Chooser.WIDTH - SCROLLBAR_WIDTH - 4,Chooser.HEIGHT - 4);
         addChild(_loc1_);
         this.elementContainer_.mask = _loc1_;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function downloadElement(param1:Element) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:FileReference = null;
         var _loc2_:BitmapData = param1.objectBitmap;
         if(_loc2_ != null)
         {
            _loc3_ = PNGEncoder.encode(param1.objectBitmap);
            _loc4_ = new FileReference();
            _loc4_.save(_loc3_,param1.type_ + ".png");
         }
      }
      
      private function drawBackground() : void
      {
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,[1,1,1,1],this.path_);
         graphics.drawGraphicsData(this.graphicsData_);
      }
      
      protected function onMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:Element = param1.currentTarget as Element;
         if(_loc2_.downloadOnly)
         {
            this.downloadElement(_loc2_);
         }
         else
         {
            this.setSelected(_loc2_);
         }
      }
      
      protected function onScrollBarChange(param1:Event) : void
      {
         this.elementContainer_.y = 6 - this.scrollBar_.pos() * (this.elementContainer_.height + 12 - HEIGHT);
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.scrollBar_.addEventListener(Event.CHANGE,this.onScrollBarChange);
         this.scrollBar_.setIndicatorSize(HEIGHT,this.elementContainer_.height);
         addChild(this.scrollBar_);
      }
      
      protected function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function get hasBeenLoaded() : Boolean
      {
         return this._hasBeenLoaded;
      }
      
      public function set hasBeenLoaded(param1:Boolean) : void
      {
         this._hasBeenLoaded = param1;
      }
   }
}
