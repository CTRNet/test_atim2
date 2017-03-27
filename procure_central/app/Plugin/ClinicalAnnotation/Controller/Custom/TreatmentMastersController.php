<?php

class TreatmentMastersControllerCustom extends TreatmentMastersController {

	var $paginate = array('TreatmentMaster'=>array('limit' => pagination_amount,'order'=>'TreatmentMaster.start_date DESC'));
	
	function listallBasedOnControlId($participant_id, $treatment_control_id, $interval_start_date = null, $interval_start_date_accuracy = '', $interval_finish_date = null, $interval_finish_date_accuracy = ''){
		//*** Specific list display based on control_id
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/listall/%%Participant.id%%'));
		$treatment_control = $this->TreatmentControl->getOrRedirect($treatment_control_id);
		$this->Structures->set(($treatment_control['TreatmentControl']['tx_method'] == 'procure medication worksheet')? '': $treatment_control['TreatmentControl']['form_alias']);
		if(is_null($interval_start_date) && is_null($interval_finish_date)) {
			// 1- No Date Restriction (probably generic listall form)
			$this->request->data = $this->paginate($this->TreatmentMaster, array('TreatmentMaster.participant_id' => $participant_id, 'TreatmentMaster.treatment_control_id' => $treatment_control_id));
		} else {
			// 2- Date Restriction (probaby list linked to Medication Worksheet detail display or Follow-up Worksheet detail display)
			$interval_start_date = preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $interval_start_date)? $interval_start_date : '';
			$interval_finish_date = preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $interval_finish_date)? $interval_finish_date : '';
			$drugs_list_conditions = array(
				'TreatmentMaster.participant_id' => $participant_id, 
				'TreatmentMaster.treatment_control_id' => $treatment_control_id);
			if($interval_start_date && $interval_finish_date) {
				$drugs_list_conditions[]['OR'] = array(
					"TreatmentMaster.start_date IS NULL AND TreatmentMaster.finish_date IS NULL",
					"TreatmentMaster.start_date IS NOT NULL AND '$interval_start_date' <= TreatmentMaster.start_date  AND TreatmentMaster.start_date <= '$interval_finish_date'",
					"TreatmentMaster.finish_date IS NOT NULL AND '$interval_start_date' <= TreatmentMaster.finish_date AND TreatmentMaster.finish_date <= '$interval_finish_date'",
					"TreatmentMaster.start_date IS NULL AND TreatmentMaster.finish_date IS NOT NULL AND '$interval_finish_date' < TreatmentMaster.finish_date",
					"TreatmentMaster.finish_date IS NULL AND TreatmentMaster.start_date IS NOT NULL AND TreatmentMaster.start_date < '$interval_start_date'",
					"TreatmentMaster.start_date < $interval_start_date AND '$interval_finish_date' < TreatmentMaster.finish_date");
			} else if($interval_start_date){
				$drugs_list_conditions[]['OR'] = array(
					"TreatmentMaster.start_date IS NULL AND TreatmentMaster.finish_date IS NULL",
					"TreatmentMaster.finish_date IS NOT NULL AND TreatmentMaster.finish_date >= '$interval_start_date'");
			} else if($interval_finish_date){
				$drugs_list_conditions[]['OR'] = array(
					"TreatmentMaster.start_date IS NULL AND TreatmentMaster.finish_date IS NULL",
					"TreatmentMaster.start_date IS NOT NULL AND TreatmentMaster.start_date <= '$interval_finish_date'");
			}
			$this->request->data = $this->paginate($this->TreatmentMaster, $drugs_list_conditions);
		}
	}
}

?>