--Sherissa Pinnock
--Advanced Databases Project


CREATE TABLE marketing_list(
    id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    DOB DATE,
    gender CHAR(1), -- Assuming 'M' for Male, 'F' for Female, or other appropriate values
    parish VARCHAR(255),
    mobile VARCHAR(15), -- Assuming a reasonable length for mobile numbers
    mobile_provider VARCHAR(50) CHECK (mobile_provider IN ('Digicel', 'Lime', 'Claro'))
);


-- Insert 10 records into marketing_list table
INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
VALUES
    (1, 'John', 'Doe', '1990-01-01', 'M', 'Kingston', '780-1111', 'Digicel'),
    (2, 'Jane', 'Smith', '1985-02-15', 'F', 'St. Andrew', '678-2222', 'Lime'),
    (3, 'Bob', 'Johnson', '1992-05-20', 'M', 'St. James', '997-3333', 'Claro'),
    (4, 'Alice', 'Williams', '1988-07-10', 'F', 'Manchester', '654-4444', 'Digicel'),
    (5, 'Charlie', 'Brown', '1995-09-05', 'M', 'Clarendon', '453-5555', 'Lime'),
    (6, 'Eva', 'Miller', '1983-11-12', 'F', 'St. Catherine', '321-6666', 'Claro'),
    (7, 'David', 'Davis', '1998-03-25', 'M', 'Westmoreland', '555-9777', 'Digicel'),
    (8, 'Sophie', 'Taylor', '1982-04-30', 'F', 'St. Ann', '575-8888', 'Lime'),
    (9, 'George', 'White', '1993-06-18', 'M', 'Trelawny', '535-9999', 'Claro'),
    (10, 'Olivia', 'Anderson', '1987-08-22', 'F', 'Portland', '560-0000', 'Digicel');

	select * from marketing_list;

	--How many customers does each mobile provider have?
	SELECT
    mobile_provider,
		COUNT(*) AS customer_count
	FROM
		marketing_list
	GROUP BY
		mobile_provider;

	--Count all males in St. Mary
	SELECT
		COUNT(*) AS male_count_in_st_mary
	FROM
		marketing_list
	WHERE
		gender = 'M'
		AND parish = 'St. Mary';

	--Delete all males who live in St.Mary
	DELETE FROM
    marketing_list
	WHERE
		gender = 'M'
		AND parish = 'St. Mary';
	
	--Show data for all males living in St. Mary
	SELECT *
	FROM
		marketing_list
	WHERE
		gender = 'M'
		AND parish = 'St. Mary';


--CREATING PROCEDURES
CREATE PROCEDURE sp_exmp1
AS
BEGIN
    -- How many customers does each mobile provider have?
    SELECT
        mobile_provider,
        COUNT(*) AS customer_count
    FROM
        marketing_list
    GROUP BY
        mobile_provider;

    -- Count all males who live in St. Mary:
    SELECT
        COUNT(*) AS male_count_in_st_mary
    FROM
        marketing_list
    WHERE
        gender = 'M'
        AND parish = 'St. Mary';

    -- Delete all male customers who live in St. Mary:
    DELETE FROM
        marketing_list
    WHERE
        gender = 'M'
        AND parish = 'St. Mary';

    -- Show data for all males who live in St. Mary:
    SELECT
        id,
        first_name,
        last_name,
        DOB,
        gender,
        parish,
        mobile,
        mobile_provider
    FROM
        marketing_list
    WHERE
        gender = 'M'
        AND parish = 'St. Mary';
END;

Execute sp_exmp1;


/*Count all female customers, count all male customers, count all customers in the various parishes,
delete all customers over 65*/ 
CREATE PROCEDURE sp_exmp2
AS
BEGIN
    -- Count all female customers
    SELECT
        COUNT(*) AS female_customer_count
    FROM
        marketing_list
    WHERE
        gender = 'F';

    -- Count all male customers
    SELECT
        COUNT(*) AS male_customer_count
    FROM
        marketing_list
    WHERE
        gender = 'M';

    -- Give a count of customers in the various parishes
    SELECT
        parish,
        COUNT(*) AS customer_count_per_parish
    FROM
        marketing_list
    GROUP BY
        parish;

    -- Delete all customers over 65
    DELETE FROM
        marketing_list
    WHERE
        DATEDIFF(YEAR, DOB, GETDATE()) > 65;
END;

EXEC sp_exmp2;

--MODIFYING PROCEDURES
--Add an sql statement to count the number of persons over 65 before you delete them
ALTER PROCEDURE sp_exmp2
AS
BEGIN
    -- Count all female customers
    SELECT
        COUNT(*) AS female_customer_count
    FROM
        marketing_list
    WHERE
        gender = 'F';

    -- Count all male customers
    SELECT
        COUNT(*) AS male_customer_count
    FROM
        marketing_list
    WHERE
        gender = 'M';

    -- Give a count of customers in the various parishes
    SELECT
        parish,
        COUNT(*) AS customer_count_per_parish
    FROM
        marketing_list
    GROUP BY
        parish;

    -- Count and delete customers over 65
    DECLARE @countOver65 INT;
    SELECT
        @countOver65 = COUNT(*)
    FROM
        marketing_list
    WHERE
        DATEDIFF(YEAR, DOB, GETDATE()) > 65;

    -- Output the count
    SELECT
        @countOver65 AS count_over_65;

    -- Delete all customers over 65
    DELETE FROM
        marketing_list
    WHERE
        DATEDIFF(YEAR, DOB, GETDATE()) > 65;
END;

EXECUTE sp_exmp2;




--Creating stored procedures with Input Parameters-----
/*Create a stored procedure with input parameters that will be used to insert records into the
customer list table.*/
CREATE PROCEDURE sp_InsertMarketingList
	@id INT,
    @first_name VARCHAR(255),
    @last_name VARCHAR(255),
    @DOB DATE,
    @gender CHAR(1),
    @parish VARCHAR(255),
    @mobile VARCHAR(15),
    @mobile_provider VARCHAR(50)
AS
BEGIN
    INSERT INTO dbo.marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
    VALUES (@id, @first_name, @last_name, @DOB, @gender, @parish, @mobile, @mobile_provider);
END;
GO
 
EXEC sp_InsertMarketingList
	@id=11,
    @first_name = 'Alice',
    @last_name = 'Johnson',
    @DOB = '1995-03-15',
    @gender = 'F',
    @parish = 'St. James',
    @mobile = '555-5678',
    @mobile_provider = 'Lime';

Select *from marketing_list;

/*b) Create a stored procedure that will find and display a record when supplied with someone’s ID
number*/
CREATE PROCEDURE sp_FindRecordByID
    @id INT
AS
BEGIN
    SELECT
        *
    FROM
        dbo.marketing_list
    WHERE
        id = @id;
END;
GO

EXEC sp_FindRecordByID @id=6;

/*c) Create a stored procedure that will update someone’s first name and last name based on an ID
that is supplied. The stored procedure should first display the person’s record and the display the
person’s record after the update.*/
CREATE PROCEDURE sp_UpdateNameByID
    @id INT,
    @new_first_name VARCHAR(255),
    @new_last_name VARCHAR(255)
AS
BEGIN
    -- Display the customer's record before the update
    PRINT 'Record Before Update:';
    SELECT  * FROM dbo.marketing_list WHERE id = @id;
    -- Update the first name and last name
    UPDATE
        dbo.marketing_list
    SET
        first_name = @new_first_name,
        last_name = @new_last_name
    WHERE
        id = @id;

    -- Display the customer's record after the update
    PRINT 'Record After Update:';
    SELECT *FROM dbo.marketing_list WHERE id = @id;
END;
GO

EXEC sp_UpdateNameByID @id=6, @new_first_name= 'Emily', @new_last_name='Myers'; 

--d) Develop a stored procedure that delete’s a record based on someone’s ID number.
CREATE PROCEDURE sp_DeleteById
	(
	@id Int
	)	
AS
BEGIN
	Delete from marketing_list where id=@id; 
END;
GO

EXEC sp_DeleteById @id=7;
Select * from marketing_list;

/*e) Create another stored procedure for part d) that displays the customer list before and after the
person is deleted.*/
CREATE PROCEDURE sp_DeleteByIdBeforeandAfter
		(
		@id Int
		)	
	AS
	BEGIN
	 -- Display the person's record before the deletion
    PRINT 'Record Before Update:';
    SELECT*FROM dbo.marketing_list WHERE id = @id;

	--Deleting the record
	Delete from marketing_list where id=@id; 

	 -- Display the person's record before the deletion
    PRINT 'Record After Update:';
    SELECT*FROM dbo.marketing_list WHERE id = @id;
	END;
	GO

