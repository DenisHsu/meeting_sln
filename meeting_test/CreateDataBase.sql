CREATE TABLE Company (
    CompanyID INT PRIMARY KEY IDENTITY(1,1),  -- 自動增量的公司ID
    CompanyCode VARCHAR(10) UNIQUE,           -- 公司代號
    CompanyName VARCHAR(50),                  -- 公司名稱
    Industry VARCHAR(50)                      -- 產業別
);
CREATE TABLE MonthlyRevenue (
    RevenueID INT PRIMARY KEY IDENTITY(1,1),  -- 自動增量的營收ID
    CompanyID INT,                            -- 來自公司表的外鍵
    DataMonth VARCHAR(6),                     -- 資料年月
    RevenueCurrentMonth FLOAT,                -- 當月營收
    RevenueLastMonth FLOAT,                   -- 上月營收
    RevenueSameMonthLastYear FLOAT,           -- 去年同月營收
    RevenueChangeLastMonth FLOAT,             -- 上月比較增減(%)
    RevenueChangeLastYear FLOAT,              -- 去年同月增減(%)
    CumulativeRevenueCurrentYear FLOAT,       -- 當月累計營收
    CumulativeRevenueLastYear FLOAT,          -- 去年累計營收
    CumulativeRevenueChange FLOAT,            -- 前期比較增減(%)
    Remarks TEXT,                             -- 備註
    CONSTRAINT FK_CompanyID FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);
GO
CREATE TABLE Report (
    ReportID INT PRIMARY KEY IDENTITY(1,1),  -- 自動增量的報告ID
    ReportDate VARCHAR(10),                  -- 出表日期
    RevenueID INT,                           -- 來自月營收表的外鍵
    CONSTRAINT FK_RevenueID FOREIGN KEY (RevenueID) REFERENCES MonthlyRevenue(RevenueID)
);
GO

-------------------------------------------
CREATE PROCEDURE InsertCompany
    @CompanyCode VARCHAR(10),
    @CompanyName VARCHAR(50),
    @Industry VARCHAR(50)
AS
BEGIN
    INSERT INTO Company (CompanyCode, CompanyName, Industry)
    VALUES (@CompanyCode, @CompanyName, @Industry);
END;
GO
CREATE PROCEDURE InsertMonthlyRevenue
    @CompanyCode VARCHAR(10),
    @DataMonth VARCHAR(6),
    @RevenueCurrentMonth FLOAT,
    @RevenueLastMonth FLOAT,
    @RevenueSameMonthLastYear FLOAT,
    @RevenueChangeLastMonth FLOAT,
    @RevenueChangeLastYear FLOAT,
    @CumulativeRevenueCurrentYear FLOAT,
    @CumulativeRevenueLastYear FLOAT,
    @CumulativeRevenueChange FLOAT,
    @Remarks TEXT
AS
BEGIN
    DECLARE @CompanyID INT;    
    SELECT @CompanyID = CompanyID FROM Company WHERE CompanyCode = @CompanyCode;

    INSERT INTO MonthlyRevenue (
        CompanyID, DataMonth, RevenueCurrentMonth, RevenueLastMonth,
        RevenueSameMonthLastYear, RevenueChangeLastMonth, RevenueChangeLastYear,
        CumulativeRevenueCurrentYear, CumulativeRevenueLastYear, CumulativeRevenueChange, Remarks
    )
    VALUES (
        @CompanyID, @DataMonth, @RevenueCurrentMonth, @RevenueLastMonth,
        @RevenueSameMonthLastYear, @RevenueChangeLastMonth, @RevenueChangeLastYear,
        @CumulativeRevenueCurrentYear, @CumulativeRevenueLastYear, @CumulativeRevenueChange, @Remarks
    );
END;
GO
CREATE PROCEDURE InsertReport
    @ReportDate VARCHAR(10),
    @CompanyCode VARCHAR(10),
    @DataMonth VARCHAR(6)
AS
BEGIN
    DECLARE @RevenueID INT;
    SELECT @RevenueID = RevenueID FROM MonthlyRevenue
    WHERE CompanyID = (SELECT CompanyID FROM Company WHERE CompanyCode = @CompanyCode) AND DataMonth = @DataMonth;

    INSERT INTO Report (ReportDate, RevenueID)
    VALUES (@ReportDate, @RevenueID);
END;
GO

CREATE PROCEDURE SelectCompanyRevenue
    @CompanyCode VARCHAR(10),
    @DataMonth VARCHAR(6)
AS
BEGIN
    SELECT 
		C.CompanyID,
		C.CompanyCode,
        C.CompanyName, 
        C.Industry,
        R.ReportDate,
        M.DataMonth,
        M.RevenueCurrentMonth,
        M.RevenueLastMonth,
        M.RevenueSameMonthLastYear,
        M.RevenueChangeLastMonth,
        M.RevenueChangeLastYear,
        M.CumulativeRevenueCurrentYear,
        M.CumulativeRevenueLastYear,
        M.CumulativeRevenueChange,
        M.Remarks
    FROM 
        Company C
    JOIN 
        MonthlyRevenue M ON C.CompanyID = M.CompanyID
    JOIN 
        Report R ON M.RevenueID = R.RevenueID
    WHERE 
        C.CompanyCode = @CompanyCode AND M.DataMonth = @DataMonth;
END;