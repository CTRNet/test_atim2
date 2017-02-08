<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';
	
	var $belongsTo = array(
		'TreatmentControl' => array(            
				'className'    => 'ClinicalAnnotation.TreatmentControl',            
				'foreignKey'    => 'treatment_control_id'), 
			'Drug' => array(
					'className'    => 'Drug.Drug',
					'foreignKey'    => 'procure_drug_id'));
	
	private $tx_method_for_data_entry_validation = null;
	
	public static $drug_model = null;
	
	function setTxMethodForDataEntryValidation($tx_method_for_data_entry_validation) {
		$this->tx_method_for_data_entry_validation = $tx_method_for_data_entry_validation;
	}
	
	function validates($options = array()){
		$result = parent::validates($options);
		
		$treatment_data =& $this->data;
		
		// Validate and set procure_drug_id
		
		$tmp_arr_to_check = array_values($treatment_data);
		if((!is_array($treatment_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['TreatmentExtendMaster']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		if(array_key_exists('FunctionManagement', $treatment_data) && array_key_exists('autocomplete_treatment_drug_id', $treatment_data['FunctionManagement'])) {
			$treatment_data['TreatmentMaster']['procure_drug_id'] = null;
			$treatment_data['FunctionManagement']['autocomplete_treatment_drug_id'] = trim($treatment_data['FunctionManagement']['autocomplete_treatment_drug_id']);
			if(strlen($treatment_data['FunctionManagement']['autocomplete_treatment_drug_id'])) {
				// Load model
				if(self::$drug_model == null) self::$drug_model = AppModel::getInstance("Drug", "Drug", true);
					
				// Check the treatment extend drug definition
				$arr_drug_selection_results = self::$drug_model->getDrugIdFromDrugDataAndCode($treatment_data['FunctionManagement']['autocomplete_treatment_drug_id']);
		
				if(isset($arr_drug_selection_results['Drug'])){
					//Check drug can be associated to treatment
					if($arr_drug_selection_results['Drug']['type'] != $this->data['TreatmentDetail']['treatment_type']){
						$result = false;
						$this->validationErrors['autocomplete_treatment_drug_id'][] = __('the type of the selected drug does not match the selected treatment type');
					} else {
						// Set drug id
						$treatment_data['TreatmentMaster']['procure_drug_id'] = $arr_drug_selection_results['Drug']['id'];
						$this->addWritableField(array('procure_drug_id'));
					}
				} else if(isset($arr_drug_selection_results['error'])){
					// Set error
					$this->validationErrors['autocomplete_treatment_drug_id'][] = $arr_drug_selection_results['error'];
					$result = false;
				} else {
					AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
			}
		
		}
		
		if(array_key_exists('TreatmentDetail', $this->data)) {
			$field_controls = array(
				'treatment_line' => array(
					'line', 
					array('chemotherapy', 'experimental treatment', 'hormonotherapy'), 
					__('chemotherapy').' & '. __('experimental treatment').' & '. __('hormonotherapy')),
				'surgery_type' => array(
					'surgery detail', 
					array('surgery'), 
					__('surgery')),
				'treatment_site' => array(
					'site', 
					array('antalgic radiotherapy', 'radiotherapy', 'brachytherapy', 'surgery'), 
					__('antalgic radiotherapy').' & '.__('radiotherapy').' & '. __('brachytherapy').' & '. __('surgery')));
			foreach($field_controls as $fied => $fied_data) {;
				list($field_label, $tx_types, $msg) = $fied_data;
				if(array_key_exists($fied, $this->data['TreatmentDetail']) && $this->data['TreatmentDetail'][$fied]) {
					if(!in_array($this->data['TreatmentDetail']['treatment_type'], $tx_types)) {
						$result = false;
						$this->validationErrors[$fied][] = __('field [%s] can only be completed for following treatment(s) : %s', __($field_label), $msg);
					}
				}
			}
		}
		
		return $result;
	}
	
	function beforeSave($options = array()){
		if(Configure::read('procure_atim_version') != 'BANK') AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		return parent::beforeSave($options);
	}
}

?>