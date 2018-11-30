<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

/**
 * Class MenusComponent
 */
class MenusComponent extends Component
{

    public $controller;

    public $components = array(
        'Session',
        'SessionAcl'
    );

    public $uses = array(
        'Aco'
    );

    /**
     *
     * @param Controller $controller
     */
    public function initialize(Controller $controller)
    {
        $this->controller = $controller;
    }

    /**
     *
     * @param null $alias
     * @param array $replace
     * @return array|bool|mixed
     */
    public function get($alias = null, $replace = array())
    {
        $aroAlias = 'Group::' . $this->Session->read('Auth.User.group_id');
        
        $return = array();
        $aliasCalculated = array();
        
        // if ALIAS not provided, try to guess what menu item CONTROLLER is looking for, defaulting to DETAIL/PROFILE if possible
        if (! $alias) {
            $alias = '/' . ($this->controller->params['plugin'] ? $this->controller->params['plugin'] . '/' : '') . $this->controller->params['controller'] . '/' . $this->controller->params['action'];
            
            $aliasWithParams = $alias;
            foreach ($this->controller->request->params as $param) {
                if (is_string($param)) {
                    $aliasWithParams .= '/' . $param;
                    $aliasCalculated[] = $aliasWithParams . '%';
                }
            }
            $aliasCalculated = array_reverse($aliasCalculated);
            $prefix = '/' . ($this->controller->params['plugin'] ? $this->controller->params['plugin'] . '/' : '') . $this->controller->params['controller'];
            $aliasCalculated[] = $prefix . '/detail%';
            $aliasCalculated[] = $prefix . '/profile%';
            $aliasCalculated[] = $prefix . '/listall%';
            $aliasCalculated[] = $prefix . '/index%';
            $aliasCalculated[] = $prefix . '%';
        }
        
        $cacheName = AppController::getInstance()->SystemVar->getVar('permission_timestamp') . str_replace("/", "_", $alias) . "_" . str_replace(":", "", $aroAlias);
        $return = Cache::read($cacheName, "menus");
        if ($return === null) {
            $return = false;
            if (Configure::read('debug') == 2) {
                AppController::addWarningMsg('Menu caching issue. (null)', true);
            }
        }
        if (! $return) {
            if ($alias) {
                $this->menuModel = AppModel::getInstance('', 'Menu', true);
                
                $result = $this->menuModel->find('all', array(
                    'conditions' => array(
                        "Menu.use_link" => array(
                            $alias,
                            $alias . '/'
                        ),
                        "Menu.flag_active" => 1
                    ),
                    'recursive' => 3,
                    'order' => 'Menu.parent_id DESC, Menu.display_order ASC',
                    'limit' => 1
                ));
                
                if (! $result) {
                    
                    $result = $this->menuModel->find('all', array(
                        'conditions' => array(
                            'Menu.use_link LIKE' => $alias . '%',
                            'Menu.flag_active' => 1
                        ),
                        'recursive' => 3,
                        'order' => 'Menu.parent_id DESC, Menu.display_order ASC',
                        'limit' => 1
                    ));
                }
                
                if (! $result) {
                    
                    $aliasCount = 0;
                    while (! $result && $aliasCount < count($aliasCalculated)) {
                        $result = $this->menuModel->find('all', array(
                            'conditions' => array(
                                "Menu.use_link LIKE " => $aliasCalculated[$aliasCount],
                                "Menu.flag_active" => 1
                            ),
                            'recursive' => 3,
                            'order' => 'Menu.parent_id DESC, Menu.display_order ASC',
                            'limit' => 1
                        ));
                        
                        $aliasCount ++;
                    }
                }
                
                $menu = array();
                
                $parentId = isset($result[0]['Menu']['parent_id']) ? $result[0]['Menu']['parent_id'] : false;
                $sourceId = isset($result[0]['Menu']['id']) ? $result[0]['Menu']['id'] : false;
                
                while ($parentId !== false) {
                    
                    $currentLevel = $this->menuModel->find('all', array(
                        'conditions' => array(
                            "Menu.parent_id" => $parentId,
                            "Menu.flag_active" => 1
                        ),
                        'order' => 'Menu.parent_id DESC, Menu.display_order ASC'
                    ));
                    if ($currentLevel && count($currentLevel)) {
                        
                        foreach ($currentLevel as &$currentItem) {
                            $currentItem['Menu']['at'] = $currentItem['Menu']['id'] == $sourceId;
                            $currentItem['Menu']['allowed'] = AppController::checkLinkPermission($currentItem['Menu']['use_link']); // $this->SessionAcl->check($aroAlias, $acoAlias);
                        }
                        
                        $menu[] = $currentLevel;
                        
                        $sourceResult = $this->menuModel->find('first', array(
                            'conditions' => array(
                                'Menu.id' => $parentId
                            )
                        ));
                        
                        if (! $sourceResult) {
                            break;
                        }
                        $sourceId = $sourceResult['Menu']['id'];
                        $parentId = $sourceResult['Menu']['parent_id'];
                    } else {
                        $parentId = false;
                    }
                }
                
                if ($result)
                    $return = $menu;
            }
            
            if (Configure::read('debug') == 0) {
                Cache::write($cacheName, $return, "menus");
            }
        }
        
        return $return;
    }
}