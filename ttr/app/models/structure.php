<?php

class Structure extends AppModel {

	var $name = 'Structure';
	var $actsAs = array('Containable');

	var $hasMany = array(
		'StructureFormat' => array('order' => 'StructureFormat.display_column ASC, StructureFormat.display_order ASC'), 
		'Sfs' => array('order' => 'Sfs.display_column ASC, Sfs.display_order ASC')
	);
	
	private $simple = true;
	
	function __construct(){
		parent::__construct();
		$this->setModeSimplified();
	}
	
	function setModeComplete(){
		$this->contain(array('StructureFormat' => array('StructureField' => array('StructureValidation', 'StructureValueDomain'))));
		$this->simple = false;
	}
	
	function setModeSimplified(){
		$this->contain(array('Sfs' => array('StructureValidation', 'StructureValueDomain')));
		$this->StructureValidation = new StructureValidation();
		$this->simple = true;
	}
	
	function find($conditions = null, $fields = array(), $order = null, $recursive = null) {
		
		$structure = parent::find('first', $fields, $order, $recursive);
		$rules = array();
		if($structure){
			$fields_ids = array(0);
			if($this->simple && isset($structure['Sfs'])){
				//if recursive = -1, there is no Sfs
				foreach($structure['Sfs'] as $sfs ){
					$fields_ids[] = $sfs['structure_field_id'];
				}
				$validations = $this->StructureValidation->find('all', array('conditions' => ('StructureValidation.structure_field_id IN('.implode(", ", $fields_ids).')')));
				foreach($validations as $validation){
					foreach ($structure['Sfs'] as &$sfs ){
						if($sfs['structure_field_id'] == $validation['StructureValidation']['structure_field_id']){
							$sfs['StructureValidation'][] = $validation['StructureValidation'];
						}
					}
					unset($sfs);
				}
			}
			
			$rules = array();

			if(($this->simple && isset($structure['Sfs'])) || (!$this->simple && isset($structure['StructureFormat']))){
				foreach ($structure[$this->simple ? 'Sfs' : 'StructureFormat'] as $sf){
					$auto_validation = isset(AppModel::$auto_validation[$sf['model']]) ? AppModel::$auto_validation[$sf['model']] : array(); 
					if (!isset($rules[$sf['model']])){
						$rules[$sf['model']] = array();
					}
					$tmp_type = $sf['type'];
					$tmp_rule = NULL;
					$tmp_msg = NULL;
					if($tmp_type == "integer"){
						$tmp_rule = VALID_INTEGER;
						$tmp_msg = "error_must_be_integer";
					}else if($tmp_type == "integer_positive"){
						$tmp_rule = VALID_INTEGER_POSITIVE;
						$tmp_msg = "error_must_be_positive_integer";
					}else if($tmp_type == "float" || $tmp_type == "number"){
						$tmp_rule = VALID_FLOAT;
						$tmp_msg = "error_must_be_float";
					}else if($tmp_type == "float_positive"){
						$tmp_rule = VALID_FLOAT_POSITIVE;
						$tmp_msg = "error_must_be_positive_float";
					}else if($tmp_type == "datetime"){
						$tmp_rule = VALID_DATETIME_YMD;
						$tmp_msg = "invalid datetime";
					}else if($tmp_type == "date"){
						$tmp_rule = "date";
						$tmp_msg = "invalid date";
					}else if($tmp_type == "time"){
						$tmp_rule = VALID_24TIME;
						$tmp_msg = "this is not a time";
					}
					if($tmp_rule != NULL){
						$sf['StructureValidation'][] = array(
							'structure_field_id' => $sf['structure_field_id'],
							'rule' => $tmp_rule, 
							'on_action' => NULL,
							'language_message' => $tmp_msg);
					}
					if(!$this->simple){
						$sf['StructureValidation'] = array_merge($sf['StructureValidation'], $sf['StructureField']['StructureValidation']);
					}
	
					foreach ( $sf['StructureValidation'] as $validation ) {
						$rule = array();
						if(($validation['rule'] == VALID_FLOAT) || ($validation['rule'] == VALID_FLOAT_POSITIVE)) {
							// To support coma as decimal separator
							$rule[0] = $validation['rule'];
						}else if(strlen($validation['rule']) > 0){
							$rule = split(',',$validation['rule']);
						}
						
						if(count($rule) == 1){
							$rule = $rule[0];
						}else if(count($rule) == 0){
							if(Configure::read('debug') > 0){
								AppController::addWarningMsg(sprintf(__("the validation with id [%d] is invalid. a rule must be defined", true), $validation['id']));
							}
							continue;
						}
						
						
						$rule_array = array(
							'rule' => $rule,
							'allowEmpty' => $rule != 'notEmpty'
						);
						
						if($validation['on_action']){
							$rule_array['on'] = $validation['on_action'];
						}
						if($validation['language_message']){
							$rule_array['message'] = __($validation['language_message'], true);
						}else if($rule_array['rule'] == 'notEmpty'){
							$rule_array['message'] = __("this field is required", true);
						}
				
						if(strlen($sf['language_label']) > 0 && isset($rule_array['message'])){
							$rule_array['message'] .= " (".__($sf['language_label'], true).")";
						}
						
						if (!isset($rules[ $sf['model']][$sf['field']])){
							$rules[$sf['model']][$sf['field']] = array();
						}
						
						$rules[$sf['model']][$sf['field']][] = $rule_array;
					}
					
					if(isset($auto_validation[$sf['field']])){
						foreach($auto_validation[$sf['field']] as $rule_array){
							$rule_array['message'] .= " (".__($sf['language_label'], true).")";
							$rules[$sf['model']][$sf['field']][] = $rule_array;
						}
					}
				}
			}
		}
		
		return array('structure' => $structure, 'rules' => $rules);
	}

}

?>