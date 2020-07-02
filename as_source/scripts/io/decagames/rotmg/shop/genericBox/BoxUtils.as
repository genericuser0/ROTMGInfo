package io.decagames.rotmg.shop.genericBox
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.util.Currency;
   import io.decagames.rotmg.shop.NotEnoughResources;
   import io.decagames.rotmg.shop.genericBox.data.GenericBoxInfo;
   import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.game.model.GameModel;
   
   public class BoxUtils
   {
       
      
      public function BoxUtils()
      {
         super();
      }
      
      public static function moneyCheckPass(param1:GenericBoxInfo, param2:int, param3:GameModel, param4:PlayerModel, param5:ShowPopupSignal) : Boolean
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(param1.isOnSale() && param1.saleAmount > 0)
         {
            _loc6_ = int(param1.saleCurrency);
            _loc7_ = int(param1.saleAmount) * param2;
         }
         else
         {
            _loc6_ = int(param1.priceCurrency);
            _loc7_ = int(param1.priceAmount) * param2;
         }
         var _loc8_:Boolean = true;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Player = param3.player;
         if(_loc11_ != null)
         {
            _loc10_ = _loc11_.credits_;
            _loc9_ = _loc11_.fame_;
         }
         else if(param4 != null)
         {
            _loc10_ = param4.getCredits();
            _loc9_ = param4.getFame();
         }
         if(_loc6_ == Currency.GOLD && _loc10_ < _loc7_)
         {
            param5.dispatch(new NotEnoughResources(300,Currency.GOLD));
            _loc8_ = false;
         }
         else if(_loc6_ == Currency.FAME && _loc9_ < _loc7_)
         {
            param5.dispatch(new NotEnoughResources(300,Currency.FAME));
            _loc8_ = false;
         }
         return _loc8_;
      }
   }
}
