(setq EasyCutRegistryPath$	"HKEY_CURRENT_USER\\Software\\EasyCut")
(setq Drawing (getvar "DWGNAME"))
(if (= (strcase Drawing) "INSTALL.DWG")
	(progn
		(setq 	Version				"Nothing"
				PathWork 			(strcat (getenv "USERPROFILE") "\\EasyCut")
				PathNc				(strcat PathWork "\\Cnc")
				PathInfo			(strcat PathWork "\\Info")
				PathOutput			(strcat PathWork "\\Output")
				PathDocs			(strcat PathWork "\\Output\\Docs")
				PathNesting			(strcat PathWork "\\Output\\Dxfnestings")
				PathdxfJob			""
				DefaultPathCfg		(strcat (getenv "LOCALAPPDATA") "\\EasyCut")
				DefaultFileCfg		"Default.cfg"
				PathCfg				DefaultPathCfg			
				FileCfg				DefaultFileCfg			
				ArrayColumn			"1"
				ArrayRow			"2"
				Leader				""
				Symula				"0"
				SymulaChoiseShape	"10"
				Sentinel			"0"
				;Internet            ""
				Imaging				"Imaging"
				Key1 				""
				Key2 				""
				Key3 				""
				PathOtherBrowser    ""
		)
		(vl-registry-write EasyCutRegistryPath$ "PathInstaller" (substr (getvar "DWGPREFIX") 1 (- (strlen (getvar "DWGPREFIX")) 1)))
		(if (not (vl-registry-read EasyCutRegistryPath$ "Version")) 			(vl-registry-write EasyCutRegistryPath$ "Version" 			Version))
		(if (not (vl-registry-read EasyCutRegistryPath$ "PathWork"))			(vl-registry-write EasyCutRegistryPath$ "PathWork" 			PathWork))
		(if (not (vl-registry-read EasyCutRegistryPath$ "PathNc"))				(vl-registry-write EasyCutRegistryPath$ "PathNc" 			PathNc))
		(if (not (vl-registry-read EasyCutRegistryPath$ "PathInfo"))			(vl-registry-write EasyCutRegistryPath$ "PathInfo" 			PathInfo))
		(if (not (vl-registry-read EasyCutRegistryPath$ "PathOutput"))			(vl-registry-write EasyCutRegistryPath$ "PathOutput" 		PathOutput))
		(if (not (vl-registry-read EasyCutRegistryPath$ "PathDocs"))			(vl-registry-write EasyCutRegistryPath$ "PathDocs" 			PathDocs))
		(if (not (vl-registry-read EasyCutRegistryPath$ "PathNesting"))			(vl-registry-write EasyCutRegistryPath$ "PathNesting" 		PathNesting))
		(if (not (vl-registry-read EasyCutRegistryPath$ "PathDxfJob"))			(vl-registry-write EasyCutRegistryPath$ "PathDxfJob" 		PathDxfJob))
		(if (not (vl-registry-read EasyCutRegistryPath$ "PathCfg"))				(vl-registry-write EasyCutRegistryPath$ "PathCfg" 			PathCfg))
		(if (not (vl-registry-read EasyCutRegistryPath$ "FileCfg"))				(vl-registry-write EasyCutRegistryPath$ "FileCfg" 			FileCfg))
		(if (not (vl-registry-read EasyCutRegistryPath$ "DefaultPathCfg"))		(vl-registry-write EasyCutRegistryPath$ "DefaultPathCfg" 	DefaultPathCfg))
		(if (not (vl-registry-read EasyCutRegistryPath$ "DefaultFileCfg"))		(vl-registry-write EasyCutRegistryPath$ "DefaultFileCfg" 	DefaultFileCfg))
		(if (not (vl-registry-read EasyCutRegistryPath$ "ArrayColumn"))			(vl-registry-write EasyCutRegistryPath$ "ArrayColumn" 		ArrayColumn))
		(if (not (vl-registry-read EasyCutRegistryPath$ "ArrayRow"))			(vl-registry-write EasyCutRegistryPath$ "ArrayRow" 			ArrayRow))
		(if (not (vl-registry-read EasyCutRegistryPath$ "Leader"))				(vl-registry-write EasyCutRegistryPath$ "Leader" 			Leader))
		(if (not (vl-registry-read EasyCutRegistryPath$ "Symula"))				(vl-registry-write EasyCutRegistryPath$ "Symula" 			Symula))
		(if (not (vl-registry-read EasyCutRegistryPath$ "SymulaChoiseShape"))	(vl-registry-write EasyCutRegistryPath$ "SymulaChoiseShape" SymulaChoiseShape))
		(if (not (vl-registry-read EasyCutRegistryPath$ "Sentinel"))			(vl-registry-write EasyCutRegistryPath$ "Sentinel" 			Sentinel))
		(if (not (vl-registry-read EasyCutRegistryPath$ "Imaging"))				(vl-registry-write EasyCutRegistryPath$ "Imaging" 			Imaging))
		;(if (not (vl-registry-read EasyCutRegistryPath$ "Internet"))			(vl-registry-write EasyCutRegistryPath$ "Internet" 			Internet))
		(if (not (vl-registry-read EasyCutRegistryPath$ "PathOtherBrowser"))	(vl-registry-write EasyCutRegistryPath$ "PathOtherBrowser" 	 PathOtherBrowser))
		(if (not (vl-registry-read (strcat EasyCutRegistryPath$ "\\" Imaging) "Key1"))	(vl-registry-write (strcat EasyCutRegistryPath$ "\\" Imaging) "Key1" Key1))
		(if (not (vl-registry-read (strcat EasyCutRegistryPath$ "\\" Imaging) "Key2"))	(vl-registry-write (strcat EasyCutRegistryPath$ "\\" Imaging) "Key2" Key2))
		(if (not (vl-registry-read (strcat EasyCutRegistryPath$ "\\" Imaging) "Key3"))	(vl-registry-write (strcat EasyCutRegistryPath$ "\\" Imaging) "Key3" Key3))

		(alert "EasyCut configurato chiudere il disegno \"install.dwg\" ")
	)
	(alert "Apri il file \"install.dwg\" per eseguire la configurazione")
)
