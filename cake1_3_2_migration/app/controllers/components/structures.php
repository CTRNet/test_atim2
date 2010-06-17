<?php

class StructuresComponent extends Object {
	
	var $controller;
	
	function initialize( &$controller, $settings=array() ) {
		$this->controller =& $controller;
	}
	
	/* Combined function to simplify plugin usage, 
	 * sets validation for models AND sets atim_structure for view
	 * 
	 * @param $alias Form alias of the new structure
	 * @param $structure_name Structure name (by default name will be 'atim_structure')
	 */
	function set( $alias=NULL, $structure_name = 'atim_structure' ) {
		foreach ( $this->get('rules', $alias) as $model=>$rules ) $this->controller->{ $model }->validate = $rules;
		$this->controller->set( $structure_name, $this->get('form', $alias) );
	}
	
	function get( $mode=NULL, $alias=NULL ) {
		$return = array();
		$mode		= strtolower($mode);
		$alias	= $alias ? strtolower($alias) : str_replace('_','',$this->controller->params['controller']);
		
		$structure_cache_directory = "../tmp/cache/structures/";
		$fname = $structure_cache_directory.$mode.".".$alias.".cache";
		if(file_exists($fname) && Configure::read('ATiMStructureCache.disable') != 1){
			$fhandle = fopen($fname, 'r');
			$return = unserialize(fread($fhandle, filesize($fname)));
			fclose($fhandle);
		}else{
			if(Configure::read('ATiMStructureCache.disable')){
				//clear structure cache
				try{
					if ($dh = opendir($structure_cache_directory)) {
				        while (($file = readdir($dh)) !== false) {
				            if(filetype($structure_cache_directory . $file) == "file"){
				            	unlink($structure_cache_directory . $file);
				            }
				        }
				        closedir($dh);
				    }
				}catch(Exception $e){
					//do nothing, it's a race condition with someone else
				}
			}
			if ( $alias ) {
				
				App::import('model', 'Structure');
				$this->Component_Structure = new Structure;
				
				$result = $this->Component_Structure->find(
								( ( $mode=='rule' || $mode=='rules' ) ? 'rules' : 'first'), 
								array(
									'conditions'	=>	array( 'Structure.alias' => $alias ), 
									'recursive'		=>	5
								)
				);
				
				if ( $result ) $return = $result;
			}
			if(Configure::read('ATiMStructureCache.disable') != 1){
				$fhandle = fopen($fname, 'w');
				fwrite($fhandle, serialize($return));
				flush();
				fclose($fhandle);
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
				if ( $value['StructureField']['type']=='number'
				|| $value['StructureField']['type']=='integer'
				|| $value['StructureField']['type']=='integer_positive'
				|| $value['StructureField']['type']=='float'
				|| $value['StructureField']['type']=='float_positive' 
				|| $value['StructureField']['type']=='date' 
				|| $value['StructureField']['type']=='datetime' ) {
					
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_start' ]['plugin']		= $value['StructureField']['plugin'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_start' ]['model']		= $value['StructureField']['model'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_start' ]['field']		= $value['StructureField']['field'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_start' ]['key']			= $value['StructureField']['model'].'.'.$value['StructureField']['field'].' >=';
					
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_end' ]['plugin']			= $value['StructureField']['plugin'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_end' ]['model']			= $value['StructureField']['model'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_end' ]['field']			= $value['StructureField']['field'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'].'_end' ]['key']				= $value['StructureField']['model'].'.'.$value['StructureField']['field'].' <=';
				}
				
