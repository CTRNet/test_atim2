<?php

	if(in_array($children_control_data['SampleControl']['sample_type'], array('pbmc','serum','plasma'))) {
		$default_sample_data = array();
		foreach($this->request->data as $new_data_set){
			$parent_sample_master_id = $new_data_set['parent']['ViewSample']['sample_master_id'];
			$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array("SampleMaster.id" => $parent_sample_master_id), 'recursive' => 0));
			$tmp_default_sample_data = array();
			$tmp_default_sample_data['DerivativeDetail.creation_by'] = $parent_sample_data['SpecimenDetail']['reception_by'];
			$tmp_default_sample_data['DerivativeDetail.creation_datetime'] = $parent_sample_data['SpecimenDetail']['reception_datetime'];
//			$tmp_default_sample_data['DerivativeDetail.creation_datetime_accuracy'] = $parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'];
			$default_sample_data[$parent_sample_master_id] = $tmp_default_sample_data;
		}
		$this->set('default_sample_data', $default_sample_data);
	}
