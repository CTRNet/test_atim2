<?php
class BcTtrBatchEntryController extends InventorymanagementAppController{
	
	var $uses = array(
		'Inventorymanagement.BcTtrBePlasma',
		'Inventorymanagement.BcTtrBeBloodCell',
		'Inventorymanagement.BcTtrBeWhatman',
	
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.AliquotMaster',
		'Inventorymanagement.DerivativeDetail'
		
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
		$this->Structures->set('bc_ttr_be_plasma', 'bc_ttr_be_plasma');
		$this->Structures->set('bc_ttr_be_blood_cells', 'bc_ttr_be_blood_cells');
		$this->Structures->set('bc_ttr_be_whatman', 'bc_ttr_be_whatman');

		if(!empty($this->data)){
			$models = array("BcTtrBePlasma", "BcTtrBeBloodCell", "BcTtrBeWhatman");
			$validated = true;
			foreach($models as $model){
				$this->{$model}->set($this->data);
				if(!$this->{$model}->validates()){
					$validated = false;
				}
			}
			
			//TODO manual validation for storages
			
			if($validated){
				//win, create the whole shebang with transactions
				$data_sources = array();
				$models = array("SampleMaster", "AliquotMaster");
				foreach($models as $model){
					//init transactions
					$tmp_data_source = $this->{$model}->getDataSource();
					$tmp_data_source->begin($this->{$model});
					$data_sources[$model] = $tmp_data_source;
				}
				
				$continue = true;
				
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
						$aliquot_data = array("AliquotMaster" => array(
							"collection_id"			=> $collection_id,
							"sample_master_id"		=> $this->SampleMaster->getLastInsertId(),
							"aliquot_type"			=> "tube",
							"aliquot_control_id"	=> "8",
							"initial_volume"		=> $plasma_be_data['volume'],
							"aliquot_volume_unit"	=> "ml",
							"in_stock"				=> "yes - available",
							"storage_datetime"		=> $plasma_be_data['stored_datetime'],
							"storage_master_id"		=> "",//TODO
							"storage_coord_x"		=> "",
							"storage_coord_y"		=> ""
						));
						for($i = $plasma_be_data['batch_count'] - 1; $i >= 0; -- $i){
							//TODO: set aliquot position
							$this->AliquotMaster->set($aliquot_data);
							$this->AliquotMaster->id = null;
							if(!$this->AliquotMaster->save()){
								$continue = false;
								break;
							}
						}
					}
				}
				
				if($continue){
					//blood cells
					$blood_cell_be_data = $this->data['BcTtrBeBloodCell'];
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
						$this->SampleMaster->set($blood_cell_data);
						$this->SampleMaster->id = null;
						if(!$this->SampleMaster->save()){
							$continue = false;
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
							$aliquot_data = array("AliquotMaster" => array(
								"collection_id"			=> $collection_id,
								"sample_master_id"		=> $this->SampleMaster->getLastInsertId(),
								"aliquot_type"			=> "tube",
								"aliquot_control_id"	=> "15",
								"initial_volume"		=> $blood_cell_be_data['volume'],
								"aliquot_volume_unit"	=> "ml",
								"in_stock"				=> "yes - available",
								"storage_datetime"		=> $blood_cell_be_data['datetime_stored'],
								"storage_master_id"		=> "",//TODO
								"storage_coord_x"		=> "",
								"storage_coord_y"		=> ""
							));
							for($i = $blood_cell_be_data['batch_count'] - 1; $i >= 0; -- $i){
								//TODO: set aliquot position
								$this->AliquotMaster->set($aliquot_data);
								$this->AliquotMaster->id = null;
								if(!$this->AliquotMaster->save()){
									$continue = false;
									break;
								}
							}
						}
					}
				}
					
				if($continue){
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
						for($i = $whatman_be_data['batch_count'] - 1; $i >= 0; -- $i){
							$this->AliquotMaster->set($aliquot_data);
							$this->AliquotMaster->id = null;
							if(!$this->AliquotMaster->save()){
								$continue = false;
								break;
							}
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
					$this->redirect('/pages/err_inv_system_error', null, true);
				}
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
			$models = array("BcTtrBeBlock", "AliquotMaster", "BcTtrBeWhatman");
			$validated = true;
			foreach($models as $model){
				$this->{$model}->set($this->data);
				if(!$this->{$model}->validates()){
					$validated = false;
				}
			}
			
			//TODO manual validation for storages
			
			if($validated){
				//win, create the whole shebang with transactions
				$data_sources = array();
				$models = array("SampleMaster", "AliquotMaster");
				foreach($models as $model){
					//init transactions
					$tmp_data_source = $this->{$model}->getDataSource();
					$tmp_data_source->begin($this->{$model});
					$data_sources[$model] = $tmp_data_source;
				}
				
				$continue = true;
				$block_be_data = $this->data['bc_ttr_be_block'];
				if($block_be_data['batch_count'] > 0){
					for($i = $block_be_data['batch_count'] - 1; $i >= 0; -- $i){
						$block_data = array(
							"AliquotMaster" => array(
								"collection_id"			=> $collection_id,
								"sample_master_id"		=> $sample_id,
								"aliquot_type"			=> "block",
								"aliquot_control_id"	=> "4",
								"in_stock"				=> "yes - available",
								"storage_datetime"		=> $block_be_data['storage_datetime'],
						), "AliquotDetail"	=> array(
								"block_type"				=> $block_be_data['block_type'],
								"bc_ttr_tissue_type"		=> $block_be_data['tissue_type'],
								"bc_ttr_tissue_site"		=> $block_be_data['tissue_site'],
								"bc_ttr_tissue_subsite"		=> $block_be_data['tissue_subsite'],
								"bc_ttr_tissue_observation"	=> $block_be_data['tissue_observation'],
								"bc_ttr_size_of_tumour"		=> $block_be_data['size_of_tumour'],
								"bc_ttr_time_of_removal"	=> $block_be_data['time_of_removal'],
								
						));
					}
				}
				
				if($continue){
					//done, commit them all
					foreach($data_sources as $model => $data_source){
						$data_source->commit($this->{$model});
					}
					$this->atimFlash('your data has been saved', '/inventorymanagement/sample_masters/contentTreeView/'.$collection_id.'/');
				}else{
					$this->redirect('/pages/err_inv_system_error', null, true);
				}
			}
		}
	}
}