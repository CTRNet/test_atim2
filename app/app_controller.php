<?php
class AppController extends Controller {
	
	// var $uses			= array('Config', 'Aco', 'Aro', 'Permission');
	private static $missing_translations = array();
	private static $me = NULL;
	private static $acl = null;
	public static $beignFlash = false;
	var $uses = array('Config');
	var $components	= array( 'Session', 'SessionAcl', 'Auth', 'Menus', 'RequestHandler', 'Structures', 'PermissionManager' );
	var $helpers		= array('Ajax', 'Csv', 'Html', 'Javascript', 'Shell', 'Structures', 'Time');
	
	//use AppController::getCalInfo to get those with translations
	private static $cal_info_short = array(1 => 'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec');
	private static $cal_info_long = array(1 => 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
	private static $cal_info_short_translated = false;
	private static $cal_info_long_translated = false;
	
	function beforeFilter() {
		AppController::$me = $this;
		if(Configure::read('debug') != 0){
			Cache::clear(false, "structures");
			Cache::clear(false, "menus");
		}
		
		if(Configure::read('Config.language') != $this->Session->read('Config.language')){
			//set language
			$this->Session->write('Config.language', Configure::read('Config.language')); 
		}
		// Uncomment the following to create an Aco entry for every plugin/controller/method combination in the app.
			// $this->buildAcl();
		// Uncomment the following to set up default permissions.
			// $this->initDB();
			
		// Configure AuthComponent
			$this->Auth->authorize = 'actions';
			$this->Auth->loginAction = array('controller' => 'users', 'action' => 'login', 'plugin' => '');
			$this->Auth->loginRedirect = array('controller' => 'menus', 'action' => 'index', 'plugin' => '');
			$this->Auth->logoutRedirect = array('controller' => 'users', 'action' => 'login', 'plugin' => '');
			$this->Auth->userScope = array('User.flag_active' => true);
			$this->Auth->actionPath = 'controllers/App/';
			$this->Auth->allowedActions = array();
			
			//homemade hack because the core seems bugged, see layouts/default.ctp
			$this->set("msg_auth", $this->Session->read("Message.auth"));
		// record URL in logs
			
			$log_activity_data['UserLog']['user_id']  = $this->Session->read('Auth.User.id');
			$log_activity_data['UserLog']['url']  = $this->here;
			$log_activity_data['UserLog']['visited'] = now();
			// $log_activity_data['UserLog']['allowed'] = $this->_othCheckPermission($row) ? '1' : '0';
			$log_activity_data['UserLog']['allowed'] = 1;
			
			if ( isset($this->UserLog) ) {
				$log_activity_model =& $this->UserLog;
			} else {
				App::import('model', 'UserLog');
				$log_activity_model = new UserLog;
			}
			
			$log_activity_model->save($log_activity_data);
			
		// menu grabbed for HEADER
			$atim_sub_menu_for_header = array();
			$menu_model = AppModel::getInstance("", "Menu", true);
			$atim_sub_menu_for_header['qry-CAN-1'] = $menu_model->find('all', array('conditions' => array('Menu.parent_id' => 'qry-CAN-1'), 'order' => array('Menu.display_order')));
			$atim_sub_menu_for_header['core_CAN_33'] = $menu_model->find('all', array('conditions' => array('Menu.parent_id' => 'core_CAN_33'), 'order' => array('Menu.display_order')));
		
			$this->set( 'atim_menu_for_header', $this->Menus->get('/menus/tools'));
			$this->set( 'atim_sub_menu_for_header', $atim_sub_menu_for_header);
			
		// menu, passed to Layout where it would be rendered through a Helper
			$this->set( 'atim_menu_variables', array() );
			$this->set( 'atim_menu', $this->Menus->get() );
		
		// get default STRUCTRES, used for forms, views, and validation	
			$this->Structures->set();
			
	}
	
	function hook( $hook_extension='' ) {
		if ( $hook_extension ) $hook_extension = '_'.$hook_extension;
		
		$hook_file = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].$hook_extension.'.php';
		if ( !file_exists($hook_file) ) $hook_file=false;
		
		return $hook_file;
	}
	
	function afterFilter(){
		global $start_time;
//		echo("Exec time (sec): ".(AppController::microtime_float() - $start_time));
		
		if(sizeof(AppController::$missing_translations) > 0){
			App::import("Model", "MissingTranslation");
			$mt = new MissingTranslation();
			foreach(AppController::$missing_translations as $missing_translation){
				$mt->set(array("MissingTranslation" => array("id" => $missing_translation)));
				$mt->save();//ignore errors, kind of insert ingnore
			}
		}
	}
	
