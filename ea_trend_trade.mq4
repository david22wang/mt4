//+------------------------------------------------------------------+
//��E��5���Ӽ���ִ��
//��һ���ǲ�ѯ���ն�
//|   ��ѯִ����������һ���������������ڶ����� ����                                               |
//| ִ��������ѯ:                                      
//ȷ�����߼�������K�ߵ�����
//
//����5���ӣ��������ߵĽ��׻��ᣬ
//�����ǣ����߳��ַ����Ƶĵ�һ��K�ߣ�
//��5���Ӽ�����õ�һ������
 
 //+------------------------------------------------------------------+
//�۲��ƷK������-ͬ�����ǲ��ǳ��ַ�ת��̬��K��
//PERIOD_M1 1 1 ���� PERIOD_M5 5 5���� PERIOD_M15 15 15 ���� 
//PERIOD_M30 30 30 ���� PERIOD_H1 60 1 Сʱ PERIOD_H4 240 4 Сʱ 
//PERIOD_D1 1440 ÿ�� PERIOD_W1 10080 ÿ���� PERIOD_MN1 43200 ÿ�� 
//+---------------------------

//+------------------------------------------------------------------+
#property copyright "david wang"
#property link      "http://david wang"
int rundebug=1;
double support_price_quickorder=0;//֧�ֿ�ɽ��ļ۸�
double fixed_stoploss=500;//oanda 1000��ʾ1��Ԫ forex 100��ʾ1 usd
int parent_trend_period=1440;//
int int_low_period=1;
int int_current_period=5;
double boll_width=2.5;
 double buyvol=0.01;

 double g_profit_basic_each_vol=1.5;//ÿ�����ϵ����̶�ֹ��λ
 double g_profit_basic_each_vol_zero=2.5;//ÿ���ϵ����̶�ֹ��λ+�ɱ�
 bool g_profit_basic_each_vol_flag=true;//ÿ���ϵ�����
 double g_profit_level1_each_vol=400;//���س�70
 double g_profit_level2_each_vol=600;// ���س�50-----
 double g_profit_level3_each_vol=800;// ���س�30-----------
 double g_profit_level4_each_vol=1000;// ���س�10-------
 int dbl_magic_num=10051;//1��ʾ�ƽ�005��ʾ5minute
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   // ObjectsDeleteAll();
 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
      //++++++++++++++++++++++
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   
   int int_dt_limit=queryLimit(0,0);//��ѯEa��ִ������_ʱ��
   int int_order_limit=queryLimit(0,1);//��ѯEa��ִ������_����
   int int_ok;
   int wk;
 
   int s;
 
    if(int_order_limit>0)
   { //����ж����Ļ������Լ�충����״̬ 
           
        generater_order_stoploss(buyvol);
        generate_order_profit(buyvol);
  
   }/////      
         
   if((int_dt_limit==0)&&(int_order_limit==0))
   {//��ʼִ����ز���,��û�ж���������
          int int_risk=query_risk();//ϵͳ��+
          int int_orderpf=query_orderpf_num(); 
          if(int_orderpf>3)
          {//�����������3��lost------------����ֹͣ����-----------
            //return(0);          
          }
          
        //++++++++++++++++++++++++++++++++

   
        wk=  watchKprice(0,0);//����ֵΪ���Ļ�����ִ��
       if(wk==1)
       {//buy 1
           if(int_risk==1)
            {//�ڸ߷����г��У�EA��ִ��
               return(0);
            }//+++++++++++++++++++   
         gen_order_buy(buyvol);
       }
        if(wk==2)
       {//sell
            if(int_risk==2)
            {//�ڸ߷����г��У�EA��ִ��
               return(0);
            }//++++++++++
           gen_order_sell(buyvol);
       }
   
   }
 
   
