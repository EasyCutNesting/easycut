(defun FormsOpenFileDialog (LstParameter / LM:lst->str LM:StringSubst PurgePath ReadFile
										   PathStart FileSearch Filter Title Multiselect
										   Rtn)
	
	; Lst Parameter
	;
	;	0 InitialDirectory
	;   1 FileName
	;   2 Filter
	;   3 Title
	;   4 Multiselect
	;
	(defun LM:lst->str ( lst del / str )
		(setq str (car lst))
		(foreach itm (cdr lst) (setq str (strcat str del itm)))
		str
	)
	;
	(defun LM:StringSubst ( new old str / inc len )
		(setq len (strlen new)
			  inc 0
		)
		(while (setq inc (vl-string-search old str inc))
			(setq str (vl-string-subst new old str inc)
				  inc (+ inc len)
			)
		)
		str
	)
	;
	(defun PurgePath (Path / SplitPath)
	
		(defun SplitPath (Path Char)
			(if (and Path Char)
				(LM:lst->str (SpliTxt Path Char) Char)
			)
		)
		(if Path
			(if (/= Path "")
				(SplitPath (LM:StringSubst "\\" "/" Path) "\\")
			)
		)
	)
	;
	(defun ReadFile (FileName FileCheck / Stream Line Rtn)
		(while (not (findfile FileCheck)))
		(setq Stream (open FileName "r"))
		(while (setq Line (read-line Stream))
			(if (/= (setq Line (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))) "")
				(if (/= (vl-filename-directory Line) "") 
					(setq Rtn (cons Line Rtn))
				)
			)
		)
		(close Stream)
		Rtn
	)
	;
	; Main
	;				   0     1    2         3          4
	;LstParameter (PathFile nil "*.*" "Explorer File" nil) nil))
	(if (not (setq PathStart   (nth 0 LstParameter))) (setq PathStart (getenv "USERPROFILE"))) 
	(if (not (setq FileSearch  (nth 1 LstParameter))) (setq FileSearch ""))
	(if (not (setq Filter      (nth 2 LstParameter))) (setq Filter "(*.*)"))
	(if (not (setq Title       (nth 3 LstParameter))) (setq Title "FileDialog"))
	(if (not (setq MultiSelect (nth 4 LstParameter))) (setq MultiSelect "$false") (setq MultiSelect "$true"))
	
	
	(if dcl-SelectFiles
		(dcl-SelectFiles  (strcat "Files " Filter "|" Filter ) Title PathStart)
		(if (setq Rtn (OpenFileDialog  (list PathStart FileSearch Filter Title Multiselect)))
				(list (strcat (car Rtn) "\\" (cadr Rtn)))
		)
	)
)
;
;(FormsOpenFileDialog '("C:\\test" "install.dwg" "Dwg File (*.dwg)|*.dwg|Zip File (*.zip)|*.dwg|All File (*.*)|*.*"	"Explorer File"	nil) nil)
;(FormsOpenFileDialog (list (getenv "USERPROFILE") "" "All File (*.*)|*.*" "Explorer File" nil) nil)
;(defun FormsOpenFileDialog (LstParameter Verbose / PurgePath ReadFile
;												   PathStart FileSearch Filter Title Multiselect
;												   FilePS FileOut FileJs FileChk
;												   Stream x Rtn)
;	
;	; Lst Parameter
;	;
;	;	0 InitialDirectory
;	;   1 FileName
;	;   2 Filter
;	;   3 Title
;	;   4 Multiselect
;	;
;	(defun PurgePath (Path / SplitPath)
;	
;		(defun SplitPath (Path Char)
;			(if (and Path Char)
;				(LM:lst->str (SpliTxt Path Char) Char)
;			)
;		)
;		(if Path
;			(if (/= Path "")
;				(SplitPath (LM:StringSubst "\\" "/" Path) "\\")
;			)
;		)
;	)
;	;
;	(defun ReadFile (FileName FileCheck / Stream Line Rtn)
;		(while (not (findfile FileCheck)))
;		(setq Stream (open FileName "r"))
;		(while (setq Line (read-line Stream))
;			(if (/= (setq Line (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))) "")
;				(if (/= (vl-filename-directory Line) "") 
;					(setq Rtn (cons Line Rtn))
;				)
;			)
;		)
;		(close Stream)
;		Rtn
;	)
;	;
;	; Main
;	;
;	(if (not (setq PathStart   (nth 0 LstParameter))) (setq PathStart (getenv "USERPROFILE"))) 
;	(if (not (setq FileSearch  (nth 1 LstParameter))) (setq FileSearch ""))
;	(if (not (setq Filter      (nth 2 LstParameter))) (setq Filter "*.*"))
;	(if (not (setq Title       (nth 3 LstParameter))) (setq Title "FileDialog"))
;	(if (not (setq MultiSelect (nth 4 LstParameter))) (setq MultiSelect "$false") (setq MultiSelect "$true"))
;	
;   (setq FilePS		 (vl-filename-mktemp "EasyCut.ps1"))
;	(setq FileOut 		 (vl-filename-mktemp "EasyCut.out"))
;	(setq FileJs 		 (vl-filename-mktemp "EasyCut.js" ))
;	(setq FileChk 		 (vl-filename-mktemp "EasyCut.chk"))
;	
;	
;   (setq Stream (open FilePS "w"))
;  	(foreach x	(list	"Add-Type -AssemblyName System.Windows.Forms"
;						"# https://docs.microsoft.com/it-it/dotnet/api/system.windows.forms.openfiledialog?view=net-5.0"
;						"$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog"
;						(strcat "$FileBrowser.InitialDirectory = " 		(chr 34) PathStart (chr 34))
;						(strcat "$FileBrowser.Title = "            		(chr 34) Title (chr 34))
;						(strcat "$FileBrowser.Multiselect = "       	MultiSelect)
;						(strcat "$FileBrowser.FileName = "         		(chr 34) FileSearch (chr 34))
;						(strcat "$FileBrowser.Filter = '"          		Filter "'")
;						"$FileBrowser.CheckFileExists = $false"
;						"$FileBrowser.ShowDialog() | Out-Null"
;						(strcat "$stream = [System.IO.StreamWriter] " 	(chr 34) FileOut (chr 34))
;						"foreach($fullFilePath in $FileBrowser.FileNames)"
;						"	{"
;						"		$stream.WriteLine($fullFilePath)"
;						"	}"					
;						"$stream.close()"
;						(strcat "New-Item -Path '" FileChk "' -ItemType " (chr 34) "File" (chr 34) " | Out-Null")
;               )			
;               (write-line x Stream)
;	)
;   (close Stream)
;
;   (setq Stream (open FileJs "w"))
;   (foreach x  (list	"var wshShell = new ActiveXObject(\"WScript.Shell\");"
;						(strcat "wshShell.Run('%SystemRoot%\\\\system32\\\\WindowsPowerShell\\\\v1.0\\\\powershell.exe -Version 2 -Nologo -Sta -ExecutionPolicy Bypass -File " 
;								(chr 34) (LM:StringSubst "\\\\" "\\" FilePS)  (chr 34) 
;								"', 0, false);")	
;				)
;				(write-line x Stream)
;	)
;   (close Stream)
;	(if Verbose
;		(progn
;			(EasyCutViewer FilePS)
;			(EasyCutViewer FileJs)
;			(princ "\n-->") (princ FilePS)
;			(princ "\n-->") (princ FileOut)
;			(princ "\n-->") (princ FileJs)
;			(princ "\n-->") (princ FileChk)
;		)
;	)
;	(startapp (strcat "wscript " FileJs))
;	(setq Rtn (ReadFile FileOut FileChk))
;	(vl-file-delete FilePS)
;	(vl-file-delete FileOut)
;	(vl-file-delete FileJs)
;	(vl-file-delete FileChk)
;	Rtn
;)