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
 
class DiagnosisMasterCustom extends DiagnosisMaster
{

    var $useTable = 'diagnosis_masters';

    var $name = 'DiagnosisMaster';

    public function summary($diagnosisMasterId = null)
    {
        $return = false;
        if (! is_null($diagnosisMasterId)) {
            $structureAlias = 'diagnosismasters';
            $result = $this->find('first', array(
                'conditions' => array(
                    'DiagnosisMaster.id' => $diagnosisMasterId
                ),
                'recursive' => 0
            ));
            switch ($result['DiagnosisControl']['category']) {
                case 'primary':
                    if ($result['DiagnosisControl']['controls_type'] != 'primary diagnosis unknown')
                        $structureAlias .= ',cusm_lung_dxd_tumor_registry';
                    break;
                case 'secondary - distant':
                    $structureAlias = ',cusm_lung_dxd_tumor_registry_secondary';
                    break;
            }
            $return = array(
                'menu' => array(
                    null,
                    __($result['DiagnosisControl']['category'], true) . ' - ' . __($result['DiagnosisControl']['controls_type'], true)
                ),
                'title' => array(
                    null,
                    __($result['DiagnosisControl']['category'], true)
                ),
                'data' => $result,
                'structure alias' => $structureAlias
            );
        }
        return $return;
    }

    public function beforeSave($options = array())
    {
        // --------------------------------------------------------------------------------
        // Tumor Registery Data Migration
        // --------------------------------------------------------------------------------
        
        // Tumor registery diagnosis can only be created/modified by the Tumor Registry data migration (using 'System' user)
        // No diagnosis can be created by user
        
        if (! in_array(AppController::getInstance()->Session->read('Auth.User.username'), array('system'))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        return parent::beforeSave($options);
    }
}