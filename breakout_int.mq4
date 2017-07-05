//+------------------------------------------------------------------+
//|                                                 breakout_int.mq4 |
//|                                                       david wang |
//|                                                     分形突破交易 |
//+------------------------------------------------------------------+
#property copyright "david wang"
#property link      "固定值突破交易"
//区间交易
//
/*------------------------------------------------------------------+
买入策略
可以固定值区间交易，如果报价时，类似数值取最小值整值，最大值
例白银报价23.52;;区间为【23-24】，以上突破24，买入，如果继续向上，继续买入
卖出策略
如果出现一个订单的交易方向和不一样，这样关闭和最后一个
不一样的所有的订单

------------------------------------------------------------------+*/

extern int dbl_magic_num=20051;//2表示白银，
extern double support_price_quickorder=50;//快速成交\
extern double supportrvalue=0.5;//跟随止损值，是ratio一半，自己设定-------
extern int ratio=2;//区间差,不支持小数，只支持整数

extern double stoplossvalue=0.0;//初始化止损值
extern double buyvol=0.1;//交易的手数
extern string magicstring="Gold Trade";
  
//下面定义全局变量
int temp_int_Op_BUY=0;
int temp_int_Op_SELL=0;
int temp_int_Op_BUYLIMIT=0;
int temp_int_Op_SELLLIMIT=0;
int temp_int_OP_SELLSTOP=0;
int temp_int_OP_BUYSTOP=0;
//-------------------------------


//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
     double oop,opp,t_opp;
    
      int tp,pos;
  
    stoplossvalue=2*MathAbs(Bid-Ask)/Point;
    int int_dt_limit=queryLimit(0,0);//查询Ea的执行条件_时间
    ini_order_num();//初始化订单数量---------------
 
 
   
      
     if((temp_int_Op_BUY+temp_int_Op_SELL)>1)
   { //如果有订单的话，可以监察订单的状态    
      generate_order_profit(buyvol);
   
      //==============================================
  
   }//
   
     double dn=MathFloor(Bid/ratio);
        double dn1=MathFloor(Ask/ratio);
        if(dn!=dn1)
        {//这个条件增加，主要是在关键点，附近震荡
            return(0);
        }//---------------------------------------
     dn=dn*ratio;//区间下沿
     double up=dn+1*ratio;//区间上沿
    
     
   if((int_dt_limit==0)&&((temp_int_Op_BUY+temp_int_Op_SELL+temp_int_Op_BUYLIMIT+temp_int_Op_SELLLIMIT+temp_int_OP_SELLSTOP+temp_int_OP_BUYSTOP)==0))
   {//挂单都没有
        int os1= OrderSend(Symbol(),OP_BUYSTOP,buyvol,up,support_price_quickorder,up-stoplossvalue*Point,0,magicstring,dbl_magic_num,0,Green);
       if(os1>0)
       {
         int os2=  OrderSend(Symbol(),OP_SELLSTOP,buyvol,dn,support_price_quickorder,dn+stoplossvalue*Point,0,magicstring,dbl_magic_num,0,Green);
         if(os2<0)
         {//删除上一个订单
         
            OrderDelete(os1);//如果是出错，就会删除第一条记录
         }//---------------------------------------------------------------------------------
       }//---------------------------------------------------------------------------------
     
       
   
   }
     if((int_dt_limit==0)&&((temp_int_Op_BUYLIMIT+temp_int_Op_SELLLIMIT+temp_int_OP_SELLSTOP+temp_int_OP_BUYSTOP)==1))//时间条件，只有一个挂单，表示最少成交一个
    {//#5
           for(pos=OrdersTotal()-1;pos>=0;pos--)
            {//#4
                        if(OrderSelect(pos,SELECT_BY_POS)) 
                        {//#3
                            
                             if(OrderMagicNumber()==dbl_magic_num)//#2
                              {
                                     
                                    if( (OrderType()==OP_BUYSTOP)||(OrderType()==OP_SELLSTOP ))
                                    {//主要是排除挂单#1
                                        OrderDelete(OrderTicket());
                                        break;
                                     }//#1
                                     
                                     
                                 }//#2
                         }//#3
              } //#4------------------------------------  
         
    }
   
    if((int_dt_limit==0)&&((temp_int_Op_BUYLIMIT+temp_int_Op_SELLLIMIT+temp_int_OP_SELLSTOP+temp_int_OP_BUYSTOP)==0)&&((temp_int_Op_BUY+temp_int_Op_SELL)>0))//时间条件，只有一个挂单，表示最少成交一个
    {//#5-----------------------------------------------------------------------
         
         
             //上面是删除一个挂单
             t_opp=0;//初始化变量
             
              for(pos=OrdersTotal()-1;pos>=0;pos--)
            {//#4
                        if(OrderSelect(pos,SELECT_BY_POS)) 
                        {//#3
                            
                             if(OrderMagicNumber()==dbl_magic_num)//#2
                              {//#2
                                    opp=MathRound(OrderOpenPrice());//项目订单开单价格
                                   
                                   //  Alert(opp,"dn",dn,"up",up);//1390 1390 1392
                                     if((opp>(dn-Point))&&(opp<(up+Point)))
                                     {//如果项目订单价格在成交区间内，不下新的订单#0
                                         // Alert("ok");
                                     
                                     }//#0
                                     else
                                     {//#0
                                               os1= OrderSend(Symbol(),OP_BUYSTOP,buyvol,up,support_price_quickorder,up-stoplossvalue*Point,0,magicstring,dbl_magic_num,0,Green);
                                                if(os1>0)
                                                {
                                                   os2=  OrderSend(Symbol(),OP_SELLSTOP,buyvol,dn,support_price_quickorder,dn+stoplossvalue*Point,0,magicstring,dbl_magic_num,0,Green);
                                                  if(os2<0)
                                                  {//删除上一个订单
         
                                                     OrderDelete(os1);//如果是出错，就会删除第一条记录
                                                  }//---------------------------------------------------------------------------------
                                                }//----------------------
                                                break;
                                     
                                     
                                     }//#0
                                     break;//主要是查询最后一条成交记录
                                     
           
                                   
                                     
                                     
                                     
                                     
                               }//#2
                         }//#3
              } //#4-----------------------------
              
                           
                           
    
    
    }//#5
  
   
   
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

 //下面是条件类函数 
 //+------------------------------------------------------------------+
