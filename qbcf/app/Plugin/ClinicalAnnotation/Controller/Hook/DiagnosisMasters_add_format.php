<?php
// ================================================================================================================================================================
// Diagnosis & treatment reminder :
// - Only one breast primary diagnosis can be created per participant.
// - A 'breast diagnostic event' treatment can only be created for a breast primary diagnosis.
// - A 'breast progression' can only be created for a breast primary diagnosis.
// - So all 'breast diagnostic event' and 'breast progression' of one participant will be linked to the same breast primary diagnosis.
// ================================================================================================================================================================
switch ($dxControlData['DiagnosisControl']['controls_type']) {
    case 'breast':
        if ($this->DiagnosisMaster->find('count', array(
            'conditions' => array(
                'DiagnosisControl.controls_type' => 'breast',
                'DiagnosisMaster.participant_id' => $participantId
            )
        ))) {
            $this->atimFlashError(__('you can not create a breast diagnosis twice'), 'javascript:history.back();');
        }
        break;
    case 'breast progression':
        if (! $parentDx)
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        if ($parentDx['DiagnosisControl']['controls_type'] != 'breast') {
            $this->atimFlashError(__('you can not link this type of secondary diagnosis to the selected primary'), 'javascript:history.back();');
        }
        break;
    case 'other cancer':
        break;
    case 'other cancer progression':
        if (! $parentDx)
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        if ($parentDx['DiagnosisControl']['controls_type'] != 'other cancer') {
            $this->atimFlashError(__('you can not link this type of secondary diagnosis to the selected primary'), 'javascript:history.back();');
        }
        break;
    default:
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
}