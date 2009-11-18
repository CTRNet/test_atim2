<?php

class PathCollectionReviewsController extends InventoryManagementAppController {
	
	var $uses = array('Inventorymanagement.PathCollectionReview', 'Inventorymanagement.Collection', 'Inventorymanagement.AliquotMaster');
	var $paginate = array('PathCollectionReview'=>array('limit'=>10, 'order' => 'PathCollectionReview.path_coll_rev_code'));
	
	function listall ($collection_id) {
		if (!$collection_id) { $this->redirect('/pages/err_clin-ann_no_part_id', null, true); }
		
		$aliquot_master_list = $this->AliquotMaster->find('all', array('fields' => array('AliquotMaster.id', 'AliquotMaster.barcode'), 'order' => array('AliquotMaster.barcode')));
		foreach ($aliquot_master_list as $record) {
			$aliquot_master_id_findall[ $record['AliquotMaster']['id'] ] = $record['AliquotMaster']['barcode'];
		}
		$this->set('aliquot_master_id_findall', $aliquot_master_id_findall);
		
		$this->set('atim_menu_variables', array('Collection.id'=>$collection_id));
		
		$this->hook();
		
		$this->data = $this->paginate($this->PathCollectionReview, array('PathCollectionReview.collection_id'=>$collection_id));
	}
	
	function add ($collection_id) {
		if (!$collection_id) { $this->redirect('/pages/err_clin-ann_no_part_id', null, true); }
		
		$aliquot_master_list = $this->AliquotMaster->find('all', array('fields' => array('AliquotMaster.id', 'AliquotMaster.barcode'), 'order' => array('AliquotMaster.barcode')));
		foreach ($aliquot_master_list as $record) {
			$aliquot_master_id_findall[ $record['AliquotMaster']['id'] ] = $record['AliquotMaster']['barcode'];
		}
		$this->set('aliquot_master_id_findall', $aliquot_master_id_findall);
		
		$this->set('atim_menu_variables', array('Collection.id'=>$collection_id));
		
		$this->hook();
		
		if (!empty($this->data)) {
			$this->data['PathCollectionReview']['collection_id'] = $collection_id;
			if ($this->PathCollectionReview->save($this->data)) {
				$this->flash('Your data has been updated . ','/inventorymanagement/path_collection_reviews/detail/' . $collection_id . '/' . $this->PathCollectionReview->id);
			}
		}
	}
	
	function detail($collection_id, $path_collection_review_id) {
		if (!$collection_id) { $this->redirect('/pages/err_clin-ann_no_part_id', null, true); }
		if (!$path_collection_review_id) { $this->redirect('/pages/err_clin-ann_no_part_id', null, true); }
		
		$aliquot_master_list = $this->AliquotMaster->find('all', array('fields' => array('AliquotMaster.id', 'AliquotMaster.barcode'), 'order' => array('AliquotMaster.barcode')));
		foreach ($aliquot_master_list as $record) {
			$aliquot_master_id_findall[ $record['AliquotMaster']['id'] ] = $record['AliquotMaster']['barcode'];
		}
		$this->set('aliquot_master_id_findall', $aliquot_master_id_findall);
		
		$this->set('atim_menu_variables', array('Collection.id'=>$collection_id, 'PathCollectionReview.id'=>$path_collection_review_id));
		
		$this->hook();
		
		$this->data = $this->PathCollectionReview->find('first',array('conditions'=>array('PathCollectionReview.id'=>$path_collection_review_id)));
	}
	
	
	function edit($collection_id, $path_collection_review_id) {
		if (!$collection_id) { $this->redirect('/pages/err_clin-ann_no_part_id', null, true); }
		if (!$path_collection_review_id) { $this->redirect('/pages/err_clin-ann_no_part_id', null, true); }
		
		$aliquot_master_list = $this->AliquotMaster->find('all', array('fields' => array('AliquotMaster.id', 'AliquotMaster.barcode'), 'order' => array('AliquotMaster.barcode')));
		foreach ($aliquot_master_list as $record) {
			$aliquot_master_id_findall[ $record['AliquotMaster']['id'] ] = $record['AliquotMaster']['barcode'];
		}
		$this->set('aliquot_master_id_findall', $aliquot_master_id_findall);
		
		$this->set('atim_menu_variables', array('Collection.id'=>$collection_id, 'PathCollectionReview.id'=>$path_collection_review_id));
		
		$this->hook();
		
		if (!empty($this->data)) {
			$this->PathCollectionReview->id = $path_collection_review_id;
			if ($this->PathCollectionReview->save($this->data)) {
				$this->flash('Your data has been updated . ','/inventorymanagement/path_collection_reviews/detail/' . $collection_id . '/' . $path_collection_review_id);
			}
		} else {
			$this->data = $this->PathCollectionReview->find('first',array('conditions'=>array('PathCollectionReview.id'=>$path_collection_review_id)));
		}
	}
	
