<?php

class QualityControlsController extends InventoryManagementAppController {
	
	var $uses = array(
			'AliquotMaster',
			'AliquotUse',
			'Collection',
			'QcTestedAliquot',
			'QualityControl',
			'SampleMaster'
	);
	var $paginate = array('QualityControl'=>array('limit'=>10));

	function listAllQualityControls($collection_id=null, $sample_master_id=null) {
		$this->set('atim_menu_variables', array('Collection.id'=>$collection_id, 'SampleMaster.id'=>$sample_master_id));
		$this->data = $this->paginate($this->QualityControl,array('QualityControl.sample_master_id'=>$sample_master_id));
	}
	
	function detail($collection_id=null, $sample_master_id=null, $quality_control_id=null) {
		$this->set('atim_menu_variables', array('Collection.id'=>$collection_id, 'SampleMaster.id'=>$sample_master_id, 'QualityControl.id'=>$quality_control_id));
		$this->data = $this->QualityControl->find('first',array('conditions'=>array('QualityControl.id'=>$quality_control_id)));
	}
	
	function edit($collection_id=null, $sample_master_id=null, $quality_control_id=null) {
		$this->set('atim_menu_variables', array('Collection.id'=>$collection_id, 'SampleMaster.id'=>$sample_master_id, 'QualityControl.id'=>$quality_control_id));
		
		$this_data = $this->QualityControl->find('first',array('conditions'=>array('QualityControl.id'=>$quality_control_id)));
		
		if (!empty($this->data)) {
			$this->QualityControl->id = $quality_control_id;
			if ($this->QualityControl->save($this->data)) $this->flash('Your data has been updated . ','/inventorymanagement/quality_controls/detail/' . $collection_id . '/' . $sample_master_id . '/' . $quality_control_id);
		} else {
			$this->data = $this_data;
		}
	
	}
	
	/**
	 * Allow to display data of a sample quality control. 
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category
	 * @param $collection_id Id of the studied collection.
	 * @param $sample_master_id Master ID of the studied sample.
	 * @param $quality_control_id ID of the studied quality control.
	 * 
	 * @author N. Luc
	 * @date 2008-01-28
	 */
	function detail_OLD($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null, 
	$collection_id=null, $sample_master_id=null, $quality_control_id = null) {
	
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($sample_category) || 
		empty($group_specimen_type) || empty($collection_id)
		|| empty($sample_master_id) || empty($quality_control_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// Verify collection data exists
		$criteria = 'Collection.id = "' . $collection_id . '" ';		
		$collection_data = $this->Collection->find($criteria);
		
		if(empty($collection_data)) {
			$this->redirect('/pages/err_inv_coll_no_data'); 
			exit;
		}
		
		// Verify sample exists
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}	
				
		// ** Get QC data **
		$criteria = array();
		$criteria['QualityControl.id'] = $quality_control_id;
		$criteria['QualityControl.sample_master_id'] = $sample_master_id;
		$criteria = array_filter($criteria);
	
		$sample_qc_data = $this->QualityControl->find($criteria, null, null, 0);
				
		if(empty($sample_qc_data)){
			$this->redirect('/pages/err_inv_qc_no_data'); 
			exit;
		}	
			
		if(strcmp($sample_qc_data['SampleMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}

		$this->set('data', $sample_qc_data);		
				
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('quality_controls'));
		
		// ** set DATA for echo on VIEW or for link build **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		
		$this->set('collection_id', $collection_id);
		$this->set('sample_category', $sample_category);
		$this->set('sample_master_id', $sample_master_id);
		
		$this->set('allow_qc_deletion', $this->allowQcDeletion($quality_control_id));
		
//		$this->set('sample_code', $sample_qc_data['SampleMaster']['sample_code']);
				
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_qc';
				$qc_menu_id = $specimen_group_menu_id . '-sa_qc_de';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $qc_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $qc_menu_id, $collection_id . '/' . $specimen_sample_master_id . '/' . $quality_control_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_der';
				$derivative_menu_id = $specimen_group_menu_id . '-der_qc';
				$qc_menu_id = $specimen_group_menu_id . '-der_qc_de';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $qc_menu_id, $derivative_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $qc_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/' . $quality_control_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);	
	
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_'.
				$this->params['controller'] . '_'.
				$this->params['action']));
				
		// ** Build array that allows to know tested aliquot code from the aliquot id **
		$arr_aliquot_barcode_from_id = array('0' => 'n/a');
				
		if(!empty($sample_qc_data['QualityControl']['aliquot_master_id'])){
			$criteria = array();
			$criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
			$criteria['AliquotMaster.collection_id'] = $collection_id;
			$criteria['AliquotMaster.id'] = $sample_qc_data['QualityControl']['aliquot_master_id'];
			 
			$aliquot_data = $this->AliquotMaster->find($criteria, null, null, 0);
							 
			if(empty($aliquot_data)){
				$this->redirect('/pages/err_inv_aliquot_no_data'); 
				exit;
			}
			
			$arr_aliquot_barcode_from_id 
				= array($aliquot_data['AliquotMaster']['id'] => $aliquot_data['AliquotMaster']['barcode']);
		}
		
		$this->set('arr_aliquot_barcode_from_id', $arr_aliquot_barcode_from_id);
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
	
	}

