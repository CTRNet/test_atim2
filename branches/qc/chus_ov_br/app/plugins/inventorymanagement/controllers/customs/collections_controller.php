<?php

class CollectionsControllerCustom extends CollectionsController {
	
	function add($clinical_collection_link_id = 0, $copy_source = 0) {
		if($clinical_collection_link_id > 0){
			$ccl_data = $this->ClinicalCollectionLink->find('first', array('conditions' => array('ClinicalCollectionLink.id' => $clinical_collection_link_id, 'ClinicalCollectionLink.collection_id' => NULL, 'ClinicalCollectionLink.deleted' => 1), 'recursive' => '1'));
		}
		// MANAGE FORM, MENU AND ACTION BUTTONS
	
		if(!empty($ccl_data)){
			$this->Structures->set('linked_collections');
		}
		
		$this->set('atim_variables', array('ClinicalCollectionLink.id' => $clinical_collection_link_id));
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/search'));
		$this->set('copy_source', $copy_source);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$need_to_save = !empty($this->data);
		if(empty($this->data) || isset($this->data['FunctionManagement']['col_copy_binding_opt'])){
			if(!empty($copy_source)){
				if(empty($this->data)){
					$this->data = $this->Collection->redirectIfNonExistent($copy_source, __METHOD__, __LINE__, true);
				}
				if($this->data['Collection']['collection_property'] == 'participant collection'){
					$this->Structures->set('collections,col_copy_binding_opt');
				}
			}
			$this->data['Generated']['field1'] = (!empty($ccl_data))? $ccl_data['Participant']['participant_identifier'] : __('n/a', true);
				
		}
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if($need_to_save){
			
			$copy_src_data = null;
			if($copy_source){
				$copy_src_data = $this->Collection->redirectIfNonExistent($copy_source, __METHOD__, __LINE__, true);
			}
			
			// LAUNCH SAVE PROCESS
			$submitted_data_validates = true;
			
			// HOOK AND VALIDATION
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
				
			if($submitted_data_validates) {

				//SAVE
				$collection_id = null;
				$this->Collection->id = null; 
				if($this->Collection->save($this->data)){
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					
					$collection_id = $this->Collection->getLastInsertId();
					
					// Create clinical collection link
					if(isset($ccl_data) && !empty($ccl_data)){
						$ccl_data['ClinicalCollectionLink']['deleted'] = 0;
						$ccl_data['ClinicalCollectionLink']['collection_id'] = $collection_id;
						if(!$this->ClinicalCollectionLink->save($ccl_data)) {
							$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
					}else{
						$classic_ccl_insert = true;
						$copy_links_option = isset($this->data['FunctionManagement']['col_copy_binding_opt']) ? (int)$this->data['FunctionManagement']['col_copy_binding_opt'] : 0;
						if($copy_source){
							if($copy_links_option > 0 && $this->data['Collection']['collection_property'] == 'independent collection'){
								AppController::addWarningMsg(__('links were not copied since the destination is an independant collection', true));
							}else{
								if($copy_links_option > 1 && $copy_links_option < 6){
									$classic_ccl_insert = false;
									$ccl_array = array(
										'collection_id' 		=> $collection_id, 
										'participant_id' 		=> $copy_src_data['ClinicalCollectionLink']['participant_id'],
										'consent_master_id' 	=> $copy_src_data['ClinicalCollectionLink']['consent_master_id'],
										'diagnosis_master_id'	=> $copy_src_data['ClinicalCollectionLink']['diagnosis_master_id'],
										'misc_identifier_id'	=> $copy_src_data['ClinicalCollectionLink']['misc_identifier_id']
									);
									if($copy_links_option == 3 || $copy_links_option == 2){
										unset($ccl_array['consent_master_id']);
									}
									if($copy_links_option == 4 || $copy_links_option == 2){
										unset($ccl_array['diagnosis_master_id']);
									}
									if($this->data['FunctionManagement']['col_copy_frsq_nbr'] != '1'){
										unset($ccl_array['misc_identifier_id']);
									}
									
									if(!$this->ClinicalCollectionLink->save(array('ClinicalCollectionLink' => $ccl_array))){
										//copying links
										$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
									}
								}
							}
						}
						
						if($classic_ccl_insert && !$this->ClinicalCollectionLink->save(array('ClinicalCollectionLink' => array('collection_id' => $collection_id)))){
							$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
					}
					$this->atimFlash('your data has been saved', '/inventorymanagement/collections/detail/' . $collection_id);
				}				
			}
		}
	}

}

?>