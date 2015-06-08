<?php
class StructuresComponent extends Component {
	
	var $controller;
	static $singleton;
	
	public static $range_types = array("date", "datetime", "time", "integer", "integer_positive", "float", "float_positive");
	
	public function initialize(Controller $controller) {
		$this->controller = $controller;
		StructuresComponent::$singleton = $this;
	}
	
	/* Combined function to simplify plugin usage, 
	 * sets validation for models AND sets atim_structure for view
	 * 
	 * @param $alias Form alias of the new structure
	 * @param $structure_name Structure name (by default name will be 'atim_structure')
	 * @param array $parameters
	 */
	function set($alias = NULL, $structure_name = 'atim_structure', array $parameters = array()){
		if(!is_array($alias)){
			$alias = array_filter(explode(",", $alias));
			if(!$alias){
				$alias[] = '';
			}			
		}
		$parameters = array_merge(
			array(
				'set_validation'	=> true, //wheter to set model validations or not 
				'model_table_assoc'	=> array()//bind a tablename to a model for writable fields 
			), $parameters
		);
		
		$structure = array('Structure' => array(), 'Sfs' => array(), 'Accuracy' => array());
		$all_structures = array();
		foreach($alias as $alias_unit){
			$struct_unit = $this->getSingleStructure($alias_unit);
			$all_structures[] = $struct_unit;
			
			if($parameters['set_validation']){
				foreach ($struct_unit['rules'] as $model => $rules){
					//reset validate for newly loaded structure models
					if(!$this->controller->{ $model }){
						$this->controller->{ $model } = new AppModel();
					}
					$this->controller->{ $model }->validate = array();
				}
				
				if(isset($struct_unit['structure']['Sfs'])){
					foreach($struct_unit['structure']['Sfs'] as $sfs){
						$tablename = isset($parameters['model_table_assoc'][$sfs['model']]) ? $parameters['model_table_assoc'][$sfs['model']] : $sfs['tablename'];
						if($tablename){
							foreach(array('add', 'edit', 'addgrid', 'editgrid', 'batchedit') as $flag){
								if($sfs['flag_'.$flag] && !$sfs['flag_'.$flag.'_readonly'] && $sfs['type'] != 'hidden'){
									AppModel::$writable_fields[$tablename][$flag][] = $sfs['field'];
									if($sfs['type'] == 'date' || $sfs['type'] == 'datetime'){
										AppModel::$writable_fields[$tablename][$flag][] = $sfs['field'].'_accuracy';
									}
								}
							}
						}
					}
				}
			}

			if(isset($struct_unit['structure']['Sfs'])){
				$structure['Sfs'] = array_merge($struct_unit['structure']['Sfs'], $structure['Sfs']);
				$structure['Structure'][] = $struct_unit['structure']['Structure'];
				$structure['Accuracy'] = array_merge_recursive($struct_unit['structure']['Accuracy'], $structure['Accuracy']);
				$structure['Structure']['CodingIcdCheck'] = $struct_unit['structure']['Structure']['CodingIcdCheck'];
			}
		}
		
		foreach($all_structures as &$struct_unit){
			foreach ($struct_unit['rules'] as $model => $rules){
				//rules are formatted, apply them
				$this->controller->{ $model }->validate = array_merge($this->controller->{ $model }->validate, $rules);
			}
		}
		
		if(count($alias) > 1){
			self::sortStructure($structure);
		}else if(count($structure['Structure']) == 1){
			$structure['Structure'] = $structure['Structure'][0];
		}
		
		$this->controller->set($structure_name, $structure);
	}
	/**
	 * Stores data into model accuracy_config. Will be used for validation. Stores the same data into the structure.
	 * @param array $structure
	 */
	private function updateAccuracyChecks(&$structure){
		$structure['Accuracy'] = array();
		foreach($structure['Sfs'] as &$field){
			if(($field['type'] == 'date' || $field['type'] == 'datetime')){
				$tablename = null;
				$model = AppModel::getInstance($field['plugin'], $field['model'], false);
				if($model === false){
					continue;
				}
				if(empty($model->_schema)){
					$model->schema();
				}
				$schema = $model->_schema;
				if($model !== false && !empty($schema) && ($field['tablename'] == $model->table || empty($field['tablename']))){
					$tablename = $model->table;
				}else if(!empty($field['tablename'])){
					$model = new AppModel(array('table' => $field['tablename'], 'name' => $field['model'], 'alias' => $field['model']));
					$tablename = $field['tablename'];
				}
				
				if($tablename != null){
					if(!array_key_exists($tablename, AppModel::$accuracy_config)){
						$model->buildAccuracyConfig();
					}
					if(isset(AppModel::$accuracy_config[$tablename][$field['field']])){
						$structure['Accuracy'][$field['model']][$field['field']] = $field['field'].'_accuracy';
					}
				}else if($field['model'] != 'custom' && Configure::read('debug') > 0){
					AppController::addWarningMsg('Cannot load model for field with id '.$field['structure_field_id'].'. Check field tablename.', true);
				}
			}
		}
	}
	