EXEC sp_DeleteByIdBeforeandAfter @id=4;

/*f) Create a stored procedure that shows the number of persons in a parish based on the parish
supplied.*/
CREATE PROCEDURE sp_CountCustomerPerParish
(
	@parish VARCHAR(255)
)
AS
BEGIN
	SELECT
	 @parish AS parish,
        COUNT(*) AS customer_count_per_parish
	FROM
		marketing_list
	WHERE
	parish=@parish;
END;
GO

EXEC sp_CountCustomerPerParish @parish= 'St. Catherine';

--Exercise 2 – Creating and executing stored procedures with Return Parameters

--a) Count all female customers
CREATE PROCEDURE sp_CountFemaleCustomers
    @femaleCount INT OUTPUT
AS
BEGIN
    SELECT @femaleCount = COUNT(*)
    FROM marketing_list
    WHERE gender = 'F';

    -- Use RETURN to indicate the count
    RETURN @femaleCount;
END;
GO

DECLARE @FemaleCountResult INT;

-- Execute the stored procedure and capture the return value
SET @FemaleCountResult = (EXEC sp_CountFemaleCustomers @femaleCount OUTPUT);

-- Display the result
PRINT 'Number of Female Customers: ' + CAST(@FemaleCountResult AS VARCHAR(10));


--b) Count all male customers
CREATE PROCEDURE sp_CountMaleCustomers
    @maleCount INT OUTPUT
AS
BEGIN
    SELECT @maleCount = COUNT(*)
    FROM marketing_list
    WHERE gender = 'M';

    -- Use RETURN to indicate the count
    RETURN @maleCount;
END;
GO

DECLARE @MaleCountResult INT;

-- Execute the stored procedure and capture the return value
EXEC sp_CountMaleCustomers @MaleCountResult OUTPUT;

-- Display the result
PRINT 'Number of Male Customers: ' + CAST(@MaleCountResult AS VARCHAR(10));


--c) Count the number of customers belonging to a specific mobile provider
CREATE PROCEDURE sp_CountCustomersByMobileProvider
    @mobileProvider VARCHAR(50),
    @customerCount INT OUTPUT
AS
BEGIN
    SELECT @customerCount = COUNT(*)
    FROM marketing_list
    WHERE mobile_provider = @mobileProvider;

    -- Use RETURN to indicate the count
    RETURN @customerCount;
END;
GO

DECLARE @CustomerCountResult INT;

-- Execute the stored procedure and capture the return value
EXEC sp_CountCustomersByMobileProvider 'Digicel', @customerCount = @CustomerCountResult OUTPUT;

-- Display the result
PRINT 'Number of Customers for the Specific Mobile Provider: ' + CAST(@CustomerCountResult AS VARCHAR(10));

/*d) Create a procedure for Exercise 1 part b, place a return parameter at the end of the procedure that
to the count of the results returned. (Example select @count = count(*) from customer_list where
id=@id). Execute the two procedures one after the other; do you notice a difference between the
two?*/
CREATE PROCEDURE sp_GetRecordByIDWithCount
    @id INT,
    @count INT OUTPUT
AS
BEGIN
    -- Display the person's record
    SELECT
        *
    FROM
        dbo.marketing_list
    WHERE
        id = @id;

    -- Count the results and store in the output parameter
    SELECT
        @count = COUNT(*)
    FROM
        dbo.marketing_list
    WHERE
        id = @id;

    -- Use RETURN to indicate the count
    RETURN @count;
END;
GO

DECLARE @IDToSearch INT = 1; 
DECLARE @RecordCount INT;

-- Execute the first procedure to get and display the person's record
EXEC @RecordCount = sp_GetRecordByIDWithCount @id = @IDToSearch, @count = @RecordCount OUTPUT;

-- Display the result count
PRINT 'Number of Records Found: ' + CAST(@RecordCount AS VARCHAR(10));

-----Creating and executing stored procedures with Output Parameters
/*a) Create a stored procedure that get’s the first name and last name of a student based on their
provided ID number. Display the names of the student.*/
CREATE PROCEDURE sp_GetStudentNamesByID
    @id INT
AS
BEGIN
    -- Declare variables to store first name and last name
    DECLARE @firstName VARCHAR(255);
    DECLARE @lastName VARCHAR(255);

    -- Retrieve the first name and last name based on the provided ID
    SELECT
        @firstName = first_name,
        @lastName = last_name
    FROM
        marketing_list
    WHERE
        id= @id;

    -- Display the names
    PRINT 'First Name: ' + ISNULL(@firstName, 'Not Found');
    PRINT 'Last Name: ' + ISNULL(@lastName, 'Not Found');
END;
GO

DECLARE @CustomerIDToSearch INT = 1; 
EXEC sp_GetStudentNamesByID @id =  @CustomerIDToSearch;


--If statements
/*Create and execute a stored procedure with an input parameter for a date. Determine whether the
year was before the Y2K bug problem and print and appropriate message (Eg. Select ‘This date
was before’ ), otherwise print how many days the date missed the Y2K bug by.*/
CREATE PROCEDURE sp_CheckY2KBug
    @inputDate DATE
AS
BEGIN
    -- Extract the year from the input date
    DECLARE @year INT;
    SET @year = YEAR(@inputDate);

    -- Check if the year is before the Y2K bug problem
    IF @year < 2000
    BEGIN
        PRINT 'This date was before the Y2K bug.';
    END
    ELSE
    BEGIN
        -- Calculate the number of days the date missed the Y2K bug by
        DECLARE @daysMissed INT;
        SET @daysMissed = DATEDIFF(DAY, '1999-12-31', @inputDate);

        PRINT 'This date missed the Y2K bug by ' + CAST(@daysMissed AS VARCHAR(10)) + ' day(s).';
    END
END;
GO

DECLARE @DateToCheck DATE = '2001-01-01'; 
EXEC sp_CheckY2KBug @inputDate = @DateToCheck;

/*Create a stored procedure that will count the number of males in a parish and display a list if the
count is over 5, otherwise print a message ”the list is not long enough”.*/
CREATE PROCEDURE sp_CountAndDisplayMalesInParish
    @parishName VARCHAR(255)
AS
BEGIN
    -- Declare a variable to store the count of males
    DECLARE @maleCount INT;

    -- Count the number of males in the specified parish
    SELECT @maleCount = COUNT(*)
    FROM dbo.marketing_list
    WHERE parish = @parishName AND gender = 'M';

    -- Check if the count is over 5
    IF @maleCount > 5
    BEGIN
        -- Display a list of males in the parish
        PRINT 'List of Males in ' + @parishName + ':';
        SELECT
            first_name,
            last_name
        FROM dbo.marketing_list
        WHERE parish = @parishName AND gender = 'M';
    END
    ELSE
    BEGIN
        -- Print a message if the list is not long enough
        PRINT 'The list is not long enough.';
    END
END;
GO
DECLARE @ParishToCheck VARCHAR(255) = 'Manchester'; 
EXEC sp_CountAndDisplayMalesInParish @parishName = @ParishToCheck;

/*Create a stored procedure that will only insert a record if the parish it is associated with it has less
then 5 persons. (Insert persons with that parish until the limit is reached for testing purposes)*/
CREATE PROCEDURE sp_InsertRecordParishLessThan5
	@id INT,
    @first_name VARCHAR(255),
    @last_name VARCHAR(255),
    @DOB DATE,
    @gender CHAR(1),
    @parish VARCHAR(255),
    @mobile VARCHAR(15),
    @mobile_provider VARCHAR(50)
AS
BEGIN
	--Variable stores the parish count
	DECLARE @parishCount INT;

	--Count the people in the parish
	SELECT @parishCount = COUNT(*)
    FROM dbo.marketing_list
    WHERE parish = @parish;

	IF @parishCount<5
	BEGIN
		INSERT INTO dbo.marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
		VALUES (@id, @first_name, @last_name, @DOB, @gender, @parish, @mobile, @mobile_provider);
		PRINT 'Record Inserted'
	END
	ELSE
	BEGIN
	PRINT 'Parish is too full'
	END
END
GO

EXEC sp_InsertRecordParishLessThan5
	@id=13,
    @first_name = 'Leah',
    @last_name = 'Michelle',
    @DOB = '1985-04-15',
    @gender = 'F',
    @parish = 'Kingston',
    @mobile = '616-9678',
    @mobile_provider = 'Digicel';

