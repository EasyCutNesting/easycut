/* dialogo SelPiecesShapeDbase <--------------------------------=  ADO */
SelPiecesShapeDbase:dialog 
 {
    label="Lista pezzi nesting";
    :boxed_radio_column {
        label="Filter";
		: row {
			:toggle {
					key="ActiveFilterId";
					fixed_width = true;
			} 
			:edit_box {
                    key="IdFilter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
                    label="Id";
		    }
			:button {label="?";	key="HelpId";}
		}
		: row {
			:toggle {
					key="ActiveFilterOrder";
					fixed_width = true;
			} 
			:edit_box {
                    key="OrderFilter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
                    label="Order";
		    }
			:button {label="?";	key="HelpOrder";}
		}
		: row {
			:toggle {
					key="ActiveFilterPhase";
					fixed_width = true;
			} 
            :edit_box {
                    key="PhaseFilter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
                    label="Phase";
			}
			:button {label="?";	key="HelpPhase";}
		}
		/*		
		: row {
			:toggle {
					key="ActiveFilterFamily";
					fixed_width = true;
			} 
            :edit_box {
                    key="FamilyFilter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
                    label="Family";
			}
			:button {label="?"; key="HelpFamily";}
		}
		*/
		: row {
			:toggle {
					key="ActiveFilterMark";
					fixed_width = true;
			} 
            :edit_box {
					key="MarkFilter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
					label="Mark";
			}
			:button {label="?";	key="HelpMark";}        
		}
		: row {
			:toggle {
					key="ActiveFilterQuantity";
					fixed_width = true;
			} 
            :edit_box {
                    key="QuantityFilter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
                    label="Quantity";
			}
			:button {label="?"; key="HelpQuantity";}        
		}
		/*		
		: row {
			:toggle {
					key="ActiveFilterName";
					fixed_width = true;
			} 
            :edit_box {
                    key="NameFilter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
                    label="Name";
			}
			:button {label="?";	key="HelpName";}        
		}
		*/
		: row {
			:toggle {
					key="ActiveFilterMaterial";
					fixed_width = true;
			} 
            :edit_box {
                    key="MaterialFilter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
					label="Material";
            }                  
			:button {label="?";	key="HelpMaterial";}        
		}
		: row {
			:toggle {
					key="ActiveFilterThikness";
					fixed_width = true;
			} 
            :edit_box {
                    key="ThiknessFilter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
					label="Thikness";
            }
			:button {label="?";	key="HelpThikness";}        
		}
		: row {
			:toggle {
					key="ActiveFilterLength";
					fixed_width = true;
			} 
            :edit_box {
                    key="LengthFilter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
					label="Length";
            }        
			:button {label="?"; key="HelpLength";}
		}	
		: row {
			:toggle {
					key="ActiveFilterHeight";
					fixed_width = true;
			} 
            :edit_box {
                    key="HeightFilter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
					label="Height";
            }
			:button {label="?";	key="HelpHeight";}
		}	
		: row {
			:toggle {
					key="ActiveFilterCut";
					fixed_width = true;
			} 
            :edit_box {
                    key="CutFilter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
					label="Cut";
            }                  
			:button {label="?";	key="HelpCut";}
		}
		: row {
			:toggle {
					key="ActiveFilterDate";
					fixed_width = true;
			} 
            :edit_box {
                    key="DateFilter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
					label="Date";
            }                  
			:button {label="?"; key="HelpDate";}
		}
		
		/*		
		: row {
			:toggle {
					key="ActiveFilterFlag1";
					fixed_width = true;
			} 
            :edit_box {
                    key="Flag1Filter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
					label="Flag1";
            }                  
			:button {label="?";	key="HelpFlag1";}
		}
		: row {
			:toggle {
					key="ActiveFilterFlag2";
					fixed_width = true;
			} 
            :edit_box {
                    key="Flag2Filter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
					label="Flag2";
            }                  
			:button {label="?";	key="HelpFlag2";}
		}
		: row {
			:toggle {
					key="ActiveFilterFlag3";
					fixed_width = true;
			} 
            :edit_box {
                    key="Flag3Filter";
                    fixed_width=true;
                    width=45;
                    edit_width=30;
					label="Flag3";
            }                  
			:button {label="?";	key="HelpFlag3";}
		}
		*/
	} 
 	ok_cancel;
}