	/**
	 * Simple function to replicate PHP 5 behaviour
	 */
	static function microtime_float(){
		list($usec, $sec) = explode(" ", microtime());
		return ((float)$usec + (float)$sec);
	}

	function missingTranslation(&$word){
		if(!is_numeric($word) && strpos($word, "<span class='untranslated'>") === false){
			AppController::$missing_translations[] = $word;
			if(Configure::read('debug') == 2){
				$word = "<span class='untranslated'>".$word."</span>";
//				$word .= "[untr]";
			}
		}
	}
	
	function atimFlash($message, $url){
		if(Configure::read('debug') > 0){
			$this->flash($message, $url);
		}else{
			$_SESSION['ctrapp_core']['confirm_msg'] = __($message, true);
			$this->redirect($url);
		}
	}
	
	static function getInstance(){
		return AppController::$me;
	}
	
	/**
	 * Takes an array of the form array("A => array("B" => "1", "C" => "2")) 
	 * to the form array("A.B" => "1", "A.C" => "2")
	 * @param flattened array
	 */
	static function flattenArray($arr){
		$result = array();
		foreach($arr as $k1 => $sub_arr){
			foreach($sub_arr as $k2 => $val){
				$result[$k1.".".$k2] = $val;
			}
		}
		return $result;
	}
	
	static function init(){
		Configure::write('Config.language', 'eng');
	
		App::import('model','AtimAcl');
		Configure::write('Acl.classname', 'AtimAcl');
		Configure::write('Acl.database', 'default');
	
		define('CONFIDENTIAL_MARKER', 'Confidential Data');
		
		// ATiM2 configuration variables from Datatable
		
		define('VALID_INTEGER', '/^[-+]?[\\s]?[0-9]+[\\s]?$/');
		define('VALID_INTEGER_POSITIVE', '/^[+]?[\\s]?[0-9]+[\\s]?$/');
		define('VALID_FLOAT', '/^[-+]?[\\s]?[0-9]*[,\\.]?[0-9]+[\\s]?$/');
		define('VALID_FLOAT_POSITIVE', '/^[+]?[\\s]?[0-9]*[,\\.]?[0-9]+[\\s]?$/');
		define('VALID_24TIME', '/^([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$/');
		
		//ripped from validation.php date + time
		define('VALID_DATETIME_YMD', '%^(?:(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))(-)(?:0?2\\1(?:29)))|(?:(?:(?:1[6-9]|2\\d)\\d{2})(-)(?:(?:(?:0?[13578]|1[02])\\2(?:31))|(?:(?:0?(1|[3-9])|1[0-2])\\2(29|30))|(?:(?:0?[1-9])|(?:1[0-2]))\\2(?:0?[1-9]|1\\d|2[0-8])))\s([0-1][0-9]|2[0-3])\:[0-5][0-9]\:[0-5][0-9]$%');
	
		// parse URI manually to get passed PARAMS
		global $start_time;
		$start_time = AppController::microtime_float();	

		$request_uri_params = array();
		
		//Fix REQUEST_URI on IIS
		if (!isset($_SERVER['REQUEST_URI'])){
			$_SERVER['REQUEST_URI'] = substr($_SERVER['PHP_SELF'], 1);
			if (isset($_SERVER['QUERY_STRING'])){
				$_SERVER['REQUEST_URI'] .= '?'.$_SERVER['QUERY_STRING']; 
			}
		}
		$request_uri = $_SERVER['REQUEST_URI'];
		$request_uri = explode('/',$request_uri);
		$request_uri = array_filter($request_uri);
		
		foreach ( $request_uri as $uri ) {
			$exploded_uri = explode(':',$uri);
			if ( count($exploded_uri)>1 ) {
				$request_uri_params[ $exploded_uri[0] ] = $exploded_uri[1];
			}
		}
		
		// import APP code required...
		App::import('model', 'Config');
		$config_data_model = new Config;
		App::import('component', 'Session');
		$config_session_component = new SessionComponent;
		
		// get CONFIG data from table and SET
		$config_results	= false;
		
		$logged_in_user	= $config_session_component->read('Auth.User.id');
		$logged_in_group	= $config_session_component->read('Auth.User.group_id');
		
		// get CONFIG for logged in user
		if ( $logged_in_user ) {
			$config_results = $config_data_model->find('first', array('conditions'=> array(
				array("OR" => array("bank_id" => 0, "bank_id IS NULL")),
				array("OR" => array("group_id" => 0, "group_id IS NULL")),
				"user_id" => $logged_in_user
			)));
		}
		// if not logged in user, or user has no CONFIG, get CONFIG for GROUP level
		if ( $logged_in_group && (!count($config_results) || !$config_results) ) {
			$config_results = $config_data_model->find('first', array('conditions'=> array(
				array("OR" => array("bank_id" => 0, "bank_id IS NULL")),
				"Config.group_id" => $logged_in_group,
				array("OR" => array("user_id" => 0, "user_id IS NULL"))
			)));
		}
		// if not logged in user, or user has no CONFIG, get CONFIG for APP level
		if ( !count($config_results) || !$config_results ) {
			$config_results = $config_data_model->find('first', array('conditions'=> array(
				array("OR" => array("bank_id" => 0, "bank_id IS NULL")),
				array("OR" => array("group_id" => 0, "group_id IS NULL")),
				array("OR" => array("user_id" => 0, "user_id IS NULL"))
			)));
		}
		
		// parse result, set configs/defines
		if ( $config_results ) {
			Configure::write('Config.language', $config_results['Config']['config_language']);
			foreach ( $config_results['Config'] as $config_key=>$config_data ) {
				if ( strpos($config_key,'_')!==false ) {
					
					// break apart CONFIG key
					$config_key = explode('_',$config_key);
					$config_format = array_shift($config_key);
					$config_key = implode('_',$config_key);
					
					// if a DEFINE or CONFIG, set new setting for APP
					if ( $config_format=='define' ) {
						
						// override DATATABLE value with URI PARAM value
						if ( $config_key=='pagination_amount' && isset($request_uri_params['per']) ) {
							$config_data = $request_uri_params['per'];
						}
						
						define($config_key, $config_data);
					} else if ( $config_format=='config' ) {
						Configure::write($config_key, $config_data);
					}
				}
			}
		}
		if(Configure::read('debug') == 0){
			set_error_handler("myErrorHandler");
		}
	}
	
