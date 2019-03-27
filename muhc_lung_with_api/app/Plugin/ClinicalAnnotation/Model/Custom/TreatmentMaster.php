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
 
class TreatmentMasterCustom extends TreatmentMaster
{

    var $useTable = 'treatment_masters';

    var $name = 'TreatmentMaster';

    public function beforeSave($options = array())
    {
        // --------------------------------------------------------------------------------
        // Tumor Registery Data Migration
        // --------------------------------------------------------------------------------
        
        // Tumor registery diagnosis can only be created/modified by the Tumor Registry data migration (using 'System' user)
        // No treatment can be created by user
        
        if (! in_array(AppController::getInstance()->Session->read('Auth.User.username'), array('system'))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        return parent::beforeSave($options);
    }
}