//----
   return(0);
  }
  //�����Ƕ���ִ���ຯ��
  
   int generate_order_profit(double buyvol)
  {  //������ִ�ж�����ִ���������
     //������ַ����ƣ����ø�����ֹ�����
       double price,order_profit,order_stoploss;
        bool   result,bexecute;
       int int_trend_parent=get_parent_direct_v2(parent_trend_period);//�õ���һ��״
      for(int i=0;i<OrdersTotal();i++)
      {
  
             if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {   
                    if(OrderMagicNumber()==dbl_magic_num)
                      {//fixed 2013-5-6
                           order_profit=OrderProfit();//�õ���
                            order_stoploss=OrderStopLoss();
                          if(int_trend_parent==1)
                          {//long
                                if(OrderType()==OP_SELL)
                                {//tag 1 begin
                                    price=OrderOpenPrice()-order_profit*0.68;
                                    if(order_stoploss<price)
                                    {//execute stop loss
                                       bexecute=true;
                                    }
                                        if(bexecute)
                                          {
                                                      if(order_stoploss!=price)
                                                      {
                                                            result= OrderModify(OrderTicket(),OrderOpenPrice(),price,0,0,Blue);
                                                            if(result)
                                                                    {
                                                                        return(1);
                                                                    }
                                                                    else
                                                                    {  
                                                                       return(0);
                                                                    }//+++++++++++
                                                     }
                                           }//bexecute
                                    
                                   
                                
                                 }//tag 1 end  
                          
                          }
                          if(int_trend_parent==2)
                          {//short
                                                
                             if(OrderType()==OP_BUY)
                                {
                                
                                     price=OrderOpenPrice()+order_profit*0.68;
                                    if(order_stoploss<price)
                                    {//execute stop loss
                                       bexecute=true;
                                    }
                                        if(bexecute)
                                          {
                                                      if(order_stoploss!=price)
                                                      {
                                                            result= OrderModify(OrderTicket(),OrderOpenPrice(),price,0,0,Blue);
                                                            if(result)
                                                                    {
                                                                        return(1);
                                                                    }
                                                                    else
                                                                    {  
                                                                       return(0);
                                                                    }//+++++++++++
                                                     }
                                           }//bexecute
                                    
                                
                                
                                
                                }   
                          
                          }
                         
                           
                     
                     
                     
                      }
                  
                }
            
         }
  
  
  
  }//------------------------------------
  //-------------------------------------------------------
  
  
  //�޸Ķ�����ֹ��λ

  int generater_order_stoploss(double buyvol)
  {   
   bool   result,bexecute;
   double price,order_profit,order_stoploss;
   int    cmd,error;
//----
   for(int i=0;i<OrdersTotal();i++)
  {
  
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {   
                if(OrderMagicNumber()==dbl_magic_num)
                  {//fixed 2013-5-6
                        order_stoploss=OrderStopLoss();
                        if(order_stoploss==0)
                           {
                               generater_neworder_stoploss(buyvol);
            
                           }
                  }
     
            }
          }


   
  
  }
    //+------------------------------------------------------------------+
    //�ر����ж���
    //
  
   int generater_neworder_stoploss(double buyvol)
  {
       bool   result;
    double price,order_profit,order_stoploss,val;
   int    cmd,error;
   

 
//----
for(int i=0;i<OrdersTotal();i++)
  {
  
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
     {
            
            if(OrderMagicNumber()==dbl_magic_num)
         {//fixed 2013-5-6
     
                  cmd=OrderType();
                  order_stoploss=OrderStopLoss();
           
                  if(cmd==OP_BUY)
                  {  
                      price=Bid-fixed_stoploss*Point;
                      val=Low[iLowest(NULL,int_current_period,MODE_LOW,2,1)]-(Ask-Bid);
                      if(price>val)
                      {
                        price=val;
                      }

                  }
                  else   
                  {
                      price=Ask+fixed_stoploss*Point;
                      val=High[iHighest(NULL,int_current_period,MODE_HIGH,2,1)]+(Ask-Bid);
                      if(price<val)
                      {
                        price=val;
                      }
                
                  }
                  if(order_stoploss!=price)
                  {
                                result= OrderModify(OrderTicket(),OrderOpenPrice(),price,0,0,Blue);
                                 if(result)
                                   {
                                       return(1);
                                   }
                                   else
                                   {  
                                       return(0);
                                   }
                   }
            }//end if tag

      
      }
     
    }//fixed 5-6
 
  }//+++++++++++++
  //+++++++++++++++
  
  //+------------------------------------------------------------------+
