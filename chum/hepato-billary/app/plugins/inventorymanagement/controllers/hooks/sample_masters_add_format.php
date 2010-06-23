<?php
//if blood
if($sample_control_id == 2 && empty($this->data)){
	$data = $this->SampleMaster->find('first', array(
		'conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_control_id' => 2), 
		'order' => array('SampleMaster.created DESC')));
	
	$preset['SampleMaster']['sop_master_id'] = $data['SampleMaster']['sop_master_id'];
	$preset['SampleMaster']['is_problematic'] = $data['SampleMaster']['is_problematic'];
	
	foreach(array("supplier_dept", "reception_by", "reception_datetime", "reception_datetime_accuracy") as $val){
		$preset['SpecimenDetail'][$val] = $data['SpecimenDetail'][$val];
	}
	$this->set("preset", $preset);
}
$this->set("sample_control_id", $sample_control_id);