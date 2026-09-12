/* --------------------------------=  */
ok_mybutton : retirement_button {
        label           = "  OK  ";
        key             = "accept";
        is_default      = true;
}
cancel_mybutton : retirement_button {
        label           = "Cancel";
        key             = "cancel";
        is_cancel       = true;
}
exit_mybutton : retirement_button {
        label           = "Esci";
        key             = "cancel";
        is_cancel       = true;
}
new_mybutton : retirement_button {
        label           = "Nuova";
        key             = "new";
        is_cancel       = true;
}
return_mybutton : retirement_button {
        label           = "<------";
        key             = "return";
        is_cancel       = true;
}
apply_mybutton : retirement_button {
        label           = "Applica";
        key             = "apply";
        is_cancel       = true;
}
zoom_mybutton : retirement_button {
        label           = "Zoom";
        key             = "zoom";
        is_cancel       = true;
}
exit_apply_zoom_new : column {
    : row {
        fixed_width = true;
        alignment = centered;
		exit_mybutton;
		: spacer { width = 2; }
        apply_mybutton;
        : spacer { width = 2; }
        zoom_mybutton;
        : spacer { width = 2; }
        new_mybutton;
    }
}
ok_cancel_return : column {
    : row {
        fixed_width = true;
        alignment = centered;
        ok_mybutton;
        : spacer { width = 2; }
        cancel_mybutton;
        : spacer { width = 2; }
        return_mybutton;
    }
}
cancel_apply : column {
    : row {
        fixed_width = true;
        alignment = centered;
        cancel_mybutton;
        : spacer { width = 2; }
        apply_mybutton;
    }
}
exit_apply : column {
    : row {
        fixed_width = true;
        alignment = centered;
        exit_mybutton;
        : spacer { width = 2; }
        apply_mybutton;
    }
}
only_exit : column {
    : row {
        fixed_width = true;
        alignment = centered;
        exit_mybutton;
    }
}

/* ----------------------------------------------- */
ArrayCopy:dialog 
{
    label="Copia Serie";
	:boxed_row {
		label="Dati";
		:text     {edit_width=30; fixed_width=true; label="Numero colonne";}
		:edit_box {edit_width=5; fixed_width=true; key="NumberColumn";}    
		:text     {edit_width=30; fixed_width=true; label="Numero righe";}	
		:edit_box {edit_width=5; fixed_width=true; key="NumberRow";}
	}	
	:boxed_column {
		label="Schema";
		:row {
			:image_button {
				key = "schema2";
				width = 29;
				height =13;
				color = 0;
				fixed_width = true;
				fixed_height = true;
			}
			:image_button {
				key = "schema1";
				width = 29;
				height =13;
				color = 0;
				fixed_width = true;
				fixed_height = true;
			}
		}
		:row {
			:image_button {
				key = "schema3";
				width = 29;
				height =13;
				color = 0;
				fixed_width = true;
				fixed_height = true;
			}
			:image_button  {
				key = "schema4";
				width = 29;
				height =13;
				color = 0;
				fixed_width = true;
				fixed_height = true;
			}
		}
	}
    only_exit; 
}


