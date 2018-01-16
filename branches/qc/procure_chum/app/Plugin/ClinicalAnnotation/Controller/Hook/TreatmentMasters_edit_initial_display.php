<?php 
	
	$Drug_model = AppModel::getInstance("Drug", "Drug", true);
	$this->request->data['FunctionManagement']['autocomplete_treatment_drug_id'] = $Drug_model->getDrugDataAndCodeForDisplay(array('Drug' => array('id' => $this->request->data['TreatmentMaster']['procure_drug_id'])));
	
	AppController::addWarningMsg("procure_dose_frequence_change_warning");
	