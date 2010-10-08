<?php
class AppController extends Controller {
	
	// var $uses			= array('Config', 'Aco', 'Aro', 'Permission');
	private static $missing_translations = array();
	private static $me = NULL;
	public static $beignFlash = false;
	var $uses = array('Config');
	var $components	= array( 'Session', 'SessionAcl', 'Auth', 'Menus', 'RequestHandler', 'Structures', 'PermissionManager' );
	var $helpers		= array('Ajax', 'Csv', 'Html', 'Javascript', 'Shell', 'Structures', 'Time');
	
	//use AppController::getCalInfo to get those with translations
	private static $cal_info_short = array(1 => 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
	private static $cal_info_long = array(1 => 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
	private static $cal_info_short_translated = false;
	private static $cal_info_long_translated = false;
	
	function beforeFilter() {
		AppController::$me = $this;
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
			$log_activity_data['UserLog']['visited'] = date('Y-m-d h:i:s');
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
			$this->set( 'atim_menu_for_header', $this->Menus->get('/menus/tools') );
			
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
			$query = "INSERT IGNORE INTO missing_translations VALUES ";
			foreach(AppController::$missing_translations as $missing_translation){
				$query .= '("'.str_replace('"', '\\"', str_replace("\\", "\\\\", $missing_translation)).'"), ';
			}
			$query = substr($query, 0, strlen($query) -2);
			$this->{$this->params["models"][0]}->query($query);
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
	
		// ATiM2 configuration variables from Datatable
		
		define('VALID_INTEGER', '/^[-+]?[\\s]?[0-9]+[\\s]?$/');
		define('VALID_INTEGER_POSITIVE', '/^[+]?[\\s]?[0-9]+[\\s]?$/');
		define('VALID_FLOAT', '/^[-+]?[\\s]?[0-9]*[,\\.]?[0-9]+[\\s]?$/');
		define('VALID_FLOAT_POSITIVE', '/^[+]?[\\s]?[0-9]*[,\\.]?[0-9]+[\\s]?$/');
		
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
			$config_results = $config_data_model->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND user_id="'.$logged_in_user.'"'));
		}
		// if not logged in user, or user has no CONFIG, get CONFIG for GROUP level
		if ( $logged_in_group && (!count($config_results) || !$config_results) ) {
			$config_results = $config_data_model->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND Config.group_id="'.$logged_in_group.'" AND (user_id="0" OR user_id IS NULL)'));
		}
		// if not logged in user, or user has no CONFIG, get CONFIG for APP level
		if ( !count($config_results) || !$config_results ) {
			$config_results = $config_data_model->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND (user_id="0" OR user_id IS NULL)'));
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
				AppController::$cal_info_short_translated = array_map(create_function('$a', 'return __($a, true);'), AppController::$cal_info_short);
			}
			return AppController::$cal_info_short;			
		}else{
			if(!AppController::$cal_info_long_translated){
				AppController::$cal_info_long_translated = array_map(create_function('$a', 'return __($a, true);'), AppController::$cal_info_long);
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
		$divider = $nbsp_spaces ? "&nbsp;" : " ";
		if(is_numeric($month)){
			$month_str = AppController::getCalInfo($short_months);
			$month = $month_str[(int)$month];
		}
		if(date_format == 'MDY') {
			$result = $month.$divider.$day.$divider.$year;
		}else if (date_format == 'YMD') {
			$result = $year.$divider.$month.$divider.$day;
		}else { // default of DATE_FORMAT=='DMY'
			$result = $day.$divider.$month.$divider.$year;
		}
		return $result;
	}
	
	/**
	 * 
	 * Enter description here ...
	 * @param $datetime_string String with format yyyy-MM-dd hh:mm:ss
	 * @param boolean $nbsp_spaces True if white spaces must be printed as &nbsp;
	 * @param boolean $short_months True if months names should be short (used if $month is an int)
	 * @return string The formated datestring with user preferences
	 */
	static function getFormatedDatetimeString($datetime_string, $nbsp_spaces = true, $short_months = true){
			list($date, $time) = explode(" ", $datetime_string);
			list($year, $month, $day) = explode("-", $date);
			$formated_date = AppController::getFormatedDateString($year, $month, $day);
			return $formated_date.($nbsp_spaces ? "&nbsp;" : "").$time;
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
	
	static function addWarningMsg($msg){
		$_SESSION['ctrapp_core']['warning_msg'][] = $msg;
	}
	
	static function getStackTrace(){
		$bt = debug_backtrace();
		$result = array();
		foreach($bt as $unit){
			$result[] = $unit['file'].", ".$unit['function']." at line ".$unit['line'];
		}
		return $result;
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
?>