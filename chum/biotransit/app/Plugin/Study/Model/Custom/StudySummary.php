<?php

/** **********************************************************************
 * CHUM-BioTransit Project
 * ***********************************************************************
 * 
 * Class StudySummaryCustom
 * Study plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-10-22
 */
 
class StudySummaryCustom extends StudySummary
{

    public $name = 'StudySummary';

    public $useTable = 'study_summaries';

    private $studyBankIdToBankLabel = array();

    /**
     * Control if the study is linked to an other object before any deletion.
     *
     * @param int $studySummaryId
     *            Id of the study to delete
     * @return array Information about the possibility of deleting the data
     */
    public function allowDeletion($studySummaryId)
    {
        $ctrlModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'Participant.chum_biotransit_study_summary_id' => $studySummaryId
            ),
            'recursive' => - 1
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'study/project is assigned to a participant'
            );
        }
        
        $ctrlModel = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'AliquotMaster.study_summary_id' => $studySummaryId
            ),
            'recursive' => - 1
        ));
        if ($ctrlValue > 0) {
            // Should never happen
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        return parent::allowDeletion($studySummaryId);
    }
}