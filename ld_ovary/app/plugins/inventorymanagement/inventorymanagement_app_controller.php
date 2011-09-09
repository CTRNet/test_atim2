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
}

?>
