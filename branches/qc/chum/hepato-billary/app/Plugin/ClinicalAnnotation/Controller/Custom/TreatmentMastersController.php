<?php

class TreatmentMastersControllerCustom extends TreatmentMastersController
{

    public function preOperativeDetail($participantId, $txMasterId)
    {
        if ((! $participantId) && (! $txMasterId)) {
            $this->redirect('/pages/err_plugin_funct_param_missing', null, true);
        }
        
        // LOAD SURGERY DATA / FORM (including cirrhosis data)
        
        $surgeryData = $this->TreatmentMaster->find('first', array(
            'conditions' => array(
                'TreatmentMaster.id' => $txMasterId,
                'TreatmentMaster.participant_id' => $participantId
            )
        ));
        if (empty($surgeryData)) {
            $this->redirect('/pages/err_plugin_no_data', null, true);
        }
        
        switch ($surgeryData['TreatmentControl']['detail_tablename']) {
            case 'qc_hb_txd_surgery_livers':
                $structureName = 'qc_hb_pre_surgery_livers';
                break;
            case 'qc_hb_txd_surgery_pancreas':
                $structureName = 'qc_hb_pre_surgery_pancreas';
                break;
            default:
                $this->atimFlashWarning(__("no pre operative data has to be defined for this type of treatment"), '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $txMasterId . '/');
                return;
        }
        
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'TreatmentMaster.id' => $txMasterId
        ));
        $this->Structures->set($structureName);
        $this->request->data = $surgeryData;
        
        // LOAD EVENT DATA & STRUCTURES (that could be linked to preoperative report)
        
        $surgeriesEventsData = array();
        
        $surgeriesEventsData['lab_report_id'] = $this->getEventDataForPreOperativeForm('lab_report_id', 'lab', 'biology', $this->request->data, $participantId, $this->request->data['TreatmentDetail']['lab_report_id']);
        $surgeriesEventsData['imagery_id'] = $this->getEventDataForPreOperativeForm('imagery_id', 'imagery', 'medical imaging%', $this->request->data, $participantId, $this->request->data['TreatmentDetail']['imagery_id']);
        $surgeriesEventsData['fong_score_id'] = $this->getEventDataForPreOperativeForm('fong_score_id', 'scores', 'fong score', $this->request->data, $participantId, $this->request->data['TreatmentDetail']['fong_score_id']);
        $surgeriesEventsData['meld_score_id'] = $this->getEventDataForPreOperativeForm('meld_score_id', 'scores', 'meld score', $this->request->data, $participantId, $this->request->data['TreatmentDetail']['meld_score_id']);
        $surgeriesEventsData['gretch_score_id'] = $this->getEventDataForPreOperativeForm('gretch_score_id', 'scores', 'gretch score', $this->request->data, $participantId, $this->request->data['TreatmentDetail']['gretch_score_id']);
        $surgeriesEventsData['clip_score_id'] = $this->getEventDataForPreOperativeForm('clip_score_id', 'scores', 'clip score', $this->request->data, $participantId, $this->request->data['TreatmentDetail']['clip_score_id']);
        $surgeriesEventsData['barcelona_score_id'] = $this->getEventDataForPreOperativeForm('barcelona_score_id', 'scores', 'barcelona score', $this->request->data, $participantId, $this->request->data['TreatmentDetail']['barcelona_score_id']);
        $surgeriesEventsData['okuda_score_id'] = $this->getEventDataForPreOperativeForm('okuda_score_id', 'scores', 'okuda score', $this->request->data, $participantId, $this->request->data['TreatmentDetail']['okuda_score_id']);
        
        $this->set('surgeriesEventsData', $surgeriesEventsData);
        
        // Load EventMaster
        $this->EventMaster = AppModel::getInstance('ClinicalAnnotation', 'EventMaster', true);
        
        // Load lab reports list, imagings and structure
        $this->set('imagingsData', $this->EventMaster->find('all', array(
            'conditions' => array(
                'EventMaster.id' => $surgeryData['TreatmentDetail']['imagery_id']
            )
        )));
        $this->set('labReportsData', $this->EventMaster->find('all', array(
            'conditions' => array(
                'EventMaster.id' => $surgeryData['TreatmentDetail']['lab_report_id']
            )
        )));
        $this->Structures->set('eventmasters', 'eventmasters_structure');
        
