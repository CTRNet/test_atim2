<?php

if(isset($this->request->data['Collection']['participant_id'])) {
	if(!isset($this->request->data['Collection']['treatment_master_id'])) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	if($this->request->data['Collection']['participant_id'] && !$this->request->data['Collection']['treatment_master_id']) {
		$this->Collection->validationErrors['col_copy_binding_opt'][] = __('the transplant linked to the collection has to be selected');
		$submitted_data_validates = false;		
	}
}
