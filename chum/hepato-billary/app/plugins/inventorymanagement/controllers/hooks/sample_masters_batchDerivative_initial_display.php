<?php

foreach($this->data as &$new_data_set) {
	$new_data_set['children'][0]['DerivativeDetail']['creation_site'] = "ICM";
	$new_data_set['children'][0]['DerivativeDetail']['creation_by'] = 'louise rousseau';
	
	if($children_control_data['SampleControl']['sample_type'] == 'tissue suspension') {
		$new_data_set['children'][0]['SampleDetail']['qc_hb_macs_enzymatic_milieu'] = 'collagenase + dnase';
	}
}