//���ɶ�����-buy
//
//+------------------------------------------------------------------+
int gen_order_buy(double buyvol)
{  int order_status;
   int orderid;
  // double buyvol=0.01;//0.1��,forexֻ��
  
    double buyprice=Ask-support_price_quickorder*Point;
    
   
   //  Sleep(200);
   order_status=OrderSend(Symbol(),OP_BUY,buyvol,buyprice,10,0,0,"buy something",dbl_magic_num,0,Green);
     
     if(order_status<0)
      { return(0);
        
      }
      else
      {  
        generater_neworder_stoploss(buyvol);
         
      }
      
        return(-1);
 
 }

 
 int gen_order_sell(double buyvol)
{  int order_status;
   int orderid;
   //double buyvol=0.01;//0.1��,forexֻ��
   
     //sell
  
       double sellprice=Bid+support_price_quickorder*Point;
       
     order_status=OrderSend(Symbol(),OP_SELL,buyvol,sellprice,10,0,0,"sell some thing",dbl_magic_num,0,Green);
 
      if(order_status<0)
      { return(0);
        
      }
      else
      {  
        generater_neworder_stoploss(buyvol);
         
      }
   return(1);
   } //==========================================================================
  
  
  //�����ǽ��ײ����ຯ��
 //+------------------------------------------------------------------+
//| ��ѯ����==�۲���ƷK�߼۸�   
//�Ȳ�ѯ��һ�����ת�۵㣬
//��ѯBOLL�ǲ����ڸ���
//
//                                      |
//+------------------------------------------------------------------+
int watchKprice(int debug,int tp)
  {//������5
      int k_parent_period=parent_trend_period;
      int k_period=int_current_period;
      int k_n,b_1,k_convert;
       if(rundebug==1)
         {//���Ӳ���
          
          
       }//+++++++++++++++++++++++++++++++++++++
      
      int int_trend_parent=get_parent_direct_v2(k_parent_period);//�õ���һ��״̬��240m
     //Alert(int_trend_parent);
      
     if(rundebug==1)
         {                    double   top=WindowPriceMax();
                                 double   bottom=WindowPriceMin();
                                 int bars_count=WindowBarsPerChart();
               if(int_trend_parent==1)
               {
                           string sdt;
                           sdt="trendup_"+iTime(NULL,0,1);
                           if(ObjectFind(sdt)==-1)
                           {
                              
                               ObjectCreate(sdt, OBJ_ARROW, 0, Time[1], iHigh(NULL,0,1)+2*((top-bottom)/bars_count));
                                ObjectSet(sdt, OBJPROP_ARROWCODE, 241);//242
                                ObjectSet(sdt, OBJPROP_COLOR, Red);//242
                 
                          }
                
                 }
                    if(int_trend_parent==2)
               {

               
                            sdt="trenddown__"+iTime(NULL,0,1);
            
                           if(ObjectFind(sdt)==-1)
                           {
               
                               ObjectCreate(sdt, OBJ_ARROW, 0, Time[1], iHigh(NULL,0,1)+2*((top-bottom)/bars_count));
                                  ObjectSet(sdt, OBJPROP_ARROWCODE, 242);//242
                               ObjectSet(sdt, OBJPROP_COLOR, Green);//242
                              
                 
                          }
                  
                 }
     
        }
      if(int_trend_parent==1)
      {//����
            //�۲�ͬ���ǲ��ǳ���һ����K
         //++++++++++++++++++++++++++
          k_convert=get_kconvert_now(int_current_period,int_trend_parent);//�۲�ͬ����K����̬���ǲ��ǳ��ַ�ת��̬
          
  
     
          if(k_convert==1)
          {//������֣��۲�
            //++++++++++++++++++++++
              k_n=get_k_now(int_low_period,int_trend_parent);//�۲��һ��K����̬��1����
              if(k_n==1)
              {//��ʾ����תת�۵㵽��
              //Boll�ж�
                   b_1= isBoll(0,int_trend_parent,Close[1],k_period,Close[2]);//��ѯ�ϸ�BOLL�ǲ�������Ч�
                 if(b_1==1)
                 {
                    return(1);
                 } 
              }
          
          }
          
   
      }
      if(int_trend_parent==2)
      {//�½�
          //++++++++++++++++++++++
           k_convert=get_kconvert_now(int_current_period,int_trend_parent);//�۲�ͬ����K����̬���ǲ��ǳ��ַ�ת��̬
             
           //++++++++++++++++++++++++++++++++++++++++++++++++++
     
          if(k_convert==2)
          {//������֣��۲�
            //++++++++++++++++++
               k_n=get_k_now(int_low_period,int_trend_parent);//�۲��һ��K����̬��1����
             
           //+++++++++++++++++++++++++++++++++++++++++++
              if(k_n==2)
              {//��ʾ����תת�۵㵽��
              //Boll�ж�
                   b_1= isBoll(0,int_trend_parent,Close[1],k_period,Close[2]);//��ѯ�ϸ�BOLL�ǲ�������Ч?
            
                  if(b_1==2)
                 {
                    return(2);
                 } 
              }
          
       }
          
   }
 
     
    
      return(-1);
  }  
 

   //+------------------------------------------------------------------+
