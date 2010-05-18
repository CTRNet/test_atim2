<?php

class PermissionManagerComponent extends Object {
	
	var $controller;
	var $log = array();
	
	/*
	 * Specify the default permissions here
	 * If there are no permissions in the DB these will be inserted.
	 *
	 * NOTE: Currently these are not inserted correctly.
	 *       Don't allow the acos or aros_acos tables to be emptied
	*/
	var $defaults = array(
		'controllers' => array(
			'allow' => array('Group::1','Group::2','Group::3'),
			'deny' => array()
		),
		'controllers/Administrate/Permissions' => array(
			'allow' => array(),
			'deny' => array('Group::2','Group::3')
		)
	);
	
	function initialize( &$controller, $settings=NULL ) {
		$this->log = array();
		$this->controller =& $controller;
		if(is_array($settings)) $this->defaults = $settings;
		
		// If there are no Aco entries, build the entire list.
		if(! $this->controller->Acl->Aco->find('count',array('fields' => 'Aco.id')) ){
			$this->controller->Acl->Aco->query('TRUNCATE acos'); // reset auto increment
			$this->buildAcl();
		}
		
		// If there are no permissions in the DB, set up the defaults
		if(! $this->controller->Acl->Aco->Permission->find('count',array('fields' => 'Permission.id')) ){
			$this->controller->Acl->Aco->query('TRUNCATE aros_acos'); // reset auto increment
			$this->initDB();
		}
	}

	/**
	* initiate PERMISSIONS
	*/
	
	function initDB() {
		
		$group =& $this->controller->User->Group;
		$user =& $this->controller->User;
		
		foreach($this->defaults as $alias => $perms){
			if(isset($perms['allow']) && count($perms['allow'])){
				foreach($perms['allow'] as $user_alias){
					list($type,$id) = split('::',$user_alias);
					
					switch($type){
					case 'Group':
						$group->id = $id;
						$this->controller->Acl->allow($group, $alias);
						break;
					case 'User':
						$user->id = $id;
						$this->controller->Acl->allow($user, $alias);
						break;
					}
				}
			}
			if(isset($perms['deny']) && count($perms['deny'])){
				foreach($perms['deny'] as $user_alias){
					list($type,$id) = split('::',$user_alias);
					
					switch($type){
					case 'Group':
						$group->id = $id;
						$this->controller->Acl->deny($group, $alias);
						break;
					case 'User':
						$user->id = $id;
						$this->controller->Acl->deny($user, $alias);
						break;
					}
				}
			}
		}
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
		
		if(!file_exists($file_path)) return false;
		
		$matches = array();
		preg_match_all('/function\s+(\w+)\s*\(/', file_get_contents($file_path), $matches);
		
		$methods = $matches[1];
		
		if(!$plugin || $plugin == 'App'){
			$file_path = APP.'controllers'.DS.'customs'.DS.Inflector::underscore($ctrlName.'Controller').'.php';
		}else{
			$file_path = APP.'plugins'.DS.Inflector::underscore($plugin).DS
						.'controllers'.DS.'customs'.DS.Inflector::underscore($ctrlName.'Controller').'.php';
		}
		
		if(file_exists($file_path)){
			
			$matches = array();
			preg_match_all('/function\s+(\w+)\s*\(/', file_get_contents($file_path), $matches);
			
			foreach($matches[1] as $match){
				if(!in_array($match,$methods)){
					$methods[] = $match;
				}
			}
		}
		return $methods;
	}
	
	/**
	* Rebuild the Acl based on the current controllers in the application
	*
	* @return void
	*/
	
