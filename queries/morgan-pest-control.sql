-- Pest Control for Morgan

SELECT TOP 100 * FROM dbo.workorder;

SELECT 
    dbo.workorder.assetnum AS 'Asset Number',
    dbo.workorder.[description] AS 'Work Order Description',
    dbo.workorder.wonum AS 'Work Order Number',


FROM dbo.workorder;