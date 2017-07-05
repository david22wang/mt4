//+------------------------------------------------------------------+
//|                                                 EA_orderDeal.mq4 |
//|                               Copyright 2013, david2wang订单处理 |
//|                                       http://www.wangzhengjun.cn |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, david2wang  单处理"
#property link      "http://www.wangzhengjun.cn"
void orderDeal(int tp)
{

      int total=OrdersTotal();
      double all_pf=0.0;
       // 编写定单命令

      if(OrderSelect(total-1,SELECT_BY_POS))
      {
         double pf=OrderTakeProfit();
         int ot=OrderType();
 
      }
      if(pf>0)
      {//如果所有 订单的获益》0，才执行平衡线
        //go to execute b
 
      }

}
void t()
{//关键点

int total=OrdersTotal();
if(total==0)
{//下挂单
   
}

}