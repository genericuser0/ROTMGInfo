package kabam.rotmg.chat.view
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.FameUtil;
   import com.company.assembleegameclient.util.StageProxy;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.StageQuality;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
   import kabam.rotmg.chat.model.ChatMessage;
   import kabam.rotmg.chat.model.ChatModel;
   import kabam.rotmg.text.model.FontModel;
   import kabam.rotmg.text.view.BitmapTextFactory;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   
   public class ChatListItemFactory
   {
      
      private static const IDENTITY_MATRIX:Matrix = new Matrix();
      
      private static const SERVER:String = Parameters.SERVER_CHAT_NAME;
      
      private static const CLIENT:String = Parameters.CLIENT_CHAT_NAME;
      
      private static const HELP:String = Parameters.HELP_CHAT_NAME;
      
      private static const ERROR:String = Parameters.ERROR_CHAT_NAME;
      
      private static const GUILD:String = Parameters.GUILD_CHAT_NAME;
      
      private static const testField:TextField = makeTestTextField();
       
      
      [Inject]
      public var factory:BitmapTextFactory;
      
      [Inject]
      public var model:ChatModel;
      
      [Inject]
      public var fontModel:FontModel;
      
      [Inject]
      public var supporterCampaignModel:SupporterCampaignModel;
      
      [Inject]
      public var stageProxy:StageProxy;
      
      private var message:ChatMessage;
      
      private var buffer:Vector.<DisplayObject>;
      
      public function ChatListItemFactory()
      {
         super();
      }
      
      public static function isTradeMessage(param1:int, param2:int, param3:String) : Boolean
      {
         return (param1 == -1 || param2 == -1) && param3.search("/trade") != -1;
      }
      
      public static function isGuildMessage(param1:String) : Boolean
      {
         return param1 == GUILD;
      }
      
      private static function makeTestTextField() : TextField
      {
         var _loc1_:TextField = new TextField();
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.size = 15;
         _loc2_.bold = true;
         _loc1_.defaultTextFormat = _loc2_;
         return _loc1_;
      }
      
      public function make(param1:ChatMessage, param2:Boolean = false) : ChatListItem
      {
         var _loc5_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         this.message = param1;
         this.buffer = new Vector.<DisplayObject>();
         this.setTFonTestField();
         this.makeStarsIcon();
         this.makeWhisperText();
         this.makeNameText();
         this.makeMessageText();
         var _loc3_:Boolean = param1.numStars == -1 || param1.objectId == -1;
         var _loc4_:Boolean = false;
         var _loc6_:String = param1.name;
         if(_loc3_ && (_loc5_ = param1.text.search("/trade ")) != -1)
         {
            _loc5_ = _loc5_ + 7;
            _loc7_ = "";
            _loc8_ = _loc5_;
            while(_loc8_ < _loc5_ + 10)
            {
               if(param1.text.charAt(_loc8_) == "\"")
               {
                  break;
               }
               _loc7_ = _loc7_ + param1.text.charAt(_loc8_);
               _loc8_++;
            }
            _loc6_ = _loc7_;
            _loc4_ = true;
         }
         return new ChatListItem(this.buffer,this.model.bounds.width,this.model.lineHeight,param2,param1.objectId,_loc6_,param1.recipient == GUILD,_loc4_);
      }
      
      private function makeStarsIcon() : void
      {
         var _loc1_:int = this.message.numStars;
         var _loc2_:int = this.message.starBg;
         if(_loc1_ >= 0)
         {
            this.buffer.push(FameUtil.numStarsToIcon(_loc1_,_loc2_));
         }
      }
      
      private function makeWhisperText() : void
      {
         var _loc1_:StringBuilder = null;
         var _loc2_:BitmapData = null;
         if(this.message.isWhisper && !this.message.isToMe)
         {
            _loc1_ = new StaticStringBuilder("To: ");
            _loc2_ = this.getBitmapData(_loc1_,61695);
            this.buffer.push(new Bitmap(_loc2_));
         }
      }
      
      private function makeNameText() : void
      {
         if(!this.isSpecialMessageType())
         {
            this.bufferNameText();
         }
      }
      
      private function isSpecialMessageType() : Boolean
      {
         var _loc1_:String = this.message.name;
         return _loc1_ == SERVER || _loc1_ == CLIENT || _loc1_ == HELP || _loc1_ == ERROR || _loc1_ == GUILD;
      }
      
      private function bufferNameText() : void
      {
         var _loc1_:StringBuilder = new StaticStringBuilder(this.processName());
         var _loc2_:BitmapData = this.getBitmapData(_loc1_,this.getNameColor());
         this.buffer.push(new Bitmap(_loc2_));
      }
      
      private function processName() : String
      {
         var _loc1_:String = this.message.isWhisper && !this.message.isToMe?this.message.recipient:this.message.name;
         if(_loc1_.charAt(0) == "#" || _loc1_.charAt(0) == "@")
         {
            _loc1_ = _loc1_.substr(1);
         }
         return "<" + _loc1_ + ">";
      }
      
      private function makeMessageText() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Array = this.message.text.split("\n");
         if(_loc1_.length > 0)
         {
            this.makeNewLineFreeMessageText(_loc1_[0],true);
            _loc2_ = 1;
            while(_loc2_ < _loc1_.length)
            {
               this.makeNewLineFreeMessageText(_loc1_[_loc2_],false);
               _loc2_++;
            }
         }
      }
      
      private function makeNewLineFreeMessageText(param1:String, param2:Boolean) : void
      {
         var _loc7_:DisplayObject = null;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc3_:String = param1;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param2)
         {
            for each(_loc7_ in this.buffer)
            {
               _loc4_ = _loc4_ + _loc7_.width;
            }
            _loc5_ = _loc3_.length;
            testField.text = _loc3_;
            while(testField.textWidth >= this.model.bounds.width - _loc4_)
            {
               _loc5_ = _loc5_ - 10;
               testField.text = _loc3_.substr(0,_loc5_);
            }
            if(_loc5_ < _loc3_.length)
            {
               _loc8_ = _loc3_.substr(0,_loc5_).lastIndexOf(" ");
               _loc5_ = _loc8_ == 0 || _loc8_ == -1?int(_loc5_):int(_loc8_ + 1);
            }
            this.makeMessageLine(_loc3_.substr(0,_loc5_));
         }
         var _loc6_:int = _loc3_.length;
         if(_loc6_ > _loc5_)
         {
            _loc9_ = _loc3_.length;
            _loc10_ = _loc5_;
            while(_loc10_ < _loc3_.length)
            {
               testField.text = _loc3_.substr(_loc10_,_loc9_);
               while(testField.textWidth >= this.model.bounds.width)
               {
                  _loc9_ = _loc9_ - 2;
                  testField.text = _loc3_.substr(_loc10_,_loc9_);
               }
               _loc11_ = _loc9_;
               if(_loc3_.length > _loc10_ + _loc9_)
               {
                  _loc11_ = _loc3_.substr(_loc10_,_loc9_).lastIndexOf(" ");
                  _loc11_ = _loc11_ == 0 || _loc11_ == -1?int(_loc9_):int(_loc11_ + 1);
               }
               this.makeMessageLine(_loc3_.substr(_loc10_,_loc11_));
               _loc10_ = _loc10_ + _loc11_;
            }
         }
      }
      
      private function makeMessageLine(param1:String) : void
      {
         var _loc2_:StringBuilder = new StaticStringBuilder(param1);
         var _loc3_:BitmapData = this.getBitmapData(_loc2_,this.getTextColor());
         this.buffer.push(new Bitmap(_loc3_));
      }
      
      private function getNameColor() : uint
      {
         if(this.message.name.charAt(0) == "#")
         {
            return 16754688;
         }
         if(this.message.name.charAt(0) == "@")
         {
            return 16776960;
         }
         if(this.message.recipient == GUILD)
         {
            return 10944349;
         }
         if(this.message.recipient != "")
         {
            return 61695;
         }
         if(this.message.isFromSupporter)
         {
            return SupporterCampaignModel.SUPPORT_COLOR;
         }
         return 65280;
      }
      
      private function getTextColor() : uint
      {
         var _loc1_:String = this.message.name;
         if(_loc1_ == SERVER)
         {
            return 16776960;
         }
         if(_loc1_ == CLIENT)
         {
            return 255;
         }
         if(_loc1_ == HELP)
         {
            return 16734981;
         }
         if(_loc1_ == ERROR)
         {
            return 16711680;
         }
         if(_loc1_.charAt(0) == "@")
         {
            return 16776960;
         }
         if(this.message.recipient == GUILD)
         {
            return 10944349;
         }
         if(this.message.recipient != "")
         {
            return 61695;
         }
         return 16777215;
      }
      
      private function getBitmapData(param1:StringBuilder, param2:uint) : BitmapData
      {
         var _loc3_:String = this.stageProxy.getQuality();
         var _loc4_:Boolean = Parameters.data_["forceChatQuality"];
         _loc4_ && this.stageProxy.setQuality(StageQuality.HIGH);
         var _loc5_:BitmapData = this.factory.make(param1,14,param2,true,IDENTITY_MATRIX,true);
         _loc4_ && this.stageProxy.setQuality(_loc3_);
         return _loc5_;
      }
      
      private function setTFonTestField() : void
      {
         var _loc1_:TextFormat = testField.getTextFormat();
         _loc1_.font = this.fontModel.getFont().getName();
         testField.defaultTextFormat = _loc1_;
      }
   }
}
