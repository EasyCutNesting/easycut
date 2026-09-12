(defun LM:listbox (msg lst bit / dch des tmp rtn)

	(defun getlist (rtn lst)
			(read (strcat "(" rtn ")"))
			(mapcar '(lambda (x) (nth x lst)) (read (strcat "(" rtn ")")))
	)
	
	(cond
		((not 	(and 	(setq tmp (vl-filename-mktemp nil nil ".dcl"))
						(setq des (open tmp "w"))
						(write-line
							(strcat "listbox:dialog{label=\""
								msg
								"\";spacer;:list_box{key=\"list\";multiple_select="
								(if (= 1 (logand 1 bit))
									"true"
									"false"
								)
								";width=50;height=15;}spacer;ok_cancel;}"
							)
							des
						)
						(not (close des))
						(< 0 (setq dch (load_dialog tmp)))
						(new_dialog "listbox" dch)
				)
		)
		(prompt "\nError Loading List Box Dialog.")
		)
		(t
			(start_list "list")
				(foreach itm lst (add_list itm))
				
			(end_list)
			
			(setq rtn (set_tile "list" "0"))
			
			(action_tile "list" "(setq rtn $value)")
			
			(action_tile "accept" "(done_dialog) (unload_dialog xx)")
			(setq rtn (getlist rtn lst))
			
			;(setq rtn
			;	(if (= 1 (start_dialog))
			;		(if (= 2 (logand 2 bit))
			;			(read (strcat "(" rtn ")"))
			;			(mapcar '(lambda (x) (nth x lst)) (read (strcat "(" rtn ")")))
			;		)
			;	)
			;)
		)
	)
	;(if (< 0 dch)
	;	(unload_dialog dch)
	;)
	(if (and tmp (setq tmp (findfile tmp)))
		(vl-file-delete tmp)
	)
	rtn
)

(setq layouts (LM:listbox "Select Layouts to Delete from... " (layoutlist) 1))

