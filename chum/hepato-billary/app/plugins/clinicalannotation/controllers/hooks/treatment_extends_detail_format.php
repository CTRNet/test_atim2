<?php

//NL Revised

// --------------------------------------------------------------------------------
	// Add menu information
	// --------------------------------------------------------------------------------
	switch($tx_master_data['TreatmentControl']['extend_form_alias']) {
		case 'txe_chemos':
			$this->viewVars['atim_menu_variables']['TreatmentExtend.menu_precision'] = 'drugs';
			break;
		case 'qc_hb_txe_surgery_complications':
			$this->viewVars['atim_menu_variables']['TreatmentExtend.menu_precision'] = 'complications';
			break;
		default:
	}	
		
?>