//�۲��ƷK����-ͬ�����Boll��,
//+------------------------------------------------------------------+
 int isBoll(int i,int trendflag,double currtpice,int tf,double preprice)
{//
      double d_1,d_2,d_3,d_4,d_5;
      int debug=1;
      d_1=iBands(NULL,tf,20,2,0,PRICE_CLOSE,MODE_MAIN,i);
      
      d_2=iBands(NULL,tf,20,2,0,PRICE_CLOSE,MODE_UPPER,i);
      
      d_3=iBands(NULL,tf,20,2,0,PRICE_CLOSE,MODE_LOWER,i);
      
      d_4=iBands(NULL,tf,20,2,0,PRICE_CLOSE,MODE_MAIN,i+1);
      
    
      int boll_ok=0;
      boll_width=2.5;
       
        if(trendflag==1)
        {//��
               if(currtpice<=d_1)
               {
                   boll_ok=1;
               }
               if((currtpice>d_1)&&(preprice<d_4))
               {//ǰ����BOLL�й��ϣ�ĿǰK�ߵ��Ϲ�
                   boll_ok=1;
               }
        }
         if(trendflag==2)
        {//��
               if(currtpice>=d_1)
               {
                   boll_ok=2;
               }
               if((currtpice<d_1)&&(preprice>d_4))
               {//ǰ����BOLL�й��£�ĿǰK�ߵ��й���++++++
                   boll_ok=2;
               }
               
        }
      
      
              
     
       //+++++++++++++++++++++++++++
        return(boll_ok);

}
  //+------------------------------------------------------------------+
//�۲��ƷK������-ͬ�����ǲ��ǳ��ַ�ת��̬��K��
//PERIOD_M1 1 1 ���� PERIOD_M5 5 5���� PERIOD_M15 15 15 ���� 
//PERIOD_M30 30 30 ���� PERIOD_H1 60 1 Сʱ PERIOD_H4 240 4 Сʱ 
//PERIOD_D1 1440 ÿ�� PERIOD_W1 10080 ÿ���� PERIOD_MN1 43200 ÿ�� 
//+------------------------------------------------------------------+
int get_kconvert_now(int k_period,int int_trend_parents)
{
      double k_1,k_2,k_3,k_4,k_5;
      int direct_k=0;
      //k_1=iClose(NULL ,k_period,0);
      k_2=iClose(NULL ,k_period,1);
      k_3=iClose(NULL ,k_period,2);
    //  k_4=iClose(NULL ,k_period,3);
     // k_5=iClose(NULL ,k_period,4);
   // Alert(int_trend_parents);
      //==========================
      if(int_trend_parents==1)
      {
          if(k_2>=k_3)
          {
             direct_k=1;
                if(rundebug==1)
                  {
                        double   top=WindowPriceMax();
                         double   bottom=WindowPriceMin();
                                 int bars_count=WindowBarsPerChart();
                        string sdt="";
                                              
                         sdt="Currenttrend_"+iTime(NULL,0,1);
            
                           if(ObjectFind(sdt)==-1)
                           {
               
                               ObjectCreate(sdt, OBJ_ARROW, 0, Time[1], iHigh(NULL,0,1)+4*((top-bottom)/bars_count));
                                  ObjectSet(sdt, OBJPROP_ARROWCODE, 67);//242
                               ObjectSet(sdt, OBJPROP_COLOR, Red);//242
                 
                          }
                   
                           
                 
                 }
          }
      
      }
      
        if(int_trend_parents==2)
      {
          if(k_2<=k_3)
          {
             direct_k=2;
             
               if(rundebug==1)
                  {       top=WindowPriceMax();
                          bottom=WindowPriceMin();
                           bars_count=WindowBarsPerChart();
                          sdt="CurrenttrendD_"+iTime(NULL,0,1);
                         if(ObjectFind(sdt)==-1)
                           {
               
                               ObjectCreate(sdt, OBJ_ARROW, 0, Time[1], iHigh(NULL,0,1)+4*((top-bottom)/bars_count));
                                  ObjectSet(sdt, OBJPROP_ARROWCODE, 68);//242
                               ObjectSet(sdt, OBJPROP_COLOR, Green);//242
                 
                          }
                        
                       
                 }
          }
      
      }
      //����������ת��׹
     // if((k_3>=k_4)&&(k_3>=k_2))
     // {
       // direct_k=1;//����ת�½�
    //  }
     
    //if((k_3<=k_4)&&(k_3<=k_2))
      //{
        // direct_k=2;//�½�ת����
     // }
      
    
      
     return(direct_k);
}
  //+------------------------------------------------------------------+
