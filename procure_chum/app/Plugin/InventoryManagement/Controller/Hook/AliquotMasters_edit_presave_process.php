<?php 
	
	//Validate barcode (in case one bank allow barcode modification)
	if(Configure::read('procure_atim_version') == 'PROCESSING') {
		if(!preg_match('/^[0-9]+$/', $this->request->data['AliquotMaster']['barcode'])) {
			$this->AliquotMaster->validationErrors['barcode'][] = __('aliquot barcode format errror - integer value expected');
			$submitted_data_validates = false;
		}
	} else if($aliquot_data['AliquotMaster']['barcode'] != $this->request->data['AliquotMaster']['barcode'] 
	|| (isset($this->request->data['AliquotMaster']['aliquot_label']) && $aliquot_data['AliquotMaster']['aliquot_label'] != $this->request->data['AliquotMaster']['aliquot_label'])) {
		$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}
	