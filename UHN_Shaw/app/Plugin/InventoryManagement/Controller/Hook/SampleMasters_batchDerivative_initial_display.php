<?php

	$uhn_default_values = array();
	 if($children_control_data['SampleControl']['sample_type'] == 'cell culture') {
	 	foreach($this->request->data as $uhn_batchderivative_data) {
	 		if($uhn_batchderivative_data['parent']['ViewSample']['sample_type'] == 'cell culture') {
	 			$this->SampleMaster->unbindModel(array('belongsTo' => array('Collection'),'hasOne' => array('SpecimenDetail','DerivativeDetail'),'hasMany' => array('AliquotMaster')));
	 			$uhn_parent_detail = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $uhn_batchderivative_data['parent']['ViewSample']['sample_master_id']), 'recursive' => '0'));
	 			$uhn_default_values[$uhn_batchderivative_data['parent']['ViewSample']['sample_master_id']]['SampleDetail']['uhn_is_cell_line'] = $uhn_parent_detail['SampleDetail']['uhn_is_cell_line'];
	 			$uhn_default_values[$uhn_batchderivative_data['parent']['ViewSample']['sample_master_id']]['SampleDetail']['uhn_gene_insertion'] = $uhn_parent_detail['SampleDetail']['uhn_gene_insertion'];
	 			$uhn_default_values[$uhn_batchderivative_data['parent']['ViewSample']['sample_master_id']]['SampleDetail']['uhn_gene_deletion'] = $uhn_parent_detail['SampleDetail']['uhn_gene_deletion'];
	 		}	 		
	 	}
	 }
	 $this->set('uhn_default_values', $uhn_default_values);
	 	 
?>