	/**
	 * Recursively removes empty parts of an array. It includes empty arrays.
	 * @param array &$arr The array to clean
	 */
	static function cleanArray(&$arr){
		foreach($arr as $k => $foo){
			if(is_array($arr[$k])){
				AppController::cleanArray($arr[$k]);
			}
			if(empty($arr[$k]) || (is_array($arr[$k]) && count($arr[$k]) == 0) || (is_string($arr[$k]) && strlen(trim($arr[$k])) == 0)){
				unset($arr[$k]);
			}
		}
	}
	
	/**
	 * @param boolean $short Wheter to return short or long month names
	 * @return an associative array containing the translated months names so that key = month_number and value = month_name 
	 */
	static function getCalInfo($short = true){
		if($short){
			if(!AppController::$cal_info_short_translated){
				AppController::$cal_info_short_translated = true;
				AppController::$cal_info_short = array_map(create_function('$a', 'return __($a, true);'), AppController::$cal_info_short);
			}
			return AppController::$cal_info_short;			
		}else{
			if(!AppController::$cal_info_long_translated){
				AppController::$cal_info_long_translated = true;
				AppController::$cal_info_long = array_map(create_function('$a', 'return __($a, true);'), AppController::$cal_info_long);
			}
			return AppController::$cal_info_long;
		}	
	}
	
	/**
	 * @param int $year
	 * @param mixed int | string $month
	 * @param int $day
	 * @param boolean $nbsp_spaces True if white spaces must be printed as &nbsp;
	 * @param boolean $short_months True if months names should be short (used if $month is an int)
	 * @return string The formated datestring with user preferences
	 */
	static function getFormatedDateString($year, $month, $day, $nbsp_spaces = true, $short_months = true){
		$result = null;
		if(empty($year) && empty($month) && empty($day)){
			$result = "";
		}else{
			$divider = $nbsp_spaces ? "&nbsp;" : " ";
			if(is_numeric($month)){
				$month_str = AppController::getCalInfo($short_months);
				$month = $month > 0 && $month < 13 ? $month_str[(int)$month] : "-";
			}
			if(date_format == 'MDY') {
				$result = $month.(empty($month) ? "" : $divider).$day.(empty($day) ? "" : $divider).$year;
			}else if (date_format == 'YMD') {
				$result = $year.(empty($month) ? "" : $divider).$month.(empty($day) ? "" : $divider).$day;
			}else { // default of DATE_FORMAT=='DMY'
				$result = $day.(empty($day) ? "" : $divider).$month.(empty($month) ? "" : $divider).$year;
			}
		}
		return $result;
	}
	
