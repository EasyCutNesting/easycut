(vl-load-com)
;;;=====================================================
;;; Copyright (c) Highflybird 2012  All rights reserves.
;;; Some code borrowed from Lee Mac,Thank him very much!
;;;=====================================================
;;; This is an example lisp file,show how to use it.    
;;; Command :Test                                       
;;; Function:Get the Pixel infomation from a resource   
;;;          file(e.g:.exe,.dll,.ocx,.arx)or image file,
;;;          then draw it into CAD or DCL, or maybe  for
;;;          other use. This one is for DCL.            
;;; Argument:None                                       
;;; Return:  Null.                                      
;;;=====================================================
(defun c:test (/ *error* dch dcl des i images j x y R G B W H wStr hStr rStr key
                 ColorObj DCLHead DCLList DCLTail ImageHead IndexColor Version)
  (defun *error* (msg)
    (and (< 0 dch) (unload_dialog dch))
    (and dcl (findfile dcl) (vl-file-delete dcl))
    (if (not (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*"))
      (princ (strcat "\nError: " msg))
    )
    (princ)
  )
  ;Read the data file that made from PixelExtractor.exe
  (setq images (ReadFromFile))
  (and (null Images) (exit))
  ;;Get a CAD color object.
  (setq Version (substr (getvar 'acadver) 1 2))
  (setq Version (strcat "AutoCAD.AcCmColor." version))
  (setq ColorObj (vlax-create-object version))
  ;;DCL head, for Dynamic DCL file.
  (setq DCLHead
         (list
           "img : image"
           "{"
           "    fixed_width = true;"
           "    fixed_height = true; "
           "    alignment = centered;"
           "}"
           "test : dialog "
           "{"
           "    label = \"ImageToDCL Test\";"
           "    spacer;"
           "    : row"
           "    {"
          )
  )
  (setq DCLList DCLHead)
  (setq i 0)
  (foreach image Images
    (setq ImageHead  "    : img { key = \"img")   
    (setq ImageHead (strcat ImageHead (itoa i) "\";"))
    (setq w (1+ (car (last Image))))
    (setq h (1+ (cadr (last Image))))
    (setq wStr (strcat "      width = " (rtos (/ w 6.0) 2 4) ";"))
    (setq hStr (strcat "      height = " (rtos (/ h 6.0) 2 4) ";"))
    (setq rStr (strcat "      aspect_ratio = " (rtos (/ h w 1.0) 2 4) ";}"))
    (setq DCLList (append DCLList (list ImageHead wstr rStr)))
    (setq i (1+ i))
  )
  (setq DCLTail
         (list
           "    }"
           "    spacer;"
           "    ok_only;"
           "}"
         )
  )
  (setq DCLList (append DCLList DCLTail))
  (setq dcl (vl-filename-mktemp nil nil ".dcl"))
  (setq des (open dcl "w"))
  (foreach line DCLList
    (write-line line des)
  )
  (close des)
  ;;Load dialog
  (setq dch (load_dialog dcl))
  (new_dialog "test" dch)
  ;;Fill Image control(s)
  (setq i 0)
  (foreach image Images
    (setq key (strcat "img" (itoa i)))
    (start_image key)
    (fill_image 0 0 (dimx_tile key) (dimy_tile key) -15)
    (foreach pt (cdr Image)
      (setq x (car pt))
      (setq y (cadr pt))
      (setq r (nth 2 pt))
      (setq g (nth 3 pt))
      (setq b (nth 4 pt))
      (setq IndexColor (RGB->Index ColorObj r g b))
      (if (/= 0 (last pt))
        (fill_image x y 1 1 IndexColor)
      )
    )
    (end_image)
    (setq i (1+ i))
  )
  ;;Start to show the image
  (start_dialog)
  (setq dch (unload_dialog dch))
  (and dcl (findfile dcl) (vl-file-delete dcl))
  (and (< 0 dch) (unload_dialog dch))
  (and ColorObj (vlax-release-object ColorObj))
  (princ)
)
 
;;;=====================================================
;;; Command :Test1                                      
;;; Function:ditto, Just put the image(s) into AutoCAD  
;;;          drawing area, and it support true color.   
;;; Argument:None                                       
;;; Return:  Null.                                      
;;;=====================================================
(defun C:test1 (/ i x y r g b e p0 X0 Y0)
  (setq p0 (getpoint "\nInsert point:"))
  (and (null p0) (setq p0 '(0 0)))
  (setq p0 (trans p0 1 0))
  (setq x0 (car p0))
  (setq y0 (cadr p0))
  (setq i 0)
  (foreach Image (ReadFromFile)
    (foreach pt (cdr Image)
      (if (/= 0  (last pt))
        (setq x (+ i (car pt))
              y (- (cadr pt))
              r (nth 2 pt)
              g (nth 3 pt)
              b (nth 4 pt)
              e (putpixel (+ x x0) (+ y y0) (RGB->Number r g b))
        )
      )
    )
    (setq i (1+ x))
  )
  (princ)
)
 
;;;=====================================================
;;;Read pixel infomation from a lisp(data) file.        
;;;=====================================================
(defun ReadFromFile (/ path name)
  (setq path (getvar 'users5))
  (if (zerop (strlen path))
    (setq path (getvar 'DWGPREFIX))
  )
  (if (setq name (getfiled "Select a data file" path "lsp" 0))
    (progn 
      (setvar 'users5 (strcat (VL-FILENAME-DIRECTORY name) "\\"))
      (load name)
    )
  )
)
 
;;;=====================================================
;;;Draw a pixel by polyline method.(EntmakeX is faster.)
;;;=====================================================
(defun putpixel (x y color)
  (entmakeX
    (list
      '(0 . "LWPOLYLINE")
      '(100 . "AcDbEntity")
      '(100 . "AcDbPolyline")
      '(90 . 2)
      '(43 . 1.0)
      (cons 420 color)
      (cons 10 (list x y))
      (cons 10 (list (1+ x) y))
    )
  )
)
 
;;;=====================================================
;;;Some functions about color conversion.               
;;;=====================================================
;;;Truecolor Number (420) to RGB list                   
;;;=====================================================
(defun Number->RGB (color)
  (list (lsh color -16)
        (lsh (lsh color 16) -24)
        (lsh (lsh color 24) -24)
  )
)
;;;=====================================================
;;;RGB list to Truecolor Number (420)                   
;;;=====================================================
(defun RGB->Number (R G B)
  (+ (lsh R 16) (lsh G 8) B)
)
;;;=====================================================
;;;RGB color(truecolor) to Index color                  
;;;=====================================================
(defun RGB->Index (ColorObj r g b / i)
  (if (and (equal 0 r 10) (equal 0 g 10) (equal 0 b 10))
    -16                                                 ;It should be 0,but if you have set the CAD background color,then it looks strange.
    (progn
      (vla-setRGB ColorObj r g b)
      (setq i (vla-get-ColorIndex ColorObj))
      (if (= i 7)                                       ;A little confused!
        255
        i
      )
    )
  )
)
 
;;;=====================================================
;;;Index color to RGB color(truecolor)                  
;;;=====================================================
(defun Index->RGB (ColorObj ci /)
  (vla-put-ColorIndex ColorObj ci)
  (list (vla-get-red ColorObj)
        (vla-get-green ColorObj)
        (vla-get-blue ColorObj)
  )
)
 
(prompt "\nPlease run:test or test1")
(princ)
 