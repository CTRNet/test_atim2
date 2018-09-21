<?php

/**
 * Class PermissionsController
 */
class PermissionsController extends AdministrateAppController
{

    public $uses = array(
        'Aco',
        'Aro',
        'ExternalLink',
        'Group',
        'Administrate.PermissionsPreset',
        'Permission'
    );

    public function beforeFilter()
    {
        parent::beforeFilter();
        
        if ($this->AtimAuth->user()) {
            $this->AtimAuth->allowedActions = array(
                'regenerate'
            );
        }
    }

    public function index()
    {}

    public function regenerate()
    {
        $this->PermissionManager->buildAcl();
        $this->set('log', $this->PermissionManager->log);
        $this->SystemVar->setVar('permission_timestamp', time());
        Cache::clear(false, "menus");
    }

    /**
     *
     * @param $aroId
     * @param $acoId
     * @param $state
     */
    public function update($aroId, $acoId, $state)
    {
        $this->autoRender = false;
        
        $aro = $this->Aro->find('first', array(
            'conditions' => 'Aro.id = "' . $aroId . '"',
            'order' => 'alias ASC',
            'recursive' => - 1
        ));
        $this->updatePermission($aroId, $acoId, $state);
        
        list ($type, $id) = explode('::', $aro['Aro']['alias']);
        switch ($type) {
            case 'Group':
                $this->redirect('/Administrate/Permissions/tree/' . $id);
                break;
            case 'User':
                $parent = $this->Aro->find('first', array(
                    'conditions' => 'Aro.id = "' . $aro['Aro']['parent_id'] . '"',
                    'order' => 'alias ASC',
                    'recursive' => - 1
                ));
                list ($type, $gid) = explode('::', $parent['Aro']['alias']);
                $this->redirect('/Administrate/Permissions/tree/' . $gid . '/' . $id);
                break;
        }
        exit();
    }

