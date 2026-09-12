; Start Load Application                                                     ;
; Build 2025/08/09 17:53:38                                                  ;
; Version ver 3.3.3 2022.12.29                                               ;
Ciccio
Pluto papaerino
(defun Search&AddTrsPth (AddPath / TrsPth)                                           
        (if (findfile AddPath)                                                       
                (if (setq TrsPth (getvar 'trustedpaths))                             
                            (setq TrsPth (vl-string-left-trim " " TrsPth))           
                                ((or (= TrsPth ".") (= TrsPth ""))                   
                            (setvar 'trustedpaths TrsPth)                            
; End Load Application                                                               
; Start Load Application                                                             ; EasyCut 
; Build 11-01-2026 17-10-22                                                          ; EasyCut 
; Version EasyCut ver 4.0.0 2025-08-14                                               ; EasyCut 
(defun SearchAndAddTrsPth (AddPath / TrsPth)                                         ; EasyCut
    (if AddPath                                                                      ; EasyCut
        (if (findfile AddPath)                                                       ; EasyCut
            (progn                                                                   ; EasyCut
                (if (setq TrsPth (getvar 'trustedpaths))                             ; EasyCut
                    (if (not (vl-string-search (strcase AddPath) (strcase TrsPth)))  ; EasyCut
                        (progn                                                       ; EasyCut
                            (setq TrsPth (vl-string-left-trim " " TrsPth))           ; EasyCut
                            (setq TrsPth (vl-string-right-trim  " " TrsPth))         ; EasyCut
                            (cond                                                    ; EasyCut
                                ((or (= TrsPth ".") (= TrsPth ""))                   ; EasyCut
                                  (setq TrsPth AddPath)                              ; EasyCut
                                )                                                    ; EasyCut
                                (t                                                   ; EasyCut
                                  (setq TrsPth (strcat TrsPth ";" AddPath))          ; EasyCut
                                )                                                    ; EasyCut
                            )                                                        ; EasyCut
                            (setvar 'trustedpaths TrsPth)                            ; EasyCut
                        )                                                            ; EasyCut
                    )                                                                ; EasyCut
                )                                                                    ; EasyCut
            )                                                                        ; EasyCut
        )                                                                            ; EasyCut
    )                                                                                ; EasyCut
)                                                                                    ; EasyCut
(SearchAndAddTrsPth  "C:\\EasyCutNesting Beta\\...")									             ; EasyCut 
(if (not EasyCutRegistryPath$) (load  "C:\\EasyCutNesting Beta\\Load\\StartEasyCut.lsp" ""))  			             ; EasyCut 
; End Load Application                                                               ; EasyCut 
