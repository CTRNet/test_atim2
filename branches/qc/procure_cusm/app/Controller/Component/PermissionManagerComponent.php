<?php

/**
 * Class PermissionManagerComponent
 */
class PermissionManagerComponent extends Component
{

    public $controller;

    public $log = array();

    /*
     * Specify the default permissions here
     * If there are no permissions in the DB these will be inserted.
     * NOTE: Don't allow the acos tables to be emptied or this will fail.
     */
    public $defaults = array(
        'controllers' => array(
            'allow' => array(
                'Group::1',
                'Group::2',
                'Group::3'
            ),
            'deny' => array()
        ),
        'controllers/Administrate/Permissions' => array(
            'allow' => array(),
            'deny' => array(
                'Group::2',
                'Group::3'
            )
        )
    );

    /**
     *
     * @param Controller $controller
     */
    public function initialize(Controller $controller)
    {
        $this->log = array();
        $this->controller = $controller;
        
        // If there are no Aco entries, build the entire list.
        if (! $this->controller->Acl->Aco->find('count', array(
            'fields' => 'Aco.id'
        ))) {
            $this->controller->Acl->Aco->deleteAll(array()); // reset auto increment
            $this->buildAcl();
        }
        
        // If there are no permissions in the DB, set up the defaults
        if (! $this->controller->Acl->Aco->Permission->find('count', array(
            'fields' => 'Permission.id'
        ))) {
            $this->controller->Acl->Aco->deleteAll(array()); // reset auto increment
            $this->initDB();
        }
    }

