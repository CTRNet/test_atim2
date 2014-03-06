<?php 
	$tmp_controls = array();
	foreach($controls as $key => $new_samp_contrl_data) {
		if($this->request->data['ViewCollection']['qc_lady_specimen_type'] == $new_samp_contrl_data['SampleControl']['sample_type']) $tmp_controls[$key] = $new_samp_contrl_data;
	}
	$this->set('specimen_sample_controls_list', $tmp_controls);	
	