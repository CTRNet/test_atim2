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
		
		//CodingIcd magic, import every model required for that structure
		if(isset($return['StructureFormat'])){
			foreach(AppModel::getMagicCodingIcdTriggerArray() as $key => $trigger){
				foreach($return['StructureFormat'] as $sfo){
					if(($sfo['flag_override_setting'] && strpos($sfo['setting'], $trigger) !== false)
					|| strpos($sfo['StructureField']['setting'], $trigger) !== false){
						App::import("Model", "codingicd.".$key);
						new $key;//instantiate it
						$return['Structure']['CodingIcdCheck'] = true;
						break;
					}
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
		if ( $atim_structure===NULL ){
			$atim_structure = $this->get();
		}
		$simplified_structure = self::simplifyForm($atim_structure);
		// format structure data into SEARCH CONDITONS format
		if ( isset($simplified_structure['SimplifiedField']) ) {
			foreach ($simplified_structure['SimplifiedField'] as $value) {
				if(!$value['flag_search']){
					//don't waste cpu cycles on non search parameters
					continue;
				}
				
				// for RANGE values, which should be searched over with a RANGE...
				//it includes numbers, dates, and fields fith the "range" setting. For the later, value  _start
				$form_fields_key = $value['model'].'.'.$value['field'];
				if ( $value['type']=='number'
				|| $value['type']=='integer'
				|| $value['type']=='integer_positive'
				|| $value['type']=='float'
				|| $value['type']=='float_positive' 
				|| $value['type']=='date' 
				|| $value['type']=='datetime'
				|| (strpos($value['setting'], "range") !== false)
						&& isset($this->controller->data[$value['model']][$value['field'].'_start'])) {
					$form_fields[$form_fields_key.'_start']['plugin']		= $value['plugin'];
					$form_fields[$form_fields_key.'_start']['model']		= $value['model'];
					$form_fields[$form_fields_key.'_start']['field']		= $value['field'];
					$form_fields[$form_fields_key.'_start']['key']			= $form_fields_key.' >=';
					
					$form_fields[$form_fields_key.'_end']['plugin']			= $value['plugin'];
					$form_fields[$form_fields_key.'_end']['model']			= $value['model'];
					$form_fields[$form_fields_key.'_end']['field']			= $value['field'];
					$form_fields[$form_fields_key.'_end']['key']				= $form_fields_key.' <=';
				}
				
				// for SELECT pulldowns, where an EXACT match is required, OR passed in DATA is an array to use the IN SQL keyword
				else if ( $value['type'] == 'select' || isset($this->controller->data['exact_search'])){
					$form_fields[$form_fields_key]['plugin']	= $value['plugin'];
					$form_fields[$form_fields_key]['model']	= $value['model'];
					$form_fields[$form_fields_key]['field']	= $value['field'];
					
					$form_fields[$form_fields_key]['key']		= $value['model'].'.'.$value['field'];
				}
				
				// all other types, a generic SQL fragment...
				else {
					$form_fields[$form_fields_key]['plugin']	= $value['plugin'];
					$form_fields[$form_fields_key]['model']	= $value['model'];
					$form_fields[$form_fields_key]['field']	= $value['field'];
					
					$form_fields[$form_fields_key]['key']		= $form_fields_key.' LIKE';
				}
				
				//CocingIcd magic
				if(isset($simplified_structure['Structure']['codingIcdCheck']) && $simplified_structure['Structure']['codingIcdCheck']){
					foreach(AppModel::getMagicCodingIcdTriggerArray() as $key => $setting_lookup){
						if(strpos($value['setting'], $setting_lookup) !== false){
							$form_fields[$form_fields_key]['cast_icd'] = $key;
							if(strpos($form_fields[$form_fields_key]['key'], " LIKE") !== false){
								$form_fields[$form_fields_key]['key'] = str_replace(" LIKE", "", $form_fields[$form_fields_key]['key']);
								$form_fields[$form_fields_key]['exact'] = false;
							}else{
								$form_fields[$form_fields_key]['exact'] = true;
							}
							break;
						}
					}
				}
			}
		}
		
		// parse DATA to generate SQL conditions
		// use ONLY the form_fields array values IF data for that MODEL.KEY combo was provided
		foreach ( $this->controller->data as $model=>$fields ) {
			if(is_array($fields)){
				foreach ( $fields as $key=>$data ) {
					$form_fields_key = $model.'.'.$key;
					// if MODEL data was passed to this function, use it to generate SQL criteria...
					if ( count($form_fields) ) {
						
						// add search element to CONDITIONS array if not blank & MODEL data included Model/Field info...
						if ( (!empty($data) || $data == "0")  && isset( $form_fields[$form_fields_key] ) ) {
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
								App::import('Model', $form_fields[$form_fields_key]['plugin'].'.'.$model);
								// App::import('Model', 'Clinicalannotation.'.$model);
								
								$format_data_model = new $model;
								$data = $format_data_model->deconstruct($form_fields[$form_fields_key]['field'], $data, strpos($key, "_end") == strlen($key) - 4);
								if ( is_array($data) ) {
									$data = array_unique($data);
									
									$data = array_filter($data, "StructuresComponent::myFilter");
								}
								
								if ( !count($data) ) $data = '';
							}
							
							// if supplied form DATA is not blank/null, add to search conditions, otherwise skip
							if ( $data || $data == "0" ) {
								
								if(isset($form_fields[$form_fields_key]['cast_icd'])){
									//special magical icd case
									eval('$instance = '.$form_fields[$form_fields_key]['cast_icd'].'::getInstance();');
									$data = $instance->getCastedSearchParams($data, $form_fields[$form_fields_key]['exact']);
								}else if ( strpos($form_fields[$form_fields_key]['key'], ' LIKE')!==false ) {
									if(is_array($data)){
										$conditions[] = "(".$form_fields[$form_fields_key]['key']." '%".implode("%' OR ".$form_fields[$form_fields_key]['key']." '%", $data)."%')";
										unset($data);
									}else{
										$data = '%'.$data.'%';
									}
								}
								
								if(isset($data)){
									$conditions[ $form_fields[$form_fields_key]['key'] ] = $data;
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
	
	static function myFilter($val){
		return strlen($val) > 0;
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
			//the conditions array is splitted in 3 types
			//1-[model.field] = value -> replace in the query @@value@@ by value (usually a _start, _end). Convert as 2B
			//2-[model.field] = array(values) -> it's from a dropdown or it an exact search
			// A-replace ='@@value@@' by IN(values)
			// B-copy model model.field {>|<|<=|>=} @@value@@ for every values
			//3-[integer] = string of the form "model.field LIKE '%value1%' OR model.field LIKE '%value2%' ..."
			//	A-if the query is model.field = ... then use the like form.
			//  B-else (the query is model.field {>|<|<=|>=}) do as 2B
			$warning_like = false;
			$warning_in = false;
			$tests = array();
			foreach($conditions as $str_to_replace => $condition){
				if(is_numeric($str_to_replace)){
					unset($conditions[$str_to_replace]);
					$condition = substr($condition, 1, -1); //remove the opening ( and closing )
					//case 3, remove the parenthesis
					$matches = array();
					list($str_to_replace, ) = explode(" ", $condition, 2);
					//3A
					preg_match_all("/[\w\.\`]+[\s]+=[\s]+\"[%]*@@".$str_to_replace."@@[%]*\"/", $sql_with_search_terms, $matches, PREG_OFFSET_CAPTURE);
					foreach($matches as $sub_matches){
						foreach($sub_matches as $match){
							$sql_with_search_terms = substr($sql_with_search_terms, 0, $match[1]).$condition.substr($sql_with_search_terms, $match[1] + strlen($match[0]));
						}
					}
					
					//reformat the condition as case 2B
					$parts = explode(" OR ", $condition);
					$condition = array();
					foreach($parts as $part){
						list( , , $value) = explode(" ", $part);
						$value = substr($value, 2, -2);//chop opening '% and closing %'
						$condition[] = $value;
					}
					$conditions[$str_to_replace] = $condition;
				}
				
				if(is_array($condition)){
					//case 2A replace the model.field = "@@value@@" by model.field IN (values)
					preg_match_all("/[\w\.\`]+[\s]+=[\s]+\"[%]*@@".$str_to_replace."@@[%]*\"/", $sql_with_search_terms, $matches, PREG_OFFSET_CAPTURE);
					foreach($matches as $sub_matches){
						foreach($sub_matches as $match){
							list($model_field, ) = explode(" ", $match[0], 2);
							$sql_with_search_terms = substr($sql_with_search_terms, 0, $match[1]).$model_field." IN ('".implode("', '", $condition)."') ".substr($sql_with_search_terms, $match[1] + strlen($match[0]));
						}
					}
					//remaining replaces to perform
					$tests = array("<", "<=", ">", ">=");
				}else{
					//case 1, convert to case 2B
					$condition = array($condition);
					//remaining replaces to perform
					$tests = array("=", "<", "<=", ">", ">=");
				}
				
				//CASE 2B
				foreach($tests as $test){
					preg_match_all("/[\w\.\`]+[\s]+".$test."[\s]+\"[%]*@@".$str_to_replace."@@[%]*\"/", $sql_with_search_terms, $matches, PREG_OFFSET_CAPTURE);
					foreach($matches as $sub_matches){
						foreach($sub_matches as $match){
							list($model_field, ) = explode(" ", $match[0], 2);
							$formated_condition = "(".$model_field." ".$test." '".implode(" OR ".$model_field." ".$test." '", $condition)."')";
							$sql_with_search_terms = substr($sql_with_search_terms, 0, $match[1]).$formated_condition.substr($sql_with_search_terms, $match[1] + strlen($match[0]));
						}
					}
				}
				
				//LIKE
				$matches = array();
				preg_match_all("/[\w\.\`]+[\s]+LIKE[\s]+\"[%]*@@".$str_to_replace."@@[%]*\"/", $sql_with_search_terms, $matches, PREG_OFFSET_CAPTURE);
				if(!empty($matches[0]) && !$warning_like){
					$warning_like = true;
					AppController::addWarningMsg(__("this query is using the LIKE keyword which goes against the ad hoc queries rules", true));
				}
				//IN
				$matches = array();
				preg_match_all("/[\w\.\`]+[\s]+IN[\s]+\([\s]*@@".$str_to_replace."@@[\s]*\)/", $sql_with_search_terms, $matches, PREG_OFFSET_CAPTURE);
				if(!empty($matches[0]) && !$warning_in){
					$warning_in = true;
					AppController::addWarningMsg(__("this query is using the IN keyword which goes against the ad hoc queries rules", true));
				}
			}
		}
		
		//whipe what wasn't replaced
		//>, <, <=, >=, =
		$sql_with_search_terms = preg_replace('/[\w\.\`]+[\s]+(\>|\<|\>\=|\<\=|\=)\s*"@@[\w\.]+@@"/i', "TRUE", $sql_with_search_terms);
		$sql_without_search_terms = preg_replace('/[\w\.\`]+[\s]+(\>|\<|\>\=|\<\=|\=)\s*"@@[\w\.]+@@"/i', "TRUE", $sql_without_search_terms);
		
		//LIKE
		$sql_with_search_terms = preg_replace('/[\w\.\`]+[\s]+LIKE\s*"[%]*@@[\w\.]+@@[%]*"/i', "TRUE", $sql_with_search_terms);
		$sql_without_search_terms = preg_replace('/[\w\.\`]+[\s]+LIKE\s*"[%]*@@[\w\.]+@@[%]*"/i', "TRUE", $sql_without_search_terms);
		
		//IN
		$sql_with_search_terms = preg_replace('/[\w\.\`]+[\s]+IN\s*\([\s]*@@[\w\.]+@@[\s]*\)/i', 'TRUE', $sql_with_search_terms);
		$sql_without_search_terms = preg_replace('/[\w\.\`]+[\s]+IN\s*\([\s]*@@[\w\.]+@@[\s]*\)/i', 'TRUE', $sql_without_search_terms);
		
		//remove TRUE
		$sql_with_search_terms = preg_replace('/(AND|OR) TRUE/i', "", $sql_with_search_terms);
		$sql_without_search_terms = preg_replace('/(AND|OR) TRUE/i', "", $sql_without_search_terms);
		
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