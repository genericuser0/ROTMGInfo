package io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard
{
   import com.company.assembleegameclient.ui.Slot;
   import com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;
   import com.company.assembleegameclient.util.FilterUtil;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import com.company.util.IIterator;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.labels.UILabel;
   import kabam.rotmg.legends.model.Legend;
   import org.osflash.signals.Signal;
   
   public class SeasonalLeaderBoardItem extends Sprite
   {
      
      public static const WIDTH:int = 560;
      
      public static const HEIGHT:int = 40;
      
      private static const FONT_SIZE:int = 18;
       
      
      public const selected:Signal = new Signal(Legend);
      
      private var _seasonalLeaderBoardItemData:SeasonalLeaderBoardItemData;
      
      private var boardRank:UILabel;
      
      private var characterBitmap:Bitmap;
      
      private var nameText:UILabel;
      
      private var inventoryGrid:EquippedGrid;
      
      private var totalFameText:UILabel;
      
      private var fameIcon:Bitmap;
      
      private var isOver:Boolean;
      
      private var leaderBoardDropShadowFilter:Array;
      
      public function SeasonalLeaderBoardItem(param1:SeasonalLeaderBoardItemData)
      {
         super();
         this._seasonalLeaderBoardItemData = param1;
         this.init();
      }
      
      private function init() : void
      {
         this.leaderBoardDropShadowFilter = FilterUtil.CHALLENGER_LEADER_BOARD_DROP_SHADOW;
         this.createBoardRank();
         this.createCharacterBitmap();
         this.createNameText();
         this.createInventory();
         this.createFameIcon();
         this.createTotalFame();
         this.addMouseListeners();
         this.draw();
      }
      
      private function createBoardRank() : void
      {
         this.boardRank = new UILabel();
         DefaultLabelFormat.createLabelFormat(this.boardRank,FONT_SIZE,this.getTextColor(),TextFormatAlign.RIGHT,true);
         this.boardRank.autoSize = TextFieldAutoSize.NONE;
         this.boardRank.width = 40;
         this.boardRank.height = 20;
         this.boardRank.text = this._seasonalLeaderBoardItemData.rank == -1?"---":this._seasonalLeaderBoardItemData.rank.toString() + ".";
         this.boardRank.filters = this.leaderBoardDropShadowFilter;
         this.boardRank.x = 10;
         this.boardRank.y = (HEIGHT - FONT_SIZE) * 0.5;
         addChild(this.boardRank);
      }
      
      private function createCharacterBitmap() : void
      {
         this.characterBitmap = new Bitmap(this._seasonalLeaderBoardItemData.character);
         this.characterBitmap.scaleX = this.characterBitmap.scaleY = 0.8;
         this.characterBitmap.x = this.boardRank.x + this.boardRank.width + 5;
         this.characterBitmap.y = HEIGHT / 2 - this.characterBitmap.height / 2 - 2;
         addChild(this.characterBitmap);
      }
      
      private function createNameText() : void
      {
         this.nameText = new UILabel();
         DefaultLabelFormat.createLabelFormat(this.nameText,FONT_SIZE,this.getTextColor(),TextFormatAlign.LEFT,true);
         this.nameText.text = this._seasonalLeaderBoardItemData.name;
         this.nameText.filters = this.leaderBoardDropShadowFilter;
         this.nameText.x = this.characterBitmap.x + this.characterBitmap.width + 5;
         this.nameText.y = (HEIGHT - FONT_SIZE) * 0.5;
         addChild(this.nameText);
      }
      
      private function createInventory() : void
      {
         var _loc2_:InteractiveItemTile = null;
         this.inventoryGrid = new EquippedGrid(null,this._seasonalLeaderBoardItemData.equipmentSlots,null);
         var _loc1_:IIterator = this.inventoryGrid.createInteractiveItemTileIterator();
         while(_loc1_.hasNext())
         {
            _loc2_ = InteractiveItemTile(_loc1_.next());
            _loc2_.setInteractive(false);
         }
         this.inventoryGrid.setItems(this._seasonalLeaderBoardItemData.equipment);
         this.inventoryGrid.scaleX = this.inventoryGrid.scaleY = 0.7;
         this.inventoryGrid.x = this.nameText.x + 140;
         this.inventoryGrid.y = (HEIGHT - Slot.HEIGHT) / 2 + 4;
         addChild(this.inventoryGrid);
      }
      
      private function createFameIcon() : void
      {
         var _loc1_:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",224);
         this.fameIcon = new Bitmap(TextureRedrawer.redraw(_loc1_,30,true,0));
         this.fameIcon.x = this.inventoryGrid.x + 155;
         this.fameIcon.y = HEIGHT / 2 - this.fameIcon.height / 2;
         addChild(this.fameIcon);
      }
      
      private function createTotalFame() : void
      {
         this.totalFameText = new UILabel();
         DefaultLabelFormat.createLabelFormat(this.totalFameText,FONT_SIZE,this.getTextColor(),TextFormatAlign.RIGHT,true);
         this.totalFameText.text = this._seasonalLeaderBoardItemData.totalFame == 0?"--":this._seasonalLeaderBoardItemData.totalFame.toString();
         this.totalFameText.filters = this.leaderBoardDropShadowFilter;
         this.totalFameText.x = this.fameIcon.x + this.fameIcon.width;
         this.totalFameText.y = (HEIGHT - FONT_SIZE) * 0.5;
         addChild(this.totalFameText);
      }
      
      private function getTextColor() : uint
      {
         var _loc1_:uint = 0;
         if(this._seasonalLeaderBoardItemData.isOwn)
         {
            _loc1_ = 16564761;
         }
         else if(this._seasonalLeaderBoardItemData.rank == 1)
         {
            _loc1_ = 16646031;
         }
         else
         {
            _loc1_ = 15597823;
         }
         return _loc1_;
      }
      
      private function addMouseListeners() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.isOver = true;
         this.draw();
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this.isOver = false;
         this.draw();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.selected.dispatch(this._seasonalLeaderBoardItemData);
      }
      
      private function draw() : void
      {
         graphics.clear();
         graphics.beginFill(6423145,!!this.isOver?Number(0.5):Number(0.8));
         graphics.drawRect(0,0,WIDTH,HEIGHT);
         graphics.endFill();
      }
   }
}
