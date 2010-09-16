<?php

class StructuresComponent extends Object {
	
	var $controller;
	static $singleton;
	
	function initialize( &$controller, $settings=array() ) {
		$this->controller =& $controller;
		StructuresComponent::$singleton = $this;
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
				fflush($fhandle);
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
				//it includes numbers, dates, and fields fith the "range" setting. For the later, value  _start
				if ( $value['StructureField']['type']=='number'
				|| $value['StructureField']['type']=='integer'
				|| $value['StructureField']['type']=='integer_positive'
				|| $value['StructureField']['type']=='float'
				|| $value['StructureField']['type']=='float_positive' 
				|| $value['StructureField']['type']=='date' 
				|| $value['StructureField']['type']=='datetime'
				|| (($value['flag_override_setting'] == 1 && strpos($value['setting'], "range") !== false) ||  (isset($value['StructureFormat']) && $value['StructureFormat']['flag_override_settings'] == 0 && strpos($value['StructureField']['setting'], "range") !== false))
						&& isset($this->controller->data[$value['StructureField']['model']][$value['StructureField']['field'].'_start'])) {
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
				else if ( $value['StructureField']['type'] == 'select' || isset($this->controller->data['exact_search'])){
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
			if(is_array($fields)){
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
								$data = $format_data_model->deconstruct($form_fields[$model.'.'.$key]['field'], $data, strpos($key, "_end") == strlen($key) - 4);
								
								if ( is_array($data) ) {
									$data = array_unique($data);
									$data = array_filter($data);
								}
								
								if ( !count($data) ) $data = '';
							}
							
							// if supplied form DATA is not blank/null, add to search conditions, otherwise skip
							if ( $data ) {
								if ( strpos($form_fields[$model.'.'.$key]['key'], ' LIKE')!==false ) {
									if(is_array($data)){
										$conditions[] = "(".$form_fields[$model.'.'.$key]['key']." '%".implode("%' OR ".$form_fields[$model.'.'.$key]['key']." '%", $data)."%')";
										unset($data);
									}else{
										$data = '%'.$data.'%';
									}
								}
								
								if(isset($data)){
									$conditions[ $form_fields[$model.'.'.$key]['key'] ] = $data;
								}
							}
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
			foreach($conditions as $model_field => $condition){
				if(is_numeric($model_field)){
					$model_field = substr($condition, 1, strpos($condition, " ") - 1);
				}else{
					if(is_array($condition)){
						$tmp_cond = array();
						foreach($condition as $unit){
							$tmp_cond[] = $model_field." LIKE '".$unit."'";
						}
						$condition = "(".implode(" OR ", $tmp_cond).")";
					}
				}
				//LIKE
				$matches = array();
				preg_match_all("/[\w\.\`]+[\s]+LIKE[\s]+\"[%]*@@".$model_field."@@[%]*\"/", $sql_with_search_terms, $matches, PREG_OFFSET_CAPTURE);
				//start with the end
				$matches[0] = array_reverse($matches[0]);
				foreach($matches[0] as $match){
					$sql_with_search_terms = substr($sql_with_search_terms, 0, $match[1]).$condition.substr($sql_with_search_terms, $match[1] + strlen($match[0]));
				}
				//IN
				$matches = array();
				preg_match_all("/[\w\.\`]+[\s]+IN[\s]+\([\s]*@@".$model_field."@@[\s]*\)/", $sql_with_search_terms, $matches, PREG_OFFSET_CAPTURE);
				if(count($matches) > 0){
					$in_arr = array();
					$tmp_cond = (strrpos($condition, ")") == strlen($condition) - 1) ? substr($condition, 0, -1) : $condition;
					$my_conds = explode(" OR ", $tmp_cond);
					foreach($my_conds as $my_cond){
						$parts = explode(" ", $my_cond);
						if(count($parts) > 1){
							$in_arr[] = "'".substr(str_replace("%'", "'", $parts[2]), 2);
						}
					}
					$matches[0] = array_reverse($matches[0]);
					foreach($matches[0] as $match){
						$sql_with_search_terms = substr($sql_with_search_terms, 0, $match[1]).$model_field." IN (".implode(", ", $in_arr).")".substr($sql_with_search_terms, $match[1] + strlen($match[0]));
					}
				}
				
				//=, <, >, <=, >=
				$tests = array("=", "<", "<=", ">", ">=");
				foreach($tests as $test){
					$matches = array();
					preg_match_all("/[\w\.\`]+[\s]+".$test."[\s]+\"[%]*@@".$model_field."@@[%]*\"/", $sql_with_search_terms, $matches, PREG_OFFSET_CAPTURE);
					if(count($matches) > 0){
						$condition = str_replace("%') OR ", "') OR ", str_replace("%')", "')", str_replace(" LIKE '%", " ".$test." '", $condition)));
						$matches[0] = array_reverse($matches[0]);
						foreach($matches[0] as $match){
							$sql_with_search_terms = substr($sql_with_search_terms, 0, $match[1]).$condition.substr($sql_with_search_terms, $match[1] + strlen($match[0]));
						}
					}
				}
				
				$sql_without_search_terms = str_replace( '@@'.$model_field.'@@', '', $sql_without_search_terms );
			}
		}
			//whipe what wasn't replaced
			//range
			$sql_with_search_terms = preg_replace('/(\>|\<)\=\s*"@@[\w\.]+@@"/i', "$1= \"\"", $sql_with_search_terms);
			$sql_without_search_terms = preg_replace('/(\>|\<)\=\s*"@@[\w\.]+@@"/i', "1= \"\"", $sql_without_search_terms);
			
			//LIKE
			$sql_with_search_terms = preg_replace('/LIKE\s*"[%]*@@[\w\.]+@@[%]*"/i', "LIKE \"%%\"", $sql_with_search_terms);
			$sql_without_search_terms = preg_replace('/LIKE\s*"[%]*@@[\w\.]+@@[%]*"/i', "LIKE \"%%\"", $sql_without_search_terms);
			
			//IN
			$sql_with_search_terms = preg_replace('/IN\s*\([\s]*@@[\w\.]+@@[\s]*\)/i', 'IN ("")', $sql_with_search_terms);
			$sql_without_search_terms = preg_replace('/IN\s*\([\s]*@@[\w\.]+@@[\s]*\)/i', 'IN ("")', $sql_without_search_terms);
			
			//others
			$sql_with_search_terms = preg_replace('/"(%)*@@[\w\.]+@@(%)*"/i', "\"\"", $sql_with_search_terms);
			$sql_without_search_terms = preg_replace('/"(%)*@@[\w\.]+@@(%)*"/i', "\"\"", $sql_without_search_terms);
		
		// WITH
			// regular expression to change search over field for BLANK values to be searches over fields for BLANK OR NULL values...
			$sql_with_search_terms = preg_replace( '/([\w\.]+)\s+LIKE\s+([\||\"])\%\%\2/i', '($1 LIKE $2%%$2 OR $1 IS NULL)', $sql_with_search_terms );
			$sql_with_search_terms = preg_replace( '/([\w\.]+)\s+\=\s+([\||\"])\2/i', '($1 LIKE $2%%$2 OR $1 IS NULL)', $sql_with_search_terms );
			$sql_with_search_terms = preg_replace( '/([\w\.]+)\s+IN\s+\(""\)/i', '($1 LIKE "%%" OR $1 IS NULL)', $sql_with_search_terms );
			
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
			$sql_without_search_terms = preg_replace( '/([\w\.]+)\s+IN\s+\(""\)/i', '($1 LIKE "%%" OR $1 IS NULL)', $sql_without_search_terms );
			
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

	function getFormById($id){
		$data = $this->Component_Structure->find('first', array('conditions' => array('Structure.id' => $id), 'recursive' => -1));
		return $this->get('form', $data['Structure']['alias']);
	}
	
	function getSimplifiedFormById($id){
		$form = $this->getFormById($id);
		foreach($form['StructureFormat'] as &$sfo){
			if(isset($sfo['StructureField']['StructureValueDomain']['source']) && strlen($sfo['StructureField']['StructureValueDomain']['source']) > 0){
				$sfo['StructureField']['StructureValueDomain']['StructurePermissibleValue'] = StructuresComponent::getPulldownFromSource($sfo['StructureField']['StructureValueDomain']['source']); 
			}
		}
		return StructuresComponent::simplifyForm($form);
	}
	
	/**
	 * Flattens a form so that all information is on the same level and that there is no need to evaluate override flags all the time
	 * @param array $form The form to simplify
	 */
	static function simplifyForm(array $form){
		$result['Structure'] = $form['Structure'];
		$sfo_to_copy = array("structure_id", "structure_field_id", "display_column", "display_order", "language_heading", "flag_add", "flag_add_readonly",
			"flag_edit", "flag_edit_readonly", "flag_search", "flag_search_readonly", "flag_datagrid", "flag_datagrid_readonly", "flag_index",
			"flag_detail");
		$sfi_to_copy = array("public_identifier", "plugin", "model", "tablename", "field", "structure_value_domain", "StructureValueDomain",
			"StructureValidation");
		foreach($form['StructureFormat'] as $sfo){
			$ssfield = array();
			$ssfield["structure_format_id"] = $sfo['id'];
			foreach($sfo_to_copy as $unit){
				$ssfield[$unit] = $sfo[$unit];
			}
			foreach($sfi_to_copy as $unit){
				$ssfield[$unit] = $sfo['StructureField'][$unit];
			}
			$ssfield['language_label'] = $sfo['flag_override_label'] ? $sfo['language_label'] : $sfo['StructureField']['language_label'];
			$ssfield['language_tag'] = $sfo['flag_override_tag'] ? $sfo['language_tag'] : $sfo['StructureField']['language_tag'];
			$ssfield['language_help'] = $sfo['flag_override_help'] ? $sfo['language_help'] : $sfo['StructureField']['language_help'];
			$ssfield['type'] = $sfo['flag_override_type'] ? $sfo['type'] : $sfo['StructureField']['type'];
			$ssfield['setting'] = $sfo['flag_override_setting'] ? $sfo['setting'] : $sfo['StructureField']['setting'];
			$ssfield['default'] = $sfo['flag_override_default'] ? $sfo['default'] : $sfo['StructureField']['default'];
			$result['SimplifiedField'][] = $ssfield;
		}
		
		return $result;
	}
	
	/**
	 * Retrieves pulldown values from a specified source. The source needs to have translated already
	 * @param unknown_type $source
	 */
	static function getPulldownFromSource($source){
		// Get arguments
		$args = null;
		preg_match('(\(\'.*\'\))', $source, $matches);
		if((sizeof($matches) == 1)) {
			// Args are included into the source
			$args = split("','", substr($matches[0], 2, (strlen($matches[0]) - 4)));
			$source = str_replace($matches[0], '', $source);
		}

		list($pulldown_model, $pulldown_function) = split('::', $source);
		$pulldown_result = array();
		if ($pulldown_model && App::import('Model',$pulldown_model)){

			// setup VARS for custom model (if any)
			$custom_pulldown_object = $pulldown_model.'Custom';
			$custom_pulldown_plugin = NULL;
			$custom_pulldown_model = NULL;

			// if model name is PLUGIN.MODEL string, need to split and drop PLUGIN name after import but before NEW
			$pulldown_plugin = NULL;
			if ( strpos($pulldown_model,'.')!==false ) {
				$combined_plugin_model_name = $pulldown_model;
				list($pulldown_plugin,$pulldown_model) = explode('.',$combined_plugin_model_name);
			}

			// load MODEL, and override with CUSTOM model if it exists...
			$pulldown_model_object = new $pulldown_model;
				
			// check for CUSTOM models, and use that if exists
			$custom_pulldown_plugin = $pulldown_plugin;
			$custom_pulldown_model = $pulldown_model.'Custom';
				
			if ( App::import('Model',$custom_pulldown_object) ) {
				$pulldown_model_object = new $custom_pulldown_model;
			}

			// run model::function
			$pulldown_result = $pulldown_model_object->{$pulldown_function}($args);
		}

		return $pulldown_result;
	}
}

?>