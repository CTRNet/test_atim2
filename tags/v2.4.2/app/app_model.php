<?php

class AppModel extends Model {
	
	var $actsAs = array('MasterDetail','Revision','SoftDeletable');
	private $validation_in_progress = false;
	public static $auto_validation = null;//Validation for all models based on the table field length for char/varchar
	static public $accuracy_config = array();//tablename -> accuracy fields

	//The values in this array can trigger magic actions when applied to a field settings
	private static $magic_coding_icd_trigger_array = array(
			"CodingIcd10Who" => "/codingicd/CodingIcd10s/tool/who", 
			"CodingIcd10Ca" => "/codingicd/CodingIcd10s/tool/ca", 
			"CodingIcdo3Morpho" => "/codingicd/CodingIcdo3s/tool/morpho", 
			"CodingIcdo3Topo" => "/codingicd/CodingIcdo3s/tool/topo");
	
	/**
	 * @desc Used to store the previous model when a model is recreated for detail search
	 * @var SampleMaster
	 */
	var $previous_model = null;

	/**
	 * @desc If $base_model_name and $detail_table are not null, a new hasOne relationship is created before calling the parent constructor.
	 * This is convenient for search based on master/detail detail table.
	 * @param unknown_type $id (see parent::__construct)
	 * @param unknown_type $table (see parent::__construct)
	 * @param unknown_type $ds (see parent::__construct) 
	 * @param string $base_model_name The base model name of a master/detail model
	 * @param string $detail_table The name of the table to use for detail
	 * @param AppModel $previous_model The previous model prior to that new creation (purely for convenience)
	 * @see parent::__construct
	 */
	function __construct($id = false, $table = null, $ds = null, $base_model_name = null, $detail_table = null, $previous_model = null) {
		if($detail_table != null && $base_model_name != null){
			$this->hasOne[$base_model_name.'Detail'] = array(
						'className'   => $detail_table,
					 	'foreignKey'  => strtolower($base_model_name).'_master_id',
					 	'dependent' => true);
			if($previous_model != null){
				$this->previous_model = $previous_model;
			}
		}
		parent::__construct($id, $table, $ds);
	}
	
	/**
	 * Ensures that the "created_by" and "modified_by" user id columns are set automatically for all models. This requires
	 * adding in access to the session to the model.
	 * 
	 * Replace float decimal separator ',' by '.'.
	**/
	function beforeSave(){
		if ( !isset($this->Session) || !$this->Session ){
			if( App::import('Model', 'CakeSession')) $this->Session = new CakeSession(); 
		}
		
		if ( $this->id && $this->Session ) {
			// editing an existing entry with an existing session
			unset($this->data[$this->name]['created_by']);
			$this->data[$this->name]['modified_by'] = $this->Session->check('Auth.User.id') ? $this->Session->read('Auth.User.id') : 0;
		} else if ($this->Session ) {
			// creating a new entry with an existing session
			$this->data[$this->name]['created_by'] = $this->Session->check('Auth.User.id') ? $this->Session->read('Auth.User.id') : 0;
			$this->data[$this->name]['modified_by'] = $this->Session->check('Auth.User.id') ? $this->Session->read('Auth.User.id') : 0;
		} else if ( $this->id ) {
			// editing an existing entry with no session
			unset($this->data[$this->name]['created_by']);
			$this->data[$this->name]['modified_by'] = 0;
		} else {
			// creating a new entry with no session
			$this->data[$this->name]['created_by'] = 0;
			$this->data[$this->name]['modified_by'] = 0;
		}
		
		
		foreach($this->_schema as $field_name => $field_properties) {
			$tmp_type = $field_properties['type'];
			if($tmp_type == "float" || $tmp_type == "number" || $tmp_type == "float_positive"){
				// Manage float record
				if(isset($this->data[$this->name][$field_name])) {
					$this->data[$this->name][$field_name] = str_replace(",", ".", $this->data[$this->name][$field_name]);
					$this->data[$this->name][$field_name] = str_replace(" ", "", $this->data[$this->name][$field_name]);
					$this->data[$this->name][$field_name] = str_replace("+", "", $this->data[$this->name][$field_name]);
					if(is_numeric($this->data[$this->name][$field_name])) {
						if(strpos($this->data[$this->name][$field_name], ".") === 0) $this->data[$this->name][$field_name] = "0".$this->data[$this->name][$field_name];
						if(strpos($this->data[$this->name][$field_name], "-.") === 0) $this->data[$this->name][$field_name] = "-0".substr($this->data[$this->name][$field_name], 1);
					} 
				}
			}else if(($tmp_type == "datetime" || $tmp_type == "date" || $tmp_type == "time") 
				&& isset($this->data[$this->name][$field_name]) && empty($this->data[$this->name][$field_name])
			){
				//manage date so that the generated query contains NULL instead of an empty string
				unset($this->data[$this->name][$field_name]);
			}
		}

		return true;
	}
	
