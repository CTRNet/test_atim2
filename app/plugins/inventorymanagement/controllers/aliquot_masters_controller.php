<?php

class AliquotMastersController extends InventoryManagementAppController {
	
	/*
	var $uses = array(
			'AliquotControl', 
			'AliquotMaster', 
			'AliquotUse', 
			'Collection',
			'DerivativeDetail',
			'OrderItem',
			'PathCollectionReview',
			'QualityControl', 
			'Realiquoting',
			'ReviewMaster',
			'SampleAliquotControlLink', 
			'SampleControl', 
			'SampleMaster',
			'SopMaster', 
			'SourceAliquot', 
			'StorageMaster',
			'StudySummary'
	);
	*/
		
	var $uses = array(
		'Inventorymanagement.Collection',
		
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.SampleControl',
		
		'Inventorymanagement.AliquotControl', 
		'Inventorymanagement.AliquotMaster'
	);
	
	var $paginate = array('SampleMaster'=>array('limit'=>10,'order'=>'SampleMaster.sample_code DESC'));
	
	var $barcode_size_max = 60;

	function index() {
		// nothing...
	}
	
	/**
	 * Allow to display the results list of a aliquot research based on aliquot barcode. 
	 * 
	 * @author N. Luc
	 * @date 2007-08-22
	 */
	function search() {
		
		// set MENU varible for echo on VIEW 
		$this->set('ctrapp_menu', array());
		
		// set FORM variable, for HELPER call on VIEW 
		$ctrapp_form = $this->Forms->getFormArray('aliquot_masters_for_search_result');
		$this->set('ctrapp_form', $ctrapp_form);
		
		// set SUMMARY variable from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build());
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', $this->Sidebars->getColsArray( 
			$this->params['plugin'].'_'.
			$this->params['controller'].'_'.
			$this->params['action']));
		
		// if SEARCH form data, parse and create conditions 
		if ($this->data) {
			$criteria = $this->Forms->getSearchConditions($this->data, $ctrapp_form);	
			// save CRITERIA to session for pagination 		
			$_SESSION['ctrapp_core']['inventory_management']['aliquot_search_criteria'] = $criteria; 
		} else {
			// if no form data, use SESSION critera for PAGINATION bug 
			$criteria = $_SESSION['ctrapp_core']['inventory_management']['aliquot_search_criteria']; 
		}
		
		// Look for aliquot data
		$belongs_array 
			= array('belongsTo' => 
				array(
					'SampleMaster' => array(
						'className' => 'SampleMaster',
						'conditions' => '',
						'order'      => '',
						'foreignKey' => 'sample_master_id'),
					'Collection' => array(
						'className' => 'Collection',
						'conditions' => '',
						'order'      => '',
						'foreignKey' => 'collection_id')));
		
		$this->AliquotMaster->bindModel($belongs_array);	
		
		$no_pagination_order = NULL;
			
		list($order, $limit, $page) = $this->Pagination->init($criteria);
		
		$this->AliquotMaster->bindModel($belongs_array);

		$aliquot_data = $this->AliquotMaster->findAll($criteria, NULL, $no_pagination_order, $limit, $page, 0);
	
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		$this->set('aliquots', $aliquot_data);
		
	}
	
	/* --------------------------------------------------------------------------
	 * a- sample aliquots functions
	 * -------------------------------------------------------------------------- */	
	
	/**
	 * List all aliquots of a 'Collection Group' sample (specimen or derivative).
	 *  
	 * (Notes: 'Collection Group' contains either 
	 * collection ascite specimens plus all derivatives 
	 * or collection blood specimens plus all derivatives 
	 * or etc).
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category
	 * @param $collection_id Id of the studied collection.
	 * @param $sample_master_id Id of the studied sample.
	 * 
	 * @author N. Luc
	 * @date 2007-08-13
	 */
	// function listAllSampleAliquots($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category = null, $collection_id=null, $sample_master_id = NULL) {
	function listAllSampleAliquots( $collection_id=NULL, $sample_master_id=NULL) {
		$this->set( 'atim_menu_variables', array('Collection.id'=>$collection_id, 'SampleMaster.id'=>$sample_master_id) );
		$this->data = $this->paginate($this->AliquotMaster,array('AliquotMaster.sample_master_id'=>$sample_master_id));
		
		/*
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($sample_category) || 
		empty($collection_id) || empty($group_specimen_type) || 
		empty($sample_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// Verify collection data exists
		$criteria = 'Collection.id = "'.$collection_id.'" ';		
		$collection_data = $this->Collection->find($criteria);
		
		if(empty($collection_data)) {
			$this->redirect('/pages/err_inv_coll_no_data'); 
			exit;
		}
		
		// ** get SAMPLE data **
		$criteria = 'SampleMaster.id ="'.$sample_master_id.'" AND ' .
				'SampleMaster.collection_id ="'.$collection_id.'"';
		$sample_master = $this->SampleMaster->find($criteria, null, null, 0);
			
		if(empty($sample_master)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('aliquot_masters'));
		
		// ** set DATA for echo on VIEW or for link build **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id );
		$this->set('sample_master_id', $sample_master_id);
		
		$this->set('max_nbr_of_aliq_per_batch', 20);
		
//		$this->set('sample_code', $sample_master['SampleMaster']['sample_code']);
				
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_al';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_al';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id.'/'.$derivative_sample_master_id.'/');	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
	
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id));
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
		
		// ** Search sample aliquot data to display in the list **

		// Search data from aliquot master table	
		$criteria = array();
		$criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
		$criteria = array_filter($criteria);
			
		list($order, $limit, $page) = $this->Pagination->init($criteria);
		$aliquot_masters = $this->AliquotMaster->findAll($criteria, NULL, $order, $limit, $page, 1);

		// Record the number of use for each aliquot
		$arr_aliquot_ids = array();				
		foreach($aliquot_masters as $id => $newAliquot){
			
			// Aliquot use number
			$aliquot_masters[$id]['Generated']['generated_field_use']
				= sizeof($newAliquot['AliquotUse'])? 
					sizeof($newAliquot['AliquotUse']): 
					'0';
					
			$arr_aliquot_ids[] = $newAliquot['AliquotMaster']['id'];
		}
		
		// Record realiquoting data
		if(!empty($aliquot_masters)) {
			$parent_aliquot_list = array();
			$child_aliquot_list = array();
					
			$parent_aliquot_list = 
				$this->Realiquoting->generateList(
					array('Realiquoting.parent_aliquot_master_id' => $arr_aliquot_ids),
					null, 
					null, 
					'{n}.Realiquoting.parent_aliquot_master_id', 
					'{n}.Realiquoting.parent_aliquot_master_id');	
	
			$child_aliquot_list = 
				$this->Realiquoting->generateList(
					array('Realiquoting.child_aliquot_master_id' => $arr_aliquot_ids),
					null, 
					null, 
					'{n}.Realiquoting.child_aliquot_master_id', 
					'{n}.Realiquoting.child_aliquot_master_id');
	
			if(empty($parent_aliquot_list)) {
				$parent_aliquot_list = array();
			}
			if(empty($child_aliquot_list)) {
				$child_aliquot_list = array();
			}
			
			foreach($aliquot_masters as $id => $newAliquot){
				
				// Aliquot use number
				$studied_aliq_id = $newAliquot['AliquotMaster']['id'];
				if(in_array($studied_aliq_id, $parent_aliquot_list) && in_array($studied_aliq_id, $child_aliquot_list)) {
					$aliquot_masters[$id]['Generated']['realiquoting_data'] = 'parent/child';
				} else if(in_array($studied_aliq_id, $parent_aliquot_list)) {
					$aliquot_masters[$id]['Generated']['realiquoting_data'] = 'parent';			
				} else if(in_array($studied_aliq_id, $child_aliquot_list)) {
					$aliquot_masters[$id]['Generated']['realiquoting_data'] = 'child';			
				} else {
					$aliquot_masters[$id]['Generated']['realiquoting_data'] = 'n/a';				
				}
				
			}
		}

		$this->set('aliquot_masters', $aliquot_masters);
			
		// ** Build list of aliquot types that could be used to contain the sample. **

		// Search types of aliquot that could be used to contain the sample
		$criteria = array();
		$criteria['sample_control_id'] = $sample_master['SampleMaster']['sample_control_id'];
		$criteria['status'] = 'active';
		$allowed_aliquot_type_ids = 
			$this->SampleAliquotControlLink->generateList(
				$criteria,
				null, 
				null, 
				'{n}.SampleAliquotControlLink.aliquot_control_id', 
				'{n}.SampleAliquotControlLink.aliquot_control_id');					
		
		$allowed_aliquot_types = array();
		
		if(!empty($allowed_aliquot_type_ids)){
			// At least one aliquot type can be used.
			
			// Search active aliquot
			$criteria = array();
			$criteria['id'] = array_values ($allowed_aliquot_type_ids);
			$criteria['status'] = 'active';
			$criteria = array_filter($criteria);

			$allowed_aliquot_types
				= $this->AliquotControl->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.AliquotControl.id', 
					'{n}.AliquotControl.aliquot_type');	
		}
		
		$this->set('allowed_aliquot_types', $allowed_aliquot_types);
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		*/
						
	} // End listAllSampleAliquots()
	
	/**
	 * This function defines if the screen displayed to create aliquot(s) 
	 * should allow to create either one aliquot or many aliquots in a batch
	 * process.
	 * 
	 * This function is only a dispatcher that will call either function addAliquot()
	 * or addAliquotInBatch() according to the number of aliquot to create.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category SampleCategory.
	 * @param $collection_id Id of the studied collection.
	 * @param $sample_master_id Id of the sample.
	 * 
	 * @author N. Luc
	 * @date 2007-08-13
	 */
	function addAliquotDispatcher($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category = null,
	$collection_id=null, $sample_master_id = NULL) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($sample_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Get the aliquot control id **
		$aliquot_control_id = null;
		// This id corresponds to the type of the new sample to create.
		if (!isset($this->params['form']['aliquot_control_id'])) {
			$this->redirect('/pages/err_inv_no_aliqu_cont_id'); 
			exit;
		} else {
			$aliquot_control_id = $this->params['form']['aliquot_control_id'];
		}
		
		// ** Get the number of aliquots **
		$aliquot_nbr = 0;
		// This id corresponds to the type of the new sample to create.
		if ((!isset($this->params['form']['aliquot_number'])) ||
		(!is_numeric($this->params['form']['aliquot_number']))) {
			$this->redirect('/pages/err_inv_aliqu_nbr_to_create'); 
			exit;
		} else {
			$aliquot_nbr = $this->params['form']['aliquot_number'];
		}

		if($aliquot_nbr == 1){
			$this->redirect('/inventorymanagement/aliquot_masters/addAliquot/'.
					$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.
					'/'.$collection_id.'/'.$sample_master_id.'/'.$aliquot_control_id);	
		} else {
			$this->redirect('/inventorymanagement/aliquot_masters/addAliquotInBatch/'.
					$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.
					'/'.$collection_id.'/'.$sample_master_id.'/'.$aliquot_control_id.'/'.$aliquot_nbr.'/');	
		}		
	}
	
	/**
	 * Allow to add one aliquot to a 'Collection Group' sample (specimen or derivative).
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category.
	 * @param $collection_id Id of the studied collection.
	 * @param $sample_master_id Id of the sample.
	 * @param $aliquot_control_id Aliquot Control Id of either the aliquot to create 
	 * or the new aliquot that allows system to know its type. 
	 * 
	 * @author N. Luc
	 * @date 2007-08-13
	 */
	function addAliquot($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category=null,
	$collection_id=null, $sample_master_id=null, $aliquot_control_id=null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($sample_master_id) || 
		empty($aliquot_control_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// Verify collection data exists
		$criteria = 'Collection.id = "'.$collection_id.'" ';		
		$collection_data = $this->Collection->find($criteria);
		
		if(empty($collection_data)) {
			$this->redirect('/pages/err_inv_coll_no_data'); 
			exit;
		}
		
		// Verify sample data exists
		$criteria = 'SampleMaster.id ="'.$sample_master_id.'" AND ' .
				'SampleMaster.collection_id ="'.$collection_id.'"';
		$sample_master = $this->SampleMaster->find($criteria, null, null, 0);

		if(empty($sample_master)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Get the aliquot control id **
		// This id corresponds to the type of the new sample to create.
		if(isset($this->data['AliquotMaster']['aliquot_control_id'])) {
			//User clicked on the Submit button to create the new aliquot
			$aliquot_control_id = $this->data['AliquotMaster']['aliquot_control_id'];	
		}
		
		if (is_null($aliquot_control_id)) {
			$this->redirect('/pages/err_inv_no_aliqu_cont_id'); 
			exit;			
		}
		
		// ** Load the aliquot type data from ALIQUOT CONTROLS table **
		$this->AliquotControl->id = $aliquot_control_id;
		$aliquot_control_data = $this->AliquotControl->read();
		if(empty($aliquot_control_data)){
			$this->redirect('/pages/err_inv_no_aliqu_cont_data'); 
			exit;			
		}

		// ** set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray($aliquot_control_data['AliquotControl']['form_alias']));

		// ** set DATA for echo on VIEW or for link build **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);	
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id);
		$this->set('sample_master_id', $sample_master_id);
		$this->set('aliquot_control_id', $aliquot_control_id);
		
//		$this->set('sample_code', $sample_master['SampleMaster']['sample_code']);
		$this->set('aliquot_type', $aliquot_control_data['AliquotControl']['aliquot_type']);
		$this->set('aliquot_volume_unit', $aliquot_control_data['AliquotControl']['volume_unit']);
	
		$this->set('arr_sop_title_from_id', 
			$this->getInventoryProductSopsArray(
				$sample_master['SampleMaster']['sample_type'],
				$aliquot_control_data['AliquotControl']['aliquot_type']));
			
		$this->set('arr_study_from_id', $this->getStudiesArray());
		
		// Set additional data for tissue slide/core
		$form_requiring_blocks_list = array ('ad_spec_tiss_slides' ,'ad_spec_tiss_cores');

		if (in_array($aliquot_control_data['AliquotControl']['form_alias'], $form_requiring_blocks_list)) {
	
			// Get aliquot control ID of tissue block 
			$criteria = array();
			$criteria['AliquotControl.form_alias'] = 'ad_spec_tiss_blocks';
			$criteria['AliquotControl.status'] = 'active';
			$tmp_aliquot_data = $this->AliquotControl->findAll($criteria);
			if(sizeof($tmp_aliquot_data) != 1) {
				$this->redirect('/pages/err_inv_source_block_definition'); 
				exit;
			}
			$source_aliquot_control_id = $tmp_aliquot_data['0']['AliquotControl']['id'];
			
			// Create array to display available tissue block lists
			$criteria = array();
			$criteria['AliquotMaster.aliquot_control_id'] = $source_aliquot_control_id;
			$criteria['AliquotMaster.status'] = 'available';
			$criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
			$criteria['AliquotMaster.collection_id'] = $collection_id;
			$criteria = array_filter($criteria);
			
			$available_block_code 
				= $this->AliquotMaster->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.AliquotMaster.id', 
					'{n}.AliquotMaster.barcode');

			$this->set('available_block_code', $available_block_code);
		}
		
		// Set additional data for cell core
		$form_requiring_gel_matrix_list = array ('ad_der_cell_cores');

		if (in_array($aliquot_control_data['AliquotControl']['form_alias'], $form_requiring_gel_matrix_list)) {
	
			// Get aliquot control ID of gel matrix 
			$criteria = array();
			$criteria['AliquotControl.form_alias'] = 'ad_der_cel_gel_matrices';
			$criteria['AliquotControl.status'] = 'active';
			$tmp_aliquot_data = $this->AliquotControl->findAll($criteria);
			if(sizeof($tmp_aliquot_data) != 1) {
				$this->redirect('/pages/err_inv_source_gel_matrix_definition'); 
				exit;
			}
			$source_aliquot_control_id = $tmp_aliquot_data['0']['AliquotControl']['id'];
			
			// Create array to display available gel matrix lists
			$criteria = array();
			$criteria['AliquotMaster.aliquot_control_id'] = $source_aliquot_control_id;
			$criteria['AliquotMaster.status'] = 'available';
			$criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
			$criteria['AliquotMaster.collection_id'] = $collection_id;
			$criteria = array_filter($criteria);
			
			$available_gel_matrix_code 
				= $this->AliquotMaster->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.AliquotMaster.id', 
					'{n}.AliquotMaster.barcode');

			$this->set('available_gel_matrix_code', $available_gel_matrix_code);
		}
		
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_al';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_al';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id.'/'.$derivative_sample_master_id.'/');	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
	
		// ** set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id));

		// ** set SIDEBAR variable **
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));

		// ** Initialize AliquotDetail **
		// Plus set boolean to define if details must be recorded in database
		$bool_needs_details_table = FALSE;
		
		if(!is_null($aliquot_control_data['AliquotControl']['detail_tablename'])){
			// This aliquot type has a specific details table
			$bool_needs_details_table = TRUE;
			
			// Create new instance of AliquotDetail model 
			$this->AliquotDetail = 
				new AliquotDetail(false, $aliquot_control_data['AliquotControl']['detail_tablename']);

		} else {
			// This Aliquot type doesn't need a specific details table
			$this->AliquotDetail = NULL;

		}
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}	
				
		if (empty($this->data)) {
			// Default creation date will be the derivative creation date or Specimen reception date
			$default_storage_date = NULL;
			
			if(strcmp($sample_master['SampleMaster']['sample_category'], 'specimen') == 0) {
				$default_storage_date = $collection_data['Collection']['reception_datetime'];
				
			} else if(strcmp($sample_master['SampleMaster']['sample_category'], 'derivative') == 0) {
				$criteria = array();
				$criteria['DerivativeDetail.sample_master_id'] = $sample_master_id;
				$derivative_detail_data = $this->DerivativeDetail->find($criteria);
				
				if(empty($derivative_detail_data)){
					$this->redirect('/pages/err_inv_missing_samp_data'); 
					exit;
				}
				
				$default_storage_date = $derivative_detail_data['DerivativeDetail']['creation_datetime'];
				
			} else {
				$this->redirect('/pages/err_inv_system_error'); 
				exit;
							
			}
			
			$this->set('default_storage_datetime', $default_storage_date);
			
			// The storage list will be empty to force user to enter first a storage selection label
			$this->set('arr_storage_list', array());
		
		} else {
			// A new aliquot has been created
						
			// ** verify barcode is unique and not too long **
			
			if(isset($this->data['AliquotMaster'])){
				$arr_barcode_in_error = 
					$this->validateAliquotBarcode(array($this->data['AliquotMaster']['barcode']));
				if(!empty($arr_barcode_in_error)){				
					// Set barcode to blank to use FORM VALIDATION
					$this->data['AliquotMaster']['barcode'] = '';
				}
			}
			
			// ** Check the user storage defintion (selection label / storage_master_id) **
			
			$recorded_selection_label = $this->data['FunctionManagement']['storage_selection_label'];
			$returned_storage_id = $this->data['AliquotMaster']['storage_master_id'];
				
			$problem_in_the_storage_defintion = false;
			$arr_storage_list = array();
			$storage_control_errors = array();
	
			$arr_storage_selection_results 
				= $this->validateStorageIdAndSelectionLabel($recorded_selection_label, $returned_storage_id);
			$this->data['AliquotMaster']['storage_master_id'] = $arr_storage_selection_results['defined_storage_id'];
			$arr_storage_list = $arr_storage_selection_results['aliquot_arr_storage_list'];
			if(!$arr_storage_selection_results['submitted_data_validates']){
				$problem_in_the_storage_defintion = true;
			}
			$storage_control_errors = $arr_storage_selection_results['storage_control_errors'];
			
			$this->set('arr_storage_list', $arr_storage_list);	
			
			// ** Verify set aliquot coordinates into storage **
			
			$arr_storage_coord_results 
				= $this->validateStorageCoordinates(
					$this->data['AliquotMaster']['storage_master_id'], 
					$this->data['AliquotMaster']['storage_coord_x'], 
					$this->data['AliquotMaster']['storage_coord_y']);
			
			$this->data['AliquotMaster']['storage_coord_x'] = $arr_storage_coord_results['validated_storage_coord_x'];
			$this->data['AliquotMaster']['storage_coord_y'] = $arr_storage_coord_results['validated_storage_coord_y'];
			if(!$arr_storage_coord_results['submitted_data_validates']){
				$problem_in_the_storage_defintion = true;
			}
			$storage_control_errors = $storage_control_errors + $arr_storage_coord_results['storage_control_errors'];	

			// Set storage errors
			foreach($storage_control_errors as $id => $msg) {
				$this->AliquotMaster->validationErrors[$id] = $msg;
			}
			
			// ** Set value that have not to be defined by the user **
			
			// Set current volume
			if(isset($this->data['AliquotMaster']['initial_volume'])){	
				
				if(is_null($aliquot_control_data['AliquotControl']['volume_unit'])){
					$this->redirect('/pages/err_inv_system_error'); 
					exit;
				}

				// Set the current volume with the initial volume
				$this->data['AliquotMaster']['current_volume'] =
					$this->data['AliquotMaster']['initial_volume'];				

			}
			
			// ** Execute Validation **
						
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray( $aliquot_control_data['AliquotControl']['form_alias'] ) as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			$submitted_data_validates = TRUE;
			
			if($problem_in_the_storage_defintion) {
				// The aliquot storage has not been correclty defined
				$submitted_data_validates = FALSE;				
			}
			
			// Validates Fields of Master Table
			$this->cleanUpFields('AliquotMaster');
			
			if(!$this->AliquotMaster->validates($this->data['AliquotMaster'])){
				$submitted_data_validates = FALSE;
			}
			
			if($bool_needs_details_table && isset($this->data['AliquotDetail'])){
				$this->cleanUpFields('AliquotDetail');
				
				// Validates Fields of Details Table
				if(!$this->AliquotDetail->validates($this->data['AliquotDetail'])){
					$submitted_data_validates = FALSE;
				}		
			}

			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			if ($submitted_data_validates) {

				// ** Save Data **
							
				$bool_save_done = TRUE;
		
				// Save ALIQUOTMASTER data
				$aliquot_master_id = NULL;
				
				if($this->AliquotMaster->save($this->data['AliquotMaster'])){
					$aliquot_master_id = $this->AliquotMaster->getLastInsertId();
				} else {
					$bool_save_done = FALSE;
				}
			
				if($bool_save_done && $bool_needs_details_table){
					// Aliquot Detail should be recorded
					
					// Set ID fields based on ALIQUOTMASTER
					$this->data['AliquotDetail']['id'] = $aliquot_master_id;
					$this->data['AliquotDetail']['aliquot_master_id'] = $aliquot_master_id;
					
					// Save ALIQUOTDETAIL data 
					if(!$this->AliquotDetail->save($this->data['AliquotDetail'])){
						$bool_save_done = FALSE;
					}
				}
					
				if(!$bool_save_done){
					$this->redirect('/pages/err_inv_aliquot_record_err'); 
					exit;
				} else {
					// Data has been recorded
					$this->flash(
						'Your data has been saved.',
						'/aliquot_masters/detailAliquot/'.
						$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.
						$collection_id.'/'.$aliquot_master_id.'/');				
				}
											
			} // end action done after validation	
		} // end data save	 		
	
	} // function addAliquot
	
	/**
	 * Allow to add one to many aliquots to a 'Collection Group' sample.s 
	 * (specimen or derivative).
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category.
	 * @param $collection_id Id of the studied collection.
	 * @param $sample_master_id Id of the sample.
	 * @param $aliquot_control_id Aliquot Control Id of either the aliquot to create 
	 * or the new aliquot that allows system to know its type. 
	 * @param $aliquot_nbr Nbr of aliquot to create in the Batch.
	 * 
	 * @author N. Luc
	 * @date 2007-08-13
	 */
	function addAliquotInBatch($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category=null,	
	$collection_id=null, $sample_master_id=null, $aliquot_control_id=null, $aliquot_nbr=1) {
	
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($sample_category) || 
		empty($sample_category) || empty($collection_id) || 
		empty($sample_master_id) || empty($aliquot_control_id) || empty($aliquot_nbr)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}

		if (!is_numeric($aliquot_nbr)) {
			$this->redirect('/pages/err_inv_aliqu_nbr_to_create'); 
			exit;
		}
		
		// Verify collection data exists
		$criteria = 'Collection.id = "'.$collection_id.'" ';		
		$collection_data = $this->Collection->find($criteria);
		
		if(empty($collection_data)) {
			$this->redirect('/pages/err_inv_coll_no_data'); 
			exit;
		}
		
		// Verify sample data exists
		$criteria = 'SampleMaster.id ="'.$sample_master_id.'" AND ' .
				'SampleMaster.collection_id ="'.$collection_id.'"';
		$sample_master = $this->SampleMaster->find($criteria, null, null, 0);

		if(empty($sample_master)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Get the aliquot control id **
		// This id corresponds to the type of the new sample to create.
		if (is_null($aliquot_control_id)) {
			$this->redirect('/pages/err_inv_no_aliqu_cont_id'); 
			exit;			
		}
		
		// ** Load the aliquot type data from ALIQUOT CONTROLS table **
		$this->AliquotControl->id = $aliquot_control_id;
		$aliquot_control_data = $this->AliquotControl->read();
		if(empty($aliquot_control_data)){
			$this->redirect('/pages/err_inv_no_aliqu_cont_data'); 
			exit;		
		}
		
		// ** set FORM variable **
		$this->set('ctrapp_form', 
			$this->Forms->getFormArray($aliquot_control_data['AliquotControl']['form_alias']));
		
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id);
		$this->set('sample_master_id', $sample_master_id);
		$this->set('aliquot_control_id', $aliquot_control_id);

