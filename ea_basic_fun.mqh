//+------------------------------------------------------------------+
//|                                                 ea_basic_fun.mq4 |
//|                              Copyright 2013, david2wang 基本函数 |
//|                                       http://www.wangzhengjun.cn |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, david2wang 基本函数"
#property link      "http://www.wangzhengjun.cn"
/*


*/
int Print_dt()
{
   Print("2012-3-3");

}


void drawsome(int i)
{
  string str_obj_name;
   str_obj_name="obj_"+iTime(NULL,0,i);
   if(ObjectFind(str_obj_name)==-1)
   {
      ObjectCreate(str_obj_name, OBJ_ARROW, 0, iTime(NULL,0,i), iHigh(NULL,0,i)+2);
      ObjectSet(str_obj_name, OBJPROP_ARROWCODE, 241);
     ObjectSet(str_obj_name, OBJPROP_COLOR, White);

   }
}
void drawsome1(int i)
{
  string str_obj_name;
   str_obj_name="obj_"+iTime(NULL,0,i);
   if(ObjectFind(str_obj_name)==-1)
   {
      ObjectCreate(str_obj_name, OBJ_ARROW, 0, iTime(NULL,0,i), iHigh(NULL,0,i)+2);
      ObjectSet(str_obj_name, OBJPROP_ARROWCODE, 81);
      ObjectSet(str_obj_name, OBJPROP_COLOR, White);
   }
}

void drawany(int i)
{
  string str_obj_name;
   str_obj_name="obj_"+iTime(NULL,0,i);
   if(ObjectFind(str_obj_name)==-1)
   {
      ObjectCreate(str_obj_name, OBJ_ARROW, 0, iTime(NULL,0,i), iLow(NULL,0,i)-22);
      ObjectSet(str_obj_name, OBJPROP_ARROWCODE, 241);
     ObjectSet(str_obj_name, OBJPROP_COLOR, White);

   }
}
void drawany1(int i)
{
  string str_obj_name;
   str_obj_name="obj_"+iTime(NULL,0,i);
   if(ObjectFind(str_obj_name)==-1)
   {
      ObjectCreate(str_obj_name, OBJ_ARROW, 0, iTime(NULL,0,i), iLow(NULL,0,i)-2);
      ObjectSet(str_obj_name, OBJPROP_ARROWCODE, 81);
      ObjectSet(str_obj_name, OBJPROP_COLOR, White);
   }
}