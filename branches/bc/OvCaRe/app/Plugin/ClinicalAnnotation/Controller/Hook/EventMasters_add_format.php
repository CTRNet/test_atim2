<?php

	if(!isset($display_all_exp_tests)) $this->redirect( '/Pages/err_plugin_no_data?method=EventMasters.add_format,line='.__LINE__, NULL, TRUE ); // To validate arg has been added to trunk controller

	$multi_add = in_array($event_control_data['EventControl']['event_type'], array('experimental tests','study inclusion'))? true : false;
	$this->set('multi_add' , $multi_add);
	$initial_display = empty($this->request->data);
	if (empty($this->request->data) && $multi_add && $display_all_exp_tests) {
		// Build one row per experimental test
		$this->request->data = array();
		$StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
		$StructurePermissibleValuesCustomControl = AppModel::getInstance("", "StructurePermissibleValuesCustomControl", true);
		$control_data = $StructurePermissibleValuesCustomControl->find('first', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => 'experimental tests'), 'recursive' => 0));
		if(empty($control_data)) $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
		$custom_tests_list = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustom.control_id' => $control_data['StructurePermissibleValuesCustomControl']['id'], 'StructurePermissibleValuesCustom.use_as_input' => '1'), 'order' => array('display_order', 'en'), 'recursive' => -1));
		foreach($custom_tests_list as $new_test) {
			$this->request->data[]['EventDetail']['test'] = $new_test['StructurePermissibleValuesCustom']['value'];
		}
		
	}
	
	$this->set('ev_header', __($event_control_data['EventControl']['event_type']));
	
 

?>