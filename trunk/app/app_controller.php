<?php

// ATiM2 configuration variables from Datatable
	
	// parse URI manually to get passed PARAMS
	
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
		$config_data_model =& new Config;
		
		App::import('component', 'Session');
		$config_session_component =& new SessionComponent;
	
	// get CONFIG data from table and SET
		
		$config_results	= false;
		
		$logged_in_user	= $config_session_component->read('Auth.User.id');
		$logged_in_group	= $config_session_component->read('Auth.User.group_id');
		
		// get CONFIG for logged in user
		if ( $_SESSION['Auth']['User']['id'] ) {
			$config_results = $config_data_model->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND user_id="'.$logged_in_user.'"'));
		}
		// if not logged in user, or user has no CONFIG, get CONFIG for GROUP level
		if ( $_SESSION['Auth']['User']['group_id'] && !count($config_results) ) {
			$config_results = $config_data_model->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND Config.group_id="'.$logged_in_group.'" AND (user_id="0" OR user_id IS NULL)'));
		}
		// if not logged in user, or user has no CONFIG, get CONFIG for APP level
		if ( !count($config_results) ) {
			$config_results = $config_data_model->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND (user_id="0" OR user_id IS NULL)'));
		}
		
		// parse result, set configs/defines
		if ( $config_results ) {
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

class AppController extends Controller {
	
	var $uses			= array('Config', 'Aco', 'Aro', 'Permission');
	var $components	= array('Acl', 'Auth', 'Menus', 'RequestHandler', 'Structures');
	var $helpers		= array('Ajax', 'Csv', 'Html', 'Javascript', 'Shell', 'Structures', 'Time');
	
	function beforeFilter() {
		// Uncomment the following to create an Aco entry for every plugin/controller/method combination in the app.
			// $this->buildAcl();
		// Uncomment the following to set up default permissions.
			// $this->initDB();
			
		// Configure AuthComponent
			$this->Auth->authorize = 'actions';
			$this->Auth->loginAction = array('controller' => 'users', 'action' => 'login', 'plugin' => '');
			$this->Auth->loginRedirect = array('controller' => 'menus', 'action' => 'index', 'plugin' => '');
			$this->Auth->logoutRedirect = array('controller' => 'users', 'action' => 'login', 'plugin' => '');
			
			$this->Auth->actionPath = 'controllers/';
			// $this->Auth->allowedActions = array('display');
			
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
				$log_activity_model =& new UserLog;
			}
			
			$log_activity_model->save($log_activity_data);
		
		/*
		// ATiM2 configuration variables from Datatable
			$config_results	= false;
			$logged_in_user	= $this->Session->read('Auth.User.id');
			$logged_in_group	= $this->Session->read('Auth.User.group_id');
			
			// get CONFIG for logged in user
			if ( $logged_in_user ) {
				$config_results = $this->Config->find('first', array('conditions'=>array('Config.bank_id'=>'0','Config.group_id'=>'0','Config.user_id'=>$logged_in_user)));
			}
			// if not logged in user, or user has no CONFIG, get CONFIG for APP level
			if ( $logged_in_group && !$config_results ) {
				$config_results = $this->Config->find('first', array('conditions'=>array('Config.bank_id'=>'0','Config.group_id'=>$logged_in_group,'Config.user_id'=>'0')));
			}
			// if not logged in user, or user has no CONFIG, get CONFIG for APP level
			if ( !$config_results ) {
				$config_results = $this->Config->find('first', array('conditions'=>array('Config.bank_id'=>'0','Config.group_id'=>'0','Config.user_id'=>'0')));
			}
			
			// parse result, set configs/defines
			if ( $config_results ) {
				foreach ( $config_results['Config'] as $config_key=>$config_data ) {
					if ( strpos($config_key,'_')!==false ) {
						
						// break apart CONFIG key
						$config_key = explode('_',$config_key);
						$config_format = array_shift($config_key);
						$config_key = implode('_',$config_key);
						
						// if a DEFINE or CONFIG, set new setting for APP
						if ( $config_format=='define' ) {
							define($config_key, $config_data);
						} else if ( $config_format=='config' ) {
							Configure::write($config_key, $config_data);
						}
					}
				}
			}
			*/
			
		// menu grabbed for HEADER
			$this->set( 'atim_menu_for_header', $this->Menus->get('/menus/tools') );
			
		// ATiM1 "ctrapp_form" = ATiM2 "atim_structure"
		// ATiM1 Forms validation = ATiM2 Structure validation
			$this->set( 'atim_structure', $this->Structures->get() );
			foreach ( $this->Structures->get('rules') as $model=>$rules ) $this->{ $model }->validate = $rules;
			
		// menu, passed to Layout where it would be rendered through a Helper
			$this->set( 'atim_menu_variables', array() );
			$this->set( 'atim_menu', $this->Menus->get() );
			
	}
	
	/**
	* initiate PERMISSIONS
	*/
	
	function initDB() {
		$group =& $this->User->Group;
		//Allow admins to everything
		$group->id = 1;
		$this->Acl->allow($group, 'controllers');
		
		//allow managers to posts and widgets
		$group->id = 2;
		$this->Acl->allow($group, 'controllers');
		
		//allow users to only add and edit on posts and widgets
		$group->id = 3;
		$this->Acl->allow($group, 'controllers');
	}
	
	function getControllerMethods($ctrlName){
		$plugin = preg_match('/^.+\..*$/',$ctrlName) ? preg_replace('/^(.+)\..*$/','\1',$ctrlName) : false;
		$ctrlName = preg_replace('/^.+\./','',$ctrlName);
		if(!$plugin || $plugin == 'App'){
			$file_path = APP.'controllers'.DS.Inflector::underscore($ctrlName.'Controller').'.php';
		}else{
			$file_path = APP.'plugins'.DS.Inflector::underscore($plugin).DS
						.'controllers'.DS.Inflector::underscore($ctrlName.'Controller').'.php';
		}
		$matches = array();
		preg_match_all('/function\s+(\w+)\s*\(/', file_get_contents($file_path), $matches);
		
		return $matches[1];
	}
	
	/**
	* Rebuild the Acl based on the current controllers in the application
	*
	* @return void
	*/
	
	function buildAcl() {
		App::import('Core', 'File');
		$Controllers = Configure::listObjects('controller');
		$appIndex = array_search('App', $Controllers);
		if ($appIndex !== false ) {
		   unset($Controllers[$appIndex]);
		}
		foreach($Controllers as $i => $name){
			if($name !== 'App') $Controllers[$i] = 'App.'.$name;
		}
		// call FUNCTION to get APP.PLUGIN.CONTROLLER list, and append to APP.CONTROLLER list
		$Plugins = $this->_get_plugin_controller_names();
		$Controllers = array_merge($Controllers, $Plugins);
		
		$log = array();
		$aco =& $this->Acl->Aco;
		$root = $aco->node('controllers');
		if (!$root) {
		   $aco->create(array('parent_id' => null, 'model' => null, 'alias' => 'controllers'));
		   $root = $aco->save();
		   $root['Aco']['id'] = $aco->id; 
		   $log[] = 'Created Aco node for controllers';
		} else {
		   $root = $root[0];
		}   
		
		$baseMethods = get_class_methods('AppController');
		$baseMethods[] = 'buildAcl';
		
		
		// look at each controller in app/controllers
		foreach ($Controllers as $ctrlName) {
		   $methods = $this->getControllerMethods($ctrlName);
		   $plugin = preg_match('/^.+\..*$/',$ctrlName) ? preg_replace('/^(.+)\..*$/','\1',$ctrlName) : false;
		   $ctrlName = preg_replace('/^.+\./','',$ctrlName);
		   
		   if($plugin){
			   // find / make controller node
			   $pluginNode = $aco->node('controllers/'.$plugin);
			   if(!$pluginNode){
			      $aco->create(array('parent_id' => $root['Aco']['id'], 'model' => null, 'alias' => $plugin));
			      $pluginNode = $aco->save();
			      $pluginNode['Aco']['id'] = $aco->id;
			      $log[] = 'Created Aco node for '.$plugin;
			   }else{
			      $pluginNode = $pluginNode[0];
			   }
			   $controllerNode = $aco->node('controllers/'.$plugin.'/'.$ctrlName);
			   if (!$controllerNode) {
			       $aco->create(array('parent_id' => $pluginNode['Aco']['id'], 'model' => null, 'alias' => $ctrlName));
			       $controllerNode = $aco->save();
			       $controllerNode['Aco']['id'] = $aco->id;
			       $log[] = 'Created Aco node for '.$ctrlName;
			   } else {
			       $controllerNode = $controllerNode[0];
			   }
		   }else{
			   // find / make controller node
			   $controllerNode = $aco->node('controllers/'.$ctrlName);
			   if (!$controllerNode) {
			       $aco->create(array('parent_id' => $root['Aco']['id'], 'model' => null, 'alias' => $ctrlName));
			       $controllerNode = $aco->save();
			       $controllerNode['Aco']['id'] = $aco->id;
			       $log[] = 'Created Aco node for '.$ctrlName;
			   } else {
			       $controllerNode = $controllerNode[0];
			   }
		   }
		   
		   //clean the methods. to remove those in Controller and private actions.
		   foreach ($methods as $k => $method) {
		       if (strpos($method, '_', 0) === 0) {
		           unset($methods[$k]);
		           continue;
		       }
		       if (in_array($method, $baseMethods)) {
		           unset($methods[$k]);
		           continue;
		       }
		       $methodNode = $plugin ? $aco->node('controllers/'.$plugin.'/'.$ctrlName.'/'.$method) : $aco->node('controllers/'.$ctrlName.'/'.$method);
		       if (!$methodNode) {
		           if($plugin){
		               $aco->create(array('parent_id' => $controllerNode['Aco']['id'], 'model' => null, 'alias' => $method, 'plugin' => $plugin));
		           }else{
		               $aco->create(array('parent_id' => $controllerNode['Aco']['id'], 'model' => null, 'alias' => $method));
		           }
		           $aco->id = NULL;
		           $methodNode = $aco->save();
		           $log[] = 'Created Aco node for '. $method;
		       }
		   }
		}
		
		debug($log);
	}

	
	/**
     * Get the names of the plugin controllers ...
     * 
     * This function will get an array of the plugin controller names, and
     * also makes sure the controllers are available for us to get the 
     * method names by doing an App::import for each plugin controller.
     *
     * @return array of plugin names.
     *
     */
    function _get_plugin_controller_names(){
        App::import('Core', 'File', 'Folder');
        $paths = Configure::getInstance();
        $folder =& new Folder();
        // Change directory to the plugins
        $folder->cd(APP.'plugins');
        // Get a list of the files that have a file name that ends
        // with controller.php
        $files = $folder->findRecursive('.*_controller\.php');
        // Get the list of plugins
        $Plugins = Configure::listObjects('plugin');

        // Loop through the controllers we found int the plugins directory
        foreach($files as $f => $fileName)
        {
            // Get the base file name
            $pluginName = preg_replace('!^(.*/)([^/]+)(/controllers)/([^/]*)controller\.php!','$2',$fileName);
            $pluginName = Inflector::camelize($pluginName);
            
            // Get the base file name
            $file = basename($fileName);

            // Get the controller name
            $file = Inflector::camelize(substr($file, 0, strlen($file)-strlen('_controller.php')));
            if(!preg_match('/^.*App$/',$file) && strpos('/plugins/',$pluginName) === false){
            	$files[$f] = $pluginName.'.'.$file;
            }else{
            	unset($files[$f]);
            }
        }
        return $files;
    }
	
}

?>