				// for SELECT pulldowns, where an EXACT match is required, OR passed in DATA is an array to use the IN SQL keyword
				else if ( $value['StructureField']['type']=='select' || ( isset($this->controller->data[ $value['StructureField']['model'] ][ $value['StructureField']['field'] ]) && is_array($this->controller->data[ $value['StructureField']['model'] ][ $value['StructureField']['field'] ]) ) ) {
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['plugin']	= $value['StructureField']['plugin'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['model']	= $value['StructureField']['model'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['field']	= $value['StructureField']['field'];
					
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['key']		= $value['StructureField']['model'].'.'.$value['StructureField']['field'];
				}
				
				// all other types, a generic SQL fragment...
				else {
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['plugin']	= $value['StructureField']['plugin'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['model']	= $value['StructureField']['model'];
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['field']	= $value['StructureField']['field'];
					
					$form_fields[ $value['StructureField']['model'].'.'.$value['StructureField']['field'] ]['key']		= $value['StructureField']['model'].'.'.$value['StructureField']['field'].' LIKE';
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
						
						// if CSV file uploaded...
						if ( is_array($data) && isset($this->controller->data[$model][$key.'_with_file_upload']) && $this->controller->data[$model][$key.'_with_file_upload']['tmp_name'] ) {
							
							// set $DATA array based on contents of uploaded FILE
							$handle = fopen($this->controller->data[$model][$key.'_with_file_upload']['tmp_name'], "r");
							
							// in each LINE, get FIRST csv value, and attach to DATA array
							while (($csv_data = fgetcsv($handle, 1000, csv_separator, '"')) !== FALSE) {
							    $data[] = $csv_data[0];
							}
							
							fclose($handle);
							
							unset($this->controller->data[$model][$key.'_with_file_upload']);
							
						}
						
						// use Model->deconstruct method to properly build data array's date/time information from arrays
						if ( is_array($data) ) {
							
							App::import('Model', $form_fields[$model.'.'.$key]['plugin'].'.'.$model);
							// App::import('Model', 'Clinicalannotation.'.$model);
							
							$format_data_model = new $model;
							
							$data = $format_data_model->deconstruct($form_fields[$model.'.'.$key]['field'],$data);
							
							if ( is_array($data) ) {
								$data = array_unique($data);
								$data = array_filter($data);
							}
							
							if ( !count($data) ) $data = '';
						}
						
						// if supplied form DATA is not blank/null, add to search conditions, otherwise skip
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
	
	function parse_sql_conditions( $sql=NULL, $conditions=NULL ) {
		$sql_with_search_terms = $sql;
		$sql_without_search_terms = $sql;
		if($conditions === null){
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
		}else{
			foreach($conditions as $model_field => $field_value_arr){
				if(sizeof($field_value_arr) > 1){
					//expand query for OR
					$matches = array();
					preg_match_all("/[\w\.\`]+[\s]+(LIKE|=)[\s]+\"@@".$model_field."@@\"/", $sql_with_search_terms, $matches, PREG_OFFSET_CAPTURE);
					//start with the end
					$matches[0] = array_reverse($matches[0]);
					foreach($matches[0] as $match){
						$str = "";
						foreach($field_value_arr as $field_value){
							$str .= str_replace('@@'.$model_field.'@@', $field_value, $match[0])." OR ";
						}
						$str = "(".substr($str, 0, -4).")";
						$sql_with_search_terms = substr($sql_with_search_terms, 0, $match[1]).$str.substr($sql_with_search_terms, $match[1] + strlen($match[0]));
					}
				}else{
					$sql_with_search_terms = str_replace( '@@'.$model_field.'@@', $field_value_arr[0], $sql_with_search_terms );
				}
				$sql_without_search_terms = str_replace( '@@'.$model_field.'@@', '', $sql_without_search_terms );
			}
		}
			//whipe what wasn't replaced
			//range
			$sql_with_search_terms = preg_replace('/(\>|\<)\=\s*"@@[\w\.]+@@"/i', "$1= \"\"", $sql_with_search_terms);
			$sql_without_search_terms = preg_replace('/(\>|\<)\=\s*"@@[\w\.]+@@"/i', "1= \"\"", $sql_without_search_terms);
			
			//LIKE
			$sql_with_search_terms = preg_replace('/LIKE\s*"@@[\w\.]+@@"/i', "LIKE \"%%\"", $sql_with_search_terms);
			$sql_without_search_terms = preg_replace('/LIKE\s*"@@[\w\.]+@@"/i', "LIKE \"%%\"", $sql_without_search_terms);
			
			//others
			$sql_with_search_terms = preg_replace('/"@@[\w\.]+@@"/i', "\"\"", $sql_with_search_terms);
			$sql_without_search_terms = preg_replace('/"@@[\w\.]+@@"/i', "\"\"", $sql_without_search_terms);
		
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
			$sql_with_search_terms = preg_replace( '/([\w\.]+)\s*\>\=\s*([\||\"])\2/i', '(($1 >= ${2}-999999${2}) OR $1 IS NULL)', $sql_with_search_terms);
			$sql_with_search_terms = preg_replace( '/([\w\.]+)\s*\<\=\s*([\||\"])\2/i', '(($1 <= ${2}999999${2}) OR $1 IS NULL)', $sql_with_search_terms);
			
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