--Using While Loops
/*a) Create a table called Age_Band with the following fields (Age – int , Age Band - varchar)*/
CREATE PROCEDURE sp_CreateAgeBandTable
    @resultMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    -- Check if the table already exists
    IF OBJECT_ID('Age_Band', 'U') IS NULL
    BEGIN
        -- Create the Age_Band table
        CREATE TABLE Age_Band (
            Age INT,
            Age_Band VARCHAR(255)
        );

        SET @resultMessage = 'Age_Band table created successfully.';
    END
    ELSE
    BEGIN
        SET @resultMessage = 'Age_Band table already exists.';
    END
END;
GO

/*b) Use a while loop to populate the table with all ages from 1 to 150.*/
CREATE PROCEDURE sp_PopulateAgeBandTable
    @resultMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    -- Check if the Age_Band table exists, if not, create it
    IF OBJECT_ID('Age_Band', 'U') IS NULL
    BEGIN
        CREATE TABLE Age_Band (
            Age INT,
            Age_Band VARCHAR(255)
        );
    END

    -- Clear existing data from the table
    DELETE FROM Age_Band;

    -- Initialize variables
    DECLARE @Age INT = 1;
    DECLARE @AgeBand VARCHAR(255);

    -- Use a WHILE loop to populate the table with ages from 1 to 150
    WHILE @Age <= 150
    BEGIN
        -- Determine Age Band based on the provided ranges
        IF @Age <= 17
            SET @AgeBand = 'Child';
        ELSE IF @Age BETWEEN 18 AND 25
            SET @AgeBand = 'Young Adult';
        ELSE IF @Age BETWEEN 26 AND 44
            SET @AgeBand = 'Adult';
        ELSE IF @Age BETWEEN 45 AND 64
            SET @AgeBand = 'Mature Adult';
        ELSE
            SET @AgeBand = 'Senior Citizen';

        -- Insert into the Age_Band table
        INSERT INTO Age_Band (Age, Age_Band)
        VALUES (@Age, @AgeBand);

        SET @Age = @Age + 1;
    END

    SET @resultMessage = 'Age_Band table populated successfully.';
END;
GO

 

DECLARE @ResultMessage NVARCHAR(255);
-- Execute the stored procedure and capture the return value
EXEC sp_PopulateAgeBandTable @resultMessage OUTPUT;
-- Display the result
PRINT @ResultMessage;

Select *from Age_Band;

/*c) Create a second table age_band_2. Use a while loop to populate the table with all ages from 1 to
150. Break the loop when it reaches 99 using the BREAK statement.
(Hint, you will need an If statement and probably variables)*/
CREATE PROCEDURE sp_PopulateAgeBand2Table
    @resultMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    -- Create the age_band_2 table
    CREATE TABLE age_band_2 (
        Age INT,
        Age_Band VARCHAR(255)
    );

    -- Initialize variables
    DECLARE @Age INT = 1;
    DECLARE @AgeBand VARCHAR(255);

    -- Use a WHILE loop to populate the table with ages from 1 to 150
    WHILE @Age <= 150
    BEGIN
        -- Break the loop when it reaches 99
        IF @Age = 100
            BREAK;

        -- Determine Age Band based on the provided ranges
        IF @Age <= 17
            SET @AgeBand = 'Child';
        ELSE IF @Age BETWEEN 18 AND 25
            SET @AgeBand = 'Young Adult';
        ELSE IF @Age BETWEEN 26 AND 44
            SET @AgeBand = 'Adult';
        ELSE IF @Age BETWEEN 45 AND 64
            SET @AgeBand = 'Mature Adult';
        ELSE
            SET @AgeBand = 'Senior Citizen';

        -- Insert into the age_band_2 table
        INSERT INTO age_band_2 (Age, Age_Band)
        VALUES (@Age, @AgeBand);

        SET @Age = @Age + 1;
    END

    SET @resultMessage = 'age_band_2 table populated successfully.';
END;
GO


--Case Statements
/*a) Write a query using simple case statement that will use a field called behavior_type that display
Masculine for all males in your marketing_list and Femine for all females. The statement should
include all other information about the customer.*/
SELECT
    *,
    CASE gender
        WHEN 'M' THEN 'Masculine'
        WHEN 'F' THEN 'Feminine'
        ELSE 'Unknown' -- Handle other cases if necessary
    END AS behavior_type
FROM
    marketing_list;

/*b) Re-Write 3a) using searched cases statements*/
SELECT
    *,
    CASE
        WHEN gender = 'M' THEN 'Masculine'
        WHEN gender = 'F' THEN 'Feminine'
        ELSE 'Unknown' -- Handle other cases if necessary
    END AS behavior_type
FROM
    marketing_list;

	
/*c) Use an Alter Table statement to modify the marketing list table, include the field marital Status.
Update some records to M (married), S (Single), D (Divorced) and U (Unknown)*/
-- Step 1: Add the 'marital_status' field to the 'marketing_list' table
ALTER TABLE marketing_list
ADD marital_status CHAR(1); 

-- Step 2: Update records with marital statuses using a CASE statement
UPDATE marketing_list
SET marital_status = 
    CASE 
        WHEN id=1 THEN 'M'
        WHEN id=4 THEN 'S'
        WHEN id=5 THEN 'D'
        ELSE 'U' -- 'Unknown' for records that don't match any specified condition
    END;

/*d) Write a query that using a case statement in the SELECT clause. The query should look
for all single persons and treat all persons that are Divorced and Unknown also as single.*/
SELECT
    first_name,
    last_name,
    
    CASE
        WHEN marital_status = 'S' OR marital_status = 'D' OR marital_status = 'U' THEN 'Single'
        ELSE 'Other'
    END AS relationship_status

FROM
    marketing_list;

/*******************************************************************/
----------------------LAB 4 BEGINS HERE-----------------------------
--Sherissa Pinnock
--2100762
/******************************************************************/

/*a) Create a scalar user defined function that will accept a date of birth and return the age a
person will be in 15 years from now. (HINT GETDATE, DATEADD, DATEDIFF)*/
CREATE FUNCTION Dbo.CalculateAgeIn15Years(@dateOfBirth date)
RETURNS INT
AS
BEGIN
DECLARE @futureDate DATE = DATEADD(YEAR, 15, GETDATE());
    DECLARE @age INT;

    SET @age = DATEDIFF(YEAR, @dateOfBirth, @futureDate);

    RETURN @age;
END;

--Testing
DECLARE @birthdate DATE = '2002-09-12';
DECLARE @futureAge INT;

SET @futureAge = Dbo.CalculateAgeIn15Years(@birthdate);

SELECT @futureAge AS 'Age in 15 Years';

/*b) Use the UDF created in part a) to show the age of all persons in your marketing_list
table along with their original information.*/
SELECT
    first_name,
    last_name,
    DOB,
    Dbo.CalculateAgeIn15Years(DOB) AS 'AgeAfter15Years'
FROM
    marketing_list;

/*Further filter part b) by introducing a WHERE clause that has the UDF as a part of it’s
criteria. The criteria should only allow persons over the age of 45 to be displayed.*/
SELECT
    first_name,
    last_name,
    DOB,
    Dbo.CalculateAgeIn15Years(DOB) AS 'AgeAfter15Years'
FROM
    marketing_list
WHERE
	Dbo.CalculateAgeIn15Years(DOB)>45; 

/*d) Create a new table called Employee (Employee_id, First_name, Last_name) and insert 3
records.*/

-- Create the Employee table
CREATE TABLE Employee (
    Employee_id INT PRIMARY KEY,
    First_name VARCHAR(50),
    Last_name VARCHAR(50)
);

-- Insert 3 records into the Employee table
INSERT INTO Employee (Employee_id, First_name, Last_name)
VALUES
    (1, 'Mike', 'Reid'),
    (2, 'Jane', 'Stevie'),
    (3, 'Kemona', 'Nelson');

-- Create the Campaign_Offer table
CREATE TABLE Campaign_Offer (
    offer_id INT PRIMARY KEY IDENTITY(1,1),
    offer_date DATE,
    customer_id INT,
    offer_value DECIMAL(10, 2),
    product_name VARCHAR(50),
    acceptance_status VARCHAR(3), -- Assuming 'yes' or 'no'
    Employee_id INT,
    FOREIGN KEY (customer_id) REFERENCES marketing_list(id),
    FOREIGN KEY (Employee_id) REFERENCES Employee(Employee_id) 
);

