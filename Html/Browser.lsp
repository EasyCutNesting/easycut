;
;ProgramFiles=C:\Program Files
;ProgramFiles(x86)=C:\Program Files (x86)
;ProgramW6432=C:\Program Files
;LOCALAPPDATA=C:\Users\delucaa\AppData\Local
;
(setq ListBrowserCheckEasyCut$ (list "opera"
								     "firefox"
								     "chrome"
								     "iexplore"
								     "edge"
									 "brave"
									 "torch"
									 "uc"
                                     "maxthon"
								     "avant"
									 "ccleaner browser"
								     "vivaldi"))

;
;
;
(defun GetPathDefaultBrowser (/ Reg Rtn SplitRtn Path Loop)

	(setq Reg (vl-registry-read "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\Shell\\Associations\\UrlAssociations\\http\\UserChoice" "Progid"))
	(if Reg
		(if (not (setq Rtn (vl-registry-read (strcat "HKEY_LOCAL_MACHINE\\Software\\Classes\\" Reg "\\Shell\\Open\\Command"))))
			     (setq Rtn (vl-registry-read (strcat "HKEY_CURRENT_USER\\Software\\Classes\\"  Reg "\\Shell\\Open\\Command")))
		)
		(progn
			(if (setq Reg (vl-registry-read "HKEY_CURRENT_USER\\Software\\Classes\\ftp\\shell\\open\\command"))   (setq Rtn Reg))
			(if (setq Reg (vl-registry-read "HKEY_CURRENT_USER\\Software\\Classes\\http\\shell\\open\\command"))  (setq Rtn Reg))
			(if (setq Reg (vl-registry-read "HKEY_CURRENT_USER\\Software\\Classes\\https\\shell\\open\\command")) (setq Rtn Reg))
		)
	)
	
	(if Rtn
		(progn
			(if (= (substr Rtn 1 1) (chr 34))  (setq Rtn (substr Rtn 2 (strlen Rtn))))
			(setq SplitRtn (splitxt Rtn "\\"))
			(setq Path "")
			(setq Loop T)
			(foreach itm SplitRtn
				(if Loop
					(progn
						(if (vl-string-search ".exe" itm)
							(progn
								(setq Path (strcat Path (car (splitxt itm ".")) ".exe"))
								(setq Loop nil)
							)
							(setq Path (strcat Path itm "\\"))
						)
					)
				)
			)
		)
	)
	Path
)
			

