package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.screens.AccountScreen;
   import com.company.assembleegameclient.screens.TitleMenuOption;
   import com.company.assembleegameclient.ui.SoundIcon;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.ui.model.EnvironmentData;
   import kabam.rotmg.ui.view.components.DarkLayer;
   import kabam.rotmg.ui.view.components.MenuOptionsBar;
   import org.osflash.signals.Signal;
   
   public class TitleView extends Sprite
   {
      
      static var TitleScreenGraphic:Class = TitleView_TitleScreenGraphic;
      
      static var TitleScreenBackground:Class = TitleView_TitleScreenBackground;
      
      public static const MIDDLE_OF_BOTTOM_BAND:Number = 589.45;
      
      public static var queueEmailConfirmation:Boolean = false;
      
      public static var queuePasswordPrompt:Boolean = false;
      
      public static var queuePasswordPromptFull:Boolean = false;
      
      public static var queueRegistrationPrompt:Boolean = false;
       
      
      private var versionText:TextFieldDisplayConcrete;
      
      private var copyrightText:TextFieldDisplayConcrete;
      
      private var menuOptionsBar:MenuOptionsBar;
      
      private var data:EnvironmentData;
      
      public var playClicked:Signal;
      
      public var accountClicked:Signal;
      
      public var legendsClicked:Signal;
      
      public var supportClicked:Signal;
      
      public var editorClicked:Signal;
      
      public var quitClicked:Signal;
      
      public var optionalButtonsAdded:Signal;
      
      private var _buttonFactory:ButtonFactory;
      
      public function TitleView()
      {
         this.optionalButtonsAdded = new Signal();
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._buttonFactory = new ButtonFactory();
         addChild(new TitleScreenBackground());
         addChild(new DarkLayer());
         addChild(new TitleScreenGraphic());
         this.menuOptionsBar = this.makeMenuOptionsBar();
         addChild(this.menuOptionsBar);
         addChild(new AccountScreen());
         this.makeChildren();
         addChild(new SoundIcon());
      }
      
      private function makeMenuOptionsBar() : MenuOptionsBar
      {
         var _loc1_:TitleMenuOption = this._buttonFactory.getPlayButton();
         var _loc2_:TitleMenuOption = this._buttonFactory.getAccountButton();
         var _loc3_:TitleMenuOption = this._buttonFactory.getLegendsButton();
         var _loc4_:TitleMenuOption = this._buttonFactory.getSupportButton();
         this.playClicked = _loc1_.clicked;
         this.accountClicked = _loc2_.clicked;
         this.legendsClicked = _loc3_.clicked;
         this.supportClicked = _loc4_.clicked;
         var _loc5_:MenuOptionsBar = new MenuOptionsBar();
         _loc5_.addButton(_loc1_,MenuOptionsBar.CENTER);
         _loc5_.addButton(_loc4_,MenuOptionsBar.LEFT);
         _loc5_.addButton(_loc2_,MenuOptionsBar.LEFT);
         _loc5_.addButton(_loc3_,MenuOptionsBar.RIGHT);
         return _loc5_;
      }
      
      private function makeChildren() : void
      {
         this.versionText = this.makeText().setHTML(true).setAutoSize(TextFieldAutoSize.LEFT).setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
         this.versionText.y = MIDDLE_OF_BOTTOM_BAND;
         addChild(this.versionText);
         this.copyrightText = this.makeText().setAutoSize(TextFieldAutoSize.RIGHT).setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
         this.copyrightText.setStringBuilder(new LineBuilder().setParams(TextKey.COPYRIGHT));
         this.copyrightText.filters = [new DropShadowFilter(0,0,0)];
         this.copyrightText.x = 800;
         this.copyrightText.y = MIDDLE_OF_BOTTOM_BAND;
         addChild(this.copyrightText);
      }
      
      public function makeText() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(12).setColor(8355711);
         _loc1_.filters = [new DropShadowFilter(0,0,0)];
         return _loc1_;
      }
      
      public function initialize(param1:EnvironmentData) : void
      {
         this.data = param1;
         this.updateVersionText();
         this.handleOptionalButtons();
      }
      
      public function putNoticeTagToOption(param1:TitleMenuOption, param2:String, param3:int = 14, param4:uint = 10092390, param5:Boolean = true) : void
      {
         param1.createNoticeTag(param2,param3,param4,param5);
      }
      
      private function updateVersionText() : void
      {
         this.versionText.setStringBuilder(new StaticStringBuilder(this.data.buildLabel));
      }
      
      private function handleOptionalButtons() : void
      {
         this.data.canMapEdit && this.createEditorButton();
         this.data.isDesktop && this.createQuitButton();
         this.optionalButtonsAdded.dispatch();
      }
      
      private function createQuitButton() : void
      {
         var _loc1_:TitleMenuOption = this._buttonFactory.getQuitButton();
         this.menuOptionsBar.addButton(_loc1_,MenuOptionsBar.RIGHT);
         this.quitClicked = _loc1_.clicked;
      }
      
      private function createEditorButton() : void
      {
         var _loc1_:TitleMenuOption = this._buttonFactory.getEditorButton();
         this.menuOptionsBar.addButton(_loc1_,MenuOptionsBar.RIGHT);
         this.editorClicked = _loc1_.clicked;
      }
      
      public function get buttonFactory() : ButtonFactory
      {
         return this._buttonFactory;
      }
   }
}
