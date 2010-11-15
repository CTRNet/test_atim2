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
	
	function summary( $variables=array() ) {
		$return = false;
		
		if (isset($variables['Structure.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Structure.id'=>$variables['Structure.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, $result['Structure']['alias'] ),
					'title'			=>	array( NULL, $result['Structure']['alias'] ),
					
					'description'	=>	array(
						'id'			=>	$result['Structure']['id'],
						'title'		=>	$result['Structure']['language_title'],
						'help'		=>	$result['Structure']['language_help'],
						'created'	=>	$result['Structure']['created']
					)
				)
			);
		}
		
		return $return;
	}
	
	function find($conditions = null, $fields = array(), $order = null, $recursive = null) {
		$result = parent::find(( ($conditions=='rule' || $conditions=='rules') ? 'first' : $conditions ), $fields, $order, $recursive);
		if($result){
			$fields_ids = array(0);
			if($this->simple && isset($result['Sfs'])){
				//if recursive = -1, there is no Sfs
				foreach($result['Sfs'] as $sfs ){
					$fields_ids[] = $sfs['structure_field_id'];
				}
				$validations = $this->StructureValidation->find('all', array('conditions' => ('StructureValidation.structure_field_id IN('.implode(", ", $fields_ids).')')));
				foreach($validations as $validation){
					foreach ($result['Sfs'] as &$sfs ){
						if($sfs['structure_field_id'] == $validation['StructureValidation']['structure_field_id']){
							$sfs['StructureValidation'][] = $validation['StructureValidation'];
						}
					}
					unset($sfs);
				}
			}
			
			if($conditions=='rule' || $conditions=='rules'){
				//TODO: do not load this when not in add/edit mode
				$return = array();
				
				foreach ($result[$this->simple ? 'Sfs' : 'StructureFormat'] as $sf){
					if (!isset($return[$sf['model']])){
						$return[$sf['model']] = array();
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
						$tmp_msg = "this is not a datetime";
					}else if($tmp_type == "date"){
						$tmp_rule = "date";
						$tmp_msg = "this is not a date";
					}
					if($tmp_rule != NULL){
						$sf['StructureValidation'][] = array(
							'structure_field_id' => $sf['structure_field_id'],
							'rule' => $tmp_rule, 
							'flag_required' => false, 
							'flag_not_empty' => false,
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
						
						if($validation['flag_not_empty']){
							$rule[] = 'notEmpty';
						}

						if(count($rule) == 1){
							$rule = $rule[0];
						}else if(count($rule) == 0){
							if(Configure::read('debug') > 0){
								AppController::addWarningMsg(sprintf(__("the validation with id [%d] is invalid. a rule and/or a flag_not_empty must be defined", true), $validation['id']));
							}
							continue;
						}
						
						
						$rule_array = array(
							'rule' => $rule,
							'allowEmpty' => !$validation['flag_not_empty'],
							'required' => $validation['flag_required'] ? true : false
						);
						
						if($validation['on_action']){
							$rule_array['on'] = $validation['on_action'];
						}
						if($validation['language_message']){
							$rule_array['message'] = $validation['language_message'];
						}
						
						if (!isset($return[ $sf['model']][$sf['field']])){
							$return[$sf['model']][$sf['field']] = array();
						}
						
						$return[$sf['model']][$sf['field']][] = $rule_array;
						
					}
				}
				
				return $return;
			}
		}
		
		return $result;
	}

}

?>