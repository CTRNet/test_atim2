<?php 

	if(!empty($this->request->data['Collection']['qc_lady_specimen_type_precision'])) {
		$this->Collection->addWritableField(array('qc_lady_specimen_type'));
		$qc_lady_specimen_type_precision = $this->request->data['Collection']['qc_lady_specimen_type_precision'];
		$this->request->data['Collection']['qc_lady_specimen_type'] = substr($qc_lady_specimen_type_precision, 0, strpos($qc_lady_specimen_type_precision,'||'));
	} 
