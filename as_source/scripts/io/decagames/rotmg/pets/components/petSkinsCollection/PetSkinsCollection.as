package io.decagames.rotmg.pets.components.petSkinsCollection
{
   import flash.display.Sprite;
   import io.decagames.rotmg.pets.components.petSkinSlot.PetSkinSlot;
   import io.decagames.rotmg.pets.data.vo.SkinVO;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.gird.UIGrid;
   import io.decagames.rotmg.ui.gird.UIGridElement;
   import io.decagames.rotmg.ui.labels.UILabel;
   import io.decagames.rotmg.ui.scroll.UIScrollbar;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import io.decagames.rotmg.ui.texture.TextureParser;
   import io.decagames.rotmg.utils.colors.Tint;
   
   public class PetSkinsCollection extends Sprite
   {
      
      public static var COLLECTION_WIDTH:int = 360;
      
      public static const COLLECTION_HEIGHT:int = 425;
       
      
      private var collectionContainer:Sprite;
      
      private var contentInset:SliceScalingBitmap;
      
      private var contentTitle:SliceScalingBitmap;
      
      private var title:UILabel;
      
      private var contentGrid:UIGrid;
      
      private var contentElement:UIGridElement;
      
      private var petGrid:UIGrid;
      
      public function PetSkinsCollection(param1:int, param2:int)
      {
         var _loc3_:SliceScalingBitmap = null;
         var _loc4_:UILabel = null;
         super();
         this.contentGrid = new UIGrid(COLLECTION_WIDTH - 40,1,15);
         this.contentInset = TextureParser.instance.getSliceScalingBitmap("UI","popup_content_inset",COLLECTION_WIDTH);
         addChild(this.contentInset);
         this.contentInset.height = COLLECTION_HEIGHT;
         this.contentInset.x = 0;
         this.contentInset.y = 0;
         this.contentTitle = TextureParser.instance.getSliceScalingBitmap("UI","content_title_decoration",COLLECTION_WIDTH);
         addChild(this.contentTitle);
         this.contentTitle.x = 0;
         this.contentTitle.y = 0;
         this.title = new UILabel();
         this.title.text = "Collection";
         DefaultLabelFormat.petNameLabel(this.title,16777215);
         this.title.width = COLLECTION_WIDTH;
         this.title.wordWrap = true;
         this.title.y = 4;
         this.title.x = 0;
         addChild(this.title);
         _loc3_ = TextureParser.instance.getSliceScalingBitmap("UI","content_divider_smalltitle_white",94);
         Tint.add(_loc3_,3355443,1);
         addChild(_loc3_);
         _loc3_.x = Math.round((COLLECTION_WIDTH - _loc3_.width) / 2);
         _loc3_.y = 23;
         _loc4_ = new UILabel();
         DefaultLabelFormat.wardrobeCollectionLabel(_loc4_);
         _loc4_.text = param1 + "/" + param2;
         _loc4_.width = _loc3_.width;
         _loc4_.wordWrap = true;
         _loc4_.y = _loc3_.y + 1;
         _loc4_.x = _loc3_.x;
         addChild(_loc4_);
         this.createScrollview();
      }
      
      private function createScrollview() : void
      {
         var _loc1_:Sprite = null;
         var _loc3_:Sprite = null;
         _loc1_ = new Sprite();
         this.collectionContainer = new Sprite();
         this.collectionContainer.x = this.contentInset.x;
         this.collectionContainer.y = 2;
         this.collectionContainer.addChild(this.contentGrid);
         _loc1_.addChild(this.collectionContainer);
         var _loc2_:UIScrollbar = new UIScrollbar(COLLECTION_HEIGHT - 57);
         _loc2_.mouseRollSpeedFactor = 1;
         _loc2_.scrollObject = this;
         _loc2_.content = this.collectionContainer;
         _loc1_.addChild(_loc2_);
         _loc2_.x = this.contentInset.x + this.contentInset.width - 25;
         _loc2_.y = 7;
         _loc3_ = new Sprite();
         _loc3_.graphics.beginFill(0);
         _loc3_.graphics.drawRect(0,0,COLLECTION_WIDTH,380);
         _loc3_.x = this.collectionContainer.x;
         _loc3_.y = this.collectionContainer.y;
         this.collectionContainer.mask = _loc3_;
         _loc1_.addChild(_loc3_);
         addChild(_loc1_);
         _loc1_.y = 42;
      }
      
      private function sortByName(param1:SkinVO, param2:SkinVO) : int
      {
         if(param1.name > param2.name)
         {
            return 1;
         }
         return -1;
      }
      
      private function sortByRarity(param1:SkinVO, param2:SkinVO) : int
      {
         if(param1.rarity.ordinal == param2.rarity.ordinal)
         {
            return this.sortByName(param1,param2);
         }
         if(param1.rarity.ordinal > param2.rarity.ordinal)
         {
            return 1;
         }
         return -1;
      }
      
      public function addPetSkins(param1:String, param2:Vector.<SkinVO>) : void
      {
         var _loc5_:SkinVO = null;
         if(param2 == null)
         {
            return;
         }
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.petGrid = new UIGrid(COLLECTION_WIDTH - 40,7,5);
         param2 = param2.sort(this.sortByRarity);
         for each(_loc5_ in param2)
         {
            this.petGrid.addGridElement(new PetSkinSlot(_loc5_,true));
            _loc3_++;
            if(_loc5_.isOwned)
            {
               _loc4_++;
            }
         }
         this.petGrid.x = 10;
         this.petGrid.y = 25;
         var _loc6_:PetFamilyContainer = new PetFamilyContainer(param1,_loc4_,_loc3_);
         _loc6_.addChild(this.petGrid);
         this.contentGrid.addGridElement(_loc6_);
      }
   }
}
