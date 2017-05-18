//+------------------------------------------------------------------+
//|                                                      Pattern.mqh |
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property link      "https://www.mql5.com"
#property strict

#define cont    FileSeek(file_handle,-2,SEEK_CUR)

class Pattern
{
  public:
   Pattern();
   Pattern(const double &_src[],int _src_start, int _size);
   int size;
   double close[];
   double absolute_diffs;
   void set_data(const double &_src[],int _src_start, int _size);
   void log_to_file(int file_handle);
   int operator&(const Pattern &p2)const;
  private:
   double calculate_absolute_diff();
};
int Pattern::operator&(const Pattern &p2)const
{  //TODO
   return 1;
}
double Pattern::calculate_absolute_diff()
{  
   double result=0;
   for(int i=0;i<size-1;i++)
   {
      result+=MathAbs(close[i]-close[i+1]);
   }
   result/=(size-1);
   return result;
}
void Pattern::log_to_file(int file_handle)
{
   FileWrite(file_handle,"close");
   for(int i=0;i<size;i++)
   {
      cont;
      FileWrite(file_handle,"",close[i]);
   }  
   cont;
   FileWrite(file_handle,"","diff",absolute_diffs);
}
Pattern::Pattern(const double &_src[],int _src_start,int _size)
{
   size = _size;
   ArrayResize(close,size);
   ArrayCopy(close,_src,0,_src_start,size);
   absolute_diffs = calculate_absolute_diff();
}
Pattern::Pattern(void)
{
}
void Pattern::set_data(const double &_src[],int _src_start, int _size)
{
   size = _size;
   ArrayResize(close,size);
   ArrayCopy(close,_src,0,_src_start,size);
   absolute_diffs = calculate_absolute_diff();
}
