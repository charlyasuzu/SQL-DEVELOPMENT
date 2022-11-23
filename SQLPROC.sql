CREATE PROC PayRateIncrease @EmpID int, @percent float
AS
BEGIN
DECLARE @maxRate float
DECLARE @RevisedRate float
DECLARE @PayFre int
IF EXISTS (SELECT * 
FROM HumanResources.EmployeePayHistory
WHERE DATEDIFF (MM, RateChangeDate, GETDATE()) > 6 AND BusinessEntityID = @EmpID)
BEGIN 
SELECT @maxRate = Rate
FROM HumanResources.EmployeePayHistory
WHERE BusinessEntityID = @EmpID
IF (@maxRate * @percent > 200.00)
BEGIN 
PRINT 'Rate of any employee cannot be greater than 200'
END
ELSE
BEGIN 
SELECT @RevisedRate = Rate, @PayFre = PayFrequency
FROM HumanResources.EmployeePayHistory
WHERE BusinessEntityID = @EmpID
SET @RevisedRate = @RevisedRate + (@RevisedRate*@percent/100)
INSERT INTO HumanResources.EmployeePayHistory
VALUES (@EmpID,GETDATE(), @RevisedRate, @PayFre,GETDATE())
END
END
END

EXEC PayRateIncrease 6,2

SELECT * FROM HumanResources.EmployeePayHistory
WHERE BusinessEntityID = 6 
ORDER BY 
ModifiedDate Desc