-- Insert offer records for each customer
INSERT INTO Campaign_Offer (offer_date, customer_id, offer_value, product_name, acceptance_status, Employee_id)
VALUES
    ('2023-01-01', 1, 50.00, 'Product_A', 'yes', 1), -- Accepted
    ('2023-01-02', 2, 30.00, 'Product_B', 'no', 2),  -- Not accepted
    ('2023-02-03', 5, 75.00, 'Product_C', 'yes', 3), -- Accepted
	('2023-09-05', 6, 75.00, 'Product_C', 'yes', 3),
	('2023-10-03', 8, 50.00, 'Product_A', 'no', 2),
	('2023-06-10', 9, 30.00, 'Product_B', 'yes', 1),
	('2023-12-03', 10, 30.00, 'Product_B', 'no', 3),
	('2023-08-07', 11, 50.00, 'Product_A', 'yes', 1),
	('2023-09-10', 12, 75.00, 'Product_C', 'yes', 3),
	('2023-10-03', 13, 75.00, 'Product_C', 'yes', 3);

-- Insert additional offers for different customers, products, and offer dates
INSERT INTO Campaign_Offer (offer_date, customer_id, offer_value, product_name, acceptance_status, Employee_id)
VALUES
    ('2023-01-04', 10, 40.00, 'Product_D', 'yes', 1),  -- Accepted
    ('2023-01-05', 5, 60.00, 'Product_E', 'no', 2),   -- Not accepted
    ('2023-01-06', 6, 25.00, 'Product_F', 'yes', 3),  -- Accepted
    ('2023-01-07', 11, 80.00,'Product_G', 'no', 2),   -- Not accepted
    ('2023-01-08', 8, 55.00, 'Product_H', 'yes', 1);  -- Accepted

	Select *from marketing_list;

/*e) Using a Scalar UDF, implement a business rule that states all offer values attract a 10%
commission. The UDF function should accept the offer value, calculate the commission
and return the commission fee that is to be paid to the employee.
Demonstrate the UDF by showing the commission that will be earned for each offer.*/
CREATE FUNCTION CalculateCommission(@offerValue DECIMAL (10, 2))
RETURNS DECIMAL (10, 2)
AS
BEGIN
DECLARE @commission DECIMAL (10, 2);
Set @commission= @offerValue*0.10;
RETURN @commission
END;

-- Show the commission for each offer
SELECT
    offer_id,
    offer_value,
    dbo.CalculateCommission(offer_value) AS commission_fee
FROM
    Campaign_Offer;

/*f) Develop a tabular UDF that does not accept any values and calculates the commission
for each employee_id. Commission can only be given if a customer accepts the offer.
(Hint Group By)*/
CREATE FUNCTION CalculateCommissionPerEmployee()
RETURNS TABLE
AS
RETURN
(
    SELECT
        Employee_id,
        SUM(CASE WHEN acceptance_status = 'yes' THEN offer_value * 0.10 ELSE 0 END) AS commission_earned
    FROM
        Campaign_Offer
    GROUP BY
        Employee_id
);

Select *from CalculateCommissionPerEmployee();

/*g) Use the UDF in f) in an inner join statement with the Employee table to show all the
details of an employee along with their total commission earned.*/
Select 
e.Employee_id,
e.First_name,
e.Last_name,
c.commission_earned
from Employee e
INNER JOIN
CalculateCommissionPerEmployee() c
ON c.Employee_id=e.Employee_id

/*h) Refine part f) by creating a new tabular UDF that accepts a start date and end date and
then shows the commission earned by each employee_IDs in that period. (Hint Group
By)*/
CREATE FUNCTION CalculateCommissionByDate (@startDate date, @endDate date)
RETURNS TABLE
AS
RETURN
(
	SELECT
        Employee_id,
        SUM(CASE WHEN acceptance_status = 'yes' THEN offer_value * 0.10 ELSE 0 END) AS commission_earned
    FROM
        Campaign_Offer
	WHERE
	offer_date BETWEEN @startDate and @endDate
    GROUP BY
        Employee_id
);

Select *from CalculateCommissionByDate('2023-01-01','2023-01-08');

/*i) Develop a Scalar UDF function to determine if a customer was born on a leap year by
accepting the cutomer_id and display ‘Customer Born in leap year’ or ‘Customer Not
born in leap year’.*/
CREATE FUNCTION leapYearBirthday(@customer_id INT)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @result VARCHAR(50);

    SELECT @result = 
        CASE WHEN YEAR(DOB) % 4 = 0 AND (YEAR(DOB) % 100 <> 0 OR YEAR(DOB) % 400 = 0)
             THEN 'Customer Born in leap year'
             ELSE 'Customer Not born in leap year'
        END
    FROM
        marketing_list
    WHERE
        id = @customer_id;

    RETURN @result;
END;

/*j) Use your UDF in part i) in a SELECT statement along with the marketing_list table.*/
DECLARE @customer_id_to_check INT = 1;
SELECT
    id,
    first_name,
    last_name,
    dbo.leapYearBirthday(id) AS leap_year_status
FROM
    marketing_list
WHERE
    id = @customer_id_to_check;

--------------------------------------------------------------------------------------
/*******************************LAB 5 BEGINS HERE************************************/
--------------------------------------------------------------------------------------
/*a) Develop a table called Loyalty Card. The table that has the following fields:
(Member_ID, Issuedate, Expirydate). The issue date should be defaulted to Today’s
date and the expiry date should be set to one year from now. Ensure that foreign key
constraints are implemented. Your Member_ID must be integer*/

CREATE TABLE LoyaltyCard (
    Member_ID INT PRIMARY KEY,
    IssueDate DATE DEFAULT GETDATE(),
    ExpiryDate DATE DEFAULT DATEADD(YEAR, 1, GETDATE()),
    CONSTRAINT FK_LoyaltyCard_Member FOREIGN KEY (Member_ID) REFERENCES marketing_list(id)
);


/*b)In a New query window, insert a pair of records into the marketing list table first, then
the loyalty card table WITHOUT THE TRANSACTION STATEMENTS. (Valid Pair –
Member_id are the same in both records.). Write two select statements for each table to
verify the records were entered.*/
INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
VALUES
(14, 'Leah', 'Michelle', '1999-04-12', 'F', 'Kinsgton', '345-6785', 'Digicel'),
(15, 'John', 'Gordon', '1997-04-11', 'M', 'Hanover', '315-6085', 'Lime');

INSERT INTO LoyaltyCard (Member_ID)
VALUES (14), (15);

-- Verify records in the tables
Select*from marketing_list;
Select *from LoyaltyCard;

/*c) Insert a second pair of records (Invalid Pair). This time the loyalty card record should
have a letter (Example ‘a’ - an incorrect member Id). (We are trying to force a convert
data type error). Write two select statements for each table to verify the records were
entered.*/
INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
VALUES (17, 'Jenna', 'Richards', '1997-06-27', 'F', 'Manchester', '235-9085', 'Digicel');

INSERT INTO LoyaltyCard (Member_ID)
VALUES ('a'), ('b');

Select*from marketing_list;
Select *from LoyaltyCard;

/*d) Redo part b ) and part c) but use the transaction statement BEGIN TRANSACTION
and COMMIT TRANSACTION (No Rollback). Did you notice anything about the
second sets of record you were trying to insert? What transaction properties did you
notice?*/
BEGIN TRANSACTION;
-- Insert records into MarketingList table
INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
VALUES (16, 'Rick', 'Manuel', '1997-06-27', 'M', 'Manchester', '635-7085', 'CLARO');

-- Insert records into LoyaltyCard table
INSERT INTO LoyaltyCard (Member_ID)
VALUES (16);

-- Commit transaction
COMMIT TRANSACTION;

-- Verify records in the MarketingList table
SELECT * FROM marketing_list;

-- Verify records in the LoyaltyCard table
SELECT * FROM LoyaltyCard;