    /**
     *
     * @param $aroId
     * @param $acoId
     * @param $state
     */
    private function updatePermission($aroId, $acoId, $state)
    {
        if (intval($state) == 0) {
            $sql = 'DELETE FROM aros_acos WHERE aro_id = "' . $aroId . '" AND aco_id = "' . $acoId . '"';
        } else {
            $sql = '
				INSERT INTO
					aros_acos
				(
					aro_id,
					aco_id,
					_create,
					_read,
					_update,
					_delete
				)
				VALUES(
					"' . $aroId . '",
					"' . $acoId . '",
					"' . $state . '",
					"' . $state . '",
					"' . $state . '",
					"' . $state . '"
				)
				ON DUPLICATE KEY UPDATE
					_create="' . $state . '",
					_read="' . $state . '",
					_update="' . $state . '",
					_delete="' . $state . '"
			';
        }
        
        try {
            $this->Aro->query($sql);
        } catch (Exception $e) {
            $bt = debug_backtrace();
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . $bt[1]['function'] . ',line=' . $bt[0]['line'], null, true);
        }
    }

    /**
     *
     * @param int $groupId
     * @param int $userId
     */
    public function tree($groupId = 0, $userId = 0)
    {
        $this->set('atimMenuVariables', array(
            'Group.id' => $groupId,
            'User.id' => $userId
        ));
        $aro = $this->Aro->find('first', array(
            'conditions' => 'Aro.alias = "Group::' . $groupId . '"',
            'order' => 'alias ASC',
            'recursive' => 1
        ));
        $acoIdExtract = Set::extract('Aco.{n}.id', $aro);
        $acoPermExtract = Set::extract('Aco.{n}.Permission', $aro);
        $knownAcos = null;
        if (count($acoIdExtract) > 0 && count($acoPermExtract) > 1) {
            $knownAcos = array_combine($acoIdExtract, $acoPermExtract);
        } else {
            $knownAcos = array();
        }
        $this->set('aro', $aro);
        $this->set('knownAcos', $knownAcos);
        
        if ($this->request->data) {
            $this->Group->id = $groupId;
            $this->Aro->pkeySafeguard = false;
            $this->Aro->checkWritableFields = false;
            $this->Group->addWritableField('flag_show_confidential');
            $this->Group->save($this->request->data['Group']);
            unset($this->request->data['Group']);
            foreach ($this->request->data as $i => $aco) {
                $this->updatePermission($aro['Aro']['id'], $aco['Aco']['id'], intval($aco['Aco']['state']));
            }
            
            if ($groupId == 1) {
                // make sure admin permissions are always allowed on the administrate module
                $permissionModel = AppModel::getInstance('', 'Permission', false);
                $permission = $permissionModel->find('first', array(
                    'conditions' => array(
                        'Permission.aro_id' => 1,
                        'Permission.aco_id' => array(
                            1,
                            2
                        )
                    ),
                    'order' => 'Permission.aco_id DESC',
                    'recursive' => - 1
                ));
                $alteredPermissions = false;
                if ($permission['Permission']['_create'] == - 1) {
                    // highest node is blocked, allow it.
                    $alteredPermissions = true;
                    $this->updatePermission(1, 2, 1);
                }
                $permissions = $this->Aco->children(2); // all administrate functions
                $permissions = AppController::defineArrayKey($permissions, 'Aco', 'id', true);
                $permissionsToDelete = $permissionModel->find('all', array(
                    'conditions' => array(
                        'Permission.aco_id' => array_keys($permissions),
                        'Permission.aro_id' => 1
                    ),
                    'recursive' => - 1
                ));
                if ($permissionsToDelete) {
                    $alteredPermissions = true;
                    foreach ($permissionsToDelete as $permissionToDelete) {
                        $this->updatePermission(1, $permissionToDelete['Permission']['aco_id'], 0);
                    }
                }
                
                if ($alteredPermissions) {
                    AppController::addWarningMsg(__('permissions were altered to grant group administrators all administrative privileges'));
                }
            }
            
            // check structure functions dependencies
            $dmStructFctModel = AppModel::getInstance('Datamart', 'DatamartStructureFunction');
            $dependentFcts = $dmStructFctModel->find('all', array(
                'conditions' => array(
                    'NOT' => array(
                        'DatamartStructureFunction.ref_single_fct_link' => ''
                    )
                )
            ));
            $aroStr = "Group::" . $groupId;
            $changed = false;
            $this->Permission->pkeySafeguard = false;
            $this->Permission->checkWritableFields = false;
            foreach ($dependentFcts as $dependentFct) {
                $batch = 'Controller' . $dependentFct['DatamartStructureFunction']['link'];
                $unit = 'Controller' . $dependentFct['DatamartStructureFunction']['ref_single_fct_link'];
                if (! $this->SessionAcl->check($aroStr, $unit) && $this->SessionAcl->check($aroStr, $batch)) {
                    $this->SessionAcl->deny($aroStr, $batch);
                    $changed = true;
                }
            }
            
            if ($changed) {
                AppController::addWarningMsg(__('batch_alter_msg'));
            }
            
            $this->SystemVar->setVar('permission_timestamp', time());
            Cache::clear(false, "menus");
            // straight flash because we redirect to the edit screen
            $this->atimFlash(__('your data has been updated'), '/Administrate/Permissions/tree/' . $groupId . '/' . $userId);
            return;
        }
        
        try {
            $depth = $this->Aco->query('
				SELECT node.id, node.lft, (COUNT(parent.id) - 1) AS depth
				FROM acos AS node, acos AS parent
				WHERE node.lft BETWEEN parent.lft AND parent.rght
				GROUP BY node.id, node.lft
				ORDER BY node.lft;
			');
        } catch (Exception $e) {
            $bt = debug_backtrace();
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . $bt[1]['function'] . ',line=' . $bt[0]['line'], null, true);
        }
        
        $depth = array_combine(Set::extract('{n}.node.id', $depth), Set::extract('{n}.0.depth', $depth));
        
        $this->set('depth', $depth);
        
        $this->set('acos', $this->Aco->find('all', array(
            'recursive' => - 1,
            'order' => 'Aco.lft ASC, Aco.alias ASC'
        )));
        
        $this->Aco->unbindModel(array(
            'hasAndBelongsToMany' => array(
                'Aro'
            )
        ));
        
        $this->Aco->bindModel(array(
            'hasAndBelongsToMany' => array(
                'Aro' => array(
                    'className' => 'Aro',
                    'joinTable' => 'aros_acos',
                    'foreignKey' => 'aco_id',
                    'associationForeignKey' => 'aro_id',
                    'conditions' => array(
                        'Aro.model' => 'Group',
                        'Aro.foreign_key' => $groupId
                    )
                )
            )
        ));
        
        $threadedData = $this->Aco->find('threaded', array(
            'order' => 'Aco.alias'
        ));
        $threadedData = $this->addPermissionStateToThreadedData($threadedData);
        
        $this->request->data = $threadedData;
        if (! isset($this->request->data[0]['Aco']['state'])) {
            // the root not is blank, display "denied" to make it easier to understand
            $this->request->data[0]['Aco']['state'] = - 1;
        }
        $helpUrl = $this->ExternalLink->find('first', array(
            'conditions' => array(
                'name' => 'permissions_help'
            )
        ));
        $this->set("helpUrl", $helpUrl['ExternalLink']['link']);
        $this->Structures->set("permissions", "permissions");
        $this->Structures->set("permissions2", "permissions2");
        $this->set("groupData", $this->Group->find('first', array(
            'conditions' => array(
                'id' => $groupId
            ),
            'recursive' => 0
        )));
    }

    /**
     *
     * @param array $threadedData
     * @return array
     */
    public function addPermissionStateToThreadedData($threadedData = array())
    {
        foreach ($threadedData as $k => $v) {
            if (isset($v['Aro'][0]) && isset($v['Aro'][0]['ArosAco']) && isset($v['Aro'][0]['ArosAco']['_create']) && $v['Aro'][0]['ArosAco']['_create'] != 0) {
                $threadedData[$k]['Aco']['state'] = $v['Aro'][0]['ArosAco']['_create'];
            }
            
            unset($threadedData[$k]['Aro']);
            
            if (isset($v['children']) && count($v['children'])) {
                $threadedData[$k]['children'] = $this->addPermissionStateToThreadedData($v['children']);
            }
        }
        
        return $threadedData;
    }

    public function savePreset()
    {
        $this->Structures->set('permission_save_preset');
        // layout = ajax to avoid printing layout
        $this->layout = 'ajax';
        // debug = 0 to avoid printing debug queries that would break the javascript array
        Configure::write('debug', 0);
        if (! empty($this->request->data)) {
            $permissionPreset = $this->PermissionsPreset->find('first', array(
                'conditions' => array(
                    'PermissionsPreset.name' => $this->request->data['PermissionsPreset']['name']
                )
            ));
            if (empty($permissionPreset)) {
                if ($this->PermissionsPreset->save(array(
                    'name' => $this->request->data['PermissionsPreset']['name'],
                    'serialized_data' => serialize(array(
                        'allow' => $this->request->data[0]['allow'],
                        'deny' => $this->request->data[0]['deny']
                    )),
                    'description' => $this->request->data['PermissionsPreset']['description']
                ))) {
                    echo 200;
                    exit();
                } else {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            } elseif ($this->request->data[0]['overwrite']) {
                if ($this->PermissionsPreset->save(array(
                    'id' => $permissionPreset['PermissionsPreset']['id'],
                    'serialized_data' => serialize(array(
                        'allow' => $this->request->data[0]['allow'],
                        'deny' => $this->request->data[0]['deny']
                    )),
                    'description' => $this->request->data['PermissionsPreset']['description']
                ))) {
                    echo 200;
                    exit();
                } else {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            } else {
                $this->PermissionsPreset->validationErrors['name'] = __('this name already exists') . " " . __('select a new one or check the overwrite option');
            }
        }
    }

    public function loadPreset()
    {
        $this->Structures->set('permission_save_preset');
        // layout = ajax to avoid printing layout
        $this->layout = 'ajax';
        // debug = 0 to avoid printing debug queries that would break the javascript array
        Configure::write('debug', 0);
        $this->request->data = $this->PermissionsPreset->find('all', array(
            'order' => array(
                'PermissionsPreset.name'
            )
        ));
        foreach ($this->request->data as &$unit) {
            $unit['PermissionsPreset']['json'] = json_encode(unserialize($unit['PermissionsPreset']['serialized_data']));
        }
        if (! empty($this->request->data)) {
            $this->request->data[0]['PermissionsPreset']['delete'] = '/Administrate/Permissions/deletePreset/';
        }
    }

    /**
     *
     * @param $presetId
     */
    public function deletePreset($presetId)
    {
        $this->layout = false;
        $this->render(false);
        $this->PermissionsPreset->atimDelete($presetId);
        $_SESSION['query']['previous'][] = $this->getQueryLogs('default');
    }
}