	/*
		ATiM 2.0 function
		used instead of Model->delete, because SoftDelete Behaviour will always return a FALSE
	*/
	
	function atim_delete($model_id, $cascade = true){
		$this->id = $model_id;
		
		// delete DATA as normal
		$this->delete($model_id, $cascade);
		
		// do a FIND of the same DATA, return FALSE if found or TRUE if not found
		if($this->read()){
			return false; 
		}else{ 
			return true; 
		}
		
	}
	
	/*
		ATiM 2.0 function
		acts like find('all') but returns array with ID values as arrays key values
	*/
	
	function atim_list( $options=array() ) {
		
		$return = false;
		
		$defaults = array(
			'conditions'	=> NULL,
			'fields'			=> NULL,
			'order'			=> NULL,
			'group'			=> NULL,
			'limit'			=> NULL,
			'page'			=> NULL,
			'recursive'		=> 1,
			'callbacks'		=> true
		);
		
		$options = array_merge( $defaults, $options );
		
		$results = $this->find( 'all', $options );
		
		if ( $results ) {
			$return = array();
			
			foreach ( $results as $key=>$result ) {
				$return[ $result[$this->name]['id'] ] = $result;
			}
		}
		
		return $return;
		
	}
	
	function paginate($conditions, $fields, $order, $limit, $page, $recursive, $extra){
		$params = array(
			'fields'	=> $fields, 
			'conditions'=> $conditions, 
			'order'		=> $order, 
			'limit'		=> $limit, 
			'offset'	=> $limit * ($page > 0 ? $page - 1 : 0), 
			'recursive' => $recursive, 
			'extra'		=> $extra
		);
		
		if(isset($extra['joins'])) {
			$params['joins'] = $extra['joins'];
			unset($extra['joins']);
		}
		
		return $this->find('all', $params);
	}
	
/**
 * Deconstructs a complex data type (array or object) into a single field value. Copied from CakePHP core since alterations were required
 *
 * @param string $field The name of the field to be deconstructed
 * @param mixed $data An array or object to be deconstructed into a field
 * @param boolean $is_end (for a range search)
 * @param boolean $is_search If true, date/time will be patched as much as possible
 * @return mixed The resulting data that should be assigned to a field
 */
	function deconstruct($field, $data, $is_end = false, $is_search = false) {
		if (!is_array($data)) {
			return $data;
		}
		
		$type = $this->getColumnType($field);
		if(in_array($type, array('datetime', 'timestamp', 'date', 'time'))){
			$data = array_merge(array("year" => null, "month" => null, "day" => null, "hour" => null, "min" => null, "sec" => null), $data);
			if(strlen($data['year']) > 0 || strlen($data['month']) > 0 || strlen($data['day']) > 0 || strlen($data['hour']) > 0 || strlen($data['min']) > 0){
				$got_date = in_array($type, array('datetime', 'timestamp', 'date'));
				$got_time = in_array($type, array('datetime', 'timestamp', 'time'));
				if($is_search){
					//if search and leading field missing, return
					if($got_date && strlen($data['year']) == 0){
						return null;
					}
					if($type == 'time' && strlen($data['hour']) == 0){
						return null;
					}
				}
				
				//manage meridian
				if($is_end && isset($data['hour']) && strlen($data['hour']) > 0 && isset($data['meridian']) && strlen($data['meridian']) == 0){
					$data['meridian'] = 'pm';
				}
				if(is_numeric($data['hour'])){
					//do not alter an invalid hour
					if (isset($data['hour']) && isset($data['meridian']) && $data['hour'] != 12 && 'pm' == $data['meridian']) {
						$data['hour'] = $data['hour'] + 12;
					}
					if (isset($data['hour']) && isset($data['meridian']) && $data['hour'] == 12 && 'am' == $data['meridian']) {
						$data['hour'] = '00';
					}
				}
				
				
				//patch incomplete values
				if($is_search){
					if($got_date){
						if($is_end){
							if(strlen($data['day']) == 0){
								$data['day'] = 31;
								if(strlen($data['month']) == 0){
									//only patch month if date is patched
									$data['month'] = 12;
								}
							}
						}else{
							if(strlen($data['day']) == 0){
								$data['day'] = 1;
								if(strlen($data['month']) == 0){
									//only patch month if date is patched
									$data['month'] = 1;
								}
							}
						}
					}
				
					if(in_array($type, array('datetime', 'timestamp'))){
						if(strlen($data['hour']) == 0 && strlen($data['min']) == 0 && strlen($data['sec']) == 0){
							//only patch hour if min and sec are empty
							$data['hour'] = $is_end ? 23 : 0;
						}
					}

					if($got_time){
						if(strlen($data['min']) == 0){
							$data['min'] = $is_end ? 59 : 0;
						}
						if(!isset($data['sec']) || strlen($data['sec']) == 0){
							$data['sec'] = $is_end ? 59 : 0;
						}
					}
				}else{
					if(isset($data['year_accuracy'])){
						$data['year'] = '±'.$data['year'];
					}
					
					if(!isset($data['sec']) || strlen($data['sec']) == 0){
						$data['sec'] = '00';
					}
				}
				
				if($got_time){
					foreach(array('hour', 'min', 'sec') as $key){
						if(is_numeric($data[$key])){
							$data[$key] = sprintf("%s", $data[$key]);
						}
					}
				}
				
				$result = null;
				if($got_date && $got_time){
					$result = sprintf("%s-%s-%s %s:%s:%s", $data['year'], $data['month'], $data['day'], $data['hour'], $data['min'], $data['sec']);
				}else if($got_date){
					$result = sprintf("%s-%s-%s", $data['year'], $data['month'], $data['day']);
				}else{
					$result = sprintf("%s:%s:%s", $data['hour'], $data['min'], $data['sec']);
				}
				return $result;
			}
			return "";
		}

		return $data;
	}
	
