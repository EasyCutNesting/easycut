;;**************************************************************************
;; LECTURE FICHIERS XML
;;
;;**************************************************************************
;;**************************************************************************
;;§/xml/retourne le noeud par sélection par nom/xmlNod tagname
;;xmlnod = IXMLDOMNode
;;retourne soit nil, soit un IXMLDOMNode

(defun pw_xmlnode_getNodeByName (xmlnod tagname
                 / finit noeud chlnd res i nb)
(if (vlax-invoke-method xmlnod 'HasChildNodes)
(progn
(setq chlnd (vlax-get-property xmlnod 'childNodes))

(setq nb (vlax-get-property chlnd 'length))
(setq i 0)
(while (and (not finit) (< i nb))
    (setq noeud (vlax-get-property chlnd 'item i))
    (setq i (+ 1 i))
    (if (= (vlax-get-property noeud 'Basename) tagname) ;_Tagname sans le ss: ex : ss:Worksheet->Worksheet
     (setq finit T
        res noeud)
    )
)
)
)
res
)



;;**************************************************************************
;;§/xml/lit une cellule / cellnod
;;retourne '("val" idx)
;;val peut etre une chaine, ou nil ou un nombre
;;idx peut etre
;; - soit nil (cellules qui se suivent)
;; - soit un integer (cellules contennant des datas qui viennent après un série de celulles vides)
;; - soit un integre de valeur 256 (cellule vides qui est ajouté à chaque ligne, ne contient jamais de data)

(defun pw_xmlsReadOneCell ( cellnod / att sty typ txt )
(setq attcell (vlax-get-property cellnod 'Attributes))
(if (setq idx (vlax-invoke-method attcell 'getNamedItem "ss:Index"))
(setq tmp2 idx
     idx (vlax-get-property idx 'value)
     idx (vlax-variant-value idx))
)

(if (setq data (pw_xmlnode_getNodeByName cellnod "Data"))
(progn
(setq att (vlax-get-property data 'Attributes))
(setq sty (vlax-invoke-method att 'getNamedItem "ss:Type"))

(setq typ (vlax-get-property sty 'value))
(setq typ (vlax-variant-value typ))
;(print typ)
(setq txt (vlax-get-property data 'text))
;(print txt)
(list (pw_xmlVal2Type txt typ) idx)

)
)
)
;;**************************************************************************
;;§/xml/lit un attribut sélectionné par son nom / xmlnod attName
;;ss:Name

(defun pw_xmlsReadOneAtt ( xmlnod attName / atts att val )
(if (setq atts (vlax-get-property xmlnod 'Attributes))
(progn
(setq att (vlax-invoke-method atts 'getNamedItem attName))
(setq val (vlax-get-property att 'value))
(vlax-variant-value val)
)
)
)
;;**************************************************************************
;;§/xml/retourne un objet attribut par son nom/ xmlnod attName
;;ss:Name

(defun pw_xmlsgetOneAtt ( xmlnod attName / atts att )
(if (setq atts (vlax-get-property xmlnod 'Attributes))
(setq att (vlax-invoke-method atts 'getNamedItem attName))
)
)

;;**************************************************************************
;;§/xml/transforme la valeur texte xml en son type spécifié / val typ

(defun pw_xmlVal2Type ( val typ / )
(cond
((= typ "String")
val
)
((= typ "Number")
(read val)
)
)
)

;;**************************************************************************
;;§/xml/lit toutes les cellules, comme pw_charger_ini/tblnod

(defun pw_xmlsReadAllCells (tblnod / lres i)
(setq i 0)
(setq lrow (pw_xmlsListAllRow tblnod))
(foreach row lrow
;;(print i)
(if (setq lcell (pw_xmlsListAllCell row))
(progn
    (setq lcell (mapcar 'pw_xmlsReadOneCell lcell))
    ;;(setq lcell (pw_supp_all 'nil lcell))
    (setq lcell (pw_xmlTrtLvalCell lcell))
    (setq lcell (mapcar 'pw_nil_t lcell))
    (if (not (and (PW_EGAL_LIST lcell)
         (member "" lcell)
         )
     ) ;_c'est une ligne vide dans le fichier xml
     (setq lres (cons lcell lres))
    )
)
)

(setq i (+ 1 i))
)
(reverse lres)
)


;;**************************************************************************
;;§/xml/traite la liste des valeurs de celulle lues, en fonction de la valeurs index /lvalcell
;;lvacell '((idx1 lvalcell1) ... (idxn lvalcelln)

(defun pw_xmlTrtLvalCell (lvalcell / cnt lres id val)
(setq cnt 1)
(foreach l lvalcell
(setq val (car l)
     id (cadr l))
(cond ((= nil id);_cette celulle est la 1ère ou suit les autres
     (setq lres (cons val lres))
     (setq cnt (+ 1 cnt))
     )
     ((and (= 256 id)(not val));_cette celulle est la dernière et ne contient pas de données
     nil
     )
     ((numberp (setq id (pw_to_type id)));_cette celulle est une celulle contennat une valeur, après une série de celulles vides
     (setq nb (- id cnt))
     (repeat nb (setq lres (cons "" lres)))
     (setq lres (cons val lres))
     (setq cnt (+ 1 id))
     )
     )
    
)
(reverse lres)

)

;;**************************************************************************
;;§/xml/liste de toutes les childs d'une noaud ayant le nom childname / Nod childname

(defun pw_xmlsListAllChildsByname ( Nod childname / lrow i noeud nb)

(if (vlax-invoke-method Nod 'HasChildNodes)
(progn
(setq chlnd (vlax-get-property Nod 'childNodes))

(setq nb (vlax-get-property chlnd 'length))
(setq i 0)
(while (< i nb)
    (setq noeud (vlax-get-property chlnd 'item i))
    (setq i (+ 1 i))
    (if (= (vlax-get-property noeud 'Basename) childname)
     (setq lrow (cons noeud lrow))
    )
)
)
)
(reverse lrow)
)
;;**************************************************************************
;;§/xml/liste de toutes les row d'une table / tablenod

(defun pw_xmlsListAllRow ( tablenod / lrow i nb)

(if (vlax-invoke-method tablenod 'HasChildNodes)
(progn
(setq chlnd (vlax-get-property tablenod 'childNodes))

(setq nb (vlax-get-property chlnd 'length))
(setq i 0)
(while (< i nb)
    (setq noeud (vlax-get-property chlnd 'item i))
    (setq i (+ 1 i))
    (if (= (vlax-get-property noeud 'Basename) "Row")
     (setq lrow (cons noeud lrow))
    )
)
)
)
(reverse lrow)
)

;;**************************************************************************
;;§/xml/liste de toutes les cell d'une row / rownod

(defun pw_xmlsListAllCell ( rownod / lcell noeud i nb)

(if (vlax-invoke-method rownod 'HasChildNodes)
(progn
(setq chlnd (vlax-get-property rownod 'childNodes))

(setq nb (vlax-get-property chlnd 'length))
(setq i 0)
(while (< i nb)
    (setq noeud (vlax-get-property chlnd 'item i))
    (setq i (+ 1 i))
    (if (= (vlax-get-property noeud 'Basename) "Cell")
     (setq lcell (cons noeud lcell))
    )
)
)
)
(reverse lcell)
)
;**************************************************************************
;;§/xml/liste de toutes les eléments d'une collection / collec

(defun pw_xmlCollec->List (collec / lcell noeud i nb)

(if collec
(progn
(setq nb (vlax-get-property collec 'length))
(setq i 0)
(while (< i nb)
    (setq noeud (vlax-get-property collec 'item i))
    (setq i (+ 1 i))
    (setq lcell (cons noeud lcell))
)

(reverse lcell)
)
)
)
;;*******************************************************************************
;;§/xml/liste de toutes les noeud child d'un noeud père par nom / fathNod NodName

(defun pw_xmlsListNodeByName ( fathNod NodName / lcell noeud chlnd nb i )

(if (vlax-invoke-method fathNod 'HasChildNodes)
(progn
(setq chlnd (vlax-get-property fathNod 'childNodes))

(setq nb (vlax-get-property chlnd 'length))
(setq i 0)
(while (< i nb)
    (setq noeud (vlax-get-property chlnd 'item i))
    (setq i (+ 1 i))
    (if (= (vlax-get-property noeud 'Basename) NodName)
     (setq lcell (cons noeud lcell))
    )
)
)
)
(reverse lcell)
)
;;*******************************************************************************
;;§/xml/liste de toutes les noeud child d'un noeud père / fathNod

(defun pw_xmlListChildNodes ( fathNod / chlnd )

(if (vlax-invoke-method fathNod 'HasChildNodes)
(progn
(setq chlnd (vlax-get-property fathNod 'childNodes))
(pw_xmlCollec->List chlnd)
)
)
)
;;*******************************************************************************
;;§/xml/liste de toutes les attributs d'un noeud père / fathNod

(defun pw_xmlListAttributes ( fathNod / chlnd )

(setq chlnd (vlax-get-property fathNod 'attributes))
(pw_xmlCollec->List chlnd)

)
;;*******************************************************************************
;;§/xml/exploration récursive d'un noeud père / fathNod

(defun explorxmldom ( fathNod level / noeud chlnd lnod lat)
(setq lat (pw_xmlListAttributes fathNod))
(foreach att lat
;----------------> (repeat (* 2 level) (princ " "))
;----------------> (princ "Attribut :")
;----------------> (princ "\n")
;----------------> (repeat (* 2 level) (princ " "))
;;(princ (vlax-get-property att 'Basename))
;;nodeName
;----------------> (princ (vlax-get-property att 'nodeName))
;----------------> (princ " Tp:")
;----------------> (princ (vlax-get-property att 'nodeType))
;----------------> (princ "\n")
)
(setq lnod (pw_xmlListChildNodes fathNod))
(foreach noeud lnod
;----------------> (repeat (* 2 level) (princ "-"))
;----------------> (princ "Noeud :")
;----------------> (princ "\n")
;----------------> (repeat (* 2 level) (princ " "))
;----------------> (princ (vlax-get-property noeud 'Basename))
;----------------> (princ " Tp:")
;----------------> (princ (vlax-get-property noeud 'nodeType))
;----------------> (princ "\n")
;----------------> (princ " URL")
;----------------> (princ (vlax-get-property noeud 'namespaceURI))
;----------------> (princ "\n")
(explorxmldom noeud (+ 1 level))
)
)

;;**************************************************************************
;;§/xml/libère le fichier xml après une erreur/none
(defun c:freexml ()
(vlax-release-object xmldoc)
(setq xmldoc nil)
(vlax-release-object pw-xmldoc)
(setq pw-xmldoc nil)
)
;;**************************************************************************
;;§/xml/charge un fichier xml dans le but de l'explorer et d'afficher sa structure à l'écran /none

;;
(defun c:xmlExplore ( / doc )
;(setq   fichier (getfiled "Fichier xml à explorer, extension quelconque : "
;         ""
;         "xml"
;         4
;     )
;)
(setq xmldoc (vlax-create-object "MSXML2.DOMDocument"))
(vlax-invoke-method
    xmldoc
    'load
    ;fichier
	"c:\\EasyCut\\test\\test01.xml"
)
(prompt "\nExplorer xmldoc")
;;currNode = xmlDoc.documentElement.firstChild;
(setq doc (vlax-get-property xmlDoc 'documentElement))
;;(setq 1st (vlax-get-property doc 'firstChild))
;(princ "-")
;(princ "Noeud :")
;(princ "\n")
;(princ " ")
;(princ (vlax-get-property doc 'Basename))
;(princ " Tp:")
;(princ (vlax-get-property doc 'nodeType))
;(princ "\n")
;(princ " URL")
;(princ (vlax-get-property doc 'namespaceURI))
;(princ "\n")
(explorxmldom doc 1)
;(princ)
)
;
;
;
;
(defun vk_XMLGetAttributes (Node / Attributes Attribute OutList)
  (if (setq Attributes (vlax-get Node "attributes"))
    (progn (while (setq Attribute (vlax-invoke Attributes "nextNode"))
    (setq OutList (cons (cons (vlax-get Attribute "nodeName")
      (vlax-get Attribute "nodeValue")
)
OutList
  )
    )
    (vlax-release-object Attribute)
  )
  (vlax-release-object Attributes)
  (reverse OutList)
    )
  )
)
;;;(vk_XMLGetAttributes Node)
(defun vk_XMLGetchildNodes (Node /)
  (if Node
    (if	(= (vlax-get Node "nodeType") 3)
      (vlax-get Node "nodeValue")
      (cons (list (vlax-get Node "nodeName")
                  (vk_XMLGetAttributes Node)
                  (vk_XMLGetchildNodes (vlax-get Node "firstChild"))
            )
            (vk_XMLGetchildNodes (vlax-get Node "nextSibling"))
      )
    )
  )
)
;;;(vk_XMLGetchildNodes Node)
(defun vk_ReadXML (FileName / Doc OutList *error*)
  (if (and FileName
;;;	  (setq FileName (findfile FileName))
  (setq Doc (vlax-create-object "MSXML.DOMDocument"))
  (not (vlax-put Doc "async" 0))
  (if (= (vlax-invoke Doc "load" FileName) -1)
    t
    (prompt
      (strcat "\nError: "
      (vlax-get (vlax-get Doc "parseError") "reason")
      )
    )
  )
  (= (vlax-get Doc "readyState") 4)
      )
    (setq OutList (vk_XMLGetchildNodes (vlax-get Doc "firstChild")))
  )
  (and Doc (vlax-release-object Doc))
  (gc)
  OutList
)
;;; starte mi
;(princ " (vk_ReadXML (getfiled \"\" \"\" \"xml\" 16))")
;(defun c:GoR ()
;	(setq LstData (vk_ReadXML "C:\\Users\\ut04\\Desktop\\Tmp\\EasyCutBeta_20220627_2252\\NewApp\\NestingBars\\job.xml"))
;)
