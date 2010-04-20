<?php
/*
 * Created on 2009-11-26
 * Author NL
 *
 * Offer an example of code override.
 */
	 
class EventMastersControllerCustom extends EventMastersController {
 
 	// --------------------------------------------------------------------------------
	// NEW FORMS
	// --------------------------------------------------------------------------------
 
	function imageryReport( $participant_id ){
		$this->data = $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventControl.form_alias LIKE "qc_hb_imaging_%"')));
		$this->Structures->set('empty');
		$atim_menu_variables['Participant.id'] = $participant_id;
		$this->set('atim_menu_variables', $atim_menu_variables);
		$this->set('atim_menu', $this->Menus->get('/clinicalannotation/event_masters/imageryReport/%%Participant.id%%/'));
	}
	 
  	// --------------------------------------------------------------------------------
	// FUNCTIONS
	// --------------------------------------------------------------------------------
 	
 	/** 
 	 * Calculate BMI value for clinical.hepatobiliary.presentation data
 	 * and add it to submitted event data.
 	 * 
 	 * @param $event_data Submitted event data
 	 * @param $event_group 
 	 * @param $disease_site 
 	 * @param $event_type 
 	 * 
 	 * @return Updated event data
 	 * */
	
 	function addBmiValue( $event_data, $event_group, $disease_site, $event_type ) { 
 		if(($event_group === 'clinical') 
 		&& ($disease_site === 'hepatobiliary') 
 		&& ($event_type === 'presentation') 
 		&& (isset($event_data['EventDetail']['weight'])) 
 		&& (isset($event_data['EventDetail']['height']))) {
			// Format 'numeric' value
			$event_data['EventDetail']['weight'] = str_replace(',', '.', $event_data['EventDetail']['weight']);
			$event_data['EventDetail']['height'] = str_replace(',', '.', $event_data['EventDetail']['height']);
			
			$weight = $event_data['EventDetail']['weight'];
			$height = $event_data['EventDetail']['height'];
			
			if(is_numeric($weight) && is_numeric($height) && (!empty($height))) {
				$event_data['EventDetail']['bmi'] =  pow(($weight/$height), 2);
			} 
		}
		
		return $event_data;	
 	}
 	
  	/** 
 	 * Set medical past history precisions list for clinical.hepatobiliary.***medical_past_history.
 	 * 
 	 * @param $event_control Event control of the created/studied event.
 	 **/
 	 
	function setMedicalPastHistoryPrecisions( $event_control ) { 
		$event_type_title = 
			$event_control['EventControl']['disease_site'].'-'.
			$event_control['EventControl']['event_group'].'-'.
			$event_control['EventControl']['event_type'];
				
		$pattern = '/^hepatobiliary-clinical-(.*)medical past history?/';
		if(preg_match($pattern, $event_type_title)) { 
			
			// load model
			App::import('Model', 'clinicalannotation.MedicalPastHistoryCtrl');		
			$this->MedicalPastHistoryCtrl = new MedicalPastHistoryCtrl();	
			
			// Get list of disease precisions
			$fields = 'DISTINCT MedicalPastHistoryCtrl.disease_precision';
			$criteria = array('MedicalPastHistoryCtrl.event_control_id' => $event_control['EventControl']['id']);
			$order = 'MedicalPastHistoryCtrl.display_order ASC';
			
			$tmp_medical_past_history_precisions = $this->MedicalPastHistoryCtrl->find('all', array('fields' => $fields, 'conditions' => $criteria, 'order' => $order));
			$medical_past_history_precisions = array();
			foreach($tmp_medical_past_history_precisions as $new_type) {
				$medical_past_history_precisions[$new_type['MedicalPastHistoryCtrl']['disease_precision']] = __($new_type['MedicalPastHistoryCtrl']['disease_precision'], true);
			}
			$this->set('medical_past_history_precisions', $medical_past_history_precisions);
		}
	}
	
	/** 
 	 * Set all required structures according to the imaging report type:
 	 * 	- date & summary
 	 * 	- pancreas
 	 * 	- volumetry
 	 * 	- segment
 	 * 	- other.
 	 * 
 	 * @param $event_control_data Event control data of the created/studied event.
 	 **/
 	 