	/**
	 * Replace the %%key_increment%% part of a string with the key increment value
	 * @param string $key - The key to seek in the database
	 * @param string $str - The string where to put the value. %%key_increment%% will be replaced by the value. 
	 * @return string The string with the replaced value or false when SQL error happens
	 */
	function getKeyIncrement($key, $str){
		$this->query('LOCK TABLE key_increments WRITE');
		$result = $this->query('SELECT key_value FROM key_increments WHERE key_name="'.$key.'"');
		if(empty($result)) return false;
		if($this->query('UPDATE key_increments set key_value = key_value + 1 WHERE key_name="'.$key.'"') === false) {
			$this->query('UNLOCK TABLES');
			return false; 
		}
		$this->query('UNLOCK TABLES');
		return str_replace("%%key_increment%%", $result[0]['key_increments']['key_value'], $str);
	}
	
	static function getMagicCodingIcdTriggerArray(){
		return self::$magic_coding_icd_trigger_array;
	}
	
	public function buildAccuracyConfig(){
		$tmp_acc = array();
		if(isset($this->_schema)){
			foreach($this->_schema as $field_name => $foo){
				if(strpos($field_name, "_accuracy") === strlen($field_name) - 9){
					$tmp_acc[substr($field_name, 0, strlen($field_name) - 9)] = $field_name;
				}
			}
		}else{
			AppController::addWarningMsg('failed to build accuracy config for model ['.$this->name.'] because there is no schema. '
				.'To avoid this warning message you can add an empty array as a schema to your model. Eg.: <code>$model->_schema = array();</code>');
		}
		self::$accuracy_config[$this->table] = $tmp_acc;
	}
	
