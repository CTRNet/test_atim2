<?php 
	if($submitted_data_validates){
		if($aliquot_data['SampleControl']['sample_type'] == 'rna') {
			list($this->request->data['AliquotDetail']['procure_total_quantity_ug'], $this->request->data['AliquotDetail']['procure_total_quantity_ug_nanodrop'])  = $this->AliquotMaster->calculateRnaQuantity($this->request->data);			
			$this->AliquotMaster->addWritableField(array('procure_total_quantity_ug', 'procure_total_quantity_ug_nanodrop'));
		}
	}
	