	static function getFormatedTimeString($hour, $minutes, $nbsp_spaces = true){
		if(time_format == 12){
			$meridiem = $hour >= 12 ? "PM" : "AM";
			$hour %= 12;
			if($hour == 0){
				$hour = 12;
			}
			return $hour.(empty($minutes) ? '' : ":".$minutes.($nbsp_spaces ? "&nbsp;" : " ")).$meridiem;
		}else if(empty($minutes)){
			return $hour.__('hour_sign', true);
		}else{
			return $hour.":".$minutes;
		}
	}
	
	/**
	 * 
	 * Enter description here ...
	 * @param $datetime_string String with format yyyy[-MM[-dd[ hh[:mm:ss]]]] (missing parts represent the accuracy
	 * @param boolean $nbsp_spaces True if white spaces must be printed as &nbsp;
	 * @param boolean $short_months True if months names should be short (used if $month is an int)
	 * @return string The formated datestring with user preferences
	 */
	static function getFormatedDatetimeString($datetime_string, $nbsp_spaces = true, $short_months = true){
		$month = null;
		$day = null;
		$hour = null;
		$minutes = null;
		if(strpos($datetime_string, ' ') === false){
			$date = $datetime_string;
		}else{
			list($date, $time) = explode(" ", $datetime_string);
			if(strpos($time, ":") === false){
				$hour = $time;
			}else{
				list($hour, $minutes, ) = explode(":", $time);
			}
		}
		
		$date = explode("-", $date);
		$year = $date[0];
		switch(count($date)){
			case 3:
				$day = $date[2];
			case 2:
				$month = $date[1];
				break;
		}
		$formated_date = self::getFormatedDateString($year, $month, $day, $nbsp_spaces);
		return $hour === null ? $formated_date : $formated_date.($nbsp_spaces ? "&nbsp;" : " ").self::getFormatedTimeString($hour, $minutes, $nbsp_spaces);
	}
	
	/**
	 * Return formatted date in SQL format from a date array returned by an application form.
	 * 
	 * @param $datetime_array Array gathering date data into following structure:
	 * 	array('month' => string, '
	 * 		'day' => string, 
	 * 		'year' => string, 
	 * 		'hour' => string, 
	 * 		'min' => string)
	 * @param $date_type  Specify the type of date ('normal', 'start', 'end')
	 * 		- normal => Will force function to build a date witout specific rules.
	 *      - start => Will force function to build date as a 'start date' of date range defintion 
	 *    		(ex1: when just year is specified, will return a value like year-01-01 00:00)
	 *    		(ex2: when array is empty, will return a value like -9999-99-99 00:00)
	 *      - end => Will force function to build date as an 'end date' of date range defintion 
	 *    		(ex1: when just year is specified, will return a value like year-12-31 23:59)
	 *    		(ex2: when array is empty, will return a value like 9999-99-99 23:59)      
	 * 
	 * @return string The formated SQL date having following format yyyy-MM-dd hh:mn
	 */
	static function getFormatedDatetimeSQL($datetime_array, $date_type = 'normal') {
		
		$formatted_date = '';
		switch($date_type) {
			case 'normal':
				if((!empty($datetime_array['year'])) && (!empty($datetime_array['month'])) && (!empty($datetime_array['day']))) {
					$formatted_date =  $datetime_array['year'].'-'.$datetime_array['month'].'-'.$datetime_array['day'];
				}
				if((!empty($formatted_date)) && (!empty($datetime_array['hour']))) {
					$formatted_date .= ' '.$datetime_array['hour'].':'.(empty($datetime_array['min'])? '00':$datetime_array['min']);
				}
				break;
				
			case 'start':
				if(empty($datetime_array['year'])) {
					$formatted_date = '-9999-99-99 00:00';
				} else {
					$formatted_date = $datetime_array['year'];
					if(empty($datetime_array['month'])) {
						$formatted_date .= '-01-01 00:00';
					} else {
						$formatted_date .= '-'.$datetime_array['month'];
						if(empty($datetime_array['day'])) {
							$formatted_date .= '-01 00:00';
						} else {
							$formatted_date .= '-'.$datetime_array['day'];
							if(empty($datetime_array['hour'])) {
								$formatted_date .= ' 00:00';
							} else {							
								$formatted_date .= ' '.$datetime_array['hour'].':'.(empty($datetime_array['min'])?'00':$datetime_array['min']);
							}
						}
					}
				}
				break;
				
			case 'end':
				if(empty($datetime_array['year'])) {
					$formatted_date = '9999-12-31 23:59';
				} else {
					$formatted_date = $datetime_array['year'];
					if(empty($datetime_array['month'])) {
						$formatted_date .= '-12-31 23:59';
					} else {
						$formatted_date .= '-'.$datetime_array['month'];
						if(empty($datetime_array['day'])) {
							$formatted_date .= '-31 23:59';
						} else {
							$formatted_date .= '-'.$datetime_array['day'];
							if(empty($datetime_array['hour'])) {
								$formatted_date .= ' 23:59';
							} else {							
								$formatted_date .= ' '.$datetime_array['hour'].':'.(empty($datetime_array['min'])?'59':$datetime_array['min']);
							}
						}
					}
				}
				break;
				
			default:		
		}
		
		return $formatted_date;
	}
	