	private function setDataAccuracy(){
		if(!array_key_exists($this->table, self::$accuracy_config)){
			//build accuracy settings for that table
			$this->buildAccuracyConfig();
		}
		foreach(self::$accuracy_config[$this->table] as $date_field => $accuracy_field){
			if(!isset($this->data[$this->name][$date_field])){
				continue;
			}
			
			$current = &$this->data[$this->name][$date_field];
			if(empty($current)){
				$this->data[$this->name][$accuracy_field] = '';
				$current = null;
			}else{
				list($year, $month, $day) = explode("-", trim($current));
				$hour = null;
				$minute = null;
				if(strpos($day, ' ') !== false){
					$time = null;
					list($day, $time) = explode(" ", $day);
					list($hour, $minute) = explode(":", $time);
				}
				
				
				//used to avoid altering the date when its invalid
				$go_to_next_field = false;
				$plus_minus = false;
				if(strpos($year, '±') === 0){
					$plus_minus = true;
					$year = substr($year, 2);
				}
				foreach(array($year, $month, $day, $hour, $minute) as $field){
					if(!empty($field) && !is_numeric($field)){
						$go_to_next_field = true;
						break;
					}
				}
				if($go_to_next_field){
					continue;//if one of them is not empty AND not numeric
				}
				
				if(!empty($year)){
					if($plus_minus || (empty($month) && empty($day) && empty($hour) && empty($minute))){
						$month = '01';
						$day = '01';
						$hour = '00';
						$minute = '00';
						if($plus_minus){
							$this->data[$this->name][$accuracy_field] = 'y';
						}else{
							$this->data[$this->name][$accuracy_field] = 'm';
						}
					}else if(empty($day) && empty($hour) && empty($minute)){
						$day = '01';
						$hour = '00';
						$minute = '00';
						$this->data[$this->name][$accuracy_field] = 'd';
					}else if(empty($time)){
						$this->data[$this->name][$accuracy_field] = 'c';
					}else if(empty($hour) && empty($minute)){
						$hour = '00';
						$minute = '00';
						$this->data[$this->name][$accuracy_field] = 'h';
					}else if(empty($minute)){
						$minute = '00';
						$this->data[$this->name][$accuracy_field] = 'i';
					}else{
						$this->data[$this->name][$accuracy_field] = 'c';
					}
					$current = sprintf("%s-%02s-%02s", $year, $month, $day);
					if(!empty($time)){
						$current .= sprintf(" %02s:%02s:00", $hour, $minute);
					}
				}
			}
		}
	}
	
