import_nesting_exit : column {
    : row {
        fixed_width = true;
        alignment = centered;
		
        import_mybutton;

		: spacer { width = 2; }
		
		nesting_mybutton;
        
		: spacer { width = 2; }
		
		exit_mybutton;
    }
}

removepart_modifiedpart_loadpart : column {
    : row {
        fixed_width = true;
        alignment = centered;
		
        removepart_mybutton;
		
        : spacer { width = 0; }
		
        modifiedpart_mybutton;
 
		: spacer { width = 0; }
		
		loadpart_mybutton;

    }
}

removepart_modifiedpart : column {
    : row {
        fixed_width = true;
        alignment = centered;
		
        removepart_mybutton;
		
        : spacer { width = 0; }
		
        modifiedpart_mybutton;

    }
}

removebar_modifiedbar_loadbar : column {
    : row {
        fixed_width = true;
        alignment = centered;
		
        removebar_mybutton;
        : spacer { width = 0; }
        modifiedbar_mybutton;
        : spacer { width = 0; }
        loadbar_mybutton;

    }
}

removebar_modifiedbar : column {
    : row {
        fixed_width = true;
        alignment = centered;
		
        removebar_mybutton;
        : spacer { width = 0; }
        modifiedbar_mybutton;

    }
}

removepart_mybutton : retirement_button {
										label           = "Rimuovi";
										key             = "RemovePart";
}
modifiedpart_mybutton : retirement_button {
										label           = "Modifica";
										key             = "ModifiedPart";
}
loadpart_mybutton : retirement_button {
										label           = "Importa File";
										key             = "LoadPart";
}
removebar_mybutton : retirement_button {
										label           = "Rimuovi";
										key             = "RemoveBar";
}
modifiedbar_mybutton : retirement_button {
										label           = "Modifica";
										key             = "ModifiedBar";
}
loadbar_mybutton : retirement_button {
										label           = "Importa File";
										key             = "LoadBar";
}
nesting_mybutton : retirement_button {
										label           = "Nesting Bar";
										key             = "NestingBar";
}
report_mybutton : retirement_button {
										label           = "REPORT";
										key             = "report";
}
import_mybutton: retirement_button {
										label           = "Importa Lavoro";
										key             = "ImportNesting";
}
save_mybutton : retirement_button {
										label           = "SALVA LAVORO";
										key             = "SaveNesting";
}
exit_mybutton : retirement_button {
										label           = "ESCI";
										key             = "cancel";
										is_cancel       = true;
}