        // Load scores list and structures
        $this->set('scoreFongData', $this->EventMaster->find('all', array(
            'conditions' => array(
                'EventMaster.id' => $surgeryData['TreatmentDetail']['fong_score_id']
            )
        )));
        $this->Structures->set('qc_hb_ed_score_fong', 'score_fong_structure');
        $this->set('scoreMeldData', $this->EventMaster->find('all', array(
            'conditions' => array(
                'EventMaster.id' => $surgeryData['TreatmentDetail']['meld_score_id']
            )
        )));
        $this->Structures->set('qc_hb_ed_score_meld', 'score_meld_structure');
        $this->set('scoreGretchData', $this->EventMaster->find('all', array(
            'conditions' => array(
                'EventMaster.id' => $surgeryData['TreatmentDetail']['gretch_score_id']
            )
        )));
        $this->Structures->set('qc_hb_ed_score_gretch', 'score_gretch_structure');
        $this->set('scoreClipData', $this->EventMaster->find('all', array(
            'conditions' => array(
                'EventMaster.id' => $surgeryData['TreatmentDetail']['clip_score_id']
            )
        )));
        $this->Structures->set('qc_hb_ed_score_clip', 'score_clip_structure');
        $this->set('scoreBarcelonaData', $this->EventMaster->find('all', array(
            'conditions' => array(
                'EventMaster.id' => $surgeryData['TreatmentDetail']['barcelona_score_id']
            )
        )));
        $this->Structures->set('qc_hb_ed_score_barcelona', 'score_barcelona_structure');
        $this->set('scoreOkudaData', $this->EventMaster->find('all', array(
            'conditions' => array(
                'EventMaster.id' => $surgeryData['TreatmentDetail']['okuda_score_id']
            )
        )));
        $this->Structures->set('qc_hb_ed_score_okuda', 'score_okuda_structure');
    }

    public function preOperativeEdit($participantId, $txMasterId)
    {
        if ((! $participantId) && (! $txMasterId)) {
            $this->redirect('/pages/err_plugin_funct_param_missing', null, true);
        }
        
        // SURGERY DATA & STRUCTURES
        
        $surgeryData = $this->TreatmentMaster->find('first', array(
            'conditions' => array(
                'TreatmentMaster.id' => $txMasterId,
                'TreatmentMaster.participant_id' => $participantId
            )
        ));
        if (empty($surgeryData)) {
            $this->redirect('/pages/err_plugin_no_data', null, true);
        }
        
        switch ($surgeryData['TreatmentControl']['detail_tablename']) {
            case 'qc_hb_txd_surgery_livers':
                $structureName = 'qc_hb_pre_surgery_livers';
                break;
            case 'qc_hb_txd_surgery_pancreas':
                $structureName = 'qc_hb_pre_surgery_pancreas';
                break;
            default:
                $this->atimFlashWarning(__("no pre operative data has to be defined for this type of treatment"), '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $txMasterId . '/');
                return;
        }
        
        $this->Structures->set($structureName);
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/preOperativeDetail/'));
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'TreatmentMaster.id' => $txMasterId
        ));
        
        if (empty($this->request->data)) {
            
            // INITIAL DISPLAY
            
            $this->request->data = $surgeryData;
            
            // Set default cirrhosis data
            if ($this->request->data['TreatmentDetail']['type_of_cirrhosis'] == "" && $this->request->data['TreatmentDetail']['esophageal_varices'] == "" && $this->request->data['TreatmentDetail']['gastric_varices'] == "" && $this->request->data['TreatmentDetail']['tips'] == "" && $this->request->data['TreatmentDetail']['portacaval_gradient'] == "" && $this->request->data['TreatmentDetail']['splenomegaly'] == "" && $this->request->data['TreatmentDetail']['splen_size'] == "") {
                
                $this->EventMaster = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
                $cirrhosis = $this->EventMaster->find('first', array(
                    'conditions' => array(
                        'EventControl.event_group' => 'clinical',
                        'EventControl.event_type' => 'cirrhosis medical past history'
                    ),
                    'order' => 'EventMaster.event_date DESC'
                ));
                if (! empty($cirrhosis)) {
                    // not the most efficient, but will automatically work if new fields matches in both tables
                    unset($cirrhosis['EventDetail']['id']);
                    unset($cirrhosis['EventDetail']['event_master_id']);
                    unset($cirrhosis['EventDetail']['created']);
                    unset($cirrhosis['EventDetail']['created_by']);
                    unset($cirrhosis['EventDetail']['modified']);
                    unset($cirrhosis['EventDetail']['modified_by']);
                    unset($cirrhosis['EventDetail']['deleted']);
                    unset($cirrhosis['EventDetail']['deleted_by']);
                    $this->request->data['TreatmentDetail'] = array_merge($this->request->data['TreatmentDetail'], $cirrhosis['EventDetail']);
                }
            }
        } else {
            
            // LAUNCH SAVE PROCESS
            
            $this->TreatmentMaster->id = $txMasterId;
            $this->request->data['TreatmentMaster']['id'] = $txMasterId;
            if ($this->TreatmentMaster->save($this->request->data)) {
                $this->atimFlashConfirm(__("your data has been saved"), '/ClinicalAnnotation/TreatmentMasters/preOperativeDetail/' . $participantId . '/' . $txMasterId . '/');
                return;
            }
        }
        
        // LOAD EVENT DATA & STRUCTURES (that could be linked to preoperative report)
        
        $surgeriesEventsData = array();
        
        $surgeriesEventsData['lab_report_id'] = $this->getEventDataForPreOperativeForm('lab_report_id', 'lab', 'biology', $this->request->data, $participantId);
        $surgeriesEventsData['imagery_id'] = $this->getEventDataForPreOperativeForm('imagery_id', 'imagery', 'medical imaging%', $this->request->data, $participantId);
        $surgeriesEventsData['fong_score_id'] = $this->getEventDataForPreOperativeForm('fong_score_id', 'scores', 'fong score', $this->request->data, $participantId);
        $surgeriesEventsData['meld_score_id'] = $this->getEventDataForPreOperativeForm('meld_score_id', 'scores', 'meld score', $this->request->data, $participantId);
        $surgeriesEventsData['gretch_score_id'] = $this->getEventDataForPreOperativeForm('gretch_score_id', 'scores', 'gretch score', $this->request->data, $participantId);
        $surgeriesEventsData['clip_score_id'] = $this->getEventDataForPreOperativeForm('clip_score_id', 'scores', 'clip score', $this->request->data, $participantId);
        $surgeriesEventsData['barcelona_score_id'] = $this->getEventDataForPreOperativeForm('barcelona_score_id', 'scores', 'barcelona score', $this->request->data, $participantId);
        $surgeriesEventsData['okuda_score_id'] = $this->getEventDataForPreOperativeForm('okuda_score_id', 'scores', 'okuda score', $this->request->data, $participantId);
        
        $this->set('surgeriesEventsData', $surgeriesEventsData);
    }

    public function getEventDataForPreOperativeForm($eventForeignKey, $eventGroup, $eventType, $preOperativeData, $participantId, $eventMasterId = '-1')
    {
        $this->EventMaster = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
        
        $conditions = array(
            'EventMaster.participant_id' => $participantId,
            'EventControl.event_group' => $eventGroup,
            'EventControl.event_type LIKE "' . $eventType . '"'
        );
        if ($eventMasterId != '-1') {
            $conditions['EventMaster.id'] = $eventMasterId;
        }
        $eventData = $this->EventMaster->find('all', array(
            'conditions' => $conditions
        ));
        
        $selectedEventFound = false;
        if ($eventMasterId == '-1') {
            foreach ($eventData as &$event) {
                if ($event['EventMaster']['id'] == $preOperativeData['TreatmentDetail'][$eventForeignKey]) {
                    // we found the one that interests us
                    $event['TreatmentMaster'] = $preOperativeData['TreatmentMaster'];
                    $event['TreatmentDetail'] = $preOperativeData['TreatmentDetail'];
                    $selectedEventFound = true;
                    break;
                }
                if ($selectedEventFound)
                    break;
            }
        }
        
        $this->EventControl = AppModel::getInstance("ClinicalAnnotation", "EventControl", true);
        $conditions = array(
            'EventControl.event_group' => $eventGroup,
            'EventControl.event_type LIKE "' . $eventType . '"'
        );
        $eventControls = $this->EventControl->find('all', array(
            'conditions' => $conditions
        ));
        
        $formAliases = array();
        foreach ($eventControls as $newControl) {
            $formAliases[$newControl['EventControl']['form_alias']] = $newControl['EventControl']['form_alias'];
        }
        $formAlias = (sizeof($formAliases) == 1) ? array_shift($formAliases) : 'eventmasters';
        
        return array(
            'event_foreign_key' => $eventForeignKey,
            'data' => $eventData,
            'selected_event_found' => $selectedEventFound,
            'structure' => $this->Structures->get('form', $formAlias),
            'header' => str_replace('%', '', $eventType)
        );
    }
}