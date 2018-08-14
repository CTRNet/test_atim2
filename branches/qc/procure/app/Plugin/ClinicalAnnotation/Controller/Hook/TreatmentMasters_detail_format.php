<?php
if ($treatment_master_data['TreatmentControl']['treatment_extend_control_id'])
    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);

$this->set('add_link_for_procure_forms', $this->Participant->buildAddProcureFormsButton($participant_id));
	