	function setMedicalImaginStructures($event_control_data){
		if(strpos($event_control_data['EventControl']['form_alias'], 'qc_hb_imaging') === 0){
			
			// Set date and summary structure for all
			$this->Structures->set('qc_hb_dateNSummary', 'qc_hb_dateNSummary_for_imaging');
			$last_imaging_structure = 'qc_hb_dateNSummary_for_imaging';
			
			// Segments
			if(strpos($event_control_data['EventControl']['form_alias'], 'segment') > 0){
				$this->Structures->set('qc_hb_segment', 'qc_hb_segment');
				$last_imaging_structure = 'qc_hb_segment';
			}	
			// Other
			if(strpos($event_control_data['EventControl']['form_alias'], 'other') > 0){
				$this->Structures->set('qc_hb_other_localisations', 'qc_hb_other_localisations');
				$last_imaging_structure = 'qc_hb_other_localisations';
			}	
			// Pancreas
			if(strpos($event_control_data['EventControl']['form_alias'], 'pancreas') > 0){
				$this->Structures->set('qc_hb_pancreas', 'qc_hb_pancreas');
				$last_imaging_structure = 'qc_hb_pancreas';
			}
			// Volumetry
			if(strpos($event_control_data['EventControl']['form_alias'], 'volumetry') > 0){
				$this->Structures->set('qc_hb_volumetry', 'qc_hb_volumetry');
				$last_imaging_structure = 'qc_hb_volumetry';
			}
			
			$this->set('last_imaging_structure', $last_imaging_structure);
		}	
	}
 	
 	/** 
 	 * Complete volumetry data for clinical.hepatobiliary.medical imaging *** - volumetry
 	 * and add it to submitted event data.
 	 * 
 	 * @param $event_data Submitted event data
 	 * 
 	 * @return Updated event data
 	 * */
	
 	function completeVolumetry( $event_data ) { 
 		if(isset($event_data['EventDetail']['is_volumetry_post_pve'])) {
 			
 			if(isset($event_data['EventDetail']['total_liver_volume'])
 			&& is_numeric($event_data['EventDetail']['total_liver_volume'])
 			&& isset($event_data['EventDetail']['resected_liver_volume'])
 			&& is_numeric($event_data['EventDetail']['resected_liver_volume'])) {
 				
 				// Remanant liver volume (= total liver volume - resected liver volume)
 				$remnant_liver_volume = $event_data['EventDetail']['total_liver_volume'] - $event_data['EventDetail']['resected_liver_volume'];
 				
 				// Remanant liver percentage (= (remnant liver volume / (total_liver_volume - tumoral_volume)) * 100 ))
 				$remnant_liver_percentage = '';
	 			if(isset($event_data['EventDetail']['tumoral_volume'])
	 			&& is_numeric($event_data['EventDetail']['tumoral_volume'])) {
	 				$diff = $event_data['EventDetail']['total_liver_volume'] - $event_data['EventDetail']['tumoral_volume'];
	 				if(!empty($diff)) {
	 					$remnant_liver_percentage = ($remnant_liver_volume / $diff) * 100;
	 				}
	 			} 
	 			
	 			$event_data['EventDetail']['remnant_liver_volume'] = $remnant_liver_volume;
 				$event_data['EventDetail']['remnant_liver_percentage'] = $remnant_liver_percentage;				
 			}
 			
 			// Remanant liver volume
 			if(isset($event_data['EventDetail']['total_liver_volume'])
 			&& is_numeric($event_data['EventDetail']['total_liver_volume'])
 			&& isset($event_data['EventDetail']['tumoral_volume'])
 			&& is_numeric($event_data['EventDetail']['tumoral_volume'])) {
 				$event_data['EventDetail']['remnant_liver_volume'] = $event_data['EventDetail']['total_liver_volume'] - $event_data['EventDetail']['resected_liver_volume'];
 			} 
 		}
 			
 		return $event_data;		
 	}
}
	
?>
