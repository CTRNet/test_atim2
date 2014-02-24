<?php

	$custom_created_sample_override_data = array('DerivativeDetail.creation_site' => 'cr. st-luc', 'DerivativeDetail.creation_by' => 'louise rousseau');
	if($children_control_data['SampleControl']['sample_type'] == 'tissue suspension') {
		$custom_created_sample_override_data['SampleDetail.qc_hb_macs_enzymatic_milieu'] = 'collagenase + dnase';
	}
	$this->set('custom_created_sample_override_data', $custom_created_sample_override_data);
