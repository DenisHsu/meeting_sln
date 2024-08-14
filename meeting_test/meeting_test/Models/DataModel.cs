namespace meeting_test.Models
{
    public class CompanyData
    {
        public int CompanyID { get; set; }             
        public string CompanyCode { get; set; }           
        public string CompanyName { get; set; }           
        public string Industry { get; set; }            

        public string DataMonth { get; set; }            
        public double RevenueCurrentMonth { get; set; }   
        public double RevenueLastMonth { get; set; }      
        public double RevenueSameMonthLastYear { get; set; } 
        public double RevenueChangeLastMonth { get; set; }   
        public double RevenueChangeLastYear { get; set; }    
        public double CumulativeRevenueCurrentYear { get; set; } 
        public double CumulativeRevenueLastYear { get; set; }    
        public double CumulativeRevenueChange { get; set; }      
        public string Remarks { get; set; }                

        // Report 相關字段
        public string ReportDate { get; set; }          
    }
}
