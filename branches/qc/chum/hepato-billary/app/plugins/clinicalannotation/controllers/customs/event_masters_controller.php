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
 	 * Set participant surgeries list for hepatobiliary-lab-biology.
 	 * 
 	 * @param $event_control Event control of the created/studied event.
 	 * @param $particpant_id
 	 **/
 	 
	function setParticipantSurgeriesList( $event_control, $participant_id = null ) { 	
		$event_type_title = 
			$event_control['EventControl']['disease_site'].'-'.
			$event_control['EventControl']['event_group'].'-'.
			$event_control['EventControl']['event_type'];
				
		$pattern = '/^hepatobiliary-lab-biology?/';
		if(preg_match($pattern, $event_type_title)) { 	
			if(!isset($this->TreatmentMaster)) {
				App::import("Model", "Clinicalannotation.TreatmentMaster");
				$this->TreatmentMaster = new TreatmentMaster();	
			}
			
			$result = array();
			
			$criteria = array();
			if(!is_null($participant_id)) $criteria['TreatmentMaster.participant_id'] = $participant_id;
			$criteria[] = "TreatmentMaster.tx_method LIKE '%surgery%'";		
			foreach($this->TreatmentMaster->find('all', array('conditions'=>$criteria, 'order' => 'TreatmentMaster.start_date DESC')) as $new_surgery) {
				$result[$new_surgery['TreatmentMaster']['id']] = __($new_surgery['TreatmentMaster']['disease_site'], true) . ' - ' . __($new_surgery['TreatmentMaster']['tx_method'], true) . ' ' . $new_surgery['TreatmentMaster']['start_date'];	
			}
			
			$this->set('surgeries_for_lab_report', $result);
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
 	
	function setScores($event_control_event_type){
		if($event_control_event_type == "child pugh score (classic)" || $event_control_event_type == "child pugh score (mod)"){
			$this->setChildPughScore();
		}else if($event_control_event_type == "okuda score"){
			$this->setOkudaScore();
		}else if($event_control_event_type == "barcelona score"){
			$this->setBarcelonaScore();
		}else if($event_control_event_type == "clip score"){
			$this->setClipScore();
		}else if($event_control_event_type == "fong score"){
			$this->setFongScore();
		}else if($event_control_event_type == "gretch score"){
			$this->setGretchScore();
		}else if($event_control_event_type == "meld score"){
			$this->setMeldScore();
		}
	}
	
	function setChildPughScore(){
		$score = 0;
		$set_score = true;

		if($this->data['EventDetail']['bilirubin'] == "<34µmol/l" || $this->data['EventDetail']['bilirubin'] == "<68µmol/l"){
			++ $score;
		}else if($this->data['EventDetail']['bilirubin'] == "34 - 50µmol/l" || $this->data['EventDetail']['bilirubin'] == "68 - 170µmol/l"){
			$score += 2;
		}else if($this->data['EventDetail']['bilirubin'] == ">50µmol/l" || $this->data['EventDetail']['bilirubin'] == ">170µmol/l"){
			$score += 3;
		} else {
			$set_score = false;
		}
		
		if($this->data['EventDetail']['albumin'] == "<28g/l"){
			++ $score;
		}else if($this->data['EventDetail']['albumin'] == "28 - 35g/l"){
			$score += 2;
		}else if($this->data['EventDetail']['albumin'] == ">35g/l"){
			$score += 3;
		} else {
			$set_score = false;
		}
		
		if($this->data['EventDetail']['inr'] == "<1.7"){
			++ $score;
		}else if($this->data['EventDetail']['inr'] == "1.7 - 2.2"){
			$score += 2;
		}else if($this->data['EventDetail']['inr'] == ">2.2"){
			$score += 3;
		} else {
			$set_score = false;
		}
		
		if($this->data['EventDetail']['encephalopathy'] == "none"){
			++ $score;
		}else if($this->data['EventDetail']['encephalopathy'] == "grade I-II"){
			$score += 2;
		}else if($this->data['EventDetail']['encephalopathy'] == "grade III-IV"){
			$score += 3;
		} else {
			$set_score = false;
		}
		
		if($this->data['EventDetail']['ascite'] == "none"){
			++ $score;
		}else if($this->data['EventDetail']['ascite'] == "mild"){
			$score += 2;
		}else if($this->data['EventDetail']['ascite'] == "severe"){
			$score += 3;
		} else {
			$set_score = false;
		}
		
		if($set_score) {
			//no score if bellow 4
			if($score < 7 && $score > 4){
				$this->data['EventDetail']['result'] = "A";
			}else if($score <10){
				$this->data['EventDetail']['result'] = "B";
			}else if($score < 16){
				$this->data['EventDetail']['result'] = "C";
			}
			$this->data['EventDetail']['result'] .= " (".$score.")";			
		} else {
			$this->data['EventDetail']['result'] = '';
		}

	}
	
	function setOkudaScore(){
		$score = 0;
		$set_score = true;
		
		if($this->data['EventDetail']['bilirubin'] == ">=50µmol/l"){
			++ $score;
		} else if(empty($this->data['EventDetail']['bilirubin'])) {
			$set_score = false;
		}
		
		if($this->data['EventDetail']['albumin'] == "<30g/l"){
			++ $score;	
		} else if(empty($this->data['EventDetail']['albumin'])) {
			$set_score = false;
		}
		
		if($this->data['EventDetail']['ascite'] == "1"){
			++ $score;
		}
		
		if($this->data['EventDetail']['tumor_size_ratio'] == ">=50%"){
			++ $score;			
		} else if(empty($this->data['EventDetail']['tumor_size_ratio'])) {
			$set_score = false;
		}

		if($set_score) {		
			//no score if bellow 4
			if($score < 1){
				$this->data['EventDetail']['result'] = "I";
			}else if($score < 3){
				$this->data['EventDetail']['result'] = "II";
			}else{
				$this->data['EventDetail']['result'] = "III";
			}
			$this->data['EventDetail']['result'] .= " (".$score.")";
		} else {
			$this->data['EventDetail']['result'] = '';
		}
	}
	
	function setBarcelonaScore(){
		if($this->data['EventDetail']['who'] == "3 - 4"
		|| $this->data['EventDetail']['tumor_morphology'] == "indifferent"
		|| $this->data['EventDetail']['okuda_score'] == "III"
		|| $this->data['EventDetail']['liver_function'] == "child-pugh C"){
			$this->data['EventDetail']['result'] = "D";
			return;
		}
		
		if($this->data['EventDetail']['who'] == "1 - 2"
		|| $this->data['EventDetail']['tumor_morphology'] == "metastasis" 
		|| $this->data['EventDetail']['tumor_morphology'] == "vascular invasion"){
			$this->data['EventDetail']['result'] = "C";
			return;
		}
		
		// Stade A, B: all fields should be completed
		if(empty($this->data['EventDetail']['who']) 
		|| empty($this->data['EventDetail']['tumor_morphology'])
		|| empty($this->data['EventDetail']['okuda_score'])
		|| empty($this->data['EventDetail']['liver_function'])) { 
			$this->data['EventDetail']['result'] = '';
			return; 
		}
		
		// At this level:
		//   - $this->data['EventDetail']['who'] equals 0 (automatically)

		if(($this->data['EventDetail']['tumor_morphology'] == "multinodular")
		&& (($this->data['EventDetail']['okuda_score'] == "I")
		|| ($this->data['EventDetail']['okuda_score'] == "II"))
		&& (($this->data['EventDetail']['liver_function'] == "child-pugh A")
		|| ($this->data['EventDetail']['liver_function'] == "child-pugh B"))) {
			$this->data['EventDetail']['result'] = 'B';
			return;	
		}
		
		if(($this->data['EventDetail']['tumor_morphology'] == "3 tumors, < 3 cm")
		&& (($this->data['EventDetail']['okuda_score'] == "I")
		|| ($this->data['EventDetail']['okuda_score'] == "II"))
		&& (($this->data['EventDetail']['liver_function'] == "child-pugh A")
		|| ($this->data['EventDetail']['liver_function'] == "child-pugh B"))) {
			$this->data['EventDetail']['result'] = 'A4';
			return;	
		}
		
		if(($this->data['EventDetail']['tumor_morphology'] == "unique, < 5cm")
		&& ($this->data['EventDetail']['okuda_score'] == "I")) {
			if($this->data['EventDetail']['liver_function'] == "HTP, hyperbilirubinemia"){
				$this->data['EventDetail']['result'] = "A3";	
			}else if($this->data['EventDetail']['liver_function'] == "HTP, bilirubin N"){
				$this->data['EventDetail']['result'] = "A2";
			}else {
				$this->data['EventDetail']['result'] = "A1";
			}			
			return;			
		}		
		
		$this->data['EventDetail']['result'] = "?";
	}
	
	function setClipScore(){
		$set_score = true;
		
		$this->data['EventDetail']['result'] = 0;
		if($this->data['EventDetail']['child_pugh_score'] == "B"){
			++ $this->data['EventDetail']['result'];
		}else if($this->data['EventDetail']['child_pugh_score'] == "C"){
			$this->data['EventDetail']['result'] += 2;
		} else if(empty($this->data['EventDetail']['child_pugh_score'])) {
			$set_score = false;
		}
		
		if($this->data['EventDetail']['morphology_of_tumor'] == "multiple nodules & < 50%"){
			++ $this->data['EventDetail']['result'];
		}else if($this->data['EventDetail']['morphology_of_tumor'] == "massive or >= 50%"){
			$this->data['EventDetail']['result'] += 2;
		} else if(empty($this->data['EventDetail']['morphology_of_tumor'])) {
			$set_score = false;
		}
		
		if($this->data['EventDetail']['alpha_foetoprotein'] == ">= 400 g/L"){
			++ $this->data['EventDetail']['result'];
		} else if(empty($this->data['EventDetail']['alpha_foetoprotein'])) {
			$set_score = false;
		}
		
		if($this->data['EventDetail']['portal_thrombosis'] == "1"){
			++ $this->data['EventDetail']['result'];
		}
		
		if(!$set_score) {
			$this->data['EventDetail']['result'] = '';
		}
	}
	
	function setFongScore(){
		$this->data['EventDetail']['result'] = 0;
		if($this->data['EventDetail']['metastatic_lymph_nodes'] == 1){
			++ $this->data['EventDetail']['result'];
		}
		if($this->data['EventDetail']['interval_under_year'] == 1){
			++ $this->data['EventDetail']['result'];
		}
		if($this->data['EventDetail']['more_than_one_metastasis'] == 1){
			++ $this->data['EventDetail']['result'];
		}
		if($this->data['EventDetail']['metastasis_greater_five_cm'] == 1){
			++ $this->data['EventDetail']['result'];
		}
		if($this->data['EventDetail']['cea_greater_two_hundred'] == 1){
			++ $this->data['EventDetail']['result'];
		}
	}
	
	function setGretchScore(){
		$score = 0;
		$set_score = true;
		
		if($this->data['EventDetail']['karnofsky_index'] == "<= 80%"){
			$score += 3;
		} else if(empty($this->data['EventDetail']['karnofsky_index'])) {
			$set_score = false;
		}
		if($this->data['EventDetail']['bilirubin'] == ">=50µmol/l"){
			$score += 3;
		} else if(empty($this->data['EventDetail']['bilirubin'])) {
			$set_score = false;
		}
		if($this->data['EventDetail']['alkaline_phosphatase'] == ">= 2N"){
			$score += 2;
		} else if(empty($this->data['EventDetail']['alkaline_phosphatase'])) {
			$set_score = false;
		}
		if($this->data['EventDetail']['alpha_foetoprotein'] == ">= 35 µg/L"){
			$score += 2;
		} else if(empty($this->data['EventDetail']['alpha_foetoprotein'])) {
			$set_score = false;
		}
		if($this->data['EventDetail']['portal_thrombosis'] == 1){
			$score += 2;
		}
		
		if(!$set_score) {
			$this->data['EventDetail']['result'] = '';
		} else {
			if($score == 0){
				$this->data['EventDetail']['result'] = "A (0)";
			}else if($score < 6){
				$this->data['EventDetail']['result'] = "B (".$score.")";
			}else{
				$this->data['EventDetail']['result'] = "C (".$score.")";
			}			
		}
	}
	
	function setMeldScore(){
		$this->data['EventDetail']['result'] = null;
		
		// Get data
		$serum_cr = (is_numeric($this->data['EventDetail']['creatinine']) && (!empty($this->data['EventDetail']['creatinine'])))? $this->data['EventDetail']['creatinine'] : null;
		$serum_bilirubin = (is_numeric($this->data['EventDetail']['bilirubin']) && (!empty($this->data['EventDetail']['bilirubin'])))? $this->data['EventDetail']['bilirubin'] : null;
		$inr = (is_numeric($this->data['EventDetail']['inr']) && (!empty($this->data['EventDetail']['inr'])))? $this->data['EventDetail']['inr'] : null;
		
		//Launch calculation
		if(!(is_null($serum_cr) || is_null($serum_bilirubin) || is_null($inr))) {
			$serum_cr = ($this->data['EventDetail']['dialysis'] == 1)? '4' : $serum_cr;
			$this->data['EventDetail']['result'] = ( (0.957*log($serum_cr)) + (0.378*log($serum_bilirubin)) + (1.12*log($inr)) + 0.643 ) *10;
		}		
	}
}
	
?>
