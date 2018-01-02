MERGE INTO dbo.Type  AS Target
USING (values 

	('Rustkamer'),
	('Vechtkamer'),
	('GameKamer'),
	('Werkkamer')

)AS Source (KamerType)
ON Target.KamerType = Source.KamerType
WHEN NOT MATCHED BY TARGET THEN
    INSERT (KamerType)
VALUES (KamerType);