//+------------------------------------------------------------------+
//|                                                   ExamineBar.mqh |
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property link      "https://www.mql5.com"
#property strict

#include <MyHeaders\Pattern.mqh>

#define MAX_AC1   2

enum ConcludeCriterion
{
   USE_HC1,
   USE_aveC1,
   USE_HC1aveC1
};
class ExamineBar
{
  public:
   ExamineBar(int _barno, Pattern* _pattern);
   int barno;
   Pattern* pattern;

   int number_of_hits;
   int success_rate;
   double sum_ac1;
   double higher_c1;
   int direction;
   
   void log_to_file_common(int file_handle);
   void log_to_file_tester(int file_handle);
   bool check_another_bar(Pattern &_check_pattern, int _correlation_thresh, int _max_hit);
   bool conclude(ConcludeCriterion _criterion, int _min_hits, int _thresh_hC, double _thresh_aC);

};
ExamineBar::ExamineBar(int _barno, Pattern* _pattern)
{
   barno=_barno; pattern=_pattern;
   number_of_hits=0;
   sum_ac1=0;
   higher_c1=0;
   success_rate=0;
   direction=0;
}

void ExamineBar::log_to_file_common(int file_handle)
{
   cont;
   FileWrite(file_handle,"","Bar",barno);
   cont;
   FileWrite(file_handle,"","hits",number_of_hits);
   cont;
   if(number_of_hits!=0)
      FileWrite(file_handle,"","aveaC1",sum_ac1/number_of_hits);
   cont;
   if(number_of_hits!=0)
      FileWrite(file_handle,"","higherC1",higher_c1,higher_c1/number_of_hits);
   cont;
   if(number_of_hits!=0)
      FileWrite(file_handle,"","SR&direction",success_rate,direction);
   cont;
   pattern.log_to_file(file_handle);

}

void ExamineBar::log_to_file_tester(int file_handle)
{
   if(number_of_hits!=0)
      FileWrite(file_handle,"","dC1-ac1-nextdir",pattern.fc1-pattern.close[0],pattern.ac1,(pattern.ac1>0)?1:-1);
   cont;
   if(number_of_hits!=0)
      FileWrite(file_handle,"","Normalised Result-dC1-aC1-dir",direction*(pattern.fc1-pattern.close[0]),direction*pattern.ac1,direction*((pattern.ac1>0)?1:-1));

}

bool ExamineBar::check_another_bar(Pattern &_check_pattern, int _correlation_thresh, int _max_hit)
{  //returns true, if the number of matches is above 100
   if((pattern & _check_pattern) >= _correlation_thresh)
   {  //found a match!
      number_of_hits++;
      sum_ac1+=MyMath::cap(_check_pattern.ac1,MAX_AC1,-MAX_AC1);
      if(_check_pattern.fc1>_check_pattern.close[0])
         higher_c1++;

   }
   return (number_of_hits>=_max_hit);
}

bool ExamineBar::conclude(ConcludeCriterion _criterion, int _min_hits, int _thresh_hC, double _thresh_aC)
{
   if(number_of_hits<_min_hits)
      return false;
   double temp;
   switch(_criterion)
   {
      case USE_HC1:
         success_rate = (int)(100*higher_c1/number_of_hits);
         if( success_rate >= _thresh_hC )
         {
            direction=1;
            return true;
         }
         if( success_rate < 100-_thresh_hC )
         {
            direction=-1;
            success_rate=100-success_rate;
            return true;
         }
         
         break;
      case USE_aveC1:
         success_rate = (sum_ac1/number_of_hits);
         if( success_rate >= _thresh_aC )
         {
            direction=1;
            return true;
         }
         if( success_rate < -_thresh_aC )
         {
            success_rate=-success_rate;
            direction=-1;
            return true;
         }
         break;
      case USE_HC1aveC1:
         break;

   }
   return false;
}
