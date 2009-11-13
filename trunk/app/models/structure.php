<?php

class Structure extends AppModel {

	var $name = 'Structure';

	var $hasMany = array('StructureFormat');
	
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
				
				foreach ( $result['StructureFormat'] as $structure_format  ) {
					
					if ( !isset($return[ $structure_format['StructureField']['model'] ]) ) {
						$return[ $structure_format['StructureField']['model'] ] = array();
					}
					
					foreach ( $structure_format['StructureField']['StructureValidation'] as $validation ) {
						
						$rule = split(',',$validation['rule']);
							if(count($rule) == 1) $rule = $rule[0];
						
						$allow_empty =  $validation['flag_empty'] ? true : false;
						$required = $validation['flag_required'] ? true : false;
						$on_action = $validation['on_action'];
						$language_message =  $validation['language_message'];
						
						$rule_array = array(
							'rule' => $rule,
							'allow_empty' => $allow_empty,
							'required' => $required,
						);
						
						if($on_action) $rule_array['on'] = $on_action;
						if($language_message) $rule_array['message'] = $language_message;
						
						if ( !isset($return[ $structure_format['StructureField']['model'] ][ $structure_format['StructureField']['field'] ]) ) {
							$return[ $structure_format['StructureField']['model'] ][ $structure_format['StructureField']['field'] ] = array();
						}
						
						$return[ $structure_format['StructureField']['model'] ][ $structure_format['StructureField']['field'] ][] = $rule_array;
						
					}
				}
				
				return $return;
			}
		}
		
		return $result;
	}

}

?>