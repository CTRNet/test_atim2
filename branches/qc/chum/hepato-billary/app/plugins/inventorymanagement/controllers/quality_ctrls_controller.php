<?php

class QualityCtrlsController extends InventoryManagementAppController {
	
	var $components = array('Inventorymanagement.Aliquots');
	
	var $uses = array(
		'Inventorymanagement.Collection',
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.AliquotMaster',
		'Inventorymanagement.AliquotUse',
		'Inventorymanagement.QualityCtrl',
		'Inventorymanagement.QualityCtrlTestedAliquot'
	);
	
	var $paginate = array('QualityCtrl' => array('limit' => pagination_amount, 'order' => 'QualityCtrl.date ASC'), 'QualityCtrlTestedAliquot' => array('limit' => pagination_amount, 'order' => 'AliquotUse.use_datetime ASC'));
	
	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/* ------------------------------ QUALITY CTRL ------------------------------ */
	
	function listAll($collection_id, $sample_master_id) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA
		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		$this->data = $this->paginate($this->QualityCtrl, array('QualityCtrl.sample_master_id'=>$sample_master_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$sample_id_parameter = ($sample_data['SampleMaster']['sample_category'] == 'specimen')? '%%SampleMaster.initial_specimen_sample_id%%': '%%SampleMaster.id%%';
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/quality_ctrls/listAll/%%Collection.id%%/' . $sample_id_parameter));		

		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $sample_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $sample_master_id,
			'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']) );
			
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
	}
	
	function add($collection_id, $sample_master_id){
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		
		// MANAGE DATA
		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$sample_id_parameter = ($sample_data['SampleMaster']['sample_category'] == 'specimen')? '%%SampleMaster.initial_specimen_sample_id%%': '%%SampleMaster.id%%';
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/quality_ctrls/listAll/%%Collection.id%%/' . $sample_id_parameter));		
		
		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $sample_data['SampleMaster']['collection_id'], 
				'SampleMaster.id' => $sample_master_id,
				'SampleMaster.initial_specimen_sample_id' => $sample_data['SampleMaster']['initial_specimen_sample_id']) 
		);
			
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}	
		
		// MANAGE DATA RECORD
		
		if ( !empty($this->data) ) {
			
			$this->data['QualityCtrl']['sample_master_id'] = $sample_master_id;
			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
				
			if ($submitted_data_validates && $this->QualityCtrl->save( $this->data )) {
				$qc_id = $this->QualityCtrl->getLastInsertId();
				
				// Record additional qc data
				$qc_data_to_update = array();
				$qc_data_to_update['QualityCtrl']['qc_code'] = $this->createQcCode($qc_id, $this->data, $sample_data);
				
				$this->QualityCtrl->id = $qc_id;					
				if(!$this->QualityCtrl->save($qc_data_to_update, false)) { $this->redirect('/pages/err_inv_system_error', null, true); }
				
				$this->atimFlash('your data has been saved', '/inventorymanagement/quality_ctrls/detail/'.$collection_id.'/'.$sample_master_id.'/'.$this->QualityCtrl->id.'/' );
			}
		}
	}
	
	function detail($collection_id, $sample_master_id, $quality_ctrl_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$quality_ctrl_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		

		// MANAGE DATA
		
		// Get Quality Control Data
		$quality_ctrl_data = $this->QualityCtrl->find('first',array('conditions'=>array('QualityCtrl.id'=>$quality_ctrl_id, 'SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id)));
		if(empty($quality_ctrl_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }

		// Set aliquot data
		$this->set('quality_ctrl_data', $quality_ctrl_data);
		$this->data = array();
		
		// Get/Set Tested Aliquots Data
		$this->set('tested_aliquots_data', $this->paginate($this->QualityCtrlTestedAliquot,array('QualityCtrlTestedAliquot.quality_ctrl_id'=>$quality_ctrl_id)));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$sample_id_parameter = ($quality_ctrl_data['SampleMaster']['sample_category'] == 'specimen')? '%%SampleMaster.initial_specimen_sample_id%%': '%%SampleMaster.id%%';
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/quality_ctrls/detail/%%Collection.id%%/' . $sample_id_parameter . '/%%QualityCtrl.id%%'));	
		
		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $quality_ctrl_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $quality_ctrl_data['QualityCtrl']['sample_master_id'],
			'SampleMaster.initial_specimen_sample_id' => $quality_ctrl_data['SampleMaster']['initial_specimen_sample_id'],
			'QualityCtrl.id' => $quality_ctrl_id) );
					
		$this->Structures->set('qctestedaliquots', 'structure_for_tested_aliquots');
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function edit($collection_id, $sample_master_id, $quality_ctrl_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$quality_ctrl_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		

		// MANAGE DATA
		
		$qc_data = $this->QualityCtrl->find('first',array('conditions'=>array('QualityCtrl.id'=>$quality_ctrl_id, 'SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id)));
		if(empty($qc_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$sample_id_parameter = ($qc_data['SampleMaster']['sample_category'] == 'specimen')? '%%SampleMaster.initial_specimen_sample_id%%': '%%SampleMaster.id%%';
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/quality_ctrls/detail/%%Collection.id%%/' . $sample_id_parameter . '/%%QualityCtrl.id%%'));	
		
		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $qc_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $qc_data['QualityCtrl']['sample_master_id'],
			'SampleMaster.initial_specimen_sample_id' =>  $qc_data['SampleMaster']['initial_specimen_sample_id'],
			'QualityCtrl.id' => $quality_ctrl_id) );

		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
								
		// MANAGE DATA RECORD
			
		if ( empty($this->data) ) {
			$this->data = $qc_data;
						
		} else {
			// Launch save process
			
			// Get aliquot use ids of the tested aliquots
			$aliquot_use_ids = array();
			foreach($qc_data['QualityCtrlTestedAliquot'] as $new_tested_aliquots) { $aliquot_use_ids[] = $new_tested_aliquots['aliquot_use_id']; }
			
			// Launch validation
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			// Save data
			$this->QualityCtrl->id = $quality_ctrl_id;	
			if ($submitted_data_validates && $this->QualityCtrl->save( $this->data )) {
				//TODO Add test to verifiy date and created_by have been modified before to launch update function
				if(!$this->Aliquots->updateAliquotUses($aliquot_use_ids, $this->data['QualityCtrl']['date'], $this->data['QualityCtrl']['run_by'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$this->atimFlash( 'your data has been saved', '/inventorymanagement/quality_ctrls/detail/'.$collection_id.'/'.$sample_master_id.'/'.$quality_ctrl_id.'/' );
			}
		}
	}
	
	function delete($collection_id, $sample_master_id, $quality_ctrl_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$quality_ctrl_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		

		$qc_data = $this->QualityCtrl->find('first',array('conditions'=>array('QualityCtrl.id'=>$quality_ctrl_id, 'SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id)));
		if(empty($qc_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }

		// Check deletion is allowed
		$arr_allow_deletion = $this->allowQcDeletion($quality_ctrl_id);
			
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			if($this->QualityCtrl->atim_delete($quality_ctrl_id)) {
				$this->atimFlash( 'your data has been deleted', 
						'/inventorymanagement/quality_ctrls/listAll/'
						.$qc_data['SampleMaster']['collection_id'].'/'
						.$qc_data['QualityCtrl']['sample_master_id'].'/');
			} else {
				$this->flash('error deleting data - contact administrator', '/inventorymanagement/quality_ctrls/listAll/' . $collection_id . '/' . $sample_master_id);
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/inventorymanagement/quality_ctrls/detail/' . $collection_id . '/' . $sample_master_id . '/' . $quality_ctrl_id);
		}	
	}
	
	/* ------------------------------ TESTED ALIQUOTS ------------------------------ */
	
	function addTestedAliquots($collection_id, $sample_master_id, $quality_ctrl_id) {
		if((!$collection_id) || (!$sample_master_id) || (!$quality_ctrl_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }		

		// MANAGE DATA
		
		$qc_data = $this->QualityCtrl->find('first',array('conditions'=>array('QualityCtrl.id'=>$quality_ctrl_id, 'SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id)));
		if(empty($qc_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }
			
		$already_tested_aliquot_ids = array();
		if(!empty($qc_data['QualityCtrlTestedAliquot'])) {
			foreach($qc_data['QualityCtrlTestedAliquot'] as $tested_aliq) {
				$already_tested_aliquot_ids[] = $tested_aliq['aliquot_master_id'];
			}
		}
			
		$criteria = array(
			'AliquotMaster.collection_id' => $collection_id,
			'AliquotMaster.sample_master_id' => $sample_master_id,
			'NOT' => array('AliquotMaster.id' => $already_tested_aliquot_ids));
		$available_sample_aliquots = $this->AliquotMaster->find('all', array('conditions' => $criteria, 'order' => 'AliquotMaster.barcode ASC', 'recursive' => '-1'));

		if(empty($available_sample_aliquots)) {
			$this->flash('no new sample aliquot could be actually defined as tested aliquot', '/inventorymanagement/quality_ctrls/detail/'. $collection_id . '/' . $sample_master_id . '/' . $quality_ctrl_id);
		}
		
		// Set array to get id from barcode
		$aliquot_id_by_barcode = array();
		foreach($available_sample_aliquots as $aliquot_data){
			$aliquot_id_by_barcode[$aliquot_data['AliquotMaster']['barcode']] = $aliquot_data['AliquotMaster']['id']; 
		}		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$sample_id_parameter = ($qc_data['SampleMaster']['sample_category'] == 'specimen')? '%%SampleMaster.initial_specimen_sample_id%%': '%%SampleMaster.id%%';
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/quality_ctrls/detail/%%Collection.id%%/' . $sample_id_parameter . '/%%QualityCtrl.id%%'));	
		
		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $qc_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $sample_master_id,
			'SampleMaster.initial_specimen_sample_id' => $qc_data['SampleMaster']['initial_specimen_sample_id'],
			'QualityCtrl.id' => $quality_ctrl_id) );

		$this->Structures->set('qctestedaliquots');

		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
					
		// MANAGE DATA RECORD
			
		if (empty($this->data)) {
			$this->data = $available_sample_aliquots;

		} else {
			// Launch validation
			$submitted_data_validates = true;	
			
			$aliquots_defined_as_tested = array();
			$errors = array();
			foreach($this->data as $key => $new_studied_aliquot){
				if($new_studied_aliquot['FunctionManagement']['use']){
					// New aliquot defined as used

					// Check volume
					if((!empty($new_studied_aliquot['AliquotUse']['used_volume'])) && empty($new_studied_aliquot['AliquotMaster']['aliquot_volume_unit'])) {
						// No volume has to be recored for this aliquot type				
						$errors['AliquotUse']['used_volume']['no volume has to be recorded for this aliquot type'] = '-'; 
						$new_studied_aliquot['AliquotUse']['used_volume'] = '#err#';
						$submitted_data_validates = false;			
					} else if(empty($new_studied_aliquot['AliquotUse']['used_volume'])) {
						// Change '0' to null
						$new_studied_aliquot['AliquotUse']['used_volume'] = null;
					}
					
					// Launch Aliquot Master validation
					$this->AliquotMaster->set($new_studied_aliquot);
					$submitted_data_validates = ($this->AliquotMaster->validates())? $submitted_data_validates: false;
					foreach($this->AliquotMaster->invalidFields() as $field => $error) { $errors['AliquotMaster'][$field][$error] = '-'; }					
					
					// Launch Aliquot Use validation
					$this->AliquotUse->set($new_studied_aliquot);
					$submitted_data_validates = ($this->AliquotUse->validates())? $submitted_data_validates: false;
					foreach($this->AliquotUse->invalidFields() as $field => $error) { $errors['AliquotUse'][$field][$error] = '-'; }					
					
					// Get child aliquot master id
					if(!isset($aliquot_id_by_barcode[$new_studied_aliquot['AliquotMaster']['barcode']])) { $this->redirect('/pages/err_inv_system_error', null, true); }
					$new_studied_aliquot['AliquotMaster']['id'] = $aliquot_id_by_barcode[$new_studied_aliquot['AliquotMaster']['barcode']];
					
					// Add record to array of tested aliquots
					$aliquots_defined_as_tested[] = $new_studied_aliquot;		
				}
				
				// Reset data
				$this->data[$key] = $new_studied_aliquot;
			}
			
			if(empty($aliquots_defined_as_tested)) { 
				$this->AliquotUse->validationErrors[] = 'no aliquot has been defined as sample tested aliquot';	
				$submitted_data_validates = false;			
			}
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) {
				require($hook_link);
			}
		
			if (!$submitted_data_validates) {
				// Set error message
				foreach($errors as $model => $field_messages) {
					$this->{$model}->validationErrors = array();
					foreach($field_messages as $field => $messages) {
						foreach($messages as $message => $tmp) {
							if(!array_key_exists($field, $this->{$model}->validationErrors)) {
								$this->{$model}->validationErrors[$field] = $message;
							} else {
								$this->{$model}->validationErrors[] = $message;
							}
						}
					}
				}
				
			} else {
				// Launch save functions
	
				// Parse records to save
				foreach($aliquots_defined_as_tested as $new_used_aliquot) {
					// Get Tested Aliquot Master Id
					$aliquot_master_id = $new_used_aliquot['AliquotMaster']['id'];

					// set aliquot master data					
					if($new_used_aliquot['FunctionManagement']['remove_from_storage'] || ($new_used_aliquot['AliquotMaster']['in_stock'] = 'no')) {
						// Delete aliquot storage data
						$new_used_aliquot['AliquotMaster'] = $this->Aliquots->removeAliquotStorageData($new_used_aliquot['AliquotMaster']);
					}
									
					// Set aliquot use data
					$new_used_aliquot['AliquotUse']['aliquot_master_id'] = $aliquot_master_id;	
					$new_used_aliquot['AliquotUse']['use_definition'] = 'quality control';
					$new_used_aliquot['AliquotUse']['use_code'] = $qc_data['QualityCtrl']['qc_code'];
					$new_used_aliquot['AliquotUse']['use_details'] = $qc_data['QualityCtrl']['run_id'];
					$new_used_aliquot['AliquotUse']['use_datetime'] = $qc_data['QualityCtrl']['date'];
					$new_used_aliquot['AliquotUse']['used_by'] = $qc_data['QualityCtrl']['run_by'];
					$new_used_aliquot['AliquotUse']['use_recorded_into_table'] = 'quality_ctrl_tested_aliquots';					

					// Save data:
					// - AliquotMaster
					$this->AliquotMaster->id = $aliquot_master_id;
					if(!$this->AliquotMaster->save($new_used_aliquot, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
					
					// - AliquotUse
					$this->AliquotUse->id = null;
					if(!$this->AliquotUse->save($new_used_aliquot, false)) { $this->redirect('/pages/err_inv_record_err', null, true); }
					$aliquot_use_id = $this->AliquotUse->getLastInsertId();
					
					// - QualityCtrlTestedAliquot
					$this->QualityCtrlTestedAliquot->id = null;
					$qc_aliquot_data = array( 'QualityCtrlTestedAliquot' => array('aliquot_master_id' => $aliquot_master_id, 'quality_ctrl_id' => $quality_ctrl_id, 'aliquot_use_id' => $aliquot_use_id));
					if(!$this->QualityCtrlTestedAliquot->save($qc_aliquot_data)) { $this->redirect('/pages/err_inv_record_err', null, true); }

					// - Update aliquot current volume
					if(!$this->Aliquots->updateAliquotCurrentVolume($aliquot_master_id)) { $this->redirect('/pages/err_inv_record_err', null, true); }
				}
				$this->atimFlash(__('your data has been saved',true).'<br>'.__('aliquot storage data were deleted (if required)',true), 
					'/inventorymanagement/quality_ctrls/detail/' . $collection_id . '/' . $sample_master_id . '/' . $quality_ctrl_id . '/'); 
			}
		}
	}
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	/**
	 * Check if a quality control can be deleted.
	 * 
	 * @param $quality_ctrl_id Id of the studied quality control.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowQcDeletion($quality_ctrl_id){
		// Check no aliquot has been linked to qc	
		$returned_nbr = $this->QualityCtrlTestedAliquot->find('count', array('conditions' => array('QualityCtrlTestedAliquot.quality_ctrl_id' => $quality_ctrl_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'aliquot has been linked to the deleted qc'); }
		
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Create code of a new quality control. 
	 * 
	 * @param $qc_id ID of the studied quality control.
	 * @param $qc_data Data of the quality control.
	 * @param $sample_data Data of the sample linked to this quality control.
	 * 
	 * @return The new code.
	 * 
	 * @author N. Luc
	 * @since 2008-01-31
	 */
	 
	function createQcCode($qc_id, $storage_data, $qc_data = null, $sample_data = null) {
		$qc_code = 'QC - ' . $qc_id;
		
		return $qc_code;
	}
}
?>
