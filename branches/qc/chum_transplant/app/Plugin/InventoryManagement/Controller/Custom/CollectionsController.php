<?php

	class CollectionsControllerCustom extends CollectionsController {
		
		function listOtherDonorCollections($collection_id) {
			// MANAGE DATA
			
			$collection_data = $this->ViewCollection->getOrRedirect($collection_id);
			if($collection_data['ViewCollection']['chum_transplant_type'] != 'donor time 0') {
				$this->flash(__('collection is not a donor collection'), '/InventoryManagement/Collections/detail/'.$collection_id);
			} 
			
			$this->ChumTransplantDonorCollectionsList = AppModel::getInstance('InventoryManagement', 'ChumTransplantDonorCollectionsList', true);
			$donor_collections_list_record = $this->ChumTransplantDonorCollectionsList->find('first', array('conditions' => array('ChumTransplantDonorCollectionsList.collection_id' => $collection_id)));
			if($donor_collections_list_record) {
				$donor_collections_conditions = array(
						'NOT' => array('ChumTransplantDonorCollectionsList.collection_id' => $collection_id),
						'ChumTransplantDonorCollectionsList.donor_id' => $donor_collections_list_record['ChumTransplantDonorCollectionsList']['donor_id']);
				$donor_collections_joins = array(array(
						'table' => 'view_collections',
						'alias' => 'ViewCollection',
						'type' => 'INNER',
						'conditions' => array('ChumTransplantDonorCollectionsList.collection_id = ViewCollection.collection_id')));
				$this->request->data = $this->ChumTransplantDonorCollectionsList->find('all', array(
					'conditions' => $donor_collections_conditions,
					'joins' => $donor_collections_joins,
					'fields' => array('ViewCollection.*')));
			} else {
				$this->request->data = array();
			}		
			
			// MANAGE FORM, MENU AND ACTION BUTTONS
			
			$this->set('atim_menu_variables', array('Collection.id' => $collection_id));
			$this->Structures->set('view_collection');
		}
		
		function linkToOtherDonorCollection($collection_id) {
			// MANAGE FORM, MENU AND ACTION BUTTONS
				
			$this->set('atim_menu_variables', array('Collection.id' => $collection_id));
			$this->set('atim_menu', $this->Menus->get('/InventoryManagement/Collections/listOtherDonorCollections/%%Collection.id%%'));
			
			// MANAGE DATA
				
			$collection_data = $this->ViewCollection->getOrRedirect($collection_id);
			if($collection_data['ViewCollection']['chum_transplant_type'] != 'donor time 0') {
				$this->flash(__('collection is not a donor collection'), '/InventoryManagement/Collections/detail/'.$collection_id);
			}
			
			if($this->request->data && $this->request->data['donor_collection_url']) {
				$regexp = '#([\d]+)(/)?$#';
				$selected_donor_collection_id = array();
				assert(preg_match($regexp, $this->request->data['donor_collection_url'], $selected_donor_collection_id));
				$selected_donor_collection_id = $selected_donor_collection_id[1];
				if($selected_donor_collection_id == $collection_id) {
					$this->set('validation_error', __('you selected the same donor collection'));
				} else {
					$selected_donor_collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $selected_donor_collection_id), 'recursive' => '-1'));
					if(empty($selected_donor_collection_data)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					if($selected_donor_collection_data['Collection']['chum_transplant_type'] != 'donor time 0') {
						$this->set('validation_error', __('the selected collection is not a donor collection'));		
					} else {
						$this->ChumTransplantDonorCollectionsList = AppModel::getInstance('InventoryManagement', 'ChumTransplantDonorCollectionsList', true);
						//Get current collection list (if exists)
						$current_donor_collections_list_record = $this->ChumTransplantDonorCollectionsList->find('first', array('conditions' => array('ChumTransplantDonorCollectionsList.collection_id' => $collection_id)));
						//Get selected collection list (if exists)
						$selected_donor_collections_list_record = $this->ChumTransplantDonorCollectionsList->find('first', array('conditions' => array('ChumTransplantDonorCollectionsList.collection_id' => $selected_donor_collection_id)));
						if(empty($current_donor_collections_list_record) && empty($selected_donor_collections_list_record)) {
							//Create new list and add both into this one
							$next_donor_id = 1;
							$max_donor_id_res = $this->ChumTransplantDonorCollectionsList->query('SELECT MAX(donor_id) AS max_donor_id FROM chum_transplant_donor_collections_lists');
							if(!empty($max_donor_id_res)) {
								$next_donor_id = $max_donor_id_res[0][0]['max_donor_id'] + 1;
							}
							$this->ChumTransplantDonorCollectionsList->check_writable_fields = false;
							if(!$this->ChumTransplantDonorCollectionsList->save(array('ChumTransplantDonorCollectionsList' => array('collection_id' => $collection_id, 'donor_id' => $next_donor_id)), false)) {
								$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
							}
							$this->ChumTransplantDonorCollectionsList->id = null;
							$this->ChumTransplantDonorCollectionsList->data = array();
							if(!$this->ChumTransplantDonorCollectionsList->save(array('ChumTransplantDonorCollectionsList' => array('collection_id' => $selected_donor_collection_id, 'donor_id' => $next_donor_id)), false)) {
								$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
							}
							$this->atimFlash(__('collections have been merged into the same donor collections list'), '/InventoryManagement/Collections/listOtherDonorCollections/'.$collection_id);
						} else if(!empty($current_donor_collections_list_record) && empty($selected_donor_collections_list_record)) {
							//Add selected collection to current collection donor list
							$donor_id = $current_donor_collections_list_record['ChumTransplantDonorCollectionsList']['donor_id'];
							$this->ChumTransplantDonorCollectionsList->check_writable_fields = false;
							if(!$this->ChumTransplantDonorCollectionsList->save(array('ChumTransplantDonorCollectionsList' => array('collection_id' => $selected_donor_collection_id, 'donor_id' => $donor_id)), false)) {
								$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
							}
							$this->atimFlash(__('collections have been merged into the same donor collections list'), '/InventoryManagement/Collections/listOtherDonorCollections/'.$collection_id);
						} else if(empty($current_donor_collections_list_record) && !empty($selected_donor_collections_list_record)) {
							//Add current collection to selected collection donor list
							$donor_id = $selected_donor_collections_list_record['ChumTransplantDonorCollectionsList']['donor_id'];
							$this->ChumTransplantDonorCollectionsList->check_writable_fields = false;
							if(!$this->ChumTransplantDonorCollectionsList->save(array('ChumTransplantDonorCollectionsList' => array('collection_id' => $collection_id, 'donor_id' => $donor_id)), false)) {
								$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
							}
							$this->atimFlash(__('collections have been merged into the same donor collections list'), '/InventoryManagement/Collections/listOtherDonorCollections/'.$collection_id);
						} else if($current_donor_collections_list_record['ChumTransplantDonorCollectionsList']['donor_id'] == $selected_donor_collections_list_record['ChumTransplantDonorCollectionsList']['donor_id']) {	
							$this->atimFlash(__('collections are already merged into the same donor collections list'), '/InventoryManagement/Collections/listOtherDonorCollections/'.$collection_id);
						} else {
							// Merge 2 donor collections lists
							$current_collection_donor_id = $current_donor_collections_list_record['ChumTransplantDonorCollectionsList']['donor_id'];
							$selected_donor_collections_list = $this->ChumTransplantDonorCollectionsList->find('all', array('conditions' => array('ChumTransplantDonorCollectionsList.donor_id' => $selected_donor_collections_list_record['ChumTransplantDonorCollectionsList']['donor_id'])));
							$this->ChumTransplantDonorCollectionsList->check_writable_fields = false;
							foreach($selected_donor_collections_list as $new_list_record) {
								$this->ChumTransplantDonorCollectionsList->id = $new_list_record['ChumTransplantDonorCollectionsList']['id'];
								if(!$this->ChumTransplantDonorCollectionsList->save(array('ChumTransplantDonorCollectionsList' => array('id' => $new_list_record['ChumTransplantDonorCollectionsList']['id'], 'donor_id' => $current_collection_donor_id)), false)) {
									$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
								}
							}
							$this->atimFlash(__('collections have been merged into the same donor collections list'), '/InventoryManagement/Collections/listOtherDonorCollections/'.$collection_id);
						}
					}
				
/*	
				si deja lié a cette collection
				deja lié
				pas de suppresions de collection lié ou de changement de statu
				pr($selected_donor_collection_data);
				exit;
*/
				
				}
			}
		}
		
		function removeFromDonorCollectionsList($collection_id) {
			$collection_data = $this->ViewCollection->getOrRedirect($collection_id);
			if($collection_data['ViewCollection']['chum_transplant_type'] != 'donor time 0') {
				$this->flash(__('collection is not a donor collection'), '/InventoryManagement/Collections/detail/'.$collection_id);
			}
			$this->ChumTransplantDonorCollectionsList = AppModel::getInstance('InventoryManagement', 'ChumTransplantDonorCollectionsList', true);
			$donor_collections_list_record = $this->ChumTransplantDonorCollectionsList->find('first', array('conditions' => array('ChumTransplantDonorCollectionsList.collection_id' => $collection_id)));
			if($donor_collections_list_record) {
				$donor_collections_conditions = array('ChumTransplantDonorCollectionsList.donor_id' => $donor_collections_list_record['ChumTransplantDonorCollectionsList']['donor_id']);
				$all_donor_collections = $this->ChumTransplantDonorCollectionsList->find('all', array('conditions' => $donor_collections_conditions));	
				if(sizeof($all_donor_collections) > 2) {
					if(!$this->ChumTransplantDonorCollectionsList->atimDelete($donor_collections_list_record['ChumTransplantDonorCollectionsList']['id'], false)) {
						$this->flash(__('error deleting data - contact administrator'), '/InventoryManagement/Collections/detail/'.$collection_id);
					} else {
						$this->atimFlash(__('collection has been removed from the donor collections list'), '/InventoryManagement/Collections/listOtherDonorCollections/'.$collection_id);
					}
				} else {
					foreach($all_donor_collections as $new_collection) {
						if(!$this->ChumTransplantDonorCollectionsList->atimDelete($new_collection['ChumTransplantDonorCollectionsList']['id'], false)) {
							$this->flash(__('error deleting data - contact administrator'), '/InventoryManagement/Collections/detail/'.$collection_id);
						}
					}
					$this->atimFlash(__('donor collections list has been deleted'), '/InventoryManagement/Collections/listOtherDonorCollections/'.$collection_id);
				}
			} else {
				$this->atimFlash(__('no donor collections list has to be deleted'), '/InventoryManagement/Collections/listOtherDonorCollections/'.$collection_id);
			}
		}
		
		function deleteAllDonorCollectionsList($collection_id) {
			$collection_data = $this->ViewCollection->getOrRedirect($collection_id);
			if($collection_data['ViewCollection']['chum_transplant_type'] != 'donor time 0') {
				$this->flash(__('collection is not a donor collection'), '/InventoryManagement/Collections/detail/'.$collection_id);
			}
			$this->ChumTransplantDonorCollectionsList = AppModel::getInstance('InventoryManagement', 'ChumTransplantDonorCollectionsList', true);
			$donor_collections_list_record = $this->ChumTransplantDonorCollectionsList->find('first', array('conditions' => array('ChumTransplantDonorCollectionsList.collection_id' => $collection_id)));
			if($donor_collections_list_record) {
				$donor_collections_conditions = array('ChumTransplantDonorCollectionsList.donor_id' => $donor_collections_list_record['ChumTransplantDonorCollectionsList']['donor_id']);
				$all_donor_collections = $this->ChumTransplantDonorCollectionsList->find('all', array('conditions' => $donor_collections_conditions));
				foreach($all_donor_collections as $new_collection) {
					if(!$this->ChumTransplantDonorCollectionsList->atimDelete($new_collection['ChumTransplantDonorCollectionsList']['id'], false)) {
						$this->flash(__('error deleting data - contact administrator'), '/InventoryManagement/Collections/detail/'.$collection_id);
					}
				}
				$this->atimFlash(__('donor collections list has been deleted'), '/InventoryManagement/Collections/listOtherDonorCollections/'.$collection_id);
			} else {
				$this->atimFlash(__('no donor collections list has to be deleted'), '/InventoryManagement/Collections/listOtherDonorCollections/'.$collection_id);
			}
		}
	}

?>