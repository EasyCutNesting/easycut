;-------------------------------------------------------------------------------
; Program Name: GetIcon.lsp [Get Icon R8]
; Created By:   Terry Miller (Email: terrycadd@yahoo.com)
;               (URL: https://autolisp-exchange.com)
; Date Created: 4-1-00
; Function:     Various dialog Get functions enhanced with the icons AlertX,
; Block, Computer, Constr, Delete, Exclam, Filefolder, Folder, Frown, Inform,
; Light, Printer, Quest, Replace, Smile and None. These functions and utilities
; get the true dialog string widths to create a C:\Temp\Temp.dcl dialog file on
; the fly and return a string of the name of the button selected.
;-------------------------------------------------------------------------------
; Revision History
; Rev  By     Date    Description
;-------------------------------------------------------------------------------
; 1   TM    4-1-00    Initial version
; 2   TM    12-1-00   Revised functions to allow up to 4 lines and to allow
;                     choosing different icons.
; 3   TM    1-1-01    Added Printer, Smile and Frown icons.
; 4   TM    7-21-03   Added EditBox for entering string values.
;                     Syntax: (EditBox "Title" "Label" "EditText" EditWidth)
; 5   TM    5-20-04   Revised functions to allow up to 10 lines closer together,
;                     and added the None option of not including an icon.
; 6   TM    12-20-04  Added GetButtons functions to allow up to 5 buttons.
;                     Type GetButtons for syntax examples. Also added ShowIcons.
; 7   TM    10-15-06  Revised the prompt width in EditBox and EditEnter. Added
;                     the PopupList and PopupListEnter functions.
; 8   TM    5-20-07   Revised GetDclWidth to correctly include the characters
;                     from ascii 127 through ascii 255.
;-------------------------------------------------------------------------------
; Overview of Main Functions
;-------------------------------------------------------------------------------
; c:ShowIcons - Dialog that displays all the GetIcon icons
; c:GetIcon - [GetIcon Help] - Displays GetIcon Get functions and syntax.
; GetOK - Returns "OK"
; GetOKCancel - Returns "OK" or "Cancel"
; GetYesNo - Returns "Yes" or "No"
; GetYesNoCancel - Returns "Yes", "No" or "Cancel"
; GetYestoAll - Returns "Yes", "Yes to All", "No" or "Cancel"
; GetRetryCancel - Returns "Retry" or "Cancel"
; c:GetButtons - [GetButtons Help] - Displays GetButtons functions and syntax.
; GetButtons1 - Returns name of button selected
; GetButtons2 - Returns name of button selected
; GetButtons3 - Returns name of button selected
; GetButtons4 - Returns name of button selected
; GetButtons5 - Returns name of button selected
; TempDcl - Creates a Temp.dcl dialog file and returns the button selected.
; GetDclWidth - Get the true dialog string width.
; GetPT [Get integer Points] - Utility for vector_line.
; vector_circle - Draws vector circles, arcs and ellipses in an image tile.
; vector_line - Draws vector lines in an image tile.
; c:Vector_Circle - Vector_Circle Dialog Examples <-- Try It!
; CancelYesNo - Dialog cancel function
; dtr - Degrees to Radians function
; EditBox - Dialog with edit_box for entering string values
;   Syntax: (EditBox "Title" "Prompt" "EditText" EditWidth)
; EditEnter - Dialog with edit_box using the enter key as the accept key
;   Syntax: (EditEnter "Title" "Prompt" "EditText" EditWidth)
; PopupList - Dialog with popup_list box for selecting items in a list
;   Syntax: (PopupList "Title" "Prompt" "DefaultItem" ListItems@)
; PopupListEnter - Dialog with popup_list box for selecting items in a list
;   that uses the enter key as the accept key
;   Syntax: (PopupListEnter "Title" "Prompt" "DefaultItem" ListItems@)
;-------------------------------------------------------------------------------
; c:ShowIcons - Dialog that displays all the GetIcon icons
;-------------------------------------------------------------------------------
(defun c:ShowIcons (/ Cnt# Dcl_Id% FileName% Icons@ Q$)
  (if (not (findfile "C:\\Temp\\Temp.dcl"))
    (progn (vl-load-com)(vl-mkdir "C:\\Temp"))
  );if
  (setq Q$ (chr 34))
  (setq Icons@ (list "alertx" "block" "computer" "constr" "delete" "exclam"
    "filefolder" "folder" "frown" "inform" "light" "printer" "quest" "replace"
    "smile")
  );setq
  (setq FileName% (open "C:\\Temp\\Temp.dcl" "w"))
  (write-line "dcl_settings : default_dcl_settings { audit_level = 3; }" FileName%)
  (write-line "Temp : dialog {" FileName%)
  (write-line (strcat "  key = "Q$"title"Q$";") FileName%)
  (write-line (strcat "  label = "Q$ Q$";") FileName%)
  (write-line "  spacer;" FileName%)
  (setq Cnt# 1)
  (foreach Item Icons@
    (if (= Cnt# 1)
      (write-line "  : row {" FileName%)
    );if
    (write-line "    : column {" FileName%)
    (write-line "      : image {" FileName%)
    (write-line (strcat "        key = " Q$ Item Q$ ";") FileName%)
    (write-line "        width = 5.42;" FileName%)
    (write-line "        height = 2.51;" FileName%)
    (write-line "        fixed_width = true;" FileName%)
    (write-line "        fixed_height = true;" FileName%)
    (write-line "        aspect_ratio = 1;" FileName%)
    (write-line "        color = -15;" FileName%)
    (write-line "        alignment = centered;" FileName%)
    (write-line "      }" FileName%)
    (write-line "      : text {" FileName%)
    (write-line (strcat "        key = " Q$ Item "_txt" Q$ ";") FileName%)
    (write-line (strcat "        label = " Q$ Q$ ";") FileName%)
    (write-line "        width = 11;" FileName%)
    (write-line "        fixed_width = true;" FileName%)
    (write-line "        alignment = centered;" FileName%)
    (write-line "      }" FileName%)
    (write-line "    }" FileName%)
    (if (= Cnt# 5)
      (write-line "  }" FileName%)
    );if
    (setq Cnt# (1+ Cnt#))
    (if (= Cnt# 6)(setq Cnt# 1))
  );foreach
  (write-line "  spacer;" FileName%)
  (write-line "  : ok_button {" FileName%)
  (write-line "    is_cancel = true;" FileName%)
  (write-line "  }" FileName%)
  (write-line "}" FileName%)
  (close FileName%)
  (setq Dcl_Id% (load_dialog "C:\\Temp\\Temp.dcl"))
  (new_dialog "Temp" Dcl_Id%)
  (set_tile "title" " GetIcon Icons")
  (AlertX:)(set_tile "alertx_txt" "AlertX")
  (Block:)(set_tile "block_txt" "Block")
  (Computer:)(set_tile "computer_txt" "Computer")
  (Constr:)(set_tile "constr_txt" "Constr")
  (Delete:)(set_tile "delete_txt" "Delete")
  (Exclam:)(set_tile "exclam_txt" "Exclam")
  (Filefolder:)(set_tile "filefolder_txt" "Filefolder")
  (Folder:)(set_tile "folder_txt" "Folder")
  (Frown:)(set_tile "frown_txt" "Frown")
  (Inform:)(set_tile "inform_txt" "Inform")
  (Light:)(set_tile "light_txt" "Light")
  (Printer:)(set_tile "printer_txt" "Printer")
  (Quest:)(set_tile "quest_txt" "Quest")
  (Replace:)(set_tile "replace_txt" "Replace")
  (Smile:)(set_tile "smile_txt" "Smile")
  (set_tile "none_txt" "None")
  (start_dialog)
  (unload_dialog Dcl_Id%)
  (princ)
);defun c:ShowIcons
;-------------------------------------------------------------------------------
; c:GetIcon - [GetIcon Help] - Displays GetIcon Get functions and syntax.
;-------------------------------------------------------------------------------
(defun c:GetIcon (/ Q$)
  (if (not (findfile "C:\\Temp\\Temp.dcl"))
    (progn (vl-load-com)(vl-mkdir "C:\\Temp"))
  );if
  (setq Q$ (chr 34))
  (textscr)
  (princ         "\nGetIcon functions return the name of the button selected:\n")
  (princ (strcat "\nGetOK          = "Q$"OK"Q$))
  (princ (strcat "\nGetOKCancel    = "Q$"OK"Q$" or "Q$"Cancel"Q$))
  (princ (strcat "\nGetYesNo       = "Q$"Yes"Q$" or "Q$"No"Q$))
  (princ (strcat "\nGetYesNoCancel = "Q$"Yes"Q$", "Q$"No"Q$" or "Q$"Cancel"Q$))
  (princ (strcat "\nGetYestoAll    = "Q$"Yes"Q$", "Q$"Yes to All"Q$", "Q$"No"Q$" or "Q$"Cancel"Q$))
  (princ (strcat "\nGetRetryCancel = "Q$"Retry"Q$" or "Q$"Cancel"Q$))
  (princ (strcat "\n\nSyntax: (Get? "Q$"Title"Q$" "Q$"Line #1\\nLine #2...\\nLine #10"Q$" "Q$"Icon"Q$")"))
  (princ (strcat "\nIcons:  AlertX, Block, Computer, Constr, Delete, Exclam, Filefolder, Folder,"))
  (princ (strcat "\n        Frown, Inform, Light, Printer, Quest, Replace, Smile and None."))
  (princ (strcat "\nExample: (GetOK "Q$ Q$" "Q$"Have a nice day!"Q$" "Q$"Smile"Q$")"))
  (princ)
);defun c:GetIcon
;-------------------------------------------------------------------------------
; GetOK - Returns "OK"
; Arguments: 3
;   Title$ = Title for dialog
;   Msg$ = Message for dialog
;   Icon$ = Icon image
; Returns: "OK" string is returned.
;-------------------------------------------------------------------------------
(defun GetOK (Title$ Msg$ Icon$ / )
  (if (or (= Icon$ "")(/= (type Icon$) 'STR)) (setq Icon$ "Inform"))
  (TempDcl "GetOK" Title$ Msg$ Icon$)
);defun GetOK
;-------------------------------------------------------------------------------
; GetOKCancel - Returns "OK" or "Cancel"
; Arguments: 3
;   Title$ = Title for dialog
;   Msg$ = Message for dialog
;   Icon$ = Icon image
; Returns: "OK" or "Cancel" string is returned.
;-------------------------------------------------------------------------------
(defun GetOKCancel (Title$ Msg$ Icon$ / )
  (if (or (= Icon$ "")(/= (type Icon$) 'STR)) (setq Icon$ "Exclam"))
  (TempDcl "GetOKCancel" Title$ Msg$ Icon$)
);defun GetOKCancel
;-------------------------------------------------------------------------------
; GetYesNo - Returns "Yes" or "No"
; Arguments: 3
;   Title$ = Title for dialog
;   Msg$ = Message for dialog
;   Icon$ = Icon image
; Returns: "Yes" or "No" string is returned.
;-------------------------------------------------------------------------------
(defun GetYesNo (Title$ Msg$ Icon$ / )
  (if (or (= Icon$ "")(/= (type Icon$) 'STR)) (setq Icon$ "Quest"))
  (TempDcl "GetYesNo" Title$ Msg$ Icon$)
);defun GetYesNo
;-------------------------------------------------------------------------------
; GetYesNoCancel - Returns "Yes", "No" or "Cancel"
; Arguments: 3
;   Title$ = Title for dialog
;   Msg$ = Message for dialog
;   Icon$ = Icon image
; Returns: "Yes", "No" or "Cancel" string is returned.
;-------------------------------------------------------------------------------
(defun GetYesNoCancel (Title$ Msg$ Icon$ / )
  (if (or (= Icon$ "")(/= (type Icon$) 'STR)) (setq Icon$ "Exclam"))
  (TempDcl "GetYesNoCancel" Title$ Msg$ Icon$)
);defun YesNoCancel
;-------------------------------------------------------------------------------
; GetYestoAll - Returns "Yes", "Yes to All", "No" or "Cancel"
; Arguments: 3
;   Title$ = Title for dialog
;   Msg$ = Message for dialog
;   Icon$ = Icon image
; Returns: "Yes", "Yes to All", "No" or "Cancel" string is returned.
;-------------------------------------------------------------------------------
(defun GetYestoAll (Title$ Msg$ Icon$ / )
  (if (or (= Icon$ "")(/= (type Icon$) 'STR)) (setq Icon$ "Block"))
  (TempDcl "GetYestoAll" Title$ Msg$ Icon$)
);defun GetYestoAll
;-------------------------------------------------------------------------------
; GetRetryCancel - Returns "Retry" or "Cancel"
; Arguments: 3
;   Title$ = Title for dialog
;   Msg$ = Message for dialog
;   Icon$ = Icon image
; Returns: "Retry" or "Cancel" string is returned.
;-------------------------------------------------------------------------------
(defun GetRetryCancel (Title$ Msg$ Icon$ / )
  (if (or (= Icon$ "")(/= (type Icon$) 'STR)) (setq Icon$ "AlertX"))
  (TempDcl "GetRetryCancel" Title$ Msg$ Icon$)
);defun GetRetryCancel
;-------------------------------------------------------------------------------
; c:GetButtons - [GetButtons Help] - Displays GetButtons functions and syntax.
;-------------------------------------------------------------------------------
(defun c:GetButtons (/ Q$)
  (if (not (findfile "C:\\Temp\\Temp.dcl"))
    (progn (vl-load-com)(vl-mkdir "C:\\Temp"))
  );if
  (setq Q$ (chr 34))
  (textscr)
  (princ         "\nGetButtons functions return the name of the button selected:\n")
  (princ (strcat "\nGetButtons1 = "Q$"Btn1"Q$))
  (princ (strcat "\nGetButtons2 = "Q$"Btn1"Q$" or "Q$"Btn2"Q$))
  (princ (strcat "\nGetButtons3 = "Q$"Btn1"Q$", "Q$"Btn2"Q$" or "Q$"Btn3"Q$))
  (princ (strcat "\nGetButtons4 = "Q$"Btn1"Q$", "Q$"Btn2"Q$", "Q$"Btn3"Q$" or "Q$"Btn4"Q$))
  (princ (strcat "\nGetButtons5 = "Q$"Btn1"Q$", "Q$"Btn2"Q$", "Q$"Btn3"Q$", "Q$"Btn4"Q$" or "Q$"Btn5"Q$))
  (princ (strcat "\n\nSyntax: (GetButtons? "Q$"Title"Q$" "Q$"Line #1...\\nLine #10"Q$" "Q$"Icon"Q$" ["Q$"Btn1"Q$"..."Q$"Btn5"Q$"])"))
  (princ (strcat "\nIcons:  AlertX, Block, Computer, Constr, Delete, Exclam, Filefolder, Folder"))
  (princ (strcat "\n        Frown, Inform, Light, Printer, Quest, Replace, Smile and None."))
  (princ "\nSyntax examples:")
  (princ (strcat "\n(GetButtons1 "Q$"Greetings"Q$" "Q$"Have a nice day!"Q$" "Q$"Smile"Q$" "Q$"You too!"Q$")"))
  (princ (strcat "\n(GetButtons2 "Q$ Q$" "Q$"Ready to print?"Q$" "Q$"Printer"Q$" "Q$"Yes"Q$" "Q$"No"Q$")"))
  (princ (strcat "\n(GetButtons3 "Q$ Q$" "Q$"Plot orientation?"Q$" "Q$"Quest"Q$" "Q$"Portrait"Q$" "Q$"Landscape"Q$" "Q$"Cancel"Q$")"))
  (princ (strcat "\n(GetButtons4 "Q$ Q$" "Q$"Paper size?"Q$" "Q$ Q$" "Q$"A-Size"Q$" "Q$"B-Size"Q$" "Q$"C-Size"Q$" "Q$"D-Size"Q$")"))
  (princ (strcat "\n(GetButtons5 "Q$ Q$" "Q$"Number of copies?"Q$" "Q$"None"Q$" "Q$"1"Q$" "Q$"2"Q$" "Q$"3"Q$" "Q$"4"Q$" "Q$"5"Q$")"))
  (princ)
);defun c:GetButtons
;-------------------------------------------------------------------------------
; GetButtons1 - Returns name of button selected
; Arguments: 4
;   Title$ = Title for dialog
;   Msg$ = Message for dialog
;   Icon$ = Icon image
;   Button1$ = Button name
; Returns: Name of button selected.
;-------------------------------------------------------------------------------
(defun GetButtons1 (Title$ Msg$ Icon$ Button1$ / )
  (if (or (= Icon$ "")(/= (type Icon$) 'STR)) (setq Icon$ "Exclam"))
  (TempDcl "GetButtons1" Title$ Msg$ Icon$)
);defun GetButtons1
;-------------------------------------------------------------------------------
; GetButtons2 - Returns name of button selected
; Arguments: 5
;   Title$ = Title for dialog
;   Msg$ = Message for dialog
;   Icon$ = Icon image
;   Button1$ = 1st Button name
;   Button2$ = 2nd Button name
; Returns: Name of button selected.
;-------------------------------------------------------------------------------
(defun GetButtons2 (Title$ Msg$ Icon$ Button1$ Button2$ / )
  (if (or (= Icon$ "")(/= (type Icon$) 'STR)) (setq Icon$ "Exclam"))
  (TempDcl "GetButtons2" Title$ Msg$ Icon$)
);defun GetButtons2
;-------------------------------------------------------------------------------
; GetButtons3 - Returns name of button selected
; Arguments: 6
;   Title$ = Title for dialog
;   Msg$ = Message for dialog
;   Icon$ = Icon image
;   Button1$ = 1st Button name
;   Button2$ = 2nd Button name
;   Button3$ = 3rd Button name
; Returns: Name of button selected.
;-------------------------------------------------------------------------------
(defun GetButtons3 (Title$ Msg$ Icon$ Button1$ Button2$ Button3$ / )
  (if (or (= Icon$ "")(/= (type Icon$) 'STR)) (setq Icon$ "Exclam"))
  (TempDcl "GetButtons3" Title$ Msg$ Icon$)
);defun GetButtons3
;-------------------------------------------------------------------------------
; GetButtons4 - Returns name of button selected
; Arguments: 7
;   Title$ = Title for dialog
;   Msg$ = Message for dialog
;   Icon$ = Icon image
;   Button1$ = 1st Button name
;   Button2$ = 2nd Button name
;   Button3$ = 3rd Button name
;   Button4$ = 4th Button name
; Returns: Name of button selected.
;-------------------------------------------------------------------------------
(defun GetButtons4 (Title$ Msg$ Icon$ Button1$ Button2$ Button3$ Button4$ / )
  (if (or (= Icon$ "")(/= (type Icon$) 'STR)) (setq Icon$ "Exclam"))
  (TempDcl "GetButtons4" Title$ Msg$ Icon$)
);defun GetButtons4
;-------------------------------------------------------------------------------
; GetButtons5 - Returns name of button selected
; Arguments: 8
;   Title$ = Title for dialog
;   Msg$ = Message for dialog
;   Icon$ = Icon image
;   Button1$ = 1st Button name
;   Button2$ = 2nd Button name
;   Button3$ = 3rd Button name
;   Button4$ = 4th Button name
;   Button5$ = 5th Button name
; Returns: Name of button selected.
;-------------------------------------------------------------------------------
(defun GetButtons5 (Title$ Msg$ Icon$ Button1$ Button2$ Button3$ Button4$ Button5$ / )
  (if (or (= Icon$ "")(/= (type Icon$) 'STR)) (setq Icon$ "Exclam"))
  (TempDcl "GetButtons5" Title$ Msg$ Icon$)
);defun GetButtons5
;-------------------------------------------------------------------------------
; TempDcl - Creates a Temp.dcl dialog file and returns the button selected.
; Arguments: 4
;   Function$ = GetIcon Function name
;   Title$ = Title for dialog
;   Msg$ = Message lines for dialog
;   Icon$ = Icon image
; Returns: String of button selected.
;-------------------------------------------------------------------------------
(defun TempDcl (Function$ Title$ Msg$ IconName$ / Cnt# Choice# Icon$ MsgNum#
  Msg1$ Msg2$ Msg3$ Msg4$ Msg5$ Msg6$ Msg7$ Msg8$ Msg9$ Msg10$ FileName% Lines#
  Q$ Wid$ Wid1~ Wid2~ Wid3~ Wid4~ Wid5~ Wid6~ Wid7~ Wid8~ Wid9~ Wid10~ WidMax~
  Dcl_Id% IsIconFunction: FindReplace: PercentPercent:)
  ;-----------------------------------------------------------------------------
  ; IsIconFunction: - Checks if Icon$ is an image function.
  ; Arguments: 1
  ;   Icon$ = Icon$ string name
  ; Returns: Changes Icon$ name to "smile" if it's not an image function.
  ; Note: Other image functions may be added outside of GetIcon.lsp. The name
  ; of the image function and the start_image name must be the same with a ":"
  ; added to the function name, and the image function in all lower case. The
  ; image functions within GetIcon.lsp are 32 x 32 pixels.
  ;-----------------------------------------------------------------------------
  (defun IsIconFunction: (Icon$ / IconFunc$ Passed)
    (if (= (type Icon$) 'STR)
      (progn
        (setq IconFunc$ (strcat (strcase Icon$) ":")
              Icon$ (strcase Icon$ t)
        );setq
        (if (or (member (read IconFunc$) (atoms-family 0))(= Icon$ "none"))
          (setq Passed t)
        );if
      );progn
    );if
    (if (not Passed) (setq Icon$ "smile"))
    Icon$
  );defun IsIconFunction:
  ;-----------------------------------------------------------------------------
  ; FindReplace: - Returns Str$ with Find$ changed to Replace$
  ; Arguments: 3
  ;   Str$ = Text string
  ;   Find$ = Phrase string to find
  ;   Replace$ = Phrase to replace Find$ with
  ; Returns: Returns Str$ with Find$ changed to Replace$
  ;-----------------------------------------------------------------------------
  (defun FindReplace: (Str$ Find$ Replace$ / Len# Num# Start#)
    (setq Len# (strlen Replace$))
    (while (setq Num# (vl-string-search Find$ Str$ Start#))
      (setq Str$ (vl-string-subst Replace$ Find$ Str$ Num#)
            Start# (+ Num# Len#)
      );setq
    );while
    Str$
  );defun FindReplace:
  ;-----------------------------------------------------------------------------
  ; PercentPercent: - Replaces special characters begining with %%.
  ; Arguments: 1
  ;   Str$ = String
  ; Returns: String with %%d, %%c and %%p characters replaced.
  ;-----------------------------------------------------------------------------
  (defun PercentPercent: (Str$)
    (if (wcmatch Str$ "*%%D*")
      (setq Str$ (FindReplace: Str$ "%%D" (chr 176)));degree
    );if
    (if (wcmatch Str$ "*%%d*")
      (setq Str$ (FindReplace: Str$ "%%d" (chr 176)));degree
    );if
    (if (wcmatch Str$ "*%%P*")
      (setq Str$ (FindReplace: Str$ "%%P" (chr 177)));plus/minus
    );if
    (if (wcmatch Str$ "*%%p*")
      (setq Str$ (FindReplace: Str$ "%%p" (chr 177)));plus/minus
    );if
    (if (wcmatch Str$ "*%%C*")
      (setq Str$ (FindReplace: Str$ "%%C" (chr 248)));diameter
    );if
    (if (wcmatch Str$ "*%%c*")
      (setq Str$ (FindReplace: Str$ "%%c" (chr 248)));diameter
    );if
    Str$
  );defun PercentPercent:
  ;-----------------------------------------------------------------------------
  ; TempDcl - Start Main Function
  ;-----------------------------------------------------------------------------
  (if (not (findfile "C:\\Temp\\Temp.dcl"))
    (progn (vl-load-com)(vl-mkdir "C:\\Temp"))
  );if
  (if (/= (type Function$) 'STR) (setq Function$ "GetOK"))
  (if (not (member Function$ (list "GetOK" "GetOKCancel" "GetYesNo" "GetYesNoCancel"
      "GetYestoAll" "GetRetryCancel" "GetButtons1" "GetButtons2" "GetButtons3" "GetButtons4" "GetButtons5"))
    );list
    (setq Function$ "GetOK")
  );if
  (setq Icon$ (IsIconFunction: IconName$))
  (if (/= (type Title$) 'STR) (setq Title$ ""))
  (setq Title$ (PercentPercent: Title$))
  (if (/= (type Msg$) 'STR) (setq Msg$ ""))
  (setq Msg$ (PercentPercent: Msg$))
  (setq Cnt# 1 MsgNum# 0 Msg1$ "" Msg2$ "" Msg3$ "" Msg4$ "" Msg5$ "" Msg6$ "" Msg7$ "" Msg8$ "" Msg9$ "" Msg10$ "")
  (repeat (strlen Msg$)
    (setq Mid$ (substr Msg$ Cnt# 1))
    (if (and (>= Mid$ " ")(<= Mid$ (chr 255)))
      (cond
        ((= MsgNum# 0)(setq MsgNum# 1)(setq Msg1$ (strcat Msg1$ Mid$)))
        ((= MsgNum# 1)(setq Msg1$ (strcat Msg1$ Mid$)))
        ((= MsgNum# 2)(setq Msg2$ (strcat Msg2$ Mid$)))
        ((= MsgNum# 3)(setq Msg3$ (strcat Msg3$ Mid$)))
        ((= MsgNum# 4)(setq Msg4$ (strcat Msg4$ Mid$)))
        ((= MsgNum# 5)(setq Msg5$ (strcat Msg5$ Mid$)))
        ((= MsgNum# 6)(setq Msg6$ (strcat Msg6$ Mid$)))
        ((= MsgNum# 7)(setq Msg7$ (strcat Msg7$ Mid$)))
        ((= MsgNum# 8)(setq Msg8$ (strcat Msg8$ Mid$)))
        ((= MsgNum# 9)(setq Msg9$ (strcat Msg9$ Mid$)))
        ((= MsgNum# 10)(setq Msg10$ (strcat Msg10$ Mid$)))
      );cond
      (progn
        (if (= Mid$ "\n") (setq MsgNum# (1+ MsgNum#)))
        (if (> MsgNum# 10) (setq MsgNum# 10))
      );progn
    );if
    (setq Cnt# (1+ Cnt#))
  );repeat
  (setq Wid1~ (+ (GetDclWidth Msg1$) 0.5)
        Wid2~ (+ (GetDclWidth Msg2$) 0.5)
        Wid3~ (+ (GetDclWidth Msg3$) 0.5)
        Wid4~ (+ (GetDclWidth Msg4$) 0.5)
        Wid5~ (+ (GetDclWidth Msg5$) 0.5)
        Wid6~ (+ (GetDclWidth Msg6$) 0.5)
        Wid7~ (+ (GetDclWidth Msg7$) 0.5)
        Wid8~ (+ (GetDclWidth Msg8$) 0.5)
        Wid9~ (+ (GetDclWidth Msg9$) 0.5)
        Wid10~ (+ (GetDclWidth Msg10$) 0.5)
  );setq
  (setq WidMax~ Wid1~)
  (if (> Wid2~ WidMax~) (setq WidMax~ Wid2~))
  (if (> Wid3~ WidMax~) (setq WidMax~ Wid3~))
  (if (> Wid4~ WidMax~) (setq WidMax~ Wid4~))
  (if (> Wid5~ WidMax~) (setq WidMax~ Wid5~))
  (if (> Wid6~ WidMax~) (setq WidMax~ Wid6~))
  (if (> Wid7~ WidMax~) (setq WidMax~ Wid7~))
  (if (> Wid8~ WidMax~) (setq WidMax~ Wid8~))
  (if (> Wid9~ WidMax~) (setq WidMax~ Wid9~))
  (if (> Wid10~ WidMax~) (setq WidMax~ Wid10~))
  (setq Lines# 1)
  (if (/= Msg2$ "") (setq Lines# 2))
  (if (/= Msg3$ "") (setq Lines# 3))
  (if (/= Msg4$ "") (setq Lines# 4))
  (if (/= Msg5$ "") (setq Lines# 5))
  (if (/= Msg6$ "") (setq Lines# 6))
  (if (/= Msg7$ "") (setq Lines# 7))
  (if (/= Msg8$ "") (setq Lines# 8))
  (if (/= Msg9$ "") (setq Lines# 9))
  (if (/= Msg10$ "") (setq Lines# 10))
  (if (/= Icon$ "none")
    (cond
      ((member Function$ (list "GetYestoAll"))
        (if (< WidMax~ 53) (setq WidMax~ 53)))
      ((member Function$ (list "GetYesNoCancel"))
        (if (< WidMax~ 29) (setq WidMax~ 29)))
      ((member Function$ (list "GetOKCancel" "GetRetryCancel"))
        (if (< WidMax~ 16) (setq WidMax~ 16)))
      ((member Function$ (list "GetOK" "GetYesNo"))
        (if (< WidMax~ 10) (setq WidMax~ 10)))
    );cond
  );if
  (setq Wid$ (rtos WidMax~ 2 3) Q$ (chr 34))
  (setq FileName% (open "C:\\Temp\\Temp.dcl" "w"))
  (write-line "dcl_settings : default_dcl_settings { audit_level = 3; }" FileName%)
  (write-line "Temp : dialog {" FileName%)
  (write-line (strcat "  key = "Q$"title"Q$";") FileName%)
  (write-line (strcat "  label = "Q$ Q$";") FileName%)
  (if (/= Icon$ "none")
    (if (< Lines# 3)
      (progn
        (write-line "  : row {" FileName%)
        (write-line "    : column {" FileName%)
        (write-line "      fixed_width = true;" FileName%)
        (write-line "      : row {" FileName%)
        (write-line "        : column {" FileName%)
        (write-line "          spacer;" FileName%)
        (write-line "          : image {" FileName%)
        (write-line (strcat "            key = "Q$ Icon$ Q$";") FileName%)
        (write-line "            width = 5.42;" FileName%)
        (write-line "            height = 2.51;" FileName%)
        (write-line "            fixed_width = true;" FileName%)
        (write-line "            fixed_height = true;" FileName%)
        (write-line "            aspect_ratio = 1;" FileName%)
        (write-line "            color = -15;" FileName%)
        (write-line "          }" FileName%)
        (write-line "          spacer;" FileName%)
        (write-line "        }" FileName%)
        (write-line "        : column {" FileName%)
        (write-line "          spacer;" FileName%)
        (write-line "          : text {" FileName%)
        (write-line (strcat "            key = "Q$"msg1"Q$";") FileName%)
        (write-line (strcat "            label = "Q$ Q$";") FileName%)
        (write-line (strcat "            width = " Wid$ ";") FileName%)
        (write-line "            fixed_width = true;" FileName%)
        (write-line "            vertical_margin = none;" FileName%)
        (write-line "          }" FileName%)
        (if (= Lines# 2)
          (progn
            (write-line "          : text {" FileName%)
            (write-line (strcat "            key = "Q$"msg2"Q$";") FileName%)
            (write-line (strcat "            label = "Q$ Q$";") FileName%)
            (write-line (strcat "            width = " Wid$ ";") FileName%)
            (write-line "            fixed_width = true;" FileName%)
            (write-line "            vertical_margin = none;" FileName%)
            (write-line "          }" FileName%)
          );progn
        );if
        (write-line "          spacer;" FileName%)
        (write-line "        }" FileName%)
        (write-line "      }" FileName%)
        (write-line "    }" FileName%)
        (if (member Function$ (list "GetButtons1" "GetButtons2" "GetButtons3" "GetButtons4" "GetButtons5"))
          (write-line "    spacer;" FileName%)
        );if
        (write-line "  }" FileName%)
      );progn
      (progn
        (write-line "  spacer;" FileName%)
        (write-line "  : row {" FileName%)
        (write-line "    : column {" FileName%)
        (write-line "      fixed_width = true;" FileName%)
        (write-line "      : row {" FileName%)
        (write-line "        : image {" FileName%)
        (write-line (strcat "          key = "Q$ Icon$ Q$";") FileName%)
        (write-line "          width = 5.42;" FileName%)
        (write-line "          height = 2.51;" FileName%)
        (write-line "          fixed_width = true;" FileName%)
        (write-line "          fixed_height = true;" FileName%)
        (write-line "          aspect_ratio = 1;" FileName%)
        (write-line "          color = -15;" FileName%)
        (write-line "        }" FileName%)
        (write-line "        : column {" FileName%)
        (write-line "          : text {" FileName%)
        (write-line (strcat "            key = "Q$"msg1"Q$";") FileName%)
        (write-line (strcat "            label = "Q$ Q$";") FileName%)
        (write-line (strcat "            width = " Wid$ ";") FileName%)
        (write-line "            fixed_width = true;" FileName%)
        (write-line "            vertical_margin = none;" FileName%)
        (write-line "          }" FileName%)
        (write-line "          : text {" FileName%)
        (write-line (strcat "            key = "Q$"msg2"Q$";") FileName%)
        (write-line (strcat "            label = "Q$ Q$";") FileName%)
        (write-line (strcat "            width = " Wid$ ";") FileName%)
        (write-line "            fixed_width = true;" FileName%)
        (write-line "            vertical_margin = none;" FileName%)
        (write-line "          }" FileName%)
        (if (>= Lines# 3)
          (progn
            (write-line "          : text {" FileName%)
            (write-line (strcat "            key = "Q$"msg3"Q$";") FileName%)
            (write-line (strcat "            label = "Q$ Q$";") FileName%)
            (write-line (strcat "            width = " Wid$ ";") FileName%)
            (write-line "            fixed_width = true;" FileName%)
            (write-line "            vertical_margin = none;" FileName%)
            (write-line "          }" FileName%)
          );progn
        );if
        (if (>= Lines# 4)
          (progn
            (write-line "          : text {" FileName%)
            (write-line (strcat "            key = "Q$"msg4"Q$";") FileName%)
            (write-line (strcat "            label = "Q$ Q$";") FileName%)
            (write-line (strcat "            width = " Wid$ ";") FileName%)
            (write-line "            fixed_width = true;" FileName%)
            (write-line "            vertical_margin = none;" FileName%)
            (write-line "          }" FileName%)
          );progn
        );if
        (if (>= Lines# 5)
          (progn
            (write-line "          : text {" FileName%)
            (write-line (strcat "            key = "Q$"msg5"Q$";") FileName%)
            (write-line (strcat "            label = "Q$ Q$";") FileName%)
            (write-line (strcat "            width = " Wid$ ";") FileName%)
            (write-line "            fixed_width = true;" FileName%)
            (write-line "            vertical_margin = none;" FileName%)
            (write-line "          }" FileName%)
          );progn
        );if
        (if (>= Lines# 6)
          (progn
            (write-line "          : text {" FileName%)
            (write-line (strcat "            key = "Q$"msg6"Q$";") FileName%)
            (write-line (strcat "            label = "Q$ Q$";") FileName%)
            (write-line (strcat "            width = " Wid$ ";") FileName%)
            (write-line "            fixed_width = true;" FileName%)
            (write-line "            vertical_margin = none;" FileName%)
            (write-line "          }" FileName%)
          );progn
        );if
        (if (>= Lines# 7)
          (progn
            (write-line "          : text {" FileName%)
            (write-line (strcat "            key = "Q$"msg7"Q$";") FileName%)
            (write-line (strcat "            label = "Q$ Q$";") FileName%)
            (write-line (strcat "            width = " Wid$ ";") FileName%)
            (write-line "            fixed_width = true;" FileName%)
            (write-line "            vertical_margin = none;" FileName%)
            (write-line "          }" FileName%)
          );progn
        );if
        (if (>= Lines# 8)
          (progn
            (write-line "          : text {" FileName%)
            (write-line (strcat "            key = "Q$"msg8"Q$";") FileName%)
            (write-line (strcat "            label = "Q$ Q$";") FileName%)
            (write-line (strcat "            width = " Wid$ ";") FileName%)
            (write-line "            fixed_width = true;" FileName%)
            (write-line "            vertical_margin = none;" FileName%)
            (write-line "          }" FileName%)
          );progn
        );if
        (if (>= Lines# 9)
          (progn
            (write-line "          : text {" FileName%)
            (write-line (strcat "            key = "Q$"msg9"Q$";") FileName%)
            (write-line (strcat "            label = "Q$ Q$";") FileName%)
            (write-line (strcat "            width = " Wid$ ";") FileName%)
            (write-line "            fixed_width = true;" FileName%)
            (write-line "            vertical_margin = none;" FileName%)
            (write-line "          }" FileName%)
          );progn
        );if
        (if (>= Lines# 10)
          (progn
            (write-line "          : text {" FileName%)
            (write-line (strcat "            key = "Q$"msg10"Q$";") FileName%)
            (write-line (strcat "            label = "Q$ Q$";") FileName%)
            (write-line (strcat "            width = " Wid$ ";") FileName%)
            (write-line "            fixed_width = true;" FileName%)
            (write-line "            vertical_margin = none;" FileName%)
            (write-line "          }" FileName%)
          );progn
        );if
        (write-line "        }" FileName%)
        (write-line "      }" FileName%)
        (write-line "    }" FileName%)
        (if (member Function$ (list "GetButtons1" "GetButtons2" "GetButtons3" "GetButtons4" "GetButtons5"))
          (write-line "    spacer;" FileName%)
        );if
        (write-line "  }" FileName%)
      );progn
    );if
    (progn;(= Icon$ "none")
      (write-line "  : column {" FileName%)
      (write-line "    alignment = centered;" FileName%)
      (write-line (strcat "    width = " Wid$ ";") FileName%)
      (write-line "    fixed_width = true;" FileName%)
      (if (<= Lines# 2)
        (progn
          (write-line "    : spacer {" FileName%)
          (write-line "      height = 0.27;" FileName%)
          (write-line "    }" FileName%)
        );progn
        (write-line "    spacer;" FileName%)
      );if
      (write-line "    : text {" FileName%)
      (write-line (strcat "      key = "Q$"msg1"Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Q$";") FileName%)
      (write-line (strcat "      width = " Wid$ ";") FileName%)
      (write-line "      fixed_width = true;" FileName%)
      (write-line "      vertical_margin = none;" FileName%)
      (write-line "    }" FileName%)
      (if (>= Lines# 2)
        (progn
          (write-line "    : text {" FileName%)
          (write-line (strcat "      key = "Q$"msg2"Q$";") FileName%)
          (write-line (strcat "      label = "Q$ Q$";") FileName%)
          (write-line (strcat "      width = " Wid$ ";") FileName%)
          (write-line "      fixed_width = true;" FileName%)
          (write-line "      vertical_margin = none;" FileName%)
          (write-line "    }" FileName%)
        );progn
      );if
      (if (>= Lines# 3)
        (progn
          (write-line "    : text {" FileName%)
          (write-line (strcat "      key = "Q$"msg3"Q$";") FileName%)
          (write-line (strcat "      label = "Q$ Q$";") FileName%)
          (write-line (strcat "      width = " Wid$ ";") FileName%)
          (write-line "      fixed_width = true;" FileName%)
          (write-line "      vertical_margin = none;" FileName%)
          (write-line "    }" FileName%)
        );progn
      );if
      (if (>= Lines# 4)
        (progn
          (write-line "    : text {" FileName%)
          (write-line (strcat "      key = "Q$"msg4"Q$";") FileName%)
          (write-line (strcat "      label = "Q$ Q$";") FileName%)
          (write-line (strcat "      width = " Wid$ ";") FileName%)
          (write-line "      fixed_width = true;" FileName%)
          (write-line "      vertical_margin = none;" FileName%)
          (write-line "    }" FileName%)
        );progn
      );if
      (if (>= Lines# 5)
        (progn
          (write-line "    : text {" FileName%)
          (write-line (strcat "      key = "Q$"msg5"Q$";") FileName%)
          (write-line (strcat "      label = "Q$ Q$";") FileName%)
          (write-line (strcat "      width = " Wid$ ";") FileName%)
          (write-line "      fixed_width = true;" FileName%)
          (write-line "      vertical_margin = none;" FileName%)
          (write-line "    }" FileName%)
        );progn
      );if
      (if (>= Lines# 6)
        (progn
          (write-line "    : text {" FileName%)
          (write-line (strcat "      key = "Q$"msg6"Q$";") FileName%)
          (write-line (strcat "      label = "Q$ Q$";") FileName%)
          (write-line (strcat "      width = " Wid$ ";") FileName%)
          (write-line "      fixed_width = true;" FileName%)
          (write-line "      vertical_margin = none;" FileName%)
          (write-line "    }" FileName%)
        );progn
      );if
      (if (>= Lines# 7)
        (progn
          (write-line "    : text {" FileName%)
          (write-line (strcat "      key = "Q$"msg7"Q$";") FileName%)
          (write-line (strcat "      label = "Q$ Q$";") FileName%)
          (write-line (strcat "      width = " Wid$ ";") FileName%)
          (write-line "      fixed_width = true;" FileName%)
          (write-line "      vertical_margin = none;" FileName%)
          (write-line "    }" FileName%)
        );progn
      );if
      (if (>= Lines# 8)
        (progn
          (write-line "    : text {" FileName%)
          (write-line (strcat "      key = "Q$"msg8"Q$";") FileName%)
          (write-line (strcat "      label = "Q$ Q$";") FileName%)
          (write-line (strcat "      width = " Wid$ ";") FileName%)
          (write-line "      fixed_width = true;" FileName%)
          (write-line "      vertical_margin = none;" FileName%)
          (write-line "    }" FileName%)
        );progn
      );if
      (if (>= Lines# 9)
        (progn
          (write-line "    : text {" FileName%)
          (write-line (strcat "      key = "Q$"msg9"Q$";") FileName%)
          (write-line (strcat "      label = "Q$ Q$";") FileName%)
          (write-line (strcat "      width = " Wid$ ";") FileName%)
          (write-line "      fixed_width = true;" FileName%)
          (write-line "      vertical_margin = none;" FileName%)
          (write-line "    }" FileName%)
        );progn
      );if
      (if (>= Lines# 10)
        (progn
          (write-line "    : text {" FileName%)
          (write-line (strcat "      key = "Q$"msg10"Q$";") FileName%)
          (write-line (strcat "      label = "Q$ Q$";") FileName%)
          (write-line (strcat "      width = " Wid$ ";") FileName%)
          (write-line "      fixed_width = true;" FileName%)
          (write-line "      vertical_margin = none;" FileName%)
          (write-line "    }" FileName%)
        );progn
      );if
      (write-line "  }" FileName%)
      (if (> Lines# 2)
        (write-line "  spacer;" FileName%)
      );if
    );progn
  );if
  (if (and (<= Lines# 2)(= Icon$ "none"))
    (progn
      (write-line "  : spacer {" FileName%)
      (write-line "    height = 0.27;" FileName%)
      (write-line "  }" FileName%)
    );progn
  );if
  (if (and (> Lines# 2)(/= Icon$ "none"))
    (write-line "  spacer;" FileName%)
  );if
  ;-----------------------------------------------------------------------------
  (cond
    ((= Function$ "GetOK")
      (write-line "  : ok_button {" FileName%)
      (write-line (strcat "    label = "Q$"OK"Q$";") FileName%)
      (write-line "    width = 8.0;" FileName%)
      (write-line "    is_cancel = true;" FileName%)
      (write-line "  }" FileName%)
      (write-line "}" FileName%)
    );GetOK
    ((= Function$ "GetOKCancel")
      (write-line "  : row {" FileName%)
      (write-line "    : column {" FileName%)
      (write-line "      : ok_button {" FileName%)
      (write-line "        alignment = right;" FileName%)
      (write-line "        width = 11;" FileName%)
      (write-line "      }" FileName%)
      (write-line "    }" FileName%)
      (write-line "    : column {" FileName%)
      (write-line "      : cancel_button {" FileName%)
      (write-line "        alignment = left;" FileName%)
      (write-line "        width = 11;" FileName%)
      (write-line "      }" FileName%)
      (write-line "    }" FileName%)
      (write-line "  }" FileName%)
      (write-line "}" FileName%)
    );GetOKCancel
    ((= Function$ "GetYesNo")
      (write-line "  : row {" FileName%)
      (write-line "    : column {" FileName%)
      (write-line "      : ok_button {" FileName%)
      (write-line (strcat "        label = "Q$"&Yes"Q$";") FileName%)
      (write-line "        alignment = right;" FileName%)
      (write-line "        width = 8.0;" FileName%)
      (write-line "      }" FileName%)
      (write-line "    }" FileName%)
      (write-line "    : column {" FileName%)
      (write-line "      : cancel_button {" FileName%)
      (write-line (strcat "        label = "Q$"&No"Q$";") FileName%)
      (write-line "        alignment = left;" FileName%)
      (write-line "        width = 8.0;" FileName%)
      (write-line "      }" FileName%)
      (write-line "    }" FileName%)
      (write-line "  }" FileName%)
      (write-line "}" FileName%)
    );GetYesNo
    ((= Function$ "GetRetryCancel")
      (write-line "  : row {" FileName%)
      (write-line "    : column {" FileName%)
      (write-line "      : ok_button {" FileName%)
      (write-line (strcat "        label = "Q$"&Retry"Q$";") FileName%)
      (write-line "        alignment = right;" FileName%)
      (write-line "        width = 11;" FileName%)
      (write-line "      }" FileName%)
      (write-line "    }" FileName%)
      (write-line "    : column {" FileName%)
      (write-line "      : cancel_button {" FileName%)
      (write-line "        alignment = left;" FileName%)
      (write-line "        width = 11;" FileName%)
      (write-line "      }" FileName%)
      (write-line "    }" FileName%)
      (write-line "  }" FileName%)
      (write-line "}" FileName%)
    );GetRetryCancel
    ((= Function$ "GetYesNoCancel")
      (write-line "  : row {" FileName%)
      (write-line "    fixed_width = true;" FileName%)
      (write-line "    alignment = centered;" FileName%)
      (write-line "    : ok_button {" FileName%)
      (write-line (strcat "      key = "Q$"OK"Q$";") FileName%)
      (write-line (strcat "      label = "Q$"&Yes"Q$";") FileName%)
      (write-line "      width = 11;" FileName%)
      (write-line "    }" FileName%)
      (write-line "    : button {" FileName%)
      (write-line (strcat "      key = "Q$"No"Q$";") FileName%)
      (write-line (strcat "      label = "Q$"&No"Q$";") FileName%)
      (write-line "      width = 11;" FileName%)
      (write-line "    }" FileName%)
      (write-line "    : cancel_button {" FileName%)
      (write-line "      width = 11;" FileName%)
      (write-line "    }" FileName%)
      (write-line "  }" FileName%)
      (write-line "}" FileName%)
    );GetYesNoCancel
    ((= Function$ "GetYestoAll")
      (write-line "  : row {" FileName%)
      (write-line "    fixed_width = true;" FileName%)
      (write-line "    alignment = centered;" FileName%)
      (write-line "    : ok_button {" FileName%)
      (write-line (strcat "      key = "Q$"OK"Q$";") FileName%)
      (write-line (strcat "      label = "Q$"&Yes"Q$";") FileName%)
      (write-line "      width = 14;" FileName%)
      (write-line "    }" FileName%)
      (write-line "    : button {" FileName%)
      (write-line (strcat "      key = "Q$"YestoAll"Q$";") FileName%)
      (write-line (strcat "      label = "Q$"Yes to &All"Q$";") FileName%)
      (write-line "      width = 14;" FileName%)
      (write-line "    }" FileName%)
      (write-line "    : button {" FileName%)
      (write-line (strcat "      key = "Q$"No"Q$";") FileName%)
      (write-line (strcat "      label = "Q$"&No"Q$";") FileName%)
      (write-line "      width = 14;" FileName%)
      (write-line "    }" FileName%)
      (write-line "    : cancel_button {" FileName%)
      (write-line "      width = 14;" FileName%)
      (write-line "    }" FileName%)
      (write-line "  }" FileName%)
      (write-line "}" FileName%)
    );GetYestoAll
    ((= Function$ "GetButtons1")
      (write-line "  : row {" FileName%)
      (write-line "    fixed_width = true;" FileName%)
      (write-line "    alignment = centered;" FileName%)
      (write-line "    : button {" FileName%)
      (write-line "      is_default = true;" FileName%)
      (write-line "      is_cancel = true;" FileName%)
      (write-line (strcat "      key = "Q$ Button1$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button1$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "  }" FileName%)
      (write-line "}" FileName%)
    );GetButtons1
    ((= Function$ "GetButtons2")
      (write-line "  : row {" FileName%)
      (write-line "    fixed_width = true;" FileName%)
      (write-line "    alignment = centered;" FileName%)
      (write-line "    : button {" FileName%)
      (write-line "      is_default = true;" FileName%)
      (write-line (strcat "      key = "Q$ Button1$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button1$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "    : button {" FileName%)
      (write-line "      is_cancel = true;" FileName%)
      (write-line (strcat "      key = "Q$ Button2$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button2$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "  }" FileName%)
      (write-line "}" FileName%)
    );GetButtons2
    ((= Function$ "GetButtons3")
      (write-line "  : row {" FileName%)
      (write-line "    fixed_width = true;" FileName%)
      (write-line "    alignment = centered;" FileName%)
      (write-line "    : button {" FileName%)
      (write-line "      is_default = true;" FileName%)
      (write-line (strcat "      key = "Q$ Button1$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button1$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "    : button {" FileName%)
      (write-line (strcat "      key = "Q$ Button2$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button2$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "    : button {" FileName%)
      (write-line "      is_cancel = true;" FileName%)
      (write-line (strcat "      key = "Q$ Button3$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button3$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "  }" FileName%)
      (write-line "}" FileName%)
    );GetButtons3
    ((= Function$ "GetButtons4")
      (write-line "  : row {" FileName%)
      (write-line "    fixed_width = true;" FileName%)
      (write-line "    alignment = centered;" FileName%)
      (write-line "    : button {" FileName%)
      (write-line "      is_default = true;" FileName%)
      (write-line (strcat "      key = "Q$ Button1$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button1$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "    : button {" FileName%)
      (write-line (strcat "      key = "Q$ Button2$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button2$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "    : button {" FileName%)
      (write-line (strcat "      key = "Q$ Button3$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button3$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "    : button {" FileName%)
      (write-line "      is_cancel = true;" FileName%)
      (write-line (strcat "      key = "Q$ Button4$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button4$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "  }" FileName%)
      (write-line "}" FileName%)
    );GetButtons4
    ((= Function$ "GetButtons5")
      (write-line "  : row {" FileName%)
      (write-line "    fixed_width = true;" FileName%)
      (write-line "    alignment = centered;" FileName%)
      (write-line "    : button {" FileName%)
      (write-line "      is_default = true;" FileName%)
      (write-line (strcat "      key = "Q$ Button1$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button1$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "    : button {" FileName%)
      (write-line (strcat "      key = "Q$ Button2$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button2$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "    : button {" FileName%)
      (write-line (strcat "      key = "Q$ Button3$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button3$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "    : button {" FileName%)
      (write-line (strcat "      key = "Q$ Button4$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button4$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "    : button {" FileName%)
      (write-line "      is_cancel = true;" FileName%)
      (write-line (strcat "      key = "Q$ Button5$ Q$";") FileName%)
      (write-line (strcat "      label = "Q$ Button5$ Q$";") FileName%)
      (write-line "    }" FileName%)
      (write-line "  }" FileName%)
      (write-line "}" FileName%)
    );GetButtons5
  );cond
  (close FileName%)
  (setq Dcl_Id% (load_dialog "C:\\Temp\\Temp.dcl"))
  (new_dialog "Temp" Dcl_Id%)
  (if (= Title$ "") (setq Title$ "AutoCAD Message"))
  (set_tile "title" (strcat " " Title$))
  (set_tile "msg1" Msg1$)
  (set_tile "msg2" Msg2$)
  (set_tile "msg3" Msg3$)
  (set_tile "msg4" Msg4$)
  (set_tile "msg5" Msg5$)
  (set_tile "msg6" Msg6$)
  (set_tile "msg7" Msg7$)
  (set_tile "msg8" Msg8$)
  (set_tile "msg9" Msg9$)
  (set_tile "msg10" Msg10$)
  (if (/= Icon$ "none")
    (eval (read (strcat "(" Icon$ ":)")))
  );if
  (cond
    ((= Function$ "GetOK")
      (action_tile "OK" "(done_dialog)")
      (start_dialog)
      (unload_dialog Dcl_Id%)
      "OK"
    );case
    ((= Function$ "GetOKCancel")
      (action_tile "OK" "(done_dialog)")
      (action_tile "cancel" "(done_dialog)")
      (setq Choice# (start_dialog))
      (unload_dialog Dcl_Id%)
      (if (= Choice# 1) "OK" "Cancel")
    );case
    ((= Function$ "GetYesNo")
      (action_tile "OK" "(done_dialog)")
      (action_tile "cancel" "(done_dialog)")
      (setq Choice# (start_dialog))
      (unload_dialog Dcl_Id%)
      (if (= Choice# 1) "Yes" "No")
    );case
    ((= Function$ "GetRetryCancel")
      (action_tile "OK" "(done_dialog)")
      (action_tile "cancel" "(done_dialog)")
      (setq Choice# (start_dialog))
      (unload_dialog Dcl_Id%)
      (if (= Choice# 1) "Retry" "Cancel")
    );case
    ((= Function$ "GetYesNoCancel")
      (action_tile "OK" "(done_dialog 2)")
      (action_tile "No" "(done_dialog 1)")
      (action_tile "cancel" "(done_dialog)")
      (setq Choice# (start_dialog))
      (unload_dialog Dcl_Id%)
      (cond
        ((= Choice# 0) "Cancel")
        ((= Choice# 1) "No")
        ((= Choice# 2) "Yes")
      );cond
    );case
    ((= Function$ "GetYestoAll")
      (action_tile "OK" "(done_dialog 3)")
      (action_tile "YestoAll" "(done_dialog 2)")
      (action_tile "No" "(done_dialog 1)")
      (action_tile "cancel" "(done_dialog)")
      (setq Choice# (start_dialog))
      (unload_dialog Dcl_Id%)
      (cond
        ((= Choice# 0) "Cancel")
        ((= Choice# 1) "No")
        ((= Choice# 2) "Yes to All")
        ((= Choice# 3) "Yes")
      );cond
    );case
    ((= Function$ "GetButtons1")
      (action_tile "OK" "(done_dialog)")
      (start_dialog)
      (unload_dialog Dcl_Id%)
      Button1$
    );case
    ((= Function$ "GetButtons2")
      (action_tile "OK" "(done_dialog)")
      (action_tile "cancel" "(done_dialog)")
      (setq Choice# (start_dialog))
      (unload_dialog Dcl_Id%)
      (if (= Choice# 1) Button1$ Button2$)
    );case
    ((= Function$ "GetButtons3")
      (action_tile Button1$ "(done_dialog 2)")
      (action_tile Button2$ "(done_dialog 1)")
      (action_tile "cancel" "(done_dialog)")
      (setq Choice# (start_dialog))
      (unload_dialog Dcl_Id%)
      (cond
        ((= Choice# 0) Button3$)
        ((= Choice# 1) Button2$)
        ((= Choice# 2) Button1$)
      );cond
    );case
    ((= Function$ "GetButtons4")
      (action_tile Button1$ "(done_dialog 3)")
      (action_tile Button2$ "(done_dialog 2)")
      (action_tile Button3$ "(done_dialog 1)")
      (action_tile "cancel" "(done_dialog)")
      (setq Choice# (start_dialog))
      (unload_dialog Dcl_Id%)
      (cond
        ((= Choice# 0) Button4$)
        ((= Choice# 1) Button3$)
        ((= Choice# 2) Button2$)
        ((= Choice# 3) Button1$)
      );cond
    );case
    ((= Function$ "GetButtons5")
      (action_tile Button1$ "(done_dialog 4)")
      (action_tile Button2$ "(done_dialog 3)")
      (action_tile Button3$ "(done_dialog 2)")
      (action_tile Button4$ "(done_dialog 1)")
      (action_tile "cancel" "(done_dialog)")
      (setq Choice# (start_dialog))
      (unload_dialog Dcl_Id%)
      (cond
        ((= Choice# 0) Button5$)
        ((= Choice# 1) Button4$)
        ((= Choice# 2) Button3$)
        ((= Choice# 3) Button2$)
        ((= Choice# 4) Button1$)
      );cond
    );case
  );cond
);defun TempDcl
;-------------------------------------------------------------------------------
; GetDclWidth - Get the true dialog string width.
; Arguments: 1
;   Str$ = String to get the dialog string width
; Returns: Dialog string width based on the Windows default MS Sans Serif font.
;-------------------------------------------------------------------------------
(defun GetDclWidth (Str$ / Cnt# Mid$ Num# Width~)
  (setq Cnt# 1 Num# 0 Width~ 0)
  (if (= (type Str$) 'STR)
    (repeat (strlen Str$)
      (setq Mid$ (substr Str$ Cnt# 1))
      (cond
        ((member Mid$ (list "@" "W"))
          (setq Num# (+ Num# 11));11 Pixels
        );case
        ((= Mid$ "M")
          (setq Num# (+ Num# 9));9 Pixels
        );case
        ((member Mid$ (list "%" "D" "G" "H" "N" "O" "Q" "R" "U" "m" "w"))
          (setq Num# (+ Num# 8));8 Pixels
        );case
        ((member Mid$ (list "#" "A" "B" "C" "E" "K" "P" "S" "T" "V" "X" "Y" "Z" "~"))
          (setq Num# (+ Num# 7));7 Pixels
        );case
        ((member Mid$ (list "$" "&" "+" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "<" "="
          ">" "?" "F" "L" "^" "_" "a" "b" "c" "d" "e" "g" "h" "k" "n" "o" "p" "q" "u" "v"))
          (setq Num# (+ Num# 6));6 Pixels
        );case
        ((member Mid$ (list (chr 34) "/" "J" (chr 92) "s" "x" "y" "z"))
          (setq Num# (+ Num# 5));5 Pixels
        );case
        ((member Mid$ (list "*" "{" "}"))
          (setq Num# (+ Num# 4));4 Pixels
        );case
        ((member Mid$ (list " " "!" "(" ")" "," "-" "." ":" ";" "I" "[" "]" "`" "f" "r" "t"))
          (setq Num# (+ Num# 3));3 Pixels
        );case
        ((member Mid$ (list "'" "i" "j" "l" "|"))
          (setq Num# (+ Num# 2));2 Pixels
        );case
        ((member (ascii Mid$) (list 198 230))
          (setq Num# (+ Num# 10));10 Pixels
        );case
        ((= (ascii Mid$) 169)
          (setq Num# (+ Num# 9));9 Pixels
        );case
        ((member (ascii Mid$) (list 174 188 189 190 208 209 210 211 212 213 214 216 217 218 219 220))
          (setq Num# (+ Num# 8));8 Pixels
        );case
        ((member (ascii Mid$) (list 192 193 194 195 196 197 199 200 201 202 203 221 222))
          (setq Num# (+ Num# 7));7 Pixels
        );case
        ((member (ascii Mid$) (list 128 162 163 164 165 167 171 172 175 177 181 182 187 191 215 223 224 225 226 227 228 229 231 232 233 234 235 240 241 242 243 244 245 246 247 248 249 250 251 252 254 255))
          (setq Num# (+ Num# 6));6 Pixels
        );case
        ((= (ascii Mid$) 253)
          (setq Num# (+ Num# 5));5 Pixels
        );case
        ((member (ascii Mid$) (list 170 176 186 237 238 239))
          (setq Num# (+ Num# 4));4 Pixels
        );case
        ((member (ascii Mid$) (list 127 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 168 173 178 179 180 183 184 185 204 205 206 207))
          (setq Num# (+ Num# 3));3 Pixels
        );case
        ((member (ascii Mid$) (list 166 236))
          (setq Num# (+ Num# 2));2 Pixels
        );case
        (t
          (setq Num# (+ Num# 7));7 Pixels default
        );case
      );cond
      (setq Cnt# (1+ Cnt#))
    );repeat
  );if
  (if (> Num# 0)
    (setq Width~ (atof (rtos (+ (* (1- Num#) (/ 1 6.0)) 0.09) 2 2)))
  );if
  Width~
);defun GetDclWidth
;-------------------------------------------------------------------------------
; AlertX: - Alert X icon
;-------------------------------------------------------------------------------
(defun AlertX: ()
  (start_image "alertx")
  (vector_line (list "C" 1 2 12 2 19 "C" 1 3 9 3 22 4 23 4 8 "C" 1 5 6 5 25 6
    26 6 5 7 5 7 26 8 27 8 4 9 3 9 28 10 28 10 3 11 3 11 28 12 29 12 2 13 2
    13 29 14 29 14 2 15 2 15 29 16 29 16 2 17 2 17 29 18 29 18 2 19 2 19 29
    20 28 20 3 21 3 21 28 22 28 22 3 23 4 23 27 24 26 24 5 25 5 25 26 26 25
    26 6 "C" 1 27 8 27 23 28 22 28 9 "C" 1 29 19 29 12)
  );vector_line
  (vector_line (list "C" 255 8 10 21 23 21 22 9 10 9 9 22 22 22 21 10 9 10 8
    23 21 "C" 255 8 21 21 8 21 9 9 21 9 22 22 9 22 10 10 22 10 23 23 10)
  );vector_line
  (vector_line (list "C" 16 12 30 19 30 20 29 22 29 24 27 25 27 27 25 27 24
    29 22 29 20 30 19 30 12 29 11 29 9 27 7 27 6 25 4 24 4 22 2 20 2 19 1 12
    1 11 2 9 2 7 4 6 4 4 6 4 7 2 9 2 11 1 12 1 19 2 20 2 22 4 24 4 25 6 27 7
    27 9 29 11 29)
  );vector_line
  (vector_line (list "C" 8 7 28 8 29 "C" 8 14 32 21 32 "C" 8 10 30 11 30 11
    31 24 31 25 30 20 30 "C" 8 27 29 23 29 24 28 28 28 29 27 26 27 27 26 29
    26 29 23 28 24 28 25 "C" 8 30 20 30 25 31 24 31 11 30 11 30 10 "C" 8 32
    21 32 14 "C" 8 28 7 29 8)
  );vector_line
  (end_image)
);defun AlertX:
;-------------------------------------------------------------------------------
; Block: - Block Replace icon
;-------------------------------------------------------------------------------
(defun Block: ()
  (start_image "block")
  (vector_line (list "C" 255 2 11 2 29 3 29 3 11 4 11 4 29 5 29 5 11 6 11 6
    29 7 29 7 11 8 11 8 29 9 29 9 11 10 11 10 29 11 29 11 11 12 11 12 29 13
    29 13 11 "C" 255 14 15 14 29 15 29 15 3 16 3 16 29 17 29 17 3 18 3 18 12
    19 14 19 3 20 3 20 21 21 21 21 3 22 3 22 21 23 21 23 3 24 3 24 21 25 21
    25 3 26 3 26 21 27 21 27 7 28 5 28 21 29 21 29 8 30 8 30 21)
  );vector_line
  (vector_line (list "C" 8 30 5 27 2 14 2 14 13 "C" 8 17 13 14 10 1 10 1 29
    "C" 8 27 3 27 5 "C" 8 28 7 30 7 "C" 8 15 15 17 15 "C" 8 2 31 19 31 19 15
    "C" 8 20 23 32 23 32 7)
  );vector_line
  (vector_line (list "C" 9 28 4 29 5 "C" 9 15 12 16 13))
  (vector_line (list "C" 250 1 30 18 30 18 14 14 14 "C" 250 20 22 31 22 31 6
    27 6)
  );vector_line
  (vector_line (list "C" 5 2 23 6 23 6 25 8 25 8 29 8 25 10 25 10 23 17 23 10
    23 10 21 8 21 8 11 8 21 6 21 6 22 "C" 5 21 21 21 17 20 17 23 17 23 15 "C"
    5 30 15 26 15 "C" 5 21 3 21 10 "C" 5 20 13 19 13 19 14 "C" 5 3 12 3 12
    "C" 5 6 12 6 12 "C" 5 10 12 10 12 "C" 5 13 12 13 12 "C" 5 3 15 3 15 "C" 5
    6 15 6 15 "C" 5 10 15 10 15 "C" 5 13 15 13 15 "C" 5 3 18 3 18 "C" 5 6 18
    6 18 "C" 5 10 18 10 18 "C" 5 13 18 13 18 "C" 5 16 18 16 18 "C" 5 3 21 3
    21 "C" 5 13 21 13 21 "C" 5 16 21 16 21 "C" 5 8 23 8 23 "C" 5 3 25 3 25
    "C" 5 13 25 13 25 "C" 5 16 25 16 25 "C" 5 3 28 3 28 "C" 5 6 28 6 28 "C" 5
    10 28 10 28 "C" 5 13 28 13 28 "C" 5 16 28 16 28 "C" 5 16 4 16 4 "C" 5 19
    4 19 4 "C" 5 23 4 23 4 "C" 5 26 4 26 4 "C" 5 16 7 16 7 "C" 5 19 7 19 7
    "C" 5 23 7 23 7 "C" 5 26 7 26 7 "C" 5 16 10 16 10 "C" 5 23 10 23 10 "C" 5
    29 10 29 10 "C" 5 26 13 26 13 "C" 5 29 13 29 13 "C" 5 29 17 29 17 "C" 5
    23 20 23 20 "C" 5 26 20 26 20 "C" 5 29 20 29 20)
  );vector_line
  (vector_line (list "C" 1 26 10 28 8 27 8 20 15 20 16 24 12 "C" 1 20 14 21
    13 16 8 16 9 17 8 17 10 "C" 1 26 16 19 9 18 9 27 18 "C" 1 28 20 28 20 "C"
    1 21 31 23 31 25 29 25 25 27 27 23 27 24 26 "C" 1 6 8 6 6 8 4 12 4 10 2
    10 6 11 5)
  );vector_line
  (end_image)
);defun Block:
;-------------------------------------------------------------------------------
; Computer: - Computer icon
;-------------------------------------------------------------------------------
(defun Computer: ()
  (start_image "computer")
  (vector_line (list "C" 8 3 23 3 18 4 17 4 4 5 3 6 3 7 2 8 2 9 1 12 1 13 2
    14 2 15 3 16 3 17 4 18 4 19 5 20 5 21 6 22 6 "C" 8 6 16 8 16 9 17 10 17
    11 18 12 18 13 19 14 19 15 20 16 20 17 21 "C" 8 8 6 9 6 10 7 11 7 12 8 13
    8 14 9 15 9 16 10 17 10 19 9 19 30 20 30 20 9 21 8 21 29 22 29 22 8 23 8
    23 28 24 28 24 8 "C" 8 28 21 28 26 27 26 27 21 26 20 26 27 25 27 25 7 26
    7 26 17 27 16 27 6 26 5 25 5 24 4 23 4 22 3 17 3)
  );vector_line
  (vector_line (list "C" 9 19 4 22 4 21 5 24 5 23 6 24 7 24 6 26 6 "C" 9 22 7
    21 7 20 8 20 6 19 6 19 8 18 9 18 5 17 5 17 9 16 9 16 4 15 4 15 8 14 8 14
    3 13 3 13 7 12 7 12 2 11 2 11 6 10 6 10 2 9 2 9 5 8 5 8 3 7 3 7 5 6 5 6
    15 5 16 5 18 4 18 "C" 9 5 20 5 23 6 24 6 17 7 17 7 24 8 25 8 17 9 18 9 25
    10 26 10 18 11 19 11 26 12 27 12 19 13 20 13 27 14 28 14 20 15 21 15 28
    16 29 16 21 17 22 17 29 18 30 18 10 "C" 9 19 26 20 26 21 25 22 25 23 24
    24 24 25 23 26 23 27 22 28 22)
  );vector_line
  (vector_line (list "C" 250 4 24 5 24 6 25 7 25 8 26 9 26 10 27 11 27 12 28
    13 28 14 29 15 29 16 30 17 30 18 31 20 31 21 30 22 30 23 29 24 29 25 28
    26 28 27 27 28 27 29 26 29 21 28 20 27 20 26 19 25 19 24 20 28 16 28 7
    "C" 250 5 17 6 18 7 18 8 19 9 19 10 20 11 20 12 21 13 21 14 22 15 22 16
    23 17 23 18 24 20 24 21 23 22 23 23 22 23 7 "C" 250 7 15 7 6)
  );vector_line
  (vector_line (list "C" 174 8 7 9 7 10 8 11 8 12 9 13 9 14 10 15 10 16 11 17
    11 17 20 16 19 15 19 14 18 13 18 12 17 11 17 10 16 9 16 8 15)
  );vector_line
  (vector_line (list "C" 5 8 8 8 14 9 15 9 8 10 9 10 15 11 16 11 9 12 10 12
    16 13 17 13 10 14 11 14 17 15 18 15 11 16 12 16 18)
  );vector_line
  (vector_line (list "C" 4 9 11 10 12 9 13 11 11 11 10 11 15 11 14 14 11 "C"
    4 13 15 13 15)
  );vector_line
  (vector_line (list "C" 255 4 23 4 19 5 19 6 20 7 20 8 21 9 21 10 22 11 22
    12 23 13 23 14 24 15 24 16 25 17 25 18 26 "C" 255 5 15 5 4 9 4 10 5 11 5
    12 6 13 6 14 7 15 7 16 8 17 8 "C" 255 11 12 11 12)
  );vector_line
  (vector_line (list "C" 3 6 22 7 22)
  );vector_line
  (vector_line (list "C" 96 6 23 7 23)
  );vector_line
  (vector_line (list "C" 2 11 13 11 13)
  );vector_line
  (end_image)
);defun Computer:
;-------------------------------------------------------------------------------
; Constr: - Constr icon
;-------------------------------------------------------------------------------
(defun Constr: ()
  (start_image "constr")
  (vector_line (list "C" 40 0 15 0 17 1 18 1 14 2 13 2 19 3 20 3 12 4 11 4 21
    5 22 5 10 6 9 6 23 7 24 7 8 8 7 8 25 9 26 9 6 10 5 10 27 11 28 11 4 12 3
    12 29 13 30 13 2 14 1 14 31 15 32 15 0 16 0 16 32 17 32 17 0 18 1 18 31
    19 30 19 2 20 3 20 29 21 28 21 4 22 5 22 27 23 26 23 6 24 7 24 25 25 24
    25 8 26 9 26 23 27 22 27 10 28 11 28 21 29 20 29 12 30 13 30 19 31 18 31
    14 32 15 32 17)
  );vector_line
  (vector_line (list "C" 250 1 17 1 15 15 1 17 1 31 15 31 17 17 31 15 31 1 17
    "C" 250 6 17 7 17 8 16 8 11 13 11 9 15 9 16 13 12 14 12 9 17 9 23 10 24
    11 24 10 23 10 17 13 20 13 24 15 24 14 23 14 20 11 17 11 16 23 16 22 17
    20 17 20 15 22 15 "C" 250 14 10 14 8 15 7 15 11 16 11 16 7 17 7 17 11 18
    10 18 8 "C" 250 17 24 22 24 22 23 17 23 18 22 21 22 20 21 19 21 "C" 250
    24 19 24 18 25 18 25 19 "C" 250 15 13 15 17 "C" 250 22 19 22 20 "C" 250
    24 21 24 22)
  );vector_line
  (vector_line (list "C" 8 18 32 32 18 32 19 19 32))
  (end_image)
);defun Constr:
;-------------------------------------------------------------------------------
; Delete: - Delete icon
;-------------------------------------------------------------------------------
(defun Delete: ()
  (start_image "delete")
  (vector_line (list "C" 255 9 3 8 4 6 4 5 5 4 5 4 7 5 7 6 8 7 8 8 9 9 9 10
    10 11 10 11 2 12 2 12 11 13 11 13 2 14 2 14 12 15 12 15 2 16 2 16 13 17
    13 17 2 18 2 18 14 19 14 19 2 20 2 20 14 21 14 21 2 "C" 255 22 14 22 6 23
    4 23 13 24 13 24 7 25 7 25 13 26 12 28 12 29 11 30 11 30 10 29 10 28 9 27
    9)
  );vector_line
  (vector_line (list "C" 9 4 9 4 8 5 8 5 13 "C" 9 6 17 6 9 7 9 7 21 "C" 9 8
    24 8 10 9 10 9 24 10 25 10 11 11 11 11 25 12 26 12 12 13 12 13 26 14 27
    14 13 15 13 15 27 16 28 16 14 17 14 17 28 18 29 18 15 19 15 19 29 20 30
    20 15 "C" 9 10 9 11 9 12 10 13 10 14 11 15 11 16 12 17 12 18 13 22 13 23
    12 25 12 26 11 28 11 28 10 27 10 "C" 9 24 4 23 3)
  );vector_line
  (vector_line (list "C" 8 30 9 29 9 28 8 26 8 26 6 23 6 22 5 22 1 10 1 10 8
    9 8 9 4 8 5 8 8 7 7 7 5 6 5 6 7 5 6 "C" 8 9 2 8 3 6 3 5 4 4 4 3 5 3 9 4
    10 4 13 5 14 5 17 6 18 6 21 7 22 7 25 9 25 10 26 11 26 12 27 13 27 14 28
    15 28 16 29 17 29 18 30 19 30 20 31 21 31 21 15 22 15 22 31 23 30 23 14
    24 14 24 30 25 29 25 14 26 13 26 29 "C" 8 27 25 27 13 28 13 28 21 "C" 8
    29 17 29 12 30 12 30 13 "C" 8 14 26 12 24 "C" 8 10 22 10 22 "C" 8 13 14
    13 14 "C" 8 17 22 17 22)
  );vector_line
  (vector_line (list "C" 250 8 26 9 26 10 27 11 27 12 28 13 28 14 29 15 29 16
    30 17 30 18 31 19 31 20 32 22 32 23 31 24 31 25 30 26 30 27 29 27 26 28
    25 28 22 29 21 29 18 30 17 30 14 31 13 31 10 "C" 250 26 11 26 5 23 2 "C"
    250 25 5 22 5)
  );vector_line
  (vector_line (list "C" 96 10 23 8 21 8 18 9 18 9 21 "C" 96 8 16 11 16 11 19
    9 17 10 17 "C" 96 12 15 14 15 14 14 15 14 15 16 16 15 16 16 17 17 16 17
    15 18 18 18 18 15 17 16 "C" 96 18 20 18 23 17 24 15 24 15 23 17 23 "C" 96
    14 25 12 23 14 21 14 24 13 23)
  );vector_line
  (vector_line (list "C" 5 13 6 20 6 "C" 5 13 8 23 8 "C" 5 13 10 23 10 "C" 5
    17 12 23 12)
  );vector_line
  (end_image)
);defun Delete:
;-------------------------------------------------------------------------------
; Exclam: - Exclamation icon
;-------------------------------------------------------------------------------
(defun Exclam: ()
  (start_image "exclam")
  (vector_line (list "C" 2 2 25 2 28 3 29 3 23 "C" 2  4 21 4 29 5 29 5 19 "C"
    2 6 17 6 29 7 29 7 15 "C" 2 8 13 8 29 9 29 9 11 "C" 2 10 9 10 29 11 29 11
    7 "C" 2 12 5 12 29 13 29 13 18 "C" 2 13 3 13 9 14 9 14 2 15 2 15 9 16 9
    16 3 17 4 17 9 "C" 2 14 21 14 22 16 22 16 21 17 22 17 18 "C" 2 14 27 14
    29 15 29 15 27 16 27 16 29 17 29 17 27 "C" 2 18 6 18 29 19 29 19 8 "C" 2
    20 10 20 29 21 29 21 12 "C" 2 22 14 22 29 23 29 23 16 "C" 2 24 18 24 29
    25 29 25 20 "C" 2 26 22 26 29 27 28 27 24 "C" 2 28 27 28 26)
  );vector_line
  (vector_line (list "C" 54 3 30 1 28 1 25 2 24 2 23 3 22 3 21 4 20 4 19 5 18
    5 17 6 16 6 15 7 14 7 13 8 12 8 11 9 10 9 9 10 8 10 7 11 6 11 5 12 4 12 3
    14 1 16 1 "C" 54 13 16 13 16 "C" 54 14 19 14 19 "C" 54 16 19 16 19 "C" 54
    17 16 17 16)
  );vector_line
  (vector_line (list "C" 9 13 10 13 10 "C" 9 17 10 17 10 "C" 9 13 17 13 17
    "C" 9 17 17 17 17 "C" 9 14 20 14 20 "C" 9 16 20 16 20 "C" 9 14 23 14 23
    "C" 9 17 23 17 23 "C" 9 14 26 14 26 "C" 9 17 26 17 26 "C" 9 16 2 17 3 "C"
    9 18 5 18 5 "C" 9 19 7 19 7 "C" 9 20 9 20 9 "C" 9 21 11 21 11 "C" 9 22 13
    22 13 "C" 9 23 15 23 15 "C" 9 24 17 24 17 "C" 9 25 19 25 19 "C" 9 26 21
    26 21 "C" 9 27 23 27 23 "C" 9 28 25 28 25 "C" 9 28 28 27 29)
  );vector_line
  (vector_line (list "C" 250 13 15 13 11 14 10 14 18 "C" 250 15 21 15 10 16
    10 16 18 "C" 250 17 11 17 15 "C" 250 14 25 14 24 15 23 15 26 16 26 16 23
    17 24 17 25 "C" 250 4 30 27 30 29 28 29 25 28 24 28 23 27 22 27 21 26 20
    26 19 25 18 25 17 24 16 24 15 23 14 23 13 22 12 22 11 21 10 21 9 20 8 20
    7 19 6 19 5 18 4 18 3 17 2)
  );vector_line
  (vector_line (list "C" 8 32 27 32 30 30 32 6 32 5 31 30 31 31 30 31 25 30
    25 30 30 28 30 29 29 "C" 8 19 3 19 4 20 4 20 6 21 5 21 8 22 7 22 10 23 9
    23 12 24 11 24 14 25 13 25 16 26 15 26 18 27 17 27 20 28 19 28 22 29 21
    29 24 30 23 30 24)
  );vector_line
  (end_image)
);defun Exclam:
;-------------------------------------------------------------------------------
; Filefolder: - Filefolder icon
;-------------------------------------------------------------------------------
(defun Filefolder: ()
  (start_image "filefolder")
  (vector_line (list "C" 8 3 28 3 26 2 25 2 22 1 21 1 18 0 17 0 13 1 12 2 12
    3 11 3 7 7 3 15 3 19 7 29 7 "C" 8 28 13 27 14 27 15 29 16 29 17 28 18 28
    19 29 22 29 23)
  );vector_line
  (vector_line (list "C" 255 4 11 4 7 7 4 15 4 19 8 29 8 "C" 255 1 13 26 13)
  );vector_line
  (vector_line (list "C" 54 4 28 30 28 30 9)
  );vector_line
  (vector_line (list "C" 250 27 13 28 14 28 17 29 18 29 21 30 22 30 25 "C"
    250 30 8 31 9 31 28 30 29 4 29)
  );vector_line
  (vector_line (list "C" 9 1 17 1 14 2 14 2 21 "C" 9 3 25 3 14 4 14 4 27 5 27
    5 14 6 14 6 27 7 27 7 14 8 14 8 27 9 27 9 14 10 14 10 27 11 27 11 14 12
    14 12 27 13 27 13 14 14 14 14 27 15 27 15 14 16 14 16 27 17 27 17 14 18
    14 18 27 19 27 19 14 20 14 20 27 21 27 21 14 22 14 22 27 23 27 23 14 24
    14 24 27 25 27 25 14 26 14 26 27 27 27 27 16 "C" 9 28 20 28 27 29 27 29
    24 "C" 9 3 12 5 12 5 7 6 6 6 12 7 12 7 5 8 5 8 12 9 12 9 5 10 5 10 12 11
    12 11 5 12 5 12 12 13 12 13 5 14 5 14 12 15 12 15 5 16 5 16 12 17 12 17 6
    18 7 18 12 "C" 9 19 9 19 12 20 12 20 9 21 9 21 12 22 12 22 9 23 9 23 12
    24 12 24 9 25 9 25 12 26 12 26 9 27 9 27 12 28 12 28 9 29 9 29 15)
  );vector_line
  (vector_line (list "C" 2 4 27 5 26 6 27 3 24 "C" 2 2 21 8 27 9 26 10 27 2
    19 "C" 2 1 16 12 27 13 26 14 27 1 14 "C" 2 3 14 16 27 17 26 18 27 5 14
    "C" 2 7 14 20 27 21 26 22 27 9 14 "C" 2 11 14 24 27 25 26 26 27 13 14 "C"
    2 15 14 28 27 29 26 17 14 "C" 2 19 14 28 23 27 22 28 21 21 14 "C" 2 23 14
    27 18 26 17 27 16 25 14 "C" 2 5 10 6 11 7 10 8 11 5 8 6 7 10 11 11 10 12
    11 7 6 8 5 14 11 15 10 16 11 10 5 11 6 12 5 18 11 19 10 20 11 14 5 15 6
    16 5 18 7 "C" 2 20 9 22 11 21 10 22 9 24 11 23 10 24 9 26 11 25 10 26 9
    29 12 27 10 28 9 29 10 "C" 2 29 14 29 14)
  );vector_line
  (vector_line (list "C" 8 5 11 16 0)
  );vector_line
  (vector_line (list "C" 255 6 11 7 11 7 10 8 9 8 11 9 11 9 8 10 7 10 11 11
    11 11 6 12 5 12 11 13 11 13 4 14 3 14 11 15 11 15 2 16 2 16 11 17 11 17 3
    18 4 18 11 19 11 19 5 20 6 20 11 21 11 21 7 22 8 22 11 23 11 23 9 24 10
    24 11 25 11)
  );vector_line
  (vector_line (list "C" 250 17 1 29 13)
  );vector_line
  (vector_line (list "C" 9 16 1 27 12)
  );vector_line
  (end_image)
);defun Filefolder:
;-------------------------------------------------------------------------------
; Folder: - Folder icon
;-------------------------------------------------------------------------------
(defun Folder: ()
  (start_image "folder")
  (vector_line (list "C" 8 3 28 3 26 2 25 2 22 1 21 1 18 0 17 0 13 1 12 2 12
    3 11 3 7 7 3 15 3 19 7 29 7 "C" 8 28 13 27 14 27 15 29 16 29 17 28 18 28
    19 29 22 29 23)
  );vector_line
  (vector_line (list "C" 255 4 11 4 7 7 4 15 4 19 8 29 8 "C" 255 1 13 26 13)
  );vector_line
  (vector_line (list "C" 54 4 28 30 28 30 9)
  );vector_line
  (vector_line (list "C" 250 27 13 28 14 28 17 29 18 29 21 30 22 30 25 "C"
    250 30 8 31 9 31 28 30 29 4 29)
  );vector_line
  (vector_line (list "C" 9 1 17 1 14 2 14 2 21 "C" 9 3 25 3 14 4 14 4 27 5 27
    5 14 6 14 6 27 7 27 7 14 8 14 8 27 9 27 9 14 10 14 10 27 11 27 11 14 12
    14 12 27 13 27 13 14 14 14 14 27 15 27 15 14 16 14 16 27 17 27 17 14 18
    14 18 27 19 27 19 14 20 14 20 27 21 27 21 14 22 14 22 27 23 27 23 14 24
    14 24 27 25 27 25 14 26 14 26 27 27 27 27 16 "C" 9 28 20 28 27 29 27 29
    24 "C" 9 3 12 5 12 5 7 6 6 6 12 7 12 7 5 8 5 8 12 9 12 9 5 10 5 10 12 11
    12 11 5 12 5 12 12 13 12 13 5 14 5 14 12 15 12 15 5 16 5 16 12 17 12 17 6
    18 7 18 12 "C" 9 19 9 19 12 20 12 20 9 21 9 21 12 22 12 22 9 23 9 23 12
    24 12 24 9 25 9 25 12 26 12 26 9 27 9 27 12 28 12 28 9 29 9 29 15)
  );vector_line
  (vector_line (list "C" 2 4 27 5 26 6 27 3 24 "C" 2 2 21 8 27 9 26 10 27 2
    19 "C" 2 1 16 12 27 13 26 14 27 1 14 "C" 2 3 14 16 27 17 26 18 27 5 14
    "C" 2 7 14 20 27 21 26 22 27 9 14 "C" 2 11 14 24 27 25 26 26 27 13 14 "C"
    2 15 14 28 27 29 26 17 14 "C" 2 19 14 28 23 27 22 28 21 21 14 "C" 2 23 14
    27 18 26 17 27 16 25 14 "C" 2 5 10 6 11 7 10 8 11 5 8 6 7 10 11 11 10 12
    11 7 6 8 5 14 11 15 10 16 11 10 5 11 6 12 5 18 11 19 10 20 11 14 5 15 6
    16 5 18 7 "C" 2 20 9 22 11 21 10 22 9 24 11 23 10 24 9 26 11 25 10 26 9
    29 12 27 10 28 9 29 10 "C" 2 29 14 29 14)
  );vector_line
  (end_image)
);defun Folder:
;-------------------------------------------------------------------------------
; Frown: - Frown icon
;-------------------------------------------------------------------------------
(defun Frown: ()
  (start_image "frown")
  (vector_line (list "C" 20 2 12 2 19 "C" 20 3 9 3 22 4 23 4 8 "C" 20 5 6 5
    25 6 26 6 5 7 5 7 26 8 27 8 4 9 3 9 28 10 28 10 3 11 3 11 28 12 29 12 2
    13 2 13 29 14 29 14 2 15 2 15 29 16 29 16 2 17 2 17 29 18 29 18 2 19 2 19
    29 20 28 20 3 21 3 21 28 22 28 22 3 23 4 23 27 24 26 24 5 25 5 25 26 26
    25 26 6 "C" 20 27 8 27 23 28 22 28 9 "C" 20 29 19 29 12)
  );vector_line
  (vector_line (list "C" 250 12 30 19 30 20 29 22 29 24 27 25 27 27 25 27 24
    29 22 29 20 30 19 30 12 29 11 29 9 27 7 27 6 25 4 24 4 22 2 20 2 19 1 12
    1 11 2 9 2 7 4 6 4 4 6 4 7 2 9 2 11 1 12 1 19 2 20 2 22 4 24 4 25 6 27 7
    27 9 29 11 29 "C" 250 11 11 12 10 12 12 13 11 "C" 250 18 11 19 10 19 12
    20 11 "C" 250 9 22 11 20 12 20 13 19 18 19 19 20 20 20 22 22)
  );vector_line
  (vector_line (list "C" 8 7 28 8 29 "C" 8 14 32 21 32 "C" 8 10 30 11 30 11
    31 24 31 25 30 20 30 "C" 8 27 29 23 29 24 28 28 28 29 27 26 27 27 26 29
    26 29 23 28 24 28 25 "C" 8 30 20 30 25 31 24 31 11 30 11 30 10 "C" 8 32
    21 32 14 "C" 8 28 7 29 8)
  );vector_line
  (end_image)
);defun Frown:
;-------------------------------------------------------------------------------
; Inform: - Information icon
;-------------------------------------------------------------------------------
(defun Inform: ()
  (start_image "inform")
  (vector_line (list "C" 9 19 2 22 3 24 4 28 8 29 10 29 16 28 18 24 22 22 23
    19 24 15 25 12 24 9 23 7 22 3 18 2 16 2 10 3 8 7 4 9 3 12 2)
  );vector_line
  (vector_line (list "C" 255 2 15 2 11 "C" 255 3 17 3 9 "C" 255 4 19 4 7 5 6
    5 20 6 21 6 5 7 5 7 21 8 22 8 4 9 4 9 22 10 23 10 3 11 3 11 23 12 23 12 3
    13 2 13 24 14 24 14 2 15 2 15 24 "C" 255 16 27 16 2 17 2 17 28 18 29 18 2
    19 3 19 23 20 23 20 3 21 3 21 23 22 22 22 4 23 4 23 22 24 21 24 5 25 5 25
    21 26 20 26 6 27 7 27 19 "C" 255 28 17 28 9 "C" 255 29 15 29 11)
  );vector_line
  (vector_line (list "C" 5 13 7 13 6 14 5 14 8 15 8 15 5 16 5 16 8 17 8 17 5
    18 6 18 7 "C" 5 12 11 14 11 14 19 15 19 15 11 16 11 16 19 17 19 17 11 18
    11 18 19 20 19 "C" 5 12 19 13 19)
  );vector_line
  (vector_line (list "C" 250 4 20 7 23 8 23 9 24 11 24 12 25 14 25 15 26 15
    27 18 30 19 30 19 25 20 24 22 24 23 23 24 23 29 18 29 17 30 16 30 10 29 9
    29 8 26 5)
  );vector_line
  (vector_line (list "C" 9 13 5 13 5 "C" 9 13 8 13 8 "C" 9 18 8 18 8 "C" 9 18
    5 18 5)
  );vector_line
  (vector_line (list "C" 8 3 19 2 18 2 17 1 16 1 10 2 9 2 8 7 3 8 3 9 2 11 2
    12 1 19 1 20 2 22 2 23 3 24 3 25 4 "C" 8 8 24 9 25 11 25 11 26 14 26 14
    27 "C" 8 19 31 20 32 20 25 21 25 21 32 "C" 8 22 26 22 25 23 24 23 26 24
    26 24 24 25 23 25 25 26 25 26 22 27 21 27 24 28 23 28 20 29 19 29 22 30
    21 30 17 "C" 8 31 20 31 10 30 9 "C" 8 32 18 32 12)
  );vector_line
  (end_image)
);defun Inform:
;-------------------------------------------------------------------------------
; Light: - Light icon
;-------------------------------------------------------------------------------
(defun Light: ()
  (start_image "light")
  (vector_line (list "C" 41 11 2 9 4 9 6 8 7 14 1 16 1 8 9 8 11 18 1 19 2 9
    12 9 14 21 2 22 3 10 15 11 16 23 4 23 6 12 17 13 18 24 7 24 9 14 19 14 21
    24 11 23 12 23 14 14 23 15 24 18 21 18 23 17 24)
  );vector_line
  (vector_line (list "C" 51 19 1 25 7 24 8 16 0 15 1 25 11 24 12 13 1 12 2 23
    13 22 14 11 3 9 5 20 16 19 17 8 6 7 7 19 19 18 20 7 9 7 11 19 23 18 24 13
    19 13 21 15 23 14 24)
  );vector_line
  (vector_line (list "C" 41 21 15 16 20 17 21 16 22 17 23 16 24))
  (vector_line (list "C" 43 13 24 13 19 8 14 8 13 7 12 7 6 8 5 8 4 11 1 12 1
    13 0 19 0 20 1 21 1 24 4 24 5 25 6 25 12 24 13 24 14 19 19 19 24)
  );vector_line
  (vector_line (list "C" 255 14 3 18 3 19 4 20 4 12 4 11 5 21 5 21 6 11 6 10
    7 22 7 22 8 10 8 10 9 22 9 22 10 10 10 10 11 22 11 21 12 11 12 11 13 21
    13 20 14 12 14 13 15 19 15 18 15 17 16 15 16 16 17 "C" 255 15 26 15 30)
  );vector_line
  (vector_line (list "C" 251 13 26 13 30))
  (vector_line (list "C" 9 14 26 14 31 16 31 16 26 18 26 18 30))
  (vector_line (list "C" 250 15 32 17 32 17 25 19 25 19 30))
  (vector_line (list "C" 8 13 25 19 25 "C" 8 13 27 19 27 "C" 8 13 29 19 29
    "C" 8 14 31 18 31)
  );vector_line
  (end_image)
);defun Light:
;-------------------------------------------------------------------------------
; Printer: - Printer icon
;-------------------------------------------------------------------------------
(defun Printer: ()
  (start_image "printer")
  (vector_line (list "C" 255 12 21 9 19 2 16 "C" 255 1 21 1 16 2 15 12 10 "C"
    255 13 12 14 13 14 10 15 13 15 8 16 7 16 14 17 14 17 6 18 5 18 15 19 14
    19 4 20 4 20 12 21 4 21 10 22 9 22 5 23 5 23 8 25 6 24 6)
  );vector_line
  (vector_line (list "C" 9 2 25 2 17 3 17 3 25 4 26 4 18 5 18 5 26 6 27 6 19
    7 19 7 27 8 28 8 20 9 20 9 28 10 29 10 21 11 21 11 29 12 30 12 22 "C" 9 3
    15 12 11 "C" 9 25 7 21 11 21 12 20 13 24 13 25 14 26 14 21 14 19 15 24 15
    13 20 12 19 10 19 9 18 8 18 14 18 16 17 6 17 5 16 17 16 15 15 7 15 11 14
    13 14 "C" 9 29 18 29 17)
  );vector_line
  (vector_line (list "C" 8 27 6 20 3 19 3 14 8 14 9 13 10 13 9 0 15 0 22 1 22
    1 24 2 23 11 27 11 20 26 13 25 13 24 12 22 12 22 13 "C" 8 3 23 3 16 12 12
    13 11 "C" 8 11 13 10 14 9 14 9 15 14 17 "C" 8 12 28 13 29 13 30 13 21 14
    21 14 30 15 29 15 20 16 20 16 29 17 28 17 19 18 19 18 28 19 27 19 18 20
    18 20 27 21 26 21 17 22 17 22 26 23 25 23 16 24 16 24 25 25 24 25 15 26
    15 26 24 26 21 27 20 27 14 "C" 8 29 19 31 17 30 17 29 16)
  );vector_line
  (vector_line (list "C" 250 27 7 26 7 21 12 20 15 "C" 250 18 16 17 15 12 13
    "C" 250 1 25 2 26 13 31 26 25 27 24 27 21 28 20 28 14 "C" 250 13 28 28 21
    31 18)
  );vector_line
  (vector_line (list "C" 3 7 16 8 16 "C" 1 9 17 10 17)
  );vector_line
  (end_image)
);defun Printer:
;-------------------------------------------------------------------------------
; Quest: - Question mark icon
;-------------------------------------------------------------------------------
(defun Quest: ()
  (start_image "quest")
  (vector_line (list "C" 9 19 2 22 3 24 4 28 8 29 10 29 16 28 18 24 22 22 23
    19 24 15 25 12 24 9 23 7 22 3 18 2 16 2 10 3 8 7 4 9 3 12 2)
  );vector_line
  (vector_line (list "C" 255 2 15 2 11 "C" 255 3 17 3 9 "C" 255 4 19 4 7 5 6
    5 20 6 21 6 5 7 5 7 21 8 22 8 4 9 4 9 22 10 23 10 3 11 3 11 23 12 23 12 3
    13 2 13 24 14 24 14 2 15 2 15 24 "C" 255 16 27 16 2 17 2 17 28 18 29 18 2
    19 3 19 23 20 23 20 3 21 3 21 23 22 22 22 4 23 4 23 22 24 21 24 5 25 5 25
    21 26 20 26 6 27 7 27 19 "C" 255 28 17 28 9 "C" 255 29 15 29 11)
  );vector_line
  (vector_line (list "C" 5 14 19 14 18 15 17 15 20 16 20 16 17 17 18 17 19
    "C" 5 16 14 16 15 15 15 15 13 17 13 18 12 16 12 16 11 19 11 20 10 17 10
    17 9 20 9 20 8 17 8 16 7 19 7 18 6 13 6 "C" 5 11 10 11 8 12 7 12 11 13 11
    13 9 14 9 14 10)
  );vector_line
  (vector_line (list "C" 250 4 20 7 23 8 23 9 24 11 24 12 25 14 25 15 26 15
    27 18 30 19 30 19 25 20 24 22 24 23 23 24 23 29 18 29 17 30 16 30 10 29 9
    29 8 26 5)
  );vector_line
  (vector_line (list "C" 9 11 7 12 6 13 7 "C" 9 19 6 20 7 "C" 9 11 11 11 11
    "C" 9 14 11 15 12 "C" 9 16 10 16 10 "C" 9 17 14 17 14 "C" 9 14 17 14 17
    "C" 9 17 17 17 17 "C" 9 14 20 14 20 "C" 9 17 20 17 20)
  );vector_line
  (vector_line (list "C" 8 3 19 2 18 2 17 1 16 1 10 2 9 2 8 7 3 8 3 9 2 11 2
    12 1 19 1 20 2 22 2 23 3 24 3 25 4 "C" 8 8 24 9 25 11 25 11 26 14 26 14
    27 "C" 8 19 31 20 32 20 25 21 25 21 32 "C" 8 22 26 22 25 23 24 23 26 24
    26 24 24 25 23 25 25 26 25 26 22 27 21 27 24 28 23 28 20 29 19 29 22 30
    21 30 17 "C" 8 31 20 31 10 30 9 "C" 8 32 18 32 12)
  );vector_line
  (end_image)
);defun Quest:
;-------------------------------------------------------------------------------
; Replace: - Replace icon
;-------------------------------------------------------------------------------
(defun Replace: ()
  (start_image "replace")
  (vector_line (list "C" 255 3 29 3 11 4 11 4 29 5 29 5 11 6 11 6 29 7 29 7
    11 8 11 8 29 9 29 9 11 10 11 10 29 11 29 11 11 12 11 12 29 13 29 13 11
    "C" 255 14 15 14 29 15 29 15 3 16 3 16 29 17 29 17 3 18 3 18 12 19 14 19
    3 20 3 20 21 21 21 21 3 22 3 22 21 23 21 23 3 24 3 24 21 25 21 25 3 "C"
    255 27 5 26 7 26 21 27 21 27 10 28 9 28 21 29 21 29 8)
  );vector_line
  (vector_line (list "C" 8 29 5 26 2 14 2 14 13 "C" 8 17 13 14 10 2 10 2 29
    "C" 8 26 3 26 5 "C" 8 27 7 29 7 "C" 8 15 15 17 15 "C" 8 3 31 19 31 19 15
    "C" 8 20 23 31 23 31 7)
  );vector_line
  (vector_line (list "C" 9 27 4 28 5 "C" 9 15 12 16 13))
  (vector_line (list "C" 250 2 30 18 30 18 14 14 14 "C" 250 20 22 30 22 30 6
    26 6)
  );vector_line
  (vector_line (list "C" 5 5 27 15 27 "C" 5 5 25 15 25 "C" 5 5 23 15 23 "C" 5
    5 21 15 21 "C" 5 5 19 15 19 "C" 5 5 17 15 17 "C" 5 5 15 12 15 "C" 5 20 19
    27 19 "C" 5 20 17 27 17 "C" 5 22 15 27 15 "C" 5 18 13 27 13 "C" 5 17 11
    27 11 "C" 5 20 9 25 9 "C" 5 17 7 24 7)
  );vector_line
  (vector_line (list "C" 1 26 10 28 8 27 8 20 15 20 16 24 12 "C" 1 20 14 21
    13 16 8 16 9 17 8 17 10 "C" 1 26 16 19 9 18 9 27 18 "C" 1 28 20 28 20 "C"
    1 21 31 23 31 25 29 25 25 27 27 23 27 24 26 "C" 1 6 8 6 6 8 4 12 4 10 2
    10 6 11 5)
  );vector_line
  (end_image)
);defun Replace:
;-------------------------------------------------------------------------------
; Smile: - Smile icon
;-------------------------------------------------------------------------------
(defun Smile: ()
  (start_image "smile")
  (vector_line (list "C" 2 2 12 2 19 "C" 2 3 9 3 22 4 23 4 8 "C" 2 5 6 5 25 6
    26 6 5 7 5 7 26 8 27 8 4 9 3 9 28 10 28 10 3 11 3 11 28 12 29 12 2 13 2
    13 29 14 29 14 2 15 2 15 29 16 29 16 2 17 2 17 29 18 29 18 2 19 2 19 29
    20 28 20 3 21 3 21 28 22 28 22 3 23 4 23 27 24 26 24 5 25 5 25 26 26 25
    26 6 "C" 2 27 8 27 23 28 22 28 9 "C" 2 29 19 29 12)
  );vector_line
  (vector_line (list "C" 250 12 30 19 30 20 29 22 29 24 27 25 27 27 25 27 24
    29 22 29 20 30 19 30 12 29 11 29 9 27 7 27 6 25 4 24 4 22 2 20 2 19 1 12
    1 11 2 9 2 7 4 6 4 4 6 4 7 2 9 2 11 1 12 1 19 2 20 2 22 4 24 4 25 6 27 7
    27 9 29 11 29 "C" 250 6 18 8 20 9 20 10 21 12 21 13 22 18 22 19 21 21 21
    22 20 23 20 25 18 "C" 250 11 12 11 10 12 9 12 13 13 12 13 10 "C" 250 18
    12 18 10 19 9 19 13 20 12 20 10)
  );vector_line
  (vector_line (list "C" 8 7 28 8 29 "C" 8 14 32 21 32 "C" 8 10 30 11 30 11
    31 24 31 25 30 20 30 "C" 8 27 29 23 29 24 28 28 28 29 27 26 27 27 26 29
    26 29 23 28 24 28 25 "C" 8 30 20 30 25 31 24 31 11 30 11 30 10 "C" 8 32
    21 32 14 "C" 8 28 7 29 8)
  );vector_line
  (end_image)
);defun Smile:
;-------------------------------------------------------------------------------
; GetPT [Get integer Points] - Utility for vector_line.
; Returns: Positive X and Y integer points to cut and paste into a list for
; vector_line or as X and Y integer points for vector_image.
; Note: This function is used to create vector images. The origin point 0,0 in
; an image tile is in the upper left corner. The height and width in the DCL
; file determine the values of the dimx_tile and dimy_tile in the AutoLISP file.
; The values of the dimx_tile and dimy_tile are one greater than the drawing
; limits of the image tile pixels. To create a 100 x 100 pixel image, draw a
; rectangle from 0,0 to 99,-99. Copy and scale the entities you want to include
; in your image into the limits of the outlined rectangle.
; Based upon a 100 dimx_tile x 100 dimy_tile image tile you may calculate:
;   DCL width  = (+ (* (1- 100)(/ 1 6.0)) 0.09) = 16.59
;   DCL height = (+ (* (1- 100)(/ 1 13.0)) 0.048) =  7.66
; As a guide while picking points, set the snap to 1.
; Below is the dialog width and height values for the following:
;   For a 10 x 10 pixel image:   width = 1.59, height = 0.74
;   For a 25 x 25 pixel image:   width = 4.09, height = 1.89
;   For a 32 x 32 pixel image:   width = 5.26, height = 2.43
;   For a 50 x 50 pixel image:   width = 8.26, height = 3.82
;   For a 100 x 100 pixel image: width = 16.59, height = 7.66
;   For a 200 x 200 pixel image: width = 33.26. height = 15.36
;   For a 400 x 400 pixel image: width = 66.59, height = 30.74
;   For a 500 x 500 pixel image: width = 83.26, height = 38.43
; These values are based an a 1024 x 768 screen area and may vary according
; to individual screen resolutions.
;-------------------------------------------------------------------------------
(defun c:GetPT (/ Pt@)
  (princ "\nPick points for vector image then press Enter to end.")
  (princ "\n")
  (while (setq Pt@ (getpoint))
    (if Pt@
      (progn
        (princ (rtos (abs (nth 0 pt@)) 2 0))(princ " ")
        (princ (rtos (abs (nth 1 Pt@)) 2 0))(princ " ")
      );progn
    );if
  );while
  (princ)
);defun c:GetPT
;-------------------------------------------------------------------------------
; vector_circle - Draws vector circles, arcs and ellipses in an image tile.
; Arguments: 9
;   XC~ = X center point
;   YC~ =  Y center point
;   Radius~ = Radius of arc or circle
;   Ratio~ = Minor diameter ratio percent for ellipse <= 1
;   Ang0~ = Rotation radian angle reference for ellipse < pi
;   Ang1~ = Starting radian angle of arc
;   Ang2~ = Ending radian angle of arc
;   Inc~ = Increment between radian angle segements
;   Color# = Color number of segements
; Returns: Draws vector circles, arcs and ellipse in an image tile.
; Note: If Inc~ is 0 the function defaults the Inc~ value to
; (/ (* pi 2) (* (fix (+ (* (* Radius~ 0.1) 8) 0.5)) 8))
; to achieve the smoothest arcs with minimal points duplicated.
; Examples:    Run c:Vector_Circle to view the following examples.
;  Example 1 - Draws a red circle with a radius of 95.
;  (vector_circle 100 100 95 1 0 0 0 0 1)
;  Example 2 - Draws a yellow ellipse rotated 45 degrees.
;  (vector_circle 100 100 95 0.5 (dtr 45) 0 0 (/ pi (* 95 pi)) 2)
;  Example 3 - Draws a green elliptical arc.
;  (vector_circle 100 100 95 0.75 (dtr 135) (dtr 90) (dtr 270) 0 3)
;  Example 4 - Draws a cyan square.
;  (vector_circle 100 100 95 1 (dtr 45) 0 0 (/ (* pi 2.0) 4.0) 4)
;  Example 5 - Draws a blue pentagon.
;  (vector_circle 100 100 95 1 (dtr 270) 0 0 (/ (* pi 2.0) 5.0) 5)
;  Example 6 - Draws a magenta hexigon.
;  (vector_circle 100 100 95 1 (dtr 90) 0 0 (/ (* pi 2.0) 6.0) 6)
; Note: The origin point 0,0 in an image tile is in the upper left corner.
; Measure radian angles clockwise from 0-East. Starting and ending angles for
; elliptical acrs vary from circular arcs due to the elliptical ratio.
;-------------------------------------------------------------------------------
(defun vector_circle (XC~ YC~ Radius~ Ratio~ Ang0~ Ang1~ Ang2~ Inc~ Color# /
  Join X0~ Y0~ X1~ Y1~ X2~ Y2~ X3~ Y3~ XYC@ XY0@ XY1@ XY2@ XY3@)
  (setq XYC@ (list XC~ YC~)
        X1~ (+ XC~ (* Radius~ (cos Ang1~)))
        Y1~ (+ YC~ (* Radius~ (sin Ang1~) Ratio~))
        XY1@ (list X1~ Y1~)
        XY1@ (polar XYC@ (+ Ang0~ (angle XYC@ XY1@)) (distance XYC@ XY1@))
        X1~ (car XY1@)
        Y1~ (cadr XY1@)
        X3~ (+ XC~ (* Radius~ (cos Ang2~)))
        Y3~ (+ YC~ (* Radius~ (sin Ang2~) Ratio~))
        XY3@ (list X3~ Y3~)
        XY3@ (polar XYC@ (+ Ang0~ (angle XYC@ XY3@)) (distance XYC@ XY3@))
        X3~ (car XY3@)
        Y3~ (cadr XY3@)
        XY3@ (list X3~ Y3~)
  );setq
  (if (= Ang1~ Ang2~)
    (setq Ang2~ (+ Ang1~ (* pi 2))
          Join t
    );setq
  );if
  (if (< Ang2~ Ang1~)
    (setq Ang2~ (+ Ang2~ (* pi 2)))
  );if
  (if Join
    (setq X0~ X1~
          Y0~ Y1~
          XY0@ (list X0~ Y0~)
    );setq
  );if
  (if (= Inc~ 0)
    (setq Inc~ (/ (* pi 2) (* (fix (+ (* (* Radius~ 0.1) 8) 0.5)) 8)))
  );if
  (setq IncPi~ (+ Ang1~ Inc~))
  (while (< IncPi~ Ang2~)
    (setq X2~ (+ XC~ (* Radius~ (cos IncPi~)))
          Y2~ (+ YC~ (* Radius~ (sin IncPi~) Ratio~))
          XY2@ (list X2~ Y2~)
          XY2@ (polar XYC@ (+ Ang0~ (angle XYC@ XY2@)) (distance XYC@ XY2@))
          X2~ (car XY2@)
          Y2~ (cadr XY2@)
    );setq
    (vector_image (fix (+ X1~ 0.5))(fix (+ Y1~ 0.5))
      (fix (+ X2~ 0.5))(fix (+ Y2~ 0.5)) Color#
    );vector_image
    (setq X1~ X2~
          Y1~ Y2~
          IncPi~ (+ IncPi~ Inc~)
    );setq
  );while
  (vector_image (fix (+ X1~ 0.5))(fix (+ Y1~ 0.5))
    (fix (+ X3~ 0.5))(fix (+ Y3~ 0.5)) Color#
  );vector_image
  (if (and Join (not (equal XY0@ XY3@)))
    (vector_image (fix (+ X1~ 0.5))(fix (+ Y1~ 0.5))
      (fix (+ X0~ 0.5))(fix (+ Y0~ 0.5)) Color#
    );vector_image
  );if
);defun vector_circle
;-------------------------------------------------------------------------------
; vector_line - Draws vector lines in an image tile.
; Arguments: 1
;   LineList@ = List of Color#'s and X# and Y# points
; Returns: Draws vector lines from a list and in Color#'s specified.
; Example:
;  (vector_line (list "C" 1 100 78 125 121 75 121 100 78
;    "C" 3 50 50 150 50 150 150 50 150 50 50))
;  Draws a red triangle inside of a green box.
; Note: The origin point 0,0 in an image tile is in the upper left corner.
;-------------------------------------------------------------------------------
(defun vector_line (LineList@ / Rep# X# Y# X1# Y1# X2# Y2# Color#)
  (if (= (type LineList@) 'LIST)
    (progn
      (setq Rep# 0)
      (repeat (/ (length LineList@) 2)
        (setq X# (nth Rep# LineList@)
              Y# (nth (+ Rep# 1) LineList@)
        );setq
        (if (and (= (type X#) 'STR) (= (type Y#) 'INT))
          (if (= (strcase X#) "C")
            (setq Color# Y#
                  X1# nil
                  Y1# nil
                  X2# nil
                  Y2# nil
            );setq
          );if
          (if (and (= (type X#) 'INT) (= (type Y#) 'INT))
            (if (and (= X1# nil) (= Y1# nil))
              (setq X1# X#
                    Y1# Y#
              );setq
              (progn
                (setq X2# X#
                      Y2# Y#
                );setq
                (vector_image X1# Y1# X2# Y2# Color#)
                (setq X1# X2#
                      Y1# Y2#
                      X# nil
                      Y# nil
                );setq
              );progn
            );if
          );if
        );if
        (setq Rep# (+ Rep# 2))
      );repeat
    );progn
  );if
);defun vector_line
;-------------------------------------------------------------------------------
; c:Vector_Circle - Vector_Circle Dialog Examples
;-------------------------------------------------------------------------------
(defun c:Vector_Circle (/ Back: Dcl_Id% Example# Example1: Example2: Example3:
  Example4: Example5: Example6: Example7: Next:
  );variables
  (if (not (findfile "C:\\Temp\\Temp.dcl"))
    (progn (vl-load-com)(vl-mkdir "C:\\Temp"))
  );if
  ;-----------------------------------------------------------------------------
  ; c:Vector_Circle subfunctions = CreateDcl:, Example1:, Example2:, Example3:,
  ; Example4:, Example5:, Example6:, Example7:, Back:, Next:,
  ;-----------------------------------------------------------------------------
  ; CreateDcl:
  ;-----------------------------------------------------------------------------
  (defun CreateDcl: (/ Q$ FileName%)
    (setq Q$ (chr 34))
    (setq FileName% (open "C:\\Temp\\Temp.dcl" "w"))
    (write-line "dcl_settings : default_dcl_settings { audit_level = 3; }"
      FileName%)
    (write-line "Temp : dialog {" FileName%)
    (write-line (strcat "  key = "Q$"title"Q$";") FileName%)
    (write-line (strcat "  label = "Q$ Q$";") FileName%)
    (write-line (strcat "  initial_focus = "Q$"Next"Q$";") FileName%)
    (write-line "  spacer;" FileName%)
    (write-line "  : image {" FileName%)
    (write-line (strcat "    key = "Q$"image"Q$";") FileName%)
    (write-line "    width = 33.25; // for a 200 image width" FileName%)
    (write-line "    height = 15.35; // for a 200 image height" FileName%)
    (write-line "    fixed_width = true;" FileName%)
    (write-line "    fixed_height = true;" FileName%)
    (write-line "    aspect_ratio = 1;" FileName%)
    (write-line "    color = 256;" FileName%)
    (write-line "    alignment = centered;" FileName%)
    (write-line "  }" FileName%)
    (write-line "  spacer;" FileName%)
    (write-line "  : row {" FileName%)
    (write-line "    fixed_width = true;" FileName%)
    (write-line "    alignment = centered;" FileName%)
    (write-line "    : button {" FileName%)
    (write-line (strcat "      key = "Q$"Back"Q$";") FileName%)
    (write-line (strcat "      label = "Q$"< &Back"Q$";") FileName%)
    (write-line "    }" FileName%)
    (write-line "    : button {" FileName%)
    (write-line (strcat "      key = "Q$"Next"Q$";") FileName%)
    (write-line "      is_default = true;" FileName%)
    (write-line (strcat "      label = "Q$"&Next >"Q$";") FileName%)
    (write-line "    }" FileName%)
    (write-line "  }" FileName%)
    (write-line "}" FileName%)
    (close FileName%)
  );defun CreateDcl:
  ;-----------------------------------------------------------------------------
  ; Example1: - Draws a red circle with a radius of 95.
  ;-----------------------------------------------------------------------------
  (defun Example1: ()
    (start_image "image")
    (fill_image 0 0 (dimx_tile "image")(dimy_tile "image") 256)
    (vector_circle 100 100 95 1 0 0 0 0 1)
    (end_image)
  );defun Example1:
  ;-----------------------------------------------------------------------------
  ; Example2: - Draws a yellow ellipse rotated 45 degrees.
  ;-----------------------------------------------------------------------------
  (defun Example2: ()
    (start_image "image")
    (fill_image 0 0 (dimx_tile "image")(dimy_tile "image") 256)
    (vector_circle 100 100 95 0.5 (dtr 45) 0 0 (/ pi (* 95 pi)) 2)
    (end_image)
  );defun Example2:
  ;-----------------------------------------------------------------------------
  ; Example3: - Draws a green elliptical arc.
  ;-----------------------------------------------------------------------------
  (defun Example3: ()
    (start_image "image")
    (fill_image 0 0 (dimx_tile "image")(dimy_tile "image") 256)
    (vector_circle 100 100 95 0.75 (dtr 135) (dtr 90) (dtr 270) 0 3)
    (end_image)
  );defun Example3:
  ;-----------------------------------------------------------------------------
  ; Example4: - Draws a cyan square.
  ;-----------------------------------------------------------------------------
  (defun Example4: ()
    (start_image "image")
    (fill_image 0 0 (dimx_tile "image")(dimy_tile "image") 256)
    (vector_circle 100 100 95 1 (dtr 45) 0 0 (/ (* pi 2.0) 4.0) 4)
    (end_image)
  );defun Example4:
  ;-----------------------------------------------------------------------------
  ; Example5: - Draws a blue pentagon.
  ;-----------------------------------------------------------------------------
  (defun Example5: ()
    (start_image "image")
    (fill_image 0 0 (dimx_tile "image")(dimy_tile "image") 256)
    (vector_circle 100 100 95 1 (dtr 270) 0 0 (/ (* pi 2.0) 5.0) 5)
    (end_image)
  );defun Example5:
  ;-----------------------------------------------------------------------------
  ; Example6: - Draws a magenta hexigon.
  ;-----------------------------------------------------------------------------
  (defun Example6: ()
    (start_image "image")
    (fill_image 0 0 (dimx_tile "image")(dimy_tile "image") 256)
    (vector_circle 100 100 95 1 (dtr 90) 0 0 (/ (* pi 2.0) 6.0) 6)
    (end_image)
  );defun Example6:
  ;-----------------------------------------------------------------------------
  ; Example7: - Draws a multi-color spiral array.
  ;-----------------------------------------------------------------------------
  (defun Example7: (/ ColorArray@ Cnt# Deg#)
    (start_image "image")
    (fill_image 0 0 (dimx_tile "image")(dimy_tile "image") 256)
    (setq ColorArray@ (list 1 30 2 3 160 6)
          Cnt# 0
          Deg# 0
    );setq
    (repeat 12
      (vector_circle 100 100 95 0.375 (dtr Deg#) 0 0 (/ pi (/ 95 2.0))
        (nth Cnt# ColorArray@)
      );vector_circle
      (setq Cnt# (1+ Cnt#)
            Deg# (+ Deg# 15)
      );setq
      (if (= Cnt# 6) (setq Cnt# 0))
    );repeat
    (end_image)
  );defun Example7:
  ;-----------------------------------------------------------------------------
  ; Back:
  ;-----------------------------------------------------------------------------
  (defun Back: ()
    (setq Example# (1- Example#))
    (if (= Example# 1)
      (progn
        (set_tile "title"
          (strcat " Vector_Circle Example " (itoa Example#) " of 7")
        );set_tile
        (eval (read (strcat "(Example" (itoa Example#) ":)")))
        (mode_tile "Back" 1)
      );progn
      (progn
        (set_tile "title"
          (strcat " Vector_Circle Example " (itoa Example#) " of 7")
        );set_tile
        (eval (read (strcat "(Example" (itoa Example#) ":)")))
      );progn
    );if
  );defun Back:
  ;-----------------------------------------------------------------------------
  ; Next:
  ;-----------------------------------------------------------------------------
  (defun Next: ()
    (setq Example# (1+ Example#))
    (if (= Example# 8)
      (done_dialog)
      (progn
        (set_tile "title"
          (strcat " Vector_Circle Example " (itoa Example#) " of 7")
        );set_tile
        (eval (read (strcat "(Example" (itoa Example#) ":)")))
        (mode_tile "Back" 0)
      );progn
    );if
  );defun Next:
  ;-----------------------------------------------------------------------------
  ; c:Vector_Circle - Start Main Function
  ;-----------------------------------------------------------------------------
  (princ "\nVector_Circle Examples")
  (CreateDcl:)
  (setq Dcl_Id% (load_dialog "C:\\Temp\\Temp.dcl"))
  (new_dialog "Temp" Dcl_Id%)
  (setq Example# 1)
  (set_tile "title"
    (strcat " Vector_Circle Example " (itoa Example#) " of 7")
  );set_tile
  (mode_tile "Back" 1)
  (Example1:)
  (action_tile "Back" "(Back:)")
  (action_tile "Next" "(Next:)")
  (start_dialog)
  (unload_dialog Dcl_Id%)
  (princ)
);defun c:Vector_Circle
;-------------------------------------------------------------------------------
; CancelYesNo - Dialog cancel function
;-------------------------------------------------------------------------------
(defun CancelYesNo ()
  (if (= (GetYesNo "" "Are you sure you want to Cancel?" "Quest") "Yes")
    (exit)
  );if
  (princ)
);defun CancelYesNo
;-------------------------------------------------------------------------------
; dtr - Degrees to Radians.
; Arguments: 1
;   Deg~ = Degrees
; Syntax: (dtr Deg~)
; Returns: Value in radians.
;-------------------------------------------------------------------------------
(defun dtr (Deg~)
  (* pi (/ Deg~ 180.0))
);defun dtr
;-------------------------------------------------------------------------------
; EditBox - Dialog with edit_box for entering string values
; Arguments: 4
;   Title$ = Title of dialog
;   Prompt$ = Prompt of dialog
;   Value$ = Text value to edit
;   EditWidth~ = Number of characters in edit_box tile
; Returns: NewValue$ from Value$ or nil if Cancel selected
;-------------------------------------------------------------------------------
(defun EditBox (Title$ Prompt$ Value$ EditWidth~ / Dcl_Id% EditWidth$ FileName%
  NewValue$ PromptWidth$ Q$)
  (if (= Title$ "")(setq Title$ "Edit Value"))
  (setq Title$ (strcat " " Title$))
  (if (= Prompt$ "")(setq Prompt$ "Value:"))
  (setq PromptWidth$ (rtos (+ (GetDclWidth Prompt$) 1.34) 2 2))
  (setq EditWidth$ (rtos (- EditWidth~ 1) 2 2))
  (if (not (findfile "C:\\Temp\\Temp.dcl"))
    (progn (vl-load-com)(vl-mkdir "C:\\Temp"))
  );if
  (setq Q$ (chr 34))
  (setq FileName% (open "C:\\Temp\\Temp.dcl" "w"))
  (write-line "dcl_settings : default_dcl_settings { audit_level = 3; }"
    FileName%)
  (write-line "Temp : dialog {" FileName%)
  (write-line (strcat "  key = "Q$"title"Q$";") FileName%)
  (write-line (strcat "  initial_focus = "Q$"Text"Q$";") FileName%)
  (write-line (strcat "  label = "Q$ Q$";") FileName%)
  (write-line (strcat "  key = "Q$"Title"Q$";") FileName%)
  (write-line "  spacer;" FileName%)
  (write-line "  : row {" FileName%)
  (write-line "    : column {" FileName%)
  (write-line (strcat "      width = " PromptWidth$ ";") FileName%)
  (write-line "      fixed_width = true;" FileName%)
  (write-line "      spacer;" FileName%)
  (write-line "      : column {" FileName%)
  (write-line "        : text {" FileName%)
  (write-line (strcat "          key = "Q$"Prompt"Q$";") FileName%)
  (write-line (strcat "          label = "Q$ Q$";") FileName%)
  (write-line "          alignment = left;" FileName%)
  (write-line "        }" FileName%)
  (write-line "      }" FileName%)
  (write-line "    }" FileName%)
  (write-line "    : edit_box {" FileName%)
  (write-line (strcat "      key = "Q$"Text"Q$";") FileName%)
  (write-line (strcat "      edit_width = " EditWidth$ ";") FileName%)
  (write-line "      fixed_width = true;" FileName%)
  (write-line "    }" FileName%)
  (write-line "  }" FileName%)
  (write-line "  : spacer { height = 0.12; }" FileName%)
  (write-line "  : row {" FileName%)
  (write-line "    : column {" FileName%)
  (write-line "      : ok_button {" FileName%)
  (write-line "        alignment = right;" FileName%)
  (write-line "        width = 11;" FileName%)
  (write-line "      }" FileName%)
  (write-line "    }" FileName%)
  (write-line "    : column {" FileName%)
  (write-line "      : cancel_button {" FileName%)
  (write-line "        alignment = left;" FileName%)
  (write-line "        width = 11;" FileName%)
  (write-line "      }" FileName%)
  (write-line "    }" FileName%)
  (write-line "  }" FileName%)
  (write-line "}" FileName%)
  (close FileName%)
  (setq Dcl_Id% (load_dialog "C:\\Temp\\Temp.dcl"))
  (new_dialog "Temp" Dcl_Id%)
  (set_tile "Title" Title$)
  (set_tile "Prompt" Prompt$)
  (set_tile "Text" Value$)
  (action_tile "Text" "(setq NewValue$ $value)")
  (setq Return# (start_dialog))
  (unload_dialog Dcl_Id%)
  (if (= Return# 0)
    (setq NewValue$ "")
  );if
  NewValue$
);defun EditBox
;-------------------------------------------------------------------------------
; EditEnter - Dialog with edit_box using the enter key as the accept key
; Arguments: 4
;   Title$ = Title of dialog
;   Prompt$ = Prompt of dialog
;   Value$ = Text value to edit
;   EditWidth~ = Number of characters in edit_box tile
; Returns: NewValue$ from Value$ argument
;-------------------------------------------------------------------------------
(defun EditEnter (Title$ Prompt$ Value$ EditWidth~ / Dcl_Id% EditWidth$ FileName%
  NewValue$ PromptWidth$ Q$)
  (setq NewValue$ Value$)
  (if (= Title$ "")(setq Title$ "Edit Value"))
  (setq Title$ (strcat " " Title$))
  (if (= Prompt$ "")(setq Prompt$ "Value:"))
  (setq PromptWidth$ (rtos (+ (GetDclWidth Prompt$) 1.34) 2 2))
  (setq EditWidth$ (rtos (- EditWidth~ 1) 2 2))
  (if (not (findfile "C:\\Temp\\Temp.dcl"))
    (progn (vl-load-com)(vl-mkdir "C:\\Temp"))
  );if
  (setq Q$ (chr 34))
  (setq FileName% (open "C:\\Temp\\Temp.dcl" "w"))
  (write-line "dcl_settings : default_dcl_settings { audit_level = 3; }"
    FileName%)
  (write-line "Temp : dialog {" FileName%)
  (write-line (strcat "  key = "Q$"title"Q$";") FileName%)
  (write-line (strcat "  initial_focus = "Q$"Text"Q$";") FileName%)
  (write-line (strcat "  label = "Q$ Q$";") FileName%)
  (write-line (strcat "  key = "Q$"Title"Q$";") FileName%)
  (write-line "  spacer;" FileName%)
  (write-line "  : row {" FileName%)
  (write-line "    : column {" FileName%)
  (write-line (strcat "      width = " PromptWidth$ ";") FileName%)
  (write-line "      fixed_width = true;" FileName%)
  (write-line "      spacer;" FileName%)
  (write-line "      : column {" FileName%)
  (write-line "        : text {" FileName%)
  (write-line (strcat "          key = "Q$"Prompt"Q$";") FileName%)
  (write-line (strcat "          label = "Q$ Q$";") FileName%)
  (write-line "          alignment = left;" FileName%)
  (write-line "        }" FileName%)
  (write-line "      }" FileName%)
  (write-line "    }" FileName%)
  (write-line "    : edit_box {" FileName%)
  (write-line (strcat "      key = "Q$"Text"Q$";") FileName%)
  (write-line (strcat "      edit_width = " EditWidth$ ";") FileName%)
  (write-line "      fixed_width = true;" FileName%)
  (write-line "    }" FileName%)
  (write-line "  }" FileName%)
  (write-line "  : spacer { height = 0.12; }" FileName%)
  (write-line "  : ok_button {" FileName%)
  (write-line "    is_cancel = true;" FileName%)
  (write-line "  }" FileName%)
  (write-line "}" FileName%)
  (close FileName%)
  (setq Dcl_Id% (load_dialog "C:\\Temp\\Temp.dcl"))
  (new_dialog "Temp" Dcl_Id%)
  (set_tile "Title" Title$)
  (set_tile "Prompt" Prompt$)
  (set_tile "Text" Value$)
  (action_tile "Text" "(setq NewValue$ (get_tile \"Text\")) (done_dialog)")
  (start_dialog)
  (unload_dialog Dcl_Id%)
  NewValue$
);defun EditEnter
;-------------------------------------------------------------------------------
; PopupList - Dialog with popup_list box for selecting items in a list
; Arguments: 4
;   Title$ = Title of dialog
;   Prompt$ = Prompt of dialog
;   DefaultItem$ = Default item from list
;   ListItems@ = List of items for selection
; Returns: NewValue$ from ListItems@ or nil if Cancel selected
;-------------------------------------------------------------------------------
(defun PopupList (Title$ Prompt$ DefaultItem$ ListItems@ / Dcl_Id% FileName%
  Item$ ItemWidth~ NewValue$ PopupWidth~ PopupWidth$ PromptWidth$ Q$ Return#)
  (if (not (member DefaultItem$ ListItems@))
    (setq DefaultItem$ (nth 0 ListItems@))
  );if
  (setq NewValue$ DefaultItem$)
  (if (= Title$ "")(setq Title$ "Select Item"))
  (setq Title$ (strcat " " Title$))
  (if (= Prompt$ "")(setq Prompt$ "Selection:"))
  (setq PromptWidth$ (rtos (+ (GetDclWidth Prompt$) 1.34) 2 2))
  (setq PopupWidth~ 0)
  (foreach Item$ ListItems@
    (setq ItemWidth~ (GetDclWidth Item$))
    (if (> ItemWidth~ PopupWidth~)
      (setq PopupWidth~ ItemWidth~)
    );if
  );foreach
  (setq PopupWidth~ (+ PopupWidth~ 4))
  (if (< PopupWidth~ 9.09)
    (setq PopupWidth~ 9.09)
  );if
  (setq PopupWidth$ (rtos PopupWidth~ 2 2))
  (if (not (findfile "C:\\Temp\\Temp.dcl"))
    (progn (vl-load-com)(vl-mkdir "C:\\Temp"))
  );if
  (setq Q$ (chr 34))
  (setq FileName% (open "C:\\Temp\\Temp.dcl" "w"))
  (write-line "dcl_settings : default_dcl_settings { audit_level = 3; }"
    FileName%)
  (write-line "Temp : dialog {" FileName%)
  (write-line (strcat "  key = "Q$"title"Q$";") FileName%)
  (write-line (strcat "  initial_focus = "Q$"ListItems"Q$";") FileName%)
  (write-line (strcat "  label = "Q$ Q$";") FileName%)
  (write-line (strcat "  key = "Q$"Title"Q$";") FileName%)
  (write-line "  spacer;" FileName%)
  (write-line "  : row {" FileName%)
  (write-line "    : column {" FileName%)
  (write-line (strcat "      width = " PromptWidth$ ";") FileName%)
  (write-line "      fixed_width = true;" FileName%)
  (write-line "      spacer;" FileName%)
  (write-line "      : column {" FileName%)
  (write-line "        : text {" FileName%)
  (write-line (strcat "          key = "Q$"Prompt"Q$";") FileName%)
  (write-line (strcat "          label = "Q$ Q$";") FileName%)
  (write-line "          alignment = left;" FileName%)
  (write-line "        }" FileName%)
  (write-line "      }" FileName%)
  (write-line "    }" FileName%)
  (write-line "    : popup_list {" FileName%)
  (write-line (strcat "      key = "Q$"ListItems"Q$";") FileName%)
  (write-line (strcat "      width = " PopupWidth$ ";") FileName%)
  (write-line "      fixed_width = true;" FileName%)
  (write-line "    }" FileName%)
  (write-line "  }" FileName%)
  (write-line "  spacer;" FileName%)
  (write-line "  : row {" FileName%)
  (write-line "    : column {" FileName%)
  (write-line "      : ok_button {" FileName%)
  (write-line "        alignment = right;" FileName%)
  (write-line "        width = 11;" FileName%)
  (write-line "      }" FileName%)
  (write-line "    }" FileName%)
  (write-line "    : column {" FileName%)
  (write-line "      : cancel_button {" FileName%)
  (write-line "        alignment = left;" FileName%)
  (write-line "        width = 11;" FileName%)
  (write-line "      }" FileName%)
  (write-line "    }" FileName%)
  (write-line "  }" FileName%)
  (write-line "}" FileName%)
  (close FileName%)
  (setq Dcl_Id% (load_dialog "C:\\Temp\\Temp.dcl"))
  (new_dialog "Temp" Dcl_Id%)
  (set_tile "Title" Title$)
  (set_tile "Prompt" Prompt$)
  (set_tile_list "ListItems" ListItems@ DefaultItem$)
  (action_tile "ListItems" "(set_list_value \"ListItems@\" \"NewValue$\")")
  (setq Return# (start_dialog))
  (unload_dialog Dcl_Id%)
  (if (= Return# 0)
    (setq NewValue$ nil)
  );if
  NewValue$
);defun PopupList
;-------------------------------------------------------------------------------
; PopupListEnter - Dialog with popup_list box for selecting items in a list
; that uses the enter key as the accept key
; Arguments: 4
;   Title$ = Title of dialog
;   Prompt$ = Prompt of dialog
;   DefaultItem$ = Default item from list
;   ListItems@ = List of items for selection
; Returns: NewValue$ from ListItems@
;-------------------------------------------------------------------------------
(defun PopupListEnter (Title$ Prompt$ DefaultItem$ ListItems@ / Dcl_Id% FileName%
  Item$ ItemWidth~ NewValue$ PopupWidth~ PopupWidth$ PromptWidth$ Q$)
  (if (not (member DefaultItem$ ListItems@))
    (setq DefaultItem$ (nth 0 ListItems@))
  );if
  (setq NewValue$ DefaultItem$)
  (if (= Title$ "")(setq Title$ "Select Item"))
  (setq Title$ (strcat " " Title$))
  (if (= Prompt$ "")(setq Prompt$ "Selection:"))
  (setq PromptWidth$ (rtos (+ (GetDclWidth Prompt$) 1.34) 2 2))
  (setq PopupWidth~ 0)
  (foreach Item$ ListItems@
    (setq ItemWidth~ (GetDclWidth Item$))
    (if (> ItemWidth~ PopupWidth~)
      (setq PopupWidth~ ItemWidth~)
    );if
  );foreach
  (setq PopupWidth~ (+ PopupWidth~ 4))
  (if (< PopupWidth~ 9.09)
    (setq PopupWidth~ 9.09)
  );if
  (setq PopupWidth$ (rtos PopupWidth~ 2 2))
  (if (not (findfile "C:\\Temp\\Temp.dcl"))
    (progn (vl-load-com)(vl-mkdir "C:\\Temp"))
  );if
  (setq Q$ (chr 34))
  (setq FileName% (open "C:\\Temp\\Temp.dcl" "w"))
  (write-line "dcl_settings : default_dcl_settings { audit_level = 3; }"
    FileName%)
  (write-line "Temp : dialog {" FileName%)
  (write-line (strcat "  key = "Q$"title"Q$";") FileName%)
  (write-line (strcat "  initial_focus = "Q$"ListItems"Q$";") FileName%)
  (write-line (strcat "  label = "Q$ Q$";") FileName%)
  (write-line (strcat "  key = "Q$"Title"Q$";") FileName%)
  (write-line "  spacer;" FileName%)
  (write-line "  : row {" FileName%)
  (write-line "    : column {" FileName%)
  (write-line (strcat "      width = " PromptWidth$ ";") FileName%)
  (write-line "      fixed_width = true;" FileName%)
  (write-line "      spacer;" FileName%)
  (write-line "      : column {" FileName%)
  (write-line "        : text {" FileName%)
  (write-line (strcat "          key = "Q$"Prompt"Q$";") FileName%)
  (write-line (strcat "          label = "Q$ Q$";") FileName%)
  (write-line "          alignment = left;" FileName%)
  (write-line "        }" FileName%)
  (write-line "      }" FileName%)
  (write-line "    }" FileName%)
  (write-line "    : popup_list {" FileName%)
  (write-line (strcat "      key = "Q$"ListItems"Q$";") FileName%)
  (write-line (strcat "      width = " PopupWidth$ ";") FileName%)
  (write-line "      fixed_width = true;" FileName%)
  (write-line "    }" FileName%)
  (write-line "  }" FileName%)
  (write-line "  spacer;" FileName%)
  (write-line "  : ok_button {" FileName%)
  (write-line "    is_cancel = true;" FileName%)
  (write-line "  }" FileName%)
  (write-line "}" FileName%)
  (close FileName%)
  (setq Dcl_Id% (load_dialog "C:\\Temp\\Temp.dcl"))
  (new_dialog "Temp" Dcl_Id%)
  (set_tile "Title" Title$)
  (set_tile "Prompt" Prompt$)
  (set_tile_list "ListItems" ListItems@ DefaultItem$)
  (action_tile "ListItems" "(set_list_value \"ListItems@\" \"NewValue$\")")
  (start_dialog)
  (unload_dialog Dcl_Id%)
  NewValue$
);defun PopupListEnter
;-------------------------------------------------------------------------------
; set_list_value - Sets SentVar$ to the item selected in SentList$
; Arguments: 2
;   SentList$ = String of the list variable name
;   SentVar$ = String of the variable name
; Syntax: (set_list_value "ListName" "Variable")
;-------------------------------------------------------------------------------
(defun set_list_value (SentList$ SentVar$ / SaveVar$ SubList@)
  (setq SubList@ (eval (read SentList$)))
  (setq SaveVar$ (eval (read SentVar$)))
  (set (read SentVar$) (nth (atoi $value) SubList@))
  (if (= (eval (read SentVar$)) "")
    (progn
      (set (read SentVar$) SaveVar$)
      (set_tile_list $key SubList@ SaveVar$)
    );progn
  );if
  (princ)
);defun set_list_value
;-------------------------------------------------------------------------------
; set_tile_list - Sets a dialog popup_list or list_box tile to a list
; Arguments: 3
;   KeyName$ = Key name of tile
;   ListName@ = The list to set in tile
;   Selected = An item in the ListNames@ or a list of items selected
; Syntax: (set_tile_list "TileName" '("A" "B" "C") "B")
;         (set_tile_list "TileName" '("A" "B" "C") '("A" "C"))
; Returns: Sets Selected items in dialog popup_list or list_box tiles.
;-------------------------------------------------------------------------------
(defun set_tile_list (KeyName$ ListName@ Selected / Item)
  (start_list KeyName$ 3)
  (mapcar 'add_list ListName@)
  (end_list)
  (foreach Item (if (listp Selected) Selected (list Selected))
   (if (member Item ListName@)
     (set_tile KeyName$ (itoa (- (length ListName@) (length (member Item ListName@)))))
   );if
  );foreach
);defun set_tile_list
;-------------------------------------------------------------------------------
(if (not (findfile "C:\\Temp\\Temp.dcl"))
  (progn (vl-load-com)(vl-mkdir "C:\\Temp"))
);if
;-------------------------------------------------------------------------------
; Color Numbers Used:
; 1 = Red, 2 = Yellow, 3 = Green, 4 = Cyan, 5 = Blue, 6 = Magenta, 8 = Dk Gray,
; 9 = Lt Gray, 16 = Dk Red, 20 = Red Orange, 54 = Dk Yellow, 96 = Dk Green,
; 134 = Dk Cyan, 174 = Dk Blue, 214 = Dk Magenta, 250 = Black, 255 = White
;-------------------------------------------------------------------------------
(princ);End of GetIcon.lsp