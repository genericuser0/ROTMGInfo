package com.adobe.serialization.json
{
   public class JSONDecoder
   {
       
      
      private var value;
      
      private var tokenizer:JSONTokenizer;
      
      private var token:JSONToken;
      
      public function JSONDecoder(param1:String)
      {
         super();
         this.tokenizer = new JSONTokenizer(param1);
         this.nextToken();
         this.value = this.parseValue();
      }
      
      public function getValue() : *
      {
         return this.value;
      }
      
      private function nextToken() : JSONToken
      {
         return this.token = this.tokenizer.getNextToken();
      }
      
      private function parseArray() : Array
      {
         var _loc1_:Array = new Array();
         this.nextToken();
         if(this.token.type == JSONTokenType.RIGHT_BRACKET)
         {
            return _loc1_;
         }
         while(true)
         {
            _loc1_.push(this.parseValue());
            this.nextToken();
            if(this.token.type == JSONTokenType.RIGHT_BRACKET)
            {
               break;
            }
            if(this.token.type == JSONTokenType.COMMA)
            {
               this.nextToken();
            }
            else
            {
               this.tokenizer.parseError("Expecting ] or , but found " + this.token.value);
            }
         }
         return _loc1_;
      }
      
      private function parseObject() : Object
      {
         /*
          * Decompilation error
          * Code may be obfuscated
          * Tip: You can try enabling "Automatic deobfuscation" in Settings
          * Error type: IndexOutOfBoundsException (Index: 0, Size: 1)
          */
         throw new flash.errors.IllegalOperationError("Not decompiled due to error");
      }
      
      private function parseValue() : Object
      {
         if(this.token == null)
         {
            this.tokenizer.parseError("Unexpected end of input");
         }
         switch(this.token.type)
         {
            case JSONTokenType.LEFT_BRACE:
               return this.parseObject();
            case JSONTokenType.LEFT_BRACKET:
               return this.parseArray();
            case JSONTokenType.STRING:
            case JSONTokenType.NUMBER:
            case JSONTokenType.TRUE:
            case JSONTokenType.FALSE:
            case JSONTokenType.NULL:
               return this.token.value;
            default:
               this.tokenizer.parseError("Unexpected " + this.token.value);
               return null;
         }
      }
   }
}