    /**
     * initiate PERMISSIONS
     */
    public function initDB()
    {
        $group = & $this->controller->User->Group;
        $user = & $this->controller->User;
        
        foreach ($this->defaults as $alias => $perms) {
            
            if (isset($perms['allow']) && count($perms['allow'])) {
                foreach ($perms['allow'] as $userAlias) {
                    list ($type, $id) = explode('::', $userAlias);
                    
                    switch ($type) {
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
            if (isset($perms['deny']) && count($perms['deny'])) {
                foreach ($perms['deny'] as $userAlias) {
                    list ($type, $id) = explode('::', $userAlias);
                    
                    switch ($type) {
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

    /**
     *
     * @param $plugin
     * @param $ctrlName
     * @return array|bool|mixed
     */
    public function getControllerMethods($plugin, $ctrlName)
    {
        if (! $plugin || $plugin == 'App') {
            $filePath = APP . 'Controller' . DS . $ctrlName . '.php';
        } else {
            $filePath = APP . 'Plugin' . DS . $plugin . DS . 'Controller' . DS . $ctrlName . 'Controller.php';
        }
        
        if (! file_exists($filePath)) {
            return false;
        }
        
        $matches = array();
        preg_match_all('/function\s+(\w+)\s*\(/', file_get_contents($filePath), $matches);
        
        $methods = $matches[1];
        
        if (! $plugin || $plugin == 'App') {
            $filePath = APP . 'Controller' . DS . 'Custom' . DS . $ctrlName . 'Controller.php';
        } else {
            $filePath = APP . 'Plugin' . DS . $plugin . DS . 'Controller' . DS . 'Custom' . DS . $ctrlName . 'Controller.php';
        }
        
        if (file_exists($filePath)) {
            
            $matches = array();
            preg_match_all('/function\s+(\w+)\s*\(/', file_get_contents($filePath), $matches);
            
            foreach ($matches[1] as $match) {
                if (! in_array($match, $methods)) {
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
    public function buildAcl()
    {
        $aco = & $this->controller->Acl->Aco;
        
        $controllers = App::objects('controller');
        
        $appIndex = array_search('App', $controllers);
        if ($appIndex !== false) {
            unset($controllers[$appIndex]);
        }
        foreach ($controllers as $i => $name) {
            if ($name !== 'App')
                $controllers[$i] = 'App.' . $name;
        }
        // call FUNCTION to get APP.PLUGIN.CONTROLLER list, and append to APP.CONTROLLER list
        $plugins = $this->getPluginControllerNames();
        $controllers = array_merge($controllers, $plugins);
        asort($controllers);
        
        $plugins = array();
        foreach ($controllers as $ctrlName) {
            $plugin = preg_match('/^.+\..*$/', $ctrlName) ? preg_replace('/^(.+)\..*$/', '\1', $ctrlName) : 'App';
            $ctrlName = preg_replace('/^.+\./', '', $ctrlName);
            
            if (! isset($plugins[$plugin])) {
                $plugins[$plugin] = array();
            }
            $plugins[$plugin][] = $ctrlName;
        }
        
        $this->log = array();
        $root = $aco->node('Controller');
        if (! $root) {
            $aco->create(array(
                'parent_id' => null,
                'model' => null,
                'alias' => 'Controller'
            ));
            $root = $aco->save();
            $root['Aco']['id'] = $aco->id;
            $this->log[] = 'Created Aco node for Controller';
        } else {
            $root = $root[0];
        }
        
        $baseMethods = get_class_methods('AppController');
        $baseMethods[] = 'buildAcl';
        
        // look at each controller in app/controllers
        $pluginNodeIds = array();
        foreach ($plugins as $plugin => $controllers) {
            // find / make controller node
            $pluginNode = $aco->node('Controller/' . $plugin);
            if (! $pluginNode) {
                $aco->create(array(
                    'parent_id' => $root['Aco']['id'],
                    'model' => null,
                    'alias' => $plugin
                ));
                $pluginNode = $aco->save();
                $pluginNode['Aco']['id'] = $aco->id;
                $this->log[] = 'Created Aco node for ' . $plugin;
            } else {
                $pluginNode = $pluginNode[0];
            }
            $pluginNodeIds[] = $pluginNode['Aco']['id'];
            
            $controllerNodeIds = array();
            
            foreach ($controllers as $ctrlName) {
                $methods = $this->getControllerMethods($plugin, $ctrlName);
                if ($methods === false) {
                    $this->log[] = $plugin . '.' . $ctrlName . ' could not be located.' . print_r($methods, 1);
                    continue;
                }
                
                $controllerNode = $aco->node('Controller/' . $plugin . '/' . $ctrlName);
                if (! $controllerNode) {
                    $aco->create(array(
                        'parent_id' => $pluginNode['Aco']['id'],
                        'model' => null,
                        'alias' => $ctrlName
                    ));
                    $controllerNode = $aco->save();
                    $controllerNode['Aco']['id'] = $aco->id;
                    $this->log[] = 'Created Aco node for ' . $plugin . '.' . $ctrlName;
                } else {
                    $controllerNode = $controllerNode[0];
                }
                $controllerNodeIds[] = $controllerNode['Aco']['id'];
                
                $methodNodeIds = array();
                
                // clean the methods. to remove those in Controller and private actions.
                foreach ($methods as $k => $method) {
                    if (strpos($method, '_', 0) === 0) {
                        unset($methods[$k]);
                        continue;
                    }
                    if (in_array($method, $baseMethods)) {
                        unset($methods[$k]);
                        continue;
                    }
                    $methodNode = $aco->node('Controller/' . $plugin . '/' . $ctrlName . '/' . $method);
                    if (! $methodNode) {
                        $aco->create(array(
                            'parent_id' => $controllerNode['Aco']['id'],
                            'model' => null,
                            'alias' => $method,
                            'plugin' => $plugin
                        ));
                        $aco->id = null;
                        $methodNode = $aco->save();
                        $this->log[] = 'Created Aco node for ' . $plugin . '.' . $ctrlName . '.' . $method;
                        $methodNodeIds[] = $aco->id;
                    } else {
                        $methodNodeIds[] = $methodNode[0]['Aco']['id'];
                    }
                }
                
                $this->removeMissingNodes('controllers/' . $plugin . '/' . $ctrlName, $methodNodeIds);
            }
            
            $this->removeMissingNodes('controllers/' . $plugin, $controllerNodeIds);
        }
        
        $this->removeMissingNodes('controllers', $pluginNodeIds);
    }

    /**
     *
     * @param $path
     * @param array $knownIds
     * @return bool
     */
    public function removeMissingNodes($path, $knownIds = array())
    {
        $aco = & $this->controller->Acl->Aco;
        
        $parentNode = $aco->node($path);
        if (! $parentNode)
            return false;
        
        $conditions = 'Aco.parent_id = "' . $parentNode[0]['Aco']['id'] . '"';
        if (count($knownIds))
            $conditions .= ' AND Aco.id NOT IN("' . join('","', $knownIds) . '")';
        
        $result = $aco->find('all', array(
            'conditions' => $conditions
        ));
        
        if (count($result)) {
            foreach ($result as $toRemove) {
                $alias = $toRemove['Aco']['alias'];
                $this->log[] = 'Removed Aco node ' . $path . '/' . $alias . ' (' . $toRemove['Aco']['id'] . ')';
                $aco->delete($toRemove['Aco']['id']);
            }
            return true;
        }
        
        return false;
    }

    /**
     * Get the names of the plugin controllers .
     *
     *
     * This function will get an array of the plugin controller names, and
     * also makes sure the controllers are available for us to get the
     * method names by doing an App::import for each plugin controller.
     *
     * @return array of plugin names.
     *        
     */
    public function getPluginControllerNames()
    {
        App::uses('Folder', 'Utility');
        $folder = new Folder();
        // Change directory to the plugins
        $folder->cd(APP . 'Plugin');
        // Get a list of the files that have a file name that ends
        // with controller.php
        $files = $folder->findRecursive('.*Controller\.php');
        // Get the list of plugins
        $plugins = App::objects('Plugin');
        
        // Loop through the controllers we found int the plugins directory
        foreach ($files as $f => $fileName) {
            // Get the base file name
            $pluginName = preg_replace('!^(.*' . preg_quote(DS) . ')(.+)(' . preg_quote(DS) . 'Controller)' . preg_quote(DS) . '(.*)Controller\.php!', '$2', $fileName);
            
            // Get the base file name
            $file = basename($fileName);
            
            // Get the controller name
            $file = Inflector::camelize(substr($file, 0, strlen($file) - strlen('Controller.php')));
            if (! preg_match('/^.*App$/', $file) && strpos(DS . 'plugins' . DS, $pluginName) === false) {
                $files[$f] = $pluginName . '.' . $file;
            } else {
                unset($files[$f]);
            }
        }
        return $files;
    }
}