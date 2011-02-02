<?php

class QualityCtrlsController extends InventoryManagementAppController {
	
	var $components = array();
	
	var $uses = array(
		'Inventorymanagement.Collection',
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.AliquotMaster',
		'Inventorymanagement.AliquotUse',
		'Inventorymanagement.QualityCtrl',
		'Inventorymanagement.QualityCtrlTestedAliquot'
	);
	
	var $paginate = array('QualityCtrl' => array('limit' => pagination_amount, 'order' => 'QualityCtrl.date ASC'));
	
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
					if((!empty($new_studied_aliquot['QualityCtrlTestedAliquot']['used_volume'])) && empty($new_studied_aliquot['AliquotMaster']['aliquot_volume_unit'])) {
						// No volume has to be recored for this aliquot type				
						$errors['QualityCtrlTestedAliquot']['used_volume']['no volume has to be recorded for this aliquot type'] = '-'; 
						$new_studied_aliquot['QualityCtrlTestedAliquot']['used_volume'] = '#err#';
						$submitted_data_validates = false;			
					} else if(empty($new_studied_aliquot['QualityCtrlTestedAliquot']['used_volume'])) {
						// Change '0' to null
						$new_studied_aliquot['QualityCtrlTestedAliquot']['used_volume'] = null;
					}
					
					// Launch Aliquot Master validation
					$this->AliquotMaster->set($new_studied_aliquot);
					$this->AliquotMaster->id = $new_studied_aliquot['AliquotMaster']['id'];
					$submitted_data_validates = ($this->AliquotMaster->validates())? $submitted_data_validates: false;
					foreach($this->AliquotMaster->invalidFields() as $field => $error) { $errors['AliquotMaster'][$field][$error] = '-'; }					
					
					// Launch Aliquot Use validation
					$this->QualityCtrlTestedAliquot->set($new_studied_aliquot);
					$submitted_data_validates = ($this->QualityCtrlTestedAliquot->validates())? $submitted_data_validates: false;
					foreach($this->QualityCtrlTestedAliquot->invalidFields() as $field => $error) { $errors['QualityCtrlTestedAliquot'][$field][$error] = '-'; }					
					
					// Add record to array of tested aliquots
					$aliquots_defined_as_tested[] = $new_studied_aliquot;		
				}
				
				// Reset data
				$this->data[$key] = $new_studied_aliquot;
			}
			
			if(empty($aliquots_defined_as_tested)) { 
				$this->QualityCtrlTestedAliquot->validationErrors[] = 'no aliquot has been defined as sample tested aliquot';	
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
						$new_used_aliquot['AliquotMaster']['storage_master_id'] = null;
						$new_used_aliquot['AliquotMaster']['storage_coord_x'] = null;
						$new_used_aliquot['AliquotMaster']['storage_coord_y'] = null;	
					}
									
					// Save data:
					// - AliquotMaster
					$this->AliquotMaster->id = $aliquot_master_id;
					if(!$this->AliquotMaster->save($new_used_aliquot, false)) { $this->redirect('/pages/err_inv_record_err?line='.__LINE__, null, true); }
					
					// - QualityCtrlTestedAliquot
					$this->QualityCtrlTestedAliquot->id = null;
					$new_used_aliquot['QualityCtrlTestedAliquot']['aliquot_master_id'] = $aliquot_master_id;	
					$new_used_aliquot['QualityCtrlTestedAliquot']['quality_ctrl_id'] = $quality_ctrl_id;	
					if(!$this->QualityCtrlTestedAliquot->save($new_used_aliquot, false)) { $this->redirect('/pages/err_inv_record_err?line='.__LINE__, null, true); }

					// - Update aliquot current volume
					if(!$this->AliquotMaster->updateAliquotCurrentVolume($aliquot_master_id)) { $this->redirect('/pages/err_inv_record_err?line='.__LINE__, null, true); }
				}
				$this->atimFlash(__('your data has been saved',true).'<br>'.__('aliquot storage data were deleted (if required)',true), 
					'/inventorymanagement/quality_ctrls/detail/' . $collection_id . '/' . $sample_master_id . '/' . $quality_ctrl_id . '/'); 
			}
		}
	}
	
	function deleteTestedAliquot($quality_ctrl_id, $aliquot_master_id, $source) {
		if((!$quality_ctrl_id) || (!$aliquot_master_id) || (!$source)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }	

 		// MANAGE DATA
		
		// Get the realiquoting data
		
		$tested_aliquot_data = $this->QualityCtrlTestedAliquot->find('first', array('conditions' => array('QualityCtrlTestedAliquot.quality_ctrl_id' => $quality_ctrl_id, 'QualityCtrlTestedAliquot.aliquot_master_id' => $aliquot_master_id)));
		if(empty($tested_aliquot_data)) { $this->redirect('/pages/err_inv_no_data?line='.__LINE__, null, true); }				
	
		$flash_url = '';
		switch($source) {
			case 'aliquot_details':
				$flash_url = '/inventorymanagement/aliquot_masters/detail/' . $tested_aliquot_data['AliquotMaster']['collection_id'] . '/' . $tested_aliquot_data['AliquotMaster']['sample_master_id'] . '/' . $tested_aliquot_data['AliquotMaster']['id'];
				break;
			case 'quality_controls_details':
				$flash_url = '/inventorymanagement/quality_ctrls/detail/' . $tested_aliquot_data['AliquotMaster']['collection_id'] . '/' . $tested_aliquot_data['AliquotMaster']['sample_master_id'] . '/' . $tested_aliquot_data['QualityCtrl']['id'];
				break;
			default:
				$this->redirect('/pages/err_inv_system_error?line='.__LINE__, null, true);
		}		
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
			
		// LAUNCH DELETION
		$deletion_done = true;
		
		// -> Delete Realiquoting
		if(!$this->QualityCtrlTestedAliquot->atim_delete($tested_aliquot_data['QualityCtrlTestedAliquot']['id'])) { $deletion_done = false; }	
		
		// -> Update volume
		if($deletion_done) {
			if(!$this->AliquotMaster->updateAliquotCurrentVolume($tested_aliquot_data['AliquotMaster']['id'])) { $deletion_done = false; }
		}
		
		if($deletion_done) {
			$this->atimFlash('your data has been deleted - update the aliquot in stock data', $flash_url); 
		} else {
			$this->flash('error deleting data - contact administrator', $flash_url); 
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
