<?php
class BcTtrBatchEntryController extends InventorymanagementAppController{
	
	var $uses = array(
		'Inventorymanagement.BcTtrBePlasma',
		'Inventorymanagement.BcTtrBeBloodCell',
		'Inventorymanagement.BcTtrBeWhatman',
	
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.AliquotMaster',
		'Inventorymanagement.DerivativeDetail',
		'Inventorymanagement.AliquotUse',
		'Inventorymanagement.Realiquoting',
	
		'Storagelayout.StorageMaster'
	);

	
	function blood($sample_id){
		$current_sample = $this->SampleMaster->findById($sample_id);
		if(empty($current_sample)){
			$this->redirect('/pages/err_inv_system_error', null, true);
		}
		$collection_id = $current_sample['SampleMaster']['collection_id'];
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_id));
		$this->set('Collection_id', $collection_id);
		$this->set('SampleMaster.id', $sample_id);
		$this->set('sample_id', $sample_id);
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/sample_masters/detail/'));
		$this->Structures->set('BcTtrBePlasma', 'bc_ttr_be_plasma');
		$this->Structures->set('BcTtrBloodCell', 'bc_ttr_be_blood_cells');
		$this->Structures->set('BcTtrBeWhatman', 'bc_ttr_be_whatman');

		if(!empty($this->data)){
			$errors = array();
			$continue = true;
			
			//storages
			$plasma_storage = $this->StorageMaster->validateAndGetStorageData($this->data['BcTtrBePlasma']['box'], null, null, false);
			$bc_storage = $this->StorageMaster->validateAndGetStorageData($this->data['BcTtrBloodCell']['box'], null, null, false);
			if(strlen($plasma_storage['storage_definition_error'])){
				$errors['box'] = __('invalid storage', true);
				$continue = false;
			}else if(strlen($bc_storage['storage_definition_error'])){
				$errors['box'] = __('invalid storage', true);
				$continue = false;
			}
			
			
			//win, create the whole shebang with transactions
			$data_sources = array();
			$models = array("SampleMaster", "AliquotMaster");
			foreach($models as $model){
				//init transactions
				$tmp_data_source = $this->{$model}->getDataSource();
				$tmp_data_source->begin($this->{$model});
				$data_sources[$model] = $tmp_data_source;
			}
			
			
			
			//plasmas
			$plasma_be_data = $this->data['BcTtrBePlasma'];
			if($plasma_be_data['batch_count'] > 0){
				$plasma_data = array(
					"SampleMaster" => array(
						"sample_control_id" 			=> 9,
						"collection_id"					=> $collection_id,
						"parent_id"						=> $sample_id,
						"initial_specimen_sample_id"	=> $sample_id,
						"initial_specimen_sample_type"	=> "blood",
						"sample_type"					=> "plasma",
						"sample_category"				=> "derivative"
					)
				);
				$this->SampleMaster->set($plasma_data);
				$this->SampleMaster->id = null;
				if(!$this->SampleMaster->save()){
					$continue = false;
					$errors = array_merge($errors, $this->SampleMaster->validationErrors);
				}
				if($continue){
					$plasma_data["SampleMaster"]["sample_code"] = "PLS - ".$this->SampleMaster->getLastInsertId();
					$this->SampleMaster->set($plasma_data);
					if(!$this->SampleMaster->save()){
						$continue = false;
					}
				}
				
				if($continue){
					$this->DerivativeDetail->id = null;
					$this->DerivativeDetail->set(array(
						"DerivativeDetail" => array(
							"sample_master_id" => $this->SampleMaster->getLastInsertId()
						)
					));
					if(!$this->DerivativeDetail->save()){
						$continue = false;
					}
				}
				
				if($continue){
					$aliquot_data = array(
						"AliquotMaster" => array(
							"collection_id"			=> $collection_id,
							"sample_master_id"		=> $this->SampleMaster->getLastInsertId(),
							"aliquot_type"			=> "tube",
							"aliquot_control_id"	=> "8",
							"initial_volume"		=> $plasma_be_data['volume'],
							"aliquot_volume_unit"	=> "ml",
							"in_stock"				=> "yes - available",
							"storage_datetime"		=> $plasma_be_data['stored_datetime'],
							"storage_master_id"		=> $plasma_storage['storage_data']['StorageMaster']['id'],
							"storage_coord_x"		=> "",
							"storage_coord_y"		=> ""
						),
						"FunctionManagement" => array("recorded_storage_selection_label" => $this->data['BcTtrBePlasma']['box'])
					);
					for($i = (int)$plasma_be_data['batch_count'] - 1; $i >= 0; -- $i){
						$pos = $this->StorageMaster->incrementPosition($plasma_storage['storage_data'], $plasma_be_data['starting_x'], $plasma_be_data['starting_y'], $i);
						if(!$pos){
							$errors["box"] = "invalid storage position for blood plasma tubes";
							$continue = false;
							break;
						}
						$aliquot_data["AliquotMaster"]["storage_coord_x"] = $pos['x'];
						$aliquot_data["AliquotMaster"]["storage_coord_y"] = $pos['y'];
						$this->AliquotMaster->set($aliquot_data);
						$this->AliquotMaster->id = null;
						if(!$this->AliquotMaster->save()){
							$continue = false;
							break;
						}
					}
				}
			}
			
			//blood cells
			$blood_cell_be_data = $this->data['BcTtrBloodCell'];
			if($blood_cell_be_data['batch_count'] > 0){
				$blood_cell_data = array(
					"SampleMaster" => array(
						"sample_control_id" 			=> 7,
						"collection_id"					=> $collection_id,
						"parent_id"						=> $sample_id,
						"initial_specimen_sample_id"	=> $sample_id,
						"initial_specimen_sample_type"	=> "blood",
						"sample_type"					=> "blood cell",
						"sample_category"				=> "derivative"
					)
				);
				
				$aliquot_data["AliquotMaster"]["storage_coord_x"] = $pos['x'];
				$aliquot_data["AliquotMaster"]["storage_coord_y"] = $pos['y'];
				$this->SampleMaster->set($blood_cell_data);
				$this->SampleMaster->id = null;
				if(!$this->SampleMaster->save()){
					$continue = false;
					$errors = array_merge($errors, $this->SampleMaster->validationErrors);
				}
				if($continue){
					$blood_cell_data["SampleMaster"]["sample_code"] = "BLD-C - ".$this->SampleMaster->getLastInsertId();
					$this->SampleMaster->set($blood_cell_data);
					if(!$this->SampleMaster->save()){
						$continue = false;
					}
				}
				
				if($continue){
					$this->DerivativeDetail->id = null;
					$this->DerivativeDetail->set(array(
						"DerivativeDetail" => array(
							"sample_master_id" => $this->SampleMaster->getLastInsertId()
						)
					));
					if(!$this->DerivativeDetail->save()){
						$continue = false;
					}
				}
				
				if($continue){
					$aliquot_data = array(
						"AliquotMaster" => array(
							"collection_id"			=> $collection_id,
							"sample_master_id"		=> $this->SampleMaster->getLastInsertId(),
							"aliquot_type"			=> "tube",
							"aliquot_control_id"	=> "15",
							"initial_volume"		=> $blood_cell_be_data['volume'],
							"aliquot_volume_unit"	=> "ml",
							"in_stock"				=> "yes - available",
							"storage_datetime"		=> $blood_cell_be_data['datetime_stored'],
							"storage_coord_x"		=> "",
							"storage_coord_y"		=> ""
						),
						"FunctionManagement" => array("recorded_storage_selection_label" => $this->data['BcTtrBloodCell']['box'])
					);
					for($i = (int)$blood_cell_be_data['batch_count'] - 1; $i >= 0; -- $i){
						$pos = $this->StorageMaster->incrementPosition($bc_storage['storage_data'], $blood_cell_be_data['starting_x'], $blood_cell_be_data['starting_y'], $i);
						if(!$pos){
							$errors["box"] = "invalid storage position for blood cell tubes";
							$continue = false;
							break;
						}
						$this->AliquotMaster->set($aliquot_data);
						$this->AliquotMaster->id = null;
						if(!$this->AliquotMaster->save()){
							$continue = false;
							break;
						}
					}
				}
			}
				
			//whatman
			$whatman_be_data = $this->data['BcTtrBeWhatman'];
			if($whatman_be_data['batch_count'] > 0){
				$aliquot_data = array("AliquotMaster" => array(
					"collection_id"			=> $collection_id,
					"sample_master_id"		=> $sample_id,
					"aliquot_type"			=> "whatman paper",
					"aliquot_control_id"	=> "6",
					"in_stock"				=> "yes - available",
					"storage_datetime"		=> $blood_cell_be_data['datetime_stored']
					//TODO lot_nb
					//TODO time created
					//TODO time stored
				));
				for($i = (int)$whatman_be_data['batch_count'] - 1; $i >= 0; -- $i){
					$this->AliquotMaster->set($aliquot_data);
					$this->AliquotMaster->id = null;
					if(!$this->AliquotMaster->save()){
						$continue = false;
						break;
					}
				}
			}
				
			if($continue){
				//done, commit them all
				foreach($data_sources as $model => $data_source){
					$data_source->commit($this->{$model});
				}
				$this->atimFlash('your data has been saved', '/inventorymanagement/sample_masters/contentTreeView/'.$collection_id.'/');
			}else if(count($errors) > 0 || count($this->AliquotMaster->validationErrors) > 0){
				$this->SampleMaster->validationErrors = $errors;
			}else{
				$this->redirect('/pages/err_inv_system_error', null, true);
			}
		}
		
	}
	
	function tissue($sample_id){
		$current_sample = $this->SampleMaster->findById($sample_id);
		if(empty($current_sample)){
			$this->redirect('/pages/err_inv_system_error', null, true);
		}
		$collection_id = $current_sample['SampleMaster']['collection_id'];
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id, 'SampleMaster.id' => $sample_id));
		$this->set('Collection_id', $collection_id);
		$this->set('SampleMaster.id', $sample_id);
		$this->set('sample_id', $sample_id);
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/sample_masters/detail/'));
		$this->Structures->set('bc_ttr_be_block', 'bc_ttr_be_block');
		$this->Structures->set('bc_ttr_be_slides', 'bc_ttr_be_slides');
		
		if(!empty($this->data)){
			//win, create the whole shebang with transactions
			$data_sources = array();
			$models = array("AliquotUse", "AliquotMaster", "Realiquoting");
			foreach($models as $model){
				//init transactions
				$tmp_data_source = $this->{$model}->getDataSource();
				$tmp_data_source->begin($this->{$model});
				$data_sources[$model] = $tmp_data_source;
			}
			
			$continue = true;
			$errors = array();
			$errorrs = array();
			$block_be_data = $this->data['block'];
			if($block_be_data['AliquotMaster']['batch_count'] > 0){
				
				$block_data = array(
					"AliquotMaster" => array(
						"collection_id"			=> $collection_id,
						"sample_master_id"		=> $sample_id,
						"aliquot_type"			=> "block",
						"aliquot_control_id"	=> "4",
						"in_stock"				=> "yes - available",
						"storage_datetime"		=> $block_be_data['AliquotMaster']['storage_datetime'],
				), "AliquotDetail"	=> $block_be_data['AliquotDetail']
				);
				$this->AliquotMaster->set($block_data);
				if(!$this->AliquotMaster->validates()){
					$errors = array_merge($errors, $this->AliquotMaster->validationErrors); 
					$continue = false;
				}
				
				$slide_data = array(
					"AliquotMaster" => array(
						"collection_id"			=> $collection_id,
						"sample_master_id"		=> $sample_id,
						"aliquot_type"			=> "slide",
						"aliquot_control_id"	=> "5",
						"in_stock"				=> "yes - available",
					),
					"AliquotDetail" => $this->data['slide']['AliquotDetail']
				);
				unset($slide_data['AliquotDetail']['bc_ttr_date_created']);
				$this->AliquotMaster->set($slide_data);
				if(!$this->AliquotMaster->validates()){
					$continue = false;
					$errors = array_merge($errors, $this->AliquotMaster->validationErrors);
				}
				
				$storage_data = $this->StorageMaster->validateAndGetStorageData($block_be_data['FunctionManagement']['recorded_storage_selection_label'], null, null, false);
				if(strlen($storage_data['storage_definition_error'])){
					$errors = array_merge($errors, array('recorded_storage_selection_label' => __('invalid storage', true)));
					$continue = false;
				}
				
				if($continue){
					for($i = $block_be_data['AliquotMaster']['batch_count'] - 1; $i >= 0; -- $i){
						//create block
						$this->AliquotMaster->id = null;
						$this->AliquotMaster->set($block_data);
						if(!$this->AliquotMaster->save()){
								$continue = false;
								break;
						}
						$block_id = $this->AliquotMaster->getLastInsertId();
						
						//create slide
						$this->AliquotMaster->id = null;
						$this->AliquotMaster->set($slide_data);
						if(!$this->AliquotMaster->save()){
								$continue = false;
								break;
						}
						
						//create use
						$this->AliquotUse->id = null;
						$this->AliquotUse->set(array(
							"AliquotUse"	=> array(
								"aliquot_master_id"			=> $block_id,
								"use_definition"			=> "realiquoted to",
								"use_recorded_into_table"	=> "realiquotings"
						)));
						if(!$this->AliquotUse->save()){
							$continue = false;
							break;
						}
						
						//create realiquoting
						$this->Realiquoting->id = null;
						$this->Realiquoting->set(array(
							"Realiquoting"	=> array(
								"parent_aliquot_master_id"	=> $block_id,
								"child_aliquot_master_id"	=> $this->AliquotMaster->getLastInsertId(),
								"aliquot_use_id"			=> $this->AliquotUse->getLastInsertId()
						)));
						if(!$this->Realiquoting->save()){
							$continue = false;
							break;
						}
					}
				}
				if($continue){
					//done, commit them all
					foreach($data_sources as $model => $data_source){
						$data_source->commit($this->{$model});
					}
					$this->atimFlash('your data has been saved', '/inventorymanagement/sample_masters/contentTreeView/'.$collection_id.'/');
				}else{
					if(count($errors) > 0){
						$this->AliquotMaster->validationErrors = $errors;
					}else{
						$this->redirect('/pages/err_inv_system_error', null, true);
					}
				}
			}

		}
	}
}