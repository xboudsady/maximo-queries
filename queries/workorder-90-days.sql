SELECT * 

FROM dbo.workorder

WHERE dbo.workorder.reportdate >= DATEADD(MONTH, -3, GETDATE())
    AND dbo.workorder.siteid = 'CAMPUS'
    AND dbo.workorder.istask = 0

ORDER BY dbo.workorder.reportdate DESC;