	function delete($collection_id=null, $path_collection_review_id=null) {
		if (!$collection_id) { $this->redirect('/pages/err_clin-ann_no_part_id', null, true); }
		if (!$path_collection_review_id) { $this->redirect('/pages/err_clin-ann_no_part_id', null, true); }
		
		$this->hook();
		
		if($this->PathCollectionReview->atim_delete($path_collection_review_id)) {
			$this->flash('Your data has been deleted . ', '/inventorymanagement/path_collection_reviews/listall/' . $collection_id);
		} else {
			$this->flash('Error deleting data - Contact administrator . ', '/inventorymanagement/path_collection_reviews/listall/' . $collection_id);
		}
  	}
	
	/*
	var $name = 'PathCollectionReviews';
	var $uses = array('PathCollectionReview', 'ReviewMaster', 'AliquotMaster');
	
	var $components = array('Summaries');
	var $helpers = array('Summaries');
	
	function beforeFilter() {
		
		// $auth_conf array hardcoded in oth_auth component, due to plugins compatibility 
		$this->othAuth->controller = &$this;
		$this->othAuth->init();
		$this->othAuth->check();
		
		// CakePHP function to re-combine dat/time select fields 
		$this->cleanUpFields();
	}
	
	//// PathCollectionReview ////
	
	
	function index() {
		// nothing...
	}
		
	// List All but with Conditions  
	function listall($collection_id=null) {
	
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_15', $collection_id);
		$this->set('ctrapp_menu', $ctrapp_menu);
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set('ctrapp_form', $this->Forms->getFormArray('path_collection_reviews'));
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', $this->Sidebars->getColsArray($this->params['plugin'] . '_' . $this->params['controller'] . '_' . $this->params['action']));
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set('collection_id', $collection_id);
		
			$conditions = array();
			$conditions['collection_id'] = $collection_id;
			$conditions = array_filter($conditions);
			
		//NL 20070921: Modify to add pagination
		//list($order, $limit, $page) = $this->Pagination->init(null);
		list($order, $limit, $page) = $this->Pagination->init($conditions);
		$this->set('path_collection_reviews', $this->PathCollectionReview->findAll($conditions, null, $order, $limit, $page, 1));
		
		//NL 20070921: Modify aliquot barcode instead of Sample
		
		// setup SELECT TAGS OPTION VALUES
		// get all aliquot barcodes for this collection for Sample Master ID 	 
		 $criteria = 'AliquotMaster.collection_id ="' .$collection_id . '"';
		 $fields = 'AliquotMaster.id, AliquotMaster.barcode';	
		 $order = 'AliquotMaster.barcode ASC';
		 $aliquot_master_id_findall_result = $this->AliquotMaster->findAll($criteria, $fields, $order, null, null, 0);
		 $aliquot_master_id_findall = array();
		 foreach ($aliquot_master_id_findall_result as $aliquot) {
		 	$aliquot_master_id_findall[ $aliquot['AliquotMaster']['id'] ] = $aliquot['AliquotMaster']['barcode'];
		 }
		 $this->set('aliquot_master_id_findall', $aliquot_master_id_findall);

	}
	
	function detail($collection_id=null, $path_collection_review_id=null) {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_15', $collection_id);
		$this->set('ctrapp_menu', $ctrapp_menu);
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set('ctrapp_form', $this->Forms->getFormArray('path_collection_reviews'));
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', $this->Sidebars->getColsArray($this->params['plugin'] . '_' . $this->params['controller'] . '_' . $this->params['action']));
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set('collection_id', $collection_id);
		$this->set('path_collection_review_id', $path_collection_review_id);
		
		$this->PathCollectionReview->id = $path_collection_review_id;
		$data = $this->PathCollectionReview->read();
		$this->set('data', $data);

		//NL 20070921: Modify aliquot barcode instead of Sample
		
		// setup SELECT TAGS OPTION VALUES
		// get all aliquot barcodes for this collection for Sample Master ID 	 
		 $criteria = 'AliquotMaster.collection_id ="' .$collection_id . '"';
		 $fields = 'AliquotMaster.id, AliquotMaster.barcode';	
		 $order = 'AliquotMaster.barcode ASC';
		 $aliquot_master_id_findall_result = $this->AliquotMaster->findAll($criteria, $fields, $order, null, null, 0);
		 $aliquot_master_id_findall = array();
		 foreach ($aliquot_master_id_findall_result as $aliquot) {
		 	$aliquot_master_id_findall[ $aliquot['AliquotMaster']['id'] ] = $aliquot['AliquotMaster']['barcode'];
		 }
		 $this->set('aliquot_master_id_findall', $aliquot_master_id_findall);
		 
		 // Check if collection review can be deleted
		 $this->set(
			'allow_review_deletion', 
		 	$this->allowSampleDeletion($collection_id, $path_collection_review_id));
		 
	}
	
  
	function add($collection_id=null) {
	
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ($this->Forms->getValidateArray('path_collection_reviews') as $validate_model=>$validate_rules) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_15', $collection_id);
		$this->set('ctrapp_menu', $ctrapp_menu);
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set('ctrapp_form', $this->Forms->getFormArray('path_collection_reviews'));
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', $this->Sidebars->getColsArray($this->params['plugin'] . '_' . $this->params['controller'] . '_' . $this->params['action']));
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set('collection_id', $collection_id);
		
		//NL 20070921: Modify aliquot barcode instead of Sample
		
		// setup SELECT TAGS OPTION VALUES
		// get all aliquot barcodes for this collection for Sample Master ID 	 
		 $criteria = 'AliquotMaster.collection_id ="' .$collection_id . '"';
		 $fields = 'AliquotMaster.id, AliquotMaster.barcode, ' .
		 		'AliquotMaster.sample_master_id';	
		 $order = 'AliquotMaster.barcode ASC';
		 $aliquot_master_id_findall_result = $this->AliquotMaster->findAll($criteria, $fields, $order, null, null, 0);
		 $aliquot_master_id_findall = array();
		 $sample_master_from_aliquot = array();
		 foreach ($aliquot_master_id_findall_result as $aliquot) {
		 	$aliquot_master_id_findall[ $aliquot['AliquotMaster']['id'] ] = $aliquot['AliquotMaster']['barcode'];
			$sample_master_from_aliquot[ $aliquot['AliquotMaster']['id'] ] = $aliquot['AliquotMaster']['sample_master_id'];
		 }
		 $this->set('aliquot_master_id_findall', $aliquot_master_id_findall);
		 
		if (!empty($this->data)) {
			
			// Add sample Master Id of the selected aliquot          	
			if((!empty($this->data['PathCollectionReview']['aliquot_master_id']))
			&& (!empty($sample_master_from_aliquot)) 
			&& (isset($sample_master_from_aliquot[ $this->data['PathCollectionReview']['aliquot_master_id'] ]))) {        	
				$this->data['PathCollectionReview']['sample_master_id'] = 
					$sample_master_from_aliquot[ $this->data['PathCollectionReview']['aliquot_master_id'] ];
			} else {
				$this->data['PathCollectionReview']['sample_master_id'] = 0;
			}
			
			// Verify that code has not alreday been used for collection
			if(!empty($this->data['PathCollectionReview']['path_coll_rev_code'])){
				 $criteria = 'PathCollectionReview.collection_id ="' .$collection_id . '" ' .
				 		'AND PathCollectionReview.path_coll_rev_code ="' .
				 		$this->data['PathCollectionReview']['path_coll_rev_code'] . '" ';
				 $review_count = $this->PathCollectionReview->findCount($criteria);
				 
				 if($review_count > 0) {
				 	$this->data['PathCollectionReview']['path_coll_rev_code'] = '';
				 }
			}
			
			if ($this->PathCollectionReview->save($this->data)) {
				$this->flash('Your data has been saved . ', '/path_collection_reviews/listall/' . $collection_id);
			}
			
		}
		
	}
	
	function edit($collection_id=null, $path_collection_review_id=null) {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ($this->Forms->getValidateArray('path_collection_reviews') as $validate_model=>$validate_rules) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		//$ctrapp_menu[] = $this->Menus->tabs('3', '13', true, $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_15', $collection_id);
		$this->set('ctrapp_menu', $ctrapp_menu);
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set('ctrapp_form', $this->Forms->getFormArray('path_collection_reviews'));
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', $this->Sidebars->getColsArray($this->params['plugin'] . '_' . $this->params['controller'] . '_' . $this->params['action']));
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set('collection_id', $collection_id);
		$this->set('path_collection_review_id', $path_collection_review_id);
		
		//NL 20070921: Modify aliquot barcode instead of Sample
		
		// setup SELECT TAGS OPTION VALUES
		// get all aliquot barcodes for this collection for Sample Master ID 	 
		 $criteria = 'AliquotMaster.collection_id ="' .$collection_id . '"';
		 $fields = 'AliquotMaster.id, AliquotMaster.barcode, ' .
		 		'AliquotMaster.sample_master_id';	
		 $order = 'AliquotMaster.barcode ASC';
		 $aliquot_master_id_findall_result = $this->AliquotMaster->findAll($criteria, $fields, $order, null, null, 0);
		 $aliquot_master_id_findall = array();
		 $sample_master_from_aliquot = array();
		 foreach ($aliquot_master_id_findall_result as $aliquot) {
		 	$aliquot_master_id_findall[ $aliquot['AliquotMaster']['id'] ] = $aliquot['AliquotMaster']['barcode'];
			$sample_master_from_aliquot[ $aliquot['AliquotMaster']['id'] ] = $aliquot['AliquotMaster']['sample_master_id'];
		 }
		 $this->set('aliquot_master_id_findall', $aliquot_master_id_findall);
		
		if (empty($this->data)) {
			
			$this->PathCollectionReview->id = $path_collection_review_id;
			$this->data = $this->PathCollectionReview->read();
			$this->set('data', $this->data);
			
		} else {
			
			// Add sample Master Id of the selected aliquot          	
			if((!empty($this->data['PathCollectionReview']['aliquot_master_id']))
			&& (!empty($sample_master_from_aliquot)) 
			&& (isset($sample_master_from_aliquot[ $this->data['PathCollectionReview']['aliquot_master_id'] ]))) {        	
				$this->data['PathCollectionReview']['sample_master_id'] = 
					$sample_master_from_aliquot[ $this->data['PathCollectionReview']['aliquot_master_id'] ];
			} else {
				$this->data['PathCollectionReview']['sample_master_id'] = 0;
			}
			
			if ($this->PathCollectionReview->save($this->data['PathCollectionReview'])) {
				$this->flash('Your data has been updated . ','/path_collection_reviews/detail/' . $collection_id . '/' . $path_collection_review_id . '/');
			}
			
		}
		
	}
	
	function delete($collection_id=null, $path_collection_review_id=null) {
		
		if(!$this->allowSampleDeletion($collection_id, $path_collection_review_id)){
				die('The Collection Review can not be deleted! ' .
					'Please try again or contact your system adminsitartor . ');
		}
		
		$this->PathCollectionReview->del($path_collection_review_id);
		$this->flash('Your data has been deleted . ', '/path_collection_reviews/listall/' . $collection_id);
		
	}
	
	/**
	 * Define if a review can be deleted.
	 * 
	 * @param $collection_id Id of the collection.
	 * @param $path_collection_review_id Id of the review.
	 * 
	 * @return Return true if the review can be deleted.
	 * 
	 * @author N. Luc
	 * @since 2007-11-29
	 
	function allowSampleDeletion($collection_id, $path_collection_review_id){
		
		// Verify that this sample has no chidlren	
		$criteria = 'ReviewMaster.collection_id ="' .$collection_id . '" ' .
				'AND ReviewMaster.path_collection_review_id ="' .$path_collection_review_id . '" ';			 
		$aliq_review_attached_to_review = $this->ReviewMaster->findCount($criteria);
		
		if($aliq_review_attached_to_review > 0){
			return false;
		}
	
		return true;
	}
*/
}

?>
