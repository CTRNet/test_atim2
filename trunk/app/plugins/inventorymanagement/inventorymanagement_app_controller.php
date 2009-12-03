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
		
		
		


	
	

	
	
	
	

	

}

?>
