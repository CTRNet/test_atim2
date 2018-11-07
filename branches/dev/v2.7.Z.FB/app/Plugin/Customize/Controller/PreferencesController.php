<?php

/**
 * Class PreferencesController
 */
App::uses('CustomizeAppController', 'Customize.Controller');

class PreferencesController extends CustomizeAppController
{

    public $name = 'Preferences';

    public $uses = array(
        'User',
        'Config'
    );

    public function index()
    {
        $this->Structures->set('preferences');
        
        // get USER data
        
        $configResults = $this->Config->getConfig($_SESSION['Auth']['User']['group_id'], $_SESSION['Auth']['User']['id']);
        
        $this->request->data['Config'] = $configResults['Config'];
    }

    public function edit()
    {
        $this->Structures->set('preferences');
        
        $configResults = $this->Config->getConfig($_SESSION['Auth']['User']['group_id'], $_SESSION['Auth']['User']['id']);
        
        if (! empty($this->request->data)) {
            $this->Config->preSave($configResults, $this->request->data, $_SESSION['Auth']['User']['group_id'], $_SESSION['Auth']['User']['id']);
            
            $this->Config->set($this->request->data);
            
            if ($this->Config->save()) {
                $this->atimFlash(__('your data has been updated'), '/Customize/Preferences/index');
            } else {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        } else {
            $this->request->data = $this->User->find('first', array(
                'conditions' => array(
                    'User.id' => $_SESSION['Auth']['User']['id']
                )
            ));
            $this->request->data['Config'] = $configResults['Config'];
        }
    }
}