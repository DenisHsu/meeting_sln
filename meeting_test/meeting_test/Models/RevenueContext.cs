using Microsoft.EntityFrameworkCore;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace meeting_test.Models
{
    public class RevenueContext : DbContext
    {
        public RevenueContext(DbContextOptions<RevenueContext> options) : base(options) { }
        public DbSet<Company> Companies { get; set; }
        public DbSet<MonthlyRevenue> MonthlyRevenues { get; set; }
        public DbSet<Report> Reports { get; set; }
    }
    public class Company
    {
        public int CompanyID { get; set; }
        public string CompanyCode { get; set; }
        public string CompanyName { get; set; }
        public string Industry { get; set; }
    }

    public class MonthlyRevenue
    {
        public int RevenueID { get; set; }
        public int CompanyID { get; set; }
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

        public Company Company { get; set; }
    }

    public class Report
    {
        public int ReportID { get; set; }
        public string ReportDate { get; set; }
        public int RevenueID { get; set; }

        public MonthlyRevenue MonthlyRevenue { get; set; }
    }
}
