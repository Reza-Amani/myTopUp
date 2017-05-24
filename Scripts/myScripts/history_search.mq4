//+------------------------------------------------------------------+
//|                                               history_search.mq4 |
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs

#include <MyHeaders\MyMath.mqh>
#include <MyHeaders\Pattern.mqh>
#include <MyHeaders\ExamineBar.mqh>
#include <MyHeaders\Screen.mqh>
#include <MyHeaders\Tools.mqh>
input int      pattern_len=12;
input int      correlation_thresh=94;
input int      hit_threshold=60;
input int      min_hit=20;
input int      max_hit=100;
input ConcludeCriterion criterion=USE_HC1;
input int      back_search_len=2000;
input int      history=4000;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   Screen screen;
   screen.add_L1_comment("script started-");
   int outfilehandle=FileOpen("./trydata/go_through_history_"+Symbol()+EnumToString(ENUM_TIMEFRAMES(_Period))+"_"+IntegerToString(pattern_len)+"_"+IntegerToString(correlation_thresh)+".csv",FILE_WRITE|FILE_CSV,',');
   if(outfilehandle<0)
     {
      screen.add_L1_comment("file error");
      Print("Failed to open the file");
      Print("Error code ",GetLastError());
      return;
     }
   screen.add_L1_comment("file ok-");
   int history_size=(int)MyMath::min(Bars,history);
   screen.add_L1_comment("CalculatingBars:"+IntegerToString(history_size)+"-");

   Pattern* p_pattern;
   ExamineBar* p_bar;
   Pattern moving_pattern;
      
   int output_counter=0;
   for(int _ref=10;_ref<history_size-back_search_len;_ref++)
   {
      p_pattern=new Pattern(Close,_ref,pattern_len,Close[_ref-1]);
      
      p_bar=new ExamineBar(_ref,p_pattern);
     
      for(int j=10;j<back_search_len-pattern_len;j++)
      {
         moving_pattern.set_data(Close,j,pattern_len,Close[j-1]);
         if(p_bar.check_another_bar(moving_pattern,correlation_thresh,max_hit))
            break;
      }
//      if(p_bar.number_of_hits>=min_hit)
      if(p_bar.conclude(criterion,min_hit,hit_threshold))
      {  //a famous bar!
         p_bar.log_to_file(outfilehandle);
         output_counter++;
      }
      
      screen.clear_L2_comment();
      screen.add_L2_comment("output:"+IntegerToString(output_counter));
      screen.clear_L3_comment();
      screen.add_L3_comment("counter:"+IntegerToString(_ref));
            
      
      delete p_bar;
      delete p_pattern;
   }

}
//+------------------------------------------------------------------+
