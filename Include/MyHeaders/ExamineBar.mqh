//+------------------------------------------------------------------+
//|                                                   ExamineBar.mqh |
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property link      "https://www.mql5.com"
#property strict
class ExamineBar
{
  public:
   ExamineBar(int _barno, Pattern* _pattern);
   int barno;
   Pattern* pattern;
   
   int number_of_hits,c1_higher_cnt;
   double ave_c1;
   
   void log_to_file(int file_handle);

};
ExamineBar::ExamineBar(int _barno, Pattern* _pattern)
{
   barno=_barno; pattern=_pattern;
   number_of_hits=0;c1_higher_cnt=0;
   ave_c1=0;
}


void ExamineBar::log_to_file(int file_handle)
{  //TODO
}