	/**
	 * Allow to add a sample quality control. 
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category
	 * @param $collection_id Id of the studied collection.
	 * @param $sample_master_id Master ID of the studied sample.
	 * 
	 * @author N. Luc
	 * @date 2008-01-28
	 */
	function add($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null,
	$collection_id=null, $sample_master_id=null) {
	 	
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id)
		|| empty($sample_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// Verify collection data exists
		$criteria = 'Collection.id = "' . $collection_id . '" ';		
		$collection_data = $this->Collection->find($criteria);
		
		if(empty($collection_data)) {
			$this->redirect('/pages/err_inv_coll_no_data'); 
			exit;
		}
		
		// Verify sample exists
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}	
				
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('quality_controls'));
		
		// ** set DATA for echo on VIEW or for link build **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		
		$this->set('collection_id', $collection_id);
		$this->set('sample_category', $sample_category);
		$this->set('sample_master_id', $sample_master_id);
		
//		$this->set('sample_code', $sample_master_data['SampleMaster']['sample_code']);
				
		// ** Set MENU variable for echo on VIEW **
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_qc';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_der';
				$derivative_menu_id = $specimen_group_menu_id . '-der_qc';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/');	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);	
	
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_'.
				$this->params['controller'] . '_'.
				$this->params['action']));

		// ** Build array that allows to list code of available sample aliquot from the aliquot id **
		$criteria = array();
		$criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
		$criteria['AliquotMaster.collection_id'] = $collection_id;
				 
		$arr_aliquot_barcode_from_id = 
			$this->AliquotMaster->generateList(
				$criteria, 
				null, 
				null, 
				'{n}.AliquotMaster.id', 
				'{n}.AliquotMaster.barcode');				
		
		if(!empty($arr_aliquot_barcode_from_id)) {
			$arr_aliquot_barcode_from_id['0'] = 'n/a';
		} else {
			$arr_aliquot_barcode_from_id = array('0' => 'n/a');
		}
		
		$this->set('arr_aliquot_barcode_from_id', $arr_aliquot_barcode_from_id);
			
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}	
				
		if (!empty($this->data)) {
			
			// ** Execute Validation **
						
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('quality_controls') as $validate_model=>$validate_rules) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			$submitted_data_validates = true;
			
			// Validates Fields of Master Table
			if(!$this->QualityControl->validates($this->data['QualityControl'])){
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'] . '_' . $this->params['action'] . '_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			if ($submitted_data_validates) {

				// ** Save Data **
							
				$bool_save_done = true;
				
				if($this->QualityControl->save($this->data['QualityControl'])){
					$quality_control_id = $this->QualityControl->getLastInsertId();
				} else {
					$bool_save_done = false;
				}
				
				if(!$bool_save_done){
					$this->redirect('/pages/err_inv_qc_record_err'); 
					exit;
				} else {
					// Data has been recorded
					$this->flash('Your data has been saved . ', 
						"/quality_controls/detail/$specimen_group_menu_id/$group_specimen_type/$sample_category/" .
						"$collection_id/$sample_master_id/$quality_control_id/");				
				}
				
			}			
			
		}

	}	// End function Add

	/**
	 * Allow to edit a sample quality control. 
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $collection_id Id of the studied collection.
	 * @param $sample_master_id Master ID of the studied sample.
	 * @param $quality_control_id ID of the studied quality control.
	 * 
	 * @author N. Luc
	 * @date 2008-01-28
	 */
	function edit_OLD($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null, 
	$collection_id=null, $sample_master_id=null, $quality_control_id = null) {
	
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($sample_category) || 
		empty($group_specimen_type) || empty($collection_id)
		|| empty($sample_master_id) || empty($quality_control_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// Verify collection data exists
		$criteria = 'Collection.id = "' . $collection_id . '" ';		
		$collection_data = $this->Collection->find($criteria);
		
		if(empty($collection_data)) {
			$this->redirect('/pages/err_inv_coll_no_data'); 
			exit;
		}
		
		// Verify sample exists
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}	
		
		// ** Get QC data **
		$criteria = array();
		$criteria['QualityControl.id'] = $quality_control_id;
		$criteria['QualityControl.sample_master_id'] = $sample_master_id;
		$criteria = array_filter($criteria);
	
		$sample_qc_data = $this->QualityControl->find($criteria, null, null, 0);
				
		if(empty($sample_qc_data)){
			$this->redirect('/pages/err_inv_qc_no_data'); 
			exit;
		}	
			
		if(strcmp($sample_qc_data['SampleMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('quality_controls'));
		
		// ** set DATA for echo on VIEW or for link build **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		
		$this->set('collection_id', $collection_id);
		$this->set('sample_category', $sample_category);
		$this->set('sample_master_id', $sample_master_id);
		
//		$this->set('sample_code', $sample_qc_data['SampleMaster']['sample_code']);
				
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_qc';
				$qc_menu_id = $specimen_group_menu_id . '-sa_qc_de';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $qc_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $qc_menu_id, $collection_id . '/' . $specimen_sample_master_id . '/' . $quality_control_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_der';
				$derivative_menu_id = $specimen_group_menu_id . '-der_qc';
				$qc_menu_id = $specimen_group_menu_id . '-der_qc_de';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $qc_menu_id, $derivative_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $qc_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/' . $quality_control_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);	
		
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_'.
				$this->params['controller'] . '_'.
				$this->params['action']));
				
		// ** Build array that allows to list code of available sample aliquot from the aliquot id **
		$criteria = array();
		$criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
		$criteria['AliquotMaster.collection_id'] = $collection_id;
				 
		$arr_aliquot_barcode_from_id = 
			$this->AliquotMaster->generateList(
				$criteria, 
				null, 
				null, 
				'{n}.AliquotMaster.id', 
				'{n}.AliquotMaster.barcode');				
		
		if(!empty($arr_aliquot_barcode_from_id)) {
			$arr_aliquot_barcode_from_id['0'] = 'n/a';
		} else {
			$arr_aliquot_barcode_from_id = array('0' => 'n/a');
		}
		
		$this->set('arr_aliquot_barcode_from_id', $arr_aliquot_barcode_from_id);			

		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}	
				
		if (empty($this->data)) {
			// ** EDIT DATA **

			$this->data = $sample_qc_data; 
			$this->set('data', $this->data);
			 
		} else {
			
			// ** SAVE DATA **
						
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('quality_controls') as $validate_model=>$validate_rules) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			$submitted_data_validates = true;
			
			// Validates Fields of Master Table
			if(!$this->QualityControl->validates($this->data['QualityControl'])){
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'] . '_' . $this->params['action'] . '_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			if ($submitted_data_validates) {

				// Save Data
							
				$bool_save_done = true;
				
				if(!$this->QualityControl->save($this->data['QualityControl'])){
					$bool_save_done = false;
				}
				
				if(!$bool_save_done){
					$this->redirect('/pages/err_inv_qc_record_err'); 
					exit;
				} else {
					// Data has been recorded
					
					// update tested aliquots use data
					$old_run_id = $sample_qc_data['QualityControl']['run_id'];
					$new_run_id = $this->data['QualityControl']['run_id'];
					$old_run_date = $sample_qc_data['QualityControl']['date'];
					$new_run_date = $this->data['QualityControl']['date'];
					if((strcmp($old_run_id,$new_run_id)!=0) ||
					(strcmp($old_run_date,$new_run_date)!=0)) {
						$this->updateTestedAliquotUses($quality_control_id, $new_run_id, $new_run_date);
					}
					
					$this->flash('Your data has been updated . ', 
						"/quality_controls/detail/$specimen_group_menu_id/$group_specimen_type/$sample_category/" .
						"$collection_id/$sample_master_id/$quality_control_id/");				
				}
				
			}
			
		}
		
	}	// End function Edit
	
	/**
	 * Allow to delete data of a sample quality control. 
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category
	 * @param $collection_id Id of the studied collection.
	 * @param $sample_master_id Master ID of the studied sample.
	 * @param $quality_control_id ID of the studied quality control.
	 * 
	 * @author N. Luc
	 * @date 2008-01-28
	 */
	function delete($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null, 
	$collection_id=null, $sample_master_id=null, $quality_control_id = null) {
	
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($sample_category) || 
		empty($group_specimen_type) || empty($collection_id)
		|| empty($sample_master_id) || empty($quality_control_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// Verify collection data exists
		$criteria = 'Collection.id = "' . $collection_id . '" ';		
		$collection_data = $this->Collection->find($criteria);
		
		if(empty($collection_data)) {
			$this->redirect('/pages/err_inv_coll_no_data'); 
			exit;
		}
		
		// ** Get QC data **
		$criteria = array();
		$criteria['QualityControl.id'] = $quality_control_id;
		$criteria['QualityControl.sample_master_id'] = $sample_master_id;
		$criteria = array_filter($criteria);
	
		$sample_qc_data = $this->QualityControl->find($criteria, null, null, 0);
				
		if(empty($sample_qc_data)){
			$this->redirect('/pages/err_inv_qc_no_data'); 
			exit;
		}	
					
		if(strcmp($sample_qc_data['SampleMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		if(!$this->allowQcDeletion($quality_control_id)) {
			$this->redirect('/pages/err_inv_qc_del_err'); 
			exit;
		}
		
		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		// ** Delete QC ** 
		
		//Delete sample Master Data
		if($this->QualityControl->del($quality_control_id)){
			// Data has been deleted
			$this->flash('Your data has been deleted . ', 
				"/quality_controls/listAllQualityControls/$specimen_group_menu_id/" .
				"$group_specimen_type/$sample_category/$collection_id/$sample_master_id/");					
		} else {
			$this->redirect('/pages/err_inv_qc_del_err'); 
			exit;
		}	
		
	}	// End function Delete
	
	function allowQcDeletion($quality_control_id){
		
		// Verify this qc is not linked to tested aliquot
		$criteria = 'QcTestedAliquot.quality_control_id ="' .$quality_control_id . '"';			 
		$qc_tested_aliquot_nbr = $this->QcTestedAliquot->findCount($criteria);
		
		if($qc_tested_aliquot_nbr > 0){
			return false;
		}
		
		return true;
	}
	
	function listTestedAliquots($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null, 
	$collection_id=null, $sample_master_id=null, $quality_control_id=null) {

		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || 
		empty($sample_master_id) || empty($quality_control_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// read SAMPLE MASTER info
		$criteria = 'SampleMaster.id ="' . $sample_master_id . '"';
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
				
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		if(strcmp($sample_master_data['SampleMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('qc_tested_aliquots_list'));
		
		// ** Set DATA for echo on view **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id);
		$this->set('sample_master_id', $sample_master_id);
		$this->set('quality_control_id', $quality_control_id);
		
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_qc';
				$qc_menu_id = $specimen_group_menu_id . '-sa_qc_al';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $qc_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $qc_menu_id, $collection_id . '/' . $specimen_sample_master_id . '/' . $quality_control_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_der';
				$derivative_menu_id = $specimen_group_menu_id . '-der_qc';
				$qc_menu_id = $specimen_group_menu_id . '-der_qc_al';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $qc_menu_id, $derivative_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $qc_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/' . $quality_control_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);	
	
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id));
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_'.
				$this->params['controller'] . '_'.
				$this->params['action']));

		// ** Search aliquot data to display in the list **
			
		// Search aliquots that have been used to realize the sample qc
		
		$criteria = array();
		$criteria['quality_control_id'] = $quality_control_id;

		$use_id_from_tested_aliquot_id = 
			$this->QcTestedAliquot->generateList(
				$criteria, 
				null, 
				null, 
				'{n}.QcTestedAliquot.aliquot_master_id', 
				'{n}.QcTestedAliquot.aliquot_use_id');
										
		// Build array of data to display
		$tested_aliquots = array();
		
		if(!empty($use_id_from_tested_aliquot_id)){
						
			// Search tested aliquot used volumes
			$criteria = array();
			$criteria['AliquotUse.id'] = array_values($use_id_from_tested_aliquot_id);
			
			$use_vol_from_tested_aliquot_id 
				= $this->AliquotUse->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.AliquotUse.aliquot_master_id', 
					'{n}.AliquotUse.used_volume');
			
			if(empty($use_vol_from_tested_aliquot_id) 
			|| (sizeof($use_vol_from_tested_aliquot_id) != sizeof($use_id_from_tested_aliquot_id))){
				// It looks like at least one record defined in TestedAliquot has not
				// its attached data into AliquotUse	
				$this->redirect('/pages/err_inv_system_error'); 
				exit;		
			}				
						
			// Search tested aliquots data
			$criteria = array();
			$criteria['AliquotMaster.id'] = array_keys($use_id_from_tested_aliquot_id);
			$criteria = array_filter($criteria);
			
			//TODO: add pagination
			$tested_aliquots = $this->AliquotMaster->findAll($criteria, null, null, null, null, 0);
			
			// For each tested aliquot, set the used_volume.
			foreach($tested_aliquots as $id_ct => $new_tested_aliquot){
				if(isset($use_vol_from_tested_aliquot_id[$new_tested_aliquot['AliquotMaster']['id']])){
					$tested_aliquots[$id_ct]['AliquotUse']['used_volume'] = 
						$use_vol_from_tested_aliquot_id[$new_tested_aliquot['AliquotMaster']['id']];
				}			
			}
		}			
		
		$this->set('tested_aliquots', $tested_aliquots);
	
		// ** Verify if additional parent sample aliquots could be added to the list of tested aliquots **
		$criteria= 'AliquotMaster.sample_master_id = ' . $sample_master_id;
		$criteria.= ' AND AliquotMaster.status = \'available\'';
		if(!empty($use_id_from_tested_aliquot_id)) {
			// Aliquot have already be defined as tested
			$criteria.= ' AND AliquotMaster.id NOT IN (\''.implode('\',\'', array_keys($use_id_from_tested_aliquot_id)) . '\')';
		}
		
		$av_sample_aliquots = 
			$this->AliquotMaster->findCount($criteria);
			
		$bool_av_sample_aliquots = false;
		
		if($av_sample_aliquots > 0){
			$bool_av_sample_aliquots = true;
		}
										
		$this->set('bool_av_sample_aliquots', $bool_av_sample_aliquots);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

	} // listTestedAliquots
	
	function addTestedAliquotInBatch($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null, 
	$collection_id=null, $sample_master_id=null, $quality_control_id=null) {
			
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($sample_master_id)|| 
		empty($quality_control_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** read SAMPLE MASTER info **
		$criteria = 'SampleMaster.id ="' . $sample_master_id . '"';
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
				
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		if(strcmp($sample_master_data['SampleMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		// ** Get QC data **
		$criteria = array();
		$criteria['QualityControl.id'] = $quality_control_id;
		$criteria['QualityControl.sample_master_id'] = $sample_master_id;
		$criteria = array_filter($criteria);
	
		$sample_qc_data = $this->QualityControl->find($criteria, null, null, 0);
				
		if(empty($sample_qc_data)){
			$this->redirect('/pages/err_inv_qc_no_data'); 
			exit;
		}	
		
		if(strcmp($sample_qc_data['SampleMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}

		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_qc';
				$qc_menu_id = $specimen_group_menu_id . '-sa_qc_al';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $qc_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $qc_menu_id, $collection_id . '/' . $specimen_sample_master_id . '/' . $quality_control_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id . '-sa_der';
				$derivative_menu_id = $specimen_group_menu_id . '-der_qc';
				$qc_menu_id = $specimen_group_menu_id . '-der_qc_al';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id . '/' . $specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $qc_menu_id, $derivative_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $qc_menu_id, $collection_id . '/' . $derivative_sample_master_id . '/' . $quality_control_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
	
		// ** Set SUMMARY varible from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id));
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'] . '_'.
				$this->params['controller'] . '_'.
				$this->params['action']));
		
		// ** Set FORM variable, for HELPER call on VIEW **
		$this->set('ctrapp_form', $this->Forms->getFormArray('qc_tested_aliquots_list'));
		
		// ** Set DATA variable, for echo en view or create link **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);

		$this->set('collection_id', $collection_id);
		$this->set('sample_master_id', $sample_master_id);	
		$this->set('quality_control_id', $quality_control_id);
		
		$this->set('sample_code', $sample_master_data['SampleMaster']['sample_code']);
							
		// ** Search aliquot data to display in the list **
		
		// Search ids of the aliquots that have been already included into the list
		// These aliquots will be excluded from the list
		
		$criteria = array();
		$criteria['quality_control_id'] = $quality_control_id;

		$already_used_aliquot_id = 
			$this->QcTestedAliquot->generateList(
				$criteria, 
				null, 
				null, 
				'{n}.QcTestedAliquot.aliquot_master_id', 
				'{n}.QcTestedAliquot.aliquot_master_id');

		// Search ids of the aliquots that could be used to realize the qc

		$criteria= 'AliquotMaster.sample_master_id = ' . $sample_master_id;
		$criteria.= ' AND AliquotMaster.status = \'available\'';
		
		if(!empty($already_used_aliquot_id)) {
			// Aliquot have already be defined as used
			$criteria.= ' AND AliquotMaster.id NOT IN (\''.implode('\',\'', array_keys($already_used_aliquot_id)) . '\')';
		}
				
		$available_aliquots = $this->AliquotMaster->findAll($criteria, null, null, null, 0);

		if(empty($available_aliquots)){
			$this->redirect('/pages/err_inv_system_error'); 
			exit;
		}
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		if (empty($this->data)) {
			// Edit Data
			$this->data = $available_aliquots;
			$this->set('data', $this->data);	
							
		} else {
			// ** Save data	**

			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('qc_tested_aliquots_list') as $validate_model=>$validate_rules) {
				$this->{$validate_model}->validate = $validate_rules;
			}
			
			// Run validation
			$submitted_data_validates = true;	
			$aliquots_to_define_as_tested = array();
					
			foreach($this->data as $id => $new_studied_aliquot){
				// New aliquot that was displayed in the datgarid
				
				if(strcmp($new_studied_aliquot['FunctionManagement']['use'], 'yes') == 0){
					// This aliquot should be defined as tested aliquot.
					
					// Validates Fields of Aliquot Master Table
					if(!$this->AliquotMaster->validates($new_studied_aliquot['AliquotMaster'])){
						$submitted_data_validates = false;
					}
					
					if(!$this->AliquotUse->validates($new_studied_aliquot['AliquotUse'])){
						$submitted_data_validates = false;
					}
					
					if(empty($new_studied_aliquot['AliquotMaster']['aliquot_volume_unit']) 
					&& (!empty($new_studied_aliquot['AliquotUse']['used_volume']))) {
						// No volume is tracked for this aliquot type
						$this->AliquotMaster->validationErrors[] 
							= 'no volume has to be recorded for this aliquot type';	
						$submitted_data_validates = false;
					}
					if(empty($new_studied_aliquot['AliquotUse']['used_volume'])){
						$new_studied_aliquot['AliquotUse']['used_volume']=null;
					}
			
					if($submitted_data_validates){
						$aliquots_to_define_as_tested[] = $new_studied_aliquot;
					} else {
						break;	
					}			
				}
			} // End foreach to study all datgrid records
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'] . '_' . $this->params['action'] . '_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			if ($submitted_data_validates) {
				
				if(empty($aliquots_to_define_as_tested)){
					// Data have been updated
					$this->Flash('No aliquot has been defined as sample tested aliquot . ', 
						'/quality_controls/listTestedAliquots/'.
							$specimen_group_menu_id . '/' . $group_specimen_type . '/' . $sample_category . '/'.
							$collection_id . '/' . $sample_master_id . '/' . $quality_control_id . '/');	
					exit;					
				}
					
				// Launch Save function
				$bool_save_done = true;
	
				// Parse records to save
				foreach($aliquots_to_define_as_tested as $id_sec => $new_aliquot_to_use){
										
					// Save data of this aliquot
					$aliquot_use_id = null;					
					$tested_aliquot_master_id = $new_aliquot_to_use['AliquotMaster']['id'];

					if(strcmp($new_aliquot_to_use['FunctionManagement']['delete_storage_data'], 'yes') == 0){
						// Delete aliquot storage data
						$new_aliquot_to_use['AliquotMaster']['storage_master_id'] = null;
						$new_aliquot_to_use['AliquotMaster']['storage_coord_x'] = null;
						$new_aliquot_to_use['AliquotMaster']['storage_coord_y'] = null;
					}
					
					// Save ALIQUOT MASTER data
					
					unset($new_aliquot_to_use['AliquotMaster']['created']);
					unset($new_aliquot_to_use['AliquotMaster']['created_by']);
					
					$new_aliquot_to_use['AliquotMaster']['modified'] = date('Y-m-d G:i');
					$new_aliquot_to_use['AliquotMaster']['modified_by'] = $this->othAuth->user('id');
					
					if(!$this->AliquotMaster->save($new_aliquot_to_use['AliquotMaster'])){
						$bool_save_done = false;
					} else {
						// Save ALIQUOT USE data
						
						// Add additional data
						$new_aliquot_to_use['AliquotUse']['aliquot_master_id'] = $tested_aliquot_master_id;
						
						$new_aliquot_to_use['AliquotUse']['use_definition'] = 'quality control';
						$new_aliquot_to_use['AliquotUse']['use_details'] = $sample_qc_data['QualityControl']['run_id'];
						$new_aliquot_to_use['AliquotUse']['use_datetime'] = $sample_qc_data['QualityControl']['date'];
						$new_aliquot_to_use['AliquotUse']['use_recorded_into_table'] = 'qc_tested_aliquots';

						$new_aliquot_to_use['AliquotUse']['created'] = date('Y-m-d G:i');
						$new_aliquot_to_use['AliquotUse']['created_by'] = $this->othAuth->user('id');
						$new_aliquot_to_use['AliquotUse']['modified'] = date('Y-m-d G:i');
						$new_aliquot_to_use['AliquotUse']['modified_by'] = $this->othAuth->user('id');
						
						if(is_null($new_aliquot_to_use['AliquotMaster']['aliquot_volume_unit'])){
							// No volume should be recorded: Set used volume to null
							$new_aliquot_to_use['AliquotUse']['used_volume'] = null;
						}					
	
						if(!$this->AliquotUse->save($new_aliquot_to_use['AliquotUse'])){
							$bool_save_done = false;
							
						} else {
							$aliquot_use_id = $this->AliquotUse->getLastInsertId();

							// Set data for qc_tested_aliquots table
							$qc_aliquot_data = array();
							$qc_aliquot_data['QcTestedAliquot']['id'] = null;
							$qc_aliquot_data['QcTestedAliquot']['aliquot_master_id'] = $tested_aliquot_master_id;
							$qc_aliquot_data['QcTestedAliquot']['quality_control_id'] = $quality_control_id;
							$qc_aliquot_data['QcTestedAliquot']['aliquot_use_id'] = $aliquot_use_id;
							
							$qc_aliquot_data['QcTestedAliquot']['created'] = date('Y-m-d G:i');
							$qc_aliquot_data['QcTestedAliquot']['created_by'] = $this->othAuth->user('id');
							$qc_aliquot_data['QcTestedAliquot']['modified'] = date('Y-m-d G:i');
							$qc_aliquot_data['QcTestedAliquot']['modified_by'] = $this->othAuth->user('id');
													
							if(!$this->QcTestedAliquot->save($qc_aliquot_data)){
								$bool_save_done = false;
							} else {
								// Update current volume of the tested aliquot
								$this->updateAliquotCurrentVolume($tested_aliquot_master_id);
							}
						}					
					} // End Save one tested aliquot
					
					
					if(!$bool_save_done){
						break;
					}
					
				} // End foreach to save all tested aliquots

				if(!$bool_save_done){
					$this->redirect('/pages/err_inv_aliquot_use_record_err'); 
					exit;
				} else {
					// Data have been updated
					$this->Flash('Your aliquots have been defined as tested aliquot . ', 
						'/quality_controls/listTestedAliquots/'.
							$specimen_group_menu_id . '/' . $group_specimen_type . '/' . $sample_category . '/'.
							$collection_id . '/' . $sample_master_id . '/' . $quality_control_id . '/');
					
				} 
			} // End Save Functions execution	
			
		} // End Save Section (validation + save)
	} 

	function deleteTestedAliquot($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null, 
	$collection_id=null, $sample_master_id=null, $quality_control_id=null, $tested_aliquot_master_id = null) {
			
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || 
		empty($sample_master_id) || empty($tested_aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// * Verify that this record match a tested aliquot defintion **
		
		// Check in TestedAliquot
		$criteria = array();		
		$criteria['QcTestedAliquot.aliquot_master_id'] = $tested_aliquot_master_id;
		$criteria['QcTestedAliquot.quality_control_id'] = $quality_control_id;
				
		$tested_aliquot_record = $this->QcTestedAliquot->find($criteria, null, null, 0);
		
		if(empty($tested_aliquot_record)){
			$this->redirect('/pages/err_inv_system_error'); 
			exit;	
		}
			
		// Check in AliquotUse
		$aliquot_use_id = $tested_aliquot_record['QcTestedAliquot']['aliquot_use_id'];
		
		$criteria = array();		
		$criteria['AliquotUse.id'] = $aliquot_use_id;
		$criteria['AliquotUse.aliquot_master_id'] = $tested_aliquot_master_id;
				
		$aliquot_use_record = $this->AliquotUse->find($criteria, null, null, 0);
		
		if(empty($aliquot_use_record)){
			$this->redirect('/pages/err_inv_system_error'); 
			exit;		
		}	

		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'] . '_' . $this->params['action'] . '_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		// ** Delete Record **
		$bool_delete_tesed_aliquot = true;
	
		if(!$this->QcTestedAliquot->del($tested_aliquot_record['QcTestedAliquot']['id'])){
			$bool_delete_tesed_aliquot = false;		
		}	
		
		if($bool_delete_tesed_aliquot){
			if(!$this->AliquotUse->del($aliquot_use_id)){
				$bool_delete_tesed_aliquot = false;		
			}			
		}
		
		if(!$bool_delete_tesed_aliquot){
			$this->redirect('/pages/err_inv_aliqu_use_del_err'); 
			exit;
		}
		
		$this->flash('Your aliquot has been deleted from the list of Tested Aliquot . ', 
			'/quality_controls/listTestedAliquots/'.
			$specimen_group_menu_id . '/' . $group_specimen_type . '/' . $sample_category . '/'.
			$collection_id . '/' . $sample_master_id . '/' . $quality_control_id . '/');
					
	} // End function deleteTestedAliquot
	
	function updateTestedAliquotUses($quality_control_id, $use_details, $use_date) {
		
		$this->QcTestedAliquot->bindModel(array('belongsTo' => 
			array('AliquotUse' => array(
					'className' => 'AliquotUse',
					'conditions' => '',
					'order'      => '',
					'foreignKey' => 'aliquot_use_id'))));
		
		$criteria = array();
		$criteria['QcTestedAliquot.quality_control_id'] = $quality_control_id;
		$criteria = array_filter($criteria);
		
		$aliquot_uses = $this->QcTestedAliquot->findAll($criteria, null, null, null, 1);
		
		if(!empty($aliquot_uses)) {
			foreach($aliquot_uses as $tmp => $tested_aliquot_use_data) {
				$this->updateAliquotUseDetailAndDate($tested_aliquot_use_data['AliquotUse']['id'], 
					$tested_aliquot_use_data['AliquotUse']['aliquot_master_id'], 
					$use_details, 
					$use_date);
			}
		}	
	
	}
	
}

?>
