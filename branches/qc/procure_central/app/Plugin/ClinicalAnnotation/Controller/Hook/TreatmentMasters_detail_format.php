<?php
if ($treatmentMasterData['TreatmentControl']['treatment_extend_control_id'])
    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);

$this->set('addLinkForProcureForms', $this->Participant->buildAddProcureFormsButton($participantId));