	function validates($options = array()){
		$settings = $this->Behaviors->MasterDetail->__settings[$this->name];
		
		if(!isset(self::$auto_validation[$this->name]) &&
			isset($this->Behaviors->MasterDetail) &&
			(strpos($this->name, 'Detail') === false ||
			!array_key_exists(str_replace('Detail', 'Master', $this->name), $this->Behaviors->MasterDetail->__settings))
		){
			//build master validation (detail validation are built within the validation function)
			self::buildAutoValidation($this->name, $this);
			if(array_key_exists($this->name, self::$auto_validation)){
				$this->validate = array_merge_recursive($this->validate, self::$auto_validation[$this->name]);
			}
		}
		$this->setDataAccuracy();

		if($this->Behaviors->MasterDetail->__settings[$this->name]['is_master_model']){
			//master detail, validate the details part
			$master_class		= $settings['master_class'];
			$control_foreign 	= $settings['control_foreign'];
			$control_class 		= $settings['control_class'];
			$detail_class		= $settings['detail_class'];
			$form_alias			= $settings['form_alias'];
			$detail_field		= $settings['detail_field'];

			$associated = NULL;
			if (isset($this->data[$master_class][$control_foreign]) && $this->data[$master_class][$control_foreign] ) {
				// use CONTROL_ID to get control row
				$associated = $this->$control_class->find('first',array('conditions' => array($control_class.'.id' => $this->data[$master_class][$control_foreign])));
			} else if(isset($this->id) && is_numeric($this->id)){
				// else, if EDIT, use MODEL.ID to get row and find CONTROL_ID that way...
				$associated = $this->find('first', array('conditions' => array($master_class.'.id' => $this->id)));
			}else if(isset($this->data[$master_class]['id']) && is_numeric($this->data[$master_class]['id'])){
				// else, (still EDIT), use use data[master_model][id] to get row and find CONTROL_ID that way...
				$associated = $this->find('first',array('conditions' => array($master_class.'.id' => $model->data[$this]['id'])));
			}
			
			if($associated == NULL || empty($associated)){
				//FAIL!, we ABSOLUTELY WANT validations
				AppController::getInstance()->redirect( '/pages/err_internal?p[]='.__CLASS__." @ line ".__LINE__." (the detail control id was not found for ".$master_class.")", NULL, TRUE );
				exit;
			}
			
			$use_form_alias = $associated[$control_class][$form_alias];
			$use_table_name = $associated[$control_class][$detail_field];
			if($use_form_alias){
				$detail_class_instance = new AppModel(array('table' => $use_table_name, 'name' => $detail_class, 'alias' => $detail_class));
				if(isset(AppController::getInstance()->{$detail_class}) && (!isset($params['validate']) || $params['validate'])){
					//attach auto validation
					$auto_validation_name = $detail_class.$associated[$control_class]['id'];
					
					if(!isset(self::$auto_validation[$auto_validation_name])){
						//build detail validation on the fly
						$this->buildAutoValidation($auto_validation_name, $detail_class_instance);
					}
					$detail_class_instance->validate = AppController::getInstance()->{$detail_class}->validate;
					foreach(self::$auto_validation[$auto_validation_name] as $field_name => $rules){
						if(!isset($detail_class_instance->validate[$field_name])){
							$detail_class_instance->validate[$field_name] = array();
						}
						$detail_class_instance->validate[$field_name] = array_merge($detail_class_instance->validate[$field_name], $rules);
					}
					$detail_class_instance->set($this->data);
					$valid_detail_class = $detail_class_instance->validates();
					if(!$valid_detail_class){
						//put details validation errors in the master model
						$this->validationErrors = array_merge($this->validationErrors, $detail_class_instance->validationErrors);
					}
				}
			}
		}
		parent::validates($options);
		return count($this->validationErrors) == 0;
	}
	
	static function getInstance($plugin_name, $class_name, $error_view_on_null){
		$instance = ClassRegistry::getObject($class_name);
		if($instance !== false && $instance instanceof $class_name){
			return $instance;
		}
		
		if($plugin_name != null && strlen($plugin_name) > 0){
			$plugin_name .= ".";
		}
		
		$import_name = (strlen($plugin_name) > 0 ? $plugin_name : "").$class_name;
		if(class_exists($class_name, false) || App::import('Model', $import_name)){
			$instance = ClassRegistry::init($plugin_name.$class_name, 'Model');
		}
		if($instance === false && $error_view_on_null){
			AppController::getInstance()->redirect( '/pages/err_model_import_failed?p[]='.$class_name, NULL, TRUE );
		}
		
		return $instance;
	}
	
	/**
	 * Use this function to instantiate extend models. It loads it based on the 
	 * table_name and and configures the shadow model
	 * @param class $class The class to instantiate
	 * @param string $table_name The table to use
	 * @return The instantiated class
	 */
	static function atimInstantiateExtend($class, $table_name){
		$extend = new $class(false, $table_name);
		$extend->Behaviors->Revision->setup($extend);//activate shadow model
		return $extend;
	}
	
