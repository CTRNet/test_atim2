<?php
class AppController extends Controller {
	
	// var $uses			= array('Config', 'Aco', 'Aro', 'Permission');
	private static $missing_translations = array();
	private static $me = NULL;
	var $uses = array('Config');
	var $components	= array( 'Session', 'SessionAcl', 'Auth', 'Menus', 'RequestHandler', 'Structures', 'PermissionManager' );
	var $helpers		= array('Ajax', 'Csv', 'Html', 'Javascript', 'Shell', 'Structures', 'Time');
	
	
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
			
			$this->Auth->actionPath = 'controllers/App/';
			$this->Auth->allowedActions = array();
			
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
		if(!is_numeric($word)){
			AppController::$missing_translations[] = $word;
			if(Configure::read('debug') == 2){
				$word = "<span class='untranslated'>".$word."</span>";
//				$word .= "[untr]";
			}
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
	
		
		$ATiMCache = Configure::read('debug') ? true : false; 
		Configure::write('ATiMMenuCache.disable', $ATiMCache);
		Configure::write('ATiMStructureCache.disable', $ATiMCache);
	
	
		// ATiM2 configuration variables from Datatable
		
		define('VALID_INTEGER', '/^[-+]?\\b[0-9]+\\b$/');
		define('VALID_INTEGER_POSITIVE', '/^[+]?\\b[0-9]+\\b$/');
		define('VALID_FLOAT', '/^[-+]?\\b[0-9]*\\.?[0-9]+\\b$/');
		define('VALID_FLOAT_POSITIVE', '/^[+]?\\b[0-9]*\\.?[0-9]+\\b$/');
		
		//ripped from validation.php date + time
		define('VALID_DATETIME_YMD', '%^(?:(?:(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))(-)(?:0?2\\1(?:29)))|(?:(?:(?:1[6-9]|[2-9]\\d)?\\d{2})(-)(?:(?:(?:0?[13578]|1[02])\\2(?:31))|(?:(?:0?(1|[3-9])|1[0-2])\\2(29|30))|(?:(?:0?[1-9])|(?:1[0-2]))\\2(?:0?[1-9]|1\\d|2[0-8]))))\s([0-1][0-9]|2[0-3])\:[0-5][0-9]\:[0-5][0-9]$%');
	
		// parse URI manually to get passed PARAMS
		global $start_time;
		$start_time = AppController::microtime_float();	

		$request_uri_params = array();
		
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