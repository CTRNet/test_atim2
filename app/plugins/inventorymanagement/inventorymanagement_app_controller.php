<?php

class InventorymanagementAppController extends AppController {	
		
	static $search_links = array(
		'collections'	=> array('link'=> '/inventorymanagement/collections/index/', 'icon' => 'search'),
		'samples'		=> array('link'=> '/inventorymanagement/sample_masters/search/', 'icon' => 'search'),
		'aliquots'		=> array('link'=> '/inventorymanagement/aliquot_masters/search/', 'icon' => 'search')
	);
	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	}
	
	/**
	 * Unset session data linked to the inventroy management system.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function unsetInventorySessionData() {
		unset($_SESSION['InventoryManagement']['treeView']['Filter']);
		unset($_SESSION['InventoryManagement']['CollectionSamples']['Filter']);
		unset($_SESSION['InventoryManagement']['CollectionAliquots']['Filter']);

		unset($_SESSION['InventoryManagement']['SpecimenDerivatives']['Filter']);
		unset($_SESSION['InventoryManagement']['SampleAliquots']['Filter']);
	}
	
	
	function setBatchMenu(array $data){
		if(array_key_exists('SampleMaster', $data) && !empty($data['SampleMaster'])){
			$id = null;
			if(is_string($data['SampleMaster'])){
				$id = explode(",", $data['SampleMaster']);
			}else if(array_key_exists(0, $data['SampleMaster']) && is_numeric($data['SampleMaster'][0])){
				$id = $data['SampleMaster'];
			}else if(!array_key_exists('initial_specimen_sample_id', $data['SampleMaster'])){
				$id = $data['SampleMaster']['id'];
			}
			if($id != null){				
				$data = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.id' => $id), 'recursive' => -1));
			}else if(array_key_exists('SampleMaster', $data)){
				$data = array(array('SampleMaster' => $data['SampleMaster']));
			}
			
			if(count($data) == 1){
				$data = $data[0]['SampleMaster'];
				if($data['initial_specimen_sample_id'] == $data['id']){
					$this->set('atim_menu', $this->Menus->get('/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%'));
				}else{
					$this->set('atim_menu', $this->Menus->get('/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.id%%'));
				}
				$this->set('atim_menu_variables', array(
					'Collection.id' => $data['collection_id'], 
					'SampleMaster.id' => $data['id'],
					'SampleMaster.initial_specimen_sample_id' => $data['initial_specimen_sample_id'])
				);
			}else if(!empty($data)){
				$collection_id = $data[0]['SampleMaster']['collection_id'];
				foreach($data as $data_unit){
					if($data_unit['SampleMaster']['collection_id'] != $collection_id){
						$collection_id = null;
						break;
					}
				}
				if($collection_id == null){
					$this->set('atim_menu', $this->Menus->get('/inventorymanagement/'));
				}else{
					$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/detail/%%Collection.id%%'));
					$this->set('atim_menu_variables', array(
						'Collection.id' => $collection_id
					));
				}
			}
		}
	}
	
	function setAliquotMenu($data){
		$atim_menu_link = ($data['SampleControl']['sample_category'] == 'specimen')?
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%/%%AliquotMaster.id%%': 
			'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		$this->set('atim_menu_variables', array(
			'Collection.id' => $data['AliquotMaster']['collection_id'], 
			'SampleMaster.id' => $data['AliquotMaster']['sample_master_id'], 
			'SampleMaster.initial_specimen_sample_id' => $data['SampleMaster']['initial_specimen_sample_id'], 
			'AliquotMaster.id' => $data['AliquotMaster']['id'])
		);
	}
}

?>
