(defun Encrypt (/ ffile_export ffile_import line)

	(setq ffile_export (open "C:\\EasyCutBeta\\Test\\test\\test.enc" "w"))
	(setq ffile_import (open "C:\\EasyCutBeta\\Test\\test\\test.lsp" "r"))
	
	(setq line (read-line ffile_import))
							  
	(while line
		(write-line  (vl-prin1-to-string (ABC_EncryptStr255 line)) ffile_export)
		(setq line (read-line ffile_import))
	)
	(close ffile_export)
	(close ffile_import)
)

(defun Decrypt (/ ffile_export ffile_import line)

	(setq ffile_export (open "C:\\EasyCutBeta\\Test\\test\\test.dec" "w"))
	(setq ffile_import (open "C:\\EasyCutBeta\\Test\\test\\test.enc" "r"))
	
	(setq line (read-line ffile_import))
							  
	(while line
		(if (read line)
		 	(write-line (ABC_DecryptStr255 (read line)) ffile_export)
			(write-line "")
		)
		(setq line (read-line ffile_import))
	)
	(close ffile_export)
	(close ffile_import)
)

;;;=========================================================================
;;; Encrypt a string with a base 255 ABC Cypher (defined below)
;;;=========================================================================
(defun ABC_EncryptStr255 (str / StrListDec CypherCode NewListDec NewStr)
  (if *ABC-Cypher255*
    (progn
      (setq StrListDec    (vl-string->list str)					;convert string to list of ascii codes
            CypherCode    (ABC_SubList (*ABC-Cypher255* "CAVEman") 1 (strlen str))		;get cypher in length of string to be encoded
            ;; cypher string
            NewListDec (mapcar '(lambda (x y) (ABC_IntShiftBaseUp x y 255)) StrListDec CypherCode)
            ;NewStr     (vl-list->string NewListDec)			;convert cyphered codes back to ascii
      )
    )
  )
)

;;;=========================================================================
;;; Decrypt a string with a base 255 ABC Cypher
;;;=========================================================================
(defun ABC_DecryptStr255 (str / StrListDec CypherCode NewListDec NewStr)
  (if *ABC-Cypher255*
    (progn
      (setq 
			
			StrListDec    str					
			str          (vl-list->string StrListDec)
			
			;StrListDec    (vl-string->list str)					;convert string to list of ascii codes
            CypherCode    (ABC_SubList (*ABC-Cypher255* "CAVEman") 1 (strlen str))		;get cypher in length of string to be encoded
            ;; cypher string
            NewListDec (mapcar '(lambda (x y) (ABC_IntShiftBaseDown x y 255)) StrListDec CypherCode)
            NewStr     (vl-list->string NewListDec)			;convert cyphered codes back to ascii
			
			
      )
    )
  )
)

;;;=========================================================================
;;; 1000 character long cypher - base 255
;;; Cypher definition needs to be protected from listing
;;; Use (*ABC-Cypher255* "CAVEman") to return list
;;; Be sure to declare as local
;;;=========================================================================
(defun *ABC-Cypher255* (password)
  (if (= password "CAVEman")
       (list 229  178  59   199  34   102  136  2    206  210  137  100  25   210  210  93   129  221  32   89   136
             7    228  152  226  34   231  47   204  212  130  180  208  2    116  178  161  97   187  141  78   128
             105  209  130  50   1    166  10   165  50   98   88   253  146  227  64   209  38   198  151  100  77
             19   7    228  2    108  178  150  217  107  244  70   206  50   241  195  60   213  35   215  23   171
             172  125  194  38   155  185  144  65   222  237  86   43   26   246  19   53   31   244  38   164  54
             17   251  134  247  33   187  16   233  111  232  179  154  146  99   102  118  162  217  92   253  166
             256  161  175  145  177  199  74   161  60   58   160  136  16   68   188  34   16   119  143  33   153
             109  210  127  186  159  105  14   136  74   233  1    9    13   137  197  185  85   48   254  12   36
             217  9    2    93   2    211  34   31   97   90   246  73   154  193  103  199  40   57   255  183  47
             168  133  4    125  90   227  136  98   161  227  84   159  171  158  56   33   120  50   23   195  61
             162  43   210  9    95   201  123  21   121  200  243  123  223  16   124  210  192  129  13   90   97
             178  200  58   137  181  10   143  216  103  50   166  24   114  240  68   242  139  69   74   5    23
             244  148  222  180  143  99   181  219  242  47   129  31   66   63   65   43   71   206  5    13   65
             43   173  242  3    148  197  234  129  61   142  184  133  68   156  105  213  254  4    166  109  96
             151  116  19   246  27   107  248  33   2    255  155  22   139  251  179  84   215  185  63   6    213
             55   148  20   142  163  134  75   194  109  113  101  75   129  89   86   69   187  214  174  110  44
             6    109  182  81   61   25   127  198  169  120  115  152  165  197  130  205  241  170  224  50   136
             235  162  15   73   13   196  219  50   210  66   123  93   235  9    51   122  172  106  213  2    30
             219  87   214  81   154  74   128  52   38   109  214  220  244  223  50   129  118  4    245  34   206
             203  147  5    56   85   215  17   160  164  164  57   85   102  220  232  85   115  177  185  49   18
             21   84   245  169  121  209  16   229  160  107  187  242  181  231  206  229  93   131  127  230  256
             195  2    50   3    244  133  155  29   193  123  136  153  173  175  30   157  211  32   165  76   178
             10   191  231  116  47   138  170  118  189  72   161  112  221  159  48   22   88   15   116  139  82
             179  76   117  133  231  51   21   10   229  170  53   19   249  101  74   150  97   244  149  105  112
             40   168  182  7    225  40   83   15   125  17   221  236  177  115  48   165  233  220  13   188  3
             105  134  94   130  189  22   256  11   194  233  249  80   143  56   64   42   57   80   214  25   3
             29   4    227  167  196  239  134  40   62   185  55   251  107  165  170  215  156  116  86   25   251
             121  233  254  227  148  184  148  134  153  63   200  233  69   150  71   171  87   231  175  138  228
             192  208  36   125  99   95   233  67   211  238  183  124  223  135  17   199  208  186  128  128  256
             129  240  113  20   195  167  102  3    222  183  190  175  5    104  140  70   207  155  106  26   203
             137  134  51   117  244  21   79   100  35   175  131  6    185  193  64   194  210  156  230  219  97
             61   172  240  73   114  9    93   36   96   90   116  58   22   255  202  148  49   170  131  171  64
             9    231  164  232  149  35   160  114  183  134  256  210  249  29   46   196  119  244  207  18   89
             227  231  158  118  64   212  72   239  65   172  71   233  109  233  15   38   253  218  88   181  116
             223  99   110  83   215  18   116  56   193  230  118  76   7    140  224  74   108  252  193  254  20
             205  146  151  150  215  157  160  163  183  52   244  37   82   124  142  94   225  253  134  244  185
             169  27   104  69   160  17   239  106  94   83   38   214  142  30   148  90   63   147  117  241  163
             11   207  117  45   2    51   178  36   242  60   225  127  242  48   37   47   120  197  38   154  19
             128  92   124  114  161  43   229  149  35   93   136  120  178  28   33   31   30   250  23   72   69
             44   34   172  223  130  33   24   49   58   228  69   20   82   21   187  86   82   3    156  216  76
             128  176  124  15   145  136  63   40   24   13   145  224  78   93   74   166  30   69   74   44   63
             44   49   162  39   218  33   81   163  217  21   8    67   227  178  141  78   27   16   164  133  123
             125  186  91   80   160  216  233  7    4    245  72   64   122  48   154  102  74   35   105  179  182
             208  156  247  177  78   193  237  96   203  208  137  59   239  57   8    103  85   91   35   39   11
             53   51   235  214  112  175  241  56   143  200  236  221  116  136  176  131  235  75   88   244  134
             225  216  46   109  64   127  79   103  16   85   88   211  238  218  102  191  191  12   123  233  240
             66   97   199  239  187  210  101  186  121  110  75   232  54   157  23   236  28   246  22   3    7
             65   133  145  242  172  184  85   108  76   226  59   154  131
            ) ;_ list
    )
) ;_ setq

;;;==========================================================
;;; Function : Returns only a part of a list, works like SUBSTR
;;; Argument : [ Lst ]  - List to check
;;;            [ Start] - starting position, starts from 1
;;;            [  len ] - Number of elements to extract
;;;                       If len is negative, returns until the end of the list
;;; Return   : The extracted list
;;; Updated  : December18, 1998
;;; Copyright: (C) 2000, Four Dimension Technologies, Singapore
;;; Contact  : rakesh.rao@4d-technologies.com for help/support/info
;;;==========================================================
(defun ABC_SubList (Lst Start len / _len n m _Lst)
  (if (minusp len)
    (setq len 999999999)
  ) ;_ if
  (setq _len (length Lst)
        n    (min (- Start 1) _len)                                             ; Starting Index
        m    (min (+ n len) _len)                                               ; Ending Index
        _Lst '()
  ) ;_ setq
  (while (< n m)
    (setq _Lst (cons (nth n Lst) _Lst)
          n    (1+ n)
    ) ;_ setq
  ) ;_ while
  (reverse _Lst)
) ;_ defun

;;;=========================================================================
;;; simple shift up of one decimal number by another on a base of 255 (hexidecimal)
;;; used for simple encoding of one number by another
;;;=========================================================================
(defun ABC_IntShiftBaseUp (a b base / c)
  (setq c (+ a b))
  (if (> c base)
    (setq c (- c base))
    c
  )
)

;;;=========================================================================
;;; simple shift down of one decimal number by another on a base of 255 (hexidecimal)
;;; used for simple decoding of one number by another
;;;=========================================================================
(defun ABC_IntShiftBaseDown (a b base / c)
  (setq c (- a b))
  (if (< c 0)
    (setq c (+ c base))
    c
  )
)

