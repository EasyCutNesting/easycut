del tmp.7z
"C:\Program Files\7-Zip\7z.exe" a -sfx tmp.exe -x!DOSLib*\ -x!ExampleCam\ -x!ExampleDstv\ -x!ExampleDxf\ -x!NestProfessor*\ -x!Release\ -x!VbaModule\ -x!*.7z -x!*.rar -x!*.zip -x!*.exe -x!.git
ren tmp.exe "EasyCutBeta_%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%.exe"