//		$this->set('sample_code', $sample_master['SampleMaster']['sample_code']);
		$this->set('aliquot_type', $aliquot_control_data['AliquotControl']['aliquot_type']);
							
		$this->set('arr_sop_title_from_id', 
			$this->getInventoryProductSopsArray(
				$sample_master['SampleMaster']['sample_type'],
				$aliquot_control_data['AliquotControl']['aliquot_type']));
			
		$this->set('arr_study_from_id', $this->getStudiesArray());
				
		// Set additional data for tissue slide
		$form_requiring_blocks_list = array ('ad_spec_tiss_slides' ,'ad_spec_tiss_cores');

		if (in_array($aliquot_control_data['AliquotControl']['form_alias'], $form_requiring_blocks_list)) {
	
			// Get aliquot control ID of tissue block 
			$criteria = array();
			$criteria['AliquotControl.form_alias'] = 'ad_spec_tiss_blocks';
			$criteria['AliquotControl.status'] = 'active';
			$tmp_aliquot_data = $this->AliquotControl->findAll($criteria);
			if(sizeof($tmp_aliquot_data) != 1) {
				$this->redirect('/pages/err_inv_source_block_definition'); 
				exit;
			}
			$source_aliquot_control_id = $tmp_aliquot_data['0']['AliquotControl']['id'];
			
			// Create array to display available tissue block lists
			$criteria = array();
			$criteria['AliquotMaster.aliquot_control_id'] = $source_aliquot_control_id;
			$criteria['AliquotMaster.status'] = 'available';
			$criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
			$criteria['AliquotMaster.collection_id'] = $collection_id;
			$criteria = array_filter($criteria);
			
			$available_block_code 
				= $this->AliquotMaster->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.AliquotMaster.id', 
					'{n}.AliquotMaster.barcode');

			$this->set('available_block_code', $available_block_code);
		}
		
		// Set additional data for cell core
		$form_requiring_gel_matrix_list = array ('ad_der_cell_cores');

		if (in_array($aliquot_control_data['AliquotControl']['form_alias'], $form_requiring_gel_matrix_list)) {
	
			// Get aliquot control ID of gel matrix 
			$criteria = array();
			$criteria['AliquotControl.form_alias'] = 'ad_der_cel_gel_matrices';
			$criteria['AliquotControl.status'] = 'active';
			$tmp_aliquot_data = $this->AliquotControl->findAll($criteria);
			if(sizeof($tmp_aliquot_data) != 1) {
				$this->redirect('/pages/err_inv_source_gel_matrix_definition'); 
				exit;
			}
			$source_aliquot_control_id = $tmp_aliquot_data['0']['AliquotControl']['id'];
			
			// Create array to display available gel matrix lists
			$criteria = array();
			$criteria['AliquotMaster.aliquot_control_id'] = $source_aliquot_control_id;
			$criteria['AliquotMaster.status'] = 'available';
			$criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
			$criteria['AliquotMaster.collection_id'] = $collection_id;
			$criteria = array_filter($criteria);
			
			$available_gel_matrix_code 
				= $this->AliquotMaster->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.AliquotMaster.id', 
					'{n}.AliquotMaster.barcode');

			$this->set('available_gel_matrix_code', $available_gel_matrix_code);
		}
		
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_al';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_al';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id.'/'.$derivative_sample_master_id.'/');	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
	
		// ** set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id));

		// ** set SIDEBAR variable **
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));

		// ** Initialize AliquotDetail **
		// Plus set boolean to define if details must be recorded in database
		$bool_needs_details_table = FALSE;
		
		if(!is_null($aliquot_control_data['AliquotControl']['detail_tablename'])){
			// This aliquot type has a specific details table
			$bool_needs_details_table = TRUE;
			
			// Create new instance of AliquotDetail model 
			$this->AliquotDetail = 
				new AliquotDetail(false, $aliquot_control_data['AliquotControl']['detail_tablename']);
		} else {
			// This Aliquot type doesn't need a specific details table
			$this->AliquotDetail = NULL;
		}
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}	
				
		if (empty($this->data)) {
			// ** Prepare Form Display **
			
			// Default creation date will be the derivative creation date or Specimen reception date
			$default_storage_date = NULL;
			
			if(strcmp($sample_master['SampleMaster']['sample_category'], 'specimen') == 0) {
				$default_storage_date = $collection_data['Collection']['reception_datetime'];
			} else if(strcmp($sample_master['SampleMaster']['sample_category'], 'derivative') == 0) {
				$criteria = array();
				$criteria['DerivativeDetail.sample_master_id'] = $sample_master_id;
				$derivative_detail_data = $this->DerivativeDetail->find($criteria);
				
				if(empty($derivative_detail_data)){
					$this->redirect('/pages/err_inv_missing_samp_data'); 
					exit;
				}
				
				$default_storage_date = $derivative_detail_data['DerivativeDetail']['creation_datetime'];
			} else {
				$this->redirect('/pages/err_inv_system_error'); 
				exit;				
			}
			
			$this->set('default_storage_date', $default_storage_date);
		
			// Build an empty array of 5 records 	
			$aliquot_masters = array();
			
			for($ind=0; $ind < $aliquot_nbr ; $ind++){
				
				$aliquot_masters[$ind] = 
					array('AliquotMaster' => 
						array(
							'id' => NULL,
							'aliquot_type' => $aliquot_control_data['AliquotControl']['aliquot_type']));
				
				// Add volume unit if required
				if(!is_null($aliquot_control_data['AliquotControl']['volume_unit'])) {
					$aliquot_masters[$ind]['AliquotMaster']['aliquot_volume_unit'] 
						= $aliquot_control_data['AliquotControl']['volume_unit'];
				}
			} 
			
			$this->data = $aliquot_masters;
			
			$this->set('data', $aliquot_masters);
			
			// The storage list will be empty to force user to enter first a storage selection label
			$this->set('arr_storage_list', array());		
			$_SESSION['ctrapp_core']['inventory_management']['arr_storage_list'] = array(); 
			
		} else {

			// New aliquots have to be created
	
			// ** Manage the save of the data	**
		
			// 1- Manage copy and track barcode
			$bool_copy_done = FALSE;
			$arr_new_barcode = array();			
			foreach($this->data as $id => $new_studied_aliquot){

				$this->cleanUpDatagridFields($id, 'AliquotMaster');	
				
				if((strcmp($new_studied_aliquot['FunctionManagement']['generated_field_copy_prev_line'], 'yes') == 0)
				&& ($id > 0)) {
					// The new record should be a copy of the previous record
					$this->data[$id] = $this->data[($id-1)];
					$bool_copy_done = TRUE;						
				}
				
				if(!empty($new_studied_aliquot['AliquotMaster']['barcode'])){
					// Track barcode for futur check
					$arr_new_barcode[] = $new_studied_aliquot['AliquotMaster']['barcode'];
				}
				
			}		
			
			if($bool_copy_done){
				// Redisplay the screen with the copied data
				// Nothing to do
				$this->set('arr_storage_list', 
					$_SESSION['ctrapp_core']['inventory_management']['arr_storage_list']);
								
			} else {
							
				//2- Run Validation and set value that have not to be defined by the user
				
				// setup MODEL(s) validation array(s) for displayed FORM 
				foreach ($this->Forms->getValidateArray($aliquot_control_data['AliquotControl']['form_alias']) as $validate_model=>$validate_rules) {
					$this->{$validate_model}->validate = $validate_rules;
				}
			
				// Get duplicated barcodes or barcode too long
				$arr_barcodes_in_error = $this->validateAliquotBarcode($arr_new_barcode);
				
				// Set Flag
				$submitted_data_validates = TRUE;
				
				$storage_control_errors = array();
				$arr_storage_list = array();	
				
				foreach($this->data as $id => $new_studied_aliquot){
					// New aliquot that has to be created
					
					// A- Check Barcode
					
					// Erase barcode data if this one is duplicated (for form field validation)
					if(in_array($this->data[$id]['AliquotMaster']['barcode'], $arr_barcodes_in_error)){
						// This barcode already exists, flush the barcode
						//$new_studied_aliquot['AliquotMaster']['barcode'] = '';
						$this->data[$id]['AliquotMaster']['barcode'] = '';
					}
					
					// B- Check the user storage defintion (selection label / storage_master_id)
					$recorded_selection_label = $this->data[$id]['FunctionManagement']['storage_selection_label'];
					$returned_storage_id = $this->data[$id]['AliquotMaster']['storage_master_id'];

					$arr_storage_selection_results = $this->validateStorageIdAndSelectionLabel($recorded_selection_label, $returned_storage_id);

					$this->data[$id]['AliquotMaster']['storage_master_id'] = $arr_storage_selection_results['defined_storage_id'];
					$arr_storage_list = $arr_storage_list + $arr_storage_selection_results['aliquot_arr_storage_list'];
					if(!$arr_storage_selection_results['submitted_data_validates']){
						$submitted_data_validates = false;
					}
					$storage_control_errors = $storage_control_errors + $arr_storage_selection_results['storage_control_errors'];			
					
					// C- Check Aliquot Storage Coordinates
					$arr_storage_coord_results = $this->validateStorageCoordinates(
							$this->data[$id]['AliquotMaster']['storage_master_id'], 
							$this->data[$id]['AliquotMaster']['storage_coord_x'], 
							$this->data[$id]['AliquotMaster']['storage_coord_y']);
						
					$this->data[$id]['AliquotMaster']['storage_coord_x'] = $arr_storage_coord_results['validated_storage_coord_x'];
					$this->data[$id]['AliquotMaster']['storage_coord_y'] = $arr_storage_coord_results['validated_storage_coord_y'];
					if(!$arr_storage_coord_results['submitted_data_validates']){
						$submitted_data_validates = false;
					}
					$storage_control_errors = $storage_control_errors + $arr_storage_coord_results['storage_control_errors'];		
					
					// D- Set Initial Volume
				
					// Set current volume
					if(isset($this->data[$id]['AliquotMaster']['initial_volume'])){	
						
						if(is_null($aliquot_control_data['AliquotControl']['volume_unit'])){
							$this->redirect('/pages/err_inv_system_error'); 
							exit;
						}
		
						// Set the current volume with the initial volume
						$this->data[$id]['AliquotMaster']['current_volume'] =
							$this->data[$id]['AliquotMaster']['initial_volume'];				
		
					}
					
					// E- Launch Validation
				
					// Validates Fields of Aliquot Master Table
					if(!$this->AliquotMaster->validates($this->data[$id]['AliquotMaster'])){
						$submitted_data_validates = FALSE;
					}
					if($bool_needs_details_table && isset($this->data[$id]['AliquotDetail'])){
						// Validates Fields of Aliquot Detail Table
						if(!$this->AliquotDetail->validates($this->data[$id]['AliquotDetail'])){
							$submitted_data_validates = FALSE;
						}	
					}

				} // End foreach to validate all new aliquot record
				
				// Set array of selectable storage
				$this->set('arr_storage_list', $arr_storage_list);	
				$_SESSION['ctrapp_core']['inventory_management']['arr_storage_list'] = $arr_storage_list; 
								
				// Set storage errors
				foreach($storage_control_errors as $id => $msg) {
					$this->AliquotMaster->validationErrors[] 
						= $msg;
				}
				
				// look for CUSTOM HOOKS, "validation"
				$custom_ctrapp_controller_hook 
					= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
					'controllers' . DS . 'hooks' . DS . 
					$this->params['controller'].'_'.$this->params['action'].'_validation.php';
				
				if (file_exists($custom_ctrapp_controller_hook)) {
					require($custom_ctrapp_controller_hook);
				}
				
				if ($submitted_data_validates) {
					
					//3- Save data
					foreach($this->data as $id => $new_studied_aliquot){

						$bool_save_done = TRUE;
				
						// Save ALIQUOTMASTER data
						$this->data[$id]['AliquotMaster']['id'] = NULL;

						if($this->AliquotMaster->save($this->data[$id]['AliquotMaster'])){
							$aliquot_master_id = $this->AliquotMaster->getLastInsertId();
						} else {
							$bool_save_done = FALSE;
						}
						
						if($bool_save_done && $bool_needs_details_table){
							// Aliquot Detail should be recorded
							
							// Set ID fields based on ALIQUOTMASTER
							$this->data[$id]['AliquotDetail']['id'] = $aliquot_master_id;
							$this->data[$id]['AliquotDetail']['aliquot_master_id'] = $aliquot_master_id;
							
							// Save ALIQUOTDETAIL data 
							if(!$this->AliquotDetail->save($this->data[$id]['AliquotDetail'])){
								$bool_save_done = FALSE;
							}
						}
							
						if(!$bool_save_done){
							break;
						}
					} // End foreach to save each new record

					if(!$bool_save_done){
						$this->redirect('/pages/err_inv_aliquot_record_err'); 
						exit;
					} else {
						// Data have been created
				
						// Data has been updated
						$this->flash(
							'Your data has been saved.',
							'/aliquot_masters/listAllSampleAliquots/'
								.$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.
								$collection_id.'/'.$sample_master_id.'/');
					}	

				} // End save action done after validation
			} // End section done when no copy has to be done (validation + save)
		} // End data save management (manage copy + validation + save)	 		
	} // function addAliquotInBatch
		
	/**
	 * Allow to display the aliquot details form when we just have the 
	 * aliquot_master_id.
	 * 
	 * This function will look for the different menu items to display.
	 * 
	 * Note: This function is a temporary function and should be replaced by a 
	 * core function.
	 * 
	 * @param $aliquot_master_id Master Id of the aliquot. 
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function detailAliquotFromId($aliquot_master_id=null){
		
		//** Verify aliquot_master_id has been defined. **
		if (empty($aliquot_master_id)) {
			$this->redirect('/pages/err_inv_aliquot_no_id'); 
			exit;
		} 
		
		// Get aliquot data
		$this->AliquotMaster->id = $aliquot_master_id;
		$aliquot_master_data = $this->AliquotMaster->read();
		
		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
		
		// Look for sample data
		$this->SampleMaster->id = $aliquot_master_data['AliquotMaster']['sample_master_id'];
		$sample_master_data = $this->SampleMaster->read();
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}		
		
		//** Set URL parameters ** 
		$specimen_group_menu_id=NULL;
		$group_specimen_type=$sample_master_data['SampleMaster']['initial_specimen_sample_type'];
		$sample_category=$sample_master_data['SampleMaster']['sample_category'];
		$collection_id=$sample_master_data['SampleMaster']['collection_id'];
		
		// Set $specimen_group_menu_id
		$a_fields = array('id');
		$conditions = ' Menu.parent_id = \'inv_CAN_10\'' .
				' AND Menu.use_link LIKE \'%/sample_masters/listall/%/'.$group_specimen_type.'/specimen/\'';
		$a_menus = $this->Menu->find($conditions, $a_fields);
				
		if(empty($a_menus)){
			$this->redirect('/pages/err_inv_menu_definition'); 
			exit;
		}
		
		$specimen_group_menu_id = $a_menus['Menu']['id'];
				
		//** Redirect to **
		$this->redirect('/inventorymanagement/aliquot_masters/detailAliquot/'.
			$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.
			$collection_id.'/'.$aliquot_master_id.'/');
					
	}
	
	function detailAliquot($collection_id=null, $sample_master_id=null, $aliquot_master_id=null) {
		$this->set( 'atim_menu_variables', array('Collection.id'=>$collection_id, 'SampleMaster.id'=>$sample_master_id, 'AliquotMaster.id'=>$aliquot_master_id) );
		$this->data = $this->AliquotMaster->find('first',array('conditions'=>array('AliquotMaster.id'=>$aliquot_master_id)));
		
		$this->set( 'atim_structure', $this->Structures->get('form',$this->data['AliquotControl']['form_alias']) );
		
	}
	
	/**
	 * Display the detail of a sample aliquot of a 'collection group'.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category.
	 * @param $collection_id Id of the studied collection.
	 * @param $aliquot_master_id Master Id of the aliquot. 
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function detailAliquot_OLD($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null) {
			
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}

		//** Get the aliquot master data **
		
		// First update current volume of the aliquot
		
		// TODO: Not necessary if all functions that manage an aliquot use volume 
		// (changing the aliquot current volume) called this function
		// updateAliquotCurrentVolume()
		
		$this->updateAliquotCurrentVolume($aliquot_master_id);
		
		// Get data
		$this->AliquotMaster->id = $aliquot_master_id;
		$aliquot_master_data = $this->AliquotMaster->read();
		
		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
		
		if(strcmp($aliquot_master_data['AliquotMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		//** Get the aliquot sample master data **
		
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];
		
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}	
		
		//** Get the aliquot collection data **
		$criteria = array();
		$criteria['Collection.id'] = $collection_id;
		$collection_data = $this->Collection->find($criteria, null, null, 0);
			
		if(empty($collection_data)) {
			$this->redirect('/pages/err_inv_coll_no_data'); 
			exit;
		}
		
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id, $aliquot_master_id));
	
		//** set SIDEBAR variable **
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
				
		//** Get the aliquot control data **
		$aliquot_control_id = $aliquot_master_data['AliquotMaster']['aliquot_control_id'];
		$this->AliquotControl->id = $aliquot_control_id;
		$aliquot_control_data = $this->AliquotControl->read();
		
		if(empty($aliquot_control_data)){
			$this->redirect('/pages/err_inv_no_aliqu_cont_data'); 
			exit;	
		}				
			
		// ** set FORM variable *
		$this->set('ctrapp_form_aliquot', 
			$this->Forms->getFormArray($aliquot_control_data['AliquotControl']['form_alias']));
				
		//** set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-sa_al_de';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-der_al_de';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id.'/'.$derivative_sample_master_id.'/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $derivative_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
	
		// ** set DATA to display on view or to build link **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id);

//		$this->set('sample_code', $sample_master_data['SampleMaster']['sample_code']);
			
		$this->set('arr_sop_title_from_id', 
			$this->getInventoryProductSopsArray(
				$sample_master_data['SampleMaster']['sample_type'],
				$aliquot_control_data['AliquotControl']['aliquot_type']));
			
		$this->set('arr_study_from_id', $this->getStudiesArray());

		// Set the number of aliquot use
		$aliquot_use 
			= sizeof($aliquot_master_data['AliquotUse'])? 
				sizeof($aliquot_master_data['AliquotUse']): 
				'0';
		
		$aliquot_master_data['Generated']['generated_field_use'] = $aliquot_use;

		// Set times spent since sample collection/reception or sample creation 
		// and sample storage			
		$aliquot_storage_date = $aliquot_master_data['AliquotMaster']['storage_datetime'];
		
		if(strcmp($sample_master_data['SampleMaster']['sample_category'], 'specimen') == 0) {
			//SPECIMEN: calculate coll_to_stor_spent_time
			
			$specimen_collection_date = $collection_data['Collection']['collection_datetime'];
			$specimen_reception_date = $collection_data['Collection']['reception_datetime'];
		
			$arr_spent_time = $this->getSpentTime($specimen_collection_date, $aliquot_storage_date);
			
			$this->set('coll_to_stor_spent_time_msg', $arr_spent_time['message']);
			$aliquot_master_data['Calculated']['coll_to_stor_spent_time_days'] = $arr_spent_time['days'];
			$aliquot_master_data['Calculated']['coll_to_stor_spent_time_hours'] = $arr_spent_time['hours'];
			$aliquot_master_data['Calculated']['coll_to_stor_spent_time_minutes'] = $arr_spent_time['minutes'];
			
			$arr_spent_time = $this->getSpentTime($specimen_reception_date, $aliquot_storage_date);
			
			$this->set('rec_to_stor_spent_time_msg', $arr_spent_time['message']);
			$aliquot_master_data['Calculated']['rec_to_stor_spent_time_days'] = $arr_spent_time['days'];
			$aliquot_master_data['Calculated']['rec_to_stor_spent_time_hours'] = $arr_spent_time['hours'];
			$aliquot_master_data['Calculated']['rec_to_stor_spent_time_minutes'] = $arr_spent_time['minutes'];
			
		} else if(strcmp($sample_master_data['SampleMaster']['sample_category'], 'derivative') == 0){
			
			//DERIVATIVE: calculate creat_to_stor_spent_time
			
			$criteria = array();
			$criteria['DerivativeDetail.sample_master_id'] = $sample_master_id;
			
			$derivative_detail_data = $this->DerivativeDetail->find($criteria);
			
			if(empty($derivative_detail_data)){
				$this->redirect('/pages/err_inv_missing_samp_data'); 
				exit;
			}
			
			$sample_creation_date = $derivative_detail_data['DerivativeDetail']['creation_datetime'];
			
			$arr_spent_time = $this->getSpentTime($sample_creation_date, $aliquot_storage_date);
			
			$this->set('creat_to_stor_spent_time_msg', $arr_spent_time['message']);
			$aliquot_master_data['Calculated']['creat_to_stor_spent_time_days'] = $arr_spent_time['days'];
			$aliquot_master_data['Calculated']['creat_to_stor_spent_time_hours'] = $arr_spent_time['hours'];
			$aliquot_master_data['Calculated']['creat_to_stor_spent_time_minutes'] = $arr_spent_time['minutes'];
			
		} else {
			$this->redirect('/pages/err_inv_system_error'); 
			exit;			
		}
		
		// ** Set Aliquot Data **
		
		if(is_null($aliquot_control_data['AliquotControl']['detail_tablename'])){
			// No detail required for this aliquot
			$this->set('data', $aliquot_master_data); 

		} else {
			// Details are required for this aliquot
			
			// start new instance of ALIQUOT DETAIL model, using TABLENAME from ALIQUOT CONTROL 
			$this->AliquotDetail = 
				new AliquotDetail(false, $aliquot_control_data['AliquotControl']['detail_tablename']);
			
			// read related ALIQUOT DETAIL row, whose ID should be same as ALIQUOT MASTER ID 
			$this->AliquotDetail->id = $aliquot_master_id;
			$aliquot_detail_data = $this->AliquotDetail->read();
			
			if(empty($aliquot_detail_data)){
				$this->redirect('/pages/err_inv_missing_aliq_data'); 
				exit;
			}
			
			// merge both datasets into a SINGLE dataset, set for VIEW 
			$this->set('data', array_merge($aliquot_master_data, $aliquot_detail_data));
			
			// Set additional variable for tissue slide
			$form_requiring_blocks_list = array ('ad_spec_tiss_slides' ,'ad_spec_tiss_cores');
	
			if (in_array($aliquot_control_data['AliquotControl']['form_alias'], $form_requiring_blocks_list)) {
				
				// Create array to display available tissue block lists
				$criteria = array();
				$criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
				$criteria['AliquotMaster.collection_id'] = $collection_id;				
				$criteria['AliquotMaster.id'] 
					= $aliquot_detail_data['AliquotDetail']['ad_block_id']; // Aliquot Master ID should be equal to Details ID
				$criteria = array_filter($criteria);
				
				$available_block_code 
					= $this->AliquotMaster->generateList(
						$criteria, 
						null, 
						null, 
						'{n}.AliquotMaster.id', 
						'{n}.AliquotMaster.barcode');
				
				$this->set('available_block_code', $available_block_code);
				
			} 
			
			// Set additional data for cell core
			$form_requiring_gel_matrix_list = array ('ad_der_cell_cores');
	
			if (in_array($aliquot_control_data['AliquotControl']['form_alias'], $form_requiring_gel_matrix_list)) {
				
				// Create array to display available gel matrix lists
				$criteria = array();
				$criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
				$criteria['AliquotMaster.collection_id'] = $collection_id;	
				$criteria['AliquotMaster.id'] 
					= $aliquot_detail_data['AliquotDetail']['ad_gel_matrix_id']; // Aliquot Master ID should be equal to Details ID
				$criteria = array_filter($criteria);
				
				$available_gel_matrix_code 
					= $this->AliquotMaster->generateList(
						$criteria, 
						null, 
						null, 
						'{n}.AliquotMaster.id', 
						'{n}.AliquotMaster.barcode');

				$this->set('available_gel_matrix_code', $available_gel_matrix_code);
				
			} 
		}
		
		// ** Manage available actions (delete, define position, etc) **
		
		// Define if user can define aliquot position into the storage: use to display the set position button
		$boolDefinePosition = FALSE;
		
		if(!empty($aliquot_master_data['AliquotMaster']['storage_master_id'])){ 
			$boolDefinePosition = $this->requestAction('/storagelayout/storage_masters/isPositionSelectionAvailable/'.
				$aliquot_master_data['AliquotMaster']['storage_master_id']);
		}
		
		$this->set('boolDefinePosition', $boolDefinePosition);
		
		// Define if user can delete aliquot: use to display the set delete button
		$this->set('boolAllowDeletion', $this->allowAliquotDeletion($aliquot_master_id));
		
		// Define if user can link the aliquot to an order
		$boolAllowOrder = FALSE;
		
		$criteria = 'OrderItem.aliquot_master_id ="' .$aliquot_master_id.'"';			 
		$aliquot_order_nbr = $this->OrderItem->findCount($criteria);
		
		if($aliquot_order_nbr == 0) {
			$boolAllowOrder = TRUE;			
		}
		
		$this->set('boolAllowOrder', $boolAllowOrder);
		
		// Define if user can delete aliquot: use to display the set delete button
		$this->set('boolAllowDeletion', $this->allowAliquotDeletion($aliquot_master_id));
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
	} // function detailAliquot
	
	function editAliquot($collection_id=null, $sample_master_id=null, $aliquot_master_id=null) {
		$this->set( 'atim_menu_variables', array('Collection.id'=>$collection_id, 'SampleMaster.id'=>$sample_master_id, 'AliquotMaster.id'=>$aliquot_master_id) );
		
		$this_data = $this->AliquotMaster->find('first',array('conditions'=>array('AliquotMaster.id'=>$aliquot_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->set( 'atim_structure', $this->Structures->get('form',$this_data['AliquotControl']['form_alias']) );
		
		if ( !empty($this->data) ) {
			$this->AliquotMaster->id = $sample_master_id;
			if ( $this->AliquotMaster->save($this->data) ) $this->flash( 'Your data has been updated.','/inventorymanagement/aliquot_masters/detailAliquot/'.$collection_id.'/'.$sample_master_id.'/'.$aliquot_master_id);
		} else {
			$this->data = $this_data;
		}
	
	}
	
	/**
	 * Allow to edit a aliquot. 
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category.
	 * @param $collection_id Id of the studied collection.
	 * @param $aliquot_master_id Master Id of the aliquot. 
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function editAliquot_OLD($specimen_group_menu_id=NULL,  $group_specimen_type=NULL, $sample_category=null, 
	$collection_id=null, $aliquot_master_id=null) {
			
		// ** Get the sample master id **
		if(isset($this->data['AliquotMaster']['id'])) {
			//User clicked on the Submit button to modify the edited collection
			$aliquot_master_id = $this->data['AliquotMaster']['id'];
		}
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Load  ALIQUOT MASTER info **
		$this->AliquotMaster->id = $aliquot_master_id;
		$aliquot_master_data = $this->AliquotMaster->read();

		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}

		if(strcmp($aliquot_master_data['AliquotMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		//** Get the aliquot sample master data **
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];

		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}

		// ** Load the aliquot type data from ALIQUOT CONTROLS table **
		$this->AliquotControl->id = $aliquot_master_data['AliquotMaster']['aliquot_control_id'];
		$aliquot_control_data = $this->AliquotControl->read();
	
		if(empty($aliquot_control_data)){
			$this->redirect('/pages/err_inv_no_aliqu_cont_data'); 
			exit;	
		}	
		
		// ** set SUMMARY varible from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id, $aliquot_master_id));

		// ** set SIDEBAR variable **
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));

		// ** set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray($aliquot_control_data['AliquotControl']['form_alias']));

		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id);
//		$this->set('sample_code', $sample_master_data['SampleMaster']['sample_code']);
				
		$this->set('arr_sop_title_from_id', 
			$this->getInventoryProductSopsArray(
				$sample_master_data['SampleMaster']['sample_type'],
				$aliquot_control_data['AliquotControl']['aliquot_type']));
			
		$this->set('arr_study_from_id', $this->getStudiesArray());

		// Set additional data for tissue slide
		$form_requiring_blocks_list = array ('ad_spec_tiss_slides' ,'ad_spec_tiss_cores');

		if (in_array($aliquot_control_data['AliquotControl']['form_alias'], $form_requiring_blocks_list)) {
			
			// Get aliquot control ID of tissue block 
			$criteria = array();
			$criteria['AliquotControl.form_alias'] = 'ad_spec_tiss_blocks';
			$criteria['AliquotControl.status'] = 'active';
			$tmp_aliquot_data = $this->AliquotControl->findAll($criteria);
			if(sizeof($tmp_aliquot_data) != 1) {
				$this->redirect('/pages/err_inv_source_block_definition'); 
				exit;
			}
			$source_aliquot_control_id = $tmp_aliquot_data['0']['AliquotControl']['id'];
			
			// Create array to display available tissue block lists
			$criteria = array();
			$criteria['AliquotMaster.aliquot_control_id'] = $source_aliquot_control_id;
			$criteria['AliquotMaster.status'] = 'available';
			$criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
			$criteria['AliquotMaster.collection_id'] = $collection_id;
			$criteria = array_filter($criteria);
			
			$available_block_code = $this->AliquotMaster->generateList($criteria, 
													null, 
													null, 
													'{n}.AliquotMaster.id', 
													'{n}.AliquotMaster.barcode');
			
			$this->set('available_block_code', $available_block_code);
			
		}
		
		// Set additional data for cell core
		$form_requiring_gel_matrix_list = array ('ad_der_cell_cores');

		if (in_array($aliquot_control_data['AliquotControl']['form_alias'], $form_requiring_gel_matrix_list)) {
	
			// Get aliquot control ID of gel matrix 
			$criteria = array();
			$criteria['AliquotControl.form_alias'] = 'ad_der_cel_gel_matrices';
			$criteria['AliquotControl.status'] = 'active';
			$tmp_aliquot_data = $this->AliquotControl->findAll($criteria);
			if(sizeof($tmp_aliquot_data) != 1) {
				$this->redirect('/pages/err_inv_source_gel_matrix_definition'); 
				exit;
			}
			$source_aliquot_control_id = $tmp_aliquot_data['0']['AliquotControl']['id'];
			
			// Create array to display available gel matrix lists
			$criteria = array();
			$criteria['AliquotMaster.aliquot_control_id'] = $source_aliquot_control_id;
			$criteria['AliquotMaster.status'] = 'available';
			$criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
			$criteria['AliquotMaster.collection_id'] = $collection_id;
			$criteria = array_filter($criteria);
			
			$available_gel_matrix_code 
				= $this->AliquotMaster->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.AliquotMaster.id', 
					'{n}.AliquotMaster.barcode');

			$this->set('available_gel_matrix_code', $available_gel_matrix_code);
		}
		
		// ** set MENU variable for echo on VIEW ** 
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-sa_al_de';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-der_al_de';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id.'/'.$derivative_sample_master_id.'/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $derivative_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
	
		// ** Initialize AliquotDetail **
		// Plus set boolean to define if details must be recorded in database
		$bool_needs_details_table = FALSE;
		
		if(!is_null($aliquot_control_data['AliquotControl']['detail_tablename'])){
			// This aliquot type has a specific details table
			$bool_needs_details_table = TRUE;
			
			// Create new instance of AliquotDetail model 
			$this->AliquotDetail = 
				new AliquotDetail(false, $aliquot_control_data['AliquotControl']['detail_tablename']);

			// Load related ALIQUOT DETAIL row, whose ID should be the same as ALIQUOT MASTER ID
			$this->AliquotDetail->id = $aliquot_master_id;
			$aliquot_detail_data = $this->AliquotDetail->read();
			
			if(empty($aliquot_detail_data)){
				$this->redirect('/pages/err_inv_missing_aliq_data'); 
				exit;
			}
			
		} else {
			// This aliquot type doesn't need a specific details table
			$this->AliquotDetail = NULL;
			
		}
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}	
				
		if (empty($this->data)) {
			// ** EDIT DATA **
			 
			// Build the list of storage to select
			$aliquot_storage_id = $aliquot_master_data['AliquotMaster']['storage_master_id'];
			
			$arr_storage_list = array();
			if(!empty($aliquot_storage_id)){
				$arr_storage_list 
					= array($aliquot_storage_id 
						=> $this->requestAction('/storagelayout/storage_masters/getStorageData/'.$aliquot_storage_id));	
			}
				
			$this->set('arr_storage_list', $arr_storage_list);	
				
			// set data
			if(!empty($bool_needs_details_table)){
				// A aliquot detail table is defined for the sample type.
				// Merge both datasets into a SINGLE dataset, set for VIEW.
				$this->data = array_merge($aliquot_master_data, $aliquot_detail_data);	
			} else {
				// all the aliquot data are recorded into the master table.
				$this->data = $aliquot_master_data;
			}	
			
			$this->set('data', $this->data);	
			
		} else {
			// ** SAVE DATA **
				
			// ** Check the user storage defintion (selection label / storage_master_id) **
			
			$recorded_selection_label = $this->data['FunctionManagement']['storage_selection_label'];
			$returned_storage_id = $this->data['AliquotMaster']['storage_master_id'];
				
			$problem_in_the_storage_defintion = false;
			$arr_storage_list = array();
			$storage_control_errors = array();
	
			$arr_storage_selection_results 
				= $this->validateStorageIdAndSelectionLabel($recorded_selection_label, $returned_storage_id);
			$this->data['AliquotMaster']['storage_master_id'] = $arr_storage_selection_results['defined_storage_id'];
			$arr_storage_list = $arr_storage_selection_results['aliquot_arr_storage_list'];
			if(!$arr_storage_selection_results['submitted_data_validates']){
				$problem_in_the_storage_defintion = true;
			}
			$storage_control_errors = $arr_storage_selection_results['storage_control_errors'];
			
			$this->set('arr_storage_list', $arr_storage_list);	
			
			// ** Verify set aliquot coordinates into storage **
			
			$arr_storage_coord_results 
				= $this->validateStorageCoordinates(
					$this->data['AliquotMaster']['storage_master_id'], 
					$this->data['AliquotMaster']['storage_coord_x'], 
					$this->data['AliquotMaster']['storage_coord_y']);
			
			$this->data['AliquotMaster']['storage_coord_x'] = $arr_storage_coord_results['validated_storage_coord_x'];
			$this->data['AliquotMaster']['storage_coord_y'] = $arr_storage_coord_results['validated_storage_coord_y'];
			if(!$arr_storage_coord_results['submitted_data_validates']){
				$problem_in_the_storage_defintion = true;
			}
			$storage_control_errors = $storage_control_errors + $arr_storage_coord_results['storage_control_errors'];	

			// Set storage errors
			foreach($storage_control_errors as $id => $msg) {
				$this->AliquotMaster->validationErrors[$id] = $msg;
			}
			
			// ** Set value that have not to be defined by the user **
			
			if(isset($this->data['AliquotMaster']['initial_volume'])){	
				// Flush volume data when enterred data is empty
				
				if(is_null($aliquot_control_data['AliquotControl']['volume_unit'])){
					$this->redirect('/pages/err_inv_system_error'); 
					exit;
				}

				$initial_volume = $this->data['AliquotMaster']['initial_volume'];
				
				if((empty($initial_volume) && (!is_numeric($initial_volume)))){
					// Means initial volume should be set to NULL
					$this->data['AliquotMaster']['initial_volume'] = NULL;					
					$this->data['AliquotMaster']['current_volume'] = NULL;
				}		

			}

			// ** Execute Validation **
						
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray( $aliquot_control_data['AliquotControl']['form_alias'] ) as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			$submitted_data_validates = TRUE;		

			if($problem_in_the_storage_defintion) {
				// The aliquot storage has not been correclty defined
				$submitted_data_validates = FALSE;				
			}
			
			// Validates Fields of Master Table
			$this->cleanUpFields('AliquotMaster');
			
			if(!$this->AliquotMaster->validates($this->data['AliquotMaster'])){
				$submitted_data_validates = FALSE;
			}
			
			if($bool_needs_details_table && isset($this->data['AliquotDetail'])){
				$this->cleanUpFields('AliquotDetail');
				
				// Validates Fields of Details Table
				if(!$this->AliquotDetail->validates($this->data['AliquotDetail'])){
					$submitted_data_validates = FALSE;
				}		
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
					
			if ($submitted_data_validates) {
				
				// ** Save Data **
							
				$bool_save_done = TRUE;
		
				// Save ALIQUOTMASTER data
				if(!$this->AliquotMaster->save($this->data['AliquotMaster'])){
					$bool_save_done = FALSE;
				} else {					
					// Update current volume
					$this->updateAliquotCurrentVolume($aliquot_master_id);
				}
				
				if($bool_save_done && $bool_needs_details_table && isset($this->data['AliquotDetail'])){			
					// Aliquot Detail should be recorded
					
					// Set ID fields based on ALIQUOTMASTER
					$this->data['AliquotDetail']['id'] = $aliquot_master_id;
					
					// Save ALIQUOTDETAIL data 
					if(!$this->AliquotDetail->save($this->data['AliquotDetail'])){
						$bool_save_done = FALSE;
					}
				}
					
				if(!$bool_save_done){
					$this->redirect('/pages/err_inv_aliquot_record_err'); 
					exit;
				} else {
					// Data has been updated
					$this->Flash('Your data has been updated.',
						'/aliquot_masters/detailAliquot/'.
							$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.
							$collection_id.'/'.$aliquot_master_id.'/');				
				}
											
			} // end action done after validation
		} // end data save	 		
	
	} // function editAliquot
	
	/**
	 * Allow to delete the storage data of a aliquot. 
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Id of the studied collection.
	 * @param $collection_id Id of the studied collection.
	 * @param $aliquot_master_id Master Id of the aliquot. 
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function deleteAliquotStorageData($specimen_group_menu_id=NULL,  $group_specimen_type=NULL, $sample_category=null, 
	$collection_id=null, $aliquot_master_id=null) {
	
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) ||empty($collection_id) || empty($aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Load  ALIQUOT MASTER info **
		$this->AliquotMaster->id = $aliquot_master_id;
		$aliquot_master_data = $this->AliquotMaster->read();

		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
		
		if(strcmp($aliquot_master_data['AliquotMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		$aliquot_master_data['AliquotMaster']['storage_master_id'] = NULL;
		$aliquot_master_data['AliquotMaster']['storage_coord_x'] = NULL;
		$aliquot_master_data['AliquotMaster']['storage_coord_y'] = NULL;
		
		$aliquot_master_data['AliquotMaster']['modified'] = date('Y-m-d G:i');
		$aliquot_master_data['AliquotMaster']['modified_by'] = $this->othAuth->user('id');
		
		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		if(!$this->AliquotMaster->save($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_record_err'); 
		} else {
			$this->Flash('Your data has been deleted.',
				'/aliquot_masters/detailAliquot/'.
					$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.
					$collection_id.'/'.$aliquot_master_id.'/');
		}
		
	} // function deleteAliquotStorageData
	
	/**
	 * Allow to delete a aliquot of a collection group sample.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_categroy Sample Category.
	 * @param $collection_id Id of the studied collection.
	 * @param $aliquot_master_id Master Id of the aliquot. 
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function deleteAliquot($specimen_group_menu_id=NULL,  $group_specimen_type=NULL, $sample_category=null, 
	$collection_id=null, $aliquot_master_id=null) {
			
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Load  ALIQUOT MASTER info **
		$this->AliquotMaster->id = $aliquot_master_id;
		$aliquot_master_data = $this->AliquotMaster->read();

		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}

		if(strcmp($aliquot_master_data['AliquotMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		// Verify aliquot can be deleted
		if(!$this->allowAliquotDeletion($aliquot_master_id)){
			$this->redirect('/pages/err_inv_aliqu_del_forbid'); 
			exit;
		}

		// Look for sample master id
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];

		//Look for aliquot control table
		$this->AliquotControl->id = $aliquot_master_data['AliquotMaster']['aliquot_control_id'];
		$aliquot_control_data = $this->AliquotControl->read();
	
		if(empty($aliquot_control_data)){
			$this->redirect('/pages/err_inv_no_aliqu_cont_data'); 
			exit;	
		}	

		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		//Delete aliquot
		$bool_delete_aliquot = TRUE;
		
		if(!is_null($aliquot_control_data['AliquotControl']['form_alias'])){
			// This aliquot has specific data
			$this->AliquotDetail = new AliquotDetail(false, $aliquot_control_data['AliquotControl']['detail_tablename']);
			
			if(!$this->AliquotDetail->del($aliquot_master_id)){
				$bool_delete_aliquot = FALSE;		
			}			
		}
			
		if($bool_delete_aliquot){
			if(!$this->AliquotMaster->del($aliquot_master_id)){
				$bool_delete_aliquot = FALSE;		
			}	
		}
		
		if(!$bool_delete_aliquot){exit;
			$this->redirect('/pages/err_inv_aliqu_del_err'); 
			exit;
		}
		
		$this->Flash('Your data has been deleted.',
			'/aliquot_masters/listAllSampleAliquots/'.
			$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.
			$collection_id.'/'.$sample_master_id.'/');
	
	} //end deleteAliquot

	/* --------------------------------------------------------------------------
	 * SOURCE ALIQUOTS FUNCTIONS
	 * -------------------------------------------------------------------------- */	
		
	/**
	 * Allow to list all parent sample aliquots
	 * used to create the derivative.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category.
	 * @param $collection_id Id of the studied collection.
	 * @param $sample_master_id Id of the derivative.
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function listSourceAliquots($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category=NULL, 
	$collection_id=null, $sample_master_id=null) {

		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || 
		empty($sample_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// read SAMPLE MASTER info
		$criteria = 'SampleMaster.id ="'.$sample_master_id.'"';
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
				
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		if(strcmp($sample_master_data['SampleMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		if(strcmp($sample_master_data['SampleMaster']['sample_category'], 'specimen') == 0){
			$this->redirect('/pages/err_inv_no_source_for_specimen'); 
			exit;	
		}
		
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('source_aliquots_list'));
		
		// ** Set DATA for echo on view **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id );
		$this->set('sample_master_id', $sample_master_id);

//		$this->set('sample_code', $sample_master_data['SampleMaster']['sample_code']);
		
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_so_al';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id.'/'.$derivative_sample_master_id.'/');	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
	
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id));
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
		

		// ** Search aliquot data to display in the list **
			
		// Search aliquots that have been used to create the derivative
		// Note: Normaly a aliquot can be used once for the creation of
		// a specifc derivative.
		
		$criteria = array();
		$criteria['sample_master_id'] = $sample_master_id;

		$use_id_from_source_aliquot_id = 
			$this->SourceAliquot->generateList(
				$criteria, 
				null, 
				null, 
				'{n}.SourceAliquot.aliquot_master_id', 
				'{n}.SourceAliquot.aliquot_use_id');
											
		// Build array of data to display
		$source_aliquots = array();
		
		if(!empty($use_id_from_source_aliquot_id)){
						
			// Search source aliquot used volumes
			$criteria = array();
			$criteria['AliquotUse.id'] = array_values($use_id_from_source_aliquot_id);
			
			$use_vol_from_source_aliquot_id 
				= $this->AliquotUse->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.AliquotUse.aliquot_master_id', 
					'{n}.AliquotUse.used_volume');
			
			if(empty($use_vol_from_source_aliquot_id) 
			|| (sizeof($use_vol_from_source_aliquot_id) != sizeof($use_id_from_source_aliquot_id) )){
				// It looks like at least one record defined in SourceAliquot has not
				// its attached data into AliquotUse	
				$this->redirect('/pages/err_inv_system_error'); 
				exit;		
			}				
			
			// Search source aliquots data
			$criteria = array();
			$criteria['AliquotMaster.id'] = array_keys($use_id_from_source_aliquot_id);
			$criteria = array_filter($criteria);
			
			list($order, $limit, $page) = $this->Pagination->init($criteria);
			$source_aliquots = $this->AliquotMaster->findAll($criteria, null, $order, $limit, $page, 0);

			// For each source aliquot, set the used_volume.
			foreach($source_aliquots as $id_ct => $new_source_aliquot){
				if(isset($use_vol_from_source_aliquot_id[$new_source_aliquot['AliquotMaster']['id']])){
					$source_aliquots[$id_ct]['AliquotUse']['used_volume'] = 
						$use_vol_from_source_aliquot_id[$new_source_aliquot['AliquotMaster']['id']];
				}			
			}
		}			
		
		$this->set('source_aliquots', $source_aliquots);
	
		// ** Verify if additional parent sample aliquots could be added to the list of source aliquots **
		$criteria= 'AliquotMaster.sample_master_id = '.$sample_master_data['SampleMaster']['parent_id'];
		$criteria.= ' AND AliquotMaster.status = \'available\'';
		if(!empty($use_id_from_source_aliquot_id)) {
			// Aliquot have already be defined as source
			$criteria.= ' AND AliquotMaster.id NOT IN (\''.implode('\',\'', array_keys($use_id_from_source_aliquot_id)).'\')';
		}
		
		$av_parent_sample_aliquots = 
			$this->AliquotMaster->findCount($criteria);
			
		$bool_av_parent_sample_aliquots = FALSE;
		
		if($av_parent_sample_aliquots > 0){
			$bool_av_parent_sample_aliquots = TRUE;
		}
										
		$this->set('bool_av_parent_sample_aliquots', $bool_av_parent_sample_aliquots);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

	} // listSourceAliquots
	
	/**
	 * Allow to define parent aliquots as source aliquots.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_catgory Sample Category.
	 * @param $collection_id Id of the studied collection.
	 * @param $sample_master_id Id of the studied sample derivative.
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function addSourceAliquotInBatch($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category=NULL, 
	$collection_id=null, $sample_master_id=null) {
			
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($sample_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// read SAMPLE MASTER info
		$criteria = 'SampleMaster.id ="'.$sample_master_id.'"';
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
				
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		if(strcmp($sample_master_data['SampleMaster']['collection_id'], $collection_id) != 0) {
			$this->redirect('/pages/err_inv_no_coll_id_map'); 
			exit;			
		}
		
		if(strcmp($sample_master_data['SampleMaster']['sample_category'], 'specimen') == 0){
			$this->redirect('/pages/err_inv_no_source_for_specimen'); 
			exit;	
		}

		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_so_al';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id.'/'.$derivative_sample_master_id.'/');	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
	
		// ** Set SUMMARY varible from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id));
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
		
		// ** Set FORM variable, for HELPER call on VIEW **
		$this->set('ctrapp_form', $this->Forms->getFormArray('source_aliquots_list'));
		
		// ** Set DATA variable, for echo en view or create link **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);

		$this->set('collection_id', $collection_id );
		$this->set('sample_master_id', $sample_master_id);	
		
		$this->set('sample_code', $sample_master_data['SampleMaster']['sample_code']);
		
		// Set aliquot use date with the sample creation date
		$criteria = 'DerivativeDetail.id ="'.$sample_master_id.'"';
		$derivative_detail_data = $this->DerivativeDetail->find($criteria, null, null, 0);

		if(empty($derivative_detail_data)){
			$this->redirect('/pages/err_inv_missing_samp_data'); 
			exit;
		}
			
		$this->set('sample_creation_datetime', $derivative_detail_data['DerivativeDetail']['creation_datetime']);
							
		// ** Search aliquot data to display in the list **
		
		// Search ids of the aliquots that have been already used to create this aliquot
		// These aliquots will be excluded from the list
		
		$criteria = array();
		$criteria['sample_master_id'] = $sample_master_id;

		$already_used_aliquot_id = 
			$this->SourceAliquot->generateList($criteria, 
											null, 
											null, 
											'{n}.SourceAliquot.aliquot_master_id', 
											'{n}.SourceAliquot.aliquot_master_id');

		// Search ids of the aliquots that could be used to create the derivative

		$criteria= 'AliquotMaster.sample_master_id = '.$sample_master_data['SampleMaster']['parent_id'];
		$criteria.= ' AND AliquotMaster.status = \'available\'';
		
		if(!empty($already_used_aliquot_id)) {
			// Aliquot have already be defined as source
			$criteria.= ' AND AliquotMaster.id NOT IN (\''.implode('\',\'', array_keys($already_used_aliquot_id)).'\')';
		}
				
		$available_source_aliquots = $this->AliquotMaster->findAll($criteria, null, null, null, 0);

		if(empty($available_source_aliquots)){
			$this->redirect('/pages/err_inv_no_aliquot_source_to_add'); 
			exit;
		}
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		if (empty($this->data)) {
			// Edit Data
			$this->data = $available_source_aliquots;
			$this->set('data', $this->data);	
							
		} else {
			// ** Save data	**

			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('source_aliquots_list') as $validate_model=>$validate_rules ) {
				$this->{$validate_model}->validate = $validate_rules;
			}
			
			// Run validation
			$submitted_data_validates = TRUE;	
			$aliquots_to_define_as_source = array();
					
			foreach($this->data as $id => $new_studied_aliquot){
				// New aliquot that was displayed in the datgarid
				
				if(strcmp($new_studied_aliquot['FunctionManagement']['generated_field_use'], 'yes') == 0){
					// This aliquot should be defined as source aliquot.
					
					// Validates Fields of Aliquot Master Table
					if(!$this->AliquotMaster->validates($new_studied_aliquot['AliquotMaster'])){
						$submitted_data_validates = FALSE;
					}
					
					if(!$this->AliquotUse->validates($new_studied_aliquot['AliquotUse'])){
						$submitted_data_validates = FALSE;
					}
					
					if(empty($new_studied_aliquot['AliquotMaster']['aliquot_volume_unit']) 
					&& (!empty($new_studied_aliquot['AliquotUse']['used_volume']))) {
						// No volume is tracked for this aliquot type
						$this->AliquotMaster->validationErrors[] 
							= 'no volume has to be recorded for this aliquot type';	
						$submitted_data_validates = false;
					}
					if(empty($new_studied_aliquot['AliquotUse']['used_volume'])){
						$new_studied_aliquot['AliquotUse']['used_volume']=NULL;
					}
			
					if($submitted_data_validates){
						$aliquots_to_define_as_source[] = $new_studied_aliquot;
					} else {
						break;	
					}			
				}
			} // End foreach to study all datgrid records
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			if ($submitted_data_validates) {
				
				if(empty($aliquots_to_define_as_source)){
					// Data have been updated
					$this->Flash('No aliquot has been defined as sample source aliquot.', 
						'/aliquot_masters/listSourceAliquots/'.
							$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.
							$collection_id.'/'.$sample_master_id.'/');	
					exit;					
				}
					
				// Launch Save function
				$bool_save_done = TRUE;
	
				// Parse records to save
				foreach($aliquots_to_define_as_source as $id_sec => $new_aliquot_to_use){
										
					// Save data of this aliquot
					$aliquot_use_id = NULL;					
					$source_aliquot_master_id = $new_aliquot_to_use['AliquotMaster']['id'];

					if(strcmp($new_aliquot_to_use['FunctionManagement']['generated_field_delete_storage_data'], 'yes') == 0){
						// Delete aliquot storage data
						$new_aliquot_to_use['AliquotMaster']['storage_master_id'] = NULL;
						$new_aliquot_to_use['AliquotMaster']['storage_coord_x'] = NULL;
						$new_aliquot_to_use['AliquotMaster']['storage_coord_y'] = NULL;
					}
					
					// Save ALIQUOT MASTER data
					
					unset($new_aliquot_to_use['AliquotMaster']['created']);
					unset($new_aliquot_to_use['AliquotMaster']['created_by']);
					
					$new_aliquot_to_use['AliquotMaster']['modified'] = date('Y-m-d G:i');
					$new_aliquot_to_use['AliquotMaster']['modified_by'] = $this->othAuth->user('id');
					
					if(!$this->AliquotMaster->save($new_aliquot_to_use['AliquotMaster'])){
						$bool_save_done = FALSE;
					} else {
						// Save ALIQUOT USE data
						
						// Add additional data
						$new_aliquot_to_use['AliquotUse']['aliquot_master_id'] = $source_aliquot_master_id;
										
						$new_aliquot_to_use['AliquotUse']['use_definition'] = 'sample derivative creation';
						$new_aliquot_to_use['AliquotUse']['use_details'] = $sample_master_data['SampleMaster']['sample_code'];
						$new_aliquot_to_use['AliquotUse']['use_recorded_into_table'] = 'source_aliquots';	
						$new_aliquot_to_use['AliquotUse']['use_datetime'] = $derivative_detail_data['DerivativeDetail']['creation_datetime'];						
						
						$new_aliquot_to_use['AliquotUse']['created'] = date('Y-m-d G:i');
						$new_aliquot_to_use['AliquotUse']['created_by'] = $this->othAuth->user('id');
						$new_aliquot_to_use['AliquotUse']['modified'] = date('Y-m-d G:i');
						$new_aliquot_to_use['AliquotUse']['modified_by'] = $this->othAuth->user('id');
						
						if(is_null($new_aliquot_to_use['AliquotMaster']['aliquot_volume_unit'])){
							// No volume should be recorded: Set used volume to NULL
							$new_aliquot_to_use['AliquotUse']['used_volume'] = NULL;
						}					
	
						if(!$this->AliquotUse->save($new_aliquot_to_use['AliquotUse'])){
							$bool_save_done = FALSE;
							
						} else {
							$aliquot_use_id = $this->AliquotUse->getLastInsertId();

							// Set data for source_aliquots table
							$source_aliquot_data = array();
							$source_aliquot_data['SourceAliquot']['id'] = null;
							$source_aliquot_data['SourceAliquot']['aliquot_master_id'] = $source_aliquot_master_id;
							$source_aliquot_data['SourceAliquot']['sample_master_id'] = $sample_master_id;
							$source_aliquot_data['SourceAliquot']['aliquot_use_id'] = $aliquot_use_id;
							
							$source_aliquot_data['SourceAliquot']['created'] = date('Y-m-d G:i');
							$source_aliquot_data['SourceAliquot']['created_by'] = $this->othAuth->user('id');
							$source_aliquot_data['SourceAliquot']['modified'] = date('Y-m-d G:i');
							$source_aliquot_data['SourceAliquot']['modified_by'] = $this->othAuth->user('id');
													
							if(!$this->SourceAliquot->save($source_aliquot_data)){
								$bool_save_done = FALSE;
							} else {
								// Update current volume of the source aliquot
								$this->updateAliquotCurrentVolume($source_aliquot_master_id);
							}
						}					
					} // End Save one source aliquot
					
					
					if(!$bool_save_done){
						break;
					}
					
				} // End foreach to save all source aliquots

				if(!$bool_save_done){
					$this->redirect('/pages/err_inv_aliquot_use_record_err'); 
					exit;
				} else {
					// Data have been updated
					$this->Flash('Your aliquots have been defined as sample source aliquot.', 
						'/aliquot_masters/listSourceAliquots/'.
							$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.
							$collection_id.'/'.$sample_master_id.'/');				
				} 
			} // End Save Functions execution	
			
		} // End Save Section (validation + save)
	} // End function addSourceAliquotInBatch

	/**
	 * Allow to delete a source aliquot from the list of parent sample aliquots
	 * used as source.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category.
	 * @param $collection_id Id of the studied collection.
	 * @param $sample_master_id Id of the studied sample derivative.
	 * @param $source_aliquot_master_id Id of the aliquot used as source that the user expects
	 * to delete from liste.
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function deleteSourceAliquot($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category=NULL, 
	$collection_id=null, $sample_master_id=null, $source_aliquot_master_id=null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || 
		empty($sample_master_id) || empty($source_aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// * Verify that this record match a source aliquot defintion **
		
		// Check in SourceAliquot
		$criteria = array();		
		$criteria['SourceAliquot.aliquot_master_id'] = $source_aliquot_master_id;
		$criteria['SourceAliquot.sample_master_id'] = $sample_master_id;
				
		$source_aliquot_record = $this->SourceAliquot->find($criteria, null, null, 0);
		
		if(empty($source_aliquot_record)){
			$this->redirect('/pages/err_inv_invalid_source_aliquot'); 
			exit;	
		}
			
		// Check in AliquotUse
		$aliquot_use_id = $source_aliquot_record['SourceAliquot']['aliquot_use_id'];
		
		$criteria = array();		
		$criteria['AliquotUse.id'] = $aliquot_use_id;
		$criteria['AliquotUse.aliquot_master_id'] = $source_aliquot_master_id;
				
		$aliquot_use_record = $this->AliquotUse->find($criteria, null, null, 0);
		
		if(empty($aliquot_use_record)){
			$this->redirect('/pages/err_inv_invalid_source_aliquot'); 
			exit;		
		}	

		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		// ** Delete Record **
		$bool_delete_source_aliquot = TRUE;
	
		if(!$this->SourceAliquot->del($source_aliquot_record['SourceAliquot']['id'])){
			$bool_delete_source_aliquot = FALSE;		
		}	
		
		if($bool_delete_source_aliquot){
			if(!$this->AliquotUse->del($aliquot_use_id)){
				$bool_delete_source_aliquot = FALSE;		
			}			
		}
		
		if(!$bool_delete_source_aliquot){
			$this->redirect('/pages/err_inv_aliqu_use_del_err'); 
			exit;
		}
		
		$this->flash('Your aliquot has been deleted from the list of Source Aliquot.', 
					'/aliquot_masters/listSourceAliquots/'.
					$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.
					$collection_id.'/'.$sample_master_id.'/');
		
	} // End function deleteSourceAliquot

	function listRealiquotedParents($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null) {

		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Look for Aliquot Data **
		$criteria = array();
		$criteria['AliquotMaster.id'] = $aliquot_master_id;
		$criteria['AliquotMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
		
		$aliquot_master_data = $this->AliquotMaster->find($criteria, null, null, 0);

		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
				
		//** Get the aliquot sample master data **
		
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];
		
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
														
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id, $aliquot_master_id));
															
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('realiquoted_parent_list'));

		// ** Set FORM data for echo on view **
		$this->set('aliquot_barcode', $aliquot_master_data['AliquotMaster']['barcode']);
//		$this->set('sample_code', $sample_master_data['SampleMaster']['sample_code']);

		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id);
		$this->set('aliquot_master_id', $aliquot_master_id);
				
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-sa_al_re';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-der_al_re';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id.'/'.$derivative_sample_master_id.'/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $derivative_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);

		// ** Search aliquot data to display in the list **
			
		// Search parent aliquots that have been realiquoted to create the new aliquot
	
		$criteria = array();
		$criteria['child_aliquot_master_id'] = $aliquot_master_id;

		$realiquoting_data = 
			$this->Realiquoting->generateList(
				$criteria, 
				null, 
				null, 
				'{n}.Realiquoting.parent_aliquot_master_id', 
				'{n}.Realiquoting');
		
		$use_id_from_realiquoted_parent_id = array();		
		if(!empty($realiquoting_data)){
			foreach($realiquoting_data as $par_aliqu_master_id => $studied_record) {
				$use_id_from_realiquoted_parent_id[$par_aliqu_master_id] = $studied_record['aliquot_use_id'];
			}
		}
											
		// Build array of data to display
		$realiquoted_parents = array();
		
		if(!empty($use_id_from_realiquoted_parent_id)){
						
			// Search realiquoted parent used volumes
			$criteria = array();
			$criteria['AliquotUse.id'] = array_values($use_id_from_realiquoted_parent_id);
			
			$use_vol_from_realiquoted_parent_id 
				= $this->AliquotUse->generateList(
					$criteria, 
					null, 
					null, 
					'{n}.AliquotUse.aliquot_master_id', 
					'{n}.AliquotUse.used_volume');
			
			if(empty($use_vol_from_realiquoted_parent_id) 
			|| (sizeof($use_vol_from_realiquoted_parent_id) != sizeof($use_id_from_realiquoted_parent_id) )){
				// It looks like at least one record defined in ParentAliquot has not
				// its attached data into AliquotUse	
				$this->redirect('/pages/err_inv_system_error'); 
				exit;		
			}				
			
			// Search realiquoted aliquots data
			$criteria = array();
			$criteria['AliquotMaster.id'] = array_keys($use_id_from_realiquoted_parent_id);
			$criteria = array_filter($criteria);
			
			list($order, $limit, $page) = $this->Pagination->init($criteria);
			$realiquoted_parents = $this->AliquotMaster->findAll($criteria, null, $order, $limit, $page, 0);

			// For each source aliquot, set different information
			foreach($realiquoted_parents as $id_ct => $new_realiquoted_parent){
				// Set AliquotUse.used_volume
				if(isset($use_vol_from_realiquoted_parent_id[$new_realiquoted_parent['AliquotMaster']['id']])){
					$realiquoted_parents[$id_ct]['AliquotUse']['used_volume'] = 
						$use_vol_from_realiquoted_parent_id[$new_realiquoted_parent['AliquotMaster']['id']];
				}
				// Set Realiquoting.realiquoted_by
				if(isset($realiquoting_data[$new_realiquoted_parent['AliquotMaster']['id']])){
					$realiquoted_parents[$id_ct]['Realiquoting']['realiquoted_by'] = 
						$realiquoting_data[$new_realiquoted_parent['AliquotMaster']['id']]['realiquoted_by'];
				}
				// Set Realiquoting.realiquoted_datetime
				if(isset($realiquoting_data[$new_realiquoted_parent['AliquotMaster']['id']])){
					$realiquoted_parents[$id_ct]['Realiquoting']['realiquoted_datetime'] = 
						$realiquoting_data[$new_realiquoted_parent['AliquotMaster']['id']]['realiquoted_datetime'];
				}
							
			}
		}
		
		$this->set('realiquoted_parents', $realiquoted_parents);
		
		// ** Verify if additional sample aliquots could be added to the list of realiquoted parents **
		
		$bool_av_realiquotable_aliquots = FALSE;
		
		if(sizeof($realiquoted_parents) == 0) {
			// Note: We consider that only one realiquoted parent can be defined
			
			$criteria= 'AliquotMaster.sample_master_id = '.$sample_master_id;
			$criteria.= ' AND AliquotMaster.status = \'available\'';
			$criteria.= ' AND AliquotMaster.id NOT IN (\''.$aliquot_master_id.'\'';
			if(!empty($use_id_from_realiquoted_parent_id)) {
				// Aliquot have already be defined as parent
				$criteria.= ', \''.implode('\',\'', array_keys($use_id_from_realiquoted_parent_id)).'\'';
			}
			$criteria.= ')';
			
			$av_realiquotable_aliquots = 
				$this->AliquotMaster->findCount($criteria);
					
			if($av_realiquotable_aliquots > 0){
				$bool_av_realiquotable_aliquots = TRUE;
			}
		}
										
		$this->set('bool_av_realiquotable_aliquots', $bool_av_realiquotable_aliquots);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

	} // listRealiquotedParent
	
	function addRealiquotedParentInBatch($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null) {
			
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Look for Aliquot Data **
		$criteria = array();
		$criteria['AliquotMaster.id'] = $aliquot_master_id;
		$criteria['AliquotMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
		
		$aliquot_master_data = $this->AliquotMaster->find($criteria, null, null, 0);

		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
		
		$realiquoted_aliquot_barcode = $aliquot_master_data['AliquotMaster']['barcode'];
				
		//** Get the aliquot sample master data **
		
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];
			
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
														
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id, $aliquot_master_id));
															
		// ** Set FORM variable **
		
		$this->set('realiquotable_parent_form', $this->Forms->getFormArray('realiquotable_parent_list'));
		$this->set('ctrapp_form', $this->Forms->getFormArray('realiquoted_parent_list'));

		// ** Set FORM data for echo on view **
//		$this->set('aliquot_barcode', $aliquot_master_data['AliquotMaster']['barcode']);
//		$this->set('sample_code', $sample_master_data['SampleMaster']['sample_code']);

		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id);
		$this->set('aliquot_master_id', $aliquot_master_id);
		
				
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-sa_al_re';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-der_al_re';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id.'/'.$derivative_sample_master_id.'/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $derivative_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);

		// ** Search aliquot data to display in the list **
		
		// Search ids of the aliquots that have been already be defined as realiquoted parent
		// These aliquots will be excluded from the list
		
		$criteria = array();
		$criteria['child_aliquot_master_id'] = $aliquot_master_id;

		$already_realiquoted_parent_id = 
			$this->Realiquoting->generateList($criteria, 
											null, 
											null, 
											'{n}.Realiquoting.parent_aliquot_master_id', 
											'{n}.Realiquoting.parent_aliquot_master_id');

		// Note we actually consider that only one aliquot can be defined as realiquoted parent
		if(sizeof($already_realiquoted_parent_id) >= 1) {
			$this->redirect('/pages/err_inv_system_error'); 
			exit;
		}

		// Search ids of the aliquots that could be defined as realiquoted parent

		$criteria= 'AliquotMaster.sample_master_id = '.$sample_master_data['SampleMaster']['id'];
		$criteria.= ' AND AliquotMaster.status = \'available\'';
		$criteria.= ' AND AliquotMaster.id NOT IN (\''.$aliquot_master_id.'\'';
		if(!empty($already_realiquoted_parent_id)) {
			// Aliquot have already be defined as parent
			$criteria.= ', \''.implode('\',\'', array_keys($already_realiquoted_parent_id)).'\'';
		}
		$criteria.= ')';
				
		$av_realiquotable_aliquots = $this->AliquotMaster->findAll($criteria, null, null, null, 0);

		if(empty($av_realiquotable_aliquots)){
			$this->redirect('/pages/err_inv_system_error'); 
			exit;
		}
		
		$this->set('realiquotable_aliquots', $av_realiquotable_aliquots);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		if (empty($this->data)) {
			// Edit Data
			$this->data = $av_realiquotable_aliquots;
			$this->set('data', $this->data);	
							
		} else {
			// ** Save data	**
						
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('realiquoted_parent_list') as $validate_model=>$validate_rules ) {
				$this->{$validate_model}->validate = $validate_rules;
			}
			
			// Run validation
			$submitted_data_validates = TRUE;	
			$aliquots_to_define_as_source = array();
			
			if(!$this->AliquotMaster->validates($this->data['AliquotMaster'])){
				$submitted_data_validates = FALSE;
			}
			
			if(!$this->AliquotUse->validates($this->data['AliquotUse'])){
				$submitted_data_validates = FALSE;
			}
			
			if(!$this->Realiquoting->validates($this->data['Realiquoting'])){
				$submitted_data_validates = FALSE;
			}
			
			$parent_aliquot_master_id = NULL;
			$parent_aliquot_volume_unit = NULL;
			if(empty($this->data['Realiquoting']['parent_aliquot_master_id'])) {
				$submitted_data_validates = FALSE;
				$this->AliquotMaster->validationErrors[] = 'realiquoted parent selection is required';						
			} else {
				
				// Search the realiquoted parent aliquot volume unit
				$parent_aliquot_master_id = $this->data['Realiquoting']['parent_aliquot_master_id'];
				
				$criteria = array();
				$criteria['AliquotMaster.id'] = $parent_aliquot_master_id;
				$criteria['AliquotMaster.collection_id'] = $collection_id;
				$criteria = array_filter($criteria);
				
				$parent_aliquot_master_data = $this->AliquotMaster->find($criteria, null, null, 0);		
				if(empty($parent_aliquot_master_data)){
					$this->redirect('/pages/err_inv_aliquot_no_data'); 
					exit;
				}
				
				$parent_aliquot_volume_unit = $parent_aliquot_master_data['AliquotMaster']['aliquot_volume_unit'];
				
				if(empty($parent_aliquot_volume_unit) 
				&& (!empty($this->data['AliquotUse']['used_volume']))) {
					// No volume is tracked for this aliquot type
					$this->AliquotMaster->validationErrors[] 
						= 'no volume has to be recorded for this aliquot type';	
					$submitted_data_validates = false;
				}
				
			}
						
			if(empty($this->data['AliquotUse']['used_volume'])){
				$this->data['AliquotUse']['used_volume']=NULL;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			if ($submitted_data_validates) {
				
				$this->cleanUpFields('Realiquoting');
					
				// Get data
				$realiquoting_data = $this->data['Realiquoting'];	
				$realiquoted_aliquot_master_data = $this->data['AliquotMaster'];	
				$use_data = $this->data['AliquotUse'];	
				$function_management_data = $this->data['FunctionManagement'];
				
				// Launch Save function
				$bool_save_done = TRUE;
										
				// 1- Update ALIQUOT MASTER data of the realiquoted parent	
				$realiquoted_aliquot_master_data['id'] = $parent_aliquot_master_id;			
				
				if(strcmp($function_management_data['generated_field_delete_storage_data'], 'yes') == 0){
					// Delete aliquot storage data
					$realiquoted_aliquot_master_data['storage_master_id'] = NULL;
					$realiquoted_aliquot_master_data['storage_coord_x'] = NULL;
					$realiquoted_aliquot_master_data['storage_coord_y'] = NULL;
				}
				
				// Save 
				unset($realiquoted_aliquot_master_data['created']);
				unset($realiquoted_aliquot_master_data['created_by']);
				
				if(!$this->AliquotMaster->save($realiquoted_aliquot_master_data)){
					$bool_save_done = FALSE;
				} 

				// 2- Save ALIQUOT USE data for the realiquoted parent					
				if($bool_save_done) {
					
					// Add additional data
					$use_data['aliquot_master_id'] = $parent_aliquot_master_id;
					$use_data['use_datetime'] = $realiquoting_data['realiquoted_datetime'];
					
					$use_data['use_definition'] = 'realiquoted to';
					$use_data['use_details'] = $realiquoted_aliquot_barcode;
					$use_data['use_recorded_into_table'] = 'realiquotings';
					
					if(is_null($parent_aliquot_volume_unit) || empty($parent_aliquot_volume_unit)){
						// No volume should be recorded: Set used volume to NULL
						$use_data['used_volume'] = NULL;
					}					

				if(!$this->AliquotUse->save($use_data)){
					$bool_save_done = FALSE;
				} 
					
				}
				
				// 3- Save realiquoting data into REALIQUOTING table
				if($bool_save_done) {
					
					$aliquot_use_id = $this->AliquotUse->getLastInsertId();

					// Set data for realiquotinf table
					$realiquoting_data['child_aliquot_master_id'] = $aliquot_master_id;
					$realiquoting_data['aliquot_use_id'] = $aliquot_use_id;	
					
					$realiquoting_data['created'] = date('Y-m-d G:i');
					$realiquoting_data['created_by'] = $this->othAuth->user('id');
					$realiquoting_data['modified'] = date('Y-m-d G:i');
					$realiquoting_data['modified_by'] = $this->othAuth->user('id');		
				
					if(!$this->Realiquoting->save($realiquoting_data)){
						$bool_save_done = FALSE;
					}
				
				}
						
				if(!$bool_save_done){
					$this->redirect('/pages/err_inv_aliquot_use_record_err'); 
					exit;
					
				} else {
					
					// Update current volume of the realiquoted parent aliquot
					$this->updateAliquotCurrentVolume($parent_aliquot_master_id);
												
					// Data have been updated
					$this->Flash('Your aliquot has been defined as realiquoted parent aliquot.', 
						'/aliquot_masters/listRealiquotedParents/'.
							$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.$collection_id.
							'/'.$aliquot_master_id.'/');			
				} 
			} // End Save Functions execution	
			
		} // End Save Section (validation + save)
		
	} // End function addRealiquotedParentInBatch

	function deleteRealiquotedParent($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null, $realiquoted_aliquot_master_id) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)
		|| empty($realiquoted_aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// * Verify that this record match a realiquoted defintion **
		
		// Check in Realiquoting
		$criteria = array();		
		$criteria['Realiquoting.parent_aliquot_master_id'] = $realiquoted_aliquot_master_id;
		$criteria['Realiquoting.child_aliquot_master_id'] = $aliquot_master_id;
				
		$realiquoting_record = $this->Realiquoting->find($criteria, null, null, 0);
		
		if(empty($realiquoting_record)){
			$this->redirect('/pages/err_inv_system_error'); 
			exit;	
		}
			
		// Check in AliquotUse
		$aliquot_use_id = $realiquoting_record['Realiquoting']['aliquot_use_id'];
		
		$criteria = array();		
		$criteria['AliquotUse.id'] = $aliquot_use_id;
		$criteria['AliquotUse.aliquot_master_id'] = $realiquoted_aliquot_master_id;
				
		$aliquot_use_record = $this->AliquotUse->find($criteria, null, null, 0);
		
		if(empty($aliquot_use_record)){
			$this->redirect('/pages/err_inv_invalid_source_aliquot'); 
			exit;		
		}	
		
		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		// ** Delete Record **
		$bool_delete_source_aliquot = TRUE;
	
		if(!$this->Realiquoting->del($realiquoting_record['Realiquoting']['id'])){
			$bool_delete_source_aliquot = FALSE;		
		}	
		
		if($bool_delete_source_aliquot){
			if(!$this->AliquotUse->del($aliquot_use_id)){
				$bool_delete_source_aliquot = FALSE;		
			}			
		}
		
		if(!$bool_delete_source_aliquot){
			$this->redirect('/pages/err_inv_aliqu_use_del_err'); 
			exit;
		}
		
		$this->flash('Your aliquot has been deleted from the list of realiquoted parent.', 
					'/aliquot_masters/listRealiquotedParents/'.
							$specimen_group_menu_id.'/'.$group_specimen_type.'/'.
							$sample_category.'/'.$collection_id.
							'/'.$aliquot_master_id.'/');
		
	} // End function deleteSourceAliquot
	
	/**
	 * Allow to display the use list of a aliquot.
	 * 
	 * @param $specimen_group_menu_id Menu id that corresponds to the tab clicked to 
	 * display the samples of the collection group (Ascite, Blood, Tissue, etc).
	 * @param $group_specimen_type Type of the source specimens of the group.
	 * @param $sample_category Sample Category.
	 * @param $collection_id Id of the studied collection.
	 * @param $aliquot_master_id Master Id of the aliquot. 
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function listAliquotUses($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Look for Aliquot Data **
		$criteria = array();
		$criteria['AliquotMaster.id'] = $aliquot_master_id;
		$criteria['AliquotMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
		
		$aliquot_master_data = $this->AliquotMaster->find($criteria, null, null, 0);
		
		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
				
		//** Get the aliquot sample master data **
		
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];
		
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
														
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id, $aliquot_master_id));
															
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('aliquot_use_list'));
		
		// ** Set FORM data for echo on view **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id );
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$this->set('studies_list', $this->getStudiesArray());
					
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-sa_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-der_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id.'/'.$derivative_sample_master_id.'/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $derivative_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);

		// ** Search aliquot uses data **
		
		$this->AliquotMaster->unbindModel(array('hasMany' => array('AliquotUse')));
		$this->AliquotMaster->unbindModel(array('belongsTo' => array('StorageMaster')));
		
		$this->AliquotUse->bindModel(array('belongsTo' => 
			array('AliquotMaster' => array(
					'className' => 'AliquotMaster',
					'conditions' => '',
					'order'      => '',
					'foreignKey' => 'aliquot_master_id'))));
		
		$criteria = array();
		$criteria['AliquotUse.aliquot_master_id'] = $aliquot_master_id;
		$criteria = array_filter($criteria);
		
		$aliquot_uses = $this->AliquotUse->findAll($criteria, null, null, null, 1);

		$this->set('aliquot_uses', $aliquot_uses);	
		
		// ** Build list of additional uses a user can add **
		$this->set('allowed_additional_uses', $this->getAllowedAdditionalAliqUses());
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
	}

	function detailAliquotUse($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null, $aliquot_use_id=null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)
		|| empty($aliquot_use_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Look for Aliquot Data **
		$criteria = array();
		$criteria['AliquotMaster.id'] = $aliquot_master_id;
		$criteria['AliquotMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
		
		$aliquot_master_data = $this->AliquotMaster->find($criteria, null, null, 0);
		
		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
				
		//** Get the aliquot sample master data **
		
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];
		
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
														
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id, $aliquot_master_id));
															
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('aliquot_use_list'));
		
		// ** Set FORM data for echo on view **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id );
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$this->set('studies_list', $this->getStudiesArray());
					
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-sa_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-der_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id.'/'.$derivative_sample_master_id.'/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $derivative_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);

		// ** Search aliquot use data **
		$this->AliquotMaster->unbindModel(array('hasMany' => array('AliquotUse')));
		$this->AliquotMaster->unbindModel(array('belongsTo' => array('StorageMaster')));
		
		$this->AliquotUse->bindModel(array('belongsTo' => 
			array('AliquotMaster' => array(
					'className' => 'AliquotMaster',
					'conditions' => '',
					'order'      => '',
					'foreignKey' => 'aliquot_master_id'))));
		
		$criteria = array();
		$criteria['AliquotUse.id'] = $aliquot_use_id;
		$criteria['AliquotUse.aliquot_master_id'] = $aliquot_master_id;
		$criteria = array_filter($criteria);
	
		$aliquot_use_data = $this->AliquotUse->find($criteria, null, null, 0);
		
		if(empty($aliquot_use_data)){
			$this->redirect('/pages/err_inv_aliq_use_no_data'); 
			exit;
		}
		
		$this->set('aliquot_use_data', $aliquot_use_data);
		
		$allow_use_management_by_user = FALSE;
		if(in_array($aliquot_use_data['AliquotUse']['use_definition'], $this->getAllowedAdditionalAliqUses())) {
			$allow_use_management_by_user = TRUE;
		}	
		$this->set('allow_use_management_by_user', $allow_use_management_by_user);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
	}
	
	function addAliquotUse($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null, $aliquot_use_defintion= null) {
		
		// ** Get the aliquot_use_defintion **
		if (isset($this->params['form']['aliquot_use_defintion'])) {
			$aliquot_use_defintion = $this->params['form']['aliquot_use_defintion'];
		}
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id) ||
		empty($aliquot_use_defintion)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Look for Aliquot Data **
		$criteria = array();
		$criteria['AliquotMaster.id'] = $aliquot_master_id;
		$criteria['AliquotMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
		
		$aliquot_master_data = $this->AliquotMaster->find($criteria, null, null, 0);
		
		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
				
		//** Get the aliquot sample master data **
		
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];
		
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
														
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id, $aliquot_master_id));
															
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('aliquot_use_list'));
		
		// ** Set FORM data for echo on view **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id );
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$this->set('aliquot_use_defintion', $aliquot_use_defintion);
		$this->set('aliquot_volume_unit', $aliquot_master_data['AliquotMaster']['aliquot_volume_unit']);
		
		$this->set('studies_list', $this->getStudiesArray());
					
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-sa_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-der_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id.'/'.$derivative_sample_master_id.'/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $derivative_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

		if (!empty($this->data)) {
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('aliquot_use_list') as $validate_model=>$validate_rules) {
				$this->{ $validate_model }->validate = $validate_rules;
			}

			$this->cleanUpFields('AliquotUse');
						
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if (!$this->AliquotUse->validates($this->data)) {
				$submitted_data_validates = false;
			}
			
			if(empty($this->data['AliquotMaster']['aliquot_volume_unit']) 
			&& (!empty($this->data['AliquotUse']['used_volume']))) {
				// No volume is tracked for this aliquot type
				$this->AliquotMaster->validationErrors[] 
					= 'no volume has to be recorded for this aliquot type';	
				$submitted_data_validates = false;
			}
			if(empty($this->data['AliquotUse']['used_volume'])){
				$this->data['AliquotUse']['used_volume']=NULL;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			// if data VALIDATE, then save data
			if ($submitted_data_validates) {
				
				if ($this->AliquotUse->save($this->data['AliquotUse'])) {
					
					$this->updateAliquotCurrentVolume($aliquot_master_id);
					
					$this->flash('Your data has been saved.', 
						'/aliquot_masters/listAliquotUses/'.
						$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.
						$collection_id.'/'.$aliquot_master_id.'/');
				} else {
					$this->redirect('/pages/err_inv_aliquot_use_record_err'); 
					exit;
				}
				
			}
			
		}
		
	}
	
	function editAliquotUse($specimen_group_menu_id=NULL, $group_specimen_type=NULL, $sample_category=null,	
	$collection_id=null, $aliquot_master_id=null, $aliquot_use_id= null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id) ||
		empty($aliquot_use_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Look for Aliquot Data **
		$criteria = array();
		$criteria['AliquotMaster.id'] = $aliquot_master_id;
		$criteria['AliquotMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
		
		$aliquot_master_data = $this->AliquotMaster->find($criteria, null, null, 0);
		
		if(empty($aliquot_master_data)){
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
				
		//** Get the aliquot sample master data **
		
		$sample_master_id = $aliquot_master_data['AliquotMaster']['sample_master_id'];
		
		$criteria = array();
		$criteria['SampleMaster.id'] = $sample_master_id;
		$criteria['SampleMaster.collection_id'] = $collection_id;
		$criteria = array_filter($criteria);
	
		$sample_master_data = $this->SampleMaster->find($criteria, null, null, 0);
		
		if(empty($sample_master_data)){
			$this->redirect('/pages/err_inv_samp_no_data'); 
			exit;
		}
		
		// ** Set SIDEBAR variable **
		// Use PLUGIN_CONTROLLER_ACTION by default, 
		// but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
														
		// ** Set SUMMARY variable from plugin's COMPONENTS **
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id, $sample_master_id, $aliquot_master_id));
															
		// ** Set FORM variable **
		$this->set('ctrapp_form', $this->Forms->getFormArray('aliquot_use_list'));
		
		// ** Set FORM data for echo on view **
		$this->set('specimen_group_menu_id', $specimen_group_menu_id);
		$this->set('group_specimen_type', $group_specimen_type);
		$this->set('sample_category', $sample_category);
		
		$this->set('collection_id', $collection_id );
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$this->set('aliquot_volume_unit', $aliquot_master_data['AliquotMaster']['aliquot_volume_unit']);
		$this->set('studies_list', $this->getStudiesArray());
					
		// ** Set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_10', $collection_id);
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_10', $specimen_group_menu_id, $collection_id);
		
		$specimen_grp_menu_lists = $this->getSpecimenGroupMenu($specimen_group_menu_id);
		
		switch($sample_category) {
			case "specimen":
				$specimen_sample_master_id=$sample_master_id;
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-sa_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $specimen_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
				
			case "derivative":
				$specimen_sample_master_id=$sample_master_data['SampleMaster']['initial_specimen_sample_id'];
				$derivative_sample_master_id=$sample_master_id;		
				
				$specimen_menu_id = $specimen_group_menu_id.'-sa_der';
				$derivative_menu_id = $specimen_group_menu_id.'-der_al';
				$aliquot_menu_id = $specimen_group_menu_id.'-der_al_us';
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $specimen_menu_id, $specimen_group_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_group_menu_id, $specimen_menu_id, $collection_id.'/'.$specimen_sample_master_id);	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $derivative_menu_id, $specimen_menu_id);
				$ctrapp_menu[] = $this->Menus->tabs($specimen_menu_id, $derivative_menu_id, $collection_id.'/'.$derivative_sample_master_id.'/');	
				$this->validateSpecimenGroupMenu($specimen_grp_menu_lists, $aliquot_menu_id, $derivative_menu_id);							
				$ctrapp_menu[] = $this->Menus->tabs($derivative_menu_id, $aliquot_menu_id, $collection_id.'/'.$aliquot_master_id);	
				break;
			
			default:
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
		}
		
		$this->set('ctrapp_menu', $ctrapp_menu);
		
		// ** Search aliquot use data **
		
		$this->AliquotMaster->unbindModel(array('hasMany' => array('AliquotUse')));
		$this->AliquotMaster->unbindModel(array('belongsTo' => array('StorageMaster')));
		
		$this->AliquotUse->bindModel(array('belongsTo' => 
			array('AliquotMaster' => array(
					'className' => 'AliquotMaster',
					'conditions' => '',
					'order'      => '',
					'foreignKey' => 'aliquot_master_id'))));
		
		$criteria = array();
		$criteria['AliquotUse.id'] = $aliquot_use_id;
		$criteria['AliquotUse.aliquot_master_id'] = $aliquot_master_id;
		$criteria = array_filter($criteria);
	
		$aliquot_use_data = $this->AliquotUse->find($criteria, null, null, 0);
		
		if(empty($aliquot_use_data)){
			$this->redirect('/pages/err_inv_aliq_use_no_data'); 
			exit;
		}
		
		if(!in_array($aliquot_use_data['AliquotUse']['use_definition'], $this->getAllowedAdditionalAliqUses())) {
			// User is not alloed to modify this use record
			$this->redirect('/pages/err_inv_system_error'); 
			exit;
		}
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

		if (empty($this->data)) {
			
			// set use data to display
			$this->data = $aliquot_use_data;
			$this->set('data', $this->data);
			
		} else {
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('aliquot_use_list') as $validate_model=>$validate_rules) {
				$this->{ $validate_model }->validate = $validate_rules;
			}

			$this->cleanUpFields('AliquotUse');
			
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if (!$this->AliquotUse->validates($this->data['AliquotUse'])) {
				$submitted_data_validates = false;
			}
			
			if(empty($this->data['AliquotMaster']['aliquot_volume_unit']) 
			&& (!empty($this->data['AliquotUse']['used_volume']))) {
				// No volume is tracked for this aliquot type
				$this->AliquotMaster->validationErrors[] 
					= 'no volume has to be recorded for this aliquot type';	
				$submitted_data_validates = false;
			}
			if(empty($this->data['AliquotUse']['used_volume'])){
				$this->data['AliquotUse']['used_volume']=NULL;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			// if data VALIDATE, then save data
			if ($submitted_data_validates) {
				
				// set a FLAG
				$bool_save_error = FALSE;
				
				if ($this->AliquotUse->save($this->data['AliquotUse'])) {
					
					$this->updateAliquotCurrentVolume($aliquot_master_id);
					
					$this->flash('Your data has been saved.', 
						'/aliquot_masters/detailAliquotUse/'.
						$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.
						$collection_id.'/'.$aliquot_master_id.'/'.$aliquot_use_id.'/');
				} else {
					$this->redirect('/pages/err_inv_aliquot_use_record_err'); 
					exit;
				}
				
			}
						
		}
		
	}
	
	function deleteAliquotUse($specimen_group_menu_id=NULL,  $group_specimen_type=NULL, $sample_category=null, 
	$collection_id=null, $aliquot_master_id=null, $aliquot_use_id=null) {
			
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($specimen_group_menu_id) || empty($group_specimen_type) || 
		empty($sample_category) || empty($collection_id) || empty($aliquot_master_id)|| 
		empty($aliquot_use_id)) {
			$this->redirect('/pages/err_inv_funct_param_missing'); 
			exit;
		}
		
		// ** Load  ALIQUOT USE info **
		$criteria = array();
		$criteria['AliquotUse.id'] = $aliquot_use_id;
		$criteria['AliquotUse.aliquot_master_id'] = $aliquot_master_id;
		$criteria = array_filter($criteria);
	
		$aliquot_use_data = $this->AliquotUse->find($criteria, null, null, 0);
		
		// Verify aliquot use can be deleted
		if(!in_array($aliquot_use_data['AliquotUse']['use_definition'], $this->getAllowedAdditionalAliqUses())) {
			// User is not allowed to modify this use record
			$this->redirect('/pages/err_inv_system_error'); 
			exit;
		}
		
		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		//Delete aliquot
		$bool_delete_aliquot = TRUE;
	
		if(!$this->AliquotUse->del($aliquot_use_id)){
			$this->redirect('/pages/err_inv_aliqu_use_del_err'); 
			exit;
		}
		
		$this->updateAliquotCurrentVolume($aliquot_master_id);
		
		$this->Flash('Your data has been deleted.',
			'/aliquot_masters/listAliquotUses/'.
			$specimen_group_menu_id.'/'.$group_specimen_type.'/'.$sample_category.'/'.
			$collection_id.'/'.$aliquot_master_id.'/');
	
	} //end deleteAliquotUse
	
	function getAllowedAdditionalAliqUses() {
		
		// ** Build list of additional use a user can add **
		
		$criteria = array();
		$criteria['GlobalLookup.alias'] = 'aliquot_use_definition';
		$criteria[] = "GlobalLookup.display_order != '-1'";
		$criteria = array_filter($criteria);
		
		$additional_uses = 
			$this->GlobalLookup->generateList(
				$criteria,
				"GlobalLookup.display_order ASC", 
				null, 
				'{n}.GlobalLookup.value', 
				'{n}.GlobalLookup.language_choice');
				
		return $additional_uses;			
			
	}
		
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */	
	
	/**
	 * Verify that all Aliquot Barcodes sent to the function do not already 
	 * exist in the DB or are not duplicated and check the size of the barcode.
	 *
	 * @param $arr_aliquot_barcodes Array that contains the list of new aliquot bacrode.
	 *
	 * @return Array that contains all barcodes that are duplicated in the list or
	 * already exist in the DB or too long.
	 * 
	 * The returned array has the following format:
	 * [duplicated barcode] = duplicated barcode or barcode too long
	 * 
	 * Note: When no duplication exists, the returned array will be empty.
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function validateAliquotBarcode($arr_aliquot_barcodes){
		
		$arr_barcode_in_error_list = array();

		// Check duplication into list
		$arr_already_studied = array();
		foreach($arr_aliquot_barcodes as $id => $barcode){
			if(isset($arr_already_studied[$barcode])){
				// Barcode already enterred into the form
				$arr_barcode_in_error_list[$barcode] = $barcode;
			}
			if(strlen($barcode) > $this->barcode_size_max) {
				// Barcode too long
				$arr_barcode_in_error_list[$barcode] = $barcode;
			}
			
			$arr_already_studied[$barcode] = $barcode;
		}
		
		// Check duplication with DB data
		$a_fields = array('id');
		$conditions = ' AliquotMaster.barcode in  (\''.implode('\',\'', array_values($arr_aliquot_barcodes)).'\')';
		$a_duplicated_in_db = 
			$this->AliquotMaster->generateList($conditions, 
												null, 
												null, 
												'{n}.AliquotMaster.barcode', 
												'{n}.AliquotMaster.barcode');
		if(empty($a_duplicated_in_db)){
			$a_duplicated_in_db = array();
		}	

		// Return duplicated barcode list
		return array_merge($a_duplicated_in_db, $arr_barcode_in_error_list);

	}
		
	/**
	 * Update the current volume of a aliquot.
	 * 
	 * When the intial volume is NULL, the current volume will be set to 
	 * NULL but the status won't be changed.
	 * 
	 * When the new current volume is equal to 0 and the status is 'available',
	 * the status will be automatically change to 'not available' 
	 * and the reason to 'empty'
	 *
	 * @param $aliquot_master_id Master Id of the aliquot.
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	function obslolete_updateAliquotCurrentVolume($aliquot_master_id){}

	/**
	 * Define if a aliquot can be deleted.
	 * 
	 * @param $aliquot_master_id Id of the studied sample.
	 * 
	 * @return Return TRUE if the aliquot can be deleted.
	 * 
	 * @author N. Luc
	 * @since 2007-08-16
	 */
	function allowAliquotDeletion($aliquot_master_id){
		
		// Verify that this aliquot has not been used 
		// - internal use, 
		// - add to order, 
		// - add for qc, 
		// - use to create derivative, 
		// - realiquoted to...	
		$criteria = 'AliquotUse.aliquot_master_id ="' .$aliquot_master_id.'"';			 
		$aliquot_use_nbr = $this->AliquotUse->findCount($criteria);
				
		if($aliquot_use_nbr > 0){
			return FALSE;
		}
		
		// Verify that this aliquot is not linked to a realiquoted aliquot	
		$criteria = 'Realiquoting.child_aliquot_master_id ="' .$aliquot_master_id.'"';			 
		$realiquoted_aliquot_nbr = $this->Realiquoting->find($criteria);
			
		if($realiquoted_aliquot_nbr > 0){
			return FALSE;
		}
		
		// Verify this aliquot has not been used for review
		$criteria = 'PathCollectionReview.aliquot_master_id ="' .$aliquot_master_id.'"';			 
		$aliquot_path_review_nbr = $this->PathCollectionReview->findCount($criteria);

		if($aliquot_path_review_nbr > 0){
			return FALSE;
		}
		
		$criteria = 'ReviewMaster.aliquot_master_id ="' .$aliquot_master_id.'"';			 
		$aliquot_review_nbr = $this->ReviewMaster->findCount($criteria);

		if($aliquot_review_nbr > 0){
			return FALSE;
		}
		
		// Attache to an order line
		$criteria = 'OrderItem.aliquot_master_id ="' .$aliquot_master_id.'"';			 
		$aliquot_order_nbr = $this->OrderItem->findCount($criteria);
		
		if($aliquot_order_nbr > 0){
			return FALSE;
		}
		
		// Verify block attched to tissue slide
		$special_aliquot_detail = new AliquotDetail(false, 'ad_tissue_slides');
		$criteria = 'AliquotDetail.ad_block_id ="' .$aliquot_master_id.'"';			 
		$aliquot_tiss_slide_nbr = $special_aliquot_detail->findCount($criteria);
		
		if($aliquot_tiss_slide_nbr > 0){
			return FALSE;
		}
		
		// Verify block atched to tissue core
		$special_aliquot_detail = new AliquotDetail(false, 'ad_tissue_cores');
		$criteria = 'AliquotDetail.ad_block_id ="' .$aliquot_master_id.'"';			 
		$aliquot_tiss_slide_nbr = $special_aliquot_detail->findCount($criteria);
		
		if($aliquot_tiss_slide_nbr > 0){
			return FALSE;
		}
		
		// Verify gel matrix atched to cell core
		$special_aliquot_detail = new AliquotDetail(false, 'ad_cell_cores');
		$criteria = 'AliquotDetail.ad_gel_matrix_id ="' .$aliquot_master_id.'"';			 
		$aliquot_tiss_slide_nbr = $special_aliquot_detail->findCount($criteria);
		
		if($aliquot_tiss_slide_nbr > 0){
			return FALSE;
		}
			
						
		// Etc...
		
		return TRUE;
	}
	
	/*
		DATAMART PROCESS, addes BATCH SET aliquot IDs to ORDER ITEMs
		Multi-part process, linking Orders, OrderLines, and OrderItems (all ACTIONs the same name in each CONTROLLER)
	*/
	
	function process_add_aliquots($aliquot_id) {
		
		// clear SESSION info
		$_SESSION['ctrapp_core']['datamart']['process'] = array(
			'AliquotMaster' => array(
				'id' => array(
					'0' => $aliquot_id
				)
			),
			'BatchSet' => array(
				'process' => 'order/orders/process_add_aliquots',
				'id' => 0,
				'model' => 'AliquotMaster'
			)
		);
		
		$this->redirect( 'order/orders/process_add_aliquots/' );
		exit();
		
	}

	function validateStorageIdAndSelectionLabel($storage_selection_label, $storage_master_id) {
	
		$submitted_data_validates = true;
		$defined_storage_id = $storage_master_id;
		$aliquot_arr_storage_list = array();
		$storage_control_errors = array();

		if(!empty($storage_selection_label)) {
			
			// Case 1: A storage selection label exists
			
			// Look for storage matching the storage selection label 
			$aliquot_arr_storage_list 
				= $this->requestAction(
					'/storagelayout/storage_masters/getStorageMatchingSelectLabel/'.$storage_selection_label);
			
			if(empty($storage_master_id)) {	
				
				// Case 1.a: No storage id has been defined: Define storage id using selection label
				
				if(empty($aliquot_arr_storage_list)) {
					// No storage matches	
					$submitted_data_validates = false;
					$storage_control_errors['B1'] 
						= 'no storage matches (at least one of) the selection label(s)';
				} else if(sizeof($aliquot_arr_storage_list) > 1) {
					// More than one storage matche this storage selection label
					$submitted_data_validates = false;
					$storage_control_errors['B2'] 
						= 'more than one storages matche (at least one of) the selection label(s)';
				} else {
					// The selection label match only one storage: Get the storage_master_id
					$defined_storage_id = key($aliquot_arr_storage_list);
				}
			
			} else {
				
				// Case 1.b: A storage id has been selected
				
				// Verify this one matches one record of the $arr_storage_list;
				if(!array_key_exists($storage_master_id, $aliquot_arr_storage_list)) {
		
					// Set error
					$submitted_data_validates = false;
					$storage_control_errors['B3'] 
						= '(at least one of) the selected id does not match a selection label';						
					
					// Add the storage to the storage list
					$aliquot_arr_storage_list[$storage_master_id] 
						= $this->requestAction('/storagelayout/storage_masters/getStorageData/'.$storage_master_id);								

				}	
			}
		
		} else if(!empty($storage_master_id)) {
			
			// Case 2: Only storage_master_id has been defined
						
			// Only  storage id has been selected:
			// Add this one in $arr_storage_list if an error is displayed
			$aliquot_arr_storage_list 
				= array($storage_master_id  
					=> $this->requestAction('/storagelayout/storage_masters/getStorageData/'.$storage_master_id));
				
		} // else if $returned_storage_id and $recorded_selection_label empty: Nothing to do	
		
		return array(
			'submitted_data_validates' => $submitted_data_validates,
			'defined_storage_id' => $defined_storage_id,
			'aliquot_arr_storage_list' => $aliquot_arr_storage_list,
			'storage_control_errors' => $storage_control_errors);
			
	}
	
	function validateStorageCoordinates($storage_master_id, $storage_coord_x, $storage_coord_y) {
		
		$submitted_data_validates = true;
		$validated_storage_coord_x = $storage_coord_x;
		$validated_storage_coord_y = $storage_coord_y;
		$storage_control_errors = array();
	
		if(empty($storage_master_id)){
			// No storage selected: no coordinate should be set
			if(!empty($storage_coord_x)){
				$submitted_data_validates = false;
				$validated_storage_coord_x = 'err!';
				$storage_control_errors['C1'] = 'no postion has to be recorded when no storage is selected';
			}
			if(!empty($storage_coord_y)){
				$submitted_data_validates = false;
				$validated_storage_coord_y = 'err!';
				$storage_control_errors['C1'] = 'no postion has to be recorded when no storage is selected';
			}						
				
		} else {
			// Verify coordinate values
			$a_coord_valid = 
				$this->requestAction('/storagelayout/storage_masters/validateStoragePosition/'.
					$storage_master_id.'/'.
					'x_'.$storage_coord_x.'/'.		// Add 'x_' before coord to support empty value
					'y_'.$storage_coord_y.'/');		// Add 'y_' before coord to support empty value
					
			// Manage coordinate x
			if(!$a_coord_valid['coord_x']['validated']) {
				$submitted_data_validates = false;
				$validated_storage_coord_x = 'err!';
				$storage_control_errors['C2'] = 'at least one position value does not match format';
			} else if($a_coord_valid['coord_x']['to_uppercase']) {
				$validated_storage_coord_x = strtoupper($storage_coord_x);
			}
			
			// Manage coordinate y
			if(!$a_coord_valid['coord_y']['validated']) {
				$submitted_data_validates = false;
				$validated_storage_coord_y = 'err!';
				$storage_control_errors['C2'] = 'at least one position value does not match format';
			} else if($a_coord_valid['coord_y']['to_uppercase']) {
				$validated_storage_coord_y = strtoupper($storage_coord_y);
			}
		
		}
		
		return array(
			'submitted_data_validates' => $submitted_data_validates,
			'validated_storage_coord_x' => $validated_storage_coord_x,
			'validated_storage_coord_y' => $validated_storage_coord_y,
			'storage_control_errors' => $storage_control_errors);
		
	}

}

?>
