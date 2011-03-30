<?php

class InventorymanagementAppController extends AppController {	
		
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
	 * @deprecated as of 2010-08-04. use SampleControl->getPermissibleSamplesArray($parent_sample_control_id)
	 */	
	
	function getAllowedDerivativeTypes($parent_sample_control_id) {
		if(Configure::read('debug') == 2){
			echo("WARNING: USAGE OF A DEPRECATED FUNCTION (getAllowedDerivativeTypes) [file:".__FILE__." - line".__LINE__."]");
		}
		return $this->SampleControl->getPermissibleSamplesArray($parent_sample_control_id);
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
	 * @deprecated as of 2010-08-04. use AliquotControl->getPermissibleAliquotsArray($parent_sample_control_id)
	 */	
	
	function getAllowedAliquotTypes($sample_control_id) {
		if(Configure::read('debug') == 2){
			echo("WARNING: USAGE OF A DEPRECATED FUNCTION (getAllowedAliquotTypes) [file:".__FILE__." - line".__LINE__."]");
		}
		return $this->AliquotControl->getPermissibleAliquotsArray($sample_control_id);
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
				'message' => null,
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
				$arr_spent_time['message'] = '0';
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
	
	function manageSpentTimeDataDisplay($spent_time_data) {
		$spent_time_msg = '';
		if(!empty($spent_time_data)) {	
			if(!is_null($spent_time_data['message'])) {
				if($spent_time_data['message'] == '0') {
					$spent_time_msg = $spent_time_data['message'];
				} else if(strcmp('error in the date definitions', $spent_time_data['message']) == 0) {
					$spent_time_msg = '<span class="red">'.__($spent_time_data['message'], TRUE).'</span>';
				} else {
					$spent_time_msg = __($spent_time_data['message'], TRUE);
				}
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
