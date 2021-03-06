//+------------------------------------------------------------------+
//本E在5分钟级别执行
//第一布是查询风险度
//|   查询执行条件，第一条件日期条件，第二条件 订单                                               |
//| 执行条件查询:                                      
//确定日线级别两个K线的趋势
//
//采用5分钟，跟踪日线的交易机会，
//策略是：日线出现反趋势的第一个K线，
//在5分钟级别采用第一个订单
 
 //+------------------------------------------------------------------+
//观察产品K线趋势-同级别是不是出现反转形态的K线
//PERIOD_M1 1 1 分钟 PERIOD_M5 5 5分钟 PERIOD_M15 15 15 分钟 
//PERIOD_M30 30 30 分钟 PERIOD_H1 60 1 小时 PERIOD_H4 240 4 小时 
//PERIOD_D1 1440 每天 PERIOD_W1 10080 每星期 PERIOD_MN1 43200 每月 
//+---------------------------

//+------------------------------------------------------------------+
#property copyright "david wang"
#property link      "http://david wang"
int rundebug=1;
double support_price_quickorder=0;//支持快成交的价格
double fixed_stoploss=500;//oanda 1000表示1美元 forex 100表示1 usd
int parent_trend_period=1440;//
int int_low_period=1;
int int_current_period=5;
double boll_width=2.5;
 double buyvol=0.01;

 double g_profit_basic_each_vol=1.5;//每个手上调给固定止损位
 double g_profit_basic_each_vol_zero=2.5;//每个上调到固定止损位+成本
 bool g_profit_basic_each_vol_flag=true;//每个上调到固
 double g_profit_level1_each_vol=400;//最大回撤70
 double g_profit_level2_each_vol=600;// 最大回撤50-----
 double g_profit_level3_each_vol=800;// 最大回撤30-----------
 double g_profit_level4_each_vol=1000;// 最大回撤10-------
 int dbl_magic_num=10051;//1表示黄金，005表示5minute
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
   
   int int_dt_limit=queryLimit(0,0);//查询Ea的执行条件_时间
   int int_order_limit=queryLimit(0,1);//查询Ea的执行条件_订单
   int int_ok;
   int wk;
 
   int s;
 
    if(int_order_limit>0)
   { //如果有订单的话，可以监察订单的状态 
           
        generater_order_stoploss(buyvol);
        generate_order_profit(buyvol);
  
   }/////      
         
   if((int_dt_limit==0)&&(int_order_limit==0))
   {//开始执行相关策略,，没有订单的情形
          int int_risk=query_risk();//系统查+
          int int_orderpf=query_orderpf_num(); 
          if(int_orderpf>3)
          {//如果连续出现3次lost------------，就停止操作-----------
            //return(0);          
          }
          
        //++++++++++++++++++++++++++++++++

   
        wk=  watchKprice(0,0);//返回值为负的话，不执行
       if(wk==1)
       {//buy 1
           if(int_risk==1)
            {//在高风险市场中，EA不执行
               return(0);
            }//+++++++++++++++++++   
         gen_order_buy(buyvol);
       }
        if(wk==2)
       {//sell
            if(int_risk==2)
            {//在高风险市场中，EA不执行
               return(0);
            }//++++++++++
           gen_order_sell(buyvol);
       }
   
   }
 
   