BEGIN TRANSACTION;
-- Attempt to insert a record with an incorrect member ID 
INSERT INTO marketing_list(id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
VALUES (17, 'Molly', 'White', '1996-05-22', 'F', 'Manchester', '835-7015', 'Lime');

-- Attempt to insert a record with an incorrect member ID (using a letter instead of a number)
INSERT INTO LoyaltyCard (Member_ID)
VALUES ('a');

-- Commit transaction
COMMIT TRANSACTION;

-- Verify records in the MarketingList table
SELECT * FROM marketing_list;

-- Verify records in the LoyaltyCard table
SELECT * FROM LoyaltyCard;

/*I noticed the property of atomicity being displayed:  If any statement within the transaction fails, 
the entire transaction is rolled back, ensuring that either all operations succeed or none are applied. In the
second transaction, the marketing_list insert statement was not completed, as the Loyalty Card insert statement was invalid*/

/*EXERCISE 2*/
/*a) Revisit the insert statement for the member list. Ensure that is working. We only
want 5 persons to any parish. Include an if statement that checks to see the
number of persons in a parish and issues a rollback command if the number of
customers in the parish has gone over 5.*/
BEGIN TRANSACTION;

DECLARE @Parish NVARCHAR(50) = 'Manchester'; 

-- Check the number of persons in the specified parish
DECLARE @NumberOfPersons INT;
SELECT @NumberOfPersons = COUNT(*)
FROM marketing_list
WHERE parish = @Parish;

-- Check if the number of persons in the parish exceeds 5
IF @NumberOfPersons >= 5
BEGIN
    -- Rollback the transaction if the limit is exceeded
    ROLLBACK TRANSACTION;
    PRINT 'Rollback: Exceeded limit of 5 persons in the parish';
END
ELSE
BEGIN
    -- Insert a new person into the MarketingList table
    INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
VALUES (18, 'Richard', 'Jones', '1996-06-22', 'M', 'Manchester', '895-9015', 'Lime');

    -- Commit the transaction if the limit is not exceeded
    COMMIT TRANSACTION;
    PRINT 'Transaction committed successfully';
END

-- Verify records in the MarketingList table
SELECT * FROM marketing_list;

/*b) Redo Section 1 part b) this time we will provide a member_id for loyality card
that is an integer but does not belong to the member table. (We are trying to
force a foreign key constraint violation).*/
INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
VALUES (19, 'Jack', 'Black', '1987-06-14', 'M', 'St.Catherine', '935-9765', 'Digicel');

SELECT * FROM marketing_list;

INSERT INTO LoyaltyCard (Member_ID)
VALUES ('21');

SELECT * FROM LoyaltyCard;

/*Redo 2 c) using the transaction statements. Does the record still insert?
Transaction do not stop when Foreign Key constraints are violated.*/
BEGIN TRANSACTION;
-- Insert a record into the marketing list table
INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
VALUES (20, 'Penelope', 'Marshall', '1988-02-14', 'F', 'St.Catherine', '635-1765', 'Lime');

-- Attempt to insert a record into the loyalty card table with an invalid member_id
INSERT INTO LoyaltyCard (Member_ID, IssueDate, ExpiryDate)
VALUES (999999, GETDATE(), DATEADD(YEAR, 1, GETDATE()));

COMMIT TRANSACTION;
-- Verify the records in the tables (expecting no new record due to the violation)
 Select *from marketing_list;
 SELECT * FROM LoyaltyCard;

 /*Redo 2 d) to first check if the member_id to be inserted in loyalty card is already
in the marketing_list table. If it is not found (count is zero), then rollback the
transaction manually.*/
BEGIN TRANSACTION;
-- Check if the member_id exists in the marketing_list table
DECLARE @MemberCount INT;
SELECT @MemberCount = COUNT(*)
FROM marketing_list
WHERE id = 20; 

-- If member_id not found in marketing_list, rollback transaction
IF @MemberCount = 0
BEGIN
    PRINT 'Member_ID not found in Marketing List. Rolling back transaction.';
    ROLLBACK TRANSACTION;
END
ELSE
BEGIN
    -- Member_id found, insert record into the loyalty_card table
    INSERT INTO LoyaltyCard (Member_ID, IssueDate, ExpiryDate)
    VALUES (20, GETDATE(), DATEADD(YEAR, 1, GETDATE()));

    -- Verify the records in the LoyaltyCard table
    SELECT * FROM LoyaltyCard;
    
    COMMIT TRANSACTION;
END

---------------------------------------------------------------------------------
/*******************************LAB 6 BEGINS HERE*******************************/
---------------------------------------------------------------------------------

/*Exercise 1
a) Develop a stored procedure for the insert statements into member list and loyalty card
scenario from the transactions lab manual ex1. Develop your own error-handling block
for each insert statement inside the store procedure. The stored procedure should take
an input parameter for the member_id of member_list separetly from the member_id of
the loyalty_card.*/
CREATE PROCEDURE InsertMemberAndLoyaltyCard
    @MemberID INT,
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @DOB DATE,
    @Gender CHAR(1),
    @Parish VARCHAR(255),
    @Mobile VARCHAR(15),
    @MobileProvider VARCHAR(50),
    @LoyaltyCardMemberID INT
AS
BEGIN
    BEGIN TRANSACTION;

    -- Insert into marketing_list
    INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
    VALUES (@MemberID, @FirstName, @LastName, @DOB, @Gender, @Parish, @Mobile, @MobileProvider);

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT 'Unexpected error occurred!' AS ErrorMessage;
        RETURN 1;
    END

    -- Insert into LoyaltyCard
    INSERT INTO LoyaltyCard (Member_ID)
    VALUES (@LoyaltyCardMemberID);

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT 'Unexpected error occurred!' AS ErrorMessage;
        RETURN 1;
    END

    COMMIT TRANSACTION;
    RETURN 0; -- Successful execution
END;


/*b) Insert a set of data for the following scenario (We’re testing which errors will be
captured):*/
--• A letter for both member_ids of loyalty card and member_list
EXEC InsertMemberAndLoyaltyCard
    @MemberID = 'A', -- Letter value for member ID
    @FirstName = 'John',
    @LastName = 'Doe',
    @DOB = '1990-01-01',
    @Gender = 'M',
    @Parish = 'Kingston',
    @Mobile = '1234567890',
    @MobileProvider = 'Digicel',
    @LoyaltyCardMemberID = 'B'; -- Letter value for loyalty card member ID

	--Error converting data type varchar to int.

/*• A valid customer on the member_list and a letter for the member_id of the
loyalty card*/
EXEC InsertMemberAndLoyaltyCard
    @MemberID = '3', -- valid value for member ID
    @FirstName = 'John',
    @LastName = 'Doe',
    @DOB = '1990-01-01',
    @Gender = 'M',
    @Parish = 'Kingston',
    @Mobile = '1234567890',
    @MobileProvider = 'Digicel',
    @LoyaltyCardMemberID = 'B'; -- Letter value for loyalty card member ID

	--Error converting data type varchar to int.

--• A valid customer but an integer for loyalty card that doesn’t exist.
EXEC InsertMemberAndLoyaltyCard
    @MemberID = '3', -- valid value for member ID
    @FirstName = 'John',
    @LastName = 'Doe',
    @DOB = '1990-01-01',
    @Gender = 'M',
    @Parish = 'Kingston',
    @Mobile = '1234567890',
    @MobileProvider = 'Digicel',
    @LoyaltyCardMemberID = '102'; -- value for loyalty card member ID that doesnt exist

	/*EROOR: The INSERT statement conflicted with the FOREIGN KEY constraint "FK_LoyaltyCard_Member". The conflict occurred 
	in database "advanced_databases_2100762", table "dbo.marketing_list", column 'id'.*/

--• Insert null values for both member_ids*/
EXEC InsertMemberAndLoyaltyCard
    @MemberID = NULL, -- valid value for member ID
    @FirstName = 'John',
    @LastName = 'Doe',
    @DOB = '1990-01-01',
    @Gender = 'M',
    @Parish = 'Kingston',
    @Mobile = '1234567890',
    @MobileProvider = 'Digicel',
    @LoyaltyCardMemberID = NULL; -- value for loyalty card member ID that doesnt exist

	/*Error: Cannot insert the value NULL into column 'id', table 
	'advanced_databases_2100762.dbo.marketing_list'; column does not allow nulls. INSERT fails.*/
select*from marketing_list;

/*c) Develop a second stored procedure that will use the GOTO function instead of the
individual error handling block that was in part a). Retry the data entered for part b).*/
CREATE PROCEDURE InsertMemberAndLoyaltyCard_GOTO
    @MemberID INT,
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @DOB DATE,
    @Gender CHAR(1),
    @Parish VARCHAR(255),
    @Mobile VARCHAR(15),
    @MobileProvider VARCHAR(50),
    @LoyaltyCardMemberID INT
AS
BEGIN
    DECLARE @Error INT;

    -- Insert into member_list table
    INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
    VALUES (@MemberID, @FirstName, @LastName, @DOB, @Gender, @Parish, @Mobile, @MobileProvider);

    -- Check for errors
    SET @Error = @@ERROR;
    IF @Error <> 0
        GOTO ErrorHandler;

    -- Insert into LoyaltyCard table
    INSERT INTO LoyaltyCard (Member_ID)
    VALUES (@LoyaltyCardMemberID);

    -- Check for errors
    SET @Error = @@ERROR;
    IF @Error <> 0
        GOTO ErrorHandler;

    -- Commit transaction if successful
    COMMIT TRANSACTION;
    RETURN 0;

    -- Error handler label
    ErrorHandler:
        -- Rollback transaction
        ROLLBACK TRANSACTION;
        -- Return error code
        RETURN @Error;
END;

--Retrying the errors:
--• A letter for both member_ids of loyalty card and member_list
EXEC InsertMemberAndLoyaltyCard
    @MemberID = 'A', -- Letter value for member ID
    @FirstName = 'John',
    @LastName = 'Doe',
    @DOB = '1990-01-01',
    @Gender = 'M',
    @Parish = 'Kingston',
    @Mobile = '1234567890',
    @MobileProvider = 'Digicel',
    @LoyaltyCardMemberID = 'B'; -- Letter value for loyalty card member ID

	--Error converting data type varchar to int.

/*• A valid customer on the member_list and a letter for the member_id of the
loyalty card*/
EXEC InsertMemberAndLoyaltyCard
    @MemberID = '3', -- valid value for member ID
    @FirstName = 'John',
    @LastName = 'Doe',
    @DOB = '1990-01-01',
    @Gender = 'M',
    @Parish = 'Kingston',
    @Mobile = '1234567890',
    @MobileProvider = 'Digicel',
    @LoyaltyCardMemberID = 'B'; -- Letter value for loyalty card member ID

	--Error converting data type varchar to int.

--• A valid customer but an integer for loyalty card that doesn’t exist.
EXEC InsertMemberAndLoyaltyCard
    @MemberID = '3', -- valid value for member ID
    @FirstName = 'John',
    @LastName = 'Doe',
    @DOB = '1990-01-01',
    @Gender = 'M',
    @Parish = 'Kingston',
    @Mobile = '1234567890',
    @MobileProvider = 'Digicel',
    @LoyaltyCardMemberID = '102'; -- value for loyalty card member ID that doesnt exist

	/*EROOR: The INSERT statement conflicted with the FOREIGN KEY constraint "FK_LoyaltyCard_Member". The conflict occurred 
	in database "advanced_databases_2100762", table "dbo.marketing_list", column 'id'.*/

--• Insert null values for both member_ids*/
EXEC InsertMemberAndLoyaltyCard
    @MemberID = NULL, -- valid value for member ID
    @FirstName = 'John',
    @LastName = 'Doe',
    @DOB = '1990-01-01',
    @Gender = 'M',
    @Parish = 'Kingston',
    @Mobile = '1234567890',
    @MobileProvider = 'Digicel',
    @LoyaltyCardMemberID = NULL; -- value for loyalty card member ID that doesnt exist

/*EXERCISE 2*/
/*
Develop a stored procedure that will accept the appropriate input parameters
with the following nested transaction structure. Place each insert in a nested
transaction statement.
Transaction 1
	Transaction 2
		Transaction 3
		Insert Member list
		Print the transaction count
		End 3
	Insert Loyalty Card
	Print the transaction count
	End 2
Insert Campaign Offer
Print the transaction count
End 1*/

CREATE PROCEDURE NestedTransactions
	@MemberID INT,
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @DOB DATE,
    @Gender CHAR(1),
    @Parish VARCHAR(255),
    @Mobile VARCHAR(15),
    @MobileProvider VARCHAR(50),
    @LoyaltyCardMemberID INT,
    @CampaignOfferID INT
AS
BEGIN
	BEGIN TRANSACTION Transaction1
		BEGIN TRANSACTION Transaction2
			BEGIN TRANSACTION Transaction3

			 INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
			 VALUES (@MemberID, @FirstName, @LastName, @DOB, @Gender, @Parish, @Mobile, @MobileProvider);
			 PRINT 'Transaction count in Transaction 3: ' + CAST(@@TRANCOUNT AS VARCHAR);
			 COMMIT TRANSACTION Transaction3;

		INSERT INTO LoyaltyCard (Member_ID) VALUES (@LoyaltyCardMemberID);
		PRINT 'Transaction count in Transaction 2: ' + CAST(@@TRANCOUNT AS VARCHAR);
		COMMIT TRANSACTION Transaction2;

	INSERT INTO Campaign_Offer (customer_id) VALUES (@CampaignOfferID);
	PRINT 'Transaction count in Transaction 1: ' + CAST(@@TRANCOUNT AS VARCHAR);
	COMMIT TRANSACTION Transaction1;
END;

--b) Execute the nested transaction with normal records.
EXEC NestedTransactions
    @MemberID = 21, -- valid value for member ID
    @FirstName = 'Nelson',
    @LastName = 'Gordon',
    @DOB = '1990-02-01',
    @Gender = 'M',
    @Parish = 'Kingston',
    @Mobile = '786-8975',
    @MobileProvider = 'Digicel',
    @LoyaltyCardMemberID = 21, 
	@CampaignOfferID= 21;

	select*from marketing_list;
	select *from LoyaltyCard;

