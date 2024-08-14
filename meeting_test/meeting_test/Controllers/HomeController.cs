using meeting_test.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;


namespace meeting_test.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HomeController : ControllerBase
    {
        private readonly RevenueContext _context;
        private readonly IConfiguration _configuration;

        public HomeController(RevenueContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        [HttpGet("{companyCode}/{dataMonth}")]
        public async Task<IActionResult> GetCompany(string companyCode, string dataMonth)
        {
            if (string.IsNullOrEmpty(companyCode) || string.IsNullOrEmpty(dataMonth))
            {
                return BadRequest("Invalid input parameters.");
            }

            CompanyData company = new CompanyData();

            using (var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnectionString")))
            {
                await connection.OpenAsync();

                using (var command = new SqlCommand("SelectCompanyRevenue", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@CompanyCode", companyCode);
                    command.Parameters.AddWithValue("@DataMonth", dataMonth);

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        if (reader.HasRows)
                        {
                            while (await reader.ReadAsync())
                            {
                                company = new CompanyData
                                {
                                    CompanyID = reader.GetInt32(reader.GetOrdinal("CompanyID")),
                                    CompanyCode = reader.GetString(reader.GetOrdinal("CompanyCode")),
                                    CompanyName = reader.GetString(reader.GetOrdinal("CompanyName")),
                                    Industry = reader.GetString(reader.GetOrdinal("Industry")),
                                    DataMonth = reader.GetString(reader.GetOrdinal("DataMonth")),
                                    RevenueCurrentMonth = reader.GetDouble(reader.GetOrdinal("RevenueCurrentMonth")),
                                    RevenueLastMonth = reader.GetDouble(reader.GetOrdinal("RevenueLastMonth")),
                                    RevenueSameMonthLastYear = reader.GetDouble(reader.GetOrdinal("RevenueSameMonthLastYear")),
                                    RevenueChangeLastMonth = reader.GetDouble(reader.GetOrdinal("RevenueChangeLastMonth")),
                                    RevenueChangeLastYear = reader.GetDouble(reader.GetOrdinal("RevenueChangeLastYear")),
                                    CumulativeRevenueCurrentYear = reader.GetDouble(reader.GetOrdinal("CumulativeRevenueCurrentYear")),
                                    CumulativeRevenueLastYear = reader.GetDouble(reader.GetOrdinal("CumulativeRevenueLastYear")),
                                    CumulativeRevenueChange = reader.GetDouble(reader.GetOrdinal("CumulativeRevenueChange")),
                                    Remarks = reader.GetString(reader.GetOrdinal("Remarks")),
                                    ReportDate = reader.GetString(reader.GetOrdinal("ReportDate"))
                                };
                            }
                        }
                    }
                }
            }

            if (company == null)
            {
                return NotFound("Company not found.");
            }

            return Ok(company);
        }
        [HttpPost]
        public async Task<IActionResult> PostCompany([FromBody] CompanyData company)
        {
            if (company == null)
            {
                return BadRequest();
            }

            using (var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnectionString")))
            {
                await connection.OpenAsync();

                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        using (var command = new SqlCommand("InsertCompany", connection, transaction))
                        {
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.AddWithValue("@CompanyCode", company.CompanyCode);
                            command.Parameters.AddWithValue("@CompanyName", company.CompanyName);
                            command.Parameters.AddWithValue("@Industry", company.Industry);

                            await command.ExecuteNonQueryAsync();
                        }

                        using (var command = new SqlCommand("InsertMonthlyRevenue", connection, transaction))
                        {
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.AddWithValue("@CompanyCode", company.CompanyCode);
                            command.Parameters.AddWithValue("@DataMonth", company.DataMonth);
                            command.Parameters.AddWithValue("@RevenueCurrentMonth", company.RevenueCurrentMonth);
                            command.Parameters.AddWithValue("@RevenueLastMonth", company.RevenueLastMonth);
                            command.Parameters.AddWithValue("@RevenueSameMonthLastYear", company.RevenueSameMonthLastYear);
                            command.Parameters.AddWithValue("@RevenueChangeLastMonth", company.RevenueChangeLastMonth);
                            command.Parameters.AddWithValue("@RevenueChangeLastYear", company.RevenueChangeLastYear);
                            command.Parameters.AddWithValue("@CumulativeRevenueCurrentYear", company.CumulativeRevenueCurrentYear);
                            command.Parameters.AddWithValue("@CumulativeRevenueLastYear", company.CumulativeRevenueLastYear);
                            command.Parameters.AddWithValue("@CumulativeRevenueChange", company.CumulativeRevenueChange);
                            command.Parameters.AddWithValue("@Remarks", company.Remarks);

                            await command.ExecuteNonQueryAsync();
                        }

                        using (var command = new SqlCommand("InsertReport", connection, transaction))
                        {
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.AddWithValue("@ReportDate", company.ReportDate);
                            command.Parameters.AddWithValue("@CompanyCode", company.CompanyCode);
                            command.Parameters.AddWithValue("@DataMonth", company.DataMonth);

                            await command.ExecuteNonQueryAsync();
                        }

                        transaction.Commit();

                        return Ok();
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        return StatusCode(500, $"Internal server error: {ex.Message}");
                    }
                }
            }
        }
    }
}
