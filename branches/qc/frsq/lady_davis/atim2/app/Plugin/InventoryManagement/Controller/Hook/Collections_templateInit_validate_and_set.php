<?php 

	if($data_validates && $template['Template']['name'] == 'META') {
		$this->request->data['FunctionManagement']['qc_ladyis_blood_meta_template'] = '1';
	} else {
		$this->request->data['FunctionManagement']['qc_ladyis_blood_meta_template'] = '0';
	}
