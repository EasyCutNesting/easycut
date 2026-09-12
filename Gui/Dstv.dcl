/* ---------------------------------------------------- */
move_mybutton : button {
        label           = "Sposta";
        key             = "move";
        /* is_cancel       = true; */
}
move_all_mybutton : button {
        label           = "Tutto";
        key             = "move_all";
        /* is_cancel       = true; */
}
remove_mybutton : button {
        label           = "Rimuovi";
        key             = "remove";
        /* is_cancel       = true; */
}
empty_mybutton : button {
        label           = "Svuota";
        key             = "empty";
        /* is_cancel       = true; */
}
move_moveall : column {
    : row {
        fixed_width = true;
        alignment = centered;
        move_mybutton;
        : spacer { width = 2; }
        move_all_mybutton;
    }
}
remove_removeall : column {
    : row {
        fixed_width = true;
        alignment = centered;
        remove_mybutton;
        : spacer { width = 2; }
        empty_mybutton;
    }
}
//-------------------------------------------
FilterList:dialog 
 {
	key="title";
	label="";
    :row { 
        :button   {label="Ident";    key="Ident";     width=20;}
		:edit_box {width=60;         key="BoolIdent";} 
 	} 
    :row { 
        :button   {label="Commessa"; key="Order";     width=20;}
		:edit_box {width=60;         key="BoolOrder";} 
 	}  
    :row { 
        :button   {label="Fase";     key="Phase";     width=20;}
		:edit_box {width=60;         key="BoolPhase";} 
 	}  
    :row { 
        :button   {label="Nome";     key="Name";      width=20;}
		:edit_box {width=60;         key="BoolName";} 
 	}  
    :row { 
        :button   {label="Quantita'"; key="Quantity"; width=20;}
		:edit_box {width=60;          key="BoolQuantity";} 
 	}  
    :row { 
        :button   {label="Spessore"; key="Thickness"; width=20;}
		:edit_box {width=60;         key="BoolThicknes";} 
 	}  
    :row { 
        :button   {label="Lunghezza"; key="Length";   width=20;}
		:edit_box {width=60;          key="BoolLength";} 
 	}  
    :row { 
        :button   {label="Larghezza"; key="Width";	  width=20;}
		:edit_box {width=60;          key="BoolWidth";} 
 	}  
    :row { 
        :button   {label="Materiale"; key="Material"; width=20;}
		:edit_box {width=60;          key="BoolMaterial";} 
 	}  
	ok_only;
}  
//--------------------------------------------	
handle_folder_list:dialog 
 {
	key="title";
	label="";
   /* label="Gestione Fasi"; */ 
    :row { 
		:edit_box {
                 label="Directory";
                 key="Dir";
		} 
        : button
        {
			key   = "Brw";
			label = "Browse";
			fixed_width = true;
        }
		
	}  
   :row {
		:boxed_column {
		
			:list_box 	{
							label="Lista Directory";
							key="BoxFolders";
							/* tabs="5 35 70"; */
							width=50;
							/* is_default= true; */ 
							/* allow_accept = true; */
							/* multiple_select = true; */
			}   
		}
		:boxed_column {
		
			:list_box {
						label="Lista File";
						key="BoxFiles";
		                /* tabs="5 35 70"; */
						width=50;
						/* multiple_select = true; */
			}    
		}     
	}
    :row { 
		:edit_box {
                 label="File";
                 key="FileOut";
		} 
	}  

	ok_cancel;
}     

