# Maximo Queries

## Table of Contents
* [Connection to Database Server](/connection/readme.md)
* Preventative Maintenance
  * [PM Forecast Tool (Katherine's Query)](/preventative-maintenance/ka)
  * [Forecast Dates](/preventative-maintenance/forcast-date/readme.md)


SQL repository, and information for Maximo.



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

    CASE
        WHEN dbo.workorder.[description] LIKE '%door sweep%'
            THEN 'Door Sweeps'
        WHEN dbo.workorder.[description] LIKE '%mite%'
            THEN 'Mites'
        WHEN dbo.workorder.[description] LIKE '%inter%'
            THEN 'Pestec Projects'
        WHEN dbo.workorder.[description] LIKE '%gopher%'
            THEN 'Pestec Projects'
        WHEN dbo.workorder.[description] LIKE '%project%'
            THEN 'Pestec Projects'
        WHEN dbo.workorder.[description] LIKE '%accty%'
            THEN 'Account Invoice'
        WHEN dbo.workorder.[description] LIKE '%bat%'
            THEN 'Animal Control'
        WHEN dbo.workorder.[description] LIKE '%dog%'
            THEN 'Animal Control'
        WHEN dbo.workorder.[description] LIKE '%owl%'
            THEN 'Animal Control'
        WHEN dbo.workorder.[description] LIKE '%racoon%'
            THEN 'Animal Control'
        WHEN dbo.workorder.[description] LIKE '%possum%'
            THEN 'Animal Control'
        WHEN dbo.workorder.[description] LIKE '%trap%'
            THEN 'Traps'
        WHEN dbo.workorder.[description] LIKE '%ant%'
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
            THEN 'Unique Bug'
        WHEN dbo.workorder.[description] LIKE '%moth%'
            THEN 'Unique Bug'
        WHEN dbo.workorder.[description] LIKE '%fish%'
            THEN 'Unique Bug'
        WHEN dbo.workorder.[description] LIKE '%gnat%'
            THEN 'Unique Bug'
        WHEN dbo.workorder.[description] LIKE '%earwig%'
            THEN 'Unique Bug'
        WHEN dbo.workorder.[description] LIKE '%mosqui%'
            THEN 'Unique Bug'
        WHEN dbo.workorder.[description] LIKE '%tick%'
            THEN 'Unique Bug'
        WHEN dbo.workorder.[description] LIKE '%yellow%'
            THEN 'Wasps'
        WHEN dbo.workorder.[description] LIKE '%spider%'
            THEN 'Spiders'
        WHEN dbo.workorder.[description] LIKE '%term%'
            THEN 'Termines'
        WHEN dbo.workorder.[description] LIKE '%bed%'
            THEN 'Bed Bugs'
        WHEN dbo.workorder.[description] LIKE '%ceiling%'
            THEN 'Rodents'
        WHEN dbo.workorder.[description] like '%mouse%'
            THEN 'Rodents'
        WHEN dbo.workorder.[description] LIKE '%mice%'
            THEN 'Rodents'
        WHEN dbo.workorder.[description] LIKE '%odor%'
            THEN 'Rodents'
        WHEN dbo.workorder.[description] LIKE '%rat%'
            THEN 'Rodents'
        WHEN dbo.workorder.[description] LIKE '%roden%'
            THEN 'Rodents'
        WHEN dbo.workorder.[description] LIKE '%dropping%'
            THEN 'Rodents'
        WHEN dbo.workorder.[description] LIKE '%bird%'
            THEN 'Birds'
        WHEN dbo.workorder.[description] LIKE '%nest%'
            THEN 'Birds'
        WHEN dbo.workorder.[description] LIKE '%pigeon%'
            THEN 'Birds'
        WHEN dbo.workorder.[description] LIKE '%sea%'
            THEN 'Birds'
        WHEN dbo.workorder.[description] LIKE '%sea%'
            THEN 'Birds'
        WHEN dbo.workorder.[description] LIKE '%pest%'
            THEN 'General Pestec Services'
        WHEN dbo.workorder.[description] LIKE '%bug%'
            THEN 'General Pestec Services'
        WHEN dbo.workorder.[description] LIKE '%bait%'
            THEN 'General Pestec Services'
        WHEN dbo.workorder.[description] LIKE '%pod%'
            THen 'General Pestec Services'
        WHEN dbo.workorder.[description] LIKE '%infest%'
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
    AND dbo.workorder.worktype NOT LIKE 'ST' -- No Standing Work Order
    AND dbo.workorder.ownergroup IN ('M38', 'P38') -- Only East and West Pest Control Group
    AND dbo.workorder.[description] NOT LIKE '%bearbuy%' -- Omit description containing bear buy work order
    AND dbo.workorder.[description] NOT LIKE '%test%' -- Omit Test Work Order
    AND dbo.workorder.[status] NOT LIKE 'can'

    AND dbo.classstructure.classstructureid = 2089 -- WO Classification ID (PEST CONTROL (CAMPUS))

ORDER BY [Pest Category] ASC;
```

## Custodial - Total Labor Hours, Materials, Costs for Event Setup

### List all Labor for Campus
Critera:
* SiteID Campus Only
* A
* Descending Order laborcode (Largest to Smallest)

```sql
SELECT 
    -- Building Inforation
    dbo.workorder.[location] AS 'Building CAAN Number',
    dbo.locations.[description] AS 'Building Description',      -- Building Description from the dbo.locations table
    dbo.locations.roomtype AS 'Room Type',
    dbo.locations.[zone] AS 'Zone Type',
    
    dbo.workorder.wonum AS 'WO Number',
    dbo.workorder.reportdate AS 'WO Report Data',
    dbo.workorder.wopriority AS 'WO Priority',
    dbo.workorder.[description] AS 'WO Description',
    dbo.workorder.[location] AS 'Location CAAN',
    dbo.workorder.worktype AS 'WO Type',
    dbo.workorder.[status] AS 'WO Status',
    dbo.workorder.[owner] AS 'WO Owner',
    dbo.workorder.ownergroup AS 'WO Owner Group',
    

    dbo.workorder.actlabhrs AS 'Actual Labor Hours',
    dbo.workorder.actlabcost AS 'Actual Labor Costs',
    dbo.workorder.actmatcost AS 'Actual Material Costs',
    dbo.workorder.actservcost AS 'Actual Service Cost',
    dbo.workorder.fbms_amountbilled AS 'FBMS Amount Billed',
    dbo.workorder.costcenter AS 'WO Cost Center'
    

FROM dbo.workorder

-- To get the Location Description
INNER JOIN dbo.locations
ON dbo.workorder.[location] = dbo.locations.[location] -- Foreign Key Building CAAN No.

-- To get the Classification Structure Description
LEFT JOIN dbo.classstructure
ON dbo.workorder.classstructureid = dbo.classstructure.classstructureid

WHERE 
    dbo.workorder.orgid = 'UCSF'
    AND dbo.workorder.siteid = 'CAMPUS'
    AND dbo.locations.siteid = 'CAMPUS'
    AND dbo.classstructure.classstructureid = 1967 -- WO Classification ID (EVENT SET-UPS);
```

---

### Tidelands 590 & 600 Cost Center, from Girod Team, PersonGroup M25
Critera:
* Select Fields and Columns
* Cost Center for Tidelands building 590 / 600
* Person Group: M25 


```sql
SELECT  -- Work Order Description
    dbo.workorder.wonum AS 'Work Order Number',
    dbo.workorder.reportdate AS 'Work Order Reported Date',
    dbo.workorder.[description] AS 'Work Order Description',
    dbo.workorder.[location] AS 'Work Order CAAN Location',
    dbo.locations.[description] AS 'Building Description',      -- Building Description from the dbo.locations table
    dbo.workorder.[status] AS 'Work Order Status',
    dbo.workorder.worktype AS 'Work Order Type',
    dbo.workorder.[owner] AS 'Work Order Owner',
    dbo.workorder.ownergroup AS 'Work Order Owner Group',
    
    -- Get WOK Classfication Type
    dbo.workorder.classstructureid AS 'WO Classification Structure ID',
    dbo.classstructure.[classificationid] AS 'WO Classification ID',

    -- Asset & Job Plans
    dbo.workorder.assetnum AS 'Asset Number',
    dbo.workorder.jpnum AS 'Job Plan Number',

    -- Estimate Hours & Costs // For PM Related WOrk Order
    dbo.workorder.estlabhrs AS 'Labor Hours Estimate',
    dbo.workorder.estlabcost AS 'Labor Hours Costs',

    -- Actuals Hours & Costs
    dbo.workorder.actlabhrs AS 'Labor Hours Actuals',
    dbo.workorder.actlabcost AS 'Labor Hours Cost',

FROM dbo.workorder

-- To get the Location Description
INNER JOIN dbo.locations
ON dbo.workorder.[location] = dbo.locations.location -- Foreign Key Building CAAN No.

-- To get the Classification Structure Description
LEFT JOIN dbo.classstructure
ON dbo.workorder.classstructureid = dbo.classstructure.classstructureid

WHERE dbo.workorder.costcenter IN ('CC3065RB', 'CC3065CU', 'CC3065BM', 'CC3065EV', 'CC3065FS', 'CC3065PM', 'CC3065RF', 'CC3065SC', 'CC3065TU',
                                    'CC3064RB', 'CC3064CU', 'CC3064BM', 'CC3064RF', 'CC3064EV', 'CC3064FS', 'CC3064PM', 'CC3064SC', 'CC3064TU')
    AND dbo.workorder.persongroup = 'M25H'
;
```

--- 

### Tidelands 590 & 600 Cost Center, from Girod Team, PersonGroup M25
Critera:
* All PM Information
* All Cost Associated
* Job Plan Information

```sql
SELECT  -- PM Plan Information
        dbo.pm.ltdpmcounter AS 'PM WO Counter',
        dbo.pm.pmnum AS 'PM Plan No.',
        dbo.pm.[description] AS 'PM Deescription',
        dbo.pm.usefrequency AS 'Frequency Value',
        dbo.pm.frequnit AS 'Frequncy Unit',
        dbo.pm.leadtime AS 'Lead Time',
        dbo.pm.nextdate AS 'Next WO Due Date',
        dbo.pm.extdate AS 'Extended Date',
        dbo.pm.masterpm AS 'Master PM',

        -- PM Plan against a Location
        dbo.pm.[location] AS 'Location CAAN',
        dbo.locations.[description] AS 'Building Description',

        -- PM Plan against an Asset
        dbo.pm.assetnum AS 'Asset No',
        dbo.asset.[description] AS 'Asset Description',

        -- PM Plan against a Route
        dbo.pm.[route] AS 'Route',
        dbo.routes.[description] AS 'Route Description',
        -- Count how many Assets in the route
        (SELECT COUNT(dbo.route_stop.[route])
        FROM dbo.route_stop
        WHERE dbo.pm.[route] = dbo.route_stop.[route]) AS 'Asset Count',

        -- Job Plan Information
        dbo.pm.jpnum AS 'Job Plan No.',
        dbo.jobplan.[description] AS 'Job Plan Description',
        (SELECT COUNT(dbo.jobtask.jobplanid)
        FROM dbo.jobtask
        WHERE dbo.jobplan.jobplanid = dbo.jobtask.jobplanid) AS 'Job Plan Tasks Count',

        -- PM Work Order Information
        dbo.pm.wostatus AS 'WO Default Status',
        dbo.pm.[owner] AS 'WO Default Owner',
        dbo.pm.ownergroup AS 'WO Default Owner Group',
        dbo.pm.lead AS 'WO Default Lead',
        dbo.pm.persongroup AS 'WO Default Person Group',
    
        -- PM Plan Cost
        dbo.pm.costcenter AS 'Cost Center',
        dbo.costcenter.[description] AS 'Cost Center Description'
        -- Sub Query || Total Labor Cost
        -- Sub Query || Total Material Cost
        -- Sub Query || Total Service Cost
        -- Sub Query || Total Tool Cost

FROM dbo.pm -- Main Table

-- Use LEFT JOIN as there may be NULL values against asset, locations or routes
LEFT JOIN dbo.locations
ON dbo.pm.[location] = dbo.locations.[location] -- Foreign Key Building CAAN No.

LEFT JOIN dbo.asset
ON dbo.pm.assetnum = dbo.asset.[description] -- Foreign Key for Asset

LEFT JOIN dbo.routes -- Foreign Key for Route
ON dbo.pm.[route] = dbo.routes.route

LEFT JOIN dbo.jobplan -- Foreign Key for Job Plan
ON dbo.pm.jpnum = dbo.jobplan.jpnum

LEFT JOIN dbo.costcenter
ON dbo.pm.costcenter = dbo.costcenter.[description]

WHERE 
        dbo.pm.siteid = 'CAMPUS'
    AND dbo.pm.persongroup = 'M4'
    AND dbo.pm.[status] = 'ACTIVE'
    AND dbo.jobplan.[status] = 'ACTIVE'

ORDER BY 'Asset Count' DESC
```