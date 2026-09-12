;**************************************************************************************
; VECTORIZE - Command to convert AutoCAD objects into 'lsp' functions to simplify     *
; =========   the placement of vector images within DCL image tiles and buttons.      *
;                                                                                     *
;             created by Richard Willis, (aka 'Didge', find me at 'www.theswamp.org') *
;                                                                                     *
;             Version 1.1 - Added curve & spline sensitivity controls                 *
;             Version 1.0 - Original Release                                          *
;**************************************************************************************
(defun c:VECTORIZE (/ OLDCMD CH Dcl_Id% SS BB DISTORT COL WIDTH HEIGHT IMAGE-WIDTH IMAGE-HEIGHT VECTORLST CH fn dclpath SEGMENTS)
  (if (not (IS-WCS))(progn (alert "    Sorry, 'Vectorize' only operates \n\nwithin the World Co-ordinate System.")(exit)))
  (setq OLDCMD (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (if (not *INI) (setq *INI (list -15 "150" "80" "24.92" "6.12" nil 253 32)))
  (setq COL (nth 0 *INI) WIDTH (nth 1 *INI) HEIGHT (nth 2 *INI) IMAGE-WIDTH (nth 3 *INI)
	IMAGE-HEIGHT (nth 4 *INI) DISTORT (nth 5 *INI) clr (nth 6 *INI) SEGMENTS (nth 7 *ini))
  (setq dclpath (vl-filename-mktemp "VECTORIZE.tmp"))
  (setq fn (open dclpath "w"))
  (foreach item (list
		    "VECTORIZE : dialog {"
		    "            label = \"Vectorize\";"
		    "            initial_focus = \"SELOBJ\";"
		    "            : spacer { height = 0.1; }"
		    "            : row {"
		    "              : column {"
		    "                : row {"
		    "                  : button {"
		    "                    key = \"SELOBJ\";"
		    "                    label = \"Select Objects >\";"
		    "                    alignment = left;"
		    "                    width = 17;"
		    "                    fixed_width = true;"
		    "                  }"
		    "                  : button {"
		    "                    key = \"SELWIN\";"
		    "                    label = \"Window Selection >\";"
		    "                    alignment = right;"
		    "                    width = 17;"
		    "                    fixed_width = true;"
		    "                  }"
		    "                }"
		    "                : boxed_row {"
		    "                  label = \"Tile Dimensions\";"
		    "                  : column {"
		    "                    : spacer { height = 0.1; }"
		    "                    : text {"
		    "                      label = \"Pixel width\";"
		    "                      alignment = centered;"
		    "                    }"
		    "                    : spacer { height = 0.1; }"
		    "                    : text {"
		    "                      label = \"Pixel height\";"
		    "                      alignment = centered;"
		    "                    }"
		    "                    : spacer { height = 0.1; }"
		    "                  }"
		    "                  : column {"
		    "                    : edit_box {"
		    "                      key = \"XPIX\";"
		    "                      edit_limit = 6;"
		    "                      alignment = left;"
		    "                    }"
		    "                    : edit_box {"
		    "                      key = \"YPIX\";"
		    "                      edit_limit = 6;"
		    "                      alignment = left;"
		    "                    }"
		    "                    : spacer { height = 0.1; }"
		    "                  }"
		    "                  : column {"
		    "                    : spacer { height = 0.1; }"
		    "                    : text {"
		    "                      label = \"Dcl width\";"
		    "                      alignment = centered;"
		    "                    }"
		    "                    : spacer { height = 0.1; }"
		    "                    : text {"
		    "                      label = \"Dcl height\";"
		    "                      alignment = centered;"
		    "                    }"
		    "                    : spacer { height = 0.1; }"
		    "                  }"
		    "                  : column {"
		    "                    : edit_box {"
		    "                      key = \"XDCL\";"
		    "                      edit_limit = 6;"
		    "                      alignment = left;"
		    "                    }"
		    "                    : edit_box {"
		    "                      key = \"YDCL\";"
		    "                      edit_limit = 6;"
		    "                      alignment = left;"
		    "                    }"
		    "                    : spacer { height = 0.1; }"
		    "                  }"
		    "               }"
                    "               : boxed_column {"
                    "                 label = \"Curve and Spline Sensitivity\";"	    
                    "                 : row {"
                    "                   : edit_box {"
                    "                     key = \"SEGMENTS\";"
                    "                     edit_width = 4;"
                    "                     width = 4;"
                    "                     alignment = left;"
                    "                     value = 16;"
                    "                   }"
                    "                   : slider {"
                    "                     key = \"SLIDER\";"
                    "                     min_value = 8;"
                    "                     max_value = 64;"
                    "                     small_increment = 1;"
                    "                     big_increment = 8;"
                    "                     alignment = left;"
                    "                     value = 16;"
                    "                     width = 38;"
                    "                   }"
                    "                 }"
                    "                 : spacer { height = 0.1; }"
                    "               }"		    
		    "               : row {"
		    "                 : boxed_radio_column {"
		    "                   label = \"Scaling\";"
		    "                   : radio_button {"
		    "                     label = \"Scale Equally\";"
		    "                     key = \"EQL\";"
		    "                     value = \"1\";"
		    "                   }"
		    "                   : radio_button {"
		    "                     label = \"Distort to fit\";"
		    "                     key = \"DISTORT\";"
		    "                     value = \"0\";"
		    "                   }"
		    "                   : spacer { height = 2; }"
		    "                 }"
		    "                 : boxed_column {"
		    "                   label = \"Background Colour\";"
		    "                   : radio_button {"
		    "                     key = \"TRANSP\";"
		    "                     label = \"Transparent\";"
		    "                     value = 0;"
		    "                   }"
		    "                   : radio_button {"
		    "                     key = \"DIALOG\";"
		    "                     label = \"Dialogue Grey\";"
		    "                     value = 1;"
		    "                   }"
		    "                   : row {"
		    "                     : radio_button {"
		    "                       key = \"OTHER\";"
		    "                       label = \"Other\";"
		    "                       value = 0;"
		    "                     }"
		    "                     : button {"
		    "                       label = \"Colour\";"
		    "                       key = \"SELCOL\";"
		    "                       width = 8;"
		    "                       fixed_width = true;"
		    "                       is_enabled = true;"
		    "                     }"
		    "                     : image_button {"
		    "                       key = \"SWATCH\";"
		    "                       height = 1.5;"
		    "                       width = 4;"
		    "                       color = -15;"
		    "                       fixed_width = true;"
		    "                       is_enabled = true;"
		    "                     }"
		    "                   }"
		    "                 }"
		    "               }"
		    "               : text {"
		    "	                key = \"CREDITS\";"
		    "	                label = \"Version 1.1, created by Richard Willis.\";"
		    "	                alignment = centered;"
		    "	              }"
		    "               : spacer { height = 0.1; }"
		    "             }"
		    "             : image {"
		    "               key = \"VLOGO\";"
		    "               color = -15;"
		    "               height = 22.8;"
		    "               fixed_height = true;"
		    "               width = 10.92;"
		    "               fixed_width = true;"
		    "               alignment = right;"
		    "            }"
		    "          }"
		    "          : row {"
		    "            fixed_width = true;"
		    "            alignment = centered;"
		    "            : retirement_button {"
		    "              label = \"Cancel\";"
		    "              key = \"cancel\";"
		    "              is_cancel = true;"
		    "           }"
		    "           : spacer { width = 0.2; }"
		    "           : retirement_button {"
		    "             label = \"Vectorize >\";"
		    "             key = \"VECTORIZE\";"
		    "           }"
		    "           : spacer { width = 0.2; }"
		    "           : retirement_button {"
		    "             label = \"Button Preview >\";"
		    "             key = \"BUTTONS\";"
		    "           }"
		    "           : spacer { width = 0.2; }"
		    "           : retirement_button {"
		    "             label = \"Help\";"
		    "             key = \"HELPME\";"
		    "           }"
		    "         }"
		    "}")
    (princ item fn)
  )
  (close fn)
  (while (/= CH 0)
    (setq Dcl_Id% (load_dialog dclpath))
    (if (not (if dclXY (new_dialog "VECTORIZE" dcl_id% "" dclXY)(new_dialog "VECTORIZE" dcl_id%)))
      (progn (prompt "\nDynamic Dialogue Extraction Failed.")(exit)))
    (if SS (mode_tile "VECTORIZE" 0)(mode_tile "VECTORIZE" 1))
    (UPDT-DIALOG)
    (VLOGO "VLOGO")
    (set_tile "XPIX" WIDTH)
    (set_tile "YPIX" HEIGHT)
    (set_tile "XDCL" IMAGE-WIDTH)
    (set_tile "YDCL" IMAGE-HEIGHT)
    (set_tile "SEGMENTS" (itoa SEGMENTS))
    (set_tile "SLIDER"   (itoa SEGMENTS))
    (action_tile "XPIX"      "(UPDT-DIALOG)")
    (action_tile "YPIX"      "(UPDT-DIALOG)")
    (action_tile "XDCL"      "(UPDT-DIALOG)")
    (action_tile "YDCL"      "(UPDT-DIALOG)")
    (action_tile "SEGMENTS"  "(progn (setq SEGMENTS (atoi $value))(set_tile \"SLIDER\" $value))")
    (action_tile "SLIDER"    "(progn (setq SEGMENTS (atoi $value))(set_tile \"SEGMENTS\" $value))")
    (action_tile "DISTORT"   "(setq DISTORT T)")
    (action_tile "EQL"       "(setq DISTORT nil)")
    (action_tile "TRANSP"    "(progn (setq COL nil)(UPDT-DIALOG))")
    (action_tile "DIALOG"    "(progn (setq COL -15)(UPDT-DIALOG))")
    (action_tile "OTHER"     "(progn (setq COL clr)(UPDT-DIALOG))")   
    (action_tile "SELCOL"    "(progn (if (setq DC (acad_colordlg clr)) (setq clr DC COL DC))(UPDT-DIALOG))")
    (action_tile "cancel"    "(setq dclXY (done_dialog 0))")
    (action_tile "SELOBJ"    "(setq dclXY (done_dialog 1))")
    (action_tile "VECTORIZE" "(setq dclXY (done_dialog 2))")
    (action_tile "BUTTONS"   "(setq dclXY (done_dialog 3))")
    (action_tile "SELWIN"    "(setq dclxy (done_dialog 4))")
    (action_tile "HELPME"    "(setq dclxy (done_dialog 5))")
    (setq CH (start_dialog))
    (unload_dialog Dcl_Id%)
    (setq *INI (list COL WIDTH HEIGHT IMAGE-WIDTH IMAGE-HEIGHT DISTORT clr segments))
     (if (= CH 1)
      (progn
	(if (setq SS (ssget (list (cons 0 "POLYLINE,LWPOLYLINE,LINE,CIRCLE,ARC,ELLIPSE,SPLINE,3DFACE"))))
	  (setq BB (ssCORNERS SS))
	)
      )
    )
    (if (= CH 2) (PREVIEW SS BB COL (atoi WIDTH) (atoi HEIGHT) IMAGE-WIDTH IMAGE-HEIGHT DISTORT SEGMENTS))
    (if (= CH 3) (button-preview IMAGE-WIDTH IMAGE-HEIGHT))
    (if (= CH 4)
      (progn
	(if (setq P1 (getpoint "\nSpecify first corner: "))
	  (if (setq P2 (getcorner P1 "Specify opposite corner: "))
	    (if (setq SS (ssget "W" P1 P2 (list (cons 0 "POLYLINE,LWPOLYLINE,LINE,CIRCLE,ARC,ELLIPSE,SPLINE,3DFACE"))))
	      (setq BB (list P1 P2))
	    )
	  )
	)
      )
    )
    (if (= CH 5)(HELPME))
  )
  (vl-file-delete dclpath)
  (setvar "CMDECHO" OLDCMD)
  (princ)
)

;************************************************************************************
; HELPME - Basic on-screen Help function.                                           *
; ======                                                                            *
;                                                                                   *
;************************************************************************************
(defun HELPME (/ helpdcl fn help_id)
  (setq helpdcl (vl-filename-mktemp "HELPME.tmp"))
      (setq fn (open helpdcl "w"))
      (foreach item (list
		      "HELPME : dialog {"
		      "         label = \"Vectorize Help\";"
		      "         : list_box {"
		      "           key = \"HELPLST\";"
		      "           color = -15;"
		      "           height = 44;"
		      "           fixed_height = true;"
		      "           width = 105;"
		      "         }"
		      "         ok_only;"
		      "}")
    (princ item fn)
  )
  (close fn)
  (setq help_id (load_dialog helpdcl))
  (if (not (if helpXY (new_dialog "HELPME" help_id "" helpXY)(new_dialog "HELPME" help_id)))
    (progn (prompt "\nDynamic Dialogue Extraction Failed.")(exit)))
  (start_list "HELPLST")
  (mapcar 'add_list (list
		      "                          VECTORIZE version 1.1"
		      "  "
		      "Vectorize is a third party extension for AutoCAD that simplifies the process of adding images to dialogue boxes and buttons."
		      "It creates lisp functions from the following objects: Lines, Circles, Arcs, Ellipses, Splines, 3Dfaces, 2D & 3D Polylines."
		      ""
		      "Once copied into your coding, these Lisp functions will reproduce the selected graphics within an 'Image Tile' or 'Image Button'"
		      "by a single command such as: (Name \"Dclkey\").   The original drawing objects are not changed in any way."
		      ""
		      "Basically, if you can draw it, then you can add it to your dialogue boxes :-)"
		      " "
		      "Instructions for use"
		      " "
		      "First and foremost, select some objects using either of the topmost buttons,"
		      "  'Select Objects' will vectorize the selected objects by zooming them to fit the available image size."
		      "  'Window Selection' will select objects and zoom to the window corners."
		      " "
		      "Now specify a width and height either in screen pixels or DCL units."
		      " "
                      "The 'curve & spline sensitivity' controls dictate how many straight segments are used to approximate curves."
		      "Low values create jagged curves and small file sizes, and high values create smooth curves with larger file sizes."
		      "This value should be set as low as possible but not low enough to create jagged curves, between 16 - 24 usually works well."
                      " "
		      "Finally, select a scaling option & background colour and press the Vectorize Button"
		      " "
		      "Vectorize will now preview your image at the correct size, if acceptable you can save this by using the 'Save Vector Function'"
		      "button. Alternatively you can import these vectors back into your current drawing by using the 'Draw Vectors' button."
		      " "
		      "The 'Button Preview' allows you to load upto 2 vector functions and preview these within a toggled image button."
		      " "
		      "Tips:"
		      " "
		      "1. Text objects including truetype fonts need to be exploded with AutoCAD's 'TXTEXP' command within the Express tools."
		      " "
		      "2. For solid fills, generate your vectors as usual and then draw these back into AutoCAD and exit Vectorize. The software"
		      "   will automatically set your snap and polyline width to 1 unit. Using these settings, add further polylines to the drawn"
		      "   vectors to fill empty areas accordingly. Once complete re-start Vectorize and select the drawn vectors and your additional"
		      "   polylines. Images should now appear solid when vectorised again using similar dimensions."
		      " "
		      "3. Before vectorising, use AutoCAD's DrawOrder command to lift outlines above fill."
		      " "
		      "Have Fun :-)"
		      "Didge."
		      "Find me at 'www.theswamp.org'" )
	  )
  (end_list)
  (action_tile "accept" "(setq helpxy (done_dialog))")
  (start_dialog)
  (unload_dialog help_id)
  (vl-file-delete helpdcl)
  (princ)
)

;**************************************************************************
; PREVIEW - Function to display a vectorised image within a dialogue box. *
; =======   with options to draw or save a vectorfile.                    *
;                                                                         *
;**************************************************************************
(defun PREVIEW (SS BB COL WIDTH HEIGHT IMAGE-WIDTH IMAGE-HEIGHT DISTORT SEGMENTS
		/ VECTORLST DCL_ID i j prevdcl fn tempname filen choice)
  (if (setq VECTORLST (SS-2-VECTORS SS BB WIDTH HEIGHT DISTORT SEGMENTS))
    (progn
      (setq prevdcl (vl-filename-mktemp "PREVIEW.tmp"))
      (setq fn (open prevdcl "w"))
      (foreach item (list
		      "PREVIEW : dialog {"
		      "          label = \"Vectorize\";"
		      "          : boxed_column {"
		      "            label = \"Preview\";"
		      "            : image {"
      (if COL (strcat "              color = " (itoa COL) ";")
	      (strcat "              color = -15;"))
	      (strcat "              width = " IMAGE-WIDTH ";")
	      (strcat "              height = " IMAGE-HEIGHT ";")
		      "              aspect_ratio = 1;"
		      "              fixed_width = true;"
		      "              fixed_height = true;"
		      "              key = \"image\";\n"
		      "              alignment = centered;"
		      "            }"
		      "            : text {"
		      "              key = \"BUTDIMS\";"
		      "              label = \" \";"
		      "              alignment = left;"
		      "            }"
		      "          }"
		      "          spacer_1;"
		      "          : row {"
		      "            fixed_width = true;"
		      "            alignment = centered;"
		      "            : retirement_button {"
		      "              label = \"< Back\";"
		      "              key = \"cancel\";"
		      "              is_cancel = true;"
		      "            }"
		       "           : spacer { width = 0.2; }"
		      "            : retirement_button {"
		      "              label = \"Draw Vectors >\";"
		      "              key = \"DRAWVECTORS\";"
		      "            }"
		       "           : spacer { width = 0.2; }"
		      "            : retirement_button {"
		      "              label = \"Save Vector Function >\";"
		      "              key = \"MK-FUNCTION\";"
		      "            }"
		      "          }"
		      "        }")
      (princ item fn)
    )
    (close fn)
    (setq CHOICE nil)
    (while (/= CHOICE 0)
      (setq dcl_id (load_dialog prevdcl))
      (if (not (if preXY (new_dialog "PREVIEW" dcl_id "" preXY)(new_dialog "PREVIEW" dcl_id)))
        (progn (prompt "\nDynamic Dialogue Extraction Failed.")(exit)))
      (setq i (/ (dimx_tile "image") (+ WIDTH 1.)) j (/ (dimy_tile "image") (+ HEIGHT 1.)))
      (start_image "image")
      (foreach x VECTORLST
        (vector_image (fix (* (car x) i))(fix (* (cadr x) j))(fix (* (caddr x) i))(fix (* (cadddr x) j))(last x))
      )
      (end_image)
      (set_tile "BUTDIMS" (strcat "Image Size: " IMAGE-WIDTH " x " IMAGE-HEIGHT "         "))
      (action_tile "cancel"      "(setq preXY (done_dialog 0))")
      (action_tile "DRAWVECTORS" "(setq preXY (done_dialog 1))")
      (action_tile "MK-FUNCTION" "(setq preXY (done_dialog 2))")
      (setq CHOICE (start_dialog))
      (unload_dialog dcl_id)
      (if (= CHOICE 1) (DRAW-VECTORS HEIGHT VECTORLST))
      (if (= CHOICE 2) (MK-FUNCTION WIDTH HEIGHT IMAGE-WIDTH IMAGE-HEIGHT VECTORLST COL))
    )
    (vl-file-delete prevdcl)
    )
  )
  (princ)
)

;**********************************************************************************************
; DRAW-VECTORS - Function to draw the contents of a supplied list of vectors using polylines. *
; ============                                                                                *
;                                                                                             *
;**********************************************************************************************
(defun DRAW-VECTORS (HEIGHT VECTORLST / XY)
  (setvar "OSMODE" 0)
  (setvar "SNAPMODE" 1)
  (setvar "SNAPUNIT" (list 1 1))
  (setvar "PLINEWID" 1.0)
  (setq XY (getpoint "\nPick Insertion Point > "))
  (foreach i VECTORLST
    (MK2DPOLY (list (list (+ (nth 0 i) (car XY))  (+ (- HEIGHT (nth 1 i)) (cadr XY)))
		    (list (+ (nth 2 i) (car XY))  (+ (- HEIGHT (nth 3 i)) (cadr XY)))) "VECTORIZE" 1 (nth 4 i))
  )
  (prompt "\nSnap set to 1 and toggled on.\n")
  (princ)
)

;********************************************************************************************
; MK-FUNCTION - Function to create a 'Vectorise' function from a supplied vector list.      *
; ===========                                                                               *
;                                                                                           *
;********************************************************************************************
(defun MK-FUNCTION (W H IMAGE-WIDTH IMAGE-HEIGHT VECTORLST COL / NAME out str)
  (if (if funcpath (setq DT (getfiled "Specify File Name" funcpath "lsp" 1))
	           (setq DT (getfiled "Specify File Name" "" "lsp" 1)))
    (progn
      (setq funcpath DT)
      (setq NAME (strcase (vl-filename-base funcpath)))
      (setq out (open funcpath "w"))
      (write-line ";********************************************************************************" out)
      (write-line "; Function to draw a vector image within a dialogue Image tile or Image Button. *" out)
      (write-line "; Argument:   'DCLKEY' - the dcl key of the image tile/button to be filled.     *" out)
      (write-line ";    Do NOT edit the dcl dimension text below, this is needed by Vectorize.     *" out)
      (write-line ";********************************************************************************" out)
      (setq str (strcat "; Compiled for dcl dimensions of width," IMAGE-WIDTH ", height," IMAGE-HEIGHT ","))
      (repeat (- 80 (strlen str))(setq str (strcat str " ")))
      (write-line (strcat str "*") out)
      (write-line ";********************************************************************************" out)
      (write-line (strcat "(defun " NAME " (DCLKEY / i j)") out)
      (write-line (strcat "  (setq i (/ (dimx_tile DCLKEY) " (itoa (+ W 1)) ".) j (/ (dimy_tile DCLKEY) " (itoa (+ H 1)) ".))") out)
      (write-line "  (start_image DCLKEY)" out)
      (if COL (write-line (strcat "  (fill_image 0 0 (dimx_tile DCLKEY)(dimy_tile DCLKEY) " (itoa COL) ")") out))
      (princ "  (foreach x '" out)
      (princ VECTORLST out)
      (write-line "\n  (vector_image (fix (* (car x) i))(fix (* (cadr x) j))(fix (* (caddr x) i))(fix (* (cadddr x) j))(last x)))" out)
      (write-line "  (end_image)" out)
      (write-line "  (princ)" out)
      (write-line ")" out)
      (close out)
      (if (findfile funcpath)
        (alert (strcat "'" funcpath "' created successfully."))
        (alert "\nUnable to create function.")
      )
    )
  )
  (princ)
)

;********************************************************************************************
; BUTTON-PREVIEW - Function to load and display 2 different 'Vectorize' functions within    *
; ==============   a sample toggle button.                                                  *
;                                                                                           *
;********************************************************************************************
(defun BUTTON-PREVIEW (IMAGE-WIDTH IMAGE-HEIGHT / DONE ON BUT_ID fn butdcl)
  (if (not ONVECT) (setq ONVECT "ON-VECT"))
  (if (not OFFVECT)(setq OFFVECT "OFF-VECT"))
  (if (not BUT-WIDTH) (setq BUT-WIDTH IMAGE-WIDTH ONX BUT-WIDTH OFFX BUT-WIDTH))
  (if (not BUT-HEIGHT)(setq BUT-HEIGHT IMAGE-HEIGHT ONY BUT-HEIGHT OFFY BUT-HEIGHT))
  (setq DONE nil ON T)
  (while (/= DONE 0)
    (setq butdcl (vl-filename-mktemp "PREVBUT.tmp"))
    (setq fn (open butdcl "w"))
    (foreach item (list
		    "PREVBUT : dialog {"
		    "          label = \"Vectorize\";"
		    "          initial_focus = \"ONFUNCT\";"
		    "          : spacer { height = 0.1; }"
		    "          : boxed_column {"
		    "            label = \"Button Preview\";"
		    "            : row {"
		    "              : image_button {"
		    "                key = \"BUTTON\";"
		    "                color = -15;"
	    (strcat "                width = " BUT-WIDTH ";")
	    (strcat "                height = " BUT-HEIGHT ";")
		    "                fixed_width = true;"
		    "                fixed_height = true;"
		    "                alignment = centered;"
		    "              }"
		    "              : column {"
		    "                spacer_1;"
		    "                : boxed_column {"
		    "                  label = \"'ON' Vectors\";"
		    "                  : button {"
		    "                    key = \"ONFUNCT\";"
		    "                    label = \"Load Vector Function >\";"
		    "                  }"
		    "                  : text {"
		    "                    key = \"ONTEXT\";"
		    "                    alignment = left;"
		    "                  }"
		    "                  : text {"
		    "                    key = \"ONDIMS\";"
		    "                    alignment = left;"
		    "                  }"
		    "                }"
		    "                spacer_1;"
		    "                : boxed_column {"
		    "                  label = \"'OFF' Vectors\";"
		    "                  : button {"
		    "                    key = \"OFFFUNCT\";"
		    "                    label = \"Load Vector Function >\";"
		    "                  }"
		    "                  : text {"
		    "                    key = \"OFFTEXT\";"
		    "                    alignment = left;"
		    "                  }"
		    "                  : text {"
		    "                    key = \"OFFDIMS\";"
		    "                    alignment = left;"
		    "                  }"
		    "                }"
		    "                spacer_1;"
		    "              }"
		    "            }"
		    "            : row {"
		    "              : text {"
		    "                key = \"BUTDIMS\";"
		    "                label = \" \";"
		    "                alignment = left;"
		    "              }"
		    "            }"
		    "          }"
		    "          spacer;"
		    "          : retirement_button {"
		    "            label = \"< Back\";"
		    "            key = \"cancel\";"
		    "            is_cancel = true;"
		    "          }"
		    "}")
      (princ item fn)
    )
    (close fn)
    (setq but_id (load_dialog butdcl))
    (if (not (if butXY (new_dialog "PREVBUT" but_id "" butXY)(new_dialog "PREVBUT" but_id)))
      (progn (prompt "\nDynamic Dialogue Extraction Failed.")(exit)))
    (if (= ONVECT "ON-VECT") (CLICK-HERE "BUTTON") (eval (read (strcat "(" ONVECT " \"BUTTON\")"))))
    (set_tile "ONTEXT"  (strcase ONVECT))
    (set_tile "ONDIMS"  (strcat "Size: " ONX  " x " ONY  "      "))
    (set_tile "OFFTEXT" (strcase OFFVECT))
    (set_tile "OFFDIMS" (strcat "Size: " OFFX " x " OFFY "      "))
    (set_tile "BUTDIMS" (strcat "Button Size: " BUT-WIDTH " x " BUT-HEIGHT "         "))
    (action_tile "BUTTON" (strcat "(if ON (progn (setq ON nil)(" OFFVECT " \"BUTTON\"))
                                          (progn (setq ON T)  (" ONVECT " \"BUTTON\")))"))
    (action_tile "cancel"   "(setq butXY (done_dialog 0))")  
    (action_tile "ONFUNCT"  "(setq butXY (done_dialog 1))")
    (action_tile "OFFFUNCT" "(setq butXY (done_dialog 2))")
    (setq DONE (start_dialog))
    (unload_dialog BUT_ID)
    (if (= DONE 1) (if (if ONFUNC (setq DT (getfiled "Select Vectorize 'ON' Function" ONFUNC "lsp" 0))
			  	  (setq DT (getfiled "Select Vectorize 'ON' Function" "" "lsp" 0)))
		       (progn
			 (if (setq DIMS (get-image-dims DT))
			   (progn
			     (setq BUT-WIDTH (car DIMS) BUT-HEIGHT (cadr DIMS) ONFUNC DT)
			     (setq ONX BUT-WIDTH ONY BUT-HEIGHT)
			     (load ONFUNC)
			     (setq ONVECT (vl-filename-base ONFUNC))
			     (if (and ONFUNC (not OFFFUNC))(setq OFFFUNC ONFUNC))
			   )
			 )
		   )))
    (if (= DONE 2) (if (if OFFFUNC (setq DT (getfiled "Select Vectorize 'OFF' Function" OFFFUNC "lsp" 0))
			           (setq DT (getfiled "Select Vectorize 'OFF' Function" "" "lsp" 0)))
		       (progn
			 (if (setq DIMS (get-image-dims DT))
			   (progn
			     (setq BUT-WIDTH (car DIMS) BUT-HEIGHT (cadr DIMS) OFFFUNC DT)
			     (setq OFFX BUT-WIDTH OFFY BUT-HEIGHT)
			     (load OFFFUNC)
			     (setq OFFVECT (vl-filename-base OFFFUNC))
			     (if (and OFFFUNC (not ONFUNC))(setq ONFUNC OFFFUNC))
			   )
			 )
        	   )))
  )
  (vl-file-delete butdcl)
  (princ)
)

;**************************************************************************************
; GET-IMAGE-DIMS -  Function to extract image dimensions from a 'Vectorise' function. *
; ==============                                                                      *
;                  (get-image-dims (getfiled "Select Vectorize Function" "" "lsp" 0)) *
;**************************************************************************************
(defun GET-IMAGE-DIMS ( PATH / lsp-in LINE WID HT)
  (setq lsp-in (open PATH "r") WID nil HT nil)
  (while (setq LINE (read-line lsp-in))
    (if (= (substr LINE 1 39) "; Compiled for dcl dimensions of width,")
      (if (> (length (cdf LINE)) 3) (setq WID (nth 1 (cdf LINE)) HT (nth 3 (cdf LINE))))
    )
  )
  (close lsp-in)
  (if (and WID HT)
    (list WID HT)
    (progn
      (alert "This file does not appear to \n\nbe a valid 'Vectorize' function.")
      nil
    )
  )
)

;************************************************************************************
; CDF   Function to convert a comma delimited string into a list of strings.        *
; ===                                                                               *
;                                                                                   *
;************************************************************************************
(defun CDF (str1 /)
  (if str1
    (progn
      (while (not (eq str1 (setq str1 (vl-string-subst "\" \"" "," str1)))))
      (read (strcat "(\"" str1 "\")"))
    )
    nil
  )
)

;**********************************************************************************
; SS-2-VECTORS  - Function to return a list of vector coordinates from a supplied *
; ============    selection set. Co-ordinates either scaled & centered to minimum *
;                 image size OR distorted to fit X & Y image dimensions.          *
;**********************************************************************************
(defun SS-2-VECTORS (SS BB WIDTH HEIGHT DISTORT SEGMENTS / scmax scx scy hsc vsc xof yof c lst ret)
  (setq SCMAX (max (setq SCX (/ (- (car (cadr BB)) (car (car BB))) WIDTH))
                   (setq SCY (/ (- (cadr (cadr BB)) (cadr (car BB))) HEIGHT))))
  (if DISTORT
    (setq HSC SCX VSC SCY XOF 0 YOF 0)
    (progn
      (setq XOF (fix (/ (- WIDTH  (/ (- (car (cadr BB)) (car (car BB))) SCMAX)) 2)))
      (setq YOF (fix (/ (- HEIGHT (/ (- (cadr (cadr BB)) (cadr (car BB))) SCMAX)) 2)))
      (setq HSC SCMAX VSC SCMAX)
    )
  )
  (foreach en (vl-remove-if (function listp)(mapcar (function cadr) (ssnamex SS)))
    (if (not (setq C (cdr (assoc 62 (entget en)))))
      (setq C (cdr (assoc 62 (tblsearch "LAYER" (cdr (assoc 8 (entget en)))))))
    )
    (setq LST (obj-2-list en SEGMENTS 0.0001))
    (setq ret (append (mapcar (function (lambda (x1 x2) (list (fix (+ (/ (- (car x1) (car (car BB))) HSC) XOF))
							      (fix (- HEIGHT (+ (/ (- (cadr x1) (cadr (car BB))) VSC) YOF)))
							      (fix (+ (/ (- (car x2) (car (car BB))) HSC) XOF))
							      (fix (- HEIGHT (+ (/ (- (cadr x2) (cadr (car BB))) VSC) YOF)))
							      C))) lst (cdr lst)) ret))
  )
  ret
)

;**************************************************************************
; OBJ-2-LIST  - Function to return a list of 3D vertex co-ordinates for a *
; ==========    given object. Curves are automatically resampled.         *
;               Repeats 1st coordinate if object is closed.               *
;                                                                         *
;               (obj-2-list (car (entsel)) 16 0.0001)                     *
;                                                                         *
;               Returns nil if a non-supported object is used.            *
;**************************************************************************
(defun OBJ-2-LIST (En Segments Fuzzy / elst obj obtp vlst vtx spacing c)
  (setq obj (vlax-ename->vla-object En))
  (setq elst (entget En))
  (setq obtp (cdr (assoc 0 elst)))
  (if (IS-BULGE En) (setq obtp "SPLINE")) ; treat bulged polylines as splines.
  (setq vlst (list))
  (cond ((= obtp "LINE")
	         (setq vlst (list (cdr (assoc 10 elst))(cdr (assoc 11 elst)))))
	((= obtp "3DFACE")
	         (setq vlst (list (cdr (assoc 10 elst))(cdr (assoc 11 elst))(cdr (assoc 12 elst))(cdr (assoc 13 elst))))
	         (setq vlst (remove-equal-points vlst Fuzzy))
	         (setq vlst (append vlst (list (cdr (assoc 10 elst))))))
        ((= obtp "LWPOLYLINE")
	         (while (setq vtx (assoc 10 elst))
                   (setq elst (cdr (member vtx elst)))
		   (setq vlst (append vlst (list (list (cadr vtx)(caddr vtx)(cdr (assoc 38 elst))))))
		 )
	         (if (or (equal (car vlst)(last vlst) fuzzy) (vlax-curve-isClosed obj) )
		   (progn
		     (setq vlst (remove-equal-points vlst Fuzzy))
		     (setq vlst (append vlst (list (car vlst))))
		   )
		   (setq vlst (remove-equal-points vlst Fuzzy))
		 ))
        ((= obtp "POLYLINE")
                 (while (= (cdr (assoc 0 (setq elst (entget (setq en (entnext en))))  )) "VERTEX")
		   (if (and (/= (cdr (assoc 70 elst)) 16) (/= (cdr (assoc 70 elst)) 48) ) 
                     (setq vlst (append vlst (list (cdr (assoc 10 elst)))))
		   )
		 )
	         (if (or (equal (car vlst)(last vlst) fuzzy) (vlax-curve-isClosed obj) )
		   (progn
		     (setq vlst (remove-equal-points vlst Fuzzy))
		     (setq vlst (append vlst (list (nth 0 vlst))))
		   )
		   (setq vlst (remove-equal-points vlst Fuzzy))
		 ))
        ((or (= obtp "CIRCLE")(= obtp "ELLIPSE"))
                 (setq spacing (/ (vlax-curve-getDistAtParam obj (vlax-curve-getEndParam obj)) segments))
                 (setq C 0)
                 (repeat segments
                   (setq vlst (append vlst (list (vlax-curve-getpointatdist obj C))))
                   (setq C (+ C spacing))    
                 )
                 (setq vlst (append vlst (list (vlax-curve-getpointatdist obj 0)))))
	((or (= obtp "ARC")(= obtp "SPLINE"))
	         (setq spacing (/ (vlax-curve-getDistAtParam obj (vlax-curve-getEndParam obj)) segments))
                 (setq C 0)
                 (repeat segments
                   (setq vlst (append vlst (list (vlax-curve-getpointatdist obj C))))
                   (setq C (+ C spacing))    
                 )
                 (setq vlst (append vlst (list (vlax-curve-getpointatdist obj C)))))
        (T (setq vlst nil) )
  )
  vlst
)

;*****************************************************************************
; Remove-Equal-Points - Lisp function to remove duplicate items from a list  *
; ===================   using FUZZY precision. Points with equal XY coords   *
;                       are also removed.                                    *
;*****************************************************************************
(defun remove-equal-points (lst FUZZY / lst2)
  (foreach pt lst (if (not (pnt-member pt lst2)) (setq lst2 (append lst2 (list pt))) ) )
  lst2
)
(defun pnt-member (p lst / tst)
  (if p (foreach pt lst (if pt (if (equal (distance (2d p) (2d pt)) 0 FUZZY)(setq tst T)))))
  tst
)
(defun 2d (pt) (if pt (list (car pt) (cadr pt)) nil))

;*****************************************************************************
; IS-BULGE - Function to test whether a Polyline contains ARC segments.      *
; ========   Returns T if it does.                                           *
;                                                                            *
;*****************************************************************************
(defun IS-BULGE ( en /)
  (setq elst (entget en) return nil)
  (foreach n elst (if (= (car n) 42)  (if (/= (cdr n) 0.0) (setq return T)) ) ) 
  return
)

;********************************************************************
; IS-WCS - Function to determine whether current coordinate system  *
; ======   is set to WCS.                                           *
;                                                                   *
;********************************************************************
(defun IS-WCS (/) (if (not (zerop (getvar "worlducs"))) T nil))

;********************************************************************
; MK2DPOLY - Function to draw an open 2d poly from a list of points *
; ========                                                          *
;                                                                   *
;********************************************************************
(defun MK2DPOLY (LST LAY PLWIDTH COL / x)
  (entmake (append (list (cons 0 "LWPOLYLINE")(cons 100 "AcDbEntity")(cons 100 "AcDbPolyline")
                         (cons 8 LAY)(cons 90 (length LST))(cons 43 PLWIDTH)(cons 62 COL)(cons 70 0))
      (mapcar '(lambda (x) (cons 10 x)) LST)))
  (princ)
)

;********************************************************************************
; SSCORNERS - Function to return 2 co-ordinates denoting the extents of a       *
; =========   supplied selection set.                                           *
;********************************************************************************
(defun SSCORNERS (ss / _GetBoundingBox _SStoObjects _Main ret)
  (defun _GetBoundingBox ( object / p1 p2)
    (vl-catch-all-apply '(lambda () (vlax-invoke-method object 'GetBoundingBox 'p1 'p2)))
    (if p1 ((lambda (data) (mapcar '(lambda (funcs)(mapcar '(lambda (func)(apply func data)) funcs))
				   '((caar cadar)(caadr cadar)(caadr cadadr)(caar cadadr))))
	     (list (mapcar 'vlax-safearray->list (list p1 p2)))))
  )
  (defun _SStoObjects (ss / i objects)
    (if (eq 'pickset (type ss))
      (repeat (setq i (sslength ss))
	(setq objects (cons (vlax-ename->vla-object (ssname ss (setq i (1- i)))) objects))
      )
    )
    objects
  )
  (defun _Main (ss / boundingboxes)
    (cond ((setq boundingboxes (vl-remove-if 'null (mapcar '_GetBoundingBox (_SStoObjects ss))))
	   (mapcar '(lambda (func pair / lst) (list (apply (car pair)(mapcar 'car (setq lst (mapcar
            func boundingboxes))))(apply (cadr pair)(mapcar 'cadr lst))))
		   '(car cadr caddr cadddr) '((min min)(max min)(max max)(min max)))))
  )
  (setq ret (_Main ss))
  (list (car ret)(caddr ret))
)

;********************************************************************************
; UPDT-DIALOG - Dialogue handling function for main Vectorize dialogue.         *
; ===========                                                                   *
;********************************************************************************
  (defun UPDT-DIALOG (/ )
    (if DISTORT (set_tile "DISTORT" "1")(set_tile "EQUAL" "1"))
    (cond ((= COL nil) (set_tile "TRANSP" "1")(set_tile "DIALOG" "0")(set_tile "OTHER" "0")
	               (mode_tile "SELCOL" 1)(mode_tile "SWATCH" 1)
	               (start_image "SWATCH")(fill_image 0 0 (dimx_tile "SWATCH")(dimy_tile "SWATCH") -15)(end_image))
	  
	  ((= COL -15) (set_tile "TRANSP" "0")(set_tile "DIALOG" "1")(set_tile "OTHER" "0")
	               (mode_tile "SELCOL" 1)(mode_tile "SWATCH" 1)
	               (start_image "SWATCH")(fill_image 0 0 (dimx_tile "SWATCH")(dimy_tile "SWATCH") -15)(end_image))

	  (T          (set_tile "TRANSP" "0")(set_tile "DIALOG" "0")(set_tile "OTHER" "1")
	              (mode_tile "SELCOL" 0)(mode_tile "SWATCH" 0)
	              (start_image "SWATCH")(fill_image 0 0 (dimx_tile "SWATCH")(dimy_tile "SWATCH") COL)(end_image))
    )
    (cond ((or (= $key "XPIX")(= $key "YPIX"))
	   (if (and (NUM-CHECK $value nil)(not (zerop (atoi $value))))
	     (if (= $key "XPIX")(setq WIDTH $value)(setq HEIGHT $value))
	     (alert "Value must be an integer greater than zero.")
	   )
	   (if (= $key "XPIX")(set_tile "XPIX" WIDTH)(set_tile "YPIX" HEIGHT))
          )
          ((or (= $key "XDCL")(= $key "YDCL"))
	   (if (and (NUM-CHECK $value T) (not (zerop (atof $value))))
	     (if (= $key "XDCL")(setq IMAGE-WIDTH $value)(setq IMAGE-HEIGHT $value))
	     (alert "Value must be a number greater than zero.")
	   )
           (if (= $key "XDCL")(set_tile "XDCL" IMAGE-WIDTH)(set_tile "XDCL" IMAGE-WIDTH))
          )
    )
    (cond ((and (= $key "XPIX")(> (atoi WIDTH) 0))
	   (set_tile "XDCL" (setq IMAGE-WIDTH (rtos (+ (* (1- (atoi WIDTH))(/ 1 6.0)) 0.09) 2 2)))
          )
          ((and (= $key "YPIX")(> (atoi HEIGHT) 0))
           (set_tile "YDCL" (setq IMAGE-HEIGHT (rtos (+ (* (1- (atoi HEIGHT))(/ 1 13.0)) 0.048) 2 2)))
          )
          ((and (= $key "XDCL")(> (atof IMAGE-WIDTH) 0))
           (set_tile "XPIX" (setq WIDTH (itoa (fix (+ 1.5 (/ (- (atof IMAGE-WIDTH) 0.09) (/ 1 6.0)))))))
           (set_tile "XDCL" (setq IMAGE-WIDTH (rtos (+ (* (1- (atoi WIDTH))(/ 1 6.0)) 0.09) 2 2)))
          )
          ((and (= $key "YDCL")(> (atof IMAGE-HEIGHT) 0))
           (set_tile "YPIX" (setq HEIGHT (itoa (fix (+ 1.5 (/ (- (atof IMAGE-HEIGHT) 0.048) (/ 1 13.0)))))))
           (set_tile "YDCL" (setq IMAGE-HEIGHT (rtos (+ (* (1- (atoi HEIGHT))(/ 1 13.0)) 0.048) 2 2)))
         )
       )
)

;*************************************************************************************
; NUM-CHECK  - Function to determine if a supplied string depicts a positive number. *
; =========                                                                          *
;    Arguments: 'str' - a numeric text string.                                       *
;               'dec' - if T will test for a real, if nil will test for an integer.  *
;*************************************************************************************
(defun NUM-CHECK (str dec / C ret)
  (setq C 1 ret T)
  (repeat (strlen str)
    (if (not (member (substr str C 1) (if dec (list "." "1" "2" "3" "4" "5" "6" "7" "8" "9" "0")
					(list "1" "2" "3" "4" "5" "6" "7" "8" "9" "0")))) (setq ret nil))
    (setq C (1+ C))
  )
  ret
)

;********************************************************************************
; Function to draw a vector image within a dialogue Image tile or Image Button. *
; Argument:   'DCLKEY' - the dcl key of the image tile/button to be filled.     *
;    Do NOT edit the dcl dimension text below, this is needed by Vectorize.     *
;********************************************************************************
; Compiled for dcl dimensions of width,24.92, height,6.12,                      *
;********************************************************************************
(defun CLICK-HERE (DCLKEY / i j)
  (setq i (/ (dimx_tile DCLKEY) 151.) j (/ (dimy_tile DCLKEY) 81.))
  (start_image DCLKEY)
  (fill_image 0 0 (dimx_tile DCLKEY)(dimy_tile DCLKEY) -15)
  (foreach x '((0 80 150 80 7) (150 80 150 0 7) (150 0 0 0 7) (0 0 0 80 7) (22 15 22 14 5) (22 14 21 13 5) (21 13 20 12 5) (20 12 18 12 5) (18 12 17 13 5) (17 13 15 14 5) (15 14 15 15 5) (15 15 14 16 5) (14 16 14 19 5) (14 19 15 20 5) (15 20 15 22 5) (15 22 17 23 5) (17 23 18 23 5) (18 23 20 23 5) (20 23 21 23 5) (21 23 22 22 5) (22 22 22 20 5) (26 12 26 23 5) (26 23 32 23 5) (35 12 35 23 5) (46 15 46 14 5) (46 14 45 13 5) (45 13 43 12 5) (43 12 41 12 5) (41 12 40 13 5) (40 13 39 14 5) (39 14 39 15 5) (39 15 38 16 5) (38 16 38 19 5) (38 19 39 20 5) (39 20 39 22 5) (39 22 40 23 5) (40 23 41 23 5) (41 23 43 23 5) (43 23 45 23 5) (45 23 46 22 5) (46 22 46 20 5) (50 12 50 23 5) (57 12 50 19 5) (52 17 57 23 5) (70 12 70 23 5) (78 12 78 23 5) (70 17 78 17 5) (82 12 82 23 5) (82 12 89 12 5) (82 17 86 17 5) (82 23 89 23 5) (92 12 92 23 5) (92 12 96 12 5) (96 12 98 13 5) (98 13 98 13 5) (98 13 99 14 5) (99 14 99 15 5) (99 15 98 16 5) (98 16 98 17 5) (98 17 96 17 5) (96 17 92 17 5) (95 17 99 23 5) (103 12 103 23 5) (103 12 109 12 5) (103 17 107 17 5) (103 23 109 23 5) (123 12 123 23 5) (120 12 127 12 5) (132 12 131 13 5) (131 13 130 14 5) (130 14 130 15 5) (130 15 129 16 5) (129 16 129 19 5) (129 19 130 20 5) (130 20 130 22 5) (130 22 131 23 5) (131 23 132 23 5) (132 23 134 23 5) (134 23 135 23 5) (135 23 136 22 5) (136 22 137 20 5) (137 20 137 19 5) (137 19 137 16 5) (137 16 137 15 5) (137 15 136 14 5) (136 14 135 13 5) (135 13 134 12 5) (134 12 132 12 5) (11 34 11 45 5) (7 34 15 34 5) (19 34 18 35 5) (18 35 17 36 5) (17 36 16 37 5) (16 37 16 38 5) (16 38 16 41 5) (16 41 16 43 5) (16 43 17 44 5) (17 44 18 45 5) (18 45 19 45 5) (19 45 21 45 5) (21 45 22 45 5) (22 45 23 44 5) (23 44 24 43 5) (24 43 24 41 5) (24 41 24 38 5) (24 38 24 37 5) (24 37 23 36 5) (23 36 22 35 5) (22 35 21 34 5) (21 34 19 34 5) (35 37 34 36 5) (34 36 33 35 5) (33 35 32 34 5) (32 34 30 34 5) (30 34 29 35 5) (29 35 28 36 5) (28 36 28 37 5) (28 37 27 38 5) (27 38 27 41 5) (27 41 28 43 5) (28 43 28 44 5) (28 44 29 45 5) (29 45 30 45 5) (30 45 32 45 5) (32 45 33 45 5) (33 45 34 44 5) (34 44 35 43 5) (35 43 35 41 5) (35 41 32 41 5) (46 37 45 36 5) (45 36 44 35 5) (44 35 43 34 5) (43 34 41 34 5) (41 34 40 35 5) (40 35 39 36 5) (39 36 39 37 5) (39 37 38 38 5) (38 38 38 41 5) (38 41 39 43 5) (39 43 39 44 5) (39 44 40 45 5) (40 45 41 45 5) (41 45 43 45 5) (43 45 44 45 5) (44 45 45 44 5) (45 44 46 43 5) (46 43 46 41 5) (46 41 43 41 5) (49 34 49 45 5) (49 45 55 45 5) (57 34 57 45 5) (57 34 64 34 5) (57 39 61 39 5) (57 45 64 45 5) (76 34 76 45 5) (76 34 81 34 5) (81 34 82 35 5) (82 35 83 35 5) (83 35 83 36 5) (83 36 83 37 5) (83 37 83 38 5) (83 38 82 39 5) (82 39 81 39 5) (81 39 76 39 5) (81 39 82 40 5) (82 40 83 40 5) (83 40 83 42 5) (83 42 83 43 5) (83 43 83 44 5) (83 44 82 45 5) (82 45 81 45 5) (81 45 76 45 5) (87 34 87 45 5) (87 34 94 34 5) (87 39 91 39 5) (87 45 94 45 5) (99 34 99 45 5) (95 34 103 34 5) (104 34 107 45 5) (107 45 109 34 5) (109 34 112 45 5) (112 45 114 34 5) (118 34 118 45 5) (118 34 124 34 5) (118 39 122 39 5) (118 45 124 45 5) (127 34 127 45 5) (127 34 134 34 5) (127 39 132 39 5) (127 45 134 45 5) (137 34 137 45 5) (137 34 145 45 5) (145 45 145 34 5) (20 55 20 66 5) (20 55 24 55 5) (24 55 26 56 5) (26 56 26 56 5) (26 56 27 57 5) (27 57 27 58 5) (27 58 26 59 5) (26 59 26 60 5) (26 60 24 60 5) (24 60 20 60 5) (24 60 26 61 5) (26 61 26 61 5) (26 61 27 62 5) (27 62 27 64 5) (27 64 26 65 5) (26 65 26 66 5) (26 66 24 66 5) (24 66 20 66 5) (31 55 31 63 5) (31 63 31 64 5) (31 64 32 66 5) (32 66 34 66 5) (34 66 35 66 5) (35 66 36 66 5) (36 66 37 64 5) (37 64 38 63 5) (38 63 38 55 5) (44 55 44 66 5) (40 55 48 55 5) (52 55 52 66 5) (49 55 56 55 5) (61 55 60 56 5) (60 56 59 57 5) (59 57 59 58 5) (59 58 58 59 5) (58 59 58 62 5) (58 62 59 63 5) (59 63 59 64 5) (59 64 60 66 5) (60 66 61 66 5) (61 66 63 66 5) (63 66 64 66 5) (64 66 65 64 5) (65 64 66 63 5) (66 63 66 62 5) (66 62 66 59 5) (66 59 66 58 5) (66 58 65 57 5) (65 57 64 56 5) (64 56 63 55 5) (63 55 61 55 5) (70 55 70 66 5) (70 55 77 66 5) (77 66 77 55 5) (94 57 93 56 5) (93 56 91 55 5) (91 55 89 55 5) (89 55 88 56 5) (88 56 87 57 5) (87 57 87 58 5) (87 58 87 59 5) (87 59 88 59 5) (88 59 89 60 5) (89 60 92 61 5) (92 61 93 61 5) (93 61 94 62 5) (94 62 94 63 5) (94 63 94 64 5) (94 64 93 66 5) (93 66 91 66 5) (91 66 89 66 5) (89 66 88 66 5) (88 66 87 64 5) (100 55 100 66 5) (96 55 103 55 5) (109 55 104 66 5) (109 55 113 66 5) (106 62 111 62 5) (117 55 117 66 5) (114 55 121 55 5) (124 55 124 66 5) (124 55 130 55 5) (124 60 128 60 5) (124 66 130 66 5) (140 57 139 56 5) (139 56 138 55 5) (138 55 136 55 5) (136 55 134 56 5) (134 56 133 57 5) (133 57 133 58 5) (133 58 133 59 5) (133 59 134 59 5) (134 59 135 60 5) (135 60 138 61 5) (138 61 139 61 5) (139 61 140 62 5) (140 62 140 63 5) (140 63 140 64 5) (140 64 139 66 5) (139 66 138 66 5) (138 66 136 66 5) (136 66 134 66 5) (134 66 133 64 5))
  (vector_image (fix (* (car x) i))(fix (* (cadr x) j))(fix (* (caddr x) i))(fix (* (cadddr x) j))(last x)))
  (end_image)
  (princ)
)

;********************************************************************************
; Function to draw a vector image within a dialogue Image tile or Image Button. *
; Argument:   'DCLKEY' - the dcl key of the image tile/button to be filled.     *
;    Do NOT edit the dcl dimension text below, this is needed by Vectorize.     *
;********************************************************************************
; Compiled for dcl dimensions of width,24.92, height,6.12,                      *
;********************************************************************************
(defun ON-VECT (DCLKEY / i j)
  (setq i (/ (dimx_tile DCLKEY) 151.) j (/ (dimy_tile DCLKEY) 81.))
  (start_image DCLKEY)
  (fill_image 0 0 (dimx_tile DCLKEY)(dimy_tile DCLKEY) -15)
  (foreach x '((46 45 49 43 251) (49 43 51 41 251) (51 41 52 38 251) (52 38 53 35 251) (53 35 54 32 251) (54 32 53 29 251) (53 29 53 27 251) (53 27 52 24 251) (52 24 50 22 251) (50 22 48 20 251) (48 20 45 18 251) (45 18 42 17 251) (42 17 40 16 251) (40 16 37 16 251) (37 16 34 17 251) (34 17 31 18 251) (31 18 29 20 251) (29 20 27 22 251) (27 22 25 25 251) (25 25 24 27 251) (24 27 23 30 251) (23 30 23 33 251) (23 33 24 36 251) (24 36 25 39 251) (25 39 27 41 251) (27 41 29 43 251) (29 43 32 45 251) (32 45 34 45 251) (34 45 37 45 251) (37 45 40 45 251) (40 45 43 45 251) (43 45 46 45 251) (46 44 48 42 2) (48 42 50 40 2) (50 40 51 37 2) (51 37 52 35 2) (52 35 53 32 2) (53 32 52 29 2) (52 29 52 27 2) (52 27 51 24 2) (51 24 49 22 2) (49 22 47 20 2) (47 20 45 19 2) (45 19 42 18 2) (42 18 39 17 2) (39 17 37 18 2) (37 18 34 18 2) (34 18 31 19 2) (31 19 29 21 2) (29 21 27 23 2) (27 23 26 25 2) (26 25 25 28 2) (25 28 24 31 2) (24 31 24 33 2) (24 33 25 36 2) (25 36 26 38 2) (26 38 28 41 2) (28 41 30 43 2) (30 43 32 44 2) (32 44 35 44 2) (35 44 38 44 2) (38 44 40 44 2) (40 44 43 44 2) (43 44 46 44 2) (46 43 48 41 2) (48 41 49 39 2) (49 39 51 37 2) (51 37 51 34 2) (51 34 52 32 2) (52 32 51 29 2) (51 29 51 27 2) (51 27 50 25 2) (50 25 48 22 2) (48 22 46 21 2) (46 21 44 20 2) (44 20 42 19 2) (42 19 39 18 2) (39 18 36 19 2) (36 19 34 19 2) (34 19 32 20 2) (32 20 30 22 2) (30 22 28 24 2) (28 24 27 26 2) (27 26 26 28 2) (26 28 25 31 2) (25 31 25 33 2) (25 33 26 36 2) (26 36 27 38 2) (27 38 29 40 2) (29 40 31 42 2) (31 42 33 43 2) (33 43 35 43 2) (35 43 38 43 2) (38 43 41 43 2) (41 43 43 43 2) (43 43 46 43 2) (45 42 47 40 2) (47 40 49 38 2) (49 38 50 36 2) (50 36 50 34 2) (50 34 51 31 2) (51 31 50 29 2) (50 29 50 27 2) (50 27 49 25 2) (49 25 47 23 2) (47 23 45 21 2) (45 21 43 20 2) (43 20 41 20 2) (41 20 39 19 2) (39 19 36 20 2) (36 20 34 20 2) (34 20 32 21 2) (32 21 30 23 2) (30 23 29 24 2) (29 24 27 27 2) (27 27 27 29 2) (27 29 26 31 2) (26 31 27 33 2) (27 33 27 36 2) (27 36 28 38 2) (28 38 30 40 2) (30 40 31 41 2) (31 41 34 42 2) (34 42 36 42 2) (36 42 38 42 2) (38 42 41 42 2) (41 42 43 42 2) (43 42 45 42 2) (45 41 47 39 2) (47 39 48 37 2) (48 37 49 35 2) (49 35 49 33 2) (49 33 50 31 2) (50 31 49 29 2) (49 29 49 27 2) (49 27 48 25 2) (48 25 46 23 2) (46 23 45 22 2) (45 22 43 21 2) (43 21 41 21 2) (41 21 38 20 2) (38 20 36 21 2) (36 21 34 21 2) (34 21 32 22 2) (32 22 31 24 2) (31 24 29 25 2) (29 25 28 27 2) (28 27 28 29 2) (28 29 27 31 2) (27 31 28 33 2) (28 33 28 36 2) (28 36 29 37 2) (29 37 30 39 2) (30 39 32 41 2) (32 41 34 41 2) (34 41 36 41 2) (36 41 39 41 2) (39 41 41 41 2) (41 41 43 41 2) (43 41 45 41 2) (45 40 46 38 2) (46 38 47 37 2) (47 37 48 35 2) (48 35 49 33 2) (49 33 49 31 2) (49 31 48 29 2) (48 29 48 27 2) (48 27 47 25 2) (47 25 45 24 2) (45 24 44 23 2) (44 23 42 22 2) (42 22 40 21 2) (40 21 38 21 2) (38 21 36 22 2) (36 22 34 22 2) (34 22 33 23 2) (33 23 31 24 2) (31 24 30 26 2) (30 26 29 28 2) (29 28 29 30 2) (29 30 28 32 2) (28 32 29 34 2) (29 34 29 35 2) (29 35 30 37 2) (30 37 31 39 2) (31 39 33 40 2) (33 40 35 40 2) (35 40 37 40 2) (37 40 39 40 2) (39 40 41 40 2) (41 40 43 40 2) (43 40 45 40 2) (44 39 46 37 2) (46 37 47 36 2) (47 36 47 34 2) (47 34 48 32 2) (48 32 48 31 2) (48 31 47 29 2) (47 29 47 27 2) (47 27 46 26 2) (46 26 44 25 2) (44 25 43 24 2) (43 24 41 23 2) (41 23 40 22 2) (40 22 38 22 2) (38 22 36 23 2) (36 23 35 23 2) (35 23 33 24 2) (33 24 32 25 2) (32 25 31 27 2) (31 27 30 28 2) (30 28 29 30 2) (29 30 29 32 2) (29 32 30 34 2) (30 34 30 35 2) (30 35 31 37 2) (31 37 32 38 2) (32 38 34 39 2) (34 39 36 39 2) (36 39 37 39 2) (37 39 39 39 2) (39 39 41 39 2) (41 39 43 39 2) (43 39 44 39 2) (44 38 45 36 2) (45 36 46 35 2) (46 35 46 34 2) (46 34 47 32 2) (47 32 47 30 2) (47 30 46 29 2) (46 29 46 27 2) (46 27 45 26 2) (45 26 44 25 2) (44 25 42 24 2) (42 24 41 24 2) (41 24 39 23 2) (39 23 38 23 2) (38 23 36 24 2) (36 24 35 24 2) (35 24 33 25 2) (33 25 32 26 2) (32 26 31 28 2) (31 28 31 29 2) (31 29 30 30 2) (30 30 30 32 2) (30 32 31 34 2) (31 34 31 35 2) (31 35 32 36 2) (32 36 33 38 2) (33 38 35 38 2) (35 38 36 38 2) (36 38 38 38 2) (38 38 39 38 2) (39 38 41 38 2) (41 38 42 38 2) (42 38 44 38 2) (44 37 44 35 2) (44 35 45 34 2) (45 34 45 33 2) (45 33 46 32 2) (46 32 46 30 2) (46 30 45 29 2) (45 29 45 28 2) (45 28 44 27 2) (44 27 43 26 2) (43 26 42 25 2) (42 25 40 25 2) (40 25 39 24 2) (39 24 38 24 2) (38 24 36 25 2) (36 25 35 25 2) (35 25 34 26 2) (34 26 33 27 2) (33 27 32 28 2) (32 28 32 30 2) (32 30 31 31 2) (31 31 31 32 2) (31 32 32 34 2) (32 34 32 35 2) (32 35 33 36 2) (33 36 34 37 2) (34 37 35 37 2) (35 37 37 37 2) (37 37 38 37 2) (38 37 39 37 2) (39 37 41 37 2) (41 37 42 37 2) (42 37 44 37 2) (43 36 44 35 2) (44 35 44 33 2) (44 33 45 32 2) (45 32 45 31 2) (45 31 44 30 2) (44 30 44 29 2) (44 29 43 28 2) (43 28 43 27 2) (43 27 42 26 2) (42 26 41 26 2) (41 26 40 25 2) (40 25 39 25 2) (39 25 37 25 2) (37 25 36 26 2) (36 26 35 26 2) (35 26 34 27 2) (34 27 34 28 2) (34 28 33 29 2) (33 29 33 30 2) (33 30 32 31 2) (32 31 32 32 2) (32 32 33 33 2) (33 33 33 35 2) (33 35 34 35 2) (34 35 35 36 2) (35 36 36 36 2) (36 36 37 36 2) (37 36 38 36 2) (38 36 40 36 2) (40 36 41 36 2) (41 36 42 36 2) (42 36 43 36 2) (43 35 43 34 2) (43 34 43 33 2) (43 33 44 32 2) (44 32 44 31 2) (44 31 43 30 2) (43 30 43 29 2) (43 29 42 28 2) (42 28 42 28 2) (42 28 41 27 2) (41 27 40 27 2) (40 27 39 26 2) (39 26 38 26 2) (38 26 37 27 2) (37 27 36 27 2) (36 27 36 27 2) (36 27 35 28 2) (35 28 34 29 2) (34 29 34 30 2) (34 30 33 31 2) (33 31 33 31 2) (33 31 33 32 2) (33 32 34 33 2) (34 33 34 34 2) (34 34 35 35 2) (35 35 36 35 2) (36 35 37 35 2) (37 35 38 35 2) (38 35 39 35 2) (39 35 40 35 2) (40 35 41 35 2) (41 35 42 35 2) (42 35 43 35 2) (42 34 42 33 2) (42 33 43 32 2) (43 32 43 31 2) (43 31 43 31 2) (43 31 42 30 2) (42 30 42 29 2) (42 29 41 29 2) (41 29 41 28 2) (41 28 40 28 2) (40 28 39 27 2) (39 27 39 27 2) (39 27 38 27 2) (38 27 37 28 2) (37 28 36 28 2) (36 28 36 28 2) (36 28 35 29 2) (35 29 35 29 2) (35 29 35 30 2) (35 30 34 31 2) (34 31 34 32 2) (34 32 34 32 2) (34 32 35 33 2) (35 33 35 34 2) (35 34 36 34 2) (36 34 37 34 2) (37 34 38 34 2) (38 34 38 34 2) (38 34 39 34 2) (39 34 40 34 2) (40 34 41 34 2) (41 34 41 34 2) (41 34 42 34 2) (41 33 42 32 2) (42 32 42 31 2) (42 31 42 31 2) (42 31 41 30 2) (41 30 41 30 2) (41 30 41 29 2) (41 29 40 29 2) (40 29 40 29 2) (40 29 39 29 2) (39 29 39 28 2) (39 28 38 28 2) (38 28 38 28 2) (38 28 37 29 2) (37 29 37 29 2) (37 29 36 29 2) (36 29 36 30 2) (36 30 36 30 2) (36 30 35 31 2) (35 31 35 31 2) (35 31 35 32 2) (35 32 35 32 2) (35 32 36 33 2) (36 33 36 33 2) (36 33 37 33 2) (37 33 38 33 2) (38 33 38 33 2) (38 33 39 33 2) (39 33 39 33 2) (39 33 40 33 2) (40 33 40 33 2) (40 33 41 33 2) (41 33 41 33 2) (41 32 41 31 2) (41 31 41 31 2) (41 31 40 31 2) (40 31 40 30 2) (40 30 40 30 2) (40 30 40 30 2) (40 30 39 30 2) (39 30 39 29 2) (39 29 39 29 2) (39 29 38 29 2) (38 29 38 29 2) (38 29 38 30 2) (38 30 37 30 2) (37 30 37 30 2) (37 30 37 30 2) (37 30 37 30 2) (37 30 37 31 2) (37 31 36 31 2) (36 31 36 31 2) (36 31 37 32 2) (37 32 37 32 2) (37 32 37 32 2) (37 32 38 32 2) (38 32 38 32 2) (38 32 38 32 2) (38 32 39 32 2) (39 32 39 32 2) (39 32 39 32 2) (39 32 40 32 2) (40 32 40 32 2) (40 32 40 32 2) (40 32 41 32 2) (41 33 42 32 2) (42 32 42 31 2) (42 31 42 31 2) (42 31 41 30 2) (41 30 41 30 2) (41 30 41 29 2) (41 29 40 29 2) (40 29 40 29 2) (40 29 39 29 2) (39 29 39 28 2) (39 28 38 28 2) (38 28 38 28 2) (38 28 37 29 2) (37 29 37 29 2) (37 29 36 29 2) (36 29 36 30 2) (36 30 36 30 2) (36 30 35 31 2) (35 31 35 31 2) (35 31 35 32 2) (35 32 35 32 2) (35 32 36 33 2) (36 33 36 33 2) (36 33 37 33 2) (37 33 38 33 2) (38 33 38 33 2) (38 33 39 33 2) (39 33 39 33 2) (39 33 40 33 2) (40 33 40 33 2) (40 33 41 33 2) (41 33 41 33 2) (31 46 46 46 250) (31 46 31 60 250) (31 60 34 64 250) (34 64 39 64 250) (46 46 46 60 250) (46 60 44 64 250) (44 64 39 64 250) (43 49 34 50 250) (43 51 34 52 250) (43 53 34 54 250) (43 55 34 56 250) (43 57 34 58 250) (43 59 34 60 250) (45 38 39 28 2) (33 39 38 28 2) (34 31 43 31 2) (35 30 43 30 2) (33 32 44 32 2) (47 41 44 27 2) (52 45 56 48 2) (56 37 61 37 2) (57 27 61 25 2) (52 19 55 15 2) (44 14 44 9 2) (34 13 32 9 2) (26 18 22 15 2) (21 26 16 26 2) (20 36 16 38 2) (25 45 22 49 2) (1 79 148 79 7) (148 79 149 0 7) (2 78 148 78 7) (148 78 148 1 7) (2 77 147 77 7) (147 77 147 2 7) (1 79 1 1 251) (1 1 149 1 251) (2 78 2 2 251) (2 2 148 2 251) (3 77 3 3 251) (3 3 147 3 251) (82 24 84 24 1) (84 24 84 24 1) (84 24 84 24 1) (84 24 85 24 1) (85 24 85 24 1) (85 24 86 24 1) (86 24 87 25 1) (87 25 87 25 1) (87 25 88 25 1) (88 25 88 25 1) (88 25 89 25 1) (89 25 89 25 1) (89 25 89 26 1) (89 26 90 26 1) (90 26 90 26 1) (90 26 91 27 1) (91 27 91 27 1) (91 27 92 27 1) (92 27 92 28 1) (92 28 92 28 1) (92 28 93 29 1) (93 29 93 29 1) (93 29 93 30 1) (93 30 94 30 1) (94 30 94 30 1) (94 30 94 31 1) (94 31 94 31 1) (94 31 94 32 1) (94 32 95 32 1) (95 32 95 33 1) (95 33 95 33 1) (95 33 95 34 1) (95 34 95 35 1) (95 35 95 35 1) (95 35 95 36 1) (95 36 95 36 1) (95 36 95 37 1) (95 37 95 37 1) (95 37 95 38 1) (95 38 95 38 1) (95 38 95 39 1) (95 39 95 40 1) (95 40 94 40 1) (94 40 94 40 1) (94 40 94 41 1) (94 41 94 41 1) (94 41 93 42 1) (93 42 93 42 1) (93 42 93 43 1) (93 43 92 43 1) (92 43 92 44 1) (92 44 92 44 1) (92 44 91 44 1) (91 44 91 45 1) (91 45 90 45 1) (90 45 90 45 1) (90 45 90 46 1) (90 46 89 46 1) (89 46 89 46 1) (89 46 88 46 1) (88 46 88 47 1) (88 47 87 47 1) (87 47 86 47 1) (86 47 86 47 1) (86 47 85 47 1) (85 47 85 47 1) (85 47 84 47 1) (84 47 82 47 1) (82 47 82 48 1) (82 48 84 48 1) (84 48 87 48 1) (87 48 89 47 1) (89 47 90 46 1) (90 46 91 46 1) (91 46 91 46 1) (91 46 92 45 1) (92 45 92 45 1) (92 45 92 45 1) (92 45 93 44 1) (93 44 93 44 1) (93 44 94 43 1) (94 43 94 43 1) (94 43 94 43 1) (94 43 95 42 1) (95 42 95 42 1) (95 42 95 41 1) (95 41 95 41 1) (95 41 95 40 1) (95 40 96 40 1) (96 40 96 39 1) (96 39 96 39 1) (96 39 96 38 1) (96 38 96 38 1) (96 38 96 37 1) (96 37 96 36 1) (96 36 96 36 1) (96 36 96 36 1) (96 36 96 35 1) (96 35 96 35 1) (96 35 96 34 1) (96 34 96 33 1) (96 33 96 33 1) (96 33 96 32 1) (96 32 96 32 1) (96 32 95 31 1) (95 31 95 31 1) (95 31 95 30 1) (95 30 95 30 1) (95 30 95 29 1) (95 29 94 29 1) (94 29 94 28 1) (94 28 94 28 1) (94 28 93 27 1) (93 27 93 27 1) (93 27 92 27 1) (92 27 92 26 1) (92 26 92 26 1) (92 26 91 26 1) (91 26 91 25 1) (91 25 90 25 1) (90 25 90 25 1) (90 25 89 24 1) (89 24 89 24 1) (89 24 88 24 1) (88 24 88 24 1) (88 24 87 24 1) (87 24 87 24 1) (87 24 86 23 1) (86 23 85 23 1) (85 23 85 23 1) (85 23 84 23 1) (84 23 82 23 1) (101 36 101 36 1) (101 36 102 37 1) (102 37 102 37 1) (102 37 103 37 1) (103 37 103 37 1) (103 37 103 37 1) (103 37 104 38 1) (104 38 104 38 1) (104 38 105 38 1) (105 38 105 38 1) (105 38 106 39 1) (106 39 106 39 1) (106 39 107 39 1) (107 39 107 40 1) (107 40 108 40 1) (108 40 109 40 1) (109 40 109 41 1) (109 41 110 41 1) (110 41 110 41 1) (110 41 111 42 1) (111 42 111 42 1) (111 42 112 42 1) (112 42 113 43 1) (113 43 113 43 1) (113 43 114 43 1) (114 43 114 44 1) (114 44 115 44 1) (115 44 116 44 1) (116 44 116 45 1) (116 45 117 45 1) (117 45 117 45 1) (117 45 118 46 1) (118 46 118 46 1) (118 46 119 46 1) (119 46 119 46 1) (119 46 120 47 1) (120 47 120 47 1) (120 47 121 47 1) (121 47 121 48 1) (121 48 121 48 1) (121 48 122 48 1) (122 48 122 48 1) (122 48 123 48 1) (123 48 122 43 1) (122 43 122 37 1) (122 37 122 32 1) (122 32 123 26 1) (123 26 123 26 1) (123 26 123 25 1) (123 25 123 25 1) (123 25 123 25 1) (123 25 123 24 1) (123 24 122 24 1) (122 24 122 24 1) (122 24 122 24 1) (122 24 122 24 1) (122 24 121 24 1) (121 24 121 25 1) (121 25 121 26 1) (121 26 121 28 1) (121 28 121 33 1) (121 33 121 35 1) (121 35 121 35 1) (121 35 120 35 1) (120 35 120 34 1) (120 34 119 34 1) (119 34 118 34 1) (118 34 118 33 1) (118 33 117 33 1) (117 33 116 33 1) (116 33 116 32 1) (116 32 115 32 1) (115 32 115 32 1) (115 32 114 31 1) (114 31 113 31 1) (113 31 113 31 1) (113 31 112 30 1) (112 30 112 30 1) (112 30 111 30 1) (111 30 111 29 1) (111 29 110 29 1) (110 29 110 29 1) (110 29 109 28 1) (109 28 109 28 1) (109 28 108 28 1) (108 28 108 28 1) (108 28 107 27 1) (107 27 107 27 1) (107 27 106 27 1) (106 27 106 26 1) (106 26 105 26 1) (105 26 105 26 1) (105 26 104 26 1) (104 26 104 25 1) (104 25 103 25 1) (103 25 103 25 1) (103 25 103 25 1) (103 25 102 24 1) (102 24 102 24 1) (102 24 102 24 1) (102 24 101 24 1) (101 24 101 24 1) (101 24 100 23 1) (100 23 100 23 1) (100 23 100 23 1) (100 23 100 35 1) (100 35 100 44 1) (100 44 100 46 1) (100 46 100 47 1) (100 47 100 47 1) (100 47 100 48 1) (100 48 101 48 1) (101 48 101 48 1) (101 48 101 48 1) (101 48 101 47 1) (101 47 101 46 1) (101 46 101 37 1) (101 37 101 36 1) (79 24 78 24 1) (78 24 78 25 1) (78 25 78 25 1) (78 25 77 25 1) (77 25 77 25 1) (77 25 76 26 1) (76 26 76 26 1) (76 26 75 27 1) (75 27 75 27 1) (75 27 74 27 1) (74 27 74 28 1) (74 28 74 28 1) (74 28 73 29 1) (73 29 73 29 1) (73 29 73 30 1) (73 30 73 30 1) (73 30 72 31 1) (72 31 72 31 1) (72 31 72 32 1) (72 32 72 32 1) (72 32 72 33 1) (72 33 71 33 1) (71 33 71 34 1) (71 34 71 35 1) (71 35 71 35 1) (71 35 71 36 1) (71 36 71 36 1) (71 36 71 37 1) (71 37 71 37 1) (71 37 71 38 1) (71 38 72 38 1) (72 38 72 39 1) (72 39 72 39 1) (72 39 72 40 1) (72 40 72 41 1) (72 41 72 41 1) (72 41 73 41 1) (73 41 73 42 1) (73 42 73 42 1) (73 42 73 43 1) (73 43 74 43 1) (74 43 74 44 1) (74 44 74 44 1) (74 44 75 45 1) (75 45 75 45 1) (75 45 76 45 1) (76 45 76 46 1) (76 46 77 46 1) (77 46 77 46 1) (77 46 78 47 1) (78 47 78 47 1) (78 47 78 47 1) (78 47 79 47 1) (79 47 79 47 1) (79 47 80 48 1) (80 48 80 48 1) (80 48 81 48 1) (81 48 81 48 1) (81 48 82 48 1) (82 48 82 48 1) (82 48 82 45 1) (82 45 82 36 1) (82 36 82 24 1) (82 24 82 23 1) (82 23 82 23 1) (82 23 81 24 1) (81 24 79 24 1) (79 25 79 25 1) (79 25 79 25 1) (79 25 78 26 1) (78 26 78 26 1) (78 26 77 26 1) (77 26 77 27 1) (77 27 76 27 1) (76 27 76 27 1) (76 27 76 28 1) (76 28 75 28 1) (75 28 75 28 1) (75 28 75 29 1) (75 29 74 29 1) (74 29 74 30 1) (74 30 74 30 1) (74 30 73 31 1) (73 31 73 31 1) (73 31 73 32 1) (73 32 73 32 1) (73 32 73 33 1) (73 33 73 33 1) (73 33 72 34 1) (72 34 72 34 1) (72 34 72 35 1) (72 35 72 35 1) (72 35 72 36 1) (72 36 72 36 1) (72 36 72 37 1) (72 37 72 37 1) (72 37 72 38 1) (72 38 73 38 1) (73 38 73 39 1) (73 39 73 39 1) (73 39 73 40 1) (73 40 73 40 1) (73 40 73 40 1) (73 40 73 41 1) (73 41 74 41 1) (74 41 74 42 1) (74 42 74 42 1) (74 42 75 43 1) (75 43 75 43 1) (75 43 75 43 1) (75 43 76 44 1) (76 44 76 44 1) (76 44 76 44 1) (76 44 77 45 1) (77 45 77 45 1) (77 45 78 45 1) (78 45 78 46 1) (78 46 78 46 1) (78 46 79 46 1) (79 46 79 46 1) (79 46 80 46 1) (80 46 80 47 1) (80 47 81 47 1) (81 47 81 47 1) (81 47 81 47 1) (81 47 81 45 1) (81 45 81 36 1) (81 36 81 24 1) (81 24 81 25 1) (81 25 79 25 1) (80 26 79 26 1) (79 26 79 26 1) (79 26 79 27 1) (79 27 78 27 1) (78 27 78 27 1) (78 27 77 27 1) (77 27 77 28 1) (77 28 77 28 1) (77 28 76 28 1) (76 28 76 29 1) (76 29 76 29 1) (76 29 75 29 1) (75 29 75 30 1) (75 30 75 30 1) (75 30 75 31 1) (75 31 74 31 1) (74 31 74 31 1) (74 31 74 32 1) (74 32 74 32 1) (74 32 74 33 1) (74 33 74 33 1) (74 33 73 34 1) (73 34 73 34 1) (73 34 73 35 1) (73 35 73 35 1) (73 35 73 36 1) (73 36 73 36 1) (73 36 73 36 1) (73 36 73 37 1) (73 37 73 37 1) (73 37 73 38 1) (73 38 74 38 1) (74 38 74 39 1) (74 39 74 39 1) (74 39 74 40 1) (74 40 74 40 1) (74 40 74 40 1) (74 40 75 41 1) (75 41 75 41 1) (75 41 75 42 1) (75 42 75 42 1) (75 42 76 42 1) (76 42 76 43 1) (76 43 76 43 1) (76 43 77 43 1) (77 43 77 44 1) (77 44 77 44 1) (77 44 78 44 1) (78 44 78 45 1) (78 45 79 45 1) (79 45 79 45 1) (79 45 80 45 1) (80 45 80 45 1) (80 45 80 46 1) (80 46 80 45 1) (80 45 80 36 1) (80 36 80 26 1) (80 26 80 26 1) (79 27 79 27 1) (79 27 79 28 1) (79 28 78 28 1) (78 28 78 28 1) (78 28 78 28 1) (78 28 77 29 1) (77 29 77 29 1) (77 29 77 29 1) (77 29 76 30 1) (76 30 76 30 1) (76 30 76 30 1) (76 30 76 31 1) (76 31 75 31 1) (75 31 75 31 1) (75 31 75 32 1) (75 32 75 32 1) (75 32 75 33 1) (75 33 75 33 1) (75 33 74 34 1) (74 34 74 34 1) (74 34 74 34 1) (74 34 74 35 1) (74 35 74 35 1) (74 35 74 36 1) (74 36 74 36 1) (74 36 74 36 1) (74 36 74 37 1) (74 37 74 37 1) (74 37 74 38 1) (74 38 75 38 1) (75 38 75 39 1) (75 39 75 39 1) (75 39 75 39 1) (75 39 75 40 1) (75 40 75 40 1) (75 40 75 40 1) (75 40 76 41 1) (76 41 76 41 1) (76 41 76 41 1) (76 41 76 42 1) (76 42 77 42 1) (77 42 77 42 1) (77 42 77 43 1) (77 43 78 43 1) (78 43 78 43 1) (78 43 78 43 1) (78 43 79 44 1) (79 44 79 44 1) (79 44 79 44 1) (79 44 79 36 1) (79 36 79 27 1) (78 29 78 29 1) (78 29 78 29 1) (78 29 78 30 1) (78 30 77 30 1) (77 30 77 30 1) (77 30 77 31 1) (77 31 77 31 1) (77 31 77 31 1) (77 31 76 32 1) (76 32 76 32 1) (76 32 76 32 1) (76 32 76 33 1) (76 33 76 33 1) (76 33 76 33 1) (76 33 75 34 1) (75 34 75 34 1) (75 34 75 35 1) (75 35 75 35 1) (75 35 75 35 1) (75 35 75 36 1) (75 36 75 36 1) (75 36 75 36 1) (75 36 75 37 1) (75 37 75 37 1) (75 37 75 38 1) (75 38 76 38 1) (76 38 76 38 1) (76 38 76 39 1) (76 39 76 39 1) (76 39 76 39 1) (76 39 76 40 1) (76 40 76 40 1) (76 40 77 40 1) (77 40 77 41 1) (77 41 77 41 1) (77 41 77 41 1) (77 41 77 41 1) (77 41 78 42 1) (78 42 78 42 1) (78 42 78 42 1) (78 42 78 42 1) (78 42 78 36 1) (78 36 78 29 1) (77 32 77 32 1) (77 32 77 32 1) (77 32 77 33 1) (77 33 77 33 1) (77 33 77 33 1) (77 33 77 34 1) (77 34 76 34 1) (76 34 76 34 1) (76 34 76 35 1) (76 35 76 35 1) (76 35 76 35 1) (76 35 76 36 1) (76 36 76 36 1) (76 36 76 36 1) (76 36 76 37 1) (76 37 76 37 1) (76 37 76 37 1) (76 37 77 38 1) (77 38 77 38 1) (77 38 77 38 1) (77 38 77 39 1) (77 39 77 39 1) (77 39 77 39 1) (77 39 77 39 1) (77 39 77 40 1) (77 40 77 36 1) (77 36 77 32 1) (101 48 101 24 1) (123 48 122 24 1) (121 36 121 36 1) (121 36 120 36 1) (120 36 120 35 1) (120 35 119 35 1) (119 35 118 35 1) (118 35 118 34 1) (118 34 117 34 1) (117 34 116 34 1) (116 34 116 33 1) (116 33 115 33 1) (115 33 115 33 1) (115 33 114 32 1) (114 32 113 32 1) (113 32 113 32 1) (113 32 112 31 1) (112 31 112 31 1) (112 31 111 31 1) (111 31 111 30 1) (111 30 110 30 1) (110 30 110 30 1) (110 30 109 29 1) (109 29 109 29 1) (109 29 108 29 1) (108 29 108 29 1) (108 29 107 28 1) (107 28 107 28 1) (107 28 106 28 1) (106 28 106 27 1) (106 27 105 27 1) (105 27 105 27 1) (105 27 104 27 1) (104 27 104 26 1) (104 26 103 26 1) (103 26 103 26 1) (103 26 103 26 1) (103 26 102 25 1) (102 25 102 25 1) (102 25 102 25 1) (102 25 101 25 1) (101 25 101 25 1) (101 25 100 24 1) (100 24 100 24 1) (100 24 100 24 1) (121 37 121 37 1) (121 37 120 37 1) (120 37 120 36 1) (120 36 119 36 1) (119 36 118 36 1) (118 36 118 35 1) (118 35 117 35 1) (117 35 116 35 1) (116 35 116 34 1) (116 34 115 34 1) (115 34 115 34 1) (115 34 114 33 1) (114 33 113 33 1) (113 33 113 33 1) (113 33 112 32 1) (112 32 112 32 1) (112 32 111 32 1) (111 32 111 31 1) (111 31 110 31 1) (110 31 110 31 1) (110 31 109 30 1) (109 30 109 30 1) (109 30 108 30 1) (108 30 108 30 1) (108 30 107 29 1) (107 29 107 29 1) (107 29 106 29 1) (106 29 106 28 1) (106 28 105 28 1) (105 28 105 28 1) (105 28 104 28 1) (104 28 104 27 1) (104 27 103 27 1) (103 27 103 27 1) (103 27 103 27 1) (103 27 102 26 1) (102 26 102 26 1) (102 26 102 26 1) (102 26 101 26 1) (101 26 101 26 1) (101 26 100 25 1) (100 25 100 25 1) (100 25 100 25 1) (121 38 121 38 1) (121 38 120 38 1) (120 38 120 37 1) (120 37 119 37 1) (119 37 118 37 1) (118 37 118 36 1) (118 36 117 36 1) (117 36 116 36 1) (116 36 116 35 1) (116 35 115 35 1) (115 35 115 35 1) (115 35 114 34 1) (114 34 113 34 1) (113 34 113 34 1) (113 34 112 33 1) (112 33 112 33 1) (112 33 111 33 1) (111 33 111 32 1) (111 32 110 32 1) (110 32 110 32 1) (110 32 109 31 1) (109 31 109 31 1) (109 31 108 31 1) (108 31 108 31 1) (108 31 107 30 1) (107 30 107 30 1) (107 30 106 30 1) (106 30 106 29 1) (106 29 105 29 1) (105 29 105 29 1) (105 29 104 29 1) (104 29 104 28 1) (104 28 103 28 1) (103 28 103 28 1) (103 28 103 28 1) (103 28 102 27 1) (102 27 102 27 1) (102 27 102 27 1) (102 27 101 27 1) (101 27 101 27 1) (101 27 100 26 1) (100 26 100 26 1) (100 26 100 26 1) (121 39 121 39 1) (121 39 120 39 1) (120 39 120 38 1) (120 38 119 38 1) (119 38 118 38 1) (118 38 118 37 1) (118 37 117 37 1) (117 37 116 37 1) (116 37 116 36 1) (116 36 115 36 1) (115 36 115 36 1) (115 36 114 35 1) (114 35 113 35 1) (113 35 113 35 1) (113 35 112 34 1) (112 34 112 34 1) (112 34 111 34 1) (111 34 111 33 1) (111 33 110 33 1) (110 33 110 33 1) (110 33 109 32 1) (109 32 109 32 1) (109 32 108 32 1) (108 32 108 32 1) (108 32 107 31 1) (107 31 107 31 1) (107 31 106 31 1) (106 31 106 30 1) (106 30 105 30 1) (105 30 105 30 1) (105 30 104 30 1) (104 30 104 29 1) (104 29 103 29 1) (103 29 103 29 1) (103 29 103 29 1) (103 29 102 28 1) (102 28 102 28 1) (102 28 102 28 1) (102 28 101 28 1) (101 28 101 28 1) (101 28 100 27 1) (100 27 100 27 1) (100 27 100 27 1) (121 40 121 40 1) (121 40 120 40 1) (120 40 120 39 1) (120 39 119 39 1) (119 39 118 39 1) (118 39 118 38 1) (118 38 117 38 1) (117 38 116 38 1) (116 38 116 37 1) (116 37 115 37 1) (115 37 115 37 1) (115 37 114 36 1) (114 36 113 36 1) (113 36 113 36 1) (113 36 112 35 1) (112 35 112 35 1) (112 35 111 35 1) (111 35 111 34 1) (111 34 110 34 1) (110 34 110 34 1) (110 34 109 33 1) (109 33 109 33 1) (109 33 108 33 1) (108 33 108 33 1) (108 33 107 32 1) (107 32 107 32 1) (107 32 106 32 1) (106 32 106 31 1) (106 31 105 31 1) (105 31 105 31 1) (105 31 104 31 1) (104 31 104 30 1) (104 30 103 30 1) (103 30 103 30 1) (103 30 103 30 1) (103 30 102 29 1) (102 29 102 29 1) (102 29 102 29 1) (102 29 101 29 1) (101 29 101 29 1) (101 29 100 28 1) (100 28 100 28 1) (100 28 100 28 1) (121 41 121 41 1) (121 41 120 41 1) (120 41 120 40 1) (120 40 119 40 1) (119 40 118 40 1) (118 40 118 39 1) (118 39 117 39 1) (117 39 116 39 1) (116 39 116 38 1) (116 38 115 38 1) (115 38 115 38 1) (115 38 114 37 1) (114 37 113 37 1) (113 37 113 37 1) (113 37 112 36 1) (112 36 112 36 1) (112 36 111 36 1) (111 36 111 35 1) (111 35 110 35 1) (110 35 110 35 1) (110 35 109 34 1) (109 34 109 34 1) (109 34 108 34 1) (108 34 108 34 1) (108 34 107 33 1) (107 33 107 33 1) (107 33 106 33 1) (106 33 106 32 1) (106 32 105 32 1) (105 32 105 32 1) (105 32 104 32 1) (104 32 104 31 1) (104 31 103 31 1) (103 31 103 31 1) (103 31 103 31 1) (103 31 102 30 1) (102 30 102 30 1) (102 30 102 30 1) (102 30 101 30 1) (101 30 101 30 1) (101 30 100 29 1) (100 29 100 29 1) (100 29 100 29 1) (121 42 121 42 1) (121 42 120 42 1) (120 42 120 41 1) (120 41 119 41 1) (119 41 118 41 1) (118 41 118 40 1) (118 40 117 40 1) (117 40 116 40 1) (116 40 116 39 1) (116 39 115 39 1) (115 39 115 39 1) (115 39 114 38 1) (114 38 113 38 1) (113 38 113 38 1) (113 38 112 37 1) (112 37 112 37 1) (112 37 111 37 1) (111 37 111 36 1) (111 36 110 36 1) (110 36 110 36 1) (110 36 109 35 1) (109 35 109 35 1) (109 35 108 35 1) (108 35 108 35 1) (108 35 107 34 1) (107 34 107 34 1) (107 34 106 34 1) (106 34 106 33 1) (106 33 105 33 1) (105 33 105 33 1) (105 33 104 33 1) (104 33 104 32 1) (104 32 103 32 1) (103 32 103 32 1) (103 32 103 32 1) (103 32 102 31 1) (102 31 102 31 1) (102 31 102 31 1) (102 31 101 31 1) (101 31 101 31 1) (101 31 100 30 1) (100 30 100 30 1) (100 30 100 30 1) (121 43 121 43 1) (121 43 120 43 1) (120 43 120 42 1) (120 42 119 42 1) (119 42 118 42 1) (118 42 118 41 1) (118 41 117 41 1) (117 41 116 41 1) (116 41 116 40 1) (116 40 115 40 1) (115 40 115 40 1) (115 40 114 39 1) (114 39 113 39 1) (113 39 113 39 1) (113 39 112 38 1) (112 38 112 38 1) (112 38 111 38 1) (111 38 111 37 1) (111 37 110 37 1) (110 37 110 37 1) (110 37 109 36 1) (109 36 109 36 1) (109 36 108 36 1) (108 36 108 36 1) (108 36 107 35 1) (107 35 107 35 1) (107 35 106 35 1) (106 35 106 34 1) (106 34 105 34 1) (105 34 105 34 1) (105 34 104 34 1) (104 34 104 33 1) (104 33 103 33 1) (103 33 103 33 1) (103 33 103 33 1) (103 33 102 32 1) (102 32 102 32 1) (102 32 102 32 1) (102 32 101 32 1) (101 32 101 32 1) (101 32 100 31 1) (100 31 100 31 1) (100 31 100 31 1) (121 44 121 44 1) (121 44 120 44 1) (120 44 120 43 1) (120 43 119 43 1) (119 43 118 43 1) (118 43 118 42 1) (118 42 117 42 1) (117 42 116 42 1) (116 42 116 41 1) (116 41 115 41 1) (115 41 115 41 1) (115 41 114 40 1) (114 40 113 40 1) (113 40 113 40 1) (113 40 112 39 1) (112 39 112 39 1) (112 39 111 39 1) (111 39 111 38 1) (111 38 110 38 1) (110 38 110 38 1) (110 38 109 37 1) (109 37 109 37 1) (109 37 108 37 1) (108 37 108 37 1) (108 37 107 36 1) (107 36 107 36 1) (107 36 106 36 1) (106 36 106 35 1) (106 35 105 35 1) (105 35 105 35 1) (105 35 104 35 1) (104 35 104 34 1) (104 34 103 34 1) (103 34 103 34 1) (103 34 103 34 1) (103 34 102 33 1) (102 33 102 33 1) (102 33 102 33 1) (102 33 101 33 1) (101 33 101 33 1) (101 33 100 32 1) (100 32 100 32 1) (100 32 100 32 1) (121 35 121 35 1) (121 35 120 35 1) (120 35 120 34 1) (120 34 119 34 1) (119 34 118 34 1) (118 34 118 33 1) (118 33 117 33 1) (117 33 116 33 1) (116 33 116 32 1) (116 32 115 32 1) (115 32 115 32 1) (115 32 114 31 1) (114 31 113 31 1) (113 31 113 31 1) (113 31 112 30 1) (112 30 112 30 1) (112 30 111 30 1) (111 30 111 29 1) (111 29 110 29 1) (110 29 110 29 1) (110 29 109 28 1) (109 28 109 28 1) (109 28 108 28 1) (108 28 108 28 1) (108 28 107 27 1) (107 27 107 27 1) (107 27 106 27 1) (106 27 106 26 1) (106 26 105 26 1) (105 26 105 26 1) (105 26 104 26 1) (104 26 104 25 1) (104 25 103 25 1) (103 25 103 25 1) (103 25 103 25 1) (103 25 102 24 1) (102 24 102 24 1) (102 24 102 24 1) (102 24 101 24 1) (101 24 101 24 1) (101 24 100 23 1) (100 23 100 23 1) (100 23 100 23 1) (121 45 121 45 1) (121 45 120 45 1) (120 45 120 44 1) (120 44 119 44 1) (119 44 118 44 1) (118 44 118 43 1) (118 43 117 43 1) (117 43 116 43 1) (116 43 116 42 1) (116 42 115 42 1) (115 42 115 42 1) (115 42 114 41 1) (114 41 113 41 1) (113 41 113 41 1) (113 41 112 40 1) (112 40 112 40 1) (112 40 111 40 1) (111 40 111 39 1) (111 39 110 39 1) (110 39 110 39 1) (110 39 109 38 1) (109 38 109 38 1) (109 38 108 38 1) (108 38 108 38 1) (108 38 107 37 1) (107 37 107 37 1) (107 37 106 37 1) (106 37 106 36 1) (106 36 105 36 1) (105 36 105 36 1) (105 36 104 36 1) (104 36 104 35 1) (104 35 103 35 1) (103 35 103 35 1) (103 35 103 35 1) (103 35 102 34 1) (102 34 102 34 1) (102 34 102 34 1) (102 34 101 34 1) (101 34 101 34 1) (101 34 100 33 1) (100 33 100 33 1) (100 33 100 33 1) (121 46 121 46 1) (121 46 120 46 1) (120 46 120 45 1) (120 45 119 45 1) (119 45 118 45 1) (118 45 118 44 1) (118 44 117 44 1) (117 44 116 44 1) (116 44 116 43 1) (116 43 115 43 1) (115 43 115 43 1) (115 43 114 42 1) (114 42 113 42 1) (113 42 113 42 1) (113 42 112 41 1) (112 41 112 41 1) (112 41 111 41 1) (111 41 111 40 1) (111 40 110 40 1) (110 40 110 40 1) (110 40 109 39 1) (109 39 109 39 1) (109 39 108 39 1) (108 39 108 39 1) (108 39 107 38 1) (107 38 107 38 1) (107 38 106 38 1) (106 38 106 37 1) (106 37 105 37 1) (105 37 105 37 1) (105 37 104 37 1) (104 37 104 36 1) (104 36 103 36 1) (103 36 103 36 1) (103 36 103 36 1) (103 36 102 35 1) (102 35 102 35 1) (102 35 102 35 1) (102 35 101 35 1) (101 35 101 35 1) (101 35 100 34 1) (100 34 100 34 1) (100 34 100 34 1) (121 47 121 47 1) (121 47 120 47 1) (120 47 120 46 1) (120 46 119 46 1) (119 46 118 46 1) (118 46 118 45 1) (118 45 117 45 1) (117 45 116 45 1) (116 45 116 44 1) (116 44 115 44 1) (115 44 115 44 1) (115 44 114 43 1) (114 43 113 43 1) (113 43 113 43 1) (113 43 112 42 1) (112 42 112 42 1) (112 42 111 42 1) (111 42 111 41 1) (111 41 110 41 1) (110 41 110 41 1) (110 41 109 40 1) (109 40 109 40 1) (109 40 108 40 1) (108 40 108 40 1) (108 40 107 39 1) (107 39 107 39 1) (107 39 106 39 1) (106 39 106 38 1) (106 38 105 38 1) (105 38 105 38 1) (105 38 104 38 1) (104 38 104 37 1) (104 37 103 37 1) (103 37 103 37 1) (103 37 103 37 1) (103 37 102 36 1) (102 36 102 36 1) (102 36 102 36 1) (102 36 101 36 1) (101 36 101 36 1) (101 36 100 35 1) (100 35 100 35 1) (100 35 100 35 1) (122 48 122 31 1) (123 25 123 48 1) (122 24 122 48 1) (121 25 121 46 1) (83 48 86 48 1) (86 48 91 46 1) (91 46 94 43 1) (94 43 96 39 1) (96 39 96 34 1) (96 34 95 30 1) (95 30 92 27 1) (92 27 89 25 1) (89 25 86 24 1) (86 24 82 24 1) (100 23 100 47 1) (101 24 101 48 1) (102 25 102 47 1) (77 46 77 26 1) (77 45 74 42 1) (74 42 72 37 1) (79 46 74 41 1) (74 41 72 36 1) (80 46 74 40 1) (74 40 72 34 1))
  (vector_image (fix (* (car x) i))(fix (* (cadr x) j))(fix (* (caddr x) i))(fix (* (cadddr x) j))(last x)))
  (end_image)
  (princ)
)

;********************************************************************************
; Function to draw a vector image within a dialogue Image tile or Image Button. *
; Argument:   'DCLKEY' - the dcl key of the image tile/button to be filled.     *
;    Do NOT edit the dcl dimension text below, this is needed by Vectorize.     *
;********************************************************************************
; Compiled for dcl dimensions of width,24.92, height,6.12,                      *
;********************************************************************************
(defun OFF-VECT (DCLKEY / i j)
  (setq i (/ (dimx_tile DCLKEY) 151.) j (/ (dimy_tile DCLKEY) 81.))
  (start_image DCLKEY)
  (fill_image 0 0 (dimx_tile DCLKEY)(dimy_tile DCLKEY) 253)
  (foreach x '((149 1 149 79 251) (149 79 1 79 251) (148 2 148 78 251) (148 78 2 78 251) (147 3 147 77 251) (147 77 3 77 251) (46 45 49 43 251) (49 43 51 41 251) (51 41 52 38 251) (52 38 53 35 251) (53 35 54 32 251) (54 32 53 29 251) (53 29 53 27 251) (53 27 52 24 251) (52 24 50 22 251) (50 22 48 20 251) (48 20 45 18 251) (45 18 42 17 251) (42 17 40 16 251) (40 16 37 16 251) (37 16 34 17 251) (34 17 31 18 251) (31 18 29 20 251) (29 20 27 22 251) (27 22 25 25 251) (25 25 24 27 251) (24 27 23 30 251) (23 30 23 33 251) (23 33 24 36 251) (24 36 25 39 251) (25 39 27 41 251) (27 41 29 43 251) (29 43 32 45 251) (32 45 34 45 251) (34 45 37 45 251) (37 45 40 45 251) (40 45 43 45 251) (43 45 46 45 251) (31 46 46 46 250) (31 46 31 60 250) (31 60 34 64 250) (34 64 39 64 250) (46 46 46 60 250) (46 60 44 64 250) (44 64 39 64 250) (44 49 34 50 250) (44 51 34 52 250) (44 53 34 54 250) (44 55 34 56 250) (44 57 34 58 250) (44 59 34 60 250) (149 1 1 1 255) (1 1 1 79 255) (148 2 2 2 255) (2 2 2 78 255) (147 3 3 3 255) (3 3 3 77 255) (34 45 34 34 251) (44 34 44 45 251) (34 34 37 37 251) (37 37 39 32 251) (39 32 41 37 251) (41 37 44 34 251) (91 36 90 33 250) (90 33 90 31 250) (90 31 89 29 250) (89 29 87 27 250) (87 27 85 25 250) (85 25 83 24 250) (83 24 81 24 250) (81 24 79 23 250) (79 23 76 24 250) (76 24 74 24 250) (74 24 72 25 250) (72 25 70 27 250) (70 27 68 29 250) (68 29 67 31 250) (67 31 67 33 250) (67 33 66 35 250) (66 35 67 38 250) (67 38 67 40 250) (67 40 68 42 250) (68 42 70 44 250) (70 44 72 46 250) (72 46 74 47 250) (74 47 76 47 250) (76 47 78 48 250) (78 48 81 47 250) (81 47 83 47 250) (83 47 85 46 250) (85 46 87 44 250) (87 44 89 42 250) (89 42 90 40 250) (90 40 90 38 250) (90 38 91 36 250) (78 23 78 48 250) (77 24 77 48 250) (76 24 76 48 250) (75 24 75 48 250) (74 25 74 47 250) (73 25 73 47 250) (72 26 72 46 250) (71 27 71 45 250) (70 28 70 44 250) (69 29 69 43 250) (68 30 68 42 250) (67 32 67 40 250) (95 24 95 48 250) (96 24 96 48 250) (97 24 97 48 250) (98 24 98 48 250) (99 24 99 48 250) (100 24 100 48 250) (101 24 101 48 250) (102 24 102 48 250) (103 24 103 48 250) (104 24 104 48 250) (104 25 114 25 250) (104 31 114 31 250) (104 32 114 32 250) (118 24 118 48 250) (119 24 119 48 250) (120 24 120 48 250) (121 24 121 48 250) (122 24 122 48 250) (123 24 123 48 250) (124 24 124 48 250) (125 24 125 48 250) (126 24 126 48 250) (127 24 127 48 250) (127 25 137 25 250) (127 31 137 31 250) (127 32 137 32 250) (114 24 95 24 250) (137 24 118 24 250) (77 24 79 24 250) (79 24 79 24 250) (79 24 79 24 250) (79 24 80 24 250) (80 24 80 24 250) (80 24 81 24 250) (81 24 82 24 250) (82 24 82 24 250) (82 24 83 25 250) (83 25 83 25 250) (83 25 84 25 250) (84 25 84 25 250) (84 25 84 25 250) (84 25 85 26 250) (85 26 85 26 250) (85 26 86 26 250) (86 26 86 27 250) (86 27 87 27 250) (87 27 87 27 250) (87 27 87 28 250) (87 28 88 28 250) (88 28 88 29 250) (88 29 88 29 250) (88 29 89 30 250) (89 30 89 30 250) (89 30 89 30 250) (89 30 89 31 250) (89 31 89 31 250) (89 31 90 32 250) (90 32 90 32 250) (90 32 90 33 250) (90 33 90 34 250) (90 34 90 34 250) (90 34 90 35 250) (90 35 90 35 250) (90 35 90 36 250) (90 36 90 36 250) (90 36 90 37 250) (90 37 90 38 250) (90 38 90 38 250) (90 38 90 39 250) (90 39 90 39 250) (90 39 89 40 250) (89 40 89 40 250) (89 40 89 40 250) (89 40 89 41 250) (89 41 88 41 250) (88 41 88 42 250) (88 42 88 42 250) (88 42 87 43 250) (87 43 87 43 250) (87 43 87 44 250) (87 44 86 44 250) (86 44 86 44 250) (86 44 85 45 250) (85 45 85 45 250) (85 45 85 45 250) (85 45 84 45 250) (84 45 84 46 250) (84 46 83 46 250) (83 46 83 46 250) (83 46 82 46 250) (82 46 81 46 250) (81 46 81 47 250) (81 47 80 47 250) (80 47 80 47 250) (80 47 79 47 250) (79 47 77 47 250) (77 47 77 48 250) (77 48 79 48 250) (79 48 82 48 250) (82 48 84 47 250) (84 47 85 46 250) (85 46 86 46 250) (86 46 86 45 250) (86 45 87 45 250) (87 45 87 45 250) (87 45 87 44 250) (87 44 88 44 250) (88 44 88 44 250) (88 44 89 43 250) (89 43 89 43 250) (89 43 89 42 250) (89 42 90 42 250) (90 42 90 41 250) (90 41 90 41 250) (90 41 90 41 250) (90 41 90 40 250) (90 40 91 39 250) (91 39 91 39 250) (91 39 91 38 250) (91 38 91 38 250) (91 38 91 37 250) (91 37 91 37 250) (91 37 91 36 250) (91 36 91 35 250) (91 35 91 35 250) (91 35 91 35 250) (91 35 91 34 250) (91 34 91 34 250) (91 34 91 33 250) (91 33 91 32 250) (91 32 91 32 250) (91 32 91 31 250) (91 31 90 31 250) (90 31 90 30 250) (90 30 90 30 250) (90 30 90 29 250) (90 29 90 29 250) (90 29 89 28 250) (89 28 89 28 250) (89 28 89 27 250) (89 27 88 27 250) (88 27 88 27 250) (88 27 87 26 250) (87 26 87 26 250) (87 26 87 26 250) (87 26 86 25 250) (86 25 86 25 250) (86 25 85 25 250) (85 25 85 24 250) (85 24 84 24 250) (84 24 84 24 250) (84 24 83 24 250) (83 24 83 23 250) (83 23 82 23 250) (82 23 82 23 250) (82 23 81 23 250) (81 23 80 23 250) (80 23 80 23 250) (80 23 79 23 250) (79 23 77 23 250) (78 48 81 48 250) (81 48 86 46 250) (86 46 89 43 250) (89 43 91 39 250) (91 39 91 34 250) (91 34 90 30 250) (90 30 87 27 250) (87 27 84 25 250) (84 25 81 24 250) (81 24 77 24 250))
  (vector_image (fix (* (car x) i))(fix (* (cadr x) j))(fix (* (caddr x) i))(fix (* (cadddr x) j))(last x)))
  (end_image)
  (princ)
)

;********************************************************************************
; Function to draw a vector image within a dialogue Image tile or Image Button. *
;                                                                               *
; Argument:   'DCLKEY' - the dcl key of the image tile.                         *
;********************************************************************************
; Compiled for dcl dimensions of width,10.92, height,18.97                      *
;********************************************************************************
(defun VLOGO (DCLKEY / i j)
  (setq i (/ (dimx_tile DCLKEY) 67.) j (/ (dimy_tile DCLKEY) 248.))
  (start_image DCLKEY)
  (foreach x '((33 120 33 120 252) (33 120 36 120 252) (36 120 39 121 252) (39 121 40 121 252) (40 121 42 122 252) (42 122 43 124 252) (43 124 43 126 252) (43 126 43 126 252) (43 126 42 127 252) (42 127 41 128 252) (41 128 40 129 252) (40 129 38 130 252) (38 130 36 131 252) (36 131 33 131 252) (33 167 18 167 252) (18 167 21 190 252) (21 190 33 190 252) (53 211 36 211 252) (59 193 6 193 252) (6 193 7 201 252) (36 211 59 193 252) (36 211 59 193 252) (19 92 19 92 252) (19 92 21 109 252) (21 109 21 109 252) (21 109 45 109 252) (45 109 45 109 252) (47 92 49 92 252) (49 92 53 92 252) (53 92 55 92 252) (55 92 61 92 252) (61 92 63 86 252) (63 86 3 86 252) (3 86 5 92 252) (5 92 11 92 252) (11 92 19 92 252) (7 65 7 67 252) (7 67 6 68 252) (6 68 6 69 252) (6 69 6 70 252) (6 70 7 71 252) (7 71 7 72 252) (7 72 8 73 252) (8 73 9 74 252) (9 74 10 76 252) (10 76 11 76 252) (11 76 13 77 252) (13 77 15 78 252) (15 78 17 78 252) (17 78 19 79 252) (19 79 22 79 252) (22 79 24 80 252) (24 80 27 80 252) (27 80 30 81 252) (30 81 32 81 252) (32 81 35 81 252) (35 81 39 81 252) (39 81 42 81 252) (42 81 43 81 252) (43 81 46 81 252) (46 81 49 81 252) (49 81 52 81 252) (52 81 55 81 252) (55 81 58 76 252) (58 76 55 76 252) (55 76 51 76 252) (51 76 48 76 252) (48 76 45 76 252) (45 76 41 76 252) (41 76 38 76 252) (38 76 36 76 252) (36 76 34 74 252) (34 74 32 73 252) (32 73 31 72 252) (31 72 31 71 252) (31 71 31 70 252) (31 70 32 69 252) (32 69 33 68 252) (33 68 34 67 252) (34 67 37 65 252) (37 65 37 65 252) (37 65 40 64 252) (40 64 43 64 252) (43 64 47 64 252) (47 64 50 64 252) (50 64 51 64 252) (51 64 55 64 252) (55 64 58 64 252) (58 64 56 58 252) (56 58 54 58 252) (54 58 51 58 252) (51 58 48 58 252) (48 58 44 58 252) (44 58 40 58 252) (40 58 37 58 252) (37 58 34 58 252) (34 58 31 58 252) (31 58 28 58 252) (28 58 25 59 252) (25 59 22 59 252) (22 59 20 60 252) (20 60 18 60 252) (18 60 16 61 252) (16 61 14 61 252) (14 61 12 62 252) (12 62 10 63 252) (10 63 9 64 252) (9 64 8 64 252) (8 64 7 65 252) (27 0 0 0 252) (0 0 23 24 252) (23 24 24 24 252) (24 24 41 24 252) (66 0 51 0 252) (55 131 56 130 252) (56 130 57 129 252) (59 128 60 127 252) (60 127 60 126 252) (60 126 60 125 252) (60 125 60 124 252) (60 124 60 124 252) (60 124 60 122 252) (60 122 60 121 252) (60 121 59 120 252) (59 120 58 119 252) (58 119 57 118 252) (57 118 56 117 252) (56 117 52 115 252) (52 115 48 114 252) (48 114 46 112 252) (46 112 44 112 252) (44 112 41 112 252) (41 112 39 112 252) (39 112 36 112 252) (36 112 33 112 252) (33 112 30 112 252) (30 112 27 112 252) (27 112 24 112 252) (24 112 22 112 252) (22 112 19 114 252) (19 114 17 114 252) (17 114 15 115 252) (15 115 13 116 252) (13 116 12 116 252) (12 116 9 117 252) (9 117 8 118 252) (8 118 7 119 252) (7 119 6 120 252) (6 120 6 120 252) (6 120 5 121 252) (5 121 5 122 252) (5 122 5 124 252) (5 124 5 124 252) (5 124 5 125 252) (5 125 5 126 252) (5 126 6 127 252) (6 127 7 128 252) (7 128 8 129 252) (8 129 10 130 252) (10 130 11 131 252) (11 131 12 131 252) (12 131 14 133 252) (14 133 16 133 252) (16 133 18 134 252) (18 134 20 134 252) (20 134 22 135 252) (22 135 25 135 252) (25 135 27 135 252) (27 135 30 135 252) (30 135 33 135 252) (33 135 34 135 252) (34 135 37 135 252) (37 135 40 135 252) (40 135 42 135 252) (42 135 45 135 252) (45 135 47 134 252) (47 134 49 134 252) (49 134 51 133 252) (51 133 53 131 252) (53 131 53 131 252) (53 131 55 131 252) (55 131 56 130 252) (56 130 57 129 252) (57 129 59 128 252) (59 128 60 127 252) (60 127 60 126 252) (60 126 60 125 252) (60 125 60 124 252) (60 124 60 124 252) (60 124 60 122 252) (33 120 33 120 252) (33 120 36 120 252) (36 120 39 121 252) (39 121 40 121 252) (40 121 42 122 252) (42 122 43 124 252) (43 124 43 126 252) (43 126 43 126 252) (43 126 42 127 252) (42 127 41 128 252) (41 128 40 129 252) (40 129 38 130 252) (38 130 36 131 252) (36 131 33 131 252) (33 131 31 131 252) (31 131 28 130 252) (28 130 26 129 252) (26 129 26 129 252) (26 129 24 128 252) (24 128 23 127 252) (23 127 23 126 252) (23 126 23 126 252) (23 126 23 124 252) (23 124 24 122 252) (24 122 26 121 252) (26 121 28 121 252) (28 121 30 120 252) (30 120 33 120 252) (25 138 25 138 252) (25 138 22 138 252) (22 138 19 138 252) (19 138 16 138 252) (16 138 13 138 252) (13 138 9 138 252) (9 138 6 138 252) (6 138 3 138 252) (3 138 6 163 252) (6 163 27 163 252) (27 163 28 156 252) (28 156 46 163 252) (46 163 61 160 252) (61 160 48 155 252) (48 155 49 155 252) (49 155 52 154 252) (52 154 54 154 252) (54 154 57 153 252) (57 153 59 152 252) (59 152 59 152 252) (59 152 60 152 252) (60 152 62 150 252) (62 150 63 149 252) (63 149 63 148 252) (63 148 63 147 252) (63 147 63 146 252) (63 146 63 146 252) (63 146 63 145 252) (63 145 62 144 252) (62 144 61 144 252) (61 144 60 143 252) (60 143 58 141 252) (58 141 57 141 252) (57 141 55 140 252) (55 140 53 139 252) (53 139 51 139 252) (51 139 48 138 252) (48 138 46 138 252) (46 138 43 138 252) (43 138 40 138 252) (40 138 36 138 252) (36 138 33 138 252) (33 138 29 138 252) (29 138 25 138 252) (21 201 10 215 252) (10 215 49 215 252) (49 215 50 214 252) (50 214 50 214 252) (50 214 51 213 252) (51 213 52 212 252) (52 212 53 211 252) (53 211 52 212 252) (52 212 51 213 252) (51 213 50 214 252) (50 214 50 214 252) (50 214 49 215 252) (49 215 10 215 252) (10 215 21 201 252) (38 12 27 0 252) (38 12 51 0 252) (28 153 29 144 252) (28 153 29 153 252) (29 153 31 153 252) (31 153 32 153 252) (32 153 34 153 252) (34 153 35 153 252) (35 153 36 153 252) (36 153 37 153 252) (37 153 39 152 252) (39 152 40 152 252) (40 152 41 150 252) (41 150 41 150 252) (41 150 42 150 252) (42 150 43 149 252) (43 149 43 149 252) (43 149 43 149 252) (43 149 43 148 252) (43 148 43 148 252) (43 148 43 147 252) (43 147 43 147 252) (43 147 42 147 252) (42 147 42 146 252) (42 146 41 146 252) (41 146 40 145 252) (40 145 39 145 252) (39 145 38 145 252) (38 145 37 144 252) (37 144 36 144 252) (36 144 34 144 252) (34 144 33 144 252) (33 144 32 144 252) (32 144 30 144 252) (30 144 29 144 252) (41 24 66 0 252) (34 225 45 225 252) (45 225 48 225 252) (48 225 57 225 252) (57 225 58 220 252) (58 220 6 220 252) (6 220 9 247 252) (43 241 32 241 252) (32 241 33 235 252) (33 231 34 225 252) (47 235 55 235 252) (55 235 56 231 252) (56 231 33 231 252) (54 247 55 241 252) (55 241 43 241 252) (33 235 47 235 252) (33 167 47 167 252) (47 167 44 190 252) (44 190 33 190 252) (50 39 46 39 252) (46 39 36 39 252) (43 39 41 39 252) (37 33 48 33 252) (48 33 60 33 252) (51 33 53 33 252) (60 33 61 27 252) (61 27 9 27 252) (9 27 12 53 252) (12 53 57 53 252) (46 49 35 49 252) (35 49 36 43 252) (36 39 37 33 252) (49 43 58 43 252) (58 43 59 39 252) (59 39 50 39 252) (57 53 58 49 252) (58 49 46 49 252) (36 43 49 43 252) (54 247 9 247 252) (21 201 7 201 252) (47 92 45 109 252))
  (vector_image (fix (* (car x) i))(fix (* (cadr x) j))(fix (* (caddr x) i))(fix (* (cadddr x) j))(last x)))
  (end_image)
  (princ)
)



(prompt "\nType 'VECTORIZE' to start.\n")
(princ)