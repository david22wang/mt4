//+------------------------------------------------------------------+
//|                                                 EA_orderDeal.mq4 |
//|                               Copyright 2013, david2wang�������� |
//|                                       http://www.wangzhengjun.cn |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, david2wang  ������"
#property link      "http://www.wangzhengjun.cn"
void orderDeal(int tp)
{

      int total=OrdersTotal();
      double all_pf=0.0;
       // ��д��������

      if(OrderSelect(total-1,SELECT_BY_POS))
      {
         double pf=OrderTakeProfit();
         int ot=OrderType();
 
      }
      if(pf>0)
      {//������� �����Ļ��桷0����ִ��ƽ����
        //go to execute b
 
      }

}
void t()
{//�ؼ���

int total=OrdersTotal();
if(total==0)
{//�¹ҵ�
   
}

}