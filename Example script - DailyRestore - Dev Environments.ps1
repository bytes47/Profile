Import-Module SQLPS –DisableNameChecking

net stop Microsoft.Dynamics.AX.Framework.Tools.DMF.SSISHelperService.exe
net stop DynamicsAxBatch
net stop MR2012ProcessService
net stop W3SVC
net stop MSSQLSERVER
net start MSSQLSERVER

Restore-SqlDatabase -ServerInstance localhost -Database AxDB -BackupFile "J:\DailyRestore\AxDB_20220516_TRAIN_Official.bak" -ReplaceDatabase

net start Microsoft.Dynamics.AX.Framework.Tools.DMF.SSISHelperService.exe
net start DynamicsAxBatch
net start MR2012ProcessService
net start W3SVC

k:\AosService\PackagesLocalDirectory\bin\syncengine.exe -syncmode="fullall" -metadatabinaries="k:\AosService\PackagesLocalDirectory" -connect="Data Source=localhost;Initial Catalog=AxDB;Integrated Security=True;Enlist=True;Application Name=AXVSSDK" -verbosity="Minimal"

