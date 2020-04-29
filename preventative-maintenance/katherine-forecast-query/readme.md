# PM Forecast by Katherine Dunne

Single query to return both Route and Non Route PM.

```sql
SELECT 
    -- PM TABLE
    maxprod.dbo.pm.pmnum,                   -- PM Number e.g. '1135'
    
    -- ISNULL(expression, value)
    -- Return the specified value IF the expression is NULL, otherwise return the expression
    ISNULL(
            loc1.location,
            ISNULL(
                    loc2.location,
                    ISNULL(
                            loc3.location,
                            loc4.location
                            )
                    )
            ) AS location,                  -- e.g. '3003-02-2M2'
    ISNULL(
            loc1.description,
            ISNULL(
                    loc2.description, 
                    ISNULL(
                            loc3.description, 
                            loc4.description
                            )
                    )
            ) AS locationdesccription,      -- e.g. 'MB Community Ctr (Rutter/21B) - Flr: 02 - Rm: 2M2'

    
    maxprod.dbo.pm.description,     -- e.g. 'PM Cooling Tower Chemical Injection Controller Operational Check - Annual | MBCC-CON-CT'
    maxprod.dbo.pm.siteid,          -- e.g. 'CAMPUS'
    maxprod.dbo.pm.status,          -- e.g. 'ACTIVE'

    -- CAST(expression AS datatype(length))
    -- The CAST() function converts a value (of any type) into a specified datatype.
    CAST(pm.frequency AS VARCHAR(50)) +' ' + pm.frequnit AS frequency,                  -- e.g. '12 MONTHS', '1 MONTHS'



    -- PM Table, ASSET Table, ROUTE_STOP Table
    ISNULL(maxprod.dbo.pm.assetnum, rs.assetnum) AS assetnum,                            -- e.e. 'C25043'
    ISNULL(maxprod.dbo.asset.pmitemid, assetroute.pmitemid) AS pmitemid,                -- e.g. 'MBCC-CON-CT'
    ISNULL(maxprod.dbo.asset.description, assetroute.description) AS assetdescription,   -- e.g. 'Controller & Control Panel, MBCC-CON-CT'
    

    -- PM Table
    maxprod.dbo.pm.costcenter,                                              -- e.g. 'CC3003PM'
    maxprod.dbo.pm.ownergroup,                                              -- e.g. 'M4'
    maxprod.dbo.pm.persongroup,                                             -- e.g. 'M4'
    
    pg.description AS persongroupdescription,    -- e.g. 'Engineers, Mission Bay - East Zone'
    
    -- PMFORECAST Table
    maxprod.dbo.pmforecast.forecastdate,    -- e.g. '2020-09-01 00:00:00.000'
    
    -- ASSET Table
    ISNULL(maxprod.dbo.asset.manufacturer, assetroute.manufacturer) AS manufactuer, -- e.g. 'GARRAT', NULL, 'DOUGLAS'

    -- Classstructure Table
    ISNULL (maxprod.dbo.classstructure.description, cs2.description) AS equipmentclass, -- e.g. 'Controller / Control Panel'
    
    -- Job Plan Table
    jb.description AS jobplandescription,   -- e.g. 'MB Cooling Tower Chemical Injection Controller Operational Check - Annual'
    
    -- Labor Table
    lab.craft,      -- e.g. 'C-BE'
    lab.laborhrs,   -- e.g. '0.25'
    lab.quantity,   -- e.g. 1

    -- Crafts Table
    cr.standardrate,    -- e.g. 154.71
    cr.standardrate * lab.laborhrs AS laborcosts, -- e.g. '38.6775'
    
    maxprod.dbo.pm.route        -- e.g. NULL
             
FROM maxprod.dbo.pm WITH (nolock)   -- MAIN TABLE

-- Only matching PM Numbers, enforce same Site Id
INNER JOIN maxprod.dbo.pmforecast WITH (nolock) 
    ON maxprod.dbo.pm.pmnum = maxprod.dbo.pmforecast.pmnum 
        AND maxprod.dbo.pm.siteid = maxprod.dbo.pmforecast.siteid 

-- Grab Asset Number, return NULL if no asset on PM Table, enforce same Site Id
LEFT OUTER JOIN maxprod.dbo.asset  WITH (nolock) 
    ON maxprod.dbo.pm.assetnum = maxprod.dbo.asset.assetnum 
        AND maxprod.dbo.pm.siteid = maxprod.dbo.asset.siteid 

-- Grab Uniformat Class Structure
LEFT OUTER JOIN maxprod.dbo.classstructure  WITH (nolock)
    ON maxprod.dbo.asset.classstructureid = maxprod.dbo.classstructure.classstructureid 


-- Matching Job Plans Only
INNER JOIN maxprod.dbo.jobplan AS jb  WITH (nolock) 
    -- Enfore Job Plan Numbers Match
    ON maxprod.dbo.pm.jpnum = jb.jpnum 
        -- Same Site Id
        AND maxprod.dbo.pm.siteid = jb.siteid 
        -- Returns latest Job Plan Revisions
        AND jb.pluscrevnum = (
                                SELECT MAX(pluscrevnum) AS Expr1
                                FROM maxprod.dbo.jobplan  AS jbmax  WITH (nolock)
                                WHERE (jb.jpnum = jpnum) 
                                    AND (jb.siteid = siteid)
                                    AND (jb.status = status)
                            ) 

-- Matching Job Labor Hours agains Job Plan Number
INNER JOIN maxprod.dbo.joblabor AS lab 
    ON jb.jpnum = lab.jpnum 
        AND lab.pluscjprevnum = (
                                    SELECT MAX(pluscjprevnum) AS Expr1
                                    FROM maxprod.dbo.joblabor AS maxlab  WITH (nolock)
                                    WHERE (lab.jpnum = jpnum)
                                )

-- Match Craft Code
INNER JOIN maxprod.dbo.craft  WITH (nolock)  
    ON lab.craft = maxprod.dbo.craft.craft 

INNER JOIN maxprod.dbo.craftrate  AS cr  WITH (nolock) 
    ON maxprod.dbo.craft.craft = cr.craft 
        AND cr.vendor IS NULL 

LEFT OUTER JOIN maxprod.dbo.routes AS r   WITH (nolock) 
    ON maxprod.dbo.pm.route = r.route 

LEFT OUTER JOIN maxprod.dbo.route_stop AS rs  WITH (nolock) 
    ON r.route = rs.route

LEFT JOIN maxprod.dbo.asset AS assetroute  WITH (nolock) 
    ON rs.assetnum = assetroute.assetnum

LEFT OUTER JOIN maxprod.dbo.classstructure AS cs2  WITH (nolock) 
    ON assetroute.classstructureid = cs2.classstructureid
                    
LEFT JOIN maxprod.dbo.locations AS loc1   WITH (nolock) 
    ON pm.location = loc1.location 
        AND pm.siteid = loc1.siteid
                    
LEFT JOIN  maxprod.dbo.locations AS loc2  WITH (nolock)  
    ON asset.location = loc2.location  
        AND pm.siteid = loc2.siteid
                    
LEFT JOIN  maxprod.dbo.locations AS loc3  WITH (nolock)  
    ON assetroute.location = loc3.location 
        AND pm.siteid = loc3.siteid
    
LEFT JOIN  maxprod.dbo.locations AS loc4  WITH (nolock) 
    ON rs.location = loc4.location 
        AND pm.siteid = loc4.siteid

LEFT JOIN maxprod.dbo.persongroup AS pg  WITH (nolock) 
    ON pm.persongroup = pg.persongroup
 
WHERE (maxprod.dbo.pm.siteid = 'campus')
    AND (jb.status = 'active')

```