//----
   return(0);
  }
  //下面是订单执行类函数
  
   int generate_order_profit(double buyvol)
  {  //下面是执行订单的执行收益情况
     //如果出现反趋势，采用跟踪性止损策略
       double price,order_profit,order_stoploss;
        bool   result,bexecute;
       int int_trend_parent=get_parent_direct_v2(parent_trend_period);//得到上一级状
      for(int i=0;i<OrdersTotal();i++)
      {
  
             if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {   
                    if(OrderMagicNumber()==dbl_magic_num)
                      {//fixed 2013-5-6
                           order_profit=OrderProfit();//得到订
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
  
  
  //修改订单的止损位

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
    //关闭所有订单
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
//生成订单吧-buy
//
//+------------------------------------------------------------------+
int gen_order_buy(double buyvol)
{  int order_status;
   int orderid;
  // double buyvol=0.01;//0.1手,forex只对
  
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
   //double buyvol=0.01;//0.1手,forex只对
   
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
  
  
  //下面是交易策略类函数
 //+------------------------------------------------------------------+
//| 查询条件==观察商品K线价格   
//先查询低一级别的转折点，
//查询BOLL是不是在附近
//
//                                      |
//+------------------------------------------------------------------+
int watchKprice(int debug,int tp)
  {//测试用5
      int k_parent_period=parent_trend_period;
      int k_period=int_current_period;
      int k_n,b_1,k_convert;
       if(rundebug==1)
         {//增加测试
          
          
       }//+++++++++++++++++++++++++++++++++++++
      
      int int_trend_parent=get_parent_direct_v2(k_parent_period);//得到上一级状态，240m
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
      {//上涨
            //观察同级是不是出现一个阳K
         //++++++++++++++++++++++++++
          k_convert=get_kconvert_now(int_current_period,int_trend_parent);//观察同级级K线形态，是不是出现反转形态
          
  
     
          if(k_convert==1)
          {//如果出现，观察
            //++++++++++++++++++++++
              k_n=get_k_now(int_low_period,int_trend_parent);//观察低一级K线形态，1分钟
              if(k_n==1)
              {//表示可以转转折点到了
              //Boll判断
                   b_1= isBoll(0,int_trend_parent,Close[1],k_period,Close[2]);//查询上个BOLL是不是在有效�
                 if(b_1==1)
                 {
                    return(1);
                 } 
              }
          
          }
          
   
      }
      if(int_trend_parent==2)
      {//下降
          //++++++++++++++++++++++
           k_convert=get_kconvert_now(int_current_period,int_trend_parent);//观察同级级K线形态，是不是出现反转形态
             
           //++++++++++++++++++++++++++++++++++++++++++++++++++
     
          if(k_convert==2)
          {//如果出现，观察
            //++++++++++++++++++
               k_n=get_k_now(int_low_period,int_trend_parent);//观察低一级K线形态，1分钟
             
           //+++++++++++++++++++++++++++++++++++++++++++
              if(k_n==2)
              {//表示可以转转折点到了
              //Boll判断
                   b_1= isBoll(0,int_trend_parent,Close[1],k_period,Close[2]);//查询上个BOLL是不是在有效?
            
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
//观察产品K线在-同级别的Boll线,
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
        {//上
               if(currtpice<=d_1)
               {
                   boll_ok=1;
               }
               if((currtpice>d_1)&&(preprice<d_4))
               {//前者在BOLL中轨上，目前K线到上轨
                   boll_ok=1;
               }
        }
         if(trendflag==2)
        {//下
               if(currtpice>=d_1)
               {
                   boll_ok=2;
               }
               if((currtpice<d_1)&&(preprice>d_4))
               {//前者在BOLL中轨下，目前K线到中轨上++++++
                   boll_ok=2;
               }
               
        }
      
      
              
     
       //+++++++++++++++++++++++++++
        return(boll_ok);

}
  //+------------------------------------------------------------------+
//观察产品K线趋势-同级别是不是出现反转形态的K线
//PERIOD_M1 1 1 分钟 PERIOD_M5 5 5分钟 PERIOD_M15 15 15 分钟 
//PERIOD_M30 30 30 分钟 PERIOD_H1 60 1 小时 PERIOD_H4 240 4 小时 
//PERIOD_D1 1440 每天 PERIOD_W1 10080 每星期 PERIOD_MN1 43200 每月 
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
      //下面是上涨转下坠
     // if((k_3>=k_4)&&(k_3>=k_2))
     // {
       // direct_k=1;//上涨转下降
    //  }
     
    //if((k_3<=k_4)&&(k_3<=k_2))
      //{
        // direct_k=2;//下降转上涨
     // }
      
    
      
     return(direct_k);
}
  //+------------------------------------------------------------------+
//观察产品K线趋势-Low Period用ma
//PERIOD_M1 1 1 分钟 PERIOD_M5 5 5分钟 PERIOD_M15 15 15 分钟 
//PERIOD_M30 30 30 分钟 PERIOD_H1 60 1 小时 PERIOD_H4 240 4 小时 
//PERIOD_D1 1440 每天 PERIOD_W1 10080 每星期 PERIOD_MN1 43200 每月 
//+------------------------------------------------------------------+
int get_k_now(int k_period,int int_trend_parents)
{
      double k_1,k_2,k_3,k_4,k_5;
      int direct_k=0;
      
      k_1=iClose(NULL ,k_period,1);

      //下面是上涨转下坠
      
       
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
      //下面是上涨转下坠
      if((k_4>=k_5)&&(k_3>=k_4))
      {  
         k_postion= iLowest(NULL,0,MODE_LOW,5,0);
         if(k_postion==3||k_postion==4||k_postion==5)
         {
             direct_k=1;//上涨转下降
         }
      }
        if((k_4>=k_3)&&(k_2>=k_3))
      {  
         k_postion= iLowest(NULL,0,MODE_LOW,5,0);
         if(k_postion==3||k_postion==4||k_postion==2)
         {
             direct_k=1;//上涨转下降
         }
      }
          if((k_3>=k_2)&&(k_1>=k_2))
      {  
         k_postion= iLowest(NULL,0,MODE_LOW,5,0);
         if(k_postion==3||k_postion==1||k_postion==2)
         {
             direct_k=1;//上涨转下降
         }
      }
       //下面是下降转上涨
      if((k_4<=k_5)&&(k_3<=k_4))
      {  
         k_postion= iHighest(NULL,0,MODE_HIGH,5,0);
         if(k_postion==3||k_postion==4||k_postion==5)
         {
             direct_k=2;//上涨转下降
         }
      }
        if((k_4>=k_3)&&(k_2>=k_3))
      {  
         k_postion= iHighest(NULL,0,MODE_HIGH,5,0);
         if(k_postion==3||k_postion==4||k_postion==2)
         {
             direct_k=2;//上涨转下降
         }
      }
          if((k_3>=k_2)&&(k_1>=k_2))
      {  
         k_postion= iHighest(NULL,0,MODE_HIGH,5,0);
         if(k_postion==3||k_postion==1||k_postion==2)
         {
             direct_k=2;//上涨转下降
         }
      }
   
     return(direct_k);
}
  //+---------------------

/*
 get_parent_direct
 这个函数是得到指定的K线的趋势。如果 是震荡，去掉，找前一K线的trend
 
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
            //下面是趋势判断
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
//观察产品高级别K线趋势
//策略：长：高价高，低价高;低：低价低，低价低;盘整
//PERIOD_M1 1 1 分钟 PERIOD_M5 5 5分钟 PERIOD_M15 15 15 分钟 
//PERIOD_M30 30 30 分钟 PERIOD_H1 60 1 小时 PERIOD_H4 240 4 小时 
//PERIOD_D1 1440 每天 PERIOD_W1 10080 每星期 PERIOD_MN1 43200 每月 
//+------------------------------------------------------------------+
int get_trend_parent(int k_period,int k_n)
{//这个地方，可能要增加功能 ，把TREND，变为UP ，down
     
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
         direct=1;//上涨
      }
      
     if((k_1_h<=k_2_h)&&(k_1_l<=k_2_l))
      {
         direct=2;//下降
      }
      
      
     return(direct);
}
/********************************************
查询交易风险度-先通过RSI来查询风险
*/
  int query_risk()
  {//查询风险参数日线
   int d_risk=0;
    double is1=iRSI(NULL,parent_trend_period,14,PRICE_CLOSE,0);//
  //tōng guò gāo jí qū shì de RSIlái chá xún fēng xiǎn dù ，rú guǒ dà yú 85，bú néng mǎi ，rú guǒ
      if(is1>=99.0)
      {
         d_risk=1;//表示高风险区 buy
      }
       if(is1<=5.0)
      {
         d_risk=2;//表示高风险区sell
      }
       if(rundebug==1)
      {//增加
        
      
      }
 //  Alert(d_risk);
  return(d_risk);
}
  
 //下面是条件类函数 
 //+------------------------------------------------------------------+
//| 查询条件                                         |
//+------------------------------------------------------------------+
int queryLimit(int debug,int tp)
  {
//----
   int int_limit=1;
   
   if(tp==0)
   {//时间条件
      
      int h=TimeHour(TimeCurrent());
      //Alert("hour:",h);
      if((h>-1)&&(h<25))
      {//时间在8点到12点,采用是美国时间
         int_limit=0;
      }
     
   }//时间条件结束
   if(tp==1)
   {//订单状态查询
       int order_num=query_order_num_status();//得到订单数量
       if(order_num==0)
       {//如果订单为0，可以执行
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
//查询订单数量状态[挂单不计算]
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
            {//主要是排除挂单
              order_num++;
            }
          }

      }

   }
   return(order_num);//--------------------------

}//===============================================
//绘图测试


//+------------------------------------------------------------------+
int get_order_open_df()
{//得到订单与开始订单开放时间与当前时间的差距----------------
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