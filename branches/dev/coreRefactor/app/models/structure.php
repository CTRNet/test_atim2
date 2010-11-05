<?php

class Structure extends AppModel {

	var $name = 'Structure';
	var $actsAs = array('Containable');

	var $hasMany = array('StructureFormat', 'Sfs');
	
	function __construct(){
		parent::__construct();
		$this->setModeSimplified();
	}
	
	function setModeComplete(){
		$this->contain(array('StructureFormat' => array('StructureField' => array('StructureValidation', 'StructureValueDomain'))));
	}
	
	function setModeSimplified(){
		$this->contain(array('Sfs' => array('StructureValidation', 'StructureValueDomain')));
	}
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Structure.id']) ) {
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
		$result = parent::find(( ($conditions=='rule' || $conditions=='rules') ? 'first' : $conditions ),$fields,$order,$recursive);
		
		if ( $result ) {
			if ( $conditions=='rule' || $conditions=='rules' ) {
				$return = array();
				foreach ( $result['Sfs'] as $sfs  ) {
					if ( !isset($return[ $sfs['model'] ]) ) {
						$return[ $sfs['model'] ] = array();
					}
					$tmp_type = $sfs['type'];
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
						$structure_format['StructureField']['StructureValidation'][] = array(
							'structure_field_id' => $sfs['structure_field_id'],
							'rule' => $tmp_rule, 
							'flag_empty' => 1, 
							'flag_required' => 0, 
							'on_action' => NULL,
							'language_message' => $tmp_msg);
					}

					foreach ( $sfs['StructureValidation'] as $validation ) {
						$rule = array();
						if(($validation['rule'] == VALID_FLOAT) || ($validation['rule'] == VALID_FLOAT_POSITIVE)) {
							// To support coma as decimal separator
							$rule[0] = $validation['rule'];
						} else {
							$rule = split(',',$validation['rule']);
						}
						
						if(count($rule) == 1){
							$rule = $rule[0];
						}
						
						$allow_empty =  $validation['flag_empty'] ? true : false;
						$required = $validation['flag_required'] ? true : false;
						$on_action = $validation['on_action'];
						$language_message =  $validation['language_message'];
						
						$rule_array = array(
							'rule' => $rule,
							'allowEmpty' => $allow_empty,
							'required' => $required,
						);
						
						if($on_action) $rule_array['on'] = $on_action;
						if($language_message) $rule_array['message'] = $language_message;
						
						if ( !isset($return[ $sfs['model'] ][ $sfs['field'] ]) ) {
							$return[ $sfs['model'] ][ $sfs['field'] ] = array();
						}
						
						$return[ $sfs['model'] ][ $sfs['field'] ][] = $rule_array;
						
					}
				}
				
				return $return;
			}
		}
		
		return $result;
	}

}

?>