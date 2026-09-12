
(defun c:example_launchbrowserdialog ()
(setq util (vla-get-utility (vla-get-activedocument
             (vlax-get-acad-object))))
                         
(vla-LaunchBrowserDialog util 'theurl "GizmoLabs Browser"
      "Open" "http://wiki.gz-labs.net/" "ACADBROWSER" 1)
(princ theurl)
(princ)
)


(google '("SearchTerm1" "Search Phrase 2"))
(defun Google (TermList / UrlStr Url)
	(or *acad* (setq *acad* (vlax-get-acad-object)))
	(or *doc* (setq *doc* (vla-get-activedocument *acad*)))
	(or *utility* (setq *utility* (vla-get-utility *doc*)))
	(setq UrlStr
		(strcat "http://groups.google.com/groups?q="
				"group%3Aautodesk.autocad.customization"
		)
	)
	(foreach term termlist
		(setq UrlStr (strcat UrlStr "+%22" (plusify term) "%22")
		)
	)
	(setq UrlStr (strcat UrlStr "&ie=UTF-8&oe=UTF-8&hl=en"))
	(vla-launchbrowserdialog
		*utility* 'Url "Title" "Open"
		UrlStr "" :vlax-true
	)
	Url
)