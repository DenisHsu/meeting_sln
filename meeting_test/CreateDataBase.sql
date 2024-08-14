CREATE TABLE Company (
    CompanyID INT PRIMARY KEY IDENTITY(1,1),  -- �۰ʼW�q�����qID
    CompanyCode VARCHAR(10) UNIQUE,           -- ���q�N��
    CompanyName VARCHAR(50),                  -- ���q�W��
    Industry VARCHAR(50)                      -- ���~�O
);
CREATE TABLE MonthlyRevenue (
    RevenueID INT PRIMARY KEY IDENTITY(1,1),  -- �۰ʼW�q���禬ID
    CompanyID INT,                            -- �Ӧۤ��q���~��
    DataMonth VARCHAR(6),                     -- ��Ʀ~��
    RevenueCurrentMonth FLOAT,                -- ����禬
    RevenueLastMonth FLOAT,                   -- �W���禬
    RevenueSameMonthLastYear FLOAT,           -- �h�~�P���禬
    RevenueChangeLastMonth FLOAT,             -- �W�����W��(%)
    RevenueChangeLastYear FLOAT,              -- �h�~�P��W��(%)
    CumulativeRevenueCurrentYear FLOAT,       -- ���֭p�禬
    CumulativeRevenueLastYear FLOAT,          -- �h�~�֭p�禬
    CumulativeRevenueChange FLOAT,            -- �e������W��(%)
    Remarks TEXT,                             -- �Ƶ�
    CONSTRAINT FK_CompanyID FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);
GO
CREATE TABLE Report (
    ReportID INT PRIMARY KEY IDENTITY(1,1),  -- �۰ʼW�q�����iID
    ReportDate VARCHAR(10),                  -- �X����
    RevenueID INT,                           -- �Ӧۤ��禬���~��
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