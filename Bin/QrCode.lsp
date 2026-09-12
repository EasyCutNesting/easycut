;
;
;
(defun FunPixel (/ PointToLine
				   Ssel Num ModelSpace EnamePoint)

	(defun PointToLine (EnamePoint ModelSpace / Pt Line1 Line2)
	
		(if EnamePoint
			(progn
				(setq Pt (cdr (assoc 10 (entget EnamePoint))))
				(setq Line1 (vla-addline ModelSpace (vlax-3d-point (- (car Pt) 0.25) (cadr Pt)) (vlax-3d-point (+ (car Pt) 0.25) (cadr Pt))))
				(setq Line2 (vla-addline ModelSpace (vlax-3d-point (car Pt) (+ 0.25 (cadr Pt))) (vlax-3d-point (car Pt) (- (cadr Pt) 0.25))))
				(setq Color (vla-get-color (vlax-ename->vla-object EnamePoint)))
				(vla-put-color Line1 Color)
				(vla-put-color Line2 Color)
			)
		)
	)

	(setq Ssel (ssget))
	(setq Num 0)
	(setq ModelSpace  (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))

	(if Ssel
		(repeat (sslength Ssel)
			(setq EnamePoint (ssname Ssel Num))
			(PointToLine EnamePoint ModelSpace)	
			(setq Num (1+ Num))
		)
	)
)
;
;
;
(defun ResizeWindowDrawing (HSize WSize / Aobj)

	; per Button_Image 250 x 250
	; 234.0 212.0
	; 250.0 250.0
	;  16    38
	 
	(setq Aobj (vla-get-activedocument (vlax-get-acad-object)))
	(vla-put-windowstate Aobj 3)
	
	(if (and HSize WSize)
		(progn
			
			(vla-put-width  Aobj (+ WSize 16))
			(vla-put-height Aobj (+ HSize 39))
		)
		(if (< (vla-get-windowstate Aobj) 3)
			(vla-put-windowstate Aobj 3)
		)
	)
	(princ (setq Ssize (getvar "ScreenSize"))) (princ)
)
;
;
;
(defun Acad64Bit-version ()
  (vl-load-com)
  (> (strlen (vl-prin1-to-string (vlax-get-acad-object))) 40)
)
;
;
;
(defun Acad64Bit-platform ()
  (vl-string-search "64" (getenv "PROCESSOR_ARCHITECTURE"))
)
;
;
;
(defun QRcode ( / FilePng FileVbs FileBat FileChk str TypeImportFile res Loop)

	(setq FilePng (strcat (getvar "SAVEFILEPATH") "EasyCutQrcode.png"))
	(setq FileVbs (strcat (getvar "SAVEFILEPATH") "EasyCutQrcode.vbs"))
	(setq FileBat (strcat (getvar "SAVEFILEPATH") "EasyCutQrcode.bat"))
	(setq FileChk (strcat (getvar "SAVEFILEPATH") "EasyCutQrcode.chk"))		
	(if (findfile FilePng) (vl-file-delete FilePng))
	(if (findfile FileVbs) (vl-file-delete FileVbs))
	(if (findfile FileBat) (vl-file-delete FileBat))
	(if (findfile FileChk) (vl-file-delete FileChk))
	
	(setq res "300")
	
	(if (setq str (getstring "\nTesto encode :" T))
		(progn
			
			;(setq TypeImportFile (getint "\nTipo import [1 Pixelation image] [2 Embedded image] [3 Reference image] "))
			(setq TypeImportFile (getint "\nTipo import [1 Embedded image] [2 Reference image] "))
			
			(cond 
				;((= TypeImportFile 1)
				;
				;	(vl-registry-write (strcat EasyCutRegistryPath$ "\\Imaging") "Key1" (urlencode str))
				;	(if (Acad64Bit-platform)
				;		(vl-registry-write (strcat EasyCutRegistryPath$ "\\Imaging") "Key2" (strcat BinPathEasyCut$ "ImageMagickConvert-x64.exe"))
				;		(vl-registry-write (strcat EasyCutRegistryPath$ "\\Imaging") "Key2" (strcat BinPathEasyCut$ "ImageMagickConvert-x86.exe"))
				;	)
				;	(vl-vbarun (strcat BinPathEasyCut$ "BitmapMapping.dvb!Module1.ShowQrcode"))
				;)
				((= TypeImportFile 1)
				
					(ClipBordClearData)
					(GetQRcode (urlencode str) res FilePng FileVbs FileBat FileChk)
					;(vl-registry-write (strcat EasyCutRegistryPath$ "\\Imaging") "Key1" FileBat)
					;(vl-vbarun (strcat BinPathEasyCut$ "BitmapMapping.dvb!Module1.ShellHide"))
					(startapp (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") 
										"\\Apps\\EasyCutShellHideForm.exe"
										" "
										FileBat
							   )
					)
					(setq Loop T)
					(while Loop
						(if (findfile FileChk)
							(setq Loop nil)
						)
					)
					(command "_pastespec")
				
					
				)
				((= TypeImportFile 2)
				
					(ClipBordClearData)
					(GetQRcode (urlencode str) res FilePng FileVbs FileBat FileChk)
					;(vl-registry-write (strcat EasyCutRegistryPath$ "\\Imaging") "Key1" FileBat)
					;(vl-vbarun (strcat BinPathEasyCut$ "BitmapMapping.dvb!Module1.ShellHide"))
					(startapp (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") 
										"\\Apps\\EasyCutShellHideForm.exe"
										" "
										FileBat
							   )
					)
					(setq Loop T)
					(while Loop
						(if (findfile FileChk)
							(setq Loop nil)
						)
					)
					
					(AttachImage FilePng (getpoint "\nPunto inserimento") 1 0)
				)
			)
		)
	)
)
;
;
;
(defun ShowImage ( / FileBat FileChk PathImage FileImage TypeImportFile Loop)

	

	(setq FileBat (strcat (getvar "SAVEFILEPATH") "EasyCutImage.bat"))
	(setq FileChk (strcat (getvar "SAVEFILEPATH") "EasyCutImage.chk"))
	(if (findfile FileBat) (vl-file-delete FileBat))
	(if (findfile FileChk) (vl-file-delete FileChk))


	(setq PathImage (vl-registry-read EasyCutRegistryPath$ "Imaging"))
	(if (= PathImage "")
		(progn
			(setq PathImage (getvar "DWGPREFIX"))
			(vl-registry-write EasyCutRegistryPath$ "Imaging" PathImage)
		)
	)
	
	(setq FileImage (LM:getfiles "Seleziona file" PathImage "bmp,gif,tif,jpg,png"))
	
	
	(if FileImage
		(progn
			(setq FileImage (nth 0 FileImage))
			;(setq TypeImportFile (getint "\nTipo import [1 Pixelation image] [2 Embedded image] [3 Reference image] "))
			(setq TypeImportFile (getint "\nTipo import [1 Embedded image] [2 Reference image] "))
			(vl-registry-write EasyCutRegistryPath$ "Imaging" (strcat (vl-filename-directory Fileimage) "\\"))
			
			(cond 
				;((= TypeImportFile 1)
				;	(vl-registry-write (strcat EasyCutRegistryPath$ "\\Imaging") "Key1" FileImage)
				;	(if (Acad64Bit-platform)
				;		(vl-registry-write (strcat EasyCutRegistryPath$ "\\Imaging") "Key2" (strcat BinPathEasyCut$ "ImageMagickConvert-x64.exe"))
				;		(vl-registry-write (strcat EasyCutRegistryPath$ "\\Imaging") "Key2" (strcat BinPathEasyCut$ "ImageMagickConvert-x86.exe"))
				;	)
				;	(vl-vbarun (strcat BinPathEasyCut$ "BitmapMapping.dvb!Module1.PixelationImage"))
				;)
				((= TypeImportFile 1)
					(ImageClip FileImage FileBat FileChk)
					;(vl-registry-write (strcat EasyCutRegistryPath$ "\\Imaging") "Key1" FileBat)
					;(vl-vbarun (strcat BinPathEasyCut$ "BitmapMapping.dvb!Module1.ShellHide"))
					(startapp (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") 
										"\\Apps\\EasyCutShellHideForm.exe"
										" "
										FileBat
							   )
					)
					(setq Loop T)
					(while Loop
						(if (findfile FileChk)
							(setq Loop nil)
						)
					)
					(command "_pastespec")
				)
				((= TypeImportFile 2)
					(DetachImage FileImage)
					(ImageClip FileImage FileBat FileChk)
					;(vl-vbarun (strcat BinPathEasyCut$ "BitmapMapping.dvb!Module1.ShellHide"))
					(startapp (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") 
										"\\Apps\\EasyCutShellHideForm.exe"
										" "
										FileBat
							   )
					)
					(setq Loop T)
					(while Loop
						(if (findfile FileChk)
							(setq Loop nil)
						)
					)
					(AttachImage FileImage (getpoint "\nPunto inserimento") 1 0)
				)
			)	
		)		
	)
)
;
;
;
(defun ImageClip (FileImage FileBat FileChk / Stream)

	(if (and FileImage FileBat FileChk)
		(progn
			(setq Stream (open FileBat "w"))
			(if Stream
				(progn
					(princ (strcat "if exist " (chr 34) FileChk (chr 34) " del " (chr 34) FileChk (chr 34)) 					Stream)
					(princ (strcat "\n" 
									(chr 34) 
									(strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Apps\\clipimage.exe")
									;BinPathEasyCut$ "clipimage.exe" 
									(chr 34) 
									" " 
									(chr 34) 
									FileImage 
									(chr 34)
							)
							Stream
					)
					(princ (strcat "\nECHO script_vbs > " (chr 34) FileChk (chr 34) "\n") 										Stream)
					(close Stream)
				)
			)		
		)
	)
)
;
;
;
(defun GetQRcode (string res filepng filevbs filebat filechk / Stream)
				
; src = "http://chart.googleapis.com/chart?cht=qr&chs=150x150&choe=UTF-8&chld=H&chl=http://13456"
; Set v1 = CreateObject ("MSXML2.XMLHTTP")
; Set v2  = CreateObject ("ADODB.Stream")
; v1.open "GET", src, false
; v1.send ()
; v2.open
; v2.Type = 1
; v2.Write v1.ResponseBody
; v2.SaveToFile "out.png"				


	(if (and string res filepng filevbs filebat filechk)
		(progn
		
			(if (findfile filepng) (vl-file-delete filepng))		
			(if (findfile filevbs) (vl-file-delete filevbs))
			(if (findfile filebat) (vl-file-delete filebat))
			(if (findfile filechk) (vl-file-delete filechk))
		
			(setq Stream (open filevbs "w"))
			(if Stream
				(progn
					(princ (strcat "src =" (chr 34) "http://chart.googleapis.com/chart?cht=qr&chs=" res "&choe=UTF-8&chld=H&chl=" (urlencode string) (chr 34)) 	Stream)
					(princ (strcat "\nSet v1 = CreateObject (" (chr 34) "MSXML2.XMLHTTP" (chr 34) ")") 															Stream)
					(princ (strcat "\nSet v2  = CreateObject (" (chr 34) "ADODB.Stream" (chr 34) ")") 															Stream)
					(princ (strcat "\nv1.open " (chr 34) "GET" (chr 34) ", src, false") 																		Stream)
					(princ (strcat "\nv1.send ()") 																												Stream)
					(princ (strcat "\nv2.open") 																												Stream)
					(princ (strcat "\nv2.Type = 1")																												Stream)
					(princ (strcat "\nv2.Write v1.ResponseBody") 																								Stream)
					(princ (strcat "\nv2.SaveToFile "  (chr 34) filepng (chr 34) ) 																				Stream)
					(close Stream)
					
				)
			)
			(setq Stream (open filebat "w"))
			(if Stream
				(progn
					(princ (strcat "if exist " (chr 34) filechk (chr 34) " del " (chr 34) filechk (chr 34)) 				Stream)
					(princ (strcat "\ncscript " (chr 34) filevbs (chr 34) " //nologo") 										Stream)
					;(princ (strcat "\n" (chr 34) BinPathEasyCut$ "clipimage.exe" (chr 34) " " (chr 34) filepng (chr 34)) 	Stream)
					
					(princ (strcat "\n" 
									(chr 34) 
									(strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Apps\\clipimage.exe")
									(chr 34) 
									" " 
									(chr 34) 
									filepng 
									(chr 34)
							) 	
							Stream)
					
					(princ (strcat "\nECHO script_vbs > " (chr 34) filechk (chr 34)) 										Stream)
					(close Stream)
				)
			)
		)
	)
)
;
;
;		
(defun urlencode (str / result n len )
	(setq result ""
		  n 1
		  len (strlen str)
	)
	(while (<= n len)
			(setq result (strcat result (urlenc (substr str n 1)))
				  n (+ 1 n))
	)
	result
)
;
;
;
(defun urlenc (ch)
	(cond
		((eq ch " ") " ");+
		((eq ch "!") "%21")
		((eq ch "\"") "%22")
		((eq ch "#") "%23")
		((eq ch "$") "%24")
		((eq ch "%") "%25")
		((eq ch "&") "%26")
		((eq ch "'") "%27")
		((eq ch "(") "%28")
		((eq ch ")") "%29")
		((eq ch "*") "%2A")
		((eq ch "+") "%2B")
		((eq ch ",") "%2C")
		((eq ch "/") "%2F")
		((eq ch ":") "%3A")
		((eq ch ";") "%3B")
		((eq ch "<") "%3C")
		((eq ch "=") "%3D")
		((eq ch ">") "%3E")
		((eq ch "?") "%3F")
		((eq ch "@") "%40")
		((eq ch "[") "%5B")
		((eq ch "\\") "%5C")
		((eq ch "]") "%5D")
		((eq ch "^") "%5E")
		((eq ch "`") "%60")
		((eq ch "{") "%7B")
		((eq ch "|") "%7C")
		((eq ch "}") "%7D")
		((eq ch "~") "%7E")
		((eq ch "‘") "%91")
		((eq ch "’") "%92")
		((eq ch "¡") "%A1")
		((eq ch "¢") "%A2")
		((eq ch "£") "%A3")
		((eq ch "¤") "%A4")
		((eq ch "¥") "%A5")
		((eq ch "¦") "%A6")
		((eq ch "§") "%A7")
		((eq ch "¨") "%A8")
		((eq ch "©") "%A9")
		((eq ch "ª") "%AA")
		((eq ch "«") "%AB")
		((eq ch "¬") "%AC")
		((eq ch "­") "%AD")
		((eq ch "®") "%AE")
		((eq ch "¯") "%AF")
		((eq ch "°") "%B0")
		((eq ch "±") "%B1")
		((eq ch "²") "%B2")
		((eq ch "³") "%B3")
		((eq ch "´") "%B4")
		((eq ch "µ") "%B5")
		((eq ch "¶") "%B6")
		((eq ch "·") "%B7")
		((eq ch "¸") "%B8")
		((eq ch "¹") "%B9")
		((eq ch "º") "%BA")
		((eq ch "»") "%BB")
		((eq ch "¼") "%BC")
		((eq ch "½") "%BD")
		((eq ch "¾") "%BE")
		((eq ch "¿") "%BF")
		((eq ch "À") "%C0")
		((eq ch "Á") "%C1")
		((eq ch "Â") "%C2")
		((eq ch "Ã") "%C3")
		((eq ch "Ä") "%C4")
		((eq ch "Å") "%C5")
		((eq ch "Æ") "%C6")
		((eq ch "Ç") "%C7")
		((eq ch "È") "%C8")
		((eq ch "É") "%C9")
		((eq ch "Ê") "%CA")
		((eq ch "Ë") "%CB")
		((eq ch "Ì") "%CC")
		((eq ch "Í") "%CD")
		((eq ch "Î") "%CE")
		((eq ch "Ï") "%CF")
		((eq ch "Ð") "%D0")
		((eq ch "Ñ") "%D1")
		((eq ch "Ò") "%D2")
		((eq ch "Ó") "%D3")
		((eq ch "Ô") "%D4")
		((eq ch "Õ") "%D5")
		((eq ch "Ö") "%D6")
		((eq ch "×") "%D7")
		((eq ch "Ø") "%D8")
		((eq ch "Ù") "%D9")
		((eq ch "Ú") "%DA")
		((eq ch "Û") "%DB")
		((eq ch "Ü") "%DC")
		((eq ch "Ý") "%DD")
		((eq ch "Þ") "%DE")
		((eq ch "ß") "%DF")
		((eq ch "à") "%E0")
		((eq ch "á") "%E1")
		((eq ch "â") "%E2")
		((eq ch "ã") "%E3")
		((eq ch "ä") "%E4")
		((eq ch "å") "%E5")
		((eq ch "æ") "%E6")
		((eq ch "ç") "%E7")
		((eq ch "è") "%E8")
		((eq ch "é") "%E9")
		((eq ch "ê") "%EA")
		((eq ch "ë") "%EB")
		((eq ch "ì") "%EC")
		((eq ch "í") "%ED")
		((eq ch "î") "%EE")
		((eq ch "ï") "%EF")
		((eq ch "ð") "%F0")
		((eq ch "ñ") "%F1")
		((eq ch "ò") "%F2")
		((eq ch "ó") "%F3")
		((eq ch "ô") "%F4")
		((eq ch "õ") "%F5")
		((eq ch "ö") "%F6")
		((eq ch "÷") "%F7")
		((eq ch "ø") "%F8")
		((eq ch "ù") "%F9")
		((eq ch "ú") "%FA")
		((eq ch "û") "%FB")
		((eq ch "ü") "%FC")
		((eq ch "ý") "%FD")
		((eq ch "þ") "%FE")
		((eq ch "ÿ") "%FF")
		(T ch)
	)
)
;
;
;
(defun C:ImageInfo (/)
  (setq image (vla-get-ImageFile (vlax-ename->vla-object (car (entsel "\nSelect Image:")))))
  (setq start1 (getvar "CDATE"))
  (setq stream (vlax-get-or-create-object "ADODB.stream"))
  (vlax-put-property stream 'type 1)
  (vlax-invoke stream 'open)
  (vlax-invoke stream 'loadfromfile image)
  (vlax-put-property stream 'position 0)
  (setq size (vlax-get stream 'size))
  (setq variable (cond ((< size 10000)10)
         ((< size 100000)100)
         ((< size 1000000)10000)
         ((< size 10000000)100000)
         ((< size 100000000)10000000)
         ((< size 1000000000)100000000)))
  (setq count 0)
  (setq text (vlax-variant-value (vlax-invoke-method stream 'read (vlax-get stream 'size))))
  (setq hextext nil)
  (setq hexbatch nil)
  (setq finalhextext nil)
  (setq countcol 0)
  (setq colmax 256)
  (setq countdata 0)
  (setq datamax 256)
  
  (while (< count size)
		(setq hextext (append hextext (list (DecToHex (vlax-safearray-get-element text count)))))
		(setq count (+ count 1))
		(setq countdata (+ countdata 1))
		(if (= countdata datamax)
			(progn
				(setq hexbatch (append hexbatch (list hextext)))
				(setq hextext nil)
				(setq countcol (+ countcol 1))
				(setq countdata 0)
			)
		)
		(if (= countcol colmax)
			(progn
				(setq finalhextext (append finalhextext (list hexbatch)))
				(setq hexbatch nil)
				(setq countcol 0)
			)
		)
		;(if (= (rem count (/ size variable)) 0)
		;	(print (strcat "ETA:" (rtos (*(/(*(- (setq finish2 (getvar "CDATE")) start1)1000000)count)(-(* 1.0 size) count)))))
		;)
   )
   
  (setq hexbatch (append hexbatch (list hextext)))
  (setq finalhextext (append finalhextext (list hexbatch)))
  (setq finish1 (getvar "CDATE"))
  
  
  (alert (strcat "Image to hex: " 				(rtos (*(- finish1 start1)1000000))))
  
  (setq data1 (itoa (hexcounter (strcat (offset 2  finalhextext) " " (offset 3  finalhextext) " " (offset  4 finalhextext) " " (offset 5 finalhextext)))))
  (setq data2 (itoa (hexcounter (strcat (offset 10 finalhextext) " " (offset 11 finalhextext) " " (offset 12 finalhextext) " " (offset 13 finalhextext)))))
  (setq data3 (itoa (hexcounter (strcat (offset 18 finalhextext) " " (offset 19 finalhextext) " " (offset 20 finalhextext) " " (offset 21 finalhextext)))))
  (setq data4 (itoa (hexcounter (strcat (offset 22 finalhextext) " " (offset 23 finalhextext) " " (offset 24 finalhextext) " " (offset 25 finalhextext)))))
  (setq data5 (itoa (hexcounter (strcat (offset 26 finalhextext) " " (offset 27 finalhextext)))))
  (setq data6 (itoa (hexcounter (strcat (offset 28 finalhextext) " " (offset 29 finalhextext)))))
  (setq data7 (itoa (hexcounter (strcat (offset 30 finalhextext) " " (offset 31 finalhextext) " " (offset 32 finalhextext) " " (offset 33 finalhextext)))))
  (setq data8 (itoa (hexcounter (strcat (offset 34 finalhextext) " " (offset 35 finalhextext) " " (offset 36 finalhextext) " " (offset 37 finalhextext)))))
  
  (princ (strcat "\nFile Size:              " data1))
  (princ (strcat "\nPixel Array starts at:  " data2))
  (princ (strcat "\nWidth:                  " data3))
  (princ (strcat "\nHight:                  " data4))
  (princ (strcat "\nNumber of Color Planes: " data5))
  (princ (strcat "\nBits Per Pixel:         " data6))
  (princ (strcat "\nPixel Array Compression:" data7))
  (princ (strcat "\nSize of Raw pixel Data: " data8))
  (terpri)
   
;  (setq loop (atoi data8))
;  (setq start (atoi data2))
;  (setq conta 0)
;  (repeat loop
;		(setq idx (offset start finalhextext))
;		(if (/= (hexcounter idx) 255)
;			(progn
;				
;				(princ (hexcounter idx)) (princ "  ") (princ conta) (terpri)
;				;(setq conta 0)
;			)
;		)
;		(setq conta (1+ conta))
;		(setq start (1+ start))
; )
; (princ)
)
;
;
;
(defun DecToHex (int /)
  (setq int (cond ((> int 256)(rem int 256))
    ((< int 0)(+(rem int 256) 256))
    (t int))
 )
  (if (= int 256)
    "00"
    (progn
      (setq b (rem int 16))
      (setq a (/ (- int b) 16))
      (strcat (if (< a 10)(itoa a)(chr (+ 55 a))) (if (< b 10)(itoa b)(chr (+ 55 b))))
      )
    )
)
;
;
;
(defun HexToDec (str /)
  (setq a (substr str 1 1))
  (setq b (substr str 2 1))
  
  (if (wcmatch a "@")
    (setq a (- (vl-string-elt a 0) 55))
    (setq a (atoi a))
    )
  (if (wcmatch b "@")
    (setq b (- (vl-string-elt b 0) 55))
    (setq b (atoi b))
    )
  ;(princ (+(* a 16) b))
  (+(* a 16) b)
)
;
;
;
(defun 3Ddata (row col data source)
  (nth data (nth col (nth row source)))
)
;
;
;
(defun offset (digit source)
  (setq row (/ (- digit (rem digit 65536)) 65536))
  (setq digit (- digit (* row 65536)))
  (setq col (/ (- digit (rem digit 256)) 256))
  (setq digit (- digit (* col 256)))
  (setq data digit)
  (3ddata row col data source)
)
;
;
;
(defun hexcounter (string)
  (while (wcmatch string "* *")(setq string (vl-string-subst "" " " string)))
  (setq len (strlen string))
  (setq strcount 0)
  (setq hexarray nil)
  (setq value 0)
  (setq arraypower 0)
  (while (< strcount len)
    (setq hexarray (append hexarray (list (substr string (+ strcount 1) 2))))
    (setq strcount (+ strcount 2))
  )
  (foreach hexbyte hexarray
    (setq value (+ value (* (hextodec hexbyte) (expt 256 arraypower))))
    (setq arraypower (+ arraypower 1))
    )
  value
)
;
;
;
(defun ImageLst (/ img lst)
  (vl-load-com)
  (if (vl-catch-all-error-p
       (setq img  (vl-catch-all-apply 'vla-item (list (vla-get-dictionaries (vla-get-activedocument (vlax-get-acad-object))) "ACAD_IMAGE_DICT")))
	  ) nil
     (vlax-for i img
        (setq lst (cons i lst))
	  )
  )
  lst
)
;
;
;
(defun ClipBordClearData (/ HTML PW CB OK?)

	(if (and (not(vl-catch-all-error-p
				(setq HTML	(vl-catch-all-apply	'vlax-create-object (list "htmlfile")))
				)
			 )
			 (= (type HTML)'VLA-OBJECT)
		)
		(progn
			(setq OK? (and (not (vl-catch-all-error-p
											(setq PW (vl-catch-all-apply 'vlax-get (list HTML 'ParentWindow)))
								)
							)
						   (not (vl-catch-all-error-p
  						                   (setq CB (vl-catch-all-apply 'vlax-get (list PW 'ClipBoardData)))
								)
							)
						   (not (vl-catch-all-error-p
						                   (vl-catch-all-apply 'vlax-invoke (list CB 'Cleardata "TEXT"))
								)
							)
					  )
			)
			(vlax-release-object HTML)
		)
	)
	OK?
)



