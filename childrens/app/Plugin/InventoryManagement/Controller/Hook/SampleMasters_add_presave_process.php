<?php
	// Custom hook to override setting of sample code to primary key ID.
	// Bank enters sample code manually
	
	if($submitted_data_validates) {
	// Save sample data
		$sample_master_id = null;
		if($this->SampleMaster->save($this->data, false)) {
			$sample_master_id = $this->SampleMaster->getLastInsertId();
		
			// Save either specimen or derivative detail
			if($is_specimen) {
			// SpecimenDetail
				$this->request->data['SpecimenDetail']['sample_master_id'] = $sample_master_id;
				$this->SpecimenDetail->id = $sample_master_id;

				if(!$this->SpecimenDetail->save($this->request->data['SpecimenDetail'], false)) { 
					$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
			} else {
			// DerivativeDetail
				$this->request->data['DerivativeDetail']['sample_master_id'] = $sample_master_id;
				$this->DerivativeDetail->id = $sample_master_id;
				if(!$this->DerivativeDetail->save($this->request->data['DerivativeDetail'], false)) { 
					$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
			}						
					
			$hook_link = $this->hook('postsave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
					
			if($this->request->is('ajax')){
				echo json_encode(array('goToNext' => true, 'display' => '', 'id' => $sample_master_id));
				exit;
			}else{
				$this->atimFlash('your data has been saved', '/InventoryManagement/SampleMasters/detail/' . $collection_id . '/' . $sample_master_id);
			}	
		}				
	}		
	$submitted_data_validates = false;
?>