	function get($mode = null, $alias = NULL){
		$result = array('structure' => array('Structure' => array(), 'Sfs' => array()), 'rules' => array());
		if(!is_array($alias)){
			$alias = explode(",", $alias);
		}

		foreach($alias as $alias_unit){
			if(!empty($alias_unit)) {
				$tmp = $this->getSingleStructure($alias_unit);			
				$result['structure']['Sfs'] = array_merge($tmp['structure']['Sfs'], $result['structure']['Sfs']);
				$result['structure']['Structure'][] = $tmp['structure']['Structure'];
				$result['rules'] = array_merge($tmp['rules'], $result['rules']);
			}
		}
		if(count($alias) > 1){
			self::sortStructure($result['structure']);
		}else if(count($result['structure']['Structure']) == 1){
			$result['structure']['Structure'] = $result['structure']['Structure'][0];
		}
		if($mode == 'rule' || $mode == 'rules'){
			$result = $result['rules'];
		}else if($mode == 'form'){
			$result = $result['structure'];
		}

		$this->updateAccuracyChecks($result);
		return $result;
	}
	
	function getSingleStructure($alias = NULL){
		$return = array();
		$alias	= $alias ? trim(strtolower($alias)) : str_replace('_','',$this->controller->params['controller']);
		$cache_alias = $alias.md5($alias);//cake alters the alias so we need to still make it unique
		
		$return = Cache::read($cache_alias, "structures");
		if($return === null){
			$return = false;
			if(Configure::read('debug') == 2){
				AppController::addWarningMsg('Structure caching issue. (null)', true);
			}
		}
		if(!$return){
			if ( $alias ) {
				App::uses('Structure', 'Model');
				$this->Component_Structure = new Structure;
				
				$result = $this->Component_Structure->find(
								'first',
								array(
									'conditions'	=>	array( 'Structure.alias' => $alias ), 
									'recursive'		=>	5
								)
				);
				
				if ( $result ){
					$return = $result;
				}
			}
			
			if(Configure::read('debug') == 0){
				Cache::write($cache_alias, $return, "structures");
			}
		}
		
		//CodingIcd magic, import every model required for that structure
		if(isset($return['structure']['Sfs'])){
			foreach(AppModel::getMagicCodingIcdTriggerArray() as $key => $trigger){
				foreach($return['structure']['Sfs'] as $sfs){
					if(strpos($sfs['setting'], $trigger) !== false){
						AppModel::getInstance('CodingIcd', $key, true);
						$return['structure']['Structure']['CodingIcdCheck'] = true;
						break;
					}
				}
				if(!isset($return['structure']['Structure']['CodingIcdCheck'])){
					$return['structure']['Structure']['CodingIcdCheck'] = false;
				}
			}
			$this->updateAccuracyChecks($return['structure']);
		}
		
		
		return $return;
	}
	