/*c) Insert an ‘x’ value into loyalty card for a new set of records and execute the
statement again. Does the member get inserted?*/
EXEC NestedTransactions
    @MemberID = 22, -- valid value for member ID
    @FirstName = 'Jack',
    @LastName = 'Gordon',
    @DOB = '1992-03-01',
    @Gender = 'M',
    @Parish = 'St. Mary',
    @Mobile = '886-1975',
    @MobileProvider = 'FLOW',
    @LoyaltyCardMemberID = 'X', 
	@CampaignOfferID= 22;

select*from marketing_list;
/*No, the member was not inserted*/

/*d) Issue a rollback command in the second transaction. Does any record get
inserted?*/
ALTER PROCEDURE NestedTransactions
	@MemberID INT,
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @DOB DATE,
    @Gender CHAR(1),
    @Parish VARCHAR(255),
    @Mobile VARCHAR(15),
    @MobileProvider VARCHAR(50),
    @LoyaltyCardMemberID INT,
    @CampaignOfferID INT
AS
BEGIN
	BEGIN TRANSACTION Transaction1
		BEGIN TRANSACTION Transaction2
			BEGIN TRANSACTION Transaction3

			 INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
			 VALUES (@MemberID, @FirstName, @LastName, @DOB, @Gender, @Parish, @Mobile, @MobileProvider);
			 PRINT 'Transaction count in Transaction 3: ' + CAST(@@TRANCOUNT AS VARCHAR);
			 COMMIT TRANSACTION Transaction3;

		INSERT INTO LoyaltyCard (Member_ID) VALUES (@LoyaltyCardMemberID);
		PRINT 'Transaction count in Transaction 2: ' + CAST(@@TRANCOUNT AS VARCHAR);
		COMMIT TRANSACTION Transaction2;

		--ROLLBACK ADDED
		ROLLBACK TRANSACTION Transaction2;

	INSERT INTO Campaign_Offer (customer_id) VALUES (@CampaignOfferID);
	PRINT 'Transaction count in Transaction 1: ' + CAST(@@TRANCOUNT AS VARCHAR);
	COMMIT TRANSACTION Transaction1;
END;

EXEC NestedTransactions
    @MemberID = 22, -- valid value for member ID
    @FirstName = 'Jack',
    @LastName = 'Gordon',
    @DOB = '1992-03-01',
    @Gender = 'M',
    @Parish = 'St. Mary',
    @Mobile = '886-1975',
    @MobileProvider = 'LIME',
    @LoyaltyCardMemberID = 22, 
	@CampaignOfferID= 22;

select*from marketing_list;
/*No*/

/*e) Currently transactions are arranged concurrently (intertwined). Arrange the
transactions sequentially (one after the other and try part c) again does the
member record get inserted?*/
ALTER PROCEDURE NestedTransactions
    @MemberID INT,
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @DOB DATE,
    @Gender CHAR(1),
    @Parish VARCHAR(255),
    @Mobile VARCHAR(15),
    @MobileProvider VARCHAR(50),
    @LoyaltyCardMemberID INT,
    @CampaignOfferID INT
AS
BEGIN
    -- Start Transaction 1
    BEGIN TRANSACTION Transaction1
    PRINT 'Transaction count in Transaction 1: ' + CAST(@@TRANCOUNT AS VARCHAR)
    
    -- Insert into Campaign_Offer
    INSERT INTO Campaign_Offer (customer_id)
    VALUES (@CampaignOfferID)
    
    -- Commit Transaction 1
    COMMIT TRANSACTION Transaction1
    
    -- Start Transaction 2
    BEGIN TRANSACTION Transaction2
    PRINT 'Transaction count in Transaction 2: ' + CAST(@@TRANCOUNT AS VARCHAR)
    
    -- Insert into LoyaltyCard
    INSERT INTO LoyaltyCard (Member_ID)
    VALUES (@LoyaltyCardMemberID)
    
    -- Commit Transaction 2
    COMMIT TRANSACTION Transaction2
    
    -- Start Transaction 3
    BEGIN TRANSACTION Transaction3
    PRINT 'Transaction count in Transaction 3: ' + CAST(@@TRANCOUNT AS VARCHAR)
    
    -- Insert into marketing_list
    INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
    VALUES (@MemberID, @FirstName, @LastName, @DOB, @Gender, @Parish, @Mobile, @MobileProvider)
    
    -- Commit Transaction 3
    COMMIT TRANSACTION Transaction3