	/**
	 * Clones the first level of an array
	 * @param array $arr The array to clone
	 */
	static function cloneArray(array $arr){
		$result = array();
		foreach($arr as $k => $v){
			if(is_array($v)){
				$result[$k] = self::cloneArray($v);
			}else{
				$result[$k] = $v;
			}
		}
		return $result;
	}
	
	static function addWarningMsg($msg){
		if(isset($_SESSION['ctrapp_core']['warning_msg'][$msg])){
			$_SESSION['ctrapp_core']['warning_msg'][$msg] ++;
		}else{
			$_SESSION['ctrapp_core']['warning_msg'][$msg] = 1;
		}
	}
	
	static function getStackTrace(){
		$bt = debug_backtrace();
		$result = array();
		foreach($bt as $unit){
			$result[] = $unit['file'].", ".$unit['function']." at line ".$unit['line'];
		}
		return $result;
	}
	
	/**
	 * Builds the value definition array for an updateAll call
	 * @param array They data array to build the values with
	 */
	static function getUpdateAllValues(array $data){
		$result = array();
		foreach($data as $model => $fields){
			foreach($fields as $name => $value){
				if(is_array($value)){
					if(strlen($value['year'])){
						$result[$model.".".$name] = "'".AppController::getFormatedDatetimeSQL($value)."'";
					}
				}else if(strlen($value)){
					$result[$model.".".$name] = "'".$value."'";
				}
			}
		}
		return $result;
	}
	
	/**
	 * @desc cookie manipulation to counter cake problems. see eventum #1032
	 */
	static function atimSetCookie(){
		$session_delay = Configure::read("Session.timeout") * (Configure::read("Security.level") == "low" ? 1800 : 100);
		if(isset($_COOKIE[Configure::read("Session.cookie")])){
			setcookie(Configure::read("Session.cookie"), $_COOKIE[Configure::read("Session.cookie")], mktime() + $session_delay, "/");
		}
		return $session_delay;
	}
	
	/**
	 * @desc Global function to initialize a batch action. Redirect/flashes on error.
	 * @param AppModek $model The model to work on
	 * @param string $data_model_name The model name used in $this->data
	 * @param string $data_key The data key name used in $this->data
	 * @param string $control_key_name The name of the control field used in the model table
	 * @param AppModel $possibilities_model The model to fetch the possibilities from
	 * @param string $possibilities_parent_key The possibilities parent key to base the search on
	 * @return An array with the ids and the possibilities
	 */
	function batchInit($model, $data_model_name, $data_key, $control_key_name, $possibilities_model, $possibilities_parent_key, $no_possibilities_msg){
		if(empty($this->data)){
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		} else if(!is_array($this->data[$data_model_name][$data_key]) && strpos($this->data[$data_model_name][$data_key], ',')){
			//User launched action from databrowser but the number of items was bigger than DatamartAppController->display_limit
			return array('error' => "batch init - number of submitted records too big");
		}
		//extract valid ids
		$ids = $model->find('all', array('conditions' => array($model->name.'.id' => $this->data[$data_model_name][$data_key]), 'fields' => array('GROUP_CONCAT('.$model->name.'.id) AS ids'), 'recursive' => -1));
		$ids = $ids[0][0]['ids'];
		if(empty($ids)){
			return array('error' => "batch init no data");
		}
		
		$controls = $model->find('all', array('conditions' => array($model->name.'.id' => explode(',', $ids)), 'fields' => array($model->name.'.'.$control_key_name), 'group' => array($model->name.'.'.$control_key_name), 'recursive' => -1));
		if(count($controls) != 1){
			return array('error' => "you must select elements with a common type");
		}
		
		$possibilities = $possibilities_model->find('all', array('conditions' => array($possibilities_parent_key => $controls[0][$model->name][$control_key_name], 'flag_active' => '1')));
		
		if(empty($possibilities)){
			return array('error' => $no_possibilities_msg);
		}
		
		return array('ids' => $ids, 'possibilities' => $possibilities, 'control_id' => $controls[0][$model->name][$control_key_name]);
	}
	
