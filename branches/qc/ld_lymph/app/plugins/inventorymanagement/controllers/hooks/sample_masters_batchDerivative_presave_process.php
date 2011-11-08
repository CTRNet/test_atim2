<?php

	$spe_nbr_from_specimen_id = array();
	if(empty($errors)){
		foreach($this->data as $new_parent) {
			if(!isset($new_parent['parent']['ViewSample']['ld_lymph_specimen_number'])) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			$spe_nbr_from_specimen_id[$new_parent['parent']['ViewSample']['initial_specimen_sample_id']] = $new_parent['parent']['ViewSample']['ld_lymph_specimen_number'];
		}
		
		foreach($prev_data as &$new_derivatives_set) {
			foreach($new_derivatives_set as &$new_derivative_unit) {
				if(!isset($new_derivative_unit['SampleMaster']['initial_specimen_sample_id'])) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				if(!isset($spe_nbr_from_specimen_id[$new_derivative_unit['SampleMaster']['initial_specimen_sample_id']])) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				$new_derivative_unit['SampleMaster']['ld_lymph_specimen_number'] = $spe_nbr_from_specimen_id[$new_derivative_unit['SampleMaster']['initial_specimen_sample_id']];
			}
		}
	}
