<?php

class CollectionsController extends InventorymanagementAppController {

	var $uses = array('InventoryManagement.Collection', 'Administrate.Bank', 'Sop.SopMaster');
	var $paginate = array('Collection'=>array('limit'=>10,'order'=>'Collection.acquisition_label ASC')); 
	
	function index() {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
		
		// Populate Bank dropdown from banks table
		$bank_list = $this->Bank->find('all', array('conditions'=>array('Bank.deleted'=>'0')), array('fields' => array('Bank.id', 'Bank.name'), 'order' => array('Bank.name')));
		foreach ( $bank_list as $record ) {
			$bank_id_findall[ $record['Bank']['id'] ] = $record['Bank']['name'];
		}
		$this->set('bank_id_findall', $bank_id_findall);
		
		// Populate SopMaster dropdown from banks table
		$sop_master_list = $this->SopMaster->find('all', array('conditions'=>array('SopMaster.deleted'=>'0')), array('fields' => array('SopMaster.id', 'SopMaster.title'), 'order' => array('SopMaster.title')));
		foreach ( $sop_master_list as $record ) {
			$sop_master_id_findall[ $record['SopMaster']['id'] ] = $record['SopMaster']['title'];
		}
		$this->set('sop_master_id_findall', $sop_master_id_findall);
	}
	
	function search() {
		$this->set( 'atim_menu', $this->Menus->get('/inventorymanagement/collections/index') );
			
		// if SEARCH form data, parse and create conditions
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->Collection, $_SESSION['ctrapp_core']['search']['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Collection']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/inventorymanagement/collections/search';
		
		// Populate Bank dropdown from banks table
		$bank_list = $this->Bank->find('all', array('conditions'=>array('Bank.deleted'=>'0')), array('fields' => array('Bank.id', 'Bank.name'), 'order' => array('Bank.name')));
		foreach ( $bank_list as $record ) {
			$bank_id_findall[ $record['Bank']['id'] ] = $record['Bank']['name'];
		}
		$this->set('bank_id_findall', $bank_id_findall);
		
		$sop_master_list = $this->SopMaster->find('all', array('conditions'=>array('SopMaster.deleted'=>'0')), array('fields' => array('SopMaster.id', 'SopMaster.title'), 'order' => array('SopMaster.title')));
		foreach ( $sop_master_list as $record ) {
			$sop_master_id_findall[ $record['SopMaster']['id'] ] = $record['SopMaster']['title'];
		}
		$this->set('sop_master_id_findall', $sop_master_id_findall);
	}

	function detail( $collection_id ) {
		$this->set( 'atim_menu_variables', array('Collection.id'=>$collection_id) );
		$this->data = $this->Collection->find('first',array('conditions'=>array('Collection.id'=>$collection_id)));
		

		//		Calulate spent time between collection and reception
		$arr_spent_time = 
			$this->getSpentTime($this->data['Collection']['collection_datetime'],
								$this->data['Collection']['reception_datetime']);
								
		$this->set('coll_to_rec_spent_time_msg', $arr_spent_time['message']);
		$this->data['Calculated']['coll_to_rec_spent_time_days'] = $arr_spent_time['days'];
		$this->data['Calculated']['coll_to_rec_spent_time_hours'] = $arr_spent_time['hours'];
		$this->data['Calculated']['coll_to_rec_spent_time_minutes'] = $arr_spent_time['minutes'];

		
		// Populate Bank dropdown from banks table
		$bank_list = $this->Bank->find('all', array('conditions'=>array('Bank.deleted'=>'0')), array('fields' => array('Bank.id', 'Bank.name'), 'order' => array('Bank.name')));
		foreach ( $bank_list as $record ) {
			$bank_id_findall[ $record['Bank']['id'] ] = $record['Bank']['name'];
		}
		$this->set('bank_id_findall', $bank_id_findall);
		
		$sop_master_list = $this->SopMaster->find('all', array('conditions'=>array('SopMaster.deleted'=>'0')), array('fields' => array('SopMaster.id', 'SopMaster.title'), 'order' => array('SopMaster.title')));
		foreach ( $sop_master_list as $record ) {
			$sop_master_id_findall[ $record['SopMaster']['id'] ] = $record['SopMaster']['title'];
		}
		$this->set('sop_master_id_findall', $sop_master_id_findall);
	}
	
	function add() {
		$this->set( 'atim_menu', $this->Menus->get('/inventorymanagement/collections/index') );
		
		// Populate Bank dropdown from banks table
		$bank_list = $this->Bank->find('all', array('conditions'=>array('Bank.deleted'=>'0')), array('fields' => array('Bank.id', 'Bank.name'), 'order' => array('Bank.name')));
		foreach ( $bank_list as $record ) {
			$bank_id_findall[ $record['Bank']['id'] ] = $record['Bank']['name'];
		}
		$this->set('bank_id_findall', $bank_id_findall);
		
		$sop_master_list = $this->SopMaster->find('all', array('conditions'=>array('SopMaster.deleted'=>'0')), array('fields' => array('SopMaster.id', 'SopMaster.title'), 'order' => array('SopMaster.title')));
		foreach ( $sop_master_list as $record ) {
			$sop_master_id_findall[ $record['SopMaster']['id'] ] = $record['SopMaster']['title'];
		}
		$this->set('sop_master_id_findall', $sop_master_id_findall);
		
		if ( !empty($this->data) ) {
			if ( $this->Collection->save($this->data) ) $this->flash( 'Your data has been updated.','/inventorymanagement/collections/detail/'.$this->Collection->id );
		}
	}
	
	function edit( $collection_id ) {
		$this->set( 'atim_menu_variables', array('Collection.id'=>$collection_id) );
		
		// Populate Bank dropdown from banks table
		$bank_list = $this->Bank->find('all', array('conditions'=>array('Bank.deleted'=>'0')), array('fields' => array('Bank.id', 'Bank.name'), 'order' => array('Bank.name')));
		foreach ( $bank_list as $record ) {
			$bank_id_findall[ $record['Bank']['id'] ] = $record['Bank']['name'];
		}
		$this->set('bank_id_findall', $bank_id_findall);
		
		$sop_master_list = $this->SopMaster->find('all', array('conditions'=>array('SopMaster.deleted'=>'0')), array('fields' => array('SopMaster.id', 'SopMaster.title'), 'order' => array('SopMaster.title')));
		foreach ( $sop_master_list as $record ) {
			$sop_master_id_findall[ $record['SopMaster']['id'] ] = $record['SopMaster']['title'];
		}
		$this->set('sop_master_id_findall', $sop_master_id_findall);
		
		if ( !empty($this->data) ) {
			$this->Collection->id = $collection_id;
			if ( $this->Collection->save($this->data) ) $this->flash( 'Your data has been updated.','/inventorymanagement/collections/detail/'.$collection_id );
		} else {
			$this->data = $this->Collection->find('first',array('conditions'=>array('Collection.id'=>$collection_id)));
		}
	}
	
	function delete( $collection_id ) {
		if ( !$collection_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		if( $this->Collection->atim_delete( $collection_id ) ) {
			$this->flash( 'Your data has been deleted.', '/inventorymanagement/path_collection_reviews/listall/'.$collection_id );
		} else {
			$this->flash( 'Error deleting data - Contact administrator.', '/inventorymanagement/path_collection_reviews/listall/'.$collection_id );
		}
	}
}

?>