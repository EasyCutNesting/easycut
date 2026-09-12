;muddyrunnergirl - 2014
;
;
;Append specified paths to Trusted Locations via LISP
;also --
;Remove specified paths from Trusted Locations via LISP
;
;
;below you will find a several functions which can help you surgically add or remove paths
;from the TRUSTEDPATHS sysvar, programmatically.
;some of you might find the methods, below overkill, but it's simply meant to illustrate how to handle
; a variety of installation/uninstallation programming styles... enjoy!
;P.S., props to EC-CAD (Bob) from Autodesk forums, this is based on his AddSupportPath function.


;*************************************************************************************************************** 
;*************************************************************************************************************** 
;
;function: STRPARSE
;	This is a string parsing function - a helper routine
;	you won't need to make any changes or customizations to this function
;*************************************************************
;*************************************************************
(defun strParse	(Str Delimiter / SearchStr StringLen return n char)
	(setq SearchStr Str)
	(setq StringLen (strlen SearchStr))
	(setq return '())

	(while (> StringLen 0)
		(setq n 1)
		(setq char (substr SearchStr 1 1))
		(while (and (/= char Delimiter) (/= char ""))
			(setq n (1+ n))
			(setq char (substr SearchStr n 1))
		) ;_ end of while
		(setq return (cons (substr SearchStr 1 (1- n)) return))
		(setq SearchStr (substr SearchStr (1+ n) StringLen))
		(setq StringLen (strlen SearchStr))
	) ; end of while
	(reverse return)
); end function
;**************

;*************************************************************************************************************** 
;*************************************************************************************************************** 
;
;function: ADDTRUSTPATH
;	This is the static function that defines how to handle the Path Locations you will specify later
;	you won't need to make any changes or customizations to this function, either
;*************************************************************
;*************************************************************
(defun addTrustPath (dir pos / tmp c lst)
 (setq tmp "" c -1)
 (if (not (member (strcase dir)
 (setq lst (mapcar 'strcase (strParse (getvar "TRUSTEDPATHS") ";")))))
  (progn
   (if (not pos) (setq tmp (strcat dir ";" (getvar "TRUSTEDPATHS")))
     (mapcar '(lambda (x)
      (setq tmp (if (= (setq c (1+ c)) pos)
      (strcat tmp ";" dir ";" x)
      (strcat tmp ";" x)
     )
    )
   )
   lst
  )
 )
 (setvar "TRUSTEDPATHS" tmp)
 )
 )
 (princ)
); end function
;**************

;*************************************************************************************************************** 
;*************************************************************************************************************** 
;
;function: ADDTRUST
;	This function, ADDTRUST, gives you a place to define the paths you want to add to your "Trusted Locations"
;	Replace the sample paths with your own customization root directories.
;	The "\\..." at the end of the path gives trust to all subfolders after that main folder you specify
;*************************************************************
;*************************************************************
(defun ADDTRUST ()
(addTrustPath "C:\\MY-MENU\\..." nil)
(addTrustPath "G:\\CAD Library\\..." nil)
); end function
;**************



;Finally, This is the piece of code you want to call in your installation .LSP file.
;It will make sure to only try to add TRUSTEDPATHS if you're running ACAD2014 or higher


(if (>= (getvar "ACADVER") "19.1")(ADDTRUST)) 


;*************************************************************************************************************** 
;***************************************************************************************************************
;;
;;	REMOVETRUSTPATH - put this in your partial menu's .mnl file...functions for uninstall of customization routines
;;
;***************************************************************************************************************
; 
;function: REMOVETRUSTPATH
;	This is the static function that defines how to handle the Path Locations you will specify later
;	you won't need to make any changes or customizations to this function
;*************************************************************

(defun RemoveTrustPath (PathtoDelete / lst tmp)
(setq PathtoDelete (strcase PathtoDelete))
(setq lst (mapcar 'strcase (strParse (getvar "TRUSTEDPATHS") ";")))
(if (member PathtoDelete lst)
(progn
(setq lst (vl-remove (strcase PathToDelete) lst))
(setq tmp "")
(foreach folder lst
(setq tmp (strcat tmp folder ";"))
)
(setvar "TRUSTEDPATHS" tmp)
)
)
(princ)
); end function
;**************



;*************************************************************************************************************** 
;function: REMOVETRUST
;	This function, REMOVETRUST, gives you a place to define the paths you want to remove from your "Trusted Locations"
;	Replace the sample paths with your own customization root directories.
;	
;*************************************************************
;*************************************************************
(defun REMOVETRUST ()
(RemoveTrustPath "C:\\MY-MENU\\...")
(RemoveTrustPath "G:\\CAD Library\\...")
); end function
;**************


;This is the actual function you call if you have a menu uninstallation routine

(if (>= (getvar "ACADVER") "19.1")(REMOVETRUST)) 
