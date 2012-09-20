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
				$this->data['SpecimenDetail']['sample_master_id'] = $sample_master_id;
				if(!$this->SpecimenDetail->save($this->data['SpecimenDetail'], false)) { 
					$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
			} else {
			// DerivativeDetail
				$this->data['DerivativeDetail']['sample_master_id'] = $sample_master_id;
				if(!$this->DerivativeDetail->save($this->data['DerivativeDetail'], false)) { 
					$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
			}						
					
			$hook_link = $this->hook('postsave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
					
			if($this->RequestHandler->isAjax()){
				echo json_encode(array('goToNext' => true, 'display' => '', 'id' => $sample_master_id));
				exit;
			}else{
				$this->atimFlash('your data has been saved', '/inventorymanagement/sample_masters/detail/' . $collection_id . '/' . $sample_master_id);
			}	
		}				
	}		
	$submitted_data_validates = false;
?>