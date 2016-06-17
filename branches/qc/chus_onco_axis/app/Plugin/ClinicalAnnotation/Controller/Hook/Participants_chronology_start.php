<?php 
	
	$Drug = AppModel::getInstance("Drug", "Drug", true);
	$all_drugs = $Drug->getDrugPermissibleValues();
	
	// **** Diagnosis ****
	
	$chus_secondary_icd10_codes = $this->DiagnosisMaster->getSecondaryIcd10Codes();
		
	// *** Treatment ***
	
	$this->TreatmentExtendMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentExtendMaster", true);
	