	/**
	 * Sorts a structure based on display_column and display_order.
	 * @param array $atim_structure
	 */
	public static function sortStructure(&$atim_structure){
		if(count($atim_structure['Sfs'])){
			// Sort the data with ORDER descending, FIELD ascending 
			foreach($atim_structure['Sfs'] as $key => $row){
				$sort_order_0[$key] = $row['flag_float'];
				$sort_order_1[$key] = $row['display_column'];
				$sort_order_2[$key] = $row['display_order'];
				$sort_order_3[$key] = $row['model'];
			}
			
			// multisort, PHP array 
			array_multisort( $sort_order_0, SORT_DESC, $sort_order_1, SORT_ASC, $sort_order_2, SORT_ASC, $sort_order_3, SORT_ASC, $atim_structure['Sfs'] );
		}
	}
	
	function parseSearchConditions($atim_structure = NULL, $auto_accuracy = true){
		// conditions to ultimately return
		$conditions = array();
		
		// general search format, after parsing STRUCTURE
		$form_fields = array();
		$accuracy_fields = array();
		
		// if no STRUCTURE provided, try and get one
		if($atim_structure === NULL){
			$atim_structure = $this->getSingleStructure();
			$atim_structure = $atim_structure['structure'];
		}
		
		// format structure data into SEARCH CONDITONS format
		if (isset($atim_structure['Sfs'])){
			$cant_read_confidential = !AppController::getInstance()->Session->read('flag_show_confidential'); 
			foreach ($atim_structure['Sfs'] as $value) {
				if(!$value['flag_search'] || ($value['flag_confidential'] && $cant_read_confidential)){
					//don't waste cpu cycles on non search parameters
					continue;
				}
				
				// for RANGE values, which should be searched over with a RANGE...
				//it includes numbers, dates, and fields fith the "range" setting. For the later, value  _start
				$form_fields_key = $value['model'].'.'.$value['field'];
				$value_type = $value['type'];
				if (in_array($value_type, self::$range_types)
					|| (strpos($value['setting'], "range") !== false)
						&& isset($this->controller->data[$value['model']][$value['field'].'_start'])
				){
					$key_start = $form_fields_key.'_start';
					$form_fields[$key_start]['plugin']		= $value['plugin'];
					$form_fields[$key_start]['model']		= $value['model'];
					$form_fields[$key_start]['field']		= $value['field'];
					$form_fields[$key_start]['key']			= $form_fields_key.' >=';
					$form_fields[$key_start]['tablename']	= $value['tablename'];
					
					$key_end = $form_fields_key.'_end';
					$form_fields[$key_end]['plugin']			= $value['plugin'];
					$form_fields[$key_end]['model']			= $value['model'];
					$form_fields[$key_end]['field']			= $value['field'];
					$form_fields[$key_end]['key']			= $form_fields_key.' <=';
					$form_fields[$key_end]['tablename']	= $value['tablename'];
					
					if(isset($atim_structure['Accuracy'][$value['model']][$value['field']])){
						$accuracy_fields[] = $key_start;
						$accuracy_fields[] = $key_end;
						$form_fields[$key_start.'_accuracy']['key'] = $form_fields_key.'_accuracy'; 
						$form_fields[$key_end.'_accuracy']['key'] = $form_fields_key.'_accuracy'; 
					}
					
				}else{ 
					$form_fields[$form_fields_key]['plugin']	= $value['plugin'];
					$form_fields[$form_fields_key]['model']		= $value['model'];
					$form_fields[$form_fields_key]['field']		= $value['field'];
					$form_fields[$form_fields_key]['tablename']	= $value['tablename'];
					
					if ( $value_type == 'select' || isset($this->controller->data['exact_search'])){
						//for SELECT pulldowns, where an EXACT match is required, OR passed in DATA is an array to use the IN SQL keyword
						$form_fields[$form_fields_key]['key']		= $value['model'].'.'.$value['field'];
						
					}else{
						// all other types, a generic SQL fragment...
						$form_fields[$form_fields_key]['key']		= $form_fields_key.' LIKE';
					}						
				}
				
				//CocingIcd magic
				$icd_check = isset($atim_structure['Structure']['CodingIcdCheck']) && $atim_structure['Structure']['CodingIcdCheck'];
				reset($atim_structure['Structure']);
				if(!$icd_check && is_array(current($atim_structure['Structure']))){
					//might be a structure with sub structures
					foreach($atim_structure['Structure'] as $sub_structure){
						if($sub_structure['CodingIcdCheck']){
							$icd_check = true;
							break;
						}
					}
				}
				if($icd_check){
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
		
		App::uses('Sanitize', 'Utility');
		
		// parse DATA to generate SQL conditions
		// use ONLY the form_fields array values IF data for that MODEL.KEY combo was provided
		foreach($this->controller->data as $model => $fields){
			if(is_array($fields)){
				foreach($fields as $key => $data){
					$key = str_replace("_with_file_upload", "", $key);
					$form_fields_key = $model.'.'.$key;
					// if MODEL data was passed to this function, use it to generate SQL criteria...
					if(count($form_fields)){
						// add search element to CONDITIONS array if not blank & MODEL data included Model/Field info...
						if((!empty($data) || $data == "0")  && isset($form_fields[$form_fields_key])){
							// if CSV file uploaded...
							if(is_array($data) && isset($this->controller->data[$model][$key.'_with_file_upload']) && $this->controller->data[$model][$key.'_with_file_upload']['tmp_name']){
								if(!preg_match('/((\.txt)|(\.csv))$/', $this->controller->data[$model][$key.'_with_file_upload']['name'])) {
									$this->controller->redirect('/Pages/err_submitted_file_extension', null, true);
								} else {
									// set $DATA array based on contents of uploaded FILE
									$handle = fopen($this->controller->data[$model][$key.'_with_file_upload']['tmp_name'], "r");
									if($handle) {
										unset($data['name'], $data['type'], $data['tmp_name'], $data['error'], $data['size']);
										// in each LINE, get FIRST csv value, and attach to DATA array
										while (($csv_data = fgetcsv($handle, 1000, csv_separator, '"')) !== FALSE) {
										    $data[] = $csv_data[0];
										}
										fclose($handle);
									} else {
										$this->controller->redirect('/Pages/err_opening_submitted_file', null, true);
									}
								}
								$tmp_controler_data = $this->controller->data;
								unset($tmp_controler_data[$model][$key.'_with_file_upload']);
								$this->controller->data = $tmp_controler_data;
							}

							// use Model->deconstruct method to properly build data array's date/time information from arrays
							if(is_array($data) && $model != "0"){
									$format_data_model = AppModel::getInstance($form_fields[$form_fields_key]['plugin'], $model, true);
									
									if($format_data_model->table != $form_fields[$form_fields_key]['tablename'] && strpos($model, 'Detail') !== false){
										//reload the model with the proper table if it's a detail model
										if(!empty($form_fields[$form_fields_key]['tablename'])){
											$model_name = $format_data_model->name;
											ClassRegistry::removeObject($model_name);//flush the old detail from cache, we'll need to reinstance it
											$format_data_model = new AppModel(array('table' => $form_fields[$form_fields_key]['tablename'], 'name' => $model_name, 'alias' => $model_name));
											
										}else if(Configure::read('debug') > 0){
											AppController::addWarningMsg('There is no tablename for field ['.$form_fields[$form_fields_key]['key'].']', true);
										}
									}
									
									$data = $format_data_model->deconstruct($form_fields[$form_fields_key]['field'], $data, strpos($key, "_end") == strlen($key) - 4, true);
									if(is_array($data)){
										$data = array_unique($data);
										$data = array_filter($data, "StructuresComponent::myFilter");
									}
									
									if (!count($data)){
										$data = '';
									}
									
							}
							
							// if supplied form DATA is not blank/null, add to search conditions, otherwise skip
							if ($data || $data == "0"){
								
								if(isset($form_fields[$form_fields_key]['cast_icd'])){
									//special magical icd case
									eval('$instance = '.$form_fields[$form_fields_key]['cast_icd'].'::getSingleton();');
									$data = $instance->getCastedSearchParams($data, $form_fields[$form_fields_key]['exact']);
								}else if (strpos($form_fields[$form_fields_key]['key'], ' LIKE') !== false){
									if(is_array($data)){
										foreach($data as &$unit){
											$unit = trim(Sanitize::escape($unit));
										}
										$conditions[] = "(".$form_fields[$form_fields_key]['key']." '%".implode("%' OR ".$form_fields[$form_fields_key]['key']." '%", $data)."%')";
										unset($data);
									}else{
										$data = '%'.trim(Sanitize::escape($data)).'%';
									}
								}
								
								if(isset($data)){
									if($auto_accuracy && in_array($form_fields_key, $accuracy_fields)){
										//accuracy treatment
										$tmp_cond = array();
										$tmp_cond[] = array(
											$form_fields[$form_fields_key]['key'] => $data,
											$form_fields[$form_fields_key.'_accuracy']['key'] => array('c', ' ')
										);
										if(strpos($data, " ") !== false){
											//datetime
											list($data, $time) = explode(" ", $data);
											list($hour, ) = explode(":", $time);
											$tmp_cond[] = array(
												$form_fields[$form_fields_key]['key'] => sprintf("%s %s:00:00", $data, $hour),
												$form_fields[$form_fields_key.'_accuracy']['key'] => 'i'
											);
											$tmp_cond[] = array(
												$form_fields[$form_fields_key]['key'] => $data." 00:00:00",
												$form_fields[$form_fields_key.'_accuracy']['key'] => 'h'
											);
										}
										list($year, $month) = explode("-", $data);
										$tmp_cond[] = array(
											$form_fields[$form_fields_key]['key'] => sprintf("%s-%s-01 00:00:00", $year, $month),
											$form_fields[$form_fields_key.'_accuracy']['key'] => 'd'
										);
										$tmp_cond[] = array(
											$form_fields[$form_fields_key]['key'] => sprintf("%s-01-01 00:00:00", $year),
											$form_fields[$form_fields_key.'_accuracy']['key'] => array('m', 'y')
										);
										$conditions[] = array("OR" => $tmp_cond);
									}else{										
										foreach($data as &$unit) if(is_string($unit)) $unit = trim($unit);
										$conditions[ $form_fields[$form_fields_key]['key'] ] = $data;
									}
								}
							}
						}
					}
				}
			}
		}
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
					AppController::addWarningMsg(__("this query is using the LIKE keyword which goes against the ad hoc queries rules"));
				}
				//IN
				$matches = array();
				preg_match_all("/[\w\.\`]+[\s]+IN[\s]+\([\s]*@@".$str_to_replace."@@[\s]*\)/", $sql_with_search_terms, $matches, PREG_OFFSET_CAPTURE);
				if(!empty($matches[0]) && !$warning_in){
					$warning_in = true;
					AppController::addWarningMsg(__("this query is using the IN keyword which goes against the ad hoc queries rules"));
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
		if(!isset($this->Component_Structure)){
			//when debug is off, Component_Structure is not initialized
			App::uses('Structure', 'Model');
			$this->Component_Structure = new Structure();
		}
		$data = $this->Component_Structure->find('first', array('conditions' => array('Structure.id' => $id), 'recursive' => -1));
		$tmp = $this->getSingleStructure($data['structure']['Structure']['alias']);
		return $tmp['structure'];
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
		$pulldown_plugin = NULL;
		if (strpos($pulldown_model,'.') !== false){
			$combined_plugin_model_name = $pulldown_model;
			list($pulldown_plugin, $pulldown_model) = explode('.',$combined_plugin_model_name);
		}

		$pulldown_result = array();
		if ($pulldown_model && ($pulldown_model_object = AppModel::getInstance($pulldown_plugin, $pulldown_model, true))){
			// run model::function
			$pulldown_result = $pulldown_model_object->{$pulldown_function}($args);
		}

		return $pulldown_result;
	}
}

?>