/* dialogo ImportPartsXls <--------------------------------=  */
ImportPartsXls:dialog 
 {
    label="Import Parts From File";
	fixed_width = true;
    :boxed_column {
		label = "Xls/Xlsx";
		:row {
			:text     { key="FileSelectPartsXls"; width=85;}
		}
		:row {
			:button   { label="Check"; key="ChkFilePartsXls"; fixed_width = true; width = 10; }
		}
	}
	:boxed_column {
		fixed_width=true;
		label="Colonne di riferimento file Excel";
		:row {
			:text       {width=12; fixed_width=true; label="Comm";}
			:popup_list {key = "Order"; edit_width = 10; fixed_width=true;}
		}
		:row {
			:text       {width=12; fixed_width=true; label="Fase";}			
			:popup_list {key = "Phase"; edit_width = 10; fixed_width=true;}
		}
		:row {
			:text       {width=12; fixed_width=true; label="Marca";}			
			:popup_list {key = "Mark"; edit_width = 10; fixed_width=true;}
		}
		:row {
			:text        {width=12; fixed_width=true; label="Qta.";}
			: popup_list {key = "Quantity";	edit_width = 10; fixed_width=true;}
		}
		:row {
			:text        {width=12; fixed_width=true; label="Lung.";}
			: popup_list {key = "Length";   edit_width = 10; fixed_width=true;}
		}
		:row {
			:text        {width=12; fixed_width=true; label="Prof.";}
			: popup_list {key = "Profile";	edit_width = 10; fixed_width=true;}
		}
		:row {
			:text        {width=12; fixed_width=true; label="Mat.";}
			: popup_list {key = "Material"; edit_width = 10; fixed_width=true;}
		}
		:row {
			:text        {width=12; fixed_width=true; value="Foglio";}
			: popup_list {key = "ListSheet"; edit_width = 10; fixed_width = true; value = "0";}
		}
	}
	ok_cancel;
}
/* dialogo ImportPartsCsv <--------------------------------=  */
ImportPartsCsv:dialog {
    label="Import Parts From File";
	fixed_width = true;
	:boxed_column {
		label = "Csv";
		:row {
			:text   {key="FileSelectPartsCsv"; width=85; }
		}
		:row {
			:button {label="Check"; key="ChkFilePartsCsv"; fixed_width = true; width = 10; }
		}
	}
	:boxed_column {
		fixed_width=true;
		label="Colonne di riferimento file Csv";
        :row {
				:text{width=12; fixed_width=true; label="Commessa";}
				: popup_list {key = "Col1"; edit_width = 10; fixed_width=true;}
		}
        :row {
				:text{width=12; fixed_width=true; label="Fase";}
				: popup_list {key = "Col2"; edit_width = 10; fixed_width=true;}
		}
        :row {
				:text{width=12; fixed_width=true; label="Marca";}
				: popup_list {key = "Col3"; edit_width = 10; fixed_width=true;}
		}
        :row {
				:text{width=12; fixed_width=true; label="Quantita'";}
				: popup_list {key = "Col4";	edit_width = 10; fixed_width=true;}
		}
        :row {
				:text{width=12; fixed_width=true; label="Lunghezza";}
				: popup_list {key = "Col5"; edit_width = 10; fixed_width=true;}
		}
        :row {
				:text{width=12; fixed_width=true; label="Profilo";}
				: popup_list {key = "Col6"; edit_width = 10; fixed_width=true;}
		}
        :row {
				:text{width=12; fixed_width=true; label="Materiale";}
				: popup_list {key = "Col7"; edit_width = 10; fixed_width=true;}
		}
		:row {
				:text       {width=12; key= "TextSeparator"; fixed_width = true;}
			    :popup_list {key = "Separator"; edit_width = 6; fixed_width = true;	value = "0" ;}
		}
	}
	ok_cancel;
}
/* dialogo ImportBarsXls <--------------------------------=  */
ImportBarsXls:dialog {
    label="Import Bars From File";
    :boxed_column {
		label = "Xls/Xlsx";
		:row {
			:text   {key="FileSelectBarsXls"; width=85;}
		}
		:row {
			:button {label="Check"; key="ChkFileBarsXls"; fixed_width = true; width = 10; }
		}
	}
	:boxed_column {
		fixed_width=true;
		label="Colonne di riferimento file Excel";
		:row {
			:text       {width=12; fixed_width=true; value="Lunghezza";}
			:popup_list {key = "Length";   edit_width = 10; fixed_width=true;}
		}
		:row {
			:text       {width=12; fixed_width=true; value="Profilo";}
			:popup_list {key = "Profile";	edit_width = 10; fixed_width=true;}
		}
		:row {
			:text       {width=12; fixed_width=true; value="Materiale";}
			:popup_list {key = "Material"; edit_width = 10; fixed_width=true;}
		}
		:row {
			:text       {width=12; fixed_width=true; value="Foglio";}
			:popup_list {key = "ListSheet"; edit_width = 10; fixed_width = true; value = "0";}
		}
	}
	ok_cancel;
}
/* dialogo ImportBarsCsv <--------------------------------=  */
ImportBarsCsv:dialog 
 {
    label="Import Bars From File";
    :boxed_column {
		label = "Csv";
		:row {
			:text     { key="FileSelectBarsCsv"; width=85; }
		}
		:row {
			:button   { label="Check"; key="ChkFileBarsCsv"; fixed_width = true; width = 10; }
		}
	}
	:boxed_column {
		fixed_width=true;
		label="Colonne di riferimento file Csv";
		:row {
				:text       {width=12; fixed_width=true; value="Lunghezza";}
				:popup_list {key = "Col1"; edit_width = 6; fixed_width=true;}
		}
		:row {
				:text       {width=12; fixed_width=true; value="Profilo";}
				:popup_list {key = "Col2"; edit_width = 6; fixed_width=true;}
		}
		:row {
				:text       {width=12; fixed_width=true; value="Materiale";}
				:popup_list {key = "Col3"; edit_width = 6; fixed_width=true;}
		}
		:row {
				:text       {width=12; key= "TextSeparator"; fixed_width = true;}
				:popup_list {key = "Separator"; edit_width = 6; fixed_width = true; value = "0";}
		}
		

	}
	ok_cancel;
}