	/**
	 * @desc Builds automatic string length validations based on the field type 
	 * @param string $use_name The name under which to record the validations
	 * @param string $model The model to base the validations on
	 */
	static function buildAutoValidation($use_name, $model){
		if(is_array($model->_schema)){
			$auto_validation = array();
			foreach($model->_schema as $field_name => $field_data){
				if($field_data['type'] == "string"){
					$auto_validation[$field_name][] = array(
								'rule' => array("maxLength", $field_data['length']), 
								'allowEmpty' => true, 
								'required' => null,
								'message' => sprintf(__("the string length must not exceed %d characters", true), $field_data['length'])
					);
				}
			}
			self::$auto_validation[$use_name] = $auto_validation;
		}
	}

	/**
	 * Searches recursively for field in CakePHP SQL conditions
	 * @param string $field The field to look for
	 * @param array $conditions CakePHP SQL conditionnal array
	 * @return true if the field was found
	 */
	static function isFieldUsedAsCondition($field, array $conditions){
		foreach($conditions as $key => $value){
			$is_array = is_array($value);
			$pos1 = strpos($key, $field);
			$pos2 = strpos($key, " ");
			if($pos1 !== false && ($pos2 === false || $pos1 < $pos2)){
				return true;
			}
			if($is_array){
				if(self::isFieldUsedAsCondition($field, $value)){
					return true;
				}
			}else{
				$pos1 = strpos($value, $field);
				$pos2 = strpos($value, " ");
				if($pos1 !== false && ($pos2 === false || $pos1 < $pos2)){
					return true;
				}
			}
		}
		return false;
	}
	
	/**
	 * Return the spent time between 2 dates. 
	 * Notes: The supported date format is YYYY-MM-DD HH:MM:SS
	 * 
	 * @param $start_date Start date
	 * @param $end_date End date
	 * 
	 * @return Return an array that contains the spent time
	 * or an error message when the spent time can not be calculated.
	 * The sturcture of the array is defined below:
	 *	Array (
	 * 		'message' => '',
	 * 		'days' => '0',
	 * 		'hours' => '0',
	 * 		'minutes' => '0'
	 * 	)
	 * 
	 * @author N. Luc
	 * @since 2007-06-20
	 */
	 
	static function getSpentTime($start_date, $end_date){
		$arr_spent_time 
			= array(
				'message' => null,
				'days' => '0',
				'hours' => '0',
				'minutes' => '0');
		
		$empty_date = '0000-00-00 00:00:00';
		
		// Verfiy date is not empty
		if(empty($start_date)||empty($end_date)
		|| (strcmp($start_date, $empty_date) == 0)
		|| (strcmp($end_date, $empty_date) == 0)){
			// At least one date is missing to continue
			$arr_spent_time['message'] = 'missing date';	
		} else {
			$start = AppModel::getTimeStamp($start_date);
			$end = AppModel::getTimeStamp($end_date);
			$spent_time = $end - $start;
			
			if(($start === false)||($end === false)){
				// Error in the date
				$arr_spent_time['message'] = 'error: unable to define date';
			} else if($spent_time < 0){
				// Error in the date
				$arr_spent_time['message'] = 'error in the date definitions';
			} else if($spent_time == 0){
				// Nothing to change to $arr_spent_time
				$arr_spent_time['message'] = '0';
			} else {
				// Return spend time
				$arr_spent_time['days'] = floor($spent_time / 86400);
				$diff_spent_time = $spent_time % 86400;
				$arr_spent_time['hours'] = floor($diff_spent_time / 3600);
				$diff_spent_time = $diff_spent_time % 3600;
				$arr_spent_time['minutes'] = floor($diff_spent_time / 60);
				if($arr_spent_time['minutes']<10) {
					$arr_spent_time['minutes'] = '0' . $arr_spent_time['minutes'];
				}
			}
			
		}
		
		return $arr_spent_time;
	}

	/**
	 * Return time stamp of a date. 
	 * Notes: The supported date format is YYYY-MM-DD HH:MM:SS
	 * 
	 * @param $date_string Date
	 * @param $end_date End date
	 * 
	 * @return Return time stamp of the date.
	 * 
	 * @author N. Luc
	 * @since 2007-06-20
	 */
	 
