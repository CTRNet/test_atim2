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
	 * @deprecated use app model function
	 */
	 
	function getSpentTime($start_date, $end_date){
		if(Configure::read('debug') == 2){
			echo("WARNING: USAGE OF A DEPRECATED FUNCTION (getSpentTime) [file:".__FILE__." - line".__LINE__."]");
		}
		return AppModel::getSpentTime($start_date, $end_date);;
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
	 * @deprecated use app model function
	 */
	 
	function getTimeStamp($date_string){
		if(Configure::read('debug') == 2){
			echo("WARNING: USAGE OF A DEPRECATED FUNCTION (getTimeStamp) [file:".__FILE__." - line".__LINE__."]");
		}
		return AppModel::getTimeStamp($date_string);
	}	
	
	/**
	 * @deprecated use app model function
	 */
	
	function manageSpentTimeDataDisplay($spent_time_data) {
		if(Configure::read('debug') == 2){
			echo("WARNING: USAGE OF A DEPRECATED FUNCTION (getTimeStamp) [file:".__FILE__." - line".__LINE__."]");
		}
		return AppModel::manageSpentTimeDataDisplay($spent_time_data);
	}
	
	/**
	 * @deprecated use app model function
	 */
	
	function translateDateValueAndUnit($spent_time_data, $time_unit) {
		if(Configure::read('debug') == 2){
			echo("WARNING: USAGE OF A DEPRECATED FUNCTION (translateDateValueAndUnit) [file:".__FILE__." - line".__LINE__."]");
		}
		return AppModel::translateDateValueAndUnit($spent_time_data, $time_unit);
	}
}

?>
