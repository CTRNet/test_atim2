<?php

class InventorymanagementAppController extends AppController
{	
	var $components = array('Administrate.Administrates', 'Sop.Sops');

	var $uses = array(
		'Administrate.Bank', 
		'Sop.SopMaster');
		
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/Inventorymanagement/';
	}
	
	/**
	 * Return the spent time between 2 dates. 
	 * Notes: The supported date format is YYYY-MM-DD HH:MM:SS
	 * 
	 * @param $start_date Start date
	 * @param $end_date End date
	 * 
	 * @return Return an array that contains the spent time
	 * or an error message when the spent time can not be calculated.
	 * The sturcture of the array is defined below:
	 *	Array (
	 * 		'message' => '',
	 * 		'days' => '0',
	 * 		'hours' => '0',
	 * 		'minutes' => '0'
	 * 	)
	 * 
	 * @author N. Luc
	 * @since 2007-06-20
	 */
	 
	function getSpentTime($start_date, $end_date){
		$arr_spent_time 
			= array(
				'message' => '',
				'days' => '0',
				'hours' => '0',
				'minutes' => '0');
		
		$empty_date = '0000-00-00 00:00:00';
		
		// Verfiy date is not empty
		if(empty($start_date)||empty($end_date)
		|| (strcmp($start_date, $empty_date) == 0)
		|| (strcmp($end_date, $empty_date) == 0)){
			// At least one date is missing to continue
			$arr_spent_time['message'] = 'missing date';	
		} else {
			$start = $this->getTimeStamp($start_date);
			$end = $this->getTimeStamp($end_date);
			$spent_time = $end - $start;
			
			if(($start === false)||($end === false)){
				// Error in the date
				$arr_spent_time['message'] = 'error: unable to define date';
			} else if($spent_time < 0){
				// Error in the date
				$arr_spent_time['message'] = 'error in the date definitions';
			} else if($spent_time == 0){
				// Nothing to change to $arr_spent_time
			} else {
				// Return spend time
				$arr_spent_time['days'] = floor($spent_time / 86400);
				$diff_spent_time = $spent_time % 86400;
				$arr_spent_time['hours'] = floor($diff_spent_time / 3600);
				$diff_spent_time = $diff_spent_time % 3600;
				$arr_spent_time['minutes'] = floor($diff_spent_time / 60);
				if($arr_spent_time['minutes']<10) {
					$arr_spent_time['minutes'] = '0' . $arr_spent_time['minutes'];
				}
			}
			
		}
		
		return $arr_spent_time;
	}

	/**
	 * Return time stamp of a date. 
	 * Notes: The supported date format is YYYY-MM-DD HH:MM:SS
	 * 
	 * @param $date_string Date
	 * @param $end_date End date
	 * 
	 * @return Return time stamp of the date.
	 * 
	 * @author N. Luc
	 * @since 2007-06-20
	 */
	 
	function getTimeStamp($date_string){
		list($date, $time) = explode(' ', $date_string);
		list($year, $month, $day) = explode('-', $date);
		list($hour, $minute, $second) = explode(':',$time);

		return mktime($hour, $minute, $second, $month, $day, $year);
	}
	
	/**
	 * Get list of banks.
	 * 
	 * Note: Function to allow bank to customize this function when they don't use 
	 * ADministrate module.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getBankList() {
		return $this->Administrates->getBankList();
	}
	
	/**
	 * Get list of SOPs existing to build inventory entity like collection, aliquot, etc.
	 *
	 * @param $entity_type Type of the studied inventory entity (collection, sample, aliquot)
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getSopList($entity_type) {
		switch($entity_type) {
			case 'collection':
			case 'sample':
			case 'aliquot':
				return $this->Sops->getSopList();
				break;
			default:
				$this->redirect('/pages/err_inv_system_error', null, true); 
		}
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
	
	/**
	 * Get list of 'derivative' sample types that could be created from 
	 * a 'parent' sample type.
	 *
	 * @param $parent_sample_control_id ID of the sample control linked the studied parent sample.
	 * 
	 * @return List of allowed derivative types stored into the following array:
	 * 	array('sample_control_id' => 'sample_type')
	 * 
	 * @author N. Luc
	 * @since 2009-11-01
	 */	
	
	function getAllowedDerivativeTypes($parent_sample_control_id) {
		$criteria = array(
			'ParentSampleControl.id' => $parent_sample_control_id,
			'ParentToDerivativeSampleControl.status' => 'active',
			'DerivativeControl.status' => 'active');
		$allowed_derivative_type_temp = $this->ParentToDerivativeSampleControl->find('all', array('conditions' => $criteria, 'order' => 'DerivativeControl.sample_type ASC'));

		$allowed_derivative_type = array();
		foreach($allowed_derivative_type_temp as $new_link) {
			$allowed_derivative_type[$new_link['DerivativeControl']['id']]['SampleControl'] = $new_link['DerivativeControl'];
		}
		
		return $allowed_derivative_type;
	}
	
	/**
	 * Get list of aliquot types that could be created from 
	 * a sample type.
	 *
	 * @param $sample_control_id ID of the sample control linked to the studied sample.
	 * 
	 * @return List of allowed aliquot types stored into the following array:
	 * 	array('aliquot_control_id' => 'aliquot_type')
	 * 
	 * @author N. Luc
	 * @since 2009-11-01
	 */	
	
	function getAllowedAliquotTypes($sample_control_id) {
		$criteria = array(
			'SampleControl.id' => $sample_control_id,
			'SampleToAliquotControl.status' => 'active',
			'AliquotControl.status' => 'active');
		$allowed_aliquot_type_temp = $this->SampleToAliquotControl->find('all', array('conditions' => $criteria, 'order' => 'AliquotControl.aliquot_type ASC'));
		
		$allowed_aliquot_type = array();
		foreach($allowed_aliquot_type_temp as $new_link) {
			$allowed_aliquot_type[$new_link['AliquotControl']['id']]['AliquotControl'] = $new_link['AliquotControl'];
		}
		
		return $allowed_aliquot_type;		
	}	
	
	function manageSpentTimeDataDisplay($spent_time_data) {
		$spent_time_msg = '';
		if(!empty($spent_time_data)) {		
			if(!empty($spent_time_data['message'])) { 
				$spent_time_msg = __($spent_time_data['message'], TRUE); 
			} else {
				$spent_time_msg = $this->translateDateValueAndUnit($spent_time_data, 'days') 
								.$this->translateDateValueAndUnit($spent_time_data, 'hours') 
								.$this->translateDateValueAndUnit($spent_time_data, 'minutes');
			} 	
		}
		return $spent_time_msg;
	}
	
	function translateDateValueAndUnit($spent_time_data, $time_unit) {
		if(array_key_exists($time_unit, $spent_time_data)) {
			return (((!empty($spent_time_data[$time_unit])) && ($spent_time_data[$time_unit] != '00'))? ($spent_time_data[$time_unit] . ' ' . __($time_unit, TRUE) . ' ') : '');
		} 
		return  '#err#';
	}
		
	function samf_listAll($collection_id, $sample_master_id, $filter_option = null) {
		if((!$collection_id) || (!$sample_master_id)) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }

		// MANAGE FILTER OPTION

		$is_collection_aliquot_list = ($sample_master_id == '-1')? true: false;

		$specific_aliquot_search_criteria = array();
		$specific_form_alias = null;
		$specific_menu_variables = array();

		if($is_collection_aliquot_list) {
			// User is working on collection aliquots list
				
			// Manage filter option
			if(is_null($filter_option)) {
				if(isset($_SESSION['InventoryManagement']['CollectionAliquots']['Filter'])) {
					// Get existing filter
					$filter_option = $_SESSION['InventoryManagement']['CollectionAliquots']['Filter'];
				}
			} else if($filter_option == '-1') {
				// User inactived filter
				$filter_option = null;
				unset($_SESSION['InventoryManagement']['CollectionAliquots']['Filter']);
			}
				
			// Search data to display
			$specific_menu_variables['FilterLevel'] = 'collection';

			if(!is_null($filter_option)) {
				// Get filter options
				$option_for_list_all = explode("|", $filter_option);
				if(sizeof($option_for_list_all) != 2)  { $this->redirect('/pages/err_inv_system_error', null, true); }
				$sample_control_id = $option_for_list_all[0];
				$aliquot_control_id = $option_for_list_all[1];

				$specific_aliquot_search_criteria['SampleMaster.sample_control_id'] = $sample_control_id;
				$specific_aliquot_search_criteria['AliquotMaster.aliquot_control_id'] = $aliquot_control_id;

				$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('SampleControl.id' => $sample_control_id)));
				if(empty($sample_control_data)) { $this->redirect('/pages/err_inv_no_samp_cont_data', null, true); }
				$specific_menu_variables['SampleTypeForFilter'] = $sample_control_data['SampleControl']['sample_type'];

				$aliquot_control_data = $this->AliquotControl->find('first', array('conditions' => array('AliquotControl.id' => $option_for_list_all[1])));
				if(empty($aliquot_control_data)) { $this->redirect('/pages/err_inv_no_aliqu_cont_data', null, true); }
				$specific_form_alias = $aliquot_control_data['AliquotControl']['form_alias'];
				$specific_menu_variables['AliquotTypeForFilter'] = $aliquot_control_data['AliquotControl']['aliquot_type'];

				// Set filter option in session
				$_SESSION['InventoryManagement']['CollectionAliquots']['Filter'] = $filter_option;
			}
				
		} else {
			// User is working on sample aliquots list
			$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '-1'));
			if(empty($sample_data)) { $this->redirect('/pages/err_inv_samp_no_data', null, true); }
			$specific_menu_variables['SampleMaster.initial_specimen_sample_id'] = $sample_data['SampleMaster']['initial_specimen_sample_id'];
			$specific_menu_variables['SampleMaster.id'] = $sample_data['SampleMaster']['id'];

			// Set sample master id into criteria
			$specific_aliquot_search_criteria['AliquotMaster.sample_master_id'] = $sample_master_id;
				
			// Manage filter option
			if(is_null($filter_option)) {
				// Get existing filter
				if(isset($_SESSION['InventoryManagement']['SampleAliquots']['Filter'])) {
					if($_SESSION['InventoryManagement']['SampleAliquots']['Filter']['SampleMasterId'] != $sample_master_id) {
						// New studied sample: clear filter option
						$filter_option = null;
						unset($_SESSION['InventoryManagement']['SampleAliquots']['Filter']);

					} else {
						// Get existing filter
						$filter_option = $_SESSION['InventoryManagement']['SampleAliquots']['Filter']['Option'];
					}
				}
			} else if($filter_option == '-1') {
				// User inactived filter
				$filter_option = null;
				unset($_SESSION['InventoryManagement']['SampleAliquots']['Filter']);
			}
				
			// Search data to display
			$specific_menu_variables['FilterLevel'] = 'sample';

			if(!is_null($filter_option)) {
				// Get filter options (being sample_control_id and aliquot_control_id)
				$option_for_list_all = explode("|", $filter_option);
				if(sizeof($option_for_list_all) != 2)  { $this->redirect('/pages/err_inv_system_error', null, true); }
				$sample_control_id = $option_for_list_all[0];
				$aliquot_control_id = $option_for_list_all[1];

				$specific_aliquot_search_criteria['AliquotMaster.aliquot_control_id'] = $aliquot_control_id;

				$aliquot_control_data = $this->AliquotControl->find('first', array('conditions' => array('AliquotControl.id' => $option_for_list_all[1])));
				if(empty($aliquot_control_data)) { $this->redirect('/pages/err_inv_no_aliqu_cont_data', null, true); }
				$specific_form_alias = $aliquot_control_data['AliquotControl']['form_alias'];
				$specific_menu_variables['AliquotTypeForFilter'] = $aliquot_control_data['AliquotControl']['aliquot_type'];

				// Set filter option in session
				$_SESSION['InventoryManagement']['SampleAliquots']['Filter'] = array(
					'SampleMasterId' => $sample_master_id,
					'Option' => $filter_option);
			}
		}

		// MANAGE DATA

		$this->setAliquotSearchData(array_merge(array('AliquotMaster.collection_id' => $collection_id), $specific_aliquot_search_criteria));

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$form_alias = (is_null($specific_form_alias))? 'aliquotmasters': $specific_form_alias;
		$this->set('aliquots_listall_structure', $this->Structures->get('form', $form_alias));

		// Get all collection/sample 'sample aliquot type list' to build the filter button
		$sample_aliquot_types = array();
		$criteria = array('AliquotMaster.collection_id' => $collection_id);
		if(!$is_collection_aliquot_list) { $criteria['AliquotMaster.sample_master_id'] = $sample_master_id; }
		$tmp_sample_aliquot_type_list = $this->AliquotMaster->find('all', array('fields' => 'DISTINCT SampleMaster.sample_type, SampleMaster.sample_control_id, AliquotMaster.aliquot_type, AliquotMaster.aliquot_control_id', 'conditions' => $criteria, 'order' => 'SampleMaster.sample_type ASC, AliquotMaster.aliquot_type ASC', 'recursive' => '0'));
		foreach($tmp_sample_aliquot_type_list as $new_sample_aliquot_type) {
			// Should create key because looks like it's not a real distinct: Perhaps exists a better solution
			$sample_control_id = $new_sample_aliquot_type['SampleMaster']['sample_control_id'];
			$aliquot_control_id = $new_sample_aliquot_type['AliquotMaster']['aliquot_control_id'];
			$sample_aliquot_types[$sample_control_id . '|' . $aliquot_control_id] = array(
				'sample_type' => $new_sample_aliquot_type['SampleMaster']['sample_type'],
				'sample_control_id' => $new_sample_aliquot_type['SampleMaster']['sample_control_id'],
				'aliquot_type' => $new_sample_aliquot_type['AliquotMaster']['aliquot_type'],
				'aliquot_control_id' => $new_sample_aliquot_type['AliquotMaster']['aliquot_control_id']);
		}
		$this->set('existing_sample_aliquot_types', $sample_aliquot_types);

		// Get all aliquot control types to build the add to selected button
		$allowed_aliquot_type = array();
		if(!$is_collection_aliquot_list) {
			$allowed_aliquot_type = $this->getAllowedAliquotTypes($sample_data['SampleMaster']['sample_control_id']);
		}
		$this->set('allowed_aliquot_type', $allowed_aliquot_type);

		// Get the current menu object
		$last_menu_parameter = '-1';
		if(!$is_collection_aliquot_list) {
			// User is working on sample aliquots
			if($specific_menu_variables['SampleMaster.initial_specimen_sample_id'] == $specific_menu_variables['SampleMaster.id']) {
				// Studied sample is a specimen
				$last_menu_parameter = '%%SampleMaster.initial_specimen_sample_id%%';
			} else {
				// Studied sample is a derivative
				$last_menu_parameter = '%%SampleMaster.id%%';
			}
		}
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/aliquot_masters/listAll/%%Collection.id%%/' . $last_menu_parameter));

		// Set menu variables
		$atim_menu_variables = array_merge(array('Collection.id' => $collection_id), $specific_menu_variables);
		$this->set('atim_menu_variables', $atim_menu_variables);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function setAliquotSearchData($criteria) {
		// Search Data
		$has_many_details = array(
			'hasMany' => array(
				'RealiquotedParent' => array(
					'className' => 'Inventorymanagement.Realiquoting',
					'foreignKey' => 'child_aliquot_master_id'),
				'ChildrenAliquot' => array(
					'className' => 'Inventorymanagement.Realiquoting',
					'foreignKey' => 'parent_aliquot_master_id')));
		
		$this->AliquotMaster->bindModel($has_many_details, false);	
		$working_data = $this->paginate($this->AliquotMaster, $criteria);
		$this->AliquotMaster->unbindModel(array('hasMany' => array('RealiquotedParent', 'ChildrenAliquot')), false);
		
		// Manage Data
		$key_to_sample_parent_id = array();
		foreach($working_data as $key => $aliquot_data) {
			// Set aliquot use
			//TODO add patch to correct bug listed in issue #650
			$working_data[$key]['Generated']['aliquot_use_counter'] = sizeof($aliquot_data['AliquotUse']);
			
			// Set realiquoting data
			$realiquoting_value = 0;
			$realiquoting_value += (sizeof($aliquot_data['ChildrenAliquot']))? 1: 0;
			$realiquoting_value += (sizeof($aliquot_data['RealiquotedParent']))? 2: 0;
			
			switch($realiquoting_value) {
				case '0':
					$working_data[$key]['Generated']['realiquoting_data'] = 'n/a';
					break;
				case '1':
					$working_data[$key]['Generated']['realiquoting_data'] = 'parent';
					break;
				case '2':
					$working_data[$key]['Generated']['realiquoting_data'] = 'child';
					break;
				case '3':
					$working_data[$key]['Generated']['realiquoting_data'] = 'parent/child';
					break;	
			}
			
			// Build GeneratedParentSample
			$working_data[$key]['GeneratedParentSample'] = array();
			if(!empty($aliquot_data['SampleMaster']['parent_id'])) { $key_to_sample_parent_id[$key] = $aliquot_data['SampleMaster']['parent_id']; }
		}
		
		// Add GeneratedParentSample Data
		$parent_sample_data = $this->SampleMaster->atim_list(array('conditions' => array('SampleMaster.id' => $key_to_sample_parent_id), 'recursive' => '-1'));
		foreach($key_to_sample_parent_id as $key => $parent_id) {
			if(!isset($parent_sample_data[$parent_id])) { $this->redirect('/pages/err_inv_system_error', null, true); }
			$working_data[$key]['GeneratedParentSample'] = $parent_sample_data[$parent_id]['SampleMaster'];
		}
		
		$this->set('aliquots_data', $working_data);
		
		// Set list of banks
		$this->set('banks', $this->getBankList());
	}
	
	

}

?>