	static function getTimeStamp($date_string){
		list($date, $time) = explode(' ', $date_string);
		list($year, $month, $day) = explode('-', $date);
		list($hour, $minute, $second) = explode(':',$time);

		return mktime($hour, $minute, $second, $month, $day, $year);
	}	
	
	static function manageSpentTimeDataDisplay($spent_time_data) {
		$spent_time_msg = '';
		if(!empty($spent_time_data)) {	
			if(!is_null($spent_time_data['message'])) {
				if($spent_time_data['message'] == '0') {
					$spent_time_msg = $spent_time_data['message'];
				} else if(strcmp('error in the date definitions', $spent_time_data['message']) == 0) {
					$spent_time_msg = '<span class="red">'.__($spent_time_data['message'], TRUE).'</span>';
				} else {
					$spent_time_msg = __($spent_time_data['message'], TRUE);
				}
			} else {
				$spent_time_msg = AppModel::translateDateValueAndUnit($spent_time_data, 'days') 
								.AppModel::translateDateValueAndUnit($spent_time_data, 'hours') 
								.AppModel::translateDateValueAndUnit($spent_time_data, 'minutes');
			} 	
		}
		
		return $spent_time_msg;
	}
	
	static function translateDateValueAndUnit($spent_time_data, $time_unit) {
		if(array_key_exists($time_unit, $spent_time_data)) {
			return (((!empty($spent_time_data[$time_unit])) && ($spent_time_data[$time_unit] != '00'))? ($spent_time_data[$time_unit] . ' ' . __($time_unit, TRUE) . ' ') : '');
		} 
		return  '#err#';
	}
	
	/**
	 * Uses the same url sorting options as cakephp paginator uses to sort a data array
	 * @param array $data The data to sort
	 * @param array $passed_args The controller passed arguments. (From the controller, $this->passedArgs)
	 * @return The data sorted if the passed_args were compatible with it
	 */
	static function sortWithUrl(array $data, array $passed_args){
		$order = array();
		if(isset($passed_args['sort'])){
			$result = array();
			list($sort_model, $sort_field) = explode(".", $passed_args['sort']);
			$i = 0;
			foreach($data as $data_unit){
				if(isset($data_unit[$sort_model]) && isset($data_unit[$sort_model][$sort_field])){
					$result[sprintf("%s%04d", $data_unit[$sort_model][$sort_field], ++ $i)] = $data_unit;
				}else{
					$result[sprintf("%04d", ++ $i)] = $data_unit;
				}
			}
			ksort($result);
			if(isset($passed_args['direction']) && $passed_args['direction'] == 'desc'){
				$result = array_reverse($result);
			}
			return $result;
		}
		return $data;
	}
	
	/**
	 * Generic function made to be overriden in model/custom models.
	 * @param int $id The db id of the element to allow the deletion of
	 * @return array with two keys, one being allow_detion, a boolean telling
	 * whether the element can be deleted or not and the second one being msg,
	 * a string that telles why, if relevant, the element cannot be deleted.
	 */
	function allowDeletion($id){
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Redirects to the missing data page if a model id cannot be fetched
	 * @param int $id
	 * @param string $method The method name to display in the error message
	 * @param string $line The line number to display in the error message
	 * @param bool $return Returns the data line if it exists
	 * @return null if $return is true and the data exists, the data, null otherwise
	 */
	function redirectIfNonExistent($id, $method, $line, $return = false){
		$this->id = $id;
		$result = null;
		if(!$this->exists()){
			AppController::getInstance()->redirect( '/pages/err_plugin_no_data?method='.$method.',line='.$line, null, true );
		}
		if($return){
			if($this->primaryKey == 'id'){
				$result = $this->findById($id); 
			}else{
				$result = $this->find('first', array('conditions' => array($this->name.'.'.$this->primaryKey => $id)));
			}
		}
		return $result;
	}
}

?>