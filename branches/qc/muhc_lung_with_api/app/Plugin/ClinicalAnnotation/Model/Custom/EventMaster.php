<?php
/**
 * **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */

class EventMasterCustom extends EventMaster
{

    var $useTable = 'event_masters';

    var $name = 'EventMaster';

    public function beforeSave($options = array())
    {
        // --------------------------------------------------------------------------------
        // Tumor Registery Data Migration
        // --------------------------------------------------------------------------------
        
        // Tumor registery data can only be created/modified by the Tumor Registry data migration (using 'System' user)
        // No tumor registry event can be created by user
        
        // Get event control type
        if (! $this->id && ! isset($this->data['EventMaster']['event_control_id'])) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $eventControlType = '';
        if ($this->id) {
            $eventControlType = $this->find('first', array(
                'conditions' => array(
                    'EventMaster.id' => $this->id
                ),
                'fields' => array(
                    'EventControl.event_type'
                )
            ));
            if (sizeof($eventControlType) != 1) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            $eventControlType = $eventControlType['EventControl']['event_type'];
        } else {
            $eventControlModel = AppModel::getInstance('ClinicalAnnotation', 'EventControl');
            $eventControlType = $eventControlModel->getOrRedirect($this->data['EventMaster']['event_control_id']);
            $eventControlType = $eventControlType['EventControl']['event_type'];
        }
        // Manage control
        if (empty($eventControlType)) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        } elseif (preg_match('/^tumor registry/', $eventControlType) 
        && ! in_array(AppController::getInstance()->Session->read('Auth.User.username'), array( 'system'))) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        return parent::beforeSave($options);
    }
}