END;


EXEC NestedTransactions
    @MemberID = 23, -- valid value for member ID
    @FirstName = 'Kyla',
    @LastName = 'John',
    @DOB = '1995-11-01',
    @Gender = 'F',
    @Parish = 'St. Catherine',
    @Mobile = '886-1975',
    @MobileProvider = 'LIME',
    @LoyaltyCardMemberID = 23, 
	@CampaignOfferID= 23;

select*from marketing_list;

---------------------------------------------------------------------------------------
/***************************Lab 7 BEGINS HERE******************************************/
----------------------------------------------------------------------------------------
/*a) Develop the trigger in example 1 for marketing list.
I. Try to insert a record.
II. What happens? Is it in the record in the marketing list table?
III. What is the purpose of “inserted”?*/
-- Step 1: Create the trigger
CREATE TRIGGER before_insert_marketing_list
ON marketing_list
INSTEAD OF INSERT
AS
BEGIN
    -- Select the inserted record to display
    SELECT * FROM inserted;
END;

-- Insert a record into the marketing list table
INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
VALUES (24, 'John', 'Doe', '1990-01-01', 'M', 'Kingston', '555-1234', 'Digicel');

select *from marketing_list;
/*II. What happens? Is it in the record in the marketing list table?
When you insert a record into the marketing list table, the trigger intercepts the insert operation 
and displays the record using the SELECT statement within the trigger. However, the record
is not actually inserted into the marketing list table because the trigger intercepts the insert operation.*/

/*III. What is the purpose of "inserted"?
The inserted table is a special table available in SQL Server triggers that contains the rows that are being inserted, updated, or deleted. 
It allows you to access the data being affected by the triggering operation.*/

-- Step 2: Drop the trigger
DROP TRIGGER before_insert_marketing_list;

/*b) Create a table called Child List that has the same fields as Marketing List. Develop a
trigger that will be placed on the marketing list table that will insert a record into the
child table if the person’s age is less than 18 once an insert is attempted. The trigger
will also place records in the customer table if the person is 18 and over.*/
CREATE TABLE Child_List(
    id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    DOB DATE,
    gender CHAR(1), -- Assuming 'M' for Male, 'F' for Female, or other appropriate values
    parish VARCHAR(255),
    mobile VARCHAR(15), -- Assuming a reasonable length for mobile numbers
    mobile_provider VARCHAR(50) CHECK (mobile_provider IN ('Digicel', 'Lime', 'Claro'))
);

-- Step 1: Create the trigger on the marketing list table

CREATE TRIGGER insert_child_or_customer
ON marketing_list
INSTEAD OF INSERT
AS
BEGIN

    -- Iterate over the inserted rows
    DECLARE @id INT, @first_name VARCHAR(255), @last_name VARCHAR(255), @DOB DATE, @gender CHAR(1), @parish VARCHAR(255), @mobile VARCHAR(15), @mobile_provider VARCHAR(50);
    DECLARE insert_cursor CURSOR FOR
    SELECT id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider
    FROM Inserted;
    
    OPEN insert_cursor;
    FETCH NEXT FROM insert_cursor INTO @id, @first_name, @last_name, @DOB, @gender, @parish, @mobile, @mobile_provider;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calculate age based on DOB
        DECLARE @Age INT = DATEDIFF(YEAR, @DOB, GETDATE());

        -- Insert into appropriate table based on age
        IF @Age < 18
        BEGIN
            INSERT INTO Child_List (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
            VALUES (@id, @first_name, @last_name, @DOB, @gender, @parish, @mobile, @mobile_provider);
        END
        ELSE
        BEGIN
            INSERT INTO marketing_list(id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
            VALUES (@id, @first_name, @last_name, @DOB, @gender, @parish, @mobile, @mobile_provider);
        END

        FETCH NEXT FROM insert_cursor INTO @id, @first_name, @last_name, @DOB, @gender, @parish, @mobile, @mobile_provider;
    END

    CLOSE insert_cursor;
    DEALLOCATE insert_cursor;
END;

--c) Insert 4 new records into customer, 2 with DOBs before 1991 and 2 with DOBs after 2000.
INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
VALUES (30, 'Ricky', 'Dixon', '1995-01-01', 'M', 'St. Ann', '515-9234', 'Digicel');

INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
VALUES (31, 'John', 'Doe', '1996-01-01', 'M', 'Kingston', '505-1234', 'LIME');

INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
VALUES (32, 'John', 'Doe', '2007-01-01', 'M', 'Kingston', '545-1234', 'CLARO');

INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
VALUES (33, 'John', 'Doe', '2007-04-01', 'M', 'Kingston', '225-1234', 'Digicel');

select*from marketing_list;
select *from Child_List;

DROP TRIGGER insert_child_or_customer;

/*Exercise 2*/
/*a) Try the trigger in example 3 for marketing list. Try to delete some records what are your
observations? [Remember to drop your trigger]*/
CREATE TRIGGER before_delete_marketing_list
ON marketing_list INSTEAD OF DELETE
AS
BEGIN
    SELECT * FROM deleted;
END;

Delete from marketing_list where id=30;
select*from marketing_list;

-- I observed that the record was not deleted from the table, it was instead displayed to me 

DROP TRIGGER before_delete_marketing_list;

/*b) Create a table called Audit_Log that has the same fields as marketing list with 3
additional fields: Audit_Action, Audit_Table, Action_Date.*/
CREATE TABLE Audit_Log(
    id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    DOB DATE,
    gender CHAR(1),
    parish VARCHAR(255),
    mobile VARCHAR(15),
    mobile_provider VARCHAR(50) CHECK (mobile_provider IN ('Digicel', 'Lime', 'Claro')),
    Audit_Action VARCHAR(50),
    Audit_Table VARCHAR(50),
    Action_Date DATETIME
);

/*c) Develop triggers that will be placed on both the customer and child tables that will track
any record deleted and place them in the Audit_Log Table while populating the three
additional audit fields.
Hint:
INSERT INTO customer (first_name, last_name, sign_up_date )
SELECT first_name, last_name, getdate() from mailing_list ;*/
CREATE TRIGGER log_delete_customer
ON marketing_list AFTER DELETE
AS
BEGIN
    INSERT INTO Audit_Log (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider, Audit_Action, Audit_Table, Action_Date)
    SELECT id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider, 'DELETED', 'customer', GETDATE()
    FROM deleted;
END;

CREATE TRIGGER log_delete_child
ON Child_List AFTER DELETE
AS
BEGIN
    INSERT INTO Audit_Log (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider, Audit_Action, Audit_Table, Action_Date)
    SELECT id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider, 'DELETED', 'Child_List', GETDATE()
    FROM deleted;
END;

--d) Delete a specific record from the Child and Customer Table.
Delete from marketing_list where id=30;
Delete from Child_List where id=29;

--e) Display the contents of the Audit_Log Table.
select *from Audit_Log;


---------------------------------------------------------------------------------------
/***************************Lab 8 BEGINS HERE******************************************/
----------------------------------------------------------------------------------------

/*Exercise 1
a) Try the two examples above for marketing _list. Ensure for example 2 you are updating
the last_name and DOB of a customer.*/

--Example 1
CREATE TRIGGER update_customer
ON marketing_list FOR UPDATE
AS
BEGIN
    SELECT * FROM Inserted;
    SELECT * FROM Deleted;
END;

DROP TRIGGER update_customer;
--Example 2
CREATE TRIGGER update_customer2
ON marketing_list AFTER UPDATE
AS
BEGIN
    SELECT DOB, last_name FROM Inserted;
    SELECT DOB, last_name FROM Deleted;
END;

/*b) Alter your marketing_list table and add a Date created field. Default the value to the
current date.*/

ALTER TABLE marketing_list
ADD DateCreated DATE DEFAULT GETDATE();

