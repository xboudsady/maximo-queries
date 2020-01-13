# Maximo Queries

SQL repository, and information for Maximo.

### Database Server
**NOTE:** Only Active Directory Authentication

* mxodata2.ucsf.edu (production)
* qcmxmowdb001.ucsfmedicalcenter.org (development)


## Table of Contents

* How to connect to database
    * Downloading to Excel 
    * Azure Data Studio (Mac)

* Work Order
    * Level 1

* Users
    * How many active accounts in Maximo.
        * User Application - Not Person Application 
    * How 


### Connecting to Database - Azure Data Studio (Mac)

SQL Servers supports different kinds of authentications and protocols: We will use Kerboros, to authenticate.

#### What is Kerberos?

It's a ticketing and key system: you, a user requests a ticket from a store, usually by authenticating to it via a username and password. If you are succeed, you will get a ticket that is stored within your local machine.

Then when you want to access resources like a SQL Server, the client re-ups with the store you got your initial ticket from (to make sure it's still valid), and you get a "key" to access the resource.

The key is then forwarded onto the resource, allowing you to access the thing you were trying to connect to.

Here Active Diretory domain (campus), manages this for you, even on non-Windows machines. It's part of your handshake with the domain controller.

But if you don't authenticate via Active Directory, there's no reason you can't do this manually. You just have to manually request your ticket (and authenticate in the process)

### Connecting to SQL Server Database 

1. Open up Terminal and input the following, where ***** is your username.
    ```console
    2016-MBP:~ kinit ****@CAMPUS.NET.UCSF.EDU
    ```
2. When prompted for password, enter your password.
    ```console
    ****@CAMPUS.NET.UCSF.EDU's password:
    ```
3. If successful, you will be prompted with the message below.
    ```console
    Encryption type arcfour-hmac-md5(23) used for authentication is weak and will be deprecated
    ```

---

## Work Order Table (dbo.workorder) Query

### List of Work Order, last 90 Days
Critera:
* All fields/columns
* Last 3 months from Today on Work Order Report Date
* Site is Campus Only
* No Tasks Work Order (PM Job Plan Tasks...)
* Descending Order report date (Largest to Smallest)

```sql
        -- All Columns
    SELECT * 

        -- From the Work Order Table
    FROM dbo.workorder

        -- 3 months back from today
    WHERE dbo.workorder.reportdate >= DATEADD(MONTH, -3, GETDATE())   
        -- Not a Task Work Order
        AND dbo.workorder.istask = 0    
        -- Campus only,no Medical center
        AND dbo.workorder.siteid = 'CAMPUS'     

        -- Most recent date first
    ORDER BY dbo.workorder.reportdate DESC;
```

---

## FBMS Financial Journal


### List all Labor for Campus
Critera:
* All fields/columns
* Last 31 days
* Descending Order laborcode (Largest to Smallest)

```sql
SELECT TOP 1000 * 
    
FROM dbo.financial_journals

WHERE dbo.financial_journals.PS_JOURNAL_DATE >= DATEADD(MONTH, -1, GETDATE())

ORDER BY dbo.financial_journals.PS_JOURNAL_DATE DESC;
```

## Morgan Pest Control

### List all Labor for Campus
Critera:
* All fields/columns
* Last 31 days
* Descending Order laborcode (Largest to Smallest)

```sql
SELECT 
    -- Building Inforation
    dbo.workorder.[location] AS 'Building CAAN Number',
    dbo.locations.[description] AS 'Building Description',      -- Building Description from the dbo.locations table
    dbo.locations.roomtype AS 'Room Type',
    dbo.locations.[zone] AS 'Zone Type',
    
    -- Work Order Information
    dbo.workorder.wopriority AS 'WO Prioirty',
    dbo.workorder.wonum AS 'WO Number',
    dbo.workorder.[description] AS 'WO Description',
    

    -- 'Unique Bug' Category 'Bees', 'SilverFish', 'EarWig', 'Mosquitos'
    -- 'Traps' is it's own category | Intalled Traps, Removed Traps
    -- 'Ceiling' is Rodent
    -- 'Racoon' is 'Animal Control' Type
    -- 'Owl' is 'Animal Control'
    -- 'Dog' is 'Animal Control'
    -- 'Accounting' is 'Accounting Invoice'
    -- 'Odor' is undder rodents
    -- 'Interstitual, bio-hazard clean' - Special Projects

    CASE 
        WHEN dbo.workorder.[description] LIKE '%ant%'
            THEN 'Ants'
        WHEN dbo.workorder.[description] LIKE '%an%'
            THEN 'Ants'
        WHEN dbo.workorder.[description] LIKE '%aunt%'
            THEN 'Ants'
        WHEN dbo.workorder.[description] LIKE '%flea%'
            THEN 'Fleas'
        WHEN dbo.workorder.[description] LIKE '%flie%'
            THEN 'Flies'
        WHEN dbo.workorder.[description] LIKE '%fly%'
            THEN 'Flies' 
        WHEN dbo.workorder.[description] LIKE '%cock%'
            THEN 'Cockroaches'
        WHEN dbo.workorder.[description] LIKE '%roach%'
            THEN 'Cockroaches'
        WHEN dbo.workorder.[description] LIKE '%wasp%'
            THEN 'Wasps'
        WHEN dbo.workorder.[description] LIKE '%bee%'
            THEN 'Bees'
        WHEN dbo.workorder.[description] LIKE '%fish%'
            THEN 'Silver Fish'
        WHEN dbo.workorder.[description] LIKE '%yellow%'
            THEN 'Wasps'
        WHEN dbo.workorder.[description] LIKE '%spider%'
            THEN 'Spiders'
        WHEN dbo.workorder.[description] LIKE '%term%'
            THEN 'Termines'
        WHEN dbo.workorder.[description] LIKE '%bed%'
            THEN 'Bed Bugs'
        WHEN dbo.workorder.[description] like '%mouse%'
            THEN 'Rodents'
        WHEN dbo.workorder.[description] LIKE '%mice%'
            THEN 'Rodents'
        WHEN dbo.workorder.[description] LIKE '%rat%'
            THEN 'Rodents'
        WHEN dbo.workorder.[description] LIKE '%roden%'
            THEN 'Rodents'
        WHEN dbo.workorder.[description] LIKE '%dropping%'
            THEN 'Rodents'
        WHEN dbo.workorder.[description] LIKE '%bird%'
            THEN 'Birds'
        WHEN dbo.workorder.[description] LIKE '%pigeon%'
            THEN 'Birds'
        WHEN dbo.workorder.[description] LIKE '%sea%'
            THEN 'Birds'
        WHEN dbo.workorder.[description] LIKE '%pest%'
            THEN 'General Pest Control Services'
        WHEN dbo.workorder.[description] LIKE '%bug%'
            THEN 'General Pest Control Services'
        WHEN dbo.workorder.[description] LIKE '%bait%'
            THEN 'General Pest Control Services'
        WHEN dbo.workorder.[description] LIKE '%pod%'
            THen 'General Pestec Services'
    END AS 'Pest Category',

    dbo.workorder.reportdate AS 'WO Reported Date',
    dbo.workorder.reportedby AS 'WO Reported By',
    dbo.workorder.[status] AS 'WO Status',
    dbo.workorder.worktype AS 'WO Type',
    dbo.workorder.[owner] AS 'WO Owner',
    dbo.workorder.ownergroup AS 'WO Owner Group',
    dbo.workorder.actintlabhrs AS 'Actual Labor Hours',
    dbo.workorder.actlabcost AS 'Actual Labor Cost',
    dbo.workorder.actmatcost AS 'Actual Material Cost',
    dbo.workorder.actservcost AS 'Actual Service Cost',
    dbo.workorder.fbms_amountbilled AS 'FBMS Amount Billed',
    dbo.workorder.costcenter AS 'WO Cost Center',

    -- Get WOK Classfication Type
    dbo.workorder.classstructureid AS 'WO Classification Structure ID',
    dbo.classstructure.[classificationid] AS 'WO Classification ID'

    
FROM dbo.workorder

-- To get the Location Description
INNER JOIN dbo.locations
ON dbo.workorder.[location] = dbo.locations.[location] -- Foreign Key Building CAAN No.

-- To get the Classification Structure Description
LEFT JOIN dbo.classstructure
ON dbo.workorder.classstructureid = dbo.classstructure.classstructureid

WHERE dbo.locations.siteid = 'CAMPUS'  -- Get only Location from Campus Site
    AND dbo.workorder.siteid = 'CAMPUS'    -- WO location with site ID of Campus Only
    AND dbo.classstructure.classstructureid = 2089

ORDER BY [Pest Category] ASC;
```