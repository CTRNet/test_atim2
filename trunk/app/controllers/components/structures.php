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
				
				// for RANGE values, which should be searched over with a RANGE...
				if ( $value['StructureField']['type']=='number' || $value['StructureField']['type']=='date' || $value['StructureField']['type']=='datetime' ) {
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_start' ]['plugin']	= $value['StructureField']['plugin'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_start' ]['model']		= $value['StructureField']['model'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_start' ]['field']		= $value['StructureField']['field'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_start' ]['key']			= $value['StructureField']['model'].'.'.$value['StructureField']['field'].' >=';
					
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_end' ]['plugin']		= $value['StructureField']['plugin'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_end' ]['model']			= $value['StructureField']['model'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_end' ]['field']			= $value['StructureField']['field'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_end' ]['key']				= $value['StructureField']['model'].'.'.$value['StructureField']['field'].' <=';
				}
				
				// for SELECT pulldowns, where an EXACT match is required...
				else if ( $value['StructureField']['type']=='select' ) {
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['plugin']	= $value['StructureField']['plugin'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['model']	= $value['StructureField']['model'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['field']	= $value['StructureField']['field'];
					
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['key']	= $value['StructureField']['model'].'.'.$value['StructureField']['field'];
				}
				
				// all other types, a generic SQL fragment...
				else {
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['plugin']	= $value['StructureField']['plugin'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['model']	= $value['StructureField']['model'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['field']	= $value['StructureField']['field'];
					
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['key']				= $value['StructureField']['model'].'.'.$value['StructureField']['field'].' LIKE';
				}
				
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
						
						// use Model->deconstruct method to properly build data array's date/time information from arrays
						if ( is_array($data) ) {
							
							App::import('Model', $form_fields[$model.'.'.$key]['plugin'].'.'.$model);
							// App::import('Model', 'Clinicalannotation.'.$model);
							
							$format_data_model = new $model;
							
							$data = $format_data_model->deconstruct($form_fields[$model.'.'.$key]['field'],$data);
						}
						
						// if supplied form DATA is not blank/null, add to search conditions, otehrwise skip
						if ( $data ) {
							if ( !is_array($data) && strpos($form_fields[$model.'.'.$key]['key'], ' LIKE')!==false ) {
								$data = '%'.$data.'%';
							}
							
							$conditions[ $form_fields[$model.'.'.$key]['key'] ] = $data;
						}
						
					}
					
				}
				
			}
		
		}
		
		// return CONDITIONS for search form
		return $conditions;
		
	}
	
	function parse_sql_conditions( $sql=NULL ) {
		
		$sql_with_search_terms = $sql;
		$sql_without_search_terms = $sql;
		
		foreach ( $this->controller->data as $model=>$model_value ) {
			foreach ( $model_value as $field=>$field_value ) {
				if ( is_array($field_value) ) {
					foreach ( $field_value as $k=>$v ) { $field_value[$k] = '"'.$v.'"'; }
					$field_value = implode(',',$field_value);
				}
				
				$sql_with_search_terms = str_replace( '@@'.$model.'.'.$field.'@@', $field_value, $sql_with_search_terms );
				$sql_without_search_terms = str_replace( '@@'.$model.'.'.$field.'@@', '', $sql_without_search_terms );
			}
		}
		
		// WITH
			
			// regular expression to change search over field for BLANK values to be searches over fields for BLANK OR NULL values...
			$sql_with_search_terms = preg_replace( '/([\w\.]+)\s+LIKE\s+([\||\"])\%\%\2/i', '($1 LIKE $2%%$2 OR $1 IS NULL)', $sql_with_search_terms );
			$sql_with_search_terms = preg_replace( '/([\w\.]+)\s+\=\s+([\||\"])\2/i', '($1 LIKE $2%%$2 OR $1 IS NULL)', $sql_with_search_terms );
			$sql_with_search_terms = preg_replace( '/([\w\.]+)\s+IN\s+\(\s*\)/i', '($1 LIKE "%%" OR $1 IS NULL)', $sql_with_search_terms );
			
			// regular expression to change search over DATE fields for BLANK values to be searches over fields for BLANK OR NULL values...
			$sql_with_search_terms = preg_replace( '/([\w\.]+)\s*([\>|\<]\=)\s*([\||\"])0000\-00\-00\3\s+AND\s+\1\s*([\>|\<]\=)\s*([\||\"])9999\-00\-00\3/i', '(($1$2${3}0000-00-00${3} AND $1$4${3}9999-00-00${3}) OR $1 IS NULL)', $sql_with_search_terms );
			
			// regular expression to change search over TIME fields for BLANK values to be searches over fields for BLANK OR NULL values...
			$sql_with_search_terms = preg_replace( '/([\w\.]+)\s*([\>|\<]\=)\s*([\||\"])00\:00\:00\3\s+AND\s+\1\s*([\>|\<]\=)\s*([\||\"])00\:00\:00\3/i', '(($1$2${3}00:00:00${3} AND $1$4${3}00:00:00${3}) OR $1 IS NULL)', $sql_with_search_terms );
			
			// regular expression to change search over DATE/TIME fields for BLANK values to be searches over fields for BLANK OR NULL values...
			$sql_with_search_terms = preg_replace( '/([\w\.]+)\s*([\>|\<]\=)\s*([\||\"])0000\-00\-00 00\:00\:00\3\s+AND\s+\1\s*([\>|\<]\=)\s*([\||\"])9999\-00\-00 00\:00\:00\3/i', '(($1$2${3}0000-00-00 00:00:00${3} AND $1$4${3}9999-00-00 00:00:00${3}) OR $1 IS NULL)', $sql_with_search_terms );
			
			// regular expression to change search over RANGE fields for BLANK values to be searches over fields for BLANK OR NULL values...
			$sql_with_search_terms = preg_replace( '/([\w\.]+)\s*([\>|\<]\=)\s*([\||\"])\3\s+AND\s+\1\s*([\>|\<]\=)\s*([\||\"])\3/i', '(($1$2${3}-999999${3} AND $1$4${3}999999${3}) OR $1 IS NULL)', $sql_with_search_terms );
			
		// WITHOUT
			
			// regular expression to change search over field for BLANK values to be searches over fields for BLANK OR NULL values...
			$sql_without_search_terms = preg_replace( '/([\w\.]+)\s+LIKE\s+([\||\"])\%\%\2/i', '($1 LIKE $2%%$2 OR $1 IS NULL)', $sql_without_search_terms );
			$sql_without_search_terms = preg_replace( '/([\w\.]+)\s+\=\s+([\||\"])\2/i', '($1 LIKE $2%%$2 OR $1 IS NULL)', $sql_without_search_terms );
			$sql_without_search_terms = preg_replace( '/([\w\.]+)\s+IN\s+\(\s*\)/i', '($1 LIKE "%%" OR $1 IS NULL)', $sql_without_search_terms );
			
			// regular expression to change search over DATE fields for BLANK values to be searches over fields for BLANK OR NULL values...
			$sql_without_search_terms = preg_replace( '/([\w\.]+)\s*([\>|\<]\=)\s*([\||\"])0000\-00\-00\3\s+AND\s+\1\s*([\>|\<]\=)\s*([\||\"])9999\-00\-00\3/i', '(($1$2${3}0000-00-00${3} AND $1$4${3}9999-00-00${3}) OR $1 IS NULL)', $sql_without_search_terms );
			
			// regular expression to change search over TIME fields for BLANK values to be searches over fields for BLANK OR NULL values...
			$sql_without_search_terms = preg_replace( '/([\w\.]+)\s*([\>|\<]\=)\s*([\||\"])00\:00\:00\3\s+AND\s+\1\s*([\>|\<]\=)\s*([\||\"])00\:00\:00\3/i', '(($1$2${3}00:00:00${3} AND $1$4${3}00:00:00${3}) OR $1 IS NULL)', $sql_without_search_terms );
			
			// regular expression to change search over DATE/TIME fields for BLANK values to be searches over fields for BLANK OR NULL values...
			$sql_without_search_terms = preg_replace( '/([\w\.]+)\s*([\>|\<]\=)\s*([\||\"])0000\-00\-00 00\:00\:00\3\s+AND\s+\1\s*([\>|\<]\=)\s*([\||\"])9999\-00\-00 00\:00\:00\3/i', '(($1$2${3}0000-00-00 00:00:00${3} AND $1$4${3}9999-00-00 00:00:00${3}) OR $1 IS NULL)', $sql_without_search_terms );
			
			// regular expression to change search over RANGE fields for BLANK values to be searches over fields for BLANK OR NULL values...
			$sql_without_search_terms = preg_replace( '/([\w\.]+)\s*([\>|\<]\=)\s*([\||\"])\3\s+AND\s+\1\s*([\>|\<]\=)\s*([\||\"])\3/i', '(($1$2${3}-999999${3} AND $1$4${3}999999${3}) OR $1 IS NULL)', $sql_without_search_terms );
			
		// return BOTH	
		return array( $sql_with_search_terms, $sql_without_search_terms );
		
	}

}

?>