<?php

/** **********************************************************************
 * CUSM-CIM Project.
 * ***********************************************************************
 * 
 * Class BankCustom
 * Bank plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-02-21
 */
 
class BankCustom extends Bank
{

    var $useTable = 'banks';
    
    var $name = "Bank";
    
    /**
     * Control if the bank is linked to an other object before any deletion.
     *
     * @param int $bankId
     *            Id of the bank to delete
     * @return array Information about the possibility of deleting the data
     */
    public function allowDeletion($bankId)
    {
        
        $studySummaryModel = AppModel::getInstance('Study', 'StudySummary', true);
        $data = $studySummaryModel->find('first', array(
            'conditions' => array(
                'StudySummary.cusm_cim_bank_id' => $bankId
            )
        ));
        if ($data) {
            return array(
                'allow_deletion' => false,
                'msg' => 'at least one study is linked to that bank'
            );
        }
        
        $ctrlModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'Participant.cusm_cim_bank_id' => $bankId
            ),
            'recursive' => - 1
        ));
        if ($ctrlValue > 0) {
            // Should never happen
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $ctrlModel = AppModel::getInstance("InventoryManagement", "Collection", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'Collection.bank_id' => $bankId
            ),
            'recursive' => - 1
        ));
        if ($ctrlValue > 0) {
            // Should never happen
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $ctrlModel = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'AliquotMaster.cusm_cim_bank_id' => $bankId
            ),
            'recursive' => - 1
        ));
        if ($ctrlValue > 0) {
            // Should never happen
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        return parent::allowDeletion($bankId);
    }
}