//�۲��ƷK������-Low Period��ma
//PERIOD_M1 1 1 ���� PERIOD_M5 5 5���� PERIOD_M15 15 15 ���� 
//PERIOD_M30 30 30 ���� PERIOD_H1 60 1 Сʱ PERIOD_H4 240 4 Сʱ 
//PERIOD_D1 1440 ÿ�� PERIOD_W1 10080 ÿ���� PERIOD_MN1 43200 ÿ�� 
//+------------------------------------------------------------------+
int get_k_now(int k_period,int int_trend_parents)
{
      double k_1,k_2,k_3,k_4,k_5;
      int direct_k=0;
      
      k_1=iClose(NULL ,k_period,1);

      //����������ת��׹
      
       
     double teeth_val1=iMA(NULL,k_period,5,3,MODE_SMMA,PRICE_CLOSE,0);
     if(int_trend_parents==1)
     {
         if(k_1>teeth_val1)
         {
              direct_k=1;//up to down
              if(rundebug==1)
                  {
                        
                       string str_obj_name;
                        str_obj_name="low_level__"+iTime(NULL,0,1);
                        if(ObjectFind(str_obj_name)==-1)
                        {
                          ObjectCreate(str_obj_name, OBJ_VLINE, 0, Time[1], 0);
                             ObjectSet(str_obj_name, OBJPROP_COLOR, Green);//242
   
                        } 
                   
                     
                 }
     
         }
     
     }
     
      if(int_trend_parents==2)
     {
         if(k_1<teeth_val1)
         {
              direct_k=2;//up to down
     
         }
         
          if(rundebug==1)
                  {
                           
                        str_obj_name="high_level__"+iTime(NULL,0,1);
                        if(ObjectFind(str_obj_name)==-1)
                        {
                              ObjectCreate(str_obj_name, OBJ_VLINE, 0, Time[1], 0);
                          
                               ObjectSet(str_obj_name, OBJPROP_COLOR, Green);//242
                        
                        }
                        
                           
                          
                 }
         
     
     }
     
    
     
     //+++++++++++++++++++++++++
     return(direct_k);
}


