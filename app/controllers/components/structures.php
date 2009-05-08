<?php

class StructuresComponent extends Object {
	
	var $controller;
	
	function initialize( &$controller, $settings=array() ) {
		$this->controller =& $controller;
	}
	
	function get( $mode=NULL, $alias=NULL ) {
		
		$return = array();
		$mode		= strtolower($mode);
		$alias	= $alias ? strtolower($alias) : str_replace('_','',$this->controller->params['controller']);
		
		if ( $alias ) {
			
			App::import('model', 'Structure');
			$this->Component_Structure =& new Structure;
			
			$result = $this->Component_Structure->find(
							'first', 
							array(
								'conditions'	=>	array( 'Structure.alias' => $alias ), 
								'recursive'		=>	5
							)
			);
			
			if ( $result ) {
				
				if ( $mode=='rule' || $mode=='rules' ) {
					
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
					
				}
				
				else {
					$return = $result;
				}
			}
		}
		
		return $return;
		
	}
	
	function parse_search_conditions( $atim_structure=NULL ) {
		
		// conditions to ultimately return
		$conditions = array();
		
		// general search format, after parsing STRUCTURE
		$form_fields = array();
		
		// if no STRUCTURE provided, try and get one
		if ( $atim_structure===NULL ) $atim_structure = $this->get();
		
		// format structure data into SEARCH CONDITONS format
		if ( isset($atim_structure['StructureFormat']) ) {
			foreach ( $atim_structure['StructureFormat'] as $value ) {
				
				// default field types, use LIKE
				$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['key']				= $value['StructureField']['model'].'.'.$value['StructureField']['field'].' LIKE';
				$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['condition']		= '%@@SEARCHTERM@@%';
				
			}
		}
		
		// parse DATA to generate SQL conditions
		// use ONLY the form_fields array values IF data for that MODEL.KEY combo was provided
		foreach ( $this->controller->data as $model=>$fields ) {
			foreach ( $fields as $key=>$data ) {
				
				// if MODEL data was passed to this function, use it to generate SQL criteria...
				if ( count($form_fields) ) {
					
					// add search element to CONDITIONS array if not blank & MODEL data included Model/Field info...
					if ( $data && isset( $form_fields[$model.'.'.$key] ) ) {
						
						// if DATA is an array, assume working with IN SQL
						if ( $form_fields[$model.'.'.$key]['key'] && is_array($data) ) {
							$form_fields[$model.'.'.$key]['key'] = str_replace( ' LIKE', ' IN', $form_fields[$model.'.'.$key]['key'] );
							$conditions[ $form_fields[$model.'.'.$key]['key'] ] = $data;
						}
						
						// else, default to LIKE
						else if ( $form_fields[$model.'.'.$key]['key'] ) {
							$conditions[ $form_fields[$model.'.'.$key]['key'] ] = str_replace( '@@SEARCHTERM@@', $data, $form_fields[$model.'.'.$key]['condition'] );
						}
						
					}
					
				}
				
			}
		}
		
		// return CONDITIONS for search form
		return $conditions;
		
	}

}

?>