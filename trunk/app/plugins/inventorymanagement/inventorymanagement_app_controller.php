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
			
			if(($start === FALSE)||($end === FALSE)){
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
					$arr_spent_time['minutes'] = '0'.$arr_spent_time['minutes'];
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
				$this->redirect('/pages/err_inv_system_error', NULL, TRUE); 
		}
	}
	
	
	
	
	
	

	
	
	
	
	//TODO validate following function
	
	
	
	
	
	
	
	
	/**
	 * Return list of studies to reserve an aliquot for this one.
	 * 
	 * @return Return array of studies having following structure.
	 * [study_summary_id] = study title
	 * 
	 * @author N. Luc
	 * @since 2008-08-15
	 */
	function getStudiesArray() {

		$arr_study_summary_id = 
				$this->StudySummary->generateList(
					null, 
					null, 
					null, 
					'{n}.StudySummary.id', 
					'{n}.StudySummary.title');
		
		if(empty($arr_study_summary_id)) {
			$arr_study_summary_id = array();
		}
		
		$arr_study_summary_id = array(NULL => 'N/A') + $arr_study_summary_id;
				
		return $arr_study_summary_id;
	}
	
	function getSpecimenGroupMenu($specimen_group_menu_id) {
		
		$criteria = array();
		$criteria[] = "Menu.id LIKE '$specimen_group_menu_id%'";		
		
		$specimen_grp_menu_lists = 
			$this->Menu->generateList(
				$criteria, 
				null, 
				null, 
				'{n}.Menu.id', 
				'{n}.Menu.parent_id');
				
		if(empty($specimen_grp_menu_lists)) {
			return array();	
		}
		
		return $specimen_grp_menu_lists;
				
	}
	
	function validateSpecimenGroupMenu($specimen_grp_menu_lists, $menu_id, $parent_id) {
		
			if(empty($specimen_grp_menu_lists)) {
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
			}
			
			if(!isset($specimen_grp_menu_lists[$menu_id])) {
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;
			}
			
			if(strcmp($parent_id, $specimen_grp_menu_lists[$menu_id]) != 0) {
				$this->redirect('/pages/err_inv_menu_definition'); 
				exit;			
			}
		
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
	function updateAliquotCurrentVolume($aliquot_master_id){

//TODO: There was a bug attached to this function
//The system is unable to update correclty the current volume when this function has been called 
//by a function that added a record into the use table (the last aliquot use won't be take in consideration).

		// Verify aliquot_master_id has been defined. 
		if (empty($aliquot_master_id)) {
			$this->redirect('/pages/err_inv_aliquot_no_id'); 
			exit;
		} 
		
		$criteria = 'AliquotMaster.id ="'.$aliquot_master_id.'"';
		$tmp_aliquot_data = $this->AliquotMaster->find($criteria, null, null, 1);

		if (empty($tmp_aliquot_data)) {
			$this->redirect('/pages/err_inv_aliquot_no_data'); 
			exit;
		}
		
		$aliquot_status = $tmp_aliquot_data['AliquotMaster']['status'];
		$aliquot_status_reason = $tmp_aliquot_data['AliquotMaster']['status_reason'];
		
		$initial_volume = $tmp_aliquot_data['AliquotMaster']['initial_volume'];
		$current_volume = $tmp_aliquot_data['AliquotMaster']['current_volume'];
		
		$new_current_volume = NULL;
		$update = FALSE;
		
		if(empty($initial_volume)){	
			// Initial_volume is null
			
			if(empty($current_volume)){
				// Nothing to change
				return;	
			} else {
				// Update current volume but don't change status of the aliquot
				// We consider that if the user set the intial volume to NULL, he should 
				// have managed the status.
				$new_current_volume = $initial_volume;
				$update = TRUE;
			}
			
		} else if(is_numeric($initial_volume) && ($initial_volume == 0)) {
			// Initial_volume is equal to 0.0000
			
			if(is_numeric($current_volume) && ($current_volume == 0)){
				// Nothing to change
				return;	
			} else {
				// Update current volume but don't change status of the aliquot
				// We consider that if the user set the intial volume to 0, he should 
				// have managed the status.
				$new_current_volume = $initial_volume;
				$update = TRUE;
			}
			
		}else {
			// A value has been recorded for the intial volume
					
			if(!is_numeric($initial_volume)){
				$this->redirect('/pages/err_inv_system_error'); 
				exit;
			}
	
			if($initial_volume < 0){
				$this->redirect('/pages/err_inv_system_error'); 
				exit;
			}
		
			$new_current_volume = $initial_volume;
			
			//TODO: Additional line to fixe bug defined at the begining
			// Can not use directly $tmp_aliquot_data['AliquotUse'].
			$criteria = 'AliquotUse.aliquot_master_id ="'.$aliquot_master_id.'"';			
			$tmp_aliquot_use_data = $this->AliquotUse->findAll($criteria, null, null, null, 1);		
			
			foreach($tmp_aliquot_use_data as $id => $aliquot_use){
				if(!empty($aliquot_use['AliquotUse']['used_volume'])){
					// Take used volume in consideration only when this one is not empty
					if(!(is_numeric($aliquot_use['AliquotUse']['used_volume']))){
						$this->redirect('/pages/err_inv_system_error'); 
						exit;
					}
					$new_current_volume= bcsub($new_current_volume, $aliquot_use['AliquotUse']['used_volume'], 5);
				}
			}
			
			if($new_current_volume <= 0){
				
				$new_current_volume = 0;
				
				if(strcmp($aliquot_status, 'available')==0){
					// Change status and reason only when this one was 'available'
					$aliquot_status = 'not available';
					$aliquot_status_reason = 'empty';
					$update = TRUE;
				}
				
			}
			
			if(!is_numeric($current_volume)){
				$update = TRUE;					
			} else if($current_volume != $new_current_volume){
				$update = TRUE;	
			}
		}
			
		if($update){
			
			// Update data
			$aliquot_data_to_update = array();

			$aliquot_data_to_update['AliquotMaster']['id'] = $aliquot_master_id;
			$aliquot_data_to_update['AliquotMaster']['current_volume'] = $new_current_volume;

//TODO: We decided to not change status automatically with Aaron.
//Should we uncomment these following lines... ?

//			$aliquot_data_to_update['AliquotMaster']['status'] = $aliquot_status;
//			$aliquot_data_to_update['AliquotMaster']['status_reason'] = $aliquot_status_reason;

			if(!$this->AliquotMaster->save($aliquot_data_to_update['AliquotMaster'])){
				$this->redirect('/pages/err_inv_aliquot_record_err'); 
				exit;
			}
			
		}

	}
	
	function updateAliquotUseDetailAndDate($aliquot_use_id, $aliquot_master_id, $details, $date) {
		
		$criteria = array();
		$criteria['AliquotUse.id'] = $aliquot_use_id;
		$criteria['AliquotUse.aliquot_master_id'] = $aliquot_master_id;
		$criteria = array_filter($criteria);
	
		$aliquot_use_data = $this->AliquotUse->find($criteria, null, null, 0);
		
		if(empty($aliquot_use_data)){
			$this->redirect('/pages/err_inv_aliq_use_no_data'); 
			exit;
		}
		
		$aliquot_use_data['AliquotUse']['use_details'] = $details;
		$aliquot_use_data['AliquotUse']['use_datetime'] = $date;
		
		if(!$this->AliquotUse->save($aliquot_use_data['AliquotUse'])){
			$this->redirect('/pages/err_inv_aliquot_use_record_err'); 
			exit;
		}
		
	}
	

}

?>
