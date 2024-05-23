# SSIS_DWH Overview

This SSIS assignment involves solving four different tasks using Microsoft SQL Server Integration Services (SSIS). Each task addresses a specific data integration challenge, from consuming REST APIs to transforming and loading data into target tables.

## Task 1: Consume REST API and Load to Database

**Problem:** Load selected fields from a REST API response into a database table.

**Steps:**
Create a database table named University with columns: name, country, alpha_two_code, and ..etc
Fetch data from the REST API and map selected fields to the corresponding columns in the University table using C# script.

## Task 2: Implement SCD Type 4

**Problem:** Implement Slowly Changing Dimension (SCD) Type 4 for a source table.

**Steps:**

1- "GET LAST EXTRACT DATE" : here we select max "From_Date" from table "Employee_Q2_History_Target2" to use Incremental Load

2- in the "Data Flow Task" : load from table Employee_Q2_Source to two target tables "Employee_Q2_Target1" , "Employee_Q2_History_Target2"

--------------- **in the "Data Flow Task" in details** ------------------

1- "Employee_Q2_Source" : we select all rows from the "Employee_Q2_Source" table but only if the "Update_Date" > MaxDate that
                              we extract it from "Employee_Q2_History_Target2" and that means we load only the changed data.

2- "Employee_Q2_Source Lookup" : we use "Employee_Q2_History_Target2" table as lookup to determine if the extracted data exists in the 
                           target tables or not.

-- in case "Lookup no match output" means the data not exists in the target and need to be inserted :

3- "First Multicast" : here we use multicast to send the extracted data to two target tables

4- "Employee_Q2_Target1" :  send the four attributes and ignore "Update_Date" for this target table

5- "Employee_Q2_History_Target2" : send all the data and assign the "From_Date" to "Update_Date" and by default 
                                  the "To_Date" will be "9999-12-30" 

-- in case "Lookup match output" means the data is already exists in the target and need to update :
6- "Check Changed Data" : check if the value of city or email is changed or not

-- in case if changed

7- "Second Multicast" : here we use multicast to send the extracted data to two target tables

8- "Update City_Email in Employee_Q2_Target1 Destination" : update "City" and "Email" in "CustomerSCD4" Using the lookupID

9- "Update To_Date in Employee_Q2_History_Target2 Destination" : update "To_Date" to "DATEADD(DAY,-1,Update_Date)" using lookupID and "To_Date" = "9999-12-30" 

10-"Employee_Q2_History_Target2 Destination" : insert the updated data in the "Employee_Q2_History_Target2" table  

## Task 3: Load Source Data with Versioning

**Problem:** Load source data into a target table with versioning.

**Solution Approach:** Implement versioning logic using SSIS for loading data from Employee_Q3 into the target table.

**Steps:**
--------------- **in the "Data Flow Task" in details** ------------------

1- "Employee_Q3_Source Table Source" : we select all row from the "Employee" table

2- "Employee_Q3_Target Lookup" : we use "Employee_Q3_Target" table as lookup to determine if the extracted data exists in the 
                            target tables or not , we select the following four attributes 
                            "Emp_Key"  , "ID" , "Insert_Date" , "Version_No" only if the "Active_Flag" = 1
                            "ID" to make join , "Insert_Date" to check if the Date is changed or not 
                            "Version_No" we check if the Date wasn't changed increment it by 1

-- in case "Lookup match output" means the data is already exists in the target and need to update :


3- "Update Active_Flag in TargetEmployee" : set the "Active_Flag" to zero where the "ID" = "LookupID" 

4- "Check Date" : conditional split to check if the "Schedule_Date" was changed or not (to update Version_No)

 -- in case "Lookup no match output" means the data is not exists in the target and need to be inserted : 


5- "Union All" : Unoin All output of " Lookup no match output " with output of conditinal split "Changed" that mean the "Schedule_Date" was changed

6- "Employee_Q3_Target Destination" : insert all data in the "Employee_Q3_Target" table expect
                                  "Active_Flag" and "Version_No" because it will be one by default 

7- "New_Version_No" : if the "Schedule_Date" wasn't changed we use derived column to increment "Version_No" by one 

8- "TargetEmployee Destination" : insert all data in the "TargetEmployee" table expect "Active_Flag" 
                                  because it will be one by default and "Version_No" will be assign to "new_version_no"

## Task 4: Transform Attendance Device Data

**Problem:** Read data from an attendance device and transform it into a target table with a descriptive state for each record.

**Solution Approach:** Use SSIS to process data from the Attendance_Device source table and transform it into the Employee_Attendance_Details target table.

**Steps:**

1- "GET LAST EXTRACT DATE" : here we select max "Date" from table "Employee_Attendence_Details_Target" to use Incremental Load
2- in the "Data Flow Task" : load from table "Attendance_Device_Source" to target table "Employee_Attendence_Details_Target" --------------- in the "Data Flow Task" in details -----------------

  1- "EmployeeAttendance_in Source" (to get Time_in): we select 'Employee_id' , date and 'min time ' of the check in for each employee in different date , and we select 'Finger_Print_TS' to
				  use it to get the diffrenece between two times
 
  2- "EmployeeAttendance_out Source" (to get Time_out): we select 'Employee_id' , date and 'min time ' of the check out only if it is >= the max check in time  for each employee in different date , and we select 
                                       'Finger_Print_TS' to use it to get the diffrenece between two times

  3- "Sort Date and ID" : sort the data of the "EmployeeAttendance_in Source" based on the date and ID

  4- "Sort Date and ID" : sort the data of the "EmployeeAttendance_out Source" based on the date and ID

  5- "Merge Join" : Merge with Full outer join of the two sources based on hte date and ID to keep the null value

  6- "Worked_hours" :   get the Emp_ID from any source to avoid the null (using ISNULL)
                        get the Date from any source to avoid null (using ISNULL)
                        get the worked_hours using the diffrence between "Finger_Print_TS"

  7- "State" : get the State according to the following criteria :
       State                      Description
       ebn el-shrka               Arrived on time (9 am) and worked more than 8 hours
       mo7tram                    Arrived on time and worked 8 hours
       raye2                      Arrived late but worked 8 hours
       byst3bat                   Arrived on time but worked less than 8 hours
       msh mo7tram                Arrived late and worked less than 8 hours
       no check out               No check-out record for the employee on that day
       undefined                  Any different scenario

  8- "Employee_Attendence_Details_Target Destination" :  insert all data in the "Employee_Attendence_Details_Target" table


## Contributors
. [Shahd Osama](https://github.com/shahdosama10)

. [Maryam Osama](https://github.com/maryamosama33)
