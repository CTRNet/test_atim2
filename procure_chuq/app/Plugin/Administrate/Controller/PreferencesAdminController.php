<?php

/**
 * Class PreferencesAdminController
 */
class PreferencesAdminController extends AdministrateAppController
{

    public $name = 'PreferencesAdmin';

    public $uses = array(
        'User',
        'Config'
    );

    /**
     *
     * @param $groupId
     * @param $userId
     */
    public function index($groupId, $userId)
    {
        $this->Structures->set('preferences');
        $this->set('atimMenuVariables', array(
            'Group.id' => $groupId,
            'User.id' => $userId
        ));
        $this->request->data = $this->User->find('first', array(
            'conditions' => array(
                'User.id' => $userId
            )
        ));
        
        // get USER data
        
        $configResults = $this->Config->getConfig($groupId, $userId);
        
        $this->request->data['Config'] = $configResults['Config'];
    }

    /**
     *
     * @param $groupId
     * @param $userId
     */
    public function edit($groupId, $userId)
    {
        $this->Structures->set('preferences');
        $this->set('atimMenuVariables', array(
            'Group.id' => $groupId,
            'User.id' => $userId
        ));
        
        $configResults = $this->Config->getConfig($groupId, $userId);
        
        if (! empty($this->request->data)) {
            $this->Config->preSave($configResults, $this->request->data, $groupId, $userId);
            
            $this->Config->set($this->request->data);
            
            if ($this->Config->save()) {
                $this->atimFlash(__('your data has been updated'), '/Administrate/PreferencesAdmin/index/' . $groupId . '/' . $userId);
            } else {
                $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        } else {
            
            $this->request->data['Config'] = $configResults['Config'];
        }
    }
}