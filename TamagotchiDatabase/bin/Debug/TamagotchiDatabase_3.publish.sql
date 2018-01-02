﻿/*
Deployment script for TamagotchiHotel

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "TamagotchiHotel"
:setvar DefaultFilePrefix "TamagotchiHotel"
:setvar DefaultDataPath "C:\Users\adam-\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\TamagotchiHotel"
:setvar DefaultLogPath "C:\Users\adam-\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\TamagotchiHotel"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
The column [dbo].[Tamagotchi].[Kleur] on table [dbo].[Tamagotchi] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
*/

IF EXISTS (select top 1 1 from [dbo].[Tamagotchi])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Rename refactoring operation with key 8d9ade1c-37f3-4e29-bd2a-382ed3c21431 is skipped, element [dbo].[Type].[Id] (SqlSimpleColumn) will not be renamed to KamerType';


GO
PRINT N'Dropping unnamed constraint on [dbo].[Tamagotchi]...';


GO
ALTER TABLE [dbo].[Tamagotchi] DROP CONSTRAINT [DF__tmp_ms_xx__Leeft__3E52440B];


GO
PRINT N'Dropping unnamed constraint on [dbo].[Tamagotchi]...';


GO
ALTER TABLE [dbo].[Tamagotchi] DROP CONSTRAINT [DF__tmp_ms_xx__Centj__3F466844];


GO
PRINT N'Dropping unnamed constraint on [dbo].[Tamagotchi]...';


GO
ALTER TABLE [dbo].[Tamagotchi] DROP CONSTRAINT [DF__tmp_ms_xx__Level__403A8C7D];


GO
PRINT N'Dropping unnamed constraint on [dbo].[Tamagotchi]...';


GO
ALTER TABLE [dbo].[Tamagotchi] DROP CONSTRAINT [DF__tmp_ms_xx__Gezon__412EB0B6];


GO
PRINT N'Dropping unnamed constraint on [dbo].[Tamagotchi]...';


GO
ALTER TABLE [dbo].[Tamagotchi] DROP CONSTRAINT [DF__tmp_ms_xx__Verve__4222D4EF];


GO
PRINT N'Dropping unnamed constraint on [dbo].[Tamagotchi]...';


GO
ALTER TABLE [dbo].[Tamagotchi] DROP CONSTRAINT [DF__tmp_ms_xx___Dood__4316F928];


GO
PRINT N'Starting rebuilding table [dbo].[Tamagotchi]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Tamagotchi] (
    [Id]         INT        NOT NULL,
    [Naam]       NCHAR (10) NOT NULL,
    [Kleur]      NCHAR (10) NOT NULL,
    [Leeftijd]   INT        DEFAULT 0 NOT NULL,
    [Centjes]    INT        DEFAULT 100 NOT NULL,
    [Level]      INT        DEFAULT 0 NOT NULL,
    [Gezondheid] INT        DEFAULT 100 NOT NULL,
    [Verveling]  INT        DEFAULT 0 NOT NULL,
    [Dood]       BIT        DEFAULT 0 NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Tamagotchi])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Tamagotchi] ([Id], [Naam], [Leeftijd], [Centjes], [Level], [Gezondheid], [Verveling], [Dood])
        SELECT   [Id],
                 [Naam],
                 [Leeftijd],
                 [Centjes],
                 [Level],
                 [Gezondheid],
                 [Verveling],
                 [Dood]
        FROM     [dbo].[Tamagotchi]
        ORDER BY [Id] ASC;
    END

DROP TABLE [dbo].[Tamagotchi];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Tamagotchi]', N'Tamagotchi';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[HotelKamer]...';


GO
CREATE TABLE [dbo].[HotelKamer] (
    [Id]                INT           NOT NULL,
    [TamagotchiID]      INT           NOT NULL,
    [HoeveelheidBedden] INT           NOT NULL,
    [KamerType]         NVARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC, [TamagotchiID] ASC)
);


GO
PRINT N'Creating [dbo].[Type]...';


GO
CREATE TABLE [dbo].[Type] (
    [KamerType] NVARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([KamerType] ASC)
);


GO
PRINT N'Creating unnamed constraint on [dbo].[HotelKamer]...';


GO
ALTER TABLE [dbo].[HotelKamer]
    ADD DEFAULT 2 FOR [HoeveelheidBedden];


GO
PRINT N'Creating [dbo].[FK_HotelKamer_Tamagotchi]...';


GO
ALTER TABLE [dbo].[HotelKamer] WITH NOCHECK
    ADD CONSTRAINT [FK_HotelKamer_Tamagotchi] FOREIGN KEY ([TamagotchiID]) REFERENCES [dbo].[Tamagotchi] ([Id]) ON UPDATE CASCADE;


GO
PRINT N'Creating [dbo].[FK_HotelKamer_Type]...';


GO
ALTER TABLE [dbo].[HotelKamer] WITH NOCHECK
    ADD CONSTRAINT [FK_HotelKamer_Type] FOREIGN KEY ([KamerType]) REFERENCES [dbo].[Type] ([KamerType]) ON UPDATE CASCADE;


GO
-- Refactoring step to update target server with deployed transaction logs
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '8d9ade1c-37f3-4e29-bd2a-382ed3c21431')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('8d9ade1c-37f3-4e29-bd2a-382ed3c21431')

GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[HotelKamer] WITH CHECK CHECK CONSTRAINT [FK_HotelKamer_Tamagotchi];

ALTER TABLE [dbo].[HotelKamer] WITH CHECK CHECK CONSTRAINT [FK_HotelKamer_Type];


GO
PRINT N'Update complete.';


GO
