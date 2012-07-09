<?php
if($aliquot_control_id == 54){
	AppController::getInstance()->redirect( '/pages/qc_nd_no_flask', null, true );
}

// --------------------------------------------------------------------------------
// Set default aliquot label(s)
// --------------------------------------------------------------------------------
$default_aliquot_labels = array();
foreach($samples as $view_sample){
	$default_aliquot_label = $this->AliquotMaster->generateDefaultAliquotLabel($view_sample, $aliquot_control);
	$default_aliquot_labels[$view_sample['ViewSample']['sample_master_id']] = $default_aliquot_label;
}
$this->set('default_aliquot_labels', $default_aliquot_labels);