	/**
	 * Replaces the array key (generally of a find) with an inner value
	 * @param array $in_array
	 * @param string $model The model ($in_array[$model])
	 * @param string $field The field (new key = $in_array[$model][$field])
	 * @param bool $unique If true, the array block will be directly under the model.field, not in an array.
	 * @return array
	 */
	static function defineArrayKey($in_array, $model, $field, $unique = false){
		$out_array = array();
		if($unique){
			foreach($in_array as $val){
				$out_array[$val[$model][$field]] = $val;
			}
		}else{
			foreach($in_array as $val){
				if(isset($val[$model])){
					$out_array[$val[$model][$field]][] = $val;
				}else{
					//the key cannot be foud
					$out_array[-1][] = $val;
				}
			}
			
		}
		return $out_array;
	}
	
	static function removeEmptyValues(array &$data){
		foreach($data as $key => &$val){
			if(is_array($val)){
				self::removeEmptyValues($val);
			}
			if(empty($val)){
				unset($data[$key]);
			}
		}
	}
	
	static function getNewSearchId(){
		return $_SESSION['Auth']['User']['search_id'] ++;
	}
	
	/**
	* @param string $link The link to check
	* @return True if the user can access that page, false otherwise
	*/
	static function checkLinkPermission($link){
		$parts = Router::parse($link);
		$aco_alias = 'controllers/'.($parts['plugin'] ? Inflector::camelize($parts['plugin']).'/' : '');
		$aco_alias .= ($parts['controller'] ? Inflector::camelize($parts['controller']).'/' : '');
		$aco_alias .= ($parts['action'] ? $parts['action'] : '');
	
		if (self::$acl == null) {
			self::$acl = new SessionAclComponent();
			self::$acl->initialize($this);
		}
		
		$instance = AppController::getInstance();
	
		return strpos($aco_alias,'controllers/Users') !== false
		|| strpos($aco_alias,'controllers/Pages') !== false
		|| $aco_alias == "controllers/Menus/index"
		|| self::$acl->check('Group::'.$instance->Session->read('Auth.User.group_id'), $aco_alias);
	}
}

	AppController::init();

	function myErrorHandler($errno, $errstr, $errfile, $errline, $context = null){
		if(class_exists("CakeLog")){
			$CakeLog = CakeLog::getInstance();
			$CakeLog->handleError($errno, $errstr, $errfile, $errline, $context);
		}
		if(class_exists("AppController")){
			$controller = AppController::getInstance();
			if($errno == E_USER_WARNING && strpos($errstr, "SQL Error:") !== false && $controller->name != 'Pages'){
				$traceMsg = "<table><tr><th>File</th><th>Line</th><th>Function</th></tr>";
				try{
					throw new Exception("");
				}catch(Exception $e){
					$traceArr = $e->getTrace();
					foreach($traceArr as $traceLine){
						if(is_array($traceLine)){
							$traceMsg .= "<tr><td>"
								.(isset($traceLine['file']) ? 
								$traceLine['file'] : "")
								."</td><td>"
								.(isset($traceLine['line']) ? 
								$traceLine['line'] : "")
								."</td><td>".$traceLine['function']."</td></tr>";
						}else{
							$traceMsg .= "<tr><td></td><td></td><td></td></tr>";
						}
					}
				}
				$traceMsg .= "</table>";
				$controller->redirect('/pages/err_query?err_msg='.urlencode($errstr.$traceMsg));
			}
		}
	}
	
	/**
	 * Returns the date in a classic format (usefull for SQL)
	 * @throws Exception
	 */
	function now(){
		return date("Y-m-d H:i:s");	
	}
?>