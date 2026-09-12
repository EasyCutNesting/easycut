/* dialogo UNINSTALLEASYCUT <--------------------------------=  */
Viewer:dialog 
	{
		label="Viewer EasyCut";
		:list_box {
				key = "Registry";
				width = 125.0;
                height = 40.0;
                fixed_width = true;
                fixed_height = true;
				tabs = "20 70";
			}
		ok_only;
}		
/* dialogo UNINSTALLEASYCUT <--------------------------------=  */
UnInstallEasyCutX:dialog 
	{
		label="UnInstall EasyCut";
		:boxed_column {label="Registry"; 
			:row {
				width=95;    fixed_width=true;
				:text_part {width=21;  fixed_width=true; label=" Nome"; }
				:text_part {width=50;  fixed_width=true; label="Valore";}
				:text_part {width=24;  fixed_width=true; label="Stato"; }
			}
			:list_box {
				
				key = "Registry";
				width = 95.0;
                height = 20.0;
                fixed_width = true;
                fixed_height = true;
				tabs = "20 70";
			}
			:row {
					:text	{width=15;    fixed_width=true; label="AcadDoc";}
					:text	{width=90;    fixed_width=true; key="AcadDocControl";}
					:spacer {width=5;     fixed_width=true;}
					:image 	{width=2.75;  fixed_width=true; key="ChkAcadDoc"; fixed_height = true; aspect_ratio = 1.0; color = -15;}
			 }
			:row {
					:text	{width=15;    fixed_width=true; label="Trustedpaths";}
					:text	{width=90;    fixed_width=true; key="TrustedpathsControl";}
					:spacer {width=5;     fixed_width=true;}
					:image 	{width=2.75;  fixed_width=true; key="ChkTrustedpaths"; fixed_height = true; aspect_ratio = 1.0; color = -15;}
			 }
			:row {
					:text	{width=15;   fixed_width=true; label="EasyCut Folder";}
					:text 	{width=90;   fixed_width=true; key="FolderEasyCutControl";}
					:spacer {width=5;    fixed_width=true;}
					:image 	{width=2.75; fixed_width=true; key="EasyCutFolderChk3";  fixed_height = true; aspect_ratio = 1.0; color = -15;}
				 }
		}		
		uninstall_exit;
}
/* dialogo INSTALLEASYCUT <--------------------------------=  */
InstallEasyCutX:dialog 
	{
		label="Install EasyCut";
		:boxed_column {
			:row {
					:text	{width=15;   fixed_width=true; label="Registri"; key="Fase1";}
					:text	{width=100;  fixed_width=true; label="Controllo registri"; key="RegistryControl";}
					:spacer {width=5;    fixed_width=true;}
					:image 	{width=2.75; fixed_width=true; key="Chk1";  fixed_height = true; aspect_ratio = 1.0; color = -15;}
				 }
			:row {
					:text	{width=15;   fixed_width=true; label="AcadDoc"; key="Fase2";}
					:text	{width=100;  fixed_width=true; label="Controllo AcadDoc"; key="AcadDocControl";}
					:spacer {width=5;    fixed_width=true;}
					:image 	{width=2.75; fixed_width=true; key="Chk2"; fixed_height = true; aspect_ratio = 1.0; color = -15;}
				 }
			:row {
					:text	{width=15;   fixed_width=true; label="EasyCut Folder"; key="Fase3";}
					:text 	{width=100;  fixed_width=true; key="FolderEasyCut";}
					:button {width=5;    fixed_width=true; label="..."; key="ButtonFolder";}
					:image 	{width=2.75; fixed_width=true; key="Chk3";  fixed_height = true; aspect_ratio = 1.0; color = -15;}
				 }
		}		
		install_exit;
}
/* dialogo NESTING <--------------------------------=  */
mainmenu:dialog {
	label="Menu' generale ";
	width=45;
    :text{key="Version";}
	:column {
		:boxed_column {                    
			label="Setup";
			:row {
				:popup_list {key = "PopupSetup"; value = "0"; tabs = "4";}
				:button {width=5; fixed_width = true; label="->"; key="AttachSetup";}
			}
		}
		:boxed_column {                    
			label="Import-Export";
			:row {
				:popup_list {key = "PopupImport"; value = "0" ; tabs = "4";}
				:button {width=5; fixed_width = true; label="->"; key="AttachImport";}
			}
			:row {
				:popup_list {key = "PopupSql"; value = "0";	tabs = "4";}
				:button {width=5; fixed_width = true; label="->"; key="AttachSql";}
			}
		}
		:boxed_column {                    
			label="Ricerca";
			:row {
				:popup_list {key = "PopupSearch"; value = "0"; tabs = "4";}
				:button {width=5; fixed_width = true; label="->"; key="AttachSearch";}
			}
		}	
		:boxed_column {                    
			label="Contorno";
			:row {
				:popup_list {key = "PopupSAndS"; value = "0"; tabs = "4";}
				:button {width=5; fixed_width = true; label="->"; key="AttachSAndS";}
			}
		}
		:boxed_column {                    
			label="Attacchi";
			:row {
				:popup_list {key = "PopupTrigger"; value = "0";	tabs = "4";}
				:button {width=5; fixed_width = true; label="->"; key="AttachTrigger";}
			}
		}
		:boxed_column {                    
			label="Utensili";
			:row {
				:popup_list {key = "PopupTools"; value = "0"; tabs = "4";}
				:button {width=5; fixed_width = true; label="->"; key="AttachTools";}
			}
		}
		:boxed_column {                    
			label="Taglio";
			:row {
				:popup_list {key = "PopupNestingExpert"; value = "0"; tabs = "4";}
				:button {width=5; fixed_width = true; label="->"; key="AttachNestingExpert";}
			}
			:row {
				:popup_list {key = "PopupNestingSimple"; value = "0"; tabs = "4";}
				:button {width=5; fixed_width = true; label="->"; key="AttachNestingSimple";}
			}
			:row {
				:popup_list {key = "PopupNestingBar"; value = "0"; tabs = "4";}
				:button {width=5; fixed_width = true; label="->"; key="AttachNestingBar";}
			}
			:row {
				:popup_list {key = "PopupNestingTools"; value = "0"; tabs = "4";}
				:button {width=5; fixed_width = true; label="->"; key="AttachNestingTools";}
			}
			:row {
				:popup_list {key = "PopupReport"; value = "0"; tabs = "4";}
				:button {width=5; fixed_width = true; label="->"; key="AttachReport";}
			}
		}  
		:boxed_column {                    
			label="Procedure";
			:row {
				:popup_list {key = "PopupApp"; value = "0" ; tabs = "4";}
				:button {width=5; fixed_width = true; label="->"; key="AttachApp";}
			}
		}  
	}
	ok_only;
}
/* dialogo EDIT_BOXT <--------------------------------=  */
edit_boxt:dialog
 {
    label="info xml file";
	width = 80;
	fixed_width = true;
	:row {
		:text{edit_width=50; key="LabelText1";}
	}
	:row {
		:text{edit_width=50; key="LabelText2";}
	}
	:row {
		:edit_box {edit_width=60; fixed_width = true;  key="LabelBox1"; }
		:edit_box {edit_width=20; fixed_width = true;  key="LabelBox2"; }
	}
	ok_only;
}
/* dialogo EXPERT NESTING <--------------------------------=  */
nestprofessor:dialog 
	{
		label="Expert Nesting";
		:boxed_column {
			:row {
					:text{edit_width=35; label="Step 1";}
					:button {
								width=20;
								fixed_width = true;
								label="Easy->Nest";
								key="Easy2Nest";
								is_default=true;
							}
				 }
			:row {
					:text{edit_width=35; label="Step 2";}
					:button {
								width=20;
								fixed_width = true;
								label="DxfImport";
								key="ImportDxfNest";
								is_default=true;
							}
				 }
			:row {
					:text{edit_width=35; label="Step 3";}
					:button {
								width=20;
								fixed_width = true;
								label="Nest->Easy";
								key="Nest2Easy";
								is_default=true;
							}
				 }
		}		
		ok_only;
}
/* dialogo INFO_LAM <--------------------------------=  */
info_lam:dialog 
 {
    label="Dati Lamiera";
	:boxed_column {
		:row {
			:text{edit_width=35; label="Id Lamiera";}
			:edit_box {edit_width=25; fixed_width = true;  key="idsheet"; }               
		}
		:row {
			:text{edit_width=35; label="Nome Lamiera";}
			:edit_box {edit_width=25; fixed_width = true;  key="namesheet"; }               
		}
		:row {
			:text{label="";}
		}
	}
	:boxed_column {
		:row {
			:text{edit_width=35; label="Larghezza Lamiera [mm]";}
			:edit_box {edit_width=25; fixed_width = true;  key="widthsheet"; }               
		}
		:row {
			:text{edit_width=35; label="Altezza Lamiera [mm]";}
			:edit_box {edit_width=25; fixed_width = true;  key="heightsheet"; }               
		}
		:row {
			:text{edit_width=35; label="Spessore Lamiera [mm]";}
			:edit_box {edit_width=25; fixed_width = true;  key="thicksheet"; }               
		}
		:row {
			:text{edit_width=35; label="Qualità Lamiera [kg]";}
			:edit_box {edit_width=25; fixed_width = true;  key="matsheet"; }               
		}
		:row {
			:text{edit_width=35; label="Superficie Lamiera [mq]";}
			:edit_box {edit_width=25; fixed_width = true;  key="surfacesheet"; }               
		}
		:row {
			:text{edit_width=35; label="Peso Lamiera [kg]";}
			:edit_box {edit_width=25; fixed_width = true;  key="weightsheet"; }               
		}
		:row {
			:text{label="";}
		}
	}
	ok_cancel;
}
/* dialogo GeoSheet <--------------------------------=  */
GeoSheet:dialog 
 {
    label="Dati Lamiera";
	:boxed_column {
		:row {
			:text{edit_width=35; label="Id Lamiera";}
			:edit_box {edit_width=25; fixed_width = true;  key="idsheet"; }               
		}
		:row {
			:text{edit_width=35; label="Nome Lamiera";}
			:edit_box {edit_width=25; fixed_width = true;  key="namesheet"; }               
		}
		:row {
			:text{label="";}
		}
	}
	:boxed_column {
		:row {
			:text{edit_width=35; label="Larghezza Lamiera [mm]";}
			:edit_box {edit_width=25; fixed_width = true;  key="widthsheet"; }               
		}
		:row {
			:text{edit_width=35; label="Altezza Lamiera [mm]";}
			:edit_box {edit_width=25; fixed_width = true;  key="heightsheet"; }               
		}
		:row {
			:text{edit_width=35; label="Spessore Lamiera [mm]";}
			:edit_box {edit_width=25; fixed_width = true;  key="thicksheet"; }               
		}
		:row {
			:text{edit_width=35; label="Qualità Lamiera [kg]";}
			:edit_box {edit_width=25; fixed_width = true;  key="matsheet"; }               
		}
		:row {
			:text{edit_width=35; label="Superficie Lamiera [mq]";}
			:edit_box {edit_width=25; fixed_width = true;  key="surfacesheet"; }               
		}
		:row {
			:text{edit_width=35; label="Peso Lamiera [kg]";}
			:edit_box {edit_width=25; fixed_width = true;  key="weightsheet"; }               
		}
		:row {
			:text{label="";}
		}
	}
	exit_apply_select;
}
/* dialogo NEW_LAM <--------------------------------=  */
new_lam:dialog 
 {
    label="Dati Lamiera";
    :boxed_column {
		:row {
			:text{edit_width=35; label="Id Lamiera";}
			:edit_box {edit_width=25; fixed_width = true;  key="idsheet"; }               
		}
		:row {
			:text{edit_width=35; label="Nome Lamiera";}
			:edit_box {edit_width=25; fixed_width = true;  key="namesheet"; }               
		}
		:row {
			:text{label="";}
		}
	}
    :boxed_column {
		label="Geometria";
		:row {
			:text{edit_width=35; label="Larghezza Lamiera";}
			:edit_box {edit_width=25; fixed_width = true;  key="widthsheet"; }               
		}
		:row {
			:text{edit_width=35; label="Altezza Lamiera";}
			:edit_box {edit_width=25; fixed_width = true;  key="heightsheet"; }               
		}
		:row {
			:text{edit_width=35; label="Spessore Lamiera";}
			:edit_box {edit_width=25; fixed_width = true;  key="thicksheet"; }               
		}
		:row {
			:text{edit_width=35; label="Qualità Lamiera";}
			:edit_box {edit_width=25; fixed_width = true;  key="matsheet"; }               
		}
		:row {
			:text{label="";}
		}
	}
    ok_cancel;
}
/* dialogo STOCK_LAM <--------------------------------=  */
stock_lam:dialog 
 {
    label="Dati Stock Lamiere";
    :boxed_column {
		width=36;
		fixed_width = true;
		:row {
			:text{edit_width=20; label="Nome Stock";}
			:edit_box {edit_width=10; fixed_width = true;  key="namesheet"; }               
		}
		:row {
			:text{label="";}
		}
	}
	:row {
		:boxed_column {
			width=30;
			fixed_width = true;
			label="Geometria";
			:row {
				:text{edit_width=20; label="Larghezza Lamiera";}
				:edit_box {edit_width=10; fixed_width = true;  key="widthsheet"; }               
			}
			:row {
				:text{edit_width=20; label="Altezza Lamiera";}
				:edit_box {edit_width=10; fixed_width = true;  key="heightsheet"; }               
			}
			:row {
				:text{edit_width=20; label="Spessore Lamiera";}
				:edit_box {edit_width=10; fixed_width = true;  key="thicksheet"; }               
			}
			:row {
				:text{edit_width=20; label="Quantità Lamiere";}
				:edit_box {edit_width=10; fixed_width = true;  key="qtasheet"; }               
			}
			:row {
				:text{edit_width=20; label="Qualità Lamiera";}
				:edit_box {edit_width=10; fixed_width = true;  key="matsheet"; }               
			}
			/* :row {
				:text{label="";}
			} */ 
			: button {
				width=35;
				fixed_width = true;
   				key =   "addstock";
				label = "Aggiungi Stock ----->"; 
			}
		}
		:boxed_column {
			label="lista lamiere";
			width=80;
			:list_box {
					key="box_label";
					// width=110;
					height=2;
					tabs = "16 28 40 52 64 76";
					list = "Stock\tLarghezza\tAltezza\tSpessore\tQuantità\tQualità";
			}

			:list_box {
                   key="box_info";
                   /* width=25;
                   height=13; */
				   tabs = "16 28 40 52 64 76";
                   list="";
			}               
		}
	}
	exit_createstock_removestock;
	//ok_cancel;
}
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
modified_mybutton : retirement_button {
        label           = "Modifica";
        key             = "modified";
        // is_cancel       = true;
}
save_mybutton : retirement_button {
        label           = "Salva";
        key             = "save";
        is_cancel       = true;
}
save1_mybutton : retirement_button {
        label           = "Salva";
        key             = "save";
        // is_cancel       = true;
}
saveAS_mybutton : retirement_button {
        label           = "Salva...";
        key             = "saveAS";
        is_cancel       = true;
}
load_mybutton : retirement_button {
        label           = "Carica";
        key             = "load";
        is_cancel       = true;
}
new_mybutton : retirement_button {
        label           = "Nuova";
        key             = "new";
        is_cancel       = true;
}
select_mybutton : retirement_button {
        label           = "Seleziona";
        key             = "select";
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
createstock_mybutton : retirement_button {
        label           = "Crea Stock";
        key             = "createstock";
        is_cancel       = true;
}
removestock_mybutton : retirement_button {
        label           = "Rimuovi Stock";
        key             = "removestock";
}
createstock1_mybutton : retirement_button {
        label           = "Crea Stock";
        key             = "createstock";
}
excel_mybutton : retirement_button {
        label           = "Excel";
        key             = "excel";
        /* is_cancel       = true; */
}
update_mybutton : retirement_button {
        label           = "Aggiorna Lista";
        key             = "update";
        /* is_cancel       = true; */
}
addfile_mybutton : retirement_button {
        label           = "Aggiungi Dxf";
        key             = "addfile";
        /* is_cancel       = true; */
}
delete_mybutton : retirement_button {
        label           = "Elimina";
        key             = "delete";
        is_cancel       = true;
}
nesting : retirement_button {
        label           = "Nesting";
        key             = "nesting";
        is_cancel       = true;
}
loadvalue_mybutton : retirement_button {
        label           = "Carica dati default";
        key             = "loaddefault";
}
filter_mybutton : retirement_button {
        label = "Filtro";
        key   = "filter";
}
install_mybutton : retirement_button {
        label = "Installa EasyCut";
        key   = "Install";
}
uninstall_mybutton : retirement_button {
        label = "Rimuovi EasyCut";
        key   = "uninstall";
}

calc_mybutton : retirement_button {
									label           = "Calcola";
									key             = "calc";
									//is_cancel       = true;
}
selectall_mybutton : retirement_button {
										label           = "Seleziona tutto";
										key             = "selectall";
										/* is_cancel       = true; */
}
show_mybutton : retirement_button {
										label           = "Show";
										key             = "show";
										/* is_cancel       = true; */
}
list_mybutton : retirement_button {
										label           = "List";
										key             = "list";
										/* is_cancel       = true; */
}
import_mybutton: retirement_button {
										label           = "Importa";
										key             = "import";
										/* is_cancel       = true; */
}
report_mybutton: retirement_button {
										label           = "Report";
										key             = "report";
										/* is_cancel       = true; */
}
search_mybutton: retirement_button {
										label           = "Search";
										key             = "search";
}
output_mybutton: retirement_button {
										label           = "Go to Output";
										key             = "output";
}
testbrowser_mybutton: retirement_button {
										label           = "Test Browser";
										key             = "testbrowser";
}
search : column {
    : row {
        fixed_width = true;
        alignment = centered;
		search_mybutton;
    }
}
excel_update_addfile_ok_cancel : column {

    : row {
        fixed_width = true;
        alignment = centered;
		excel_mybutton;
		: spacer { width = 2; }
		update_mybutton;
		: spacer { width = 2; }
		addfile_mybutton;
		: spacer { width = 2; }
		ok_mybutton;
		: spacer { width = 2; }
		exit_mybutton;
    }
}
nesting_exit : column {
    : row {
        fixed_width = true;
        alignment = centered;
		nesting;
		: spacer { width = 2; }
        exit_mybutton;
    }
}
install_exit : column {
    : row {
        fixed_width = true;
        alignment = centered;
		install_mybutton;
		: spacer { width = 2; }
        exit_mybutton;
    }
}
uninstall_exit : column {
    : row {
        fixed_width = true;
        alignment = centered;
		uninstall_mybutton;
		: spacer { width = 2; }
        exit_mybutton;
    }
}
exit_createstock_removestock : column {
    : row {
        fixed_width = true;
        alignment = centered;
		exit_mybutton;
		: spacer { width = 2; }
        createstock_mybutton;
		: spacer { width = 2; }
        removestock_mybutton;
    }
}
exit_createstock1 : column {
    : row {
        fixed_width = true;
        alignment = centered;
		exit_mybutton;
		: spacer { width = 2; }
        createstock1_mybutton;
    }
}
ok_save_exit : column {
    : row {
        fixed_width = true;
        alignment = centered;
		ok_mybutton;
		: spacer { width = 2; }
        save_mybutton;
		: spacer { width = 2; }
		exit_mybutton;
    }
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
cancel_only : column {
    : row {
        fixed_width = true;
        alignment = centered;
        cancel_mybutton;
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
ok_cancel_output_report : column {
    : row {
        fixed_width = true;
        alignment = centered;
        ok_mybutton;
        : spacer { width = 2; }
        cancel_mybutton;
        : spacer { width = 2; }
        output_mybutton;
		: spacer { width = 2; }
		report_mybutton;
    }
}
output_report_cancel : column {
    : row {
        fixed_width = true;
        alignment = centered;
        output_mybutton;
		: spacer { width = 2; }
		report_mybutton;
		: spacer { width = 2; }
        cancel_mybutton;

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
ok_apply : column {
    : row {
        fixed_width = true;
        alignment = centered;
        ok_mybutton;
        : spacer { width = 2; }
        apply_mybutton;
    }
}
ok_report : column {
    : row {
        fixed_width = true;
        alignment = centered;
        ok_mybutton;
        : spacer { width = 2; }
        report_mybutton;
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
exit_apply_select : column {
    : row {
        fixed_width = true;
        alignment = centered;
        exit_mybutton;
        : spacer { width = 2; }
        apply_mybutton;
        : spacer { width = 2; }
        select_mybutton;
    }
}

selectall_modified_list_exit : column {
    : row {
        fixed_width = true;
        alignment = centered;
        selectall_mybutton;
        : spacer { width = 2; }
        modified_mybutton;
        : spacer { width = 2; }
        list_mybutton;
		//: spacer { width = 2; }
		//filter_mybutton;
		: spacer { width = 2; }
		exit_mybutton;
    }
}

selectall_show_import_list_exit : column {
    : row {
        fixed_width = true;
        alignment = centered;
        selectall_mybutton;
        : spacer { width = 2; }
        show_mybutton;
        : spacer { width = 2; }
        import_mybutton;
        : spacer { width = 2; }
		list_mybutton;
		: spacer { width = 2; }
		exit_mybutton;
 
    }
}
selectall_import_save_list_exit : column {
    : row {
        fixed_width = true;
        alignment = centered;
        selectall_mybutton;
        : spacer { width = 2; }
        import_mybutton;
		: spacer { width = 2; }
		save1_mybutton;
        : spacer { width = 2; }
		list_mybutton;
        : spacer { width = 2; }
		exit_mybutton;
    }
}
ok_saveAS_load_show_delete_exit : column {
    : row {
        fixed_width = true;
        alignment = centered;
        ok_mybutton;
        : spacer { width = 2; }
        saveAS_mybutton;
		: spacer { width = 2; }
		load_mybutton;
        : spacer { width = 2; }
        show_mybutton;
        : spacer { width = 2; }
        delete_mybutton;
        : spacer { width = 2; }
		exit_mybutton;
    }
}
ok_browser : column {
    : row {
        fixed_width = true;
        alignment = centered;
        ok_mybutton;
        : spacer { width = 2; }
        testbrowser_mybutton;
    }
}
cancel_return : column {
    : row {
        fixed_width = true;
        alignment = centered;
        cancel_mybutton;
        : spacer { width = 2; }
        return_mybutton;
    }
}
calc_cancel : column {
    : row {
        fixed_width = true;
        alignment = centered;
        calc_mybutton;
        : spacer { width = 2; }
        cancel_mybutton;
    }
}
ok_cancel_loaddefault : column {
    : row {
        fixed_width = true;
        alignment = centered;
		
        ok_mybutton;
        
		: spacer { width = 2; }
        cancel_mybutton;
		
		: spacer { width = 2; }
		loadvalue_mybutton;
    }
}
/* dialogo OkCancel <--------------------------------=  */
OkCancel:dialog 
 {
    label="Avvertimento";
    :row {
		:text{key="prompt1";}
	}
    :row {
		:text{key="prompt2";}
	}
	ok_cancel;
}

/* dialogo CheckCut <--------------------------------=  */
CheckCut:dialog 
{
    label="Controllo simulazione taglio ";
    :boxed_column {
		:row{  
				:text	{width=35; fixed_width=true; label="Sequenza taglio";  key="sequence";}
				:text	{width=10; fixed_width=true; label=".........";        key="resultsequence";}
				:button {width=20; fixed_width=true; label="Risolvi";          key="infosequence";}			
			}
		:row{  
				:text	{width=35; fixed_width=true; label="Attacchi contorno";key="trigger";}
				:text	{width=10; fixed_width=true; label=".........";        key="resulttrigger";}
				:button {width=20; fixed_width=true; label="Controlla";        key="infotrigger";}			
			}
		:row{  
				:text	{width=35; fixed_width=true; label="Percorso";key="walk";}
				:text	{width=35; fixed_width=true;                  key="resultwalk";}
				:button {width=20; fixed_width=true; label="Simula";  key="infowalk";}			
			}
	}
	ok_only;
}	
/* dialogo CheckCut02 <--------------------------------=  */
CheckCut02:dialog 
{
    label="Controllo simulazione taglio ";
    :boxed_column {
		:row{  
				:text	{width=35; fixed_width=true; label="Attacchi contorno";	key="trigger";}
				:text	{width=10; fixed_width=true; label=".........";        	key="resulttrigger";}
				:button {width=25; fixed_width=true; label="Controlla";        	key="infotrigger";}			
			}
		:row{  
				:text	{width=35; fixed_width=true; label="Sequenza taglio";  	key="sequence";}
				:text	{width=10; fixed_width=true; label=".........";        	key="resultsequence";}
				:button {width=25; fixed_width=true; label="Risolvi";          	key="infosequence";}			
			}
		:row{  
				:text	{width=35; fixed_width=true; label="Percorso";			key="walk";}
				:text	{width=35; fixed_width=true;                  			key="resultwalk";}
				:button {width=25; fixed_width=true; label="Simula";  			key="infowalk";}			
			}
		:row{  
				:text	{width=35; fixed_width=true; label="PartProgramm";		key="PartProgramm";}
				:text	{width=35; fixed_width=true;                 			key="ResultPartProgramm";}
				:button {width=25; fixed_width=true; label="Crea";  			key="StartPartProgramm";}			
			}
	}
	ok_only;
}
/* dialogo CheckCut03 <--------------------------------=  */
CheckCut03:dialog 
{
    label="Controllo simulazione taglio ";
    :boxed_column {
		:row{  
				:text	{width=35; fixed_width=true; label="Attacchi contorno";	key="trigger";}
				:text	{width=10; fixed_width=true; label=".........";        	key="resulttrigger";}
				:button {width=25; fixed_width=true; label="Controlla";        	key="infotrigger";}			
			}
		:row{  
				:text	{width=35; fixed_width=true; label="Percorso";			key="walk";}
				:text	{width=35; fixed_width=true;                  			key="resultwalk";}
				:button {width=25; fixed_width=true; label="Simula";  			key="infowalk";}			
			}
		:row{  
				:text	{width=35; fixed_width=true; label="PartProgramm";		key="PartProgramm";}
				:text	{width=35; fixed_width=true;                 			key="ResultPartProgramm";}
				:button {width=25; fixed_width=true; label="Crea";  			key="StartPartProgramm";}			
			}
	}
	ok_only;
}
/* dialogo AtteditShape <--------------------------------=  */
AtteditShape:dialog 
 {
     label="Menu' tecnologia contorno ";
	 
     :column {
        :boxed_column {
			:row {  
				:text{edit_width=35; label="Id Contorno";}
				:edit_box {edit_width=25; fixed_width = true;  key="idshape"; }               
			}			
			:row {  
				:text{edit_width=35; label="Commessa";}
				:edit_box {edit_width=25; fixed_width = true;  key="commessa"; }               
			}			
			:row {  
				:text{edit_width=35; label="Fase";}
				:edit_box {edit_width=25; fixed_width = true;  key="fase"; }               
			}			
			:row {  
				:text{edit_width=35; label="Marca";}
				:edit_box {edit_width=25; fixed_width = true;  key="marca"; }               
			}			
			:row {  
				:text{edit_width=35; label="Qualita'";}
				:edit_box {edit_width=25; fixed_width = true;  key="qualita"; }               
			}			
			:row {  
				:text{edit_width=35; label="Spessore";}
				:edit_box {edit_width=25; fixed_width = true;  key="spessore"; }               
			}	
			:row {  
				:text{edit_width=35; label="Lunghezza contorno";}
				:edit_box {edit_width=25; fixed_width = true;  key="lgshape"; }               
			}			
			:row {  
				:text{edit_width=35; label="Tempo di taglio";}
				:edit_box {edit_width=25; fixed_width = true;  key="timecut"; }               
			}
			:row {  
				:text{edit_width=35; label="Ultima modifica";}
				:edit_box {edit_width=25; fixed_width = true;  key="ultimamodifica"; }               
			}			
			:row {  
				:text{edit_width=35; label="Quantita'";}
				:edit_box {edit_width=25; fixed_width = true;  key="quantita"; }               
			}			
			
		}			
        :boxed_radio_row {
                   label="Contorno";
				   key="typecont";
                   :radio_button {
                        label="Contorno interno";
                        key="cont_int";
                   }
                   :radio_button {
                        label="Contorno esterno";
                        key="cont_est";
                   }
        }
        :boxed_radio_row {
                   label="Percorrenza torcia";
                   :radio_button {
                        label="Percorrenza oraria";
                        key="perc_ora";
                   }
                   :radio_button {
                        label="Percorrenza antioraria";
                        key="perc_anti";
                   }
        }
        :boxed_radio_row {
                   label="Compensazioni";
                   :radio_button {
                        label="auto";
                        key="comp_auto";
                   }
                   :radio_button {
                        label="no  ";
                        key="comp_no";
                   }
                   :radio_button {
                        label="dx  ";
                        key="comp_dx";
                   }
                   :radio_button {
                        label="sx  ";
                        key="comp_sx";
                   }
        }
     }
     
 exit_apply_select; 
}
/* dialogo DummyChoise <--------------------------------=  */
DummyChoise:dialog
{
	label="xxxxx";
	:boxed_radio_column {
			width=50;fixed_width=true;
			height=50;fixed_height=true;
			:radio_button {
				label="Choose 1";
				key="ch1";
			}
			:radio_button {
				label="Choose 2";
				key="ch2";
			}
			:radio_button {
				label="Choose 3";
				key="ch3";
			}

	}
	ok_cancel;
}
/* dialogo ChoiseTypeShape <--------------------------------=  */
ChoiseTypeShape:dialog
{
	label="Contorno";
	:boxed_radio_column {
		: row {
			:toggle   {key="include1";label="Contorno esterno";} 
		}
		: row {
			:toggle   {key="include2";label="Contorno interno";} 
	   }
	}
	ok_only;
}
/* dialogo GeoShape <--------------------------------=  
GeoShape:dialog 
 {
     label="Menu' tecnologia contorno ";
	 
     :boxed_column {
		label="informazioni contorno";
       :list_box {
                   key="box_info";
                   width=60;
                   height=13;
				   tabs = "40 35";
                   list="";
       }               
     }
     :column {
        :boxed_column {
			:row {  
				:text{edit_width=35; label="Id Contorno";}
				:edit_box {edit_width=25; fixed_width = true;  key="idshape"; }               
			}			
			:row {  
				:text{edit_width=35; label="Commessa";}
				:edit_box {edit_width=25; fixed_width = true;  key="commessa"; }               
			}			
			:row {  
				:text{edit_width=35; label="Fase";}
				:edit_box {edit_width=25; fixed_width = true;  key="fase"; }               
			}			
			:row {  
				:text{edit_width=35; label="Marca";}
				:edit_box {edit_width=25; fixed_width = true;  key="marca"; }               
			}			
			:row {  
				:text{edit_width=35; label="Qualita'";}
				:edit_box {edit_width=25; fixed_width = true;  key="qualita"; }               
			}			
			:row {  
				:text{edit_width=35; label="Spessore";}
				:edit_box {edit_width=25; fixed_width = true;  key="spessore"; }               
			}
			:row {  
				:text{edit_width=35; label="Lunghezza contorno";}
				:edit_box {edit_width=25; fixed_width = true;  key="lgshape"; }               
			}			
			:row {  
				:text{edit_width=35; label="Tempo di taglio";}
				:edit_box {edit_width=25; fixed_width = true;  key="timecut"; }               
			}
			:row {  
				:text{edit_width=35; label="Ultima modifica";}
				:edit_box {edit_width=25; fixed_width = true;  key="ultimamodifica"; }               
			}			
			:row {  
				:text{edit_width=35; label="Quantita'";}
				:edit_box {edit_width=25; fixed_width = true;  key="quantita"; }               
			}			
		}			
        :boxed_radio_row {
                   label="Contorno";
				   key="typecont";
                   :radio_button {
                        label="Contorno interno";
                        key="cont_int";
                   }
                   :radio_button {
                        label="Contorno esterno";
                        key="cont_est";
                   }
        }
        :boxed_radio_row {
                   label="Percorrenza torcia";
                   :radio_button {
                        label="Percorrenza oraria";
                        key="perc_ora";
                   }
                   :radio_button {
                        label="Percorrenza antioraria";
                        key="perc_anti";
                   }
        }
        :boxed_radio_row {
                   label="Compensazioni";
                   :radio_button {
                        label="auto";
                        key="comp_auto";
                   }
                   :radio_button {
                        label="no  ";
                        key="comp_no";
                   }
                   :radio_button {
                        label="dx  ";
                        key="comp_dx";
                   }
                   :radio_button {
                        label="sx  ";
                        key="comp_sx";
                   }
        }
     }
     
 exit_apply_select; 
}
*/
/* dialogo GEO_TEC <--------------------------------=  */
GeoShape:dialog {
    label="Info Contorno";
	:boxed_column {
		label="ID";
		:row {
			:text{width=30; fixed_width=true; label="IdContorno";}
			:edit_box{edit_width=12; fixed_width=true; key="idshape";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Ultima modifica";}
			:edit_box{edit_width=12; fixed_width=true; key="lastmodshape";}
		}
	}
	:boxed_column {
		label="DATI GENERALI";
		:row {
			:text{width=30; fixed_width=true; label="Commessa";}
			:edit_box{edit_width=12; fixed_width=true; key="ordershape";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Fase";}
			:edit_box{edit_width=12; fixed_width=true; key="phaseshape";}
		}	
		:row {
			:text{width=30; fixed_width=true; label="Marca";}
			:edit_box{edit_width=12; fixed_width=true; key="nameshape";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Qualita'";}
			:edit_box{edit_width=12; fixed_width=true; key="matshape";}
		}
		:row {
			:text{width=30; fixed_width=true; label="Lunghezza [mm]";}
			:edit_box{edit_width=12; fixed_width=true; key="lengthshape";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Larghezza [mm]";}
			:edit_box{edit_width=12; fixed_width=true; key="widthshape";}
		}	
		:row {
			:text{width=30; fixed_width=true; label="Spessore [mm]";}
			:edit_box{edit_width=12; fixed_width=true; key="tkshape";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; key="quantita"; label="Quantita'";}
			:edit_box{edit_width=12; fixed_width=true; key="qtashape";}
		}	
	}
	:boxed_column {
		label="TEMPI";
		:row {
			:text{width=30; fixed_width=true; label="Velocita' taglio [mm/min]";}
			:edit_box{edit_width=12; fixed_width=true; key="speedcut";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true;}
			:text{width=12; fixed_width=true;}				
		}
		:row {
			:text{width=30; fixed_width=true; label="Contorno selezionato";}
			:edit_box{edit_width=12; fixed_width=true; key="timecut";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Attacchi selezionati";}
			:edit_box{edit_width=12; fixed_width=true; key="timecut4";}
		}	
		:row {
			:text{width=30; fixed_width=true; label="Contorno esterno";}
			:edit_box{edit_width=12; fixed_width=true; key="timecut1";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Contorni interni";}
			:edit_box{edit_width=12; fixed_width=true; key="timecut2";}
		}
		:row {
			:text{width=30; fixed_width=true; label="Totale attacchi";}
			:edit_box{edit_width=12; fixed_width=true; key="timecut3";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Totale marca";}
			:edit_box{edit_width=12; fixed_width=true; key="timecut5";}
		}
	}
	:boxed_column {
		label="PERCORRENZE";
		:row {
			:text{width=30; fixed_width=true; label="Lung. selezionata [mm]";}
			:edit_box{edit_width=12; fixed_width=true; key="lgshape";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Attacchi selezionati [mm]";}
			:edit_box{edit_width=12; fixed_width=true; key="lgshape4";}
		}	
		:row {
			:text{width=30; fixed_width=true; label="Lung. esterna [mm]";}
			:edit_box{edit_width=12; fixed_width=true; key="lgshape1";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Lung. interne [mm]";}
			:edit_box{edit_width=12; fixed_width=true; key="lgshape2";}
		}	
		:row {
			:text{width=30; fixed_width=true; label="Totale attacchi [mm]";}
			:edit_box{edit_width=12; fixed_width=true; key="lgshape3";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Totale marca [mm]";}
			:edit_box{edit_width=12; fixed_width=true; key="lgshape5";}
		}
	}
	:boxed_column {
		label="PESI";
		:row {
			:text{width=30; fixed_width=true; label="Peso selezionato [kg]";}
			:edit_box{edit_width=12; fixed_width=true; key="weight";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Peso esterno [kg]";}
			:edit_box{edit_width=12; fixed_width=true; key="grossweight";}
		}	
		:row {
			:text{width=30; fixed_width=true; label="Peso sfrido [kg]";}
			:edit_box{edit_width=12; fixed_width=true; key="scrapweight";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Peso netto [kg]";}
			:edit_box{edit_width=12; fixed_width=true; key="netweight";}
		}	
	}
	:row {
		:boxed_radio_column {
			label="Contorno";
			key="typecont";
			width=22; fixed_width=true;fixed_height=true;
			:radio_button {
						label="Contorno interno";
						key="cont_int";
			}
			:radio_button {
						  label="Contorno esterno";
						key="cont_est";
			}
		}
		:boxed_radio_column {
			label="Percorrenza torcia";
			width=22; fixed_width=true;fixed_height=true;
			:radio_button {
						label="Percorrenza oraria";
						key="perc_ora";
			}
			:radio_button {
						label="Percorrenza antioraria";
						key="perc_anti";
			}
		}
		:boxed_radio_column {
			label="Compensazioni";
			width=22; fixed_width=true;fixed_height=true;
			:radio_button {
						label="auto";
						key="comp_auto";
			}
			:radio_button {
						label="no";
						key="comp_no";
			}
			:radio_button {
						label="dx";
						key="comp_dx";
			}
			:radio_button {
						label="sx";
						key="comp_sx";
			}
		}
    }
	exit_apply_select;
}
/* GeoShapeOnSheet <--------------------------------=  */
GeoShapeOnSheet:dialog {
    label="Info Contorno";
	:boxed_column {
		label="ID";
		:row {
			:text{width=30; fixed_width=true; label="IdContorno";}
			:text{width=12; fixed_width=true; key="idshape";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Ultima modifica";}
			:text{width=12; fixed_width=true; key="lastmodshape";}
		}
	}
	:boxed_column {
		label="DATI GENERALI";
		:row {
			:text{width=30; fixed_width=true; label="Commessa";}
			:text{width=12; fixed_width=true; key="ordershape";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Fase";}
			:text{width=12; fixed_width=true; key="phaseshape";}
		}	
		:row {
			:text{width=30; fixed_width=true; label="Marca";}
			:text{width=12; fixed_width=true; key="nameshape";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Qualita'";}
			:text{width=12; fixed_width=true; key="matshape";}
		}
		:row {
			:text{width=30; fixed_width=true; label="Lunghezza [mm]";}
			:text{width=12; fixed_width=true; key="lengthshape";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Larghezza [mm]";}
			:text{width=12; fixed_width=true; key="widthshape";}
		}	
		:row {
			:text{width=30; fixed_width=true; label="Spessore [mm]";}
			:text{width=12; fixed_width=true; key="tkshape";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; key="quantita"; label="Quantita'";}
			:text{width=12; fixed_width=true; key="qtashape";}
		}	
	}
	:boxed_column {
		label="TEMPI";
		:row {
			:text{width=30; fixed_width=true; label="Velocita' taglio [mm/min]";}
			:text{width=12; fixed_width=true; key="speedcut";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true;}
			:text{width=12; fixed_width=true;}				
		}
		:row {
			:text{width=30; fixed_width=true; label="Contorno selezionato";}
			:text{width=12; fixed_width=true; key="timecut";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Attacchi selezionati";}
			:text{width=12; fixed_width=true; key="timecut4";}
		}	
		:row {
			:text{width=30; fixed_width=true; label="Contorno esterno";}
			:text{width=12; fixed_width=true; key="timecut1";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Contorni interni";}
			:text{width=12; fixed_width=true; key="timecut2";}
		}
		:row {
			:text{width=30; fixed_width=true; label="Totale attacchi";}
			:text{width=12; fixed_width=true; key="timecut3";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Totale marca";}
			:text{width=12; fixed_width=true; key="timecut5";}
		}
	}
	:boxed_column {
		label="PERCORRENZE";
		:row {
			:text{width=30; fixed_width=true; label="Lung. selezionata [mm]";}
			:text{width=12; fixed_width=true; key="lgshape";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Attacchi selezionati [mm]";}
			:text{width=12; fixed_width=true; key="lgshape4";}
		}	
		:row {
			:text{width=30; fixed_width=true; label="Lung. esterna [mm]";}
			:text{width=12; fixed_width=true; key="lgshape1";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Lung. interne [mm]";}
			:text{width=12; fixed_width=true; key="lgshape2";}
		}	
		:row {
			:text{width=30; fixed_width=true; label="Totale attacchi [mm]";}
			:text{width=12; fixed_width=true; key="lgshape3";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Totale marca [mm]";}
			:text{width=12; fixed_width=true; key="lgshape5";}
		}
	}
	:boxed_column {
		label="PESI";
		:row {
			:text{width=30; fixed_width=true; label="Peso selezionato [kg]";}
			:text{width=12; fixed_width=true; key="weight";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Peso esterno [kg]";}
			:text{width=12; fixed_width=true; key="grossweight";}
		}	
		:row {
			:text{width=30; fixed_width=true; label="Peso sfrido [kg]";}
			:text{width=12; fixed_width=true; key="scrapweight";}
			:spacer{width=3;}
			:text{width=30; fixed_width=true; label="Peso netto [kg]";}
			:text{width=12; fixed_width=true; key="netweight";}
		}	
	}
	:row {
		:boxed_radio_column {
			label="Contorno";
			key="typecont";
			width=22; fixed_width=true;fixed_height=true;
			:radio_button {
						label="Contorno interno";
						key="cont_int";
			}
			:radio_button {
						  label="Contorno esterno";
						key="cont_est";
			}
		}
		:boxed_radio_column {
			label="Percorrenza torcia";
			width=22; fixed_width=true;fixed_height=true;
			:radio_button {
						label="Percorrenza oraria";
						key="perc_ora";
			}
			:radio_button {
						label="Percorrenza antioraria";
						key="perc_anti";
			}
		}
		:boxed_radio_column {
			label="Compensazioni";
			width=22; fixed_width=true;fixed_height=true;
			:radio_button {
						label="auto";
						key="comp_auto";
			}
			:radio_button {
						label="no";
						key="comp_no";
			}
			:radio_button {
						label="dx";
						key="comp_dx";
			}
			:radio_button {
						label="sx";
						key="comp_sx";
			}
		}
    }
	exit_apply_select;
}
/* dialogo InfoCut <--------------------------------=  */
InfoCut:dialog 
 {
     label="Utilizzo lamiera";
	 
    :boxed_column {
		label="Lista Pezzi";
		:list_box {
                   key="box_info1";
                   width=150;
                   height=2;
				   tabs = "15 25 75 90 105 120 135 150";
				   
		}               
		:list_box {
                   key="box_info2";
                   width=150;
                   height=18;
				   tabs = "15 25 75 90 105 120 135 150";
				   // allow_accept = true;
		}
		:list_box {
                   key="box_info3";
                   width=150;
                   height=2;
				   tabs = "15 25 75 90 105 120 135 150";
				   
		}               
	}
    :boxed_column {
			:row {  
				:text{width=40; fixed_width=true; label="Peso lamiera [Kg]";}
				:text{width=15; fixed_width=true; key="WeightSheet";}    
				:spacer{width=5;}				
				:text{width=40; fixed_width=true; label="Peso contorni [Kg]";}
				:text{width=15; fixed_width=true; key="WeightShape";}               
				:spacer{width=5;}				
			}
			:row {  
				:text{width=40; fixed_width=true; label="Percorrenza totale [mm]";}
				:text{width=15; fixed_width=true; key="TotLgCut";}               
				:spacer{width=5;}				
				:text{width=40; fixed_width=true; label="Percorrenza contorni esterni [mm]";}
				:text{width=15; fixed_width=true; key="LgExtCut";}               
				:spacer{width=5;}				
			}
			:row {  
				:text{width=40; fixed_width=true; label="Percorrenza contorni interni [mm]";}
				:text{width=15; fixed_width=true; key="LgIntCut";}               
				:spacer{width=5;}				
				:text{width=40; fixed_width=true; label="Percorrenza attacchi [mm]";}
				:text{width=15; fixed_width=true; key="LgTriggerCut";}               
				:spacer{width=5;}				
			}
			:row {  
				:text{width=40; fixed_width=true; label="Velocita' taglio [mm/min]";}
				:text{width=15; fixed_width=true; key="SpeedCut";}               
				:spacer{width=5;}				
				:text{width=40; fixed_width=true; label="Tempo Percorrenza [min/sec]";}
				:text{width=15; fixed_width=true; key="TimingCut";}               
				:spacer{width=5;}				
			}			
			:row {  
				:text{width=40; fixed_width=true; label="Superficie Lamiera [Mq]";}
				:text{width=15; fixed_width=true; key="SheetSurface";}               
				:spacer{width=5;}				
				:text{width=40; fixed_width=true; label="Superficie Pezzi [Mq]";}
				:text{width=15; fixed_width=true; key="ShapeSurface";}               
				:spacer{width=5;}				
			}			
			:row {  
				:text{width=40; fixed_width=true; label="Sfrido [Mq]";}
				:text{width=15; fixed_width=true; key="SheetScrapsSurface";}               
				:spacer{width=5;}				
				:text{width=40; fixed_width=true; label="Sfrido [Kg]";}
				:text{width=15; fixed_width=true; key="SheetScrapsWeigth";}               
				:spacer{width=5;}				
			}			
			:row {  
				:text{width=40; fixed_width=true; label="Sfrido [%]";}
				:text{width=15; fixed_width=true; key="SheetScrapsPercent";}               
				:spacer{width=5;}				
				:text{width=40; fixed_width=true; label="Qualita' lamiera";}
				:text{width=15; fixed_width=true; key="MatSheet";}               
				:spacer{width=5;}				
			}			
    }
	 
	ok_report;
}
/* dialogo InfoCutError <--------------------------------=  */
InfoCutError:dialog 
 {
     label="Controllo Taglio";
	 
     :boxed_column {
		label="Lista Contorni";
		:list_box {
					key="box_label";
					height=2;
				    tabs = "8 22 72 87 97 117 137";
					// list = "Prog\tId contorno\tMarca\tTipo contorno\tHandle\tAttacco ingresso\tAttacco uscita";
		}

       :list_box {
                   key="box_info";
                   width=137;
                   height=20;
				   /* tabs = "15 30 45 60 75"; */
				   tabs = "8 22 72 87 97 117 137";
				   /* allow_accept = true; */
       }               
     }
	 ok_only;
}

/* dialogo SETUPLAYOUT <--------------------------------=  */
setuplayout:dialog 
	{
    label="Menu' immagini html ";
    :boxed_row {
		
		:list_box {
					label="Stampanti";
					key="box_info1";
					width=35;
					height=10;
					allow_accept = true;
		}               
		:list_box {
					label="Fogli";
					key="box_info2";
					width=40;
					height=10;
					allow_accept = true;
					/* multiple_select = true; */
		}               
		:list_box {
					label="Stili";
					key="box_info3";
					width=35;
					height=10;
					allow_accept = true;
		}               
    }
    :boxed_row {
		label="Stampante";
		:text{edit_width=35;  key="PlotDeviceName";}
		/* :edit_box {edit_width=35; fixed_width = true;  key="PlotDeviceName"; } */
	}
    :boxed_row {	
		label="Foglio";
		:text{edit_width=35;  key="SheetName";}
		/* :edit_box {edit_width=40; fixed_width = true;  key="SheetName"; } */
	}
    :boxed_row {	
		label="Stile";
		:text{edit_width=35;  key="StyleName";}
		/* :edit_box {edit_width=35; fixed_width = true;  key="StyleName"; } */       
	}
	 ok_cancel;
}

/* dialogo MAINSETUP <--------------------------------=  */
mainsetup:dialog 
 {
     label="Menu' Setup Easy Cut ";
	 :text{key="NameSetup";}
     :boxed_column {
		label="Lista Setup";
       :list_box {
                   key="box_info";
                   width=35;
                   height=17;
				   allow_accept = true;
       }               
     }
	 ok_saveAS_load_show_delete_exit;
	 // ok_cancel;
}
/* dialogo BROWSERSETUP <--------------------------------=  */
BrowserSetup:dialog 
 {
    label="Setup Browser";
    :boxed_column {
		label="Lista Browser Installati";
		:list_box {
					key="title_box";
					height=2;
					tabs = "20 40 60 120";
					list = "Nome Browser\tStatus\tDefault\tPath Browser";
		}
		:list_box {
					key="box_info";
					tabs = "20 40 60 120";
					// list = "Name Browser\tStatus\tDefault\tPath Browser";
                    width=80;
					height=15;
					//allow_accept = true;
		}
		:row {  :toggle   {key="ActiveBrowser";                                               }
				:text     {edit_width=35; fixed_width = true;  key="TxtDifferentBrowser"; label="Altro Browser";}
				:edit_box {edit_width=55; fixed_width = true;  key="DifferentBrowser";        }    
				:button   {width=15;	  fixed_width = true;  label="Path"; key="PathSearch";} 
				:spacer   {width=45;}
		}
		:row {
			:image_button {
						key ="image1";
						width = 11;             
						fixed_width = true;
						height = 5; 
						fixed_height = true;
						color = 250;
			}	   
			:image_button {
						key ="image2";
						width = 11;             
						fixed_width = true;
						height = 5; 
						fixed_height = true;
						color = 250;
			}	   
			:image_button {
						key ="image3";
						width = 11;             
						fixed_width = true;
						height = 5; 
						fixed_height = true;
						color = 250;
			}	   
			:image_button {
						key ="image4";
						width = 11;             
						fixed_width = true;
						height = 5; 
						fixed_height = true;
						color = 250;
			}	   
			:image_button {
						key ="image5";
						width = 11;             
						fixed_width = true;
						height = 5; 
						fixed_height = true;
						color = 250;
			}	   
			:image_button {
						key ="image6";
						width = 11;             
						fixed_width = true;
						height = 5; 
						fixed_height = true;
						color = 250;
			}	   
			:image_button {
						key ="image7";
						width = 11;             
						fixed_width = true;
						height = 5; 
						fixed_height = true;
						color = 250;
			}	   
			:image_button {
						key ="image8";
						width = 11;             
						fixed_width = true;
						height = 5; 
						fixed_height = true;
						color = 250;
			}	   
			:image_button {
						key ="image9";
						width = 11;             
						fixed_width = true;
						height = 5; 
						fixed_height = true;
						color = 250;
			}	   
			:image_button {
						key ="image10";
						width = 11;             
						fixed_width = true;
						height = 5; 
						fixed_height = true;
						color = 250;
			}	   
			:image_button {
						key ="image11";
						width = 11;             
						fixed_width = true;
						height = 5; 
						fixed_height = true;
						color = 250;
			}	   
			:image_button {
						key ="image12";
						width = 11;             
						fixed_width = true;
						height = 5; 
						fixed_height = true;
						color = 250;
			}	   
		}	   
    }
	ok_browser;
}
/* dialogo SETUPATTACCHI <--------------------------------=  */
setupattacchi:dialog 
 {
	label="Setup attacchi";
   :boxed_column {
		label="Variabili attacchi";
		:row {  :text{edit_width=35; label="margine accosto contorno [mm]";}
				:edit_box {edit_width=25; fixed_width = true;  key="MargineAccosto"; }               
		}
		:row {  :text{edit_width=35; label="margine accosto contorno/bordo lamiera Dx [mm]";}
				:edit_box {edit_width=25; fixed_width = true;  key="MargineLamieraDx"; }               
		}
		:row {  :text{edit_width=35; label="margine accosto contorno/bordo lamiera Sx [mm]";}
				:edit_box {edit_width=25; fixed_width = true;  key="MargineLamieraSx"; }               
		}
		:row {  :text{edit_width=35; label="margine accosto contorno/bordo lamiera Alto [mm]";}
				:edit_box {edit_width=25; fixed_width = true;  key="MargineLamieraTp"; }               
		}
		:row {  :text{edit_width=35; label="margine accosto contorno/bordo lamiera Basso [mm]";}
				:edit_box {edit_width=25; fixed_width = true;  key="MargineLamieraBt"; }               
		}
		:row {  :text{edit_width=35; label="margine accosto contorno/bordo lamiera irregolare [mm]";}
				:edit_box {edit_width=25; fixed_width = true;  key="MargineLamiera"; }               
		}
		:row {  :text{edit_width=35; label="margine rifilo sezionatrice [mm]";}
				:edit_box {edit_width=25; fixed_width = true;  key="MargineRifilo"; }               
		}
		:row {  :text{edit_width=35; label="spessore lama sezionatrice [mm]";}
				:edit_box {edit_width=25; fixed_width = true; key="SpessoreLama";}               
		}
		:row {  :text{edit_width=35; label="lunghezza attacco rettilineo in uscita [mm]";}
				:edit_box {edit_width=25; fixed_width = true; key="LgSegEsci";}               
		}
		:row {  :text{edit_width=35; label="lunghezza attacco circolare in entrata [mm]";}
				:edit_box {edit_width=25; fixed_width = true; key="SvArcEntra";}               
		}
		:row {  :text{edit_width=35; label="lunghezza attacco circolare in uscita [mm]";}
				:edit_box {edit_width=25; fixed_width = true; key="SvArcEsci";}               
		}
		:row {  :text{edit_width=35; label="raggio attacco circolare in entrata [mm]";}
				:edit_box {edit_width=25; fixed_width = true; key="RaggioEntra";}               
		}
		:row {  :text{edit_width=35; label="raggio attacco circolare in uscita [mm]";}
				:edit_box {edit_width=25; fixed_width = true; key="RaggioEsci";}               
		}
		:row {  :text{edit_width=35; label="colore attacco in entrata";}
				:edit_box {edit_width=25; fixed_width = true; key="ColorEntra";}               
		}
		:row {  :text{edit_width=35; label="colore attacco in uscita";}
				:edit_box {edit_width=25; fixed_width = true; key="ColorEsci";}               
		}
	}
	ok_cancel;
}
/* dialogo SETUPCONTORNI <--------------------------------=  */
setupcontorni:dialog 
 {
    label="Setup contorni"; 
	:boxed_column {
		label="Variabili contorni";
		:row {  :text{edit_width=35; label="velocità taglio [mm/min]";}
				:edit_box {edit_width=25; fixed_width = true;  key="SpeedCut"; }               
		}
		:row {  :text{edit_width=35; label="colore contorno esterno orario";}
				:edit_box {edit_width=25; fixed_width = true; key="ColorShapeOra";}               
		}
		:row {  :text{edit_width=35; label="colore contorno esterno antiorario";}
				:edit_box {edit_width=25; fixed_width = true; key="ColorShapeAntiOra";}               
		}
		:row {  :text{edit_width=35; label="colore contorno interno orario";}
				:edit_box {edit_width=25; fixed_width = true; key="ColorHoleOra";}               
		}
		:row {  :text{edit_width=35; label="colore contorno interno antiorario";}
				:edit_box {edit_width=25; fixed_width = true; key="ColorHoleAntiOra";}               
		}
		:row {  :text{edit_width=35; label="colore contorno interno circolari";}
				:edit_box {edit_width=25; fixed_width = true; key="ColorCircle";}               
		}
		:row {  :text{edit_width=35; label="colore contorno interno ellittici";}
				:edit_box {edit_width=25; fixed_width = true; key="ColorEllipse";}               
		}
		:row {  :text{edit_width=35; label="colore contorno staccati";}
				:edit_box {edit_width=25; fixed_width = true; key="ColorDetatch";}               
		}
		:row {  :text{edit_width=35; label="freccia massima per il calcolo della divisione dell'arco/cerchio";}
				:edit_box {edit_width=25; fixed_width = true; key="ArrowArcDivision";}               
		}
		:row {  :text{edit_width=35; label="precisione rotazione LeanOn [gradi]";}
				:edit_box {edit_width=25; fixed_width = true; key="AccuracyAngleRotation";}               
		}
	}
	ok_cancel;
}
/* dialogo SETUPRAGGRUPPAMENT <--------------------------------=  */
setupragg:dialog 
 {
    label="Setup raggruppamenti";  
   :boxed_column {
		label="Variabili raggruppamenti";
		:row {  :text{edit_width=35; label="raggruppamento lamiera";}
				:edit_box {edit_width=25; fixed_width = true;  key="RgpSheet"; }               
		}
		:row {  :text{edit_width=35; label="raggruppamento target lamiera";}
				:edit_box {edit_width=25; fixed_width = true;  key="RgpSheetTarget"; }               
		}
		:row {  :text{edit_width=35; label="raggruppamento contorno piatto";}
				:edit_box {edit_width=25; fixed_width = true; key="RgpShape";}               
		}
		:row {  :text{edit_width=35; label="raggruppamento target piatto";}
				:edit_box {edit_width=25; fixed_width = true;  key="RgpShapeTarget"; }               
		}
		:row {  :text{edit_width=35; label="raggruppamento attacco in entrata";}
				:edit_box {edit_width=25; fixed_width = true; key="RgpTiggerOn";}               
		}
		:row {  :text{edit_width=35; label="raggruppamento attacco in uscita";}
				:edit_box {edit_width=25; fixed_width = true; key="RgpTiggeroff";}               
		}
		//:row {  :text{edit_width=35; label="raggruppamento righello";}
		//		:edit_box {edit_width=25; fixed_width = true; key="RgpRule";}               
		//}
		:row {  :text{edit_width=35; label="raggruppamento simulazione taglio";}
				:edit_box {edit_width=25; fixed_width = true; key="RgpSymula";}               
		}
		//:row {  :text{edit_width=35; label="raggruppamento cartiglio e squadratura";}
		//		:edit_box {edit_width=25; fixed_width = true; key="RgpBom";}
		//}
	}
	ok_cancel;
}
/* dialogo SETUPSYMULA <--------------------------------=  */
setupsymula:dialog 
 {
    label="Setup simula";  
	:boxed_column {
		label="Variabili sequenza e simulazione";
		:row {	:text{edit_width=22; label="tipo sequenza taglio";}
				:popup_list { 	key="Sequence";	
								edit_width=40; list="[1]   Superficie maggiore\n[2]   Superficie minore\n[3]   Vicino a..\n[4]   X/Y";}
		}
		:row {  :text{edit_width=22; label="tipo simulazione";}
				:popup_list { 	key="TypSymula";	
								edit_width=40; list="[1]   battere enter ad ogni segmento\n[2]   automatico per ogni segmento\n[3]   battere enter ad ogni spostamento veloce\n[4]   animazione";}
		}
		:row {  :text{edit_width=22; label="colore simulazione";}
				:edit_box {edit_width=40; fixed_width = true;  key="ColorSymula"; }               
		}
		:row {  
			:text	{edit_width=22; label="velocita' simulazione";}
			:slider {	key = "TimeSymula" ;		//give it a name
						width=40;
						max_value = 5000;			//upper value
						min_value = 1;				//lower value
						value = "1000";				//initial value
			}
		}
	}
	ok_cancel;
}
/* dialogo SETUPFLEX <--------------------------------=  */
setupflex:dialog 
 {
    label="Setup flex";  
	:boxed_column {
		label="Variabili flessione sagoma";
		:row {  :text{edit_width=35; label="Flessione [mm]";}
				:edit_box {edit_width=25; fixed_width = true;  key="Flex"; }               
		}
		:row {  :text{edit_width=35; label="Escludi diametro da ";}
				:edit_box {edit_width=25; fixed_width = true; key="FlexHoleDiamExcludeFrom";}               
		}
		:row {  :text{edit_width=35; label="Escludi diametro a";}
				:edit_box {edit_width=25; fixed_width = true; key="FlexHoleDiamExcludeTo";}               
		}
	}
	ok_cancel;
}
/* dialogo SETUPMICRO <--------------------------------=  */
setupmicro:dialog 
 {
    label="Setup micro";  
	:boxed_column {
		label="Variabili microconnessioni";
		:row {  :text{edit_width=35; label="Lunghezza Micro [mm]";}
				:edit_box {edit_width=25; fixed_width = true;  key="LgMicro"; }               
		}
		:row {  :text{edit_width=35; label="Altezza Micro ";}
				:edit_box {edit_width=25; fixed_width = true; key="WdMicro";}               
		}
		:row {  :text{edit_width=35; label="Altezza Micro nel vertice polylinea";}
				:edit_box {edit_width=25; fixed_width = true; key="WdMicroAtPoint";}               
		}
	}
	ok_cancel;
}
/* dialogo SETUPADMINSCRAP <--------------------------------=  */
setupadminscrap:dialog {

    label="Setup gestione sfrido";  
	:boxed_column {
	
		:radio_row {
			:text{width=40; value="Utilizzo sfrido controni interni";}
			: radio_button {
				label="Si"  ;
				key = "OkPartInPart" ;
				value = "1" ;
			}		
			: radio_button {
				label="No"  ;
				key = "NoPartInPart" ;
			}		
		}
		:radio_row {
			:text{width=40; value="Utilizzo sfrido controni esterni";}
			: radio_button {
				label="Si"  ;
				key = "OkScrapInPart" ;
				value = "1" ;
			}		
			: radio_button {
				label="No"  ;
				key = "NoScrapInPart" ;
			}		
		}
		:radio_row {
			:text{width=40; value="Utilizzo sfrido lamiera";}
			: radio_button {
				label="Si"  ;
				key = "OkMergeScrap" ;
				value = "1" ;
			}		
			: radio_button {
				label="No"  ;
				key = "NoMergeScrap" ;
			}		
		}
	}
	ok_cancel;
}
/* dialogo SETUPDXFIMPORT <--------------------------------=  */
setupdxfimport:dialog {

    label="Setup import dxf";  
	:boxed_column {
	
		// label="Variabili import dxf";
		
		:radio_row {
			:text{width=40; value="Rimuovere gli oggetti singoli";}
			: radio_button {
				label="Si"  ;
				key = "OkRemove" ;
				value = "1" ;
			}		
			: radio_button {
				label="No"  ;
				key = "NoRemove" ;
			}		
		}
		:radio_row {
			:text{width=40; value="Forzare la chiusura polilinee";}
			: radio_button {
				label="Si"  ;
				key = "OkClose" ;
				value = "1" ;
			}		
			: radio_button {
				label="No"  ;
				key = "NoClose" ;
			}		
		}
		:radio_row {
			:text{width=40; value="Esplodere i blocchi";}
			: radio_button {
				label="Si"  ;
				key = "OkExplode" ;
				value = "1" ;
			}		
			: radio_button {
				label="No"  ;
				key = "NoExplode" ;
			}		
		}
		:radio_row {
			:text{width=40; value="Semplificare le polilinee";}
			: radio_button {
				label="Si"  ;
				key = "OkSimple" ;
				value = "1" ;
			}		
			: radio_button {
				label="No"  ;
				key = "NoSimple" ;
			}		
		}
		:boxed_column {
			:radio_row {
				:text{width=40; value="Controllo sovrapposizione oggetti";}
				: radio_button {
					label="Si"  ;
					key = "OkOverlapp" ;
					value = "1" ;
				}		
				: radio_button {
					label="No"  ;
					key = "NoOverlapp" ;
				}
			}
			:row {  :text{width=35; value="Tolleranza centro archi [ mm ] ";}
					:edit_box {edit_width=15; fixed_width = true;  key="OverlappAcuracyCenter";}               
			}
			:row {  :text{width=35; value="Tolleranza raggio archi / cerchi [ mm ] ";}
					:edit_box {edit_width=15; fixed_width = true;  key="OverlappAcuracyRadius";}               
			}
			:row {  :text{width=35; value="Tolleranza vertici [ mm ] ";}
					:edit_box {edit_width=15; fixed_width = true;  key="OverlappAcuracyPoint";}               
			}
			:row {  :text{width=35; value="Tolleranza collinearita' [ mm ] ";}
					:edit_box {edit_width=15; fixed_width = true;  key="OverlappAcuracyCollinear";}               
			}
			:row {  :text{width=35; value="Tolleranza angoli archi [ gradi ] ";}
					:edit_box {edit_width=15; fixed_width = true;  key="OverlappAcuracyAngleArc";}               
			}
		}
		:boxed_column {
			:row {  :text{width=35; value="Tolleranza centro polilinee [ mm ] ";}
					:edit_box {edit_width=15; fixed_width = true;  key="CenterCirclePolyline";}               
			}
			:row {  :text{width=35; value="Tolleranza rimozioni entita minori di [ mm ] ";}
					:edit_box {edit_width=15; fixed_width = true;  key="RemoveAmbiguosLength";}               
			}
			:row {  :text{width=35; value="Chiusura polilinee con apertura minore di [ mm ] ";}
					:edit_box {edit_width=15; fixed_width = true;  key="MaxOpenPolyline";}               
			}
			:row {  :text{width=35; value="Carattere divisore CSV ";}
					:edit_box {edit_width=15; fixed_width = true;  key="DivideCsv";}               
			}
		}
	}
	//ok_cancel;
	ok_cancel_loaddefault;
}

/* dialogo SETUPNESTINGBAR <--------------------------------=  */
setupnestingbar:dialog 
 {
    label="Setup nesting bar";  
	:boxed_column {
		label="Variabili nesting bar";

		:row {  :text{edit_width=35; label="Spessore taglio barra [mm] ";}
				:edit_box {edit_width=25; fixed_width = true;  key="TkCutBar"; }               
		}
		:row {  :text{edit_width=35; label="Margine iniziale barra [mm] ";}
				:edit_box {edit_width=25; fixed_width = true; key="BarMargStart";}               
		}
		:row {  :text{edit_width=35; label="Margine minimo finale barra [mm] ";}
				:edit_box {edit_width=25; fixed_width = true; key="BarMargEnd";}               
		}
	}
	ok_cancel;
}
/* dialogo SETUPARCHIVIO <--------------------------------=  */
setuparchivio:dialog 
 {
    label="Setup archivio";   
	:boxed_column {
		label="Variabili folders e files";
		:row {  :text{edit_width=30; label="archivio Bin";}
				:edit_box {edit_width=55; fixed_width = true; key="BinPathEasyCut";}
		}
		:row {  :text{edit_width=30; label="archivio DCL";}
				:edit_box {edit_width=55; fixed_width = true; key="GuiPathEasyCut";}
		}
		:row {  :text{edit_width=30; label="archivio FONT";}
				:edit_box {edit_width=55; fixed_width = true; key="FontPathEasyCut";}
		}
		:row {  :text{edit_width=30; label="archivio LIB";}
				:edit_box {edit_width=55; fixed_width = true; key="LibPathEasyCut";}
		}
		/* :row {  :text{edit_width=30; label="archivio NestProfessor";} */ 
		/* 		:edit_box {edit_width=55; fixed_width = true; key="NestPorfessorEasyCut";} */
		/* } */
		:row {  :text{edit_width=30; label="archivio Expert Nesting";}
				:edit_box {edit_width=55; fixed_width = true; key="ExpertNestingEasyCut";}
		}
		:row {  :text{edit_width=30; label="archivio RectPack Nesting";}
				:edit_box {edit_width=55; fixed_width = true; key="RectPackNestingEasyCut";}
		}
		:row {  :text{edit_width=30; label="archivio DataBase";}
				:edit_box {edit_width=55; fixed_width = true; key="DbaseEasyCut";}
		}
		:row {  :text{edit_width=30; label="archivio Load";}
				:edit_box {edit_width=55; fixed_width = true; key="LoadEasyCut";}
		}
		:row {  :text{edit_width=30; label="archivio Cnc";}
				:edit_box {edit_width=55; fixed_width = true; key="CncPathEasyCut";}
		}
		:row {  :text{edit_width=30; label="archivio percorso taglio";}
				:edit_box {edit_width=55; fixed_width = true;  key="CutPathEasyCut"; }
		}
		:row {  :text{edit_width=30; label="archivio info";}
				:edit_box {edit_width=55; fixed_width = true;  key="InfoPathEasyCut"; }
		}
		:row {  :text{edit_width=30; label="archivio layout Html";}
				:edit_box {edit_width=55; fixed_width = true; key="HtmlStorageEasyCut";}
		}
		:row {  :text{edit_width=30; label="archivio dxf nesting";}
				:edit_box {edit_width=55; fixed_width = true; key="DxfNestingEasyCut";}
		}
		:row {  :text{edit_width=30; label="archivio setup";}
				:edit_box {edit_width=55; fixed_width = true; key="SetupPathEasyCut";}
		}
		:row {  :text{edit_width=30; label="nome file setup";}
				:edit_box {edit_width=55; fixed_width = true; key="SetupFileEasyCut";}
		}
		:row {  :text{edit_width=30; label="nome file setup Expert Nesting";}
				:edit_box {edit_width=55; fixed_width = true; key="ECFileSetupExpertNesting";}
		}
		:row {  :text{edit_width=30; label="nome file setup RectPack Nesting";}
				:edit_box {edit_width=55; fixed_width = true; key="ECFileSetupRectPackNesting";}
		}
		:row {  :text{edit_width=30; label="nome file EXE Expert Nesting";}
				:edit_box {edit_width=55; fixed_width = true; key="ECFileExeExpertNesting";}
		}
		:row {  :text{edit_width=30; label="nome file EXE RectPack Nesting";}
				:edit_box {edit_width=55; fixed_width = true; key="ECFileExeRectPackNesting";}
		}
		:row {  :text{edit_width=30; label="nome file EasyCutViewer";}
				:edit_box {edit_width=55; fixed_width = true; key="ECFileViewer";}
		}
		:row {  :text{edit_width=30; label="nome blocco info sheet";}
				:edit_box {edit_width=55; fixed_width = true; key="NameBlockSheet";}
		}
		:row {  :text{edit_width=30; label="nome blocco info shape";}
				:edit_box {edit_width=55; fixed_width = true; key="NameBlockShape";}
		}
		:row {  :text{edit_width=30; label="nome blocco info shape Tmp";}
				:edit_box {edit_width=55; fixed_width = true; key="NameBlockShapeTmp";}
		}
		:row {  :text{edit_width=30; label="file blocco info sheet";}
				:edit_box {edit_width=55; fixed_width = true; key="FileBlockSheet";}
		}
		:row {  :text{edit_width=30; label="file blocco info shape";}
				:edit_box {edit_width=55; fixed_width = true; key="FileBlockShape";}
		}
		:row {  :text{edit_width=30; label="file blocco info shape Tmp";}
				:edit_box {edit_width=55; fixed_width = true; key="FileBlockShapeTmp";}
		}
		:row {  :text{edit_width=30; label="file blocco logo";}
				:edit_box {edit_width=55; fixed_width = true; key="FileBlockLogo";}
		}
	}
	ok_cancel;
}
/* dialogo SETUPFILTRI <--------------------------------=  */
setupfiltri:dialog 
 {
    label="Setup filtri";   
   :boxed_column {
		label="Variabili filtri";
		:row {  :text{edit_width=20; label="filtro contorni";}
				:edit_box {edit_width=75; fixed_width = true;  key="FilterList"; }
		}
		:row {  :text{edit_width=20; label="filtro attacchi";}
				:edit_box {edit_width=75; fixed_width = true; key="TriggerList";}
		}
	}
	ok_cancel;
}
/* dialogo SETUTPESTO <--------------------------------=  */
setuptesto:dialog 
 {
    label="Setup testo";    
    :boxed_column {
		label="Variabili testo";
		:row {  :text{edit_width=30; label="style testo";}
				:edit_box {edit_width=35; fixed_width = true;  key="StyleEasyCut"; }
		}
		:row {  :text{edit_width=30; label="style codice a barre";}
				:edit_box {edit_width=35; fixed_width = true;  key="StyleEasyCutBarCode"; }
		}
		:row {  :text{edit_width=30; label="altezza testo";}
				:edit_box {edit_width=35; fixed_width = true; key="HTextEasyCut";}
		}
		:row {  :text{edit_width=30; label="layer info dinamico";}
				:edit_box {edit_width=35; fixed_width = true; key="LayerDinamicInfoEasyCut";}
		}
		:row {  :text{edit_width=30; label="altezza testo info dinamico";}
				:edit_box {edit_width=35; fixed_width = true; key="HTextDinamicInfoEasyCut";}
		}
		//:row {  :text{edit_width=30; label="apertura catch info dinamico";}
		//		:edit_box {edit_width=35; fixed_width = true; key="AperturaDinamicInfoEasyCut";}
		//}
		//:row {  :text{edit_width=30; label="barcode font";}
		//		:edit_box {edit_width=35; fixed_width = true; key="FontBarCodeEasyCut";}
		//}
		:row {  :text{edit_width=30; label="default font";}
				:edit_box {edit_width=35; fixed_width = true; key="FontDefaultEasyCut";}
		}
	}
	ok_cancel;
}
/* dialogo SETUPHTML <--------------------------------=  */
setuphtlm:dialog 
 {
    label="Setup HTML";    
    :boxed_column {
	
		label="Variabili layout HTML";
		:row {  :text{edit_width=30; label="HTML PC3 di riferimento layout";}
				:edit_box {edit_width=35; fixed_width = true;  key="HtmlPlotterEasyCut"; }
		}
		:row {  :text{edit_width=30; label="HTML Ctb di riferimento layout";}
				:edit_box {edit_width=35; fixed_width = true;  key="HtmlCtbEasyCut"; }
		}
		:row {  :text{edit_width=30; label="HTML dimensione foglio layout";}
				:edit_box {edit_width=35; fixed_width = true; key="HtmlPaperSizeEasyCut";}
		}
		:row {  :text{edit_width=30; label="HTML scripts";}
				:edit_box {edit_width=35; fixed_width = true;  key="HtmlScriptEasyCut"; }
		}
		:row {  :text{edit_width=30; label="HTML archivio lamiere";}
				:edit_box {edit_width=35; fixed_width = true; key="ECFolderSheet";}
		}
		:row {  :text{edit_width=30; label="HTML archivio contorni";}
				:edit_box {edit_width=35; fixed_width = true; key="ECFolderShape";}
		}
		:row {  :text{edit_width=30; label="HTML archivio contorni preview";}
				:edit_box {edit_width=35; fixed_width = true; key="ECFolderShapePreview";}
		}
		:row {  :text{edit_width=30; label="HTML archivio report";}
				:edit_box {edit_width=35; fixed_width = true; key="ECFolderReport";}
		}
		:row {  :text{edit_width=30; label="HTML nome file lamiere";}
				:edit_box {edit_width=35; fixed_width = true; key="ECFileSheet";}
		}
		:row {  :text{edit_width=30; label="HTML nome file contorno";}
				:edit_box {edit_width=35; fixed_width = true; key="ECFileShape";}
		}
		:row {  :text{edit_width=30; label="HTML nome file report";}
				:edit_box {edit_width=35; fixed_width = true; key="ECFileReport";}
		}
		:row {  :text{edit_width=30; label="HTML nome file tree";}
				:edit_box {edit_width=35; fixed_width = true; key="ECFileTree";}
		}
	}
	ok_cancel;
}
/* ------------------------------------- */
/*             setupspeedcut            */
/* ------------------------------------- */
setupspeedcut:dialog {
        label="Setup velocita di taglio";
        :boxed_radio_column {
			: row {
                   :text     {label="1"; width=3;}
				   :toggle   {key="include1";} 
				   :text     {key="tk1_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk1"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk1_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut1";  fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="2"; width=3;}
 				   :toggle   {key="include2";} 
				   :text     {key="tk2_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk2"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
 				   :text     {key="tk2_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut2"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="3"; width=3;}
				   :toggle   {key="include3";} 
 				   :text     {key="tk3_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk3"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk3_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut3"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="4"; width=3;}
				   :toggle   {key="include4";} 
				   :text     {key="tk4_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk4"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk4_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut4"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="5"; width=3;}
				   :toggle   {key="include5";} 
				   :text     {key="tk5_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk5"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk5_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut5"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="6"; width=3;}
 				   :toggle   {key="include6";} 
				   :text     {key="tk6_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk6"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk6_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut6"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="7"; width=3;}
				   :toggle   {key="include7";} 
				   :text     {key="tk7_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk7"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk7_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut7"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="8"; width=3;}
				   :toggle   {key="include8";} 
				   :text     {key="tk8_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk8"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk8_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut8"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="9"; width=3;}
				   :toggle   {key="include9";} 
				   :text     {key="tk9_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk9"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk9_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut9"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="10"; width=3;}
				   :toggle   {key="include10";} 
				   :text     {key="tk10_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk10"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk10_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut10"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="11"; width=3;}
				   :toggle   {key="include11";} 
				   :text     {key="tk11_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk11"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk11_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut11"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="12"; width=3;}
				   :toggle   {key="include12";} 
				   :text     {key="tk12_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk12"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk12_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut12"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="13"; width=3;}
				   :toggle   {key="include13";} 
				   :text     {key="tk13_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk13"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk13_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut13"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="14"; width=3;}
				   :toggle   {key="include14";} 
				   :text     {key="tk14_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk14"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk14_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut14"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="15"; width=3;}
				   :toggle   {key="include15";} 
				   :text     {key="tk15_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk15"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk15_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut15"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="16"; width=3;}
				   :toggle   {key="include16";} 
				   :text     {key="tk16_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk16"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk16_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut16"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="17"; width=3;}
				   :toggle   {key="include17";} 
				   :text     {key="tk17_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk17"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk17_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut17"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="18"; width=3;}
				   :toggle   {key="include18";} 
				   :text     {key="tk18_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk18"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk18_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut18"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="19"; width=3;}
				   :toggle   {key="include19";} 
				   :text     {key="tk19_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk19"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk19_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut19"; fixed_width=true; edit_width=8;}
            }
			: row {
                   :text     {label="20"; width=3;}
				   :toggle   {key="include20";} 
				   :text     {key="tk20_1"; edit_width=15; label="Spessore [mm]";}
                   :edit_box {key="tk20"; fixed_width=true; edit_width=8;}
                   :spacer   {fixed_width=true; width=5;}
				   :text     {key="tk20_2"; edit_width=15; label="Velocita' [mm/min]";}
                   :edit_box {key="speedcut20"; fixed_width=true; edit_width=8;}
            }
		}
		:boxed_radio_column {
			: row {
					:edit_box {key="speedcut"; label="Velocita alternativa [mm/min]"; edit_width=8;}
            }
		}
       :row {
               fixed_width = true;
               alignment = centered;
               :button   { label="Salva"; key="_Salva_"; is_default=true; 
                           fixed_width = true; width = 11; }
               : spacer { width = 2; }
               :button   { label="Esci"; key="_Esci_"; is_default=true; 
                           fixed_width = true; width = 11; }
     }
}
/* ------------------------------------- */
/*             setuptcutoff            */
/* ------------------------------------- */
setupcutoff:dialog {
        label="Cut Off";
        :boxed_radio_column {
			label="Fori interni da escludere dal taglio";
			: row {
                   :text     {label="1"; width=3;}
				   :toggle   {key="include1";} 
				   :text     {key="tdia1_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia1_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia1_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia1_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="2"; width=3;}
				   :toggle   {key="include2";} 
				   :text     {key="tdia2_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia2_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia2_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia2_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="3"; width=3;}
				   :toggle   {key="include3";} 
				   :text     {key="tdia3_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia3_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia3_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia3_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="4"; width=3;}
				   :toggle   {key="include4";} 
				   :text     {key="tdia4_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia4_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia4_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia4_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="5"; width=3;}
				   :toggle   {key="include5";} 
				   :text     {key="tdia5_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia5_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia5_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia5_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="6"; width=3;}
				   :toggle   {key="include6";} 
				   :text     {key="tdia6_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia6_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia6_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia6_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="7"; width=3;}
				   :toggle   {key="include7";} 
				   :text     {key="tdia7_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia7_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia7_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia7_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="8"; width=3;}
				   :toggle   {key="include8";} 
				   :text     {key="tdia8_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia8_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia8_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia8_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="9"; width=3;}
				   :toggle   {key="include9";} 
				   :text     {key="tdia9_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia9_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia9_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia9_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="10"; width=3;}
				   :toggle   {key="include10";} 
				   :text     {key="tdia10_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia10_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia10_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia10_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="11"; width=3;}
				   :toggle   {key="include11";} 
				   :text     {key="tdia11_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia11_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia11_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia11_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="12"; width=3;}
				   :toggle   {key="include12";} 
				   :text     {key="tdia12_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia12_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia12_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia12_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="13"; width=3;}
				   :toggle   {key="include13";} 
				   :text     {key="tdia13_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia13_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia13_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia13_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="14"; width=3;}
				   :toggle   {key="include14";} 
				   :text     {key="tdia14_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia14_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia14_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia14_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="15"; width=3;}
				   :toggle   {key="include15";} 
				   :text     {key="tdia15_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia15_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia15_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia15_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="16"; width=3;}
				   :toggle   {key="include16";} 
				   :text     {key="tdia16_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia16_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia16_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia16_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="17"; width=3;}
				   :toggle   {key="include17";} 
				   :text     {key="tdia17_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia17_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia17_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia17_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="18"; width=3;}
				   :toggle   {key="include18";} 
				   :text     {key="tdia18_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia18_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia18_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia18_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="19"; width=3;}
				   :toggle   {key="include19";} 
				   :text     {key="tdia19_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia19_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia19_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia19_2"; fixed_width=true;  label=">";}
            }
			: row {
                   :text     {label="20"; width=3;}
				   :toggle   {key="include20";} 
				   :text     {key="tdia20_1"; fixed_width=true;  label="Diametro [mm]";}
                   :edit_box {key="dia20_1";  fixed_width=true;  edit_width=8; label="<";}
                   :edit_box {key="dia20_2";  fixed_width=true;  edit_width=8;}
				   :text     {key="tdia20_2"; fixed_width=true;  label=">";}
            }
		}
        :boxed_radio_column {
			label="Contorni interni irregolari da escludere dal taglio";
			: row {
				   :toggle   {key="irregularshape"; label="Escludi taglio";} 
            }
        }

		:row {
               fixed_width = true;
               alignment = centered;
               :button  { label="Salva"; key="_Salva_"; is_default=true; 
                           fixed_width = true; width = 11; }
               :spacer 	{ width = 2; }
               :button  { label="Esci"; key="_Esci_"; is_default=true; 
                           fixed_width = true; width = 11; }
		}
}
/* ------------------------------------- */
/*             setupbarcode              */
/* ------------------------------------- */
setupbarcode:dialog {
        label="Setup codice a barre";
        :boxed_radio_column {
		
			:row {
					:toggle   	{ key="Include1";} 
					:text		{ width=15; key="campo1"; label="Campo 1";}
					:spacer 	{ width = 22; }
					:edit_box 	{ label="Carattere iniziale";  	key="separa1"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include2";} 
					:text		{ width=15;				label="Campo 2";}
					:popup_list { key="campo2"; 		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa2"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include3";} 
					:text		{ width=15;				label="Campo 3";}
					:popup_list { key="campo3"; 		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa3"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include4";} 
					:text		{ width=15;				label="Campo 4";}
                    :popup_list { key="campo4"; 		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa4"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include5";} 
					:text		{ width=15;				label="Campo 5";}
                    :popup_list { key="campo5";  		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa5"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include6";} 
					:text		{ width=15;				label="Campo 6";}
                    :popup_list { key="campo6";  		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa6"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include7";} 
 					:text		{ width=15;				label="Campo 7";}
					:popup_list { key="campo7";  		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa7"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include8";} 
					:text		{ width=15;				label="Campo 8";}
                    :popup_list { key="campo8";  		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa8"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include9";} 
					:text		{ width=15;				label="Campo 9";}
                    :popup_list { key="campo9";  		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa9"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include10";} 
					:text		{ width=15;				label="Campo 10";}
                    :popup_list { key="campo10";  		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa10"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include11";} 
					:text		{ width=15;				label="Campo 11";}
                    :popup_list { key="campo11";  		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa11"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include12";} 
					:text		{ width=15;				label="Campo 12";}
                    :popup_list { key="campo12";  		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa12"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include13";} 
					:text		{ width=15;				label="Campo 13";}
                    :popup_list { key="campo13";  		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa13"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include14";} 
					:text		{ width=15;				label="Campo 14";}
                    :popup_list { key="campo14";  		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa14"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include15";} 
					:text		{ width=15;		 		label="Campo 15";}
                    :popup_list { key="campo15"; 		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa15"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include16";} 
					:text		{ width=15;				label="Campo 16";}
                    :popup_list { key="campo16";  		edit_width=20;}
					:spacer 	{ width = 2; }
					:edit_box 	{ label="Separatore";  	key="separa16"; 	edit_width=5; edit_limit=1;}
            }
			:row {
					:toggle   	{ key="Include17";}
					:text		{ width=15; key="campo17"; label="Campo 17";}
 					:spacer 	{ width = 22; }
					:edit_box 	{ label="Carattere finale"; key="separa17"; edit_width=5; edit_limit=1;}
            }

		}
		ok_cancel;
}

/* dialogo SearchShapeOnSheet <--------------------------------=  */
SearchShapeOnSheet:dialog
 {
	label="Search Shape on Sheet";
	: row {
		:column {
			fixed_height=true;
			alignment =top;
			:boxed_radio_column {
				label="Info Search";
				fixed_height=true;
				alignment =top;
				:row {
					:toggle {key="ActiveFilterOrder"; fixed_width = true;} 
					:edit_box {key="OrderFilter"; fixed_width=true; width=30; edit_width=20; label="Order";}                  
				}                  
				:row {
					:toggle {key="ActiveFilterPhase"; fixed_width = true;} 
					:edit_box {key="PhaseFilter"; fixed_width=true; width=30; edit_width=20; label="Phase";}                  
				}                  
				:row {
					:toggle {key="ActiveFilterMark"; fixed_width = true;} 
					:edit_box {key="MarkFilter"; fixed_width=true; width=30; edit_width=20; label="Name";}                  
				} 
				search;
			} 
			:boxed_radio_column {
				fixed_height=true;
				alignment =top;
				:text{ label="Search";}
			    :image {
						key = "$progbarsearch$";
						fixed_width  = 50;
						height = 1;
						color = -15;
				}
				:text{ label="Shadow";}
			    :image {
						key = "$progbarshadow$";
						fixed_width  = 50;
						height = 1;
						color = -15;
				}
			}
		}                  
		:column {
			:boxed_radio_column {
				label="Sheet List";
				width=32;
				:list_box {
							height=2;
							key="box_infol_title";
							tabs = "4 12 32";
							list = "Itm\tId\tName";
				}
				:list_box {
							height=35;
							key="box_infol";
							tabs = "4 12 32";
							//allow_accept = true;
				}
			}
		}
		:column {
			:boxed_radio_column {
				label="Shape List";
				width=114;
				:list_box {
							height=2;
							key="box_info2_title";
							tabs = "4 16 28 40 52 64 76 88 100 114";
							list = "Itm\tId\tOrder\tPhase\tName\tQuantity\tThikness\tWidth\tLength\tMaterial";
				}  
				:list_box {
							height=35;
							key="box_info2";
							tabs = "4 16 28 40 52 64 76 88 100 114";
							multiple_select = true;
							//allow_accept = true;
				}
			}
		}
	}
	output_report_cancel;
	
}
/* dialogo SearchShape <--------------------------------=  */
SearchShape:dialog
 {
	label="Search Shape";
	: row {
		:column {
			fixed_height=true;
			alignment =top;
			:boxed_radio_column {
				label="Info Search";
				fixed_height=true;
				alignment =top;
				:row {
					:toggle   {key="ActiveFilterOrder"; fixed_width = true;} 
					:edit_box {key="OrderFilter"; fixed_width=true; width=30; edit_width=20; label="Order";}                  
				}                  
				:row {
					:toggle   {key="ActiveFilterPhase"; fixed_width = true;} 
					:edit_box {key="PhaseFilter"; fixed_width=true; width=30; edit_width=20; label="Phase";}                  
				}                  
				:row {
					:toggle   {key="ActiveFilterMark"; fixed_width = true;} 
					:edit_box {key="MarkFilter"; fixed_width=true; width=30; edit_width=20;	label="Name";}                  
				} 
				search;
			} 
			:boxed_radio_column {
				fixed_height=true;
				alignment =top;
				:text{ label="Search";}
			    :image {
						key = "$progbarsearch$";
						fixed_width  = 50;
						height = 1;
						color = -15;
				}
				:text{ label="Shadow";}
			    :image {
						key = "$progbarshadow$";
						fixed_width  = 50;
						height = 1;
						color = -15;
				}
			}
		}                  
		:column {
			:boxed_radio_column {
				label="Shape List";
				width=114;
				:list_box {
							height=2;
							key="box_info_title";
							tabs = "4 16 28 40 52 64 76 88 100 114";
							list = "Itm\tId\tOrder\tPhase\tName\tQuantity\tThikness\tWidth\tLength\tMaterial";
				}  
				:list_box {
							height=35;
							key="box_info";
							tabs = "4 16 28 40 52 64 76 88 100 114";
							multiple_select = true;
							//allow_accept = true;
				}
			}
		}
	}
	output_report_cancel;
}
/* dialogo ReportDxf <--------------------------------=  */
ReportDxf:dialog
 {
	label="Info Dxf";
	
    :boxed_column {
		label="List";
		width=125;
		:list_box {
					key="box_label";
					height=2;
					tabs = "4 52 64 76 88 100 112 124";
					list = "Itm\tFile Dxf\tCommessa\tFase\tMarca\tSpessore\tQuantita\tImportare";
					
		}
		:list_box {
					key="box_info";
					height=35;
					tabs = "4 52 64 76 88 100 112 124";
					multiple_select = true;
		}  
    }
	
	excel_update_addfile_ok_cancel;
}


/* dialogo NestingDialog <--------------------------------=  */
NestingDialog:dialog 
 {
	:row {
		:boxed_column {
			fixed_width = true;
			label="Nesting";
			//:row {
			//	: toggle {key = "DeductShape";  label = "Scontare le quantita' presenti nelle lamiere"; value = 1;}
			//}
			:row {
				:button   { label="Shape"; key="SelectShape";    fixed_width = true; width = 15;}
				:edit_box { key="FileSelectShape"; fixed_width = true; width = 70;}
				:button   { label="Restore"; key="RestoreShape"; fixed_width = true;}
			}
			:row {
				:button   { label="Sheet"; key="SelectSheet";    fixed_width = true; width = 15;}
				:edit_box { key="FileSelectSheet"; fixed_width = true; width = 70;}
				:button   { label="Restore"; key="RestoreSheet"; fixed_width = true;}
			}
		}
	}
	:row {
		:boxed_column {
			label="Lista contorni selezionati";
			:row {
				:text_part {width=4;  fixed_width=true; label="Pr";  		}
				:text_part {width=12; fixed_width=true; label="Id";  		}
				:text_part {width=10; fixed_width=true; label="Comm.";  	}
				:text_part {width=8;  fixed_width=true; label="Fase";  		}
				:text_part {width=50; fixed_width=true; label="Nome";   	}
				:text_part {width=10; fixed_width=true; label="Qta";		}
				:text_part {width=10;  fixed_width=true; label="Spes.";	  	}
				:text_part {width=12; fixed_width=true; label="Disp.";		}
			}
			:row {
				:image_button {key="BtShape1";  height=1.2; width=4.0;  vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape2";  height=1.2; width=12.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape3";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape4";  height=1.2; width=8.0;  vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape5";  height=1.2; width=50.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape6";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape7";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape8";  height=1.2; width=12.0; vertical_margin=none; horizontal_margin=none;}
			}
			:list_box {
				key="ListShape";
				width=116;
				height=35;
				fixed_width=true;
				vertical_margin=none; 
				horizontal_margin=none;
				tabs = "4 16 26 34 84 94 104 116";
				// allow_accept = true;
				multiple_select = true;
			}  
		} 
		:boxed_column {
			label="Lista lamiere selezionate";
			:row {
				:text_part {width=4;  fixed_width=true; label="Pr";  	  	}
				:text_part {width=12; fixed_width=true; label="Id";    	  	}
				:text_part {width=16; fixed_width=true; label="Stock";    	}
				:text_part {width=10; fixed_width=true; label="Largh.";  	}
				:text_part {width=10; fixed_width=true; label="Lungh.";  	}
				:text_part {width=10; fixed_width=true; label="Spes.";   	}
				:text_part {width=12; fixed_width=true; label="Disp.";		}

			}
			:row {
				:image_button {key="BtSheet1";  height=1.2; width=4.0;  vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet2";  height=1.2; width=12.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet3";  height=1.2; width=16.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet4";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet5";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet6";  height=1.2; width=10.0;  vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet7";  height=1.2; width=12.0; vertical_margin=none; horizontal_margin=none;}
			}
			:list_box {
				key="ListSheet";
				width=74;
				height=35;
				fixed_width=true;
				vertical_margin=none; 
				horizontal_margin=none;
				tabs = "4 16 32 42 52 62 74";
				// allow_accept = true;
				multiple_select = true;
			}  
		} 

	} 
	:row {fixed_width = true; alignment = centered;
		:retirement_button {label= "Nesting";key="Nesting";}
		:spacer { width = 2; }
		:retirement_button {label= "Esci";key="cancel";is_cancel= true;}
	}
}


/* dialogo AvailabilityUseSheet <--------------------------------=  */
AvailabilityUseSheet:dialog 
 {
	:row {
		:boxed_column {
			fixed_width = true;
			label="Nesting";
			//:row {
			//	: toggle {key = "DeductShape";  label = "Scontare le quantita' presenti nelle lamiere"; value = 1;}
			//}
			:row {
				:button   { label="Shape"; key="SelectShape";    fixed_width = true; width = 15;}
				:edit_box { key="FileSelectShape"; fixed_width = true; width = 70;}
				:button   { label="Restore"; key="RestoreShape"; fixed_width = true;}
			}
			:row {
				:button   { label="Sheet"; key="SelectSheet";    fixed_width = true; width = 15;}
				:edit_box { key="FileSelectSheet"; fixed_width = true; width = 70;}
				:button   { label="Restore"; key="RestoreSheet"; fixed_width = true;}
			}
		}
	}
	:row {
		:boxed_column {
			label="Lista contorni selezionati";
			:row {
				:text_part {width=4;  fixed_width=true; label="Pr";  		 }
				:text_part {width=12; fixed_width=true; label="Id";  		 }
				:text_part {width=10; fixed_width=true; label="Commessa";  	 }
				:text_part {width=8;  fixed_width=true; label="Fase";  		 }
				:text_part {width=50; fixed_width=true; label="Nome";   	 }
				:text_part {width=6;  fixed_width=true; label="Quantita";	 }		
				:text_part {width=6;  fixed_width=true; label="Spessore";	 }
				:text_part {width=12; fixed_width=true; label="Disponibile"; }
			}
			:row {
				:image_button {key="BtShape1";  height=1.2; width=4.0;  vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape2";  height=1.2; width=12.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape3";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape4";  height=1.2; width=8.0;  vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape5";  height=1.2; width=50.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape6";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape7";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape8";  height=1.2; width=12.0; vertical_margin=none; horizontal_margin=none;}
			}
			:list_box {
				key="ListShape";
				width=116;
				height=35;
				fixed_width=true;
				vertical_margin=none; 
				horizontal_margin=none;
				tabs = "4 16 26 34 84 94 104 116";
				// allow_accept = true;
				multiple_select = true;
			}  
		} 
		:boxed_column {
			label="Lista lamiere selezionate";
			:row {
				:text_part {width=4;  fixed_width=true; label="Pr";  	  	}
				:text_part {width=12; fixed_width=true; label="Id";    	  	}
				:text_part {width=16; fixed_width=true; label="Stock";    	}
				:text_part {width=10; fixed_width=true; label="Larghezza";  }
				:text_part {width=10; fixed_width=true; label="Lunghezza";  }
				:text_part {width=10; fixed_width=true; label="Spessore";	}
				:text_part {width=12; fixed_width=true; label="Disponibile";}

			}
			:row {
				:image_button {key="BtSheet1";  height=1.2; width=4.0;  vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet2";  height=1.2; width=12.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet3";  height=1.2; width=16.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet4";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet5";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet6";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet7";  height=1.2; width=12.0; vertical_margin=none; horizontal_margin=none;}
			}
			:list_box {
				key="ListSheet";
				width=74;
				height=35;
				fixed_width=true;
				vertical_margin=none; 
				horizontal_margin=none;
				tabs = "4 16 32 42 52 62 74";
				// allow_accept = true;
				multiple_select = true;
			}  
		} 

	}
	:row {fixed_width = true; alignment = centered;
		:retirement_button {label= "Disponibilita'";key="Availability";}
		:spacer { width = 2; }
		:retirement_button {label= "Esci";key="cancel";is_cancel= true;}
	}
}


/* dialogo MergeNestingDialog <--------------------------------=  */
MergeNestingDialog:dialog 
 {
	:row {
		:boxed_column {
			fixed_width = true;
			label="Nesting";
			:row {
				:button   { label="File Shape"; key="SelectFileShape";    fixed_width = true; width = 15;}
				:edit_box { key="FileSelectShape"; fixed_width = true; width = 70;}
			}
			:row {
				:button   { label="File Sheet"; key="SelectFileSheet";    fixed_width = true; width = 15;}
				:edit_box { key="FileSelectSheet"; fixed_width = true; width = 70;}
			}
		}
	}
	:row {
		:boxed_column {
			label="Lista contorni selezionati";
			:row {
				:text_part {width=4;  fixed_width=true; label="Pr";  			}
				:text_part {width=12; fixed_width=true; label="Id";  			}
				:text_part {width=10; fixed_width=true; label="Commessa";  		}
				:text_part {width=8;  fixed_width=true; label="Fase";  			}
				:text_part {width=50; fixed_width=true; label="Nome";   		}
				:text_part {width=10; fixed_width=true; label="Quantita";		}
				:text_part {width=10; fixed_width=true; label="Spessore";	    }
				:text_part {width=12; fixed_width=true; label="Disponibile";	}
			}
			:row {
				:image_button {key="BtShape1";  height=1.2; width=4.0;  vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape2";  height=1.2; width=12.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape3";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape4";  height=1.2; width=8.0;  vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape5";  height=1.2; width=50.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape6";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape7";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtShape8";  height=1.2; width=12.0; vertical_margin=none; horizontal_margin=none;}
			}
			:list_box {
				key="ListShape";
				width=116;
				height=35;
				fixed_width=true;
				vertical_margin=none; 
				horizontal_margin=none;
				tabs = "4 16 26 34 84 94 104 116";
				// allow_accept = true;
				multiple_select = true;
			}  
		} 
		:boxed_column {
			label="Lista lamiere selezionate";
			:row {
				:text_part {width=4;  fixed_width=true; label="Pr";  	  		}
				:text_part {width=12; fixed_width=true; label="Id";    	  		}
				:text_part {width=16; fixed_width=true; label="Stock";    		}
				:text_part {width=10; fixed_width=true; label="Larghezza";    	}
				:text_part {width=10; fixed_width=true; label="Lunghezza";   	}
				:text_part {width=10; fixed_width=true; label="Spessore";	  	}
				:text_part {width=12; fixed_width=true; label="Disponibile";	}

			}
			:row {
				:image_button {key="BtSheet1";  height=1.2; width=4.0;  vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet2";  height=1.2; width=12.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet3";  height=1.2; width=16.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet4";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet5";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet6";  height=1.2; width=10.0; vertical_margin=none; horizontal_margin=none;}
				:image_button {key="BtSheet7";  height=1.2; width=12.0; vertical_margin=none; horizontal_margin=none;}
			}
			:list_box {
				key="ListSheet";
				width=74;
				height=35;
				fixed_width=true;
				vertical_margin=none; 
				horizontal_margin=none;
				tabs = "4 16 32 42 52 62 74";
				// allow_accept = true;
				multiple_select = true;
			}  
		} 
	}
	ok_cancel;
}

/* dialogo LeaderDialog <--------------------------------=  */
LeaderDialog:dialog {
	label="Setup Leader";
	width=45;
    :boxed_radio_column {
		: toggle {key = "Ucs"; 			  label = "       Ucs Globale [on/off]"; 	  value = 1;}
		: toggle {key = "X";   			  label = "       Valore X [on/off]"; 		  value = 1;}
		: toggle {key = "Y";   			  label = "       Valore Y [on/off]"; 		  value = 1;}
		: toggle {key = "Z";   			  label = "       Valore Z [on/off]"; 		  value = 1;}
		: toggle {key = "Rotation"; 	  label = "       Rotazione testo [Or/Ver]";  value = 1;}
		: toggle {key = "Frame"; 	  	  label = "       Frame    [on/off]";  		  value = 0;}
		: toggle {key = "Mask"; 	  	  label = "       Sfondo   [on/off]";  		  value = 1;}
	}
    :boxed_radio_column {
		: edit_box {key = "PrX";          label= "Prefisso X";          edit_width = 12; value = "[X]=";}
		: edit_box {key = "PrY";          label= "Prefisso Y";          edit_width = 12; value = "[Y]=";}
		: edit_box {key = "PrZ";          label= "Prefisso Z";       	edit_width = 12; value = "[Z]=";}
		: edit_box {key = "Preci";        label= "Precisione";       	edit_width = 12; value = "2";}
		: edit_box {key = "FactX";        label= "Fattore X";        	edit_width = 12; value = "1.0";}
		: edit_box {key = "FactY";        label= "Fattore Y";        	edit_width = 12; value = "1.0";}
		: edit_box {key = "FactZ";        label= "Fattore Z";        	edit_width = 12; value = "1.0";}
		: edit_box {key = "ColorText";    label= "Colore Testo";     	edit_width = 12; value = "4";}
		: edit_box {key = "ColorLeader";  label= "Colore Leader";    	edit_width = 12; value = "1";}
		: edit_box {key = "HeightText";   label= "Altezza Testo";    	edit_width = 12; value = "3.5";}
		: edit_box {key = "WidthText";    label= "Larghezza Testo";  	edit_width = 12; value = "0.8";}
		: edit_box {key = "ScaleText";    label= "Scala Testo";      	edit_width = 12; value = "1.0";}
		: edit_box {key = "TypeArrow";    label= "Tipo freccia [1÷20]"; edit_width = 12; value = "1";}
		: edit_box {key = "SizeArrow";    label= "Dimensione freccia";  edit_width = 12; value = "4";}

	}
	ok_cancel;
}

/* dialogo DimensionTools1 <--------------------------------=  */
DimensionTools1:dialog 
 {
    label="Dimension";
	:text { width=15; key  ="DimStyle";}

    :boxed_column {
		label = "Dim 1";
		:row {
			:image_button {
						key ="image1";
						width = 12;             
						fixed_width = true;
						height = 6; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}	   
			:image_button {
						key ="image2";
						width = 12;             
						fixed_width = true;
						height = 6; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}	 
			:image_button {
						key ="image3";
						width = 12;             
						fixed_width = true;
						height = 6; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}
		}
		:row {
			: popup_list {			
						label="Quota";
						key = "TypeDimFree";			
						value = "0" ;
						edit_width = 23;						
			}
		}
	}

	:boxed_column {
		label = "Dim 2";
		:row { 	:toggle {key = "tog1"; label = "Ricerca matrici";} :toggle {key = "tog2"; label = "Dividi";} :toggle {key = "tog3"; label = "Ottimizza";} }
		:row {	:toggle {key = "tog4"; label="Quota int.";}
				:popup_list {								
					key = "TypeDimInternalShape";			
					value = "0" ;
					edit_width = 23;						
				}
			}
		:row { 	:toggle {key = "tog5"; label="Quota est.";}
				:popup_list {								
					key = "TypeDimExternalShape";			
					value = "0" ;		
					edit_width = 23;						
				}
			}
		:row { 	:image {alignment = centered; height = 0.5 ; fixed_height = true; color = -15; }}
		:row {	:image_button {key ="image4"; width = 12; fixed_width = true; height = 6; fixed_height = true; color = 250;allow_accept = true;}}
	}

    :boxed_column {
		label = "Tools";
		:row {
			:image_button {
						key ="image100";
						width = 26;         
						fixed_width = true;
						height =5; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}	   
		}
		:row {
			:image_button {
						key ="image101";
						width = 26;         
						fixed_width = true;
						height =5; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}	   
		}
		:row {
			:image_button {
						key ="image102";
						width = 26;         
						fixed_width = true;
						height =5; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}	   
		}
	}
	cancel_return;
}

/* dialogo DimensionToolsOpenDcl <--------------------------------=  */
DimensionToolsOpenDcl:dialog 
 {
    label="Dimension";
	:text { width=15; key  ="DimStyle";}

    :boxed_column {
		label = "Dim 1";
		:row {
			:image_button {
						key ="image1";
						width = 12;             
						fixed_width = true;
						height = 6; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}	   
			:image_button {
						key ="image2";
						width = 12;             
						fixed_width = true;
						height = 6; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}	 
			:image_button {
						key ="image3";
						width = 12;             
						fixed_width = true;
						height = 6; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}
		}
		:row {
			: popup_list {			
						label="Quota";
						key = "TypeDimFree";			
						value = "0" ;
						edit_width = 23;						
			}
		}
	}

	:boxed_column {
		label = "Dim 2";
		:row { 	:toggle {key = "tog1"; label = "Ricerca matrici";} :toggle {key = "tog2"; label = "Dividi";} :toggle {key = "tog3"; label = "Ottimizza";} }
		:row {	:toggle {key = "tog4"; label="Quota int.";}
				:popup_list {								
					key = "TypeDimInternalShape";			
					value = "0" ;
					edit_width = 23;						
				}
			}
		:row { 	:toggle {key = "tog5"; label="Quota est.";}
				:popup_list {								
					key = "TypeDimExternalShape";			
					value = "0" ;		
					edit_width = 23;						
				}
			}
		:row { 	:image {alignment = centered; height = 0.5 ; fixed_height = true; color = -15; }}
		:row {	:image_button {key ="image4"; width = 12; fixed_width = true; height = 6; fixed_height = true; color = 250;allow_accept = true;}}
	}

    :boxed_column {
		label = "Tools";
		:row {
			:image_button {
						key ="image100";
						width = 26;         
						fixed_width = true;
						height =5; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}	   
		}
		:row {
			:image_button {
						key ="image101";
						width = 26;         
						fixed_width = true;
						height =5; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}	   
		}
		:row {
			:image_button {
						key ="image102";
						width = 26;         
						fixed_width = true;
						height =5; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}	   
		}
	}
	ok_only;
}

/* dialogo DimensionDialog <--------------------------------=  */
DimensionDialog:dialog {
    label="Dimensioni";
    :boxed_radio_column {
        :row { 
				: toggle {key = "DimAnnotative"; label = "       Annotativa [on/off]"; 	  value = 0;}
        } 
    }
   :boxed_radio_column { label="Set Dimension"; 
        :row { 
                :text     { width=15; fixed_width = true; value="Scala testo";}
                :edit_box { key="DimScale";     edit_width=15; fixed_width = true;}
        } 
        :row { 
                :text     { width=15; fixed_width = true; value="Style testo";}
                :edit_box { key="DimStyleText"; edit_width=15; fixed_width = true;}
        } 
        :row { 
                :text     { width=15; fixed_width = true; value="Altezza testo";}
                :edit_box { key="DimHText";     edit_width=15; fixed_width = true;}
        } 
        :row { 
                :text     { width=15; fixed_width = true; value="Style dimensione";}
                :edit_box { key="DimStyleName";     edit_width=15; fixed_width = true;}
        } 
    }
     ok_cancel;
}
/* dialogo ScrapSheet <--------------------------------=  */
ScrapSheet:dialog 
 {
    label="Sfrido lamiera";
    :boxed_column {
		label = "Tools";
		:row {
			:image_button {
						key ="image1";
						width = 20;         
						fixed_width = true;
						height =7; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}	   
			:image_button {
						key ="image2";
						width = 20;         
						fixed_width = true;
						height =7; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}	   
			:image_button {
						key ="image3";
						width = 20;         
						fixed_width = true;
						height =7; 
						fixed_height = true;
						color = 250;
						allow_accept = true;
			}	   
		}
	}
	cancel_return;
}
/* dialogo ImportShapeXls <--------------------------------=  */
ImportShapeXls:dialog 
 {
    label="Import Shape From File";
	width = 120;
	fixed_width = true;
	:boxed_radio_column {
		:radio_button {
						key = "TypeXls";
						label = "Xls/Xlsx file";
		}
		:radio_button {
						key = "TypeCsv";
						label = "Csv file";
		}
	}
    :boxed_radio_column {
		label = "XLS/XLSX";
		key   = "XlsData";
		:row {
			:button   { label="File"; key="SelectFileShapeXls"; fixed_width = true; width = 15; }
			:text     { key="FileSelectShapeXls"; width=65;}
			:button   { label="Open"; key="OpenFileShapeXls"; fixed_width = true; width = 10; }
			:button   { label="Check"; key="ChkFileShapeXls"; fixed_width = true; width = 10; }
			:button   { label="Open Demo"; key="OpenDemoShapeXls"; fixed_width = true; width = 10; }
			
		}
		:row {
			: popup_list {				
							key = "ListSheet";
							label = "Foglio dati:";
							width = 25;
							fixed_width = true;
							value = "0" ;
			}
		}
        :row {
				:text{width=10; label="Comm";}
				:text{width=10; label="Fase";}
				:text{width=10; label="Marca";}
				:text{width=10; label="Qta.";}
				:text{width=10; label="Lung.";}
				:text{width=10; label="Larg.";}
				:text{width=10; label="Spes.";}
				:text{width=10; label="Mat.";}
		}
		:row {
				: popup_list {key = "Order";    edit_width = 10;}
				: popup_list {key = "Phase";    edit_width = 10;}
				: popup_list {key = "Mark";     edit_width = 10;}
				: popup_list {key = "Quantity";	edit_width = 10;}
				: popup_list {key = "Length";   edit_width = 10;}
				: popup_list {key = "Width";    edit_width = 10;}
				: popup_list {key = "Thick";	edit_width = 10;}
				: popup_list {key = "Material"; edit_width = 10;}
				
		}
		:boxed_column {
			width = 45;
			fixed_width = true;
			:row {
					:text {label="[Se non dichiarato o trovato]";} 
					:text {width=10; label="Commessa";} 
					:edit_box {key = "OrderNAXls"; fixed_width = true; width = 10;} 
				}
			:row {
					:text {label="[Se non dichiarato o trovato]";} 
					:text {width=10;label="Fase";} 
					:edit_box {key = "PhaseNAXls"; fixed_width = true; width = 10;}
				}
			:row {
					:text {label="[Se non dichiarato o trovato]";} 
					:text {width=10;label="Materiale";} 
					:edit_box {key = "MatNAXls"; fixed_width = true; width = 10;}
				}
		}
	}
    :boxed_radio_column {
		label = "CSV";
		key   = "CsvData";
		:row {
			:button   { label="File"; key="SelectFileShapeCsv"; fixed_width = true; width = 15; }
			//:edit_box { key="FileSelectShapeCsv"; width = 65;}
			:text     { key="FileSelectShapeCsv"; width=65; }
			:button   { label="Open"; key="OpenFileShapeCsv"; fixed_width = true; width = 10; }
			:button   { label="Check"; key="ChkFileShapeCsv"; fixed_width = true; width = 10; }
			:button   { label="Open Demo"; key="OpenDemoShapeCsv"; fixed_width = true; width = 10; }
		}
		:row {
			: popup_list {				
							key = "Separator";
							label = "Separatore:";
							width = 25;
							fixed_width = true;
							value = "0" ;
			}
		}
        :row {
				:text{width=10; label="Comm";}
				:text{width=10; label="Fase";}
				:text{width=10; label="Marca";}
				:text{width=10; label="Qta.";}
				:text{width=10; label="Lung.";}
				:text{width=10; label="Larg.";}
				:text{width=10; label="Spes.";}
				:text{width=10; label="Mat.";}
		}
        :row {
				: popup_list {key = "Col1"; edit_width = 10;}
				: popup_list {key = "Col2"; edit_width = 10;}
				: popup_list {key = "Col3"; edit_width = 10;}
				: popup_list {key = "Col4";	edit_width = 10;}
				: popup_list {key = "Col5"; edit_width = 10;}
				: popup_list {key = "Col6"; edit_width = 10;}
				: popup_list {key = "Col7"; edit_width = 10;}
				: popup_list {key = "Col8"; edit_width = 10;}
				
			}
		:boxed_column {
			width = 45;
			fixed_width = true;
			:row {
					:text {label="[Se non dichiarato o trovato]";} 
					:text {width=10; label="Commessa";} 
					:edit_box {key = "OrderNACsv"; fixed_width = true; width = 10;} 
				}
			:row {
					:text {label="[Se non dichiarato o trovato]";} 
					:text {width=10;label="Fase";} 
					:edit_box {key = "PhaseNACsv"; fixed_width = true; width = 10;}
				}
			:row {
					:text {label="[Se non dichiarato o trovato]";} 
					:text {width=10;label="Materiale";} 
					:edit_box {key = "MatNACsv"; fixed_width = true; width = 10;}
				}
		}
	}
	ok_cancel;

}	   
/* dialogo UseSheet <--------------------------------=  */
UseSheet:dialog 
 {
	label="Calcolo utilizzo lamiere";
    :boxed_radio_column {
		label="Dati geometrici lamiera";
		:row { 
				:text {label = "Minima larghezza lamiera";		width=25;}
				:edit_box {key = "MinWidthUseSheet"; 	fixed_width = true; width = 10;}
		}
		:row { 
				:text {label = "Massima larghezza lamiera";		width=25;}
				:edit_box {key = "MaxWidthUseSheet";	fixed_width = true; width = 10;}
		}
		:row { 
				:text {label = "Minima lunghezza lamiera";		width=25;}
				:edit_box {key = "MinLengthUseSheet";	fixed_width = true; width = 10;}
		}
		:row { 
				:text {label = "Massima lunghezza lamiera";		width=25;}
				:edit_box {key = "MaxLengthUseSheet";	fixed_width = true; width = 10;}
		}
		:row { 
				:text {label = "Incremento dimensione lamiera";	width=25;}
				:edit_box {key = "StepUseSheet";		fixed_width = true; width = 10;}
		}
		//:row {:text {label = "";}}
	}
    :boxed_radio_column {
		label="Dati superficie di calcolo";
		:row { 
				:text {label = "Supeficie da utilizzare [Mq]";	width=25;}
				:edit_box {key = "SurfaceUse"; fixed_width = true; width = 10;}
		}
		:row { 
				:text {label = "Percentuale da aggiungere alla superficie [%]";	width=25;}
				:edit_box {key = "AddSurfaceUse"; fixed_width = true; width = 10;}
		}
		:row { 
				:text {label = "Supeficie di calcolo [Mq]";	width=25;}
				:edit_box {key = "AvailableSurfaceUse"; fixed_width = true; width = 10;}
		}
	}
	calc_cancel;
}
/* dialogo UseSheetListBox <--------------------------------=  */
UseSheetListBox:dialog 
 {
	label="Formati lamiere";
    :boxed_radio_column {
		:row {
				:list_box {
							key = "UseSheetFormat";
							height=25;
							width = 70;
							tabs = "11 27 33";
							//		Mq 1234	  n. 10 lamiere   da 1234 x 78910 sfrido 123%
							//		12345678901234567890123456789012345678901234567890123
							//multiple_select = true;
							//allow_accept = true;
				}
		}
	}
	exit_createstock1;
}
/* dialogo UseSheet <--------------------------------=  */
UseSheetToMakeStock:dialog 
 {
    label="Dati Stock Lamiere";
    :boxed_column {
		width=36;
		fixed_width = true;
		:row {
			:text{edit_width=20; label="Nome Stock";}
			:edit_box {edit_width=10; fixed_width = true;  key="namesheet"; }               
		}
		:row {
			:text{label="";}
		}
	}
	:row {
		:boxed_column {
			width=30;
			fixed_width = true;
			label="Geometria";
			:row {
				:text{edit_width=20; label="Larghezza Lamiera";}
				:edit_box {edit_width=10; fixed_width = true;  key="widthsheet"; }               
			}
			:row {
				:text{edit_width=20; label="Altezza Lamiera";}
				:edit_box {edit_width=10; fixed_width = true;  key="heightsheet"; }               
			}
			:row {
				:text{edit_width=20; label="Spessore Lamiera";}
				:edit_box {edit_width=10; fixed_width = true;  key="thicksheet"; }               
			}
			:row {
				:text{edit_width=20; label="Quantità Lamiere";}
				:edit_box {edit_width=10; fixed_width = true;  key="qtasheet"; }               
			}
			:row {
				:text{edit_width=20; label="Qualità Lamiera";}
				:edit_box {edit_width=10; fixed_width = true;  key="matsheet"; }               
			}
			/* :row {
				:text{label="";}
			} */ 
			: button {
				width=35;
				fixed_width = true;
   				key =   "addstock";
				label = "Aggiungi Stock ----->"; 
			}
		}
		:boxed_column {
			label="lista lamiere";
			width=80;
			:list_box {
					key="box_label";
					// width=110;
					height=2;
					tabs = "16 28 40 52 64 76";
					list = "Stock\tLarghezza\tAltezza\tSpessore\tQuantità\tQualità";
			}

			:list_box {
                   key="box_info";
                   /* width=25;
                   height=13; */
				   tabs = "16 28 40 52 64 76";
                   list="";
			}               
		}
	}
	exit_createstock_removestock;
	//ok_cancel;
}
/* dialogo dcltut <--------------------------------=  */
dcltut : dialog {
    fixed_width = true;
    label = "DCL Progress Bar Tutorial 1.0";
    key = "br-label";
    : row {
       : button {
          key = "start";
          label = "Start";
          mnemonic = "S";
       }
       : edit_box {
          key = "max";
          label = "Max:";
          mnemonic = "M";
       }
    }
    : image {
       key = "progbar";
       fixed_width  = 50;
       height = 1;
    }
    /// This Tile may also be put below the OK_Cancel buttons
    : row {
       : button {
          label = "OK";
          mnemonic = "O";
          key = "ok";
       }
       : button {
          label = "Cancel";
          mnemonic = "C";
          key = "cancel";
          is_cancel = true;
       }
    }
    : row {
       : errtile {
          label = "";
          key = "error";
          width = 26;
       }
    }
}


/* dialogo InfoTableStockSheetNesting <--------------------------------=  */
ProgressBar : dialog {
	key = "Title";
	label = "";
	spacer;
	: text {
		key = "Message";
		label = "";
	}
	: row {
		: column {
		: spacer { height = 0.12; fixed_height = true;}
		: image {	key = "$ProgressBar$";
					width = 58.92; fixed_width = true;
					height = 1.51; fixed_height = true;
					aspect_ratio = 1;
					color = -15;
					vertical_margin = none;
		}
		spacer;
    }
    cancel_button;
  }
  : text {
    key = "Complete";
    label = "";
  }
}
/* dialogo ChoseSequenceCut01 <--------------------------------=  */
ChoiseSequenceCut01 : dialog {
	label = "Sequenza di taglio";
	:boxed_radio_column {
                   :radio_button {
						label="Ordina per superficie maggiore";
                        key="Type1";
                   }
                   :radio_button {
						label="Ordina per superficie minore";
                        key="Type2";
                   }
                   :radio_button {
						label="Ordina per vicinanza origine contorno";
                        key="Type3";
                   }
                   :radio_button {
						label="Ordina per x y origine contorno";
                        key="Type4";
                   }
        }
    ok_cancel;
}
/* dialogo ChoseSequenceCut02 <--------------------------------=  */
ChoiseSequenceCut02 : dialog {
	label = "Sequenza di taglio";
	:boxed_radio_column {
                   :radio_button {
						label="Ordina per superficie maggiore";
                        key="Type1";
                   }
                   :radio_button {
						label="Ordina per superficie minore";
                        key="Type2";
                   }
                   :radio_button {
						label="Ordina per vicinanza origine contorno";
                        key="Type3";
                   }
                   :radio_button {
						label="Ordina per x y origine contorno";
                        key="Type4";
                   }
                   :radio_button {
						label="Rimuovi ordinamento";
                        key="Type5";
                   }
        }
    ok_cancel;
}
/* dialogo ChosePartProgramm <--------------------------------=  */
ChoisePartProgramm : dialog {
	label = "Programma di taglio";
	:boxed_radio_column {
                   :radio_button {
						label="Essi Fro";
                        key="Type1";
                   }
                   :radio_button {
						label="Essi Esab";
                        key="Type2";
                   }
                   :radio_button {
						label="Iso Koike";
                        key="Type3";
                   }
                   :radio_button {
						label="Iso Soitaab";
                        key="Type4";
                   }
        }
    ok_cancel;
}


