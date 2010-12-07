<?php

class DiagnosisMaster extends ClinicalannotationAppModel {
	var $belongsTo = array(        
		'DiagnosisControl' => array(            
		'className'    => 'Clinicalannotation.DiagnosisControl',            
		'foreignKey'    => 'diagnosis_control_id'
		),
	);
	
	var $hasOne = array(
		'ClinicalCollectionLink' => array(
			'className' => 'Clinicalannotation.ClinicalCollectionLink',
			'foreignKey' => 'diagnosis_master_id'));
	
	function summary( $variables=array() ) {
		$return = false;
		if ( isset($variables['DiagnosisMaster.id']) ) {
			$result = $this->find('first', array('conditions'=>array('DiagnosisMaster.id'=>$variables['DiagnosisMaster.id'])));
			
			$return = array(
				'Summary'	 => array(
					'menu' => array(NULL, __($result['DiagnosisControl']['controls_type'], TRUE)),
					'title' => array(NULL, __('diagnosis', TRUE)),
					'description' => array(
						__('nature', TRUE) => __($result['DiagnosisMaster']['dx_nature'], TRUE),
						__('origin', TRUE) => __($result['DiagnosisMaster']['dx_origin'], TRUE),
						__('date', TRUE) => $result['DiagnosisMaster']['dx_date'],
						__('method', TRUE) => __($result['DiagnosisMaster']['dx_method'], TRUE)
					)
				)
			);
			
		}
		return $return;
	}
	
	/**
	 * Replaces icd10 empty string to null values to respect foreign keys constraints
	 * @param $participantArray
	 */
	function patchIcd10NullValues(&$participantArray){
		if(strlen(trim($participantArray['DiagnosisMaster']['primary_icd10_code'])) == 0){
			$participantArray['DiagnosisMaster']['primary_icd10_code'] = null;
		}
	}

	function getMorphologyValues(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM coding_icdo3_tissue") as $icdo3){
			$result[] = array("value" => $icdo3['coding_icdo3_tissue']['val'], "default" => $icdo3[0]['default']);
		}
		return $result;
	}

	function getMorphBloodValues(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM coding_icdo3_blood") as $icdo3blood){
			$result[] = array("value" => $icdo3blood['coding_icdo3_blood']['val'], "default" => $icdo3blood[0]['default']);
		}
		return $result;
	}

	function getICD9Values(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM coding_icd9") as $icd9){
			$result[] = array("value" => $icd9['coding_icd9']['val'], "default" => $icd9[0]['default']);
		}
		return $result;
	}
	function getICDOTOPOValues(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM coding_icdotopo") as $icdotopo){
			$result[] = array("value" => $icdotopo['coding_icdotopo']['val'], "default" => $icdotopo[0]['default']);
		}
		return $result;
	}
	function getICD10Values(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM coding_icd10v2") as $icd10v2){
			$result[] = array("value" => $icd10v2['coding_icd10v2']['val'], "default" => $icd10v2[0]['default']);
		}
		return $result;
	}

	function geticd10bloodValues(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM icd10_blood") as $icd10blood){
			$result[] = array("value" => $icd10blood['icd10_blood']['val'], "default" => $icd10blood[0]['default']);
		}
		return $result;
	}
	function getCCIValues(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM coding_cci") as $cci){
			$result[] = array("value" => $cci['coding_cci']['val'], "default" => $cci[0]['default']);
		}
		return $result;
	}
	function getTXICD9Values(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM coding_txicd9") as $txicd9){
			$result[] = array("value" => $txicd9['coding_txicd9']['val'], "default" => $txicd9[0]['default']);
		}
		return $result;
	}
	function getFamHxIcd10Values(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM coding_famhx_icd10") as $famhxicd10){
			$result[] = array("value" => $famhxicd10['coding_famhx_icd10']['val'], "default" => $famhxicd10[0]['default']);
		}
		return $result;
	}

	function getDeathIcd10Values(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM coding_death_icd10") as $deathicd10){
			$result[] = array("value" => $deathicd10['coding_death_icd10']['val'], "default" => $deathicd10[0]['default']);
		}
		return $result;
	}
	function getDeathIcd9Values(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM coding_death_icd9") as $deathicd9){
			$result[] = array("value" => $deathicd9['coding_death_icd9']['val'], "default" => $deathicd9[0]['default']);
		}
		return $result;
	}
	function getCCIRadsValues(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM cci_rads") as $ccirads){
			$result[] = array("value" => $ccirads['cci_rads']['val'], "default" => $ccirads[0]['default']);
		}
		return $result;
	}
	function getCCISurgeryValues(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM cci_surgery") as $ccisurgery){
			$result[] = array("value" => $ccisurgery['cci_surgery']['val'], "default" => $ccisurgery[0]['default']);
		}
		return $result;
	}
	function getCCIHormonalValues(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM cci_hormonal") as $ccihorm){
			$result[] = array("value" => $ccihorm['cci_hormonal']['val'], "default" => $ccihorm[0]['default']);
		}
		return $result;
	}
	function getCCIChemoValues(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM cci_chemo") as $ccichemo){
			$result[] = array("value" => $ccichemo['cci_chemo']['val'], "default" => $ccichemo[0]['default']);
		}
		return $result;
	}
	function getCCIBrachyValues(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM cci_brachy") as $ccibrachy){
			$result[] = array("value" => $ccibrachy['cci_brachy']['val'], "default" => $ccibrachy[0]['default']);
		}
		return $result;
	}
	function getCCIImmunoValues(){
		$result = array();
		foreach($this->query("SELECT code AS val, CONCAT(code, ' - ', en_desc) AS `default` FROM cci_immuno") as $cciimmuno){
			$result[] = array("value" => $cciimmuno['cci_immuno']['val'], "default" => $cciimmuno[0]['default']);
		}
		return $result;
	}


}
?>