//| 查询条件                                         |
//+------------------------------------------------------------------+
int queryLimit(int debug,int tp)
  {
//----
   int temp_int_limit=1;
   
   if(tp==0)
   {//时间条件
      
      int h=TimeHour(TimeCurrent());
      //Alert("hour:",h);
      if((h>-1)&&(h<25))
      {//时间在8点到12点,采用是美国时间
         temp_int_limit=0;
      }
     
   }//时间条件结束
  
   
//----
   return(temp_int_limit);
  }
  
  
  //+------------------------------------------------------------------+
//查询订单数量状态[挂单不计算]
//
//+------------------------------------------------------------------+

 //+------------------------------------------------------------------+
//查询订单数量状态[挂单不计算]
//
//+------------------------------------------------------------------+
int ini_order_num()//初始化订单数量--------
{
    //初始化所有变量
      temp_int_Op_BUY=0;
      temp_int_Op_SELL=0;
      temp_int_Op_BUYLIMIT=0;
      temp_int_Op_SELLLIMIT=0;
      temp_int_OP_SELLSTOP=0;
      temp_int_OP_BUYSTOP=0;
   //上面是初始化所有变量
    
    int or_t=OrdersTotal();
 
   for(int pos=0;pos<or_t;pos++)
   {
      if(OrderSelect(pos,SELECT_BY_POS)) 
      {
          
          if(OrderMagicNumber()==dbl_magic_num)
          {
              
                if(OrderType()==OP_BUY)
               {//主要是排除挂单#00
                 temp_int_Op_BUY++;
                 
                }//#00---------------
                 if(OrderType()==OP_SELL )
               {//主要是排除挂单#00
                  temp_int_Op_SELL++;
                }//#00---------------
                 if(OrderType()==OP_BUYLIMIT)
               {//主要是排除挂单#00
                   temp_int_Op_BUYLIMIT++;
            
                }//#00---------------
                
                 if(OrderType()==OP_SELLLIMIT)
               {//主要是排除挂单#00
                 temp_int_Op_SELLLIMIT++;
                 
                }//#00---------------
                
                
                 if(OrderType()==OP_BUYSTOP)
               {//主要是排除挂单#00
                   temp_int_OP_BUYSTOP++;
                }//#00---------------
                
                 if(OrderType()==OP_SELLSTOP)
               {//主要是排除挂单#00
                 temp_int_OP_SELLSTOP++;
               }//#00-------------------------------------------
               //-------------------------------------------------------
               
               
          }

      }

   }
   return(0);//----------------------------------------

}//------------------------------


  //下面是订单执行类函数
   
   int generate_order_profit(double buyvol)
  {  //下面是执行订单的执行收益情况
     //如果出现反趋势，采用跟踪性止损策略
     //如果最后一个，方向不一样，关闭所有  
     int trade_tp=0;//交易类型

     double myarray[100];
     ArrayInitialize(myarray,0.0);
     
      for(int i=0;i<OrdersTotal();i++)
      {//#2 
              if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {//#1   
                    if(OrderMagicNumber()==dbl_magic_num)
                      {//fixed 2013-5-6#0
                              
                            if( OrderType()==OP_BUY)
                              {  myarray[i]=1;
                                
                              }    
                               
                           if( OrderType()==OP_SELL)
                              {
                                 myarray[i]=-1; 
                              } 
                               
                     }//#0
                 }//#1  
                         
  
      }//#2 
      if((myarray[ArrayMaximum(myarray)]==1)&&(myarray[ArrayMaximum(myarray)]==-1))
      {//close all Order
      //#00000000000000
      
               int trade_tps=0;
               for(i=0;i<OrdersTotal();i++)
               {//#2 
                       if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                        {//#1   
                             if(OrderMagicNumber()==dbl_magic_num)
                               {//fixed 2013-5-6#0
                                    
                                      if( OrderType()==OP_BUY)
                                      {   if((trade_tps==0)||(trade_tps==1))//这主要过滤最后一条订单--------------
                                           {
                                                OrderClose(OrderTicket(),OrderLots(),Bid,support_price_quickorder,Red);
                                                trade_tps=1;
                                          }
                                                              
                                      }    
                               
                                   if( OrderType()==OP_SELL)
                                      {
                                         if((trade_tps==0)||(trade_tps==2))//这主要过滤最后一条订单-----------
                                           {
                                          OrderClose(OrderTicket(),OrderLots(),Ask,support_price_quickorder,Red);
                                           trade_tps=2;
                                          }
                                      } 
                      
                      
                                }//#0
                          }//#1  
                         
  
               }//#2 
      
      }//#00000000000000--------------------------------------------------------------
      
      

 
  
  }//------------------------------------
  //-----