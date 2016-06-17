<?php 
	
	if(empty($this->request->data) && in_array($dx_control_data['DiagnosisControl']['controls_type'], array('digestive system', 'other'))) $this->set('default_ajcc_edition', 'WHO 2010');
