del tmp.7z
"C:\Program Files\7-Zip\7z.exe" a tmp.7z -x!.git*\ -x!.vscode*\ -x!DOSLib*\ -x!Release\ -x!*.7z -x!*.rar -x!*.zip
ren tmp.7z "EasyCutBeta_%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%.7z"

