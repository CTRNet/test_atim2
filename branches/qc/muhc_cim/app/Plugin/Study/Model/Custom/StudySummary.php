<?php

/** **********************************************************************
 * CUSM-CIM Project.
 * ***********************************************************************
 * 
 * Class StudySummaryCustom
 * Study plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-02-21
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
                'Participant.cusm_cim_study_summary_id' => $studySummaryId
            ),
            'recursive' => - 1
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'study/project is assigned to a participant'
            );
        }
        
        $ctrlModel = AppModel::getInstance("InventoryManagement", "Collection", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'Collection.cusm_cim_study_summary_id' => $studySummaryId
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

    /**
     * Override getStudyDataAndCodeForDisplay() function of the Class StudySummary.
     *
     * @param array $studyData            
     * @return string Formatted label of the study to display
     */
    public function getStudyDataAndCodeForDisplay($studyData)
    {
        $formattedData = '';
        if ((! empty($studyData)) && isset($studyData['StudySummary']['id']) && (! empty($studyData['StudySummary']['id']))) {
            if (! isset($this->studyDataAndCodeForDisplayAlreadySet[$studyData['StudySummary']['id']])) {
                if (! isset($studyData['StudySummary']['title']) || ! isset($studyData['StudySummary']['cusm_cim_bank_id'])) {
                    $studyData = $this->find('first', array(
                        'conditions' => array(
                            'StudySummary.id' => ($studyData['StudySummary']['id'])
                        )
                    ));
                }
                $bankName = $this->getStudyBankNameFromId($studyData['StudySummary']['cusm_cim_bank_id']);
                $this->studyDataAndCodeForDisplayAlreadySet[$studyData['StudySummary']['id']] = $studyData['StudySummary']['title'] . ' [' . $studyData['StudySummary']['id'] . ']' . ' || ' . $bankName;
            }
            $formattedData = $this->studyDataAndCodeForDisplayAlreadySet[$studyData['StudySummary']['id']];
        }
        return $formattedData;
    }

    /**
     *
     * @param int $studyBankId
     *            Id of the bank linkedto the study
     * @return string Formatted label of the bank to display
     */
    public function getStudyBankNameFromId($studyBankId)
    {
        if (! isset($this->studyBankIdToBankLabel[$studyBankId])) {
            $bankModel = AppModel::getInstance("Administrate", "Bank", true);
            $bankData = $bankModel->find('first', array(
                'conditions' => array(
                    'Bank.id' => $studyBankId
                )
            ));
            if ($bankData) {
                $this->studyBankIdToBankLabel[$studyBankId] = $bankData['Bank']['name'];
            } else {
                $this->studyBankIdToBankLabel[$studyBankId] = '?';
            }
        }
        return $this->studyBankIdToBankLabel[$studyBankId];
    }
}