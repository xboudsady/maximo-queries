# Query the Forecast Date

* Tableau Forecast Tool

```sql
SELECT  dbo.pmforecast.pmnum,
        dbo.pm.[description],
        dbo.pmforecast.forecastdate
        

FROM dbo.pmforecast 

LEFT JOIN dbo.pm
    ON dbo.pmforecast.pmnum = dbo.pm.pmnum

WHERE dbo.pmforecast.siteid = 'CAMPUS'
    AND dbo.pmforecast.orgid = 'UCSF'
    AND dbo.pm.siteid = 'CAMPUS'
    AND dbo.pm.[status] = 'ACTIVE';

```