;(NavigateEdge "https://www.easycutnesting.it")
(defun NavigateEdge ( url / ie )
	(if url
		(vl-cmdf "_.SHELL" (strcat "start Microsoft-edge:" url))
	)
)
;
;
;
(defun NavigateTo (Browser url / sa)
	(if (and Browser url)
		(progn
			;(setq url (strcat "\"" (vl-string-translate "/" "\\" url) "\""))
			;(setq sa (vlax-get-or-create-object "Shell.Application"))
			;(null (vlax-invoke sa 'shellexecute Browser url))
			;(vlax-release-object sa)
			;(foreach itm (GetListBrowser)
			;	(if (vl-string-search (strcase Browser) (strcase itm))
					(startapp Browser (strcat (chr 34) url (chr 34)))
			;	)
			;)
		)
	)
)
;
;
;(defaultbrowser "l:\\CAD Web\\Display\\cadweb.html")
(defun DefaultBrowser ( url / NameBrowser)
	(if url
		(progn
			(setq url (vl-string-translate "/" "\\" url))
			(if (not DefaultBrowserEasyCut$)
			    (setq DefaultBrowserEasyCut$ (GetNameBrowserDefaultToRegistry))
			)
			(NavigateTo DefaultBrowserEasyCut$ url)
		)
	)
)
;
;
;
(defun GetNameBrowserDefaultToRegistry (/ VW Rtn)

	(if (setq VW (vl-registry-read "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion" "ProductName"))
		(cond 
			((vl-string-search (strcase "windows 10") (strcase VW))
				(setq Rtn (GetPathDefaultBrowser))
			)
			((vl-string-search (strcase "Windows 7") (strcase VW))
				(setq Rtn (GetPathDefaultBrowser))
			)
			
			(t
				; < Windows 10 HKEY_CURRENT_USER\SOFTWARE\Clients\StartMenuInternet
			)
		)
	)
	Rtn
)
;
;
;
;(defun InternetStatus (Verbose / FileJs Stream x Loop Rtn)
;
;	(setq FileJs (vl-filename-mktemp "EasyCut.js" ))
;    (setq Stream (open FileJs "w"))
;    (foreach x  (list	"var wshShell = new ActiveXObject(\"WScript.Shell\");"
;						(strcat "wshShell.Run('" 	(chr 34)	(LM:StringSubst "/" "\\" 
;																	(strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "/Apps/EasyCutInternetAccess.exe")
;																) 
;													(chr 34) 
;													"', 0, false);")
;				)
;				(write-line x Stream)
;	)
;   (close Stream)
;	
;	(vl-registry-write EasyCutRegistryPath$ "Internet" "")
;	;(startapp (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Apps\\EasyCutInternetAccessForm.exe"))
;	(startapp (strcat "wscript " (chr 34) FileJs (chr 34)))
;	(setq Loop T)
;	(while Loop
;		(setq Rtn (vl-registry-read EasyCutRegistryPath$ "Internet"))
;		(if (/= Rtn "") (setq Loop nil))
;	)
;	(vl-file-delete FileJs)
;	(if Verbose 
;		Rtn
;		(progn 
;			(if (vl-string-search "[NoInt]" Rtn)
;				nil
;				T
;			)
;		)
;	)
;)		
;
;Default app
;(command "browser" "https://www.easycutnesting.it")
;
;
(defun GetListBrowser (/ Mwcmatch FindSubPath
						 itm1 itm2 LstRegistry TreeShell ExeBrowser Rgy SubRgy Brs LstFound Exe LstDataBrowser LstPathSearch LstExe RtnExe)

	;
	(defun Mwcmatch (Text1 Text2 / Num Rtn)
		(setq Num 1)
		(if (and Text1 Text2)
			(repeat (+ (- (strlen Text2) (strlen Text1)) 1)
				(if (= (strcase (substr Text2 Num (strlen Text1))) (strcase Text1))
					(setq Rtn T)
				)
				(setq num (1+ Num))
			)
		)
		Rtn
	)
	;
	;
	;
	(defun FindSubPath (PathSearch Path / PosNth Rtn)
		
		(if (and PathSearch Path)
			(if (and (> (strlen Path) 0) (> (strlen PathSearch) 0))
				(progn
					(setq LstPathSearch (splitxt PathSearch "\\"))
					(setq LstPath		(splitxt Path "\\"))
					(if (>= (length LstPath) (length LstPathSearch))
						(progn
							(setq PosNth (- (length LstPath) (length (member (car LstPathSearch) LstPath))))
							(foreach itm LstPathSearch
								(if (not (equal itm (nth PosNth LstPath)))
									(setq Rtn -1)
								)
								(setq PosNth (1+ PosNth))
							)
						)
						(setq Rtn -1)
					)
				)
				(setq Rtn -1)
			)
			(setq Rtn -1)
		)
		(if (not Rtn) 
			T
			nil
		)
	)
	;
	;
	(setq LstRegistry (list "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\App Paths"						;opera.exe
							"HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\App Paths"						;(*.exe)
							"HKEY_LOCAL_MACHINE\\Software\\Clients\\StartMenuInternet"
							"HKEY_LOCAL_MACHINE\\Software\\WOW6432Node\\Clients\\StartMenuInternet"
							"HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\App Paths"))		;(*.exe)
	
	(setq TreeShell  "\\shell\\open\\command")
	(setq ExeBrowser ".exe")
	;
	(foreach Rgy LstRegistry
		(foreach SubRgy (setq LstSubRegistry (vl-registry-descendents Rgy))
			(foreach Brs ListBrowserCheckEasyCut$
				(if (Mwcmatch Brs SubRgy)
					(setq LstFound (append LstFound (list SubRgy)))
				)
			)
		)
	)
	; 1°
	(foreach Rgy LstRegistry
		(foreach Brs LstFound
			(if (setq Exe (vl-registry-read (strcat  Rgy "\\" Brs TreeShell)))
				(progn
					(if (= (substr Exe 1 1) (chr 34))            (setq Exe (substr Exe 2 (strlen Exe))))
					(if (= (substr Exe (strlen Exe) 1) (chr 34)) (setq Exe (substr Exe 1 (- (strlen Exe) 1))))
					(if (findfile Exe)
						(if (not (member (strcase Exe T) LstExe)) (setq LstExe (append LstExe (list (strcase Exe T)))))
					)
				)
			)
		)
	)
	; 2°
	(foreach Rgy LstRegistry
		(foreach Brs LstFound
			(if (Mwcmatch ExeBrowser Brs)
				(if (setq Exe (vl-registry-read (strcat  Rgy "\\" Brs)))
					(progn
						(if (= (substr Exe 1 1) (chr 34))            (setq Exe (substr Exe 2 (strlen Exe))))
						(if (= (substr Exe (strlen Exe) 1) (chr 34)) (setq Exe (substr Exe 1 (- (strlen Exe) 1))))
						(if (findfile Exe)
							(if (not (member (strcase Exe T) LstExe)) (setq LstExe (append LstExe (list (strcase Exe T)))))
						)
					)
				)
			)
		)
	)
	;
	(if (not (member (getenv "ProgramFiles")		LstPathSearch)) 	(setq LstPathSearch (cons (getenv "ProgramFiles") 		LstPathSearch)))
	(if (not (member (getenv "ProgramFiles(x86)")	LstPathSearch))		(setq LstPathSearch (cons (getenv "ProgramFiles(x86)")	LstPathSearch)))
	(if (not (member (getenv "ProgramW6432")		LstPathSearch))		(setq LstPathSearch (cons (getenv "ProgramW6432")		LstPathSearch)))
	(if (not (member (getenv "LOCALAPPDATA")		LstPathSearch))		(setq LstPathSearch (cons (getenv "LOCALAPPDATA")		LstPathSearch)))
	;
	(foreach itm1 (LM:Unique LstPathSearch)
		(foreach itm2 LstExe
			(if (FindSubPath (strcase itm1) (strcase itm2))
				(setq RtnExe (cons (strcase itm2 T) RtnExe))
			)
		)
	)
	; Edge 
	(if (setq Exe (findfile (strcat (getenv "systemroot") "\\SystemApps\\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\\MicrosoftEdge.exe")))
		(setq RtnExe (cons (strcase Exe T) RtnExe))
	)
	RtnExe
)
;
;
;
(defun GuiLstBrowser (/ ActiveBrowser TestBrowser
						Defaultbrowser xx itm LstDataBrowser Num x y OtherBrowser ActiveOtherBrowser PathOtherBrowser)
	
	(defun ActiveBrowser ()
		(if (/= (get_tile "DifferentBrowser") "")
			(cond
				((= (get_tile "ActiveBrowser") "1")
					(setq DefaultBrowserEasyCut$ (get_tile "DifferentBrowser"))
					(vl-registry-write EasyCutRegistryPath$ "PathOtherBrowser"  (strcat DefaultBrowserEasyCut$ "*1"))
				)
				((= (get_tile "ActiveBrowser") "0")
					(setq DefaultBrowserEasyCut$ (GetNameBrowserDefaultToRegistry))
					(vl-registry-write EasyCutRegistryPath$ "PathOtherBrowser"  (strcat (get_tile "DifferentBrowser") "*0"))
				)
			)
			(progn
				(setq DefaultBrowserEasyCut$ (GetNameBrowserDefaultToRegistry))
				(vl-registry-write EasyCutRegistryPath$ "PathOtherBrowser" "")
			)
		)
		
	)
	;
	(defun TestBrowser( / Browser)
		(if (/= (get_tile "DifferentBrowser") "")
			(cond
				((= (get_tile "ActiveBrowser") "1")
					(setq Browser (get_tile "DifferentBrowser"))
				)
				((= (get_tile "ActiveBrowser") "0")
					(setq Browser (GetNameBrowserDefaultToRegistry))
				)
			)
			(setq Browser (GetNameBrowserDefaultToRegistry))
		)
		(startapp Browser "https://www.easycutnesting.it/")
	)
	;
	; Main
	;
	(setq DefaultBrowser (GetNameBrowserDefaultToRegistry))
	
	(foreach itm (GetListBrowser)
	
			(cond
				((and (vl-string-search (strcase "LaunchWinApp.exe")  (strcase DefaultBrowser))
					  (vl-string-search (strcase "MicrosoftEdge.exe") (strcase itm)))
					(setq LstDataBrowser (append LstDataBrowser (list (strcat "MicrosoftEdge"  "\t" "installed" "\t" "Browser Default" "\t" itm))))
				)
			
				((equal (strcase DefaultBrowser) (strcase itm))
					(setq LstDataBrowser (append LstDataBrowser (list (strcat (vl-filename-base itm)  "\t" "installed" "\t" "Browser Default" "\t" itm))))
				)
				(t
					(setq LstDataBrowser (append LstDataBrowser (list (strcat (vl-filename-base itm)  "\t" "installed" "\t" " "               "\t" itm))))
				)
			)
	)
	
	(setq OtherBrowser (vl-registry-read EasyCutRegistryPath$ "PathOtherBrowser"))
	(if (and (/= OtherBrowser "") (vl-string-search "*" OtherBrowser))
		(progn		 	
			(setq PathOtherBrowser   (car  (splitxt OtherBrowser "*"))) 
			(setq ActiveOtherBrowser (cadr (splitxt OtherBrowser "*")))
		)
		(setq ActiveOtherBrowser "0")
	)

	(if (not (findfile 	(strcat SetupPathEasyCut$ "avant120x120.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "avant120x120.sld")           (strcat SetupPathEasyCut$ "avant120x120.sld")))

	(if (not (findfile 	(strcat SetupPathEasyCut$ "brave120x120.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "brave120x120.sld")           (strcat SetupPathEasyCut$ "brave120x120.sld")))

	(if (not (findfile 	(strcat SetupPathEasyCut$ "ccleanerbrowser120x120.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "ccleanerbrowser120x120.sld") (strcat SetupPathEasyCut$ "ccleanerbrowser120x120.sld")))

	(if (not (findfile 	(strcat SetupPathEasyCut$ "chrome120x120.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "chrome120x120.sld")          (strcat SetupPathEasyCut$ "chrome120x120.sld")))

	(if (not (findfile 	(strcat SetupPathEasyCut$ "edge120x120.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "edge120x120.sld")            (strcat SetupPathEasyCut$ "edge120x120.sld")))

	(if (not (findfile 	(strcat SetupPathEasyCut$ "firefox120x120.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "firefox120x120.sld")         (strcat SetupPathEasyCut$ "firefox120x120.sld")))

	(if (not (findfile 	(strcat SetupPathEasyCut$ "iexplorer120x120.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "iexplorer120x120.sld")       (strcat SetupPathEasyCut$ "iexplorer120x120.sld")))

	(if (not (findfile 	(strcat SetupPathEasyCut$ "maxthon120x120.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "maxthon120x120.sld")         (strcat SetupPathEasyCut$ "maxthon120x120.sld")))

	(if (not (findfile 	(strcat SetupPathEasyCut$ "opera120x120.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "opera120x120.sld")           (strcat SetupPathEasyCut$ "opera120x120.sld")))

	(if (not (findfile 	(strcat SetupPathEasyCut$ "torch120x120.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "torch120x120.sld")           (strcat SetupPathEasyCut$ "torch120x120.sld")))

	(if (not (findfile 	(strcat SetupPathEasyCut$ "uc120x120.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "uc120x120.sld")              (strcat SetupPathEasyCut$ "uc120x120.sld")))

	(if (not (findfile 	(strcat SetupPathEasyCut$ "vivaldi120x120.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "vivaldi120x120.sld")         (strcat SetupPathEasyCut$ "vivaldi120x120.sld")))


	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "BrowserSetup" xx "" (cond ( *BrowserSetup* ) ( '(-1 -1) )))
	(start_list "box_info")
		(mapcar 'add_list LstDataBrowser)
	(end_list)
	
	(if ActiveOtherBrowser (set_tile "ActiveBrowser" ActiveOtherBrowser))
	
	(if (= ActiveOtherBrowser "0")	; tutto spento
		(progn 
			(mode_tile "TxtDifferentBrowser" 1)
			(mode_tile "DifferentBrowser"    1)
			(mode_tile "PathSearch"          1)
		)
		(progn
			(mode_tile "box_info"            1)
		)
	)
	(if PathOtherBrowser (set_tile "DifferentBrowser" PathOtherBrowser))
		
	(setq x (dimx_tile "image1")) ;get image tile width
	(setq y (dimy_tile "image1")) ;get image tile heigth
	
	(start_image "image1")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "avant120x120.sld"))
	(end_image)			
	(start_image "image2")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "brave120x120.sld"))
	(end_image)		
	(start_image "image3")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "ccleanerbrowser120x120.sld"))
	(end_image)			
	(start_image "image4")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "chrome120x120.sld"))
	(end_image)			
	(start_image "image5")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "edge120x120.sld"))
	(end_image)	
	(start_image "image6")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "firefox120x120.sld"))
	(end_image)			
	(start_image "image7")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "iexplorer120x120.sld"))
	(end_image)			
	(start_image "image8")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "maxthon120x120.sld"))
	(end_image)			
	(start_image "image9")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "opera120x120.sld"))
	(end_image)			
	(start_image "image10")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "torch120x120.sld"))
	(end_image)			
	(start_image "image11")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "uc120x120.sld"))
	(end_image)			
	(start_image "image12")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "vivaldi120x120.sld"))
	(end_image)	


	(action_tile "PathSearch" (strcat "(if (setq PathBrowser (LM:getfiles \"Seleziona file\" \"\" \"exe\"))"
										  "(progn (vl-registry-write EasyCutRegistryPath$ \"PathOtherBrowser\"  (strcat (car PathBrowser) \"*1\"))"
												 "(set_tile \"DifferentBrowser\" (car PathBrowser))))"))
	
	(action_tile "ActiveBrowser" (strcat "(if (= (get_tile \"ActiveBrowser\") \"0\")"
										 "(progn (mode_tile \"DifferentBrowser\" 1)	(mode_tile \"TxtDifferentBrowser\" 1) (mode_tile \"PathSearch\" 1) (mode_tile \"box_info\" 0))"
										 "(progn (mode_tile \"DifferentBrowser\" 0)	(mode_tile \"TxtDifferentBrowser\" 0) (mode_tile \"PathSearch\" 0) (mode_tile \"box_info\" 1)))"
								 ))
							
	(action_tile "accept"		(strcat "(ActiveBrowser)"
										"(setq *BrowserSetup* (done_dialog)) (unload_dialog xx)"
								))
								
	(action_tile "testbrowser"	"(TestBrowser)")
	
	(start_dialog)
	
)