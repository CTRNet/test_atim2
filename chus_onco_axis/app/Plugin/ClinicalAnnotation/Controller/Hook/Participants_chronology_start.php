<?php 
	
	$Drug = AppModel::getInstance("Drug", "Drug", true);
	$all_drugs = $Drug->getDrugPermissibleValues();
		
	$this->TreatmentExtendMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentExtendMaster", true);
	$this->CodingIcdo3Topo = AppModel::getInstance("CodingIcd", "CodingIcdo3Topo", true);
	