int get_k_now_v2(int k_period)
{
      double k_1,k_2,k_3,k_4,k_5;
      int direct_k=0;
      int k_postion;
      k_1=iClose(NULL ,k_period,0);
      k_2=iClose(NULL ,k_period,1);
      k_3=iClose(NULL ,k_period,2);
      k_4=iClose(NULL ,k_period,3);
      k_5=iClose(NULL ,k_period,4);
      //����������ת��׹
      if((k_4>=k_5)&&(k_3>=k_4))
      {  
         k_postion= iLowest(NULL,0,MODE_LOW,5,0);
         if(k_postion==3||k_postion==4||k_postion==5)
         {
             direct_k=1;//����ת�½�
         }
      }
        if((k_4>=k_3)&&(k_2>=k_3))
      {  
         k_postion= iLowest(NULL,0,MODE_LOW,5,0);
         if(k_postion==3||k_postion==4||k_postion==2)
         {
             direct_k=1;//����ת�½�
         }
      }
          if((k_3>=k_2)&&(k_1>=k_2))
      {  
         k_postion= iLowest(NULL,0,MODE_LOW,5,0);
         if(k_postion==3||k_postion==1||k_postion==2)
         {
             direct_k=1;//����ת�½�
         }
      }
       //�������½�ת����
      if((k_4<=k_5)&&(k_3<=k_4))
      {  
         k_postion= iHighest(NULL,0,MODE_HIGH,5,0);
         if(k_postion==3||k_postion==4||k_postion==5)
         {
             direct_k=2;//����ת�½�
         }
      }
        if((k_4>=k_3)&&(k_2>=k_3))
      {  
         k_postion= iHighest(NULL,0,MODE_HIGH,5,0);
         if(k_postion==3||k_postion==4||k_postion==2)
         {
             direct_k=2;//����ת�½�
         }
      }
          if((k_3>=k_2)&&(k_1>=k_2))
      {  
         k_postion= iHighest(NULL,0,MODE_HIGH,5,0);
         if(k_postion==3||k_postion==1||k_postion==2)
         {
             direct_k=2;//����ת�½�
         }
      }
   
     return(direct_k);
}
  //+---------------------

/*
 get_parent_direct
 ��������ǵõ�ָ����K�ߵ����ơ���� ���𵴣�ȥ������ǰһK�ߵ�trend
 
 */
 int get_parent_direct_v2(int timeframes)
 {
 
   bool runflag=true;
  int i=1;
  double k1,k2,k3,k4;
  int direct_1=0;
   while(runflag)
   {
       if( (iLow(NULL,timeframes,i)>=iLow(NULL,timeframes,i+1))&&(iHigh(NULL,timeframes,i)<=iHigh(NULL,timeframes,i+1)))
       {          
            i++;
       }
       else
       {
            runflag=false;
            //�����������ж�
             if( (iLow(NULL,timeframes,i)<=iLow(NULL,timeframes,i+1))&&(iClose(NULL,timeframes,0)<iHigh(NULL,timeframes,i+1)))
             {
                  direct_1=2;//down
             
             }
           // if( (iLow(NULL,timeframes,i)>=iLow(NULL,timeframes,i+1))&&(iHigh(NULL,timeframes,i)>=iHigh(NULL,timeframes,i+1)))
             if( (iClose(NULL,timeframes,0)>iLow(NULL,timeframes,i+1))&&(iHigh(NULL,timeframes,i)>=iHigh(NULL,timeframes,i+1)))
             {
                  direct_1=1;//up
             
             }
            
             
             return(direct_1);
       
       }      
  
     }
     return(0);
  }//=================================

  //+------------------------------------------------------------------+
