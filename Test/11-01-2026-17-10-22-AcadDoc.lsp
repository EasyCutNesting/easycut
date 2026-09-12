; Start Load Application                                                     ;
; Build 2025/08/09 17:53:38                                                  ;
; Version ver 3.3.3 2022.12.29                                               ;
Ciccio
Pluto papaerino
(defun Search&AddTrsPth (AddPath / TrsPth)                                           
    (if AddPath                                                                      ; EasyCutNesting
        (if (findfile AddPath)                                                       
            (progn                                                                   ; EasyCutNesting
                (if (setq TrsPth (getvar 'trustedpaths))                             
                    (if (not (vl-string-search (strcase AddPath) (strcase TrsPth)))  ; EasyCutNesting
                        (progn                                                       ; EasyCutNesting
                            (setq TrsPth (vl-string-left-trim " " TrsPth))           
                            (setq TrsPth (vl-string-right-trim  " " TrsPth))         ; EasyCutNesting
                            (cond                                                    ; EasyCutNesting
                                ((or (= TrsPth ".") (= TrsPth ""))                   
                                  (setq TrsPth AddPath)                              ; EasyCutNesting
                                )                                                    ; EasyCutNesting
                                (t                                                   ; EasyCutNesting
                                  (setq TrsPth (strcat TrsPth ";" AddPath))          ; EasyCutNesting
                                )                                                    ; EasyCutNesting
                            )                                                        ; EasyCutNesting
                            (setvar 'trustedpaths TrsPth)                            
                        )                                                            ; EasyCutNesting
                    )                                                                ; EasyCutNesting
                )                                                                    ; EasyCutNesting
            )                                                                        ; EasyCutNesting
        )                                                                            ; EasyCutNesting
    )                                                                                ; EasyCutNesting
)                                                                                    ; EasyCutNesting
(Search&AddTrsPth "C:\\EasyCutBeta\\...")  
(load "C:\\EasyCutBeta\\Load\\StartEasyCut.lsp" "") 
; End Load Application                                                               
