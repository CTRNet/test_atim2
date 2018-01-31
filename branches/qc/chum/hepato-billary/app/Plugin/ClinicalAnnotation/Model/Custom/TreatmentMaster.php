<?php

class TreatmentMasterCustom extends TreatmentMaster
{

    var $useTable = 'treatment_masters';

    var $name = 'TreatmentMaster';

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['TreatmentMaster.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'TreatmentMaster.id' => $variables['TreatmentMaster.id']
                )
            ));
            $return = array(
                'menu' => array(
                    null,
                    __($result['TreatmentControl']['disease_site'], true) . ' - ' . __($result['TreatmentControl']['tx_method'], true)
                ),
                'title' => array(
                    null,
                    __($result['TreatmentControl']['disease_site'], true) . ' - ' . __($result['TreatmentControl']['tx_method'], true)
                ),
                'structure alias' => $result['TreatmentControl']['form_alias'],
                'data' => $result
            );
        }
        
        return $return;
    }

    public function updateAllSurvivalTimes($participantId, $treatmentMasterId = null)
    {
        
        // Get Participant Data
        $participantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        $participantData = $participantModel->find('first', array(
            'conditions' => array(
                'Participant.id' => $participantId
            ),
            'recursive' => -1
        ));
        if (empty($participantData))
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            
            // Get Surgeries
        $conditions = array(
            'TreatmentMaster.participant_id' => $participantId,
            'TreatmentControl.tx_method' => 'surgery'
        );
        if ($treatmentMasterId)
            $conditions['TreatmentMaster.id'] = $treatmentMasterId;
        $participantSurgeries = $this->find('all', array(
            'conditions' => $conditions,
            'recursive' => 0
        ));
        
        // Update Survival Times
        foreach ($participantSurgeries as $newSurgery) {
            if (array_key_exists('survival_time_in_months', $newSurgery['TreatmentDetail'])) {
                $lastNewsDate = $participantData['Participant']['last_news_date'];
                $lastNewsDateAccuracy = $participantData['Participant']['last_news_date_accuracy'];
                $surgeryId = $newSurgery['TreatmentMaster']['id'];
                $surgeryDate = $newSurgery['TreatmentMaster']['start_date'];
                $surgeryDateAccuracy = $newSurgery['TreatmentMaster']['start_date_accuracy'];
                $oldSurvivalTimeInMonths = $newSurgery['TreatmentDetail']['survival_time_in_months'];
                $newSurvivalTimeInMonths = '';
                if ($surgeryDate && $lastNewsDate) {
                    if (in_array($surgeryDateAccuracy, array(
                        'y',
                        'm'
                    )) || in_array($lastNewsDateAccuracy, array(
                        'y',
                        'm'
                    ))) {
                        AppController::addWarningMsg(str_replace('%field%', __('survival time in months', true), __('the dates accuracy is not sufficient: the field [%%field%%] can not be generated', true)));
                    } else {
                        $SurgeryDateObj = new DateTime($surgeryDate);
                        $LastNewsDateObj = new DateTime($lastNewsDate);
                        $interval = $SurgeryDateObj->diff($LastNewsDateObj);
                        if ($interval->invert) {
                            AppController::addWarningMsg(str_replace('%field%', __('survival time in months', true), __('error in the dates definitions: the field [%%field%%] can not be generated', true)));
                        } else {
                            $newSurvivalTimeInMonths = $interval->y * 12 + $interval->m;
                        }
                    }
                }
                if ((is_null($oldSurvivalTimeInMonths) && ! is_null($newSurvivalTimeInMonths)) || ($oldSurvivalTimeInMonths != $newSurvivalTimeInMonths)) {
                    $newTrData = array();
                    $newTrData['TreatmentMaster']['id'] = $surgeryId;
                    $newTrData['TreatmentDetail']['survival_time_in_months'] = $newSurvivalTimeInMonths;
                    $this->data = array();
                    $this->id = $surgeryId;
                    $this->addWritableField(array(
                        'survival_time_in_months'
                    ));
                    if (! $this->save($newTrData, false))
                        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            }
        }
    }

    public function inactivatePreOperativeDataMenu($atimMenu, $detailTablename)
    {
        if (! in_array($detailTablename, array(
            'qc_hb_txd_surgery_livers',
            'qc_hb_txd_surgery_pancreas'
        ))) {
            foreach ($atimMenu as $menuGroupId => $menuGroup) {
                foreach ($menuGroup as $menuId => $menuData) {
                    if (strpos($menuData['Menu']['use_link'], '/ClinicalAnnotation/TreatmentMasters/preOperativeDetail') !== false) {
                        $atimMenu[$menuGroupId][$menuId]['Menu']['allowed'] = 0;
                        return $atimMenu;
                    }
                }
            }
        }
        return $atimMenu;
    }

    public function allowDeletion($txMasterId)
    {
        $res = parent::allowDeletion($txMasterId);
        if ($res['allow_deletion']) {
            if ($txMasterId != $this->id) {
                // not the same, fetch
                $data = $this->findById($txMasterId);
            } else {
                $data = $this->data;
            }
            $participantId = $data['TreatmentMaster']['participant_id'];
            if (! $participantId)
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            $EventControl = AppModel::getInstance('ClinicalAnnotation', 'EventControl', true);
            $studiedEventControlIds = $EventControl->find('list', array(
                'conditions' => array(
                    'EventControl.detail_tablename' => 'qc_hb_ed_hepatobilary_lab_report_biologies',
                    'EventControl.flag_active' => '1'
                ),
                'fields' => array(
                    'EventControl.id'
                )
            ));
            $EventMaster = AppModel::getInstance('ClinicalAnnotation', 'EventMaster', true);
            $linkedLabReportBiologies = $EventMaster->find('all', array(
                'conditions' => array(
                    'EventMaster.event_control_id' => $studiedEventControlIds,
                    'EventMaster.participant_id' => $participantId
                )
            ));
            $linkedToEvent = false;
            foreach ($linkedLabReportBiologies as $newOne) {
                if ($newOne['EventDetail']['surgery_tx_master_id'] == $txMasterId)
                    $linkedToEvent = true;
            }
            if ($linkedToEvent)
                $res = array(
                    'allow_deletion' => false,
                    'msg' => 'at least one biology lab report is linked to this treatment'
                );
        }
        return $res;
    }
}