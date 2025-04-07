Close Data

targetFile = Justpath(Sys(16,0))+'\myregexp2.Dbf'

Try

  If !File(m.targetFile)
    Select * From _regex Into Table (m.targetFile)
    Close Tables All
  Endif

  Use myregexp2 Shared

Catch

Endtry


If !Used('myregexp2')
  Messagebox(' Unable to create or use regex table "'+m.targetFile+'"',32,'VFP RegexTool')
  Return .F.
Endif