/* dialogo InfoTableNestingBar <--------------------------------=  */
InfoTableNestingBar:dialog 
 {
    label="Nesting barre";
 	:row {
		:column {
			fixed_height=true;
			alignment =top;
			height=26;
			:row {
				:boxed_radio_column {
					label="Dati parti";
					alignment =top;
					fixed_height=true;
					height=16;
					:edit_box {key="OrderPart"; fixed_width=true; edit_width=10; width=23; label="Comm.";   }
					:edit_box {key="PhasePart"; fixed_width=true; edit_width=10; width=23; label="Fase";    }
					:edit_box {key="MarkPart";	fixed_width=true; edit_width=10; width=23; label="Marca";   }
					:edit_box {key="QtyPart"; 	fixed_width=true; edit_width=10; width=23; label="Qta'";    }        
					:edit_box {key="LgPart"; 	fixed_width=true; edit_width=10; width=23; label="Lung.";   }
					:edit_box {key="ProPart"; 	fixed_width=true; edit_width=10; width=23; label="Profilo"; }
					:edit_box {key="MatPart"; 	fixed_width=true; edit_width=10; width=23; label="Mat.";    }
					:button   {key="AddPart"; 	label="Aggiungi   --->";}
				}
			}
			:row {
				:boxed_column {
					fixed_height=true;
					:button   {key="LoadPart"; label="Carica dati da File ->";}
					:button   {key="ExamplePart"; label="Carica Esempio ->";}
				}
			}
		} 
		
		:boxed_column {
			label="Lista parti";
			fixed_height=true;
			alignment =top;
			height=22;
			:row {
				:text_part {width=6 ; fixed_width=true; label="Prg";     }
				:text_part {width=11; fixed_width=true; label="Comm";   }
				:text_part {width=11; fixed_width=true; label="Fase";   }
				:text_part {width=11; fixed_width=true; label="Marca";    }
				:text_part {width=11; fixed_width=true; label="Qta'";}
				:text_part {width=11; fixed_width=true; label="Lungh.";  }
				:text_part {width=11; fixed_width=true; label="Prof."; }
				:text_part {width=11; fixed_width=true; label="Mat.";}
			}
			:row {
				: image_button {key="Btnp0";  height=1.2; width=6.0;  vertical_margin=none; horizontal_margin=none;fixed_width=true;fixed_height=true;}
				: image_button {key="Btnp1";  height=1.2; width=11.0; vertical_margin=none; horizontal_margin=none;fixed_width=true;fixed_height=true;}
				: image_button {key="Btnp2";  height=1.2; width=11.0; vertical_margin=none; horizontal_margin=none;fixed_width=true;fixed_height=true;}
				: image_button {key="Btnp3";  height=1.2; width=11.0; vertical_margin=none; horizontal_margin=none;fixed_width=true;fixed_height=true;}
				: image_button {key="Btnp4";  height=1.2; width=11.0; vertical_margin=none; horizontal_margin=none;fixed_width=true;fixed_height=true;}
				: image_button {key="Btnp5";  height=1.2; width=11.0; vertical_margin=none; horizontal_margin=none;fixed_width=true;fixed_height=true;}
				: image_button {key="Btnp6";  height=1.2; width=11.0; vertical_margin=none; horizontal_margin=none;fixed_width=true;fixed_height=true;}
				: image_button {key="Btnp7";  height=1.2; width=11.0; vertical_margin=none; horizontal_margin=none;fixed_width=true;fixed_height=true;}
			}
			:row {
				fixed_height=true;
				:list_box {
					key="BoxPart";
					width=83;
					height=20;
					fixed_width=true;
					vertical_margin=none; 
					horizontal_margin=none;
					//      prg order phase mark quantity length profile material
					tabs = "6 18 28 40 50 61 72";
					multiple_select = true;
					// allow_accept = true;
				}
			}
			removepart_modifiedpart;
		}
		
		:column {
			fixed_height=true;
			alignment =top;
			height=26;
			:row {
				:boxed_radio_column {
					label="Dati barre";
					fixed_height=true;
					alignment =top;
					height=16;
					:edit_box {key="LgBar"; 	fixed_width=true; edit_width=10; width=23; label="Lung.";  }
					:edit_box {key="ProBar"; 	fixed_width=true; edit_width=10; width=23; label="Profilo"; }
					:edit_box {key="MatBar"; 	fixed_width=true; edit_width=10; width=23; label="Mat.";}
					:button   {key="AddBar"; 	label="Aggiungi   --->";}
				}
			}
			:row {
				:boxed_column {
					fixed_height=true;
					:button   {key="LoadBar"; label="Carica dati da File ->";}
					:button   {key="ExampleBar"; label="Carica Esempio ->";}
				}
			}
		} 

		:boxed_column {
			label="Lista barre";
			fixed_height=true;
			alignment =top;
			height=22;
			:row {
				:text_part {width=6 ; fixed_width=true; label="Prg";     }
				:text_part {width=20; fixed_width=true; label="Lungh.";  }
				:text_part {width=20; fixed_width=true; label="Profilo"; }
				:text_part {width=20; fixed_width=true; label="Mat.";    }
			}
			:row {
				: image_button {key="Btnb0";  height=1.2; width=6.0;  vertical_margin=none; horizontal_margin=none;fixed_width=true;fixed_height=true;}
				: image_button {key="Btnb1";  height=1.2; width=20.0; vertical_margin=none; horizontal_margin=none;fixed_width=true;fixed_height=true;}
				: image_button {key="Btnb2";  height=1.2; width=20.0; vertical_margin=none; horizontal_margin=none;fixed_width=true;fixed_height=true;}
				: image_button {key="Btnb3";  height=1.2; width=20.0; vertical_margin=none; horizontal_margin=none;fixed_width=true;fixed_height=true;}
			}
			:row {
				:list_box {
					key="BoxBar";
					width=66;
					height=20;
					fixed_width=true;
					vertical_margin=none; 
					horizontal_margin=none;
					//      prg order phase mark quantity length profile material
					tabs = "6 26 46 66";
					multiple_select = true;
					// allow_accept = true;
				}
			}
			removebar_modifiedbar;
		}

	}

	:row {:text_part {label=" ";}}
	:row {
		:boxed_column {
			label="Dati taglio";
			fixed_height=true;
			alignment =top;
			fixed_width=true; 
			width=35;
			height=6;
			:edit_box {key="TkCutBar"; 		edit_width=8; label="Spessore taglio";}
			:edit_box {key="BarMargStart"; 	edit_width=8; label="Sfrido iniziale barra";}
			:edit_box {key="BarMargEnd"; 	edit_width=8; label="Sfrido finale barra";}
		}
		:boxed_column {
			label="Accuratezza risultato nesting";
			fixed_height=true;
			alignment =top;
			fixed_width=true; 
			width=35;
			height=6;
			:toggle {
				key = "AutoAccuracyNestingBar";
				label = "Automatico";
			}								
			:edit_box {				
				key = "AccuracyValueNestingBar";
				label = "Accuratezza" ;
				edit_width = 6 ;			
			}	
			:slider {						
				key = "AccuracySliderNestingBar";
				max_value = 100;
				min_value = 1;
				value = "50";
			}
		}							
		:boxed_column {
			label="Rappresentazione parte";
			fixed_height=true;
			alignment =top;
			fixed_width=true; 
			width=15;
			: popup_list {
				key = "RapPart";
				value = "0";
				width = 25;
				fixed_width = true;
			}
		}
		:boxed_column {
			label="File lavoro";
			fixed_height=true;
			alignment =top;
			fixed_width=true; 
			width=100;
			:text{key="JobFle";}
		}
		// : spacer { width = 110; }
	}

 	import_nesting_exit;
}