//�۲��Ʒ�߼���K������
//���ԣ������߼۸ߣ��ͼ۸�;�ͣ��ͼ۵ͣ��ͼ۵�;����
//PERIOD_M1 1 1 ���� PERIOD_M5 5 5���� PERIOD_M15 15 15 ���� 
//PERIOD_M30 30 30 ���� PERIOD_H1 60 1 Сʱ PERIOD_H4 240 4 Сʱ 
//PERIOD_D1 1440 ÿ�� PERIOD_W1 10080 ÿ���� PERIOD_MN1 43200 ÿ�� 
//+------------------------------------------------------------------+
int get_trend_parent(int k_period,int k_n)
{//����ط�������Ҫ���ӹ��� ����TREND����ΪUP ��down
     
      double k_1_l,k_2_l;
      double k_1_h,k_2_h;
      int direct=0;
      k_1_l=iHigh(NULL ,k_period,k_n);
      k_1_h=iLow(NULL ,k_period,k_n);
      k_n=k_n+1;
      k_2_l=iHigh(NULL ,k_period,k_n);
      k_2_h=iLow(NULL ,k_period,k_n);
      if((k_1_h>=k_2_h)&&(k_1_l>=k_2_l))
      {
         direct=1;//����
      }
      
     if((k_1_h<=k_2_h)&&(k_1_l<=k_2_l))
      {
         direct=2;//�½�
      }
      
      
     return(direct);
}
/********************************************
��ѯ���׷��ն�-��ͨ��RSI����ѯ����
*/
  int query_risk()
  {//��ѯ���ղ�������
   int d_risk=0;
    double is1=iRSI(NULL,parent_trend_period,14,PRICE_CLOSE,0);//
  //t��ng gu�� g��o j�� q�� sh�� de RSIl��i ch�� x��n f��ng xi��n d�� ��r�� gu�� d�� y�� 85��b�� n��ng m��i ��r�� gu��
      if(is1>=99.0)
      {
         d_risk=1;//��ʾ�߷����� buy
      }
       if(is1<=5.0)
      {
         d_risk=2;//��ʾ�߷�����sell
      }
       if(rundebug==1)
      {//����
        
      
      }
 //  Alert(d_risk);
  return(d_risk);
}
  
 //�����������ຯ�� 
 //+------------------------------------------------------------------+
//| ��ѯ����                                         |
//+------------------------------------------------------------------+
int queryLimit(int debug,int tp)
  {
//----
   int int_limit=1;
   
   if(tp==0)
   {//ʱ������
      
      int h=TimeHour(TimeCurrent());
      //Alert("hour:",h);
      if((h>-1)&&(h<25))
      {//ʱ����8�㵽12��,����������ʱ��
         int_limit=0;
      }
     
   }//ʱ����������
   if(tp==1)
   {//����״̬��ѯ
       int order_num=query_order_num_status();//�õ���������
       if(order_num==0)
       {//�������Ϊ0������ִ��
          int_limit=0;
       }
       else
       {
       
         int_limit=order_num;
       }
        if(rundebug==1)
      {//add function demo
        
       }
         
    }
   
//----
   return(int_limit);
  }
  
  
  //+------------------------------------------------------------------+
//��ѯ��������״̬[�ҵ�������]
//
//+------------------------------------------------------------------+
int query_orderpf_num()
{//return history profit is negative ,
  
    int or_t=OrdersHistoryTotal();
   int order_id;
   int order_num=0;
   
   for(int pos=0;pos<or_t;pos++)
   {
      if(OrderSelect(pos,SELECT_BY_POS,MODE_HISTORY)) 
      {
         if(OrderMagicNumber()==dbl_magic_num)
         {//fixed 2013-5-6
            if( OrderProfit()<0)
            {
               order_num++;
            }
         }//fixed 2013-5-6
         

      }

   }
   return(order_num);//-------------------
   
   



}
int query_order_num_status()
{

   int or_t=OrdersTotal();
   int order_id;
   int order_num=0;
   for(int pos=0;pos<or_t;pos++)
   {
      if(OrderSelect(pos,SELECT_BY_POS)) 
      {
          //order_id=OrderTicket();
          if(OrderMagicNumber()==dbl_magic_num)
         {//fixed 2013-5-6
            if( (OrderType()==OP_BUY)||(OrderType()==OP_SELL ))
            {//��Ҫ���ų��ҵ�
              order_num++;
            }
          }

      }

   }
   return(order_num);//--------------------------

}//===============================================
//��ͼ����


//+------------------------------------------------------------------+
int get_order_open_df()
{//�õ������뿪ʼ��������ʱ���뵱ǰʱ��Ĳ��----------------
   int total=OrdersTotal();
   if(total>0)
   {
      if(OrderSelect(0, SELECT_BY_POS)==true)
      {
          if(OrderMagicNumber()==dbl_magic_num)
         {//fixed 2013-5-6
               datetime dt =OrderOpenTime();
                datetime dt1=TimeCurrent();
                return((dt1-dt)/60);
          }
       
      }

   }
   return(-1);
}//_______________--------------------------------------

void drawline(datetime dt,double price)
{
     string sdt="";
     sdt="xh_"+TimeLocal();
     ObjectCreate(sdt, OBJ_VLINE, 0, dt, price);


}
//+------------------------------------------------------------------+