;(XD::AutoStartup "C:\\EasyCut\\StartEasyCut.lsp" nil)
;(vl-filename-directory "C:\\EasyCut\\StartEasyCut.lsp")
;(setq path "C:\\EasyCut\\StartEasyCut.lsp")


(defun XD::AutoStartup (path tf / Profiles allpro newnum AutoLoadpath)

 (if tf
   (progn
     (vla-getallprofilenames (vla-get-profiles (vla-get-preferences (vlax-get-acad-object))) 'Profiles)
     (setq allpro (safearray-value Profiles))
   )
   (setq allpro (list (getvar "cprofile")))
 )
 
 (setenv "ACAD" (strcat (getenv "ACAD") ";" (vl-filename-directory path)))
 
 (if (wcmatch (getvar "acadver") "19.[1-9]*")
   (if tf
     (mapcar '(lambda (x / trpath) 
				(setq trpath 	(strcat	"HKEY_CURRENT_USER\\"
										(vlax-product-key)
										"\\Profiles\\"
										x
										"\\Variables"
								)
				)
				(vl-registry-write  trpath "Trustedpaths"
									(strcat (vl-registry-read trpath "Trustedpaths")
											";"
											(vl-filename-directory path)
											"\\..."
									)
				)
			  )
			  allpro
     )
     (setvar "TRUSTEDPATHS" (strcat (getvar "TRUSTEDPATHS")
									";"
									(vl-filename-directory path)
									"\\..."
							)
	)
   )
 )
 (mapcar '(lambda (x)	(setq AppLoadPath	(strcat	"HKEY_CURRENT_USER\\"
													(vlax-product-key)
													"\\Profiles\\"
													x
													"\\Dialogs\\Appload\\Startup"
											)
						)
						(setq NewNum (itoa (1+ (read  (vl-registry-read AppLoadPath "NumStartup")))))
						(vl-registry-write AppLoadPath "NumStartup" NewNum)
						(vl-registry-write AppLoadPath (strcat NewNum "Startup") path)
			)
			allpro
 )
 (princ)
)