--c) Create a trigger that only allows updates to records that are less than three days old.
CREATE TRIGGER prevent_old_record_updates
ON marketing_list
FOR UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT * 
        FROM Inserted i
        JOIN Deleted d ON i.id = d.id
        WHERE DATEDIFF(DAY, i.DateCreated, GETDATE()) >= 3
    )
    BEGIN
        RAISERROR('Updates to records older than three days are not allowed.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
DROP TRIGGER prevent_old_record_updates;


/*d) Create a trigger that stores the old version of a record to the audit_log table with the
appropriate audit fields updated.*/
CREATE TRIGGER log_old_record
ON marketing_list
AFTER UPDATE
AS
BEGIN
    INSERT INTO Audit_Log (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider, Audit_Action, Audit_Table, Action_Date)
    SELECT 
        d.id, d.first_name, d.last_name, d.DOB, d.gender, d.parish, d.mobile, d.mobile_provider,
        'Update', 'marketing_list', GETDATE()
    FROM
        Deleted d
        JOIN Inserted i ON d.id = i.id;
END;


--Testing
update marketing_list set last_name='Brown' where id=11;
select *from Audit_Log

DROP TRIGGER log_old_record;
--e) Create a trigger that will only update a record if the old record is different from the new.
CREATE TRIGGER update_if_different
ON marketing_list
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Inserted i
        JOIN Deleted d ON i.id = d.id
        WHERE 
            i.first_name <> d.first_name OR
            i.last_name <> d.last_name OR
            i.DOB <> d.DOB OR
            i.gender <> d.gender OR
            i.parish <> d.parish OR
            i.mobile <> d.mobile OR
            i.mobile_provider <> d.mobile_provider
    )
    BEGIN
        UPDATE m
        SET 
            m.first_name = i.first_name,
            m.last_name = i.last_name,
            m.DOB = i.DOB,
            m.gender = i.gender,
            m.parish = i.parish,
            m.mobile = i.mobile,
            m.mobile_provider = i.mobile_provider
        FROM
            marketing_list m
        INNER JOIN
            Inserted i ON m.id = i.id;
    END;
END;

 /*Exercise 2
a) Create an update trigger on Marketing_list and Child that checks if the DOB has been
updated. If the new DOB is 18 and over in Child move the record to Customer table and
vice versa for Customer.*/
-- Update trigger on marketing_list
CREATE TRIGGER update_dob_marketing_list
ON marketing_list
AFTER UPDATE
AS
BEGIN
    IF UPDATE(DOB)
    BEGIN
        DECLARE @ID INT, @DOB DATE;

        SELECT @ID = i.id, @DOB = i.DOB
        FROM Inserted i
        JOIN Deleted d ON i.id = d.id;

        IF @DOB IS NOT NULL
        BEGIN
            DECLARE @Age INT;
            SET @Age = DATEDIFF(YEAR, @DOB, GETDATE());

            IF @Age >= 18
            BEGIN
                DELETE FROM marketing_list WHERE id = @ID;
                INSERT INTO Child_List (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
                SELECT id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider
                FROM Inserted
                WHERE id = @ID;
            END;
        END;
    END;
END;
-- Update trigger on Child_List
CREATE TRIGGER update_dob_child_list
ON Child_List
AFTER UPDATE
AS
BEGIN
    IF UPDATE(DOB)
    BEGIN
        DECLARE @ID INT, @DOB DATE;

        SELECT @ID = i.id, @DOB = i.DOB
        FROM Inserted i
        JOIN Deleted d ON i.id = d.id;

        IF @DOB IS NOT NULL
        BEGIN
            DECLARE @Age INT;
            SET @Age = DATEDIFF(YEAR, @DOB, GETDATE());

            IF @Age < 18
            BEGIN
                DELETE FROM Child_List WHERE id = @ID;
                INSERT INTO marketing_list (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider)
                SELECT id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider
                FROM Inserted
                WHERE id = @ID;
            END;
        END;
    END;
END;

---------------------------------------------------------------------------------------
/***************************Lab 9 BEGINS HERE******************************************/
--Sherissa Pinnock
--2100762
--Advanced Databases
----------------------------------------------------------------------------------------

/*Exercises
a. Ensure that gender is a field in your marketing_list table. Create the tables male and
female with the same fields as your marketing_list table.*/
-- Create table male
CREATE TABLE male (
    id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    DOB DATE,
    gender CHAR(1),
    parish VARCHAR(255),
    mobile VARCHAR(15),
    mobile_provider VARCHAR(50),
    CONSTRAINT CHK_gender_male CHECK (gender = 'M')
);

-- Create table female
CREATE TABLE female (
    id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    DOB DATE,
    gender CHAR(1),
    parish VARCHAR(255),
    mobile VARCHAR(15),
    mobile_provider VARCHAR(50),
    CONSTRAINT CHK_gender_female CHECK (gender = 'F')
);

/*b. Create a cursor that will the go through the customer table and determine the gender for
each record. If the customer is a female place a record in the female table and also the
same for male. *Remember to deallocate the cursor**/
DECLARE @id INT, 
        @first_name VARCHAR(255), 
        @last_name VARCHAR(255), 
        @DOB DATE,
        @gender CHAR(1),
        @parish VARCHAR(255),
        @mobile VARCHAR(15),
        @mobile_provider VARCHAR(50);

DECLARE gender_cursor CURSOR FOR 
SELECT id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider 
FROM marketing_list;

OPEN gender_cursor;

FETCH NEXT FROM gender_cursor INTO @id, @first_name, @last_name, @DOB, @gender, @parish, @mobile, @mobile_provider;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @gender = 'M'
    BEGIN
        INSERT INTO male (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider) 
        VALUES (@id, @first_name, @last_name, @DOB, @gender, @parish, @mobile, @mobile_provider);
    END
    ELSE IF @gender = 'F'
    BEGIN
        INSERT INTO female (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider) 
        VALUES (@id, @first_name, @last_name, @DOB, @gender, @parish, @mobile, @mobile_provider);
    END

    FETCH NEXT FROM gender_cursor INTO @id, @first_name, @last_name, @DOB, @gender, @parish, @mobile, @mobile_provider;
END

CLOSE gender_cursor;
DEALLOCATE gender_cursor;

select *from male;
select *from female;

--c. Extend your cursor in part b to also go through the child table and split the genders.
DECLARE @id INT, 
        @first_name VARCHAR(255), 
        @last_name VARCHAR(255), 
        @DOB DATE,
        @gender CHAR(1),
        @parish VARCHAR(255),
        @mobile VARCHAR(15),
        @mobile_provider VARCHAR(50);

DECLARE gender_cursor CURSOR FOR 
SELECT id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider 
FROM marketing_list
UNION ALL
SELECT id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider 
FROM Child_List;

OPEN gender_cursor;

FETCH NEXT FROM gender_cursor INTO @id, @first_name, @last_name, @DOB, @gender, @parish, @mobile, @mobile_provider;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @gender = 'M'
    BEGIN
        INSERT INTO male (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider) 
        VALUES (@id, @first_name, @last_name, @DOB, @gender, @parish, @mobile, @mobile_provider);
    END
    ELSE IF @gender = 'F'
    BEGIN
        INSERT INTO female (id, first_name, last_name, DOB, gender, parish, mobile, mobile_provider) 
        VALUES (@id, @first_name, @last_name, @DOB, @gender, @parish, @mobile, @mobile_provider);
    END

    FETCH NEXT FROM gender_cursor INTO @id, @first_name, @last_name, @DOB, @gender, @parish, @mobile, @mobile_provider;
END

CLOSE gender_cursor;
DEALLOCATE gender_cursor;

/*d. Create a cursor that has a target date variable. The cursor should give a summary of the
audit_log table detailing how many deletes and updates were attempted on each table.*/
DECLARE @targetDate DATE = '2024-01-01'; -- Change the target date as needed

DECLARE @tableName NVARCHAR(255), 
        @deleteCount INT = 0,
        @updateCount INT = 0;

DECLARE audit_summary_cursor CURSOR FOR 
SELECT DISTINCT Audit_Table
FROM Audit_Log
WHERE Action_Date >= @targetDate;

OPEN audit_summary_cursor;

FETCH NEXT FROM audit_summary_cursor INTO @tableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @deleteCount = COUNT(CASE WHEN Audit_Action = 'DELETE' THEN 1 END),
           @updateCount = COUNT(CASE WHEN Audit_Action = 'UPDATE' THEN 1 END)
    FROM Audit_Log
    WHERE Audit_Table = @tableName
    AND Action_Date >= @targetDate;

    PRINT 'Table: ' + @tableName + ', Deletes: ' + CAST(@deleteCount AS NVARCHAR(10)) + ', Updates: ' + CAST(@updateCount AS NVARCHAR(10));
    
    FETCH NEXT FROM audit_summary_cursor INTO @tableName;
END

CLOSE audit_summary_cursor;
DEALLOCATE audit_summary_cursor;