	function buildAcl() {
		$aco =& $this->controller->Acl->Aco;
		
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
		$Plugins = $this->getPluginControllerNames();
		$Controllers = array_merge($Controllers, $Plugins);
		asort($Controllers);
		
		$Plugins = array();
		
		foreach ($Controllers as $ctrlName) {
			$plugin = preg_match('/^.+\..*$/',$ctrlName) ? preg_replace('/^(.+)\..*$/','\1',$ctrlName) : 'App';
			$ctrlName = preg_replace('/^.+\./','',$ctrlName);
			
			if(!isset($Plugins[$plugin])) $Plugins[$plugin] = array();
			$Plugins[$plugin][] = $ctrlName;
		}
		
		$this->log = array();
		$root = $aco->node('controllers');
		if (!$root) {
			$aco->create(array('parent_id' => null, 'model' => null, 'alias' => 'controllers'));
			$root = $aco->save();
			$root['Aco']['id'] = $aco->id; 
			$this->log[] = 'Created Aco node for controllers';
		} else {
			$root = $root[0];
		}	
		
		$baseMethods = get_class_methods('AppController');
		$baseMethods[] = 'buildAcl';
		
		// look at each controller in app/controllers
		$pluginNodeIds = array();
		
		foreach ($Plugins as $plugin => $Controllers) {
			// find / make controller node
			$pluginNode = $aco->node('controllers/'.$plugin);
			
			if(!$pluginNode){
				$aco->create(array('parent_id' => $root['Aco']['id'], 'model' => null, 'alias' => $plugin));
				$pluginNode = $aco->save();
				$pluginNode['Aco']['id'] = $aco->id;
				$this->log[] = 'Created Aco node for '.$plugin;
			}else{
				$pluginNode = $pluginNode[0];
			}
			$pluginNodeIds[] = $pluginNode['Aco']['id'];
			
			$controllerNodeIds = array();
			
			foreach ($Controllers as $ctrlName) {
				$methods = $this->getControllerMethods($plugin.'.'.$ctrlName);
				if($methods === false){
					$this->log[] = $plugin.'.'.$ctrlName.' could not be located.'.print_r($methods,1);
					continue;
				
				}
				
				$controllerNode = $aco->node('controllers/'.$plugin.'/'.$ctrlName);
				if (!$controllerNode) {
					$aco->create(array('parent_id' => $pluginNode['Aco']['id'], 'model' => null, 'alias' => $ctrlName));
					$controllerNode = $aco->save();
					$controllerNode['Aco']['id'] = $aco->id;
					$this->log[] = 'Created Aco node for '.$plugin.'.'.$ctrlName;
				} else {
					$controllerNode = $controllerNode[0];
				}
				$controllerNodeIds[] = $controllerNode['Aco']['id'];
				
				$methodNodeIds = array();
				
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
					$methodNode = $aco->node('controllers/'.$plugin.'/'.$ctrlName.'/'.$method);
					if (!$methodNode) {
						$aco->create(array('parent_id' => $controllerNode['Aco']['id'], 'model' => null, 'alias' => $method, 'plugin' => $plugin));
						$aco->id = NULL;
						$methodNode = $aco->save();
						$this->log[] = 'Created Aco node for '. $plugin.'.'.$ctrlName.'.'.$method;
						$methodNodeIds[] = $aco->id;
					}else{
						$methodNodeIds[] = $methodNode[0]['Aco']['id'];
					}
				}
				
				$this->removeMissingNodes('controllers/'.$plugin.'/'.$ctrlName, $methodNodeIds);
			}
			
			$this->removeMissingNodes('controllers/'.$plugin, $controllerNodeIds);
		}
		
		$this->removeMissingNodes('controllers', $pluginNodeIds);
	}
	
	function removeMissingNodes($path, $known_ids = array()){
		
		$aco =& $this->controller->Acl->Aco;
		
		$parent_node =  $aco->node($path);
		if(!$parent_node) return false;
		
		$conditions = 'Aco.parent_id = "'.$parent_node[0]['Aco']['id'].'"';
		if( count($known_ids) ) $conditions .= ' AND Aco.id NOT IN("'.join('","',$known_ids).'")';
		
		$result = $aco->find('all', array('conditions' => $conditions));
		
		if(count($result)){
			foreach($result as $toRemove){
				$alias = $toRemove['Aco']['alias'];
				$this->log[] = 'Removed Aco node '. $path.'/'.$alias.' ('.$toRemove['Aco']['id'].')';
				$aco->del($toRemove['Aco']['id']);
			}
			return true;
		}
		
		return false;
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
	function getPluginControllerNames(){
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
				$pluginName = preg_replace('!^(.*/)(.+)(/controllers)/(.*)controller\.php!','$2',$fileName);
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