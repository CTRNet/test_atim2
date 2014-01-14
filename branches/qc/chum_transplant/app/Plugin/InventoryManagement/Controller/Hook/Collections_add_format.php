<?php

if(!empty($this->request->data) && isset($this->request->data['FunctionManagement']['col_copy_binding_opt']) && $this->request->data['FunctionManagement']['col_copy_binding_opt'] == '2') {
	$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
}

if(!$need_to_save && !empty($collection_data)) {
	if($collection_data['EventMaster']['id']) {
		// A biopsy has been linked to the collection
		$this->request->data['Collection']['collection_datetime'] = $collection_data['EventMaster']['event_date'];
		$this->request->data['Collection']['collection_datetime_accuracy'] = $collection_data['EventMaster']['event_date_accuracy'];
	} else if($collection_data['TreatmentMaster']['id'] && !$this->Collection->find('count', array('conditions' => array('Collection.treatment_master_id' => $collection_data['TreatmentMaster']['id']), 'recursive' => '-1'))) {
		// If first collection linked to the treatment... here we go
		$this->request->data['Collection']['collection_datetime'] = $collection_data['TreatmentMaster']['start_date'];
		$this->request->data['Collection']['collection_datetime_accuracy'] = $collection_data['TreatmentMaster']['start_date_accuracy'];
	}
}