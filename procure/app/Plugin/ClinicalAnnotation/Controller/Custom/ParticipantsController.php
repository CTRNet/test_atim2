<?php
class ParticipantsControllerCustom extends ParticipantsController{
	
	function chronology($participant_id){		$tmp_array = array();
		$tmp_array = array();
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		$this->Structures->set('chronology', 'chronology');
	
		
		//Get control varaibles
		
		$StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
		$Drug = AppModel::getInstance("Drug", "Drug", true);
		$all_drugs = $Drug->getDrugPermissibleValues();

		//accuracy_sort
		$a_s = array(
				'±'	=> 0,
				'y'	=> 1,
				'm'	=> 2,
				'd'	=> 3,
				'h'	=> 4,
				'i'	=> 5,
				'c'	=> 6,
				'' => 7
		);
	
		$add_to_tmp_array = function(array $in) use($a_s, &$tmp_array){
			if($in['date']){
				$tmp_array[$in['date'].$a_s[$in['date_accuracy']]][] = $in;
			}else{
				$tmp_array[' '][] = $in;
			}
		};
	
		//load every wanted information into the tmpArray
		$participant = $this->Participant->find('first', array('conditions' => array('Participant.id' => $participant_id)));
		$add_to_tmp_array(array(
				'date'			=> $participant['Participant']['date_of_birth'],
				'event' 		=> __('date of birth'),
				'link'			=> '/ClinicalAnnotation/Participants/profile/'.$participant_id.'/',
				'procure_chronology_details' => '',
				'date_accuracy'	=> $participant['Participant']['date_of_birth_accuracy']
		));
	
		if(strlen($participant['Participant']['date_of_death']) > 0){
			$add_to_tmp_array(array(
					'date'			=> $participant['Participant']['date_of_death'],
					'event'			=> __('date of death'),
					'link'			=> '/ClinicalAnnotation/Participants/profile/'.$participant_id.'/',
					'procure_chronology_details' => '',
					'date_accuracy'	=> $participant['Participant']['date_of_death_accuracy']
			));
		}
	
		$consents = $this->ConsentMaster->find('all', array('conditions' => array('ConsentMaster.participant_id' => $participant_id)));
		foreach($consents as $consent){
			$add_to_tmp_array(array(
					'date'			=> $consent['ConsentMaster']['consent_signed_date'],
					'event'			=> __('consent'),
					'link'			=> '/ClinicalAnnotation/ConsentMasters/detail/'.$participant_id.'/'.$consent['ConsentMaster']['id'],
					'procure_chronology_details' => '',
					'date_accuracy'	=> isset($consent['ConsentMaster']['consent_signed_date_accuracy']) ? $consent['ConsentMaster']['consent_signed_date_accuracy'] : 'c'
			));
		}
	
		$annotations = $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id)));
		foreach($annotations as $annotation){
			switch($annotation['EventControl']['event_type']) {
				case 'procure follow-up worksheet - aps':
					$add_to_tmp_array(array(
							'date'			=> $annotation['EventMaster']['event_date'],
							'event'			=> __('aps'),
							'link'			=> '/ClinicalAnnotation/EventMasters/detail/'.$participant_id.'/'.$annotation['EventMaster']['id'],
							'procure_chronology_details' =>  $annotation['EventDetail']['total_ngml'] .( $annotation['EventDetail']['biochemical_relapse']? ' (BCR)' : ''),         
							'date_accuracy' => isset($annotation['EventMaster']['event_date_accuracy']) ? $annotation['EventMaster']['event_date_accuracy'] : 'c'
					));
					break;
				case 'procure follow-up worksheet - clinical event':
					$exam_type = $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('procure followup exam types', $annotation['EventDetail']['type']);
					$exam_result = $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Exam Results', $annotation['EventDetail']['results']);
					$add_to_tmp_array(array(
							'date'			=> $annotation['EventMaster']['event_date'],
							'event'			=> $exam_type,
							'link'			=> '/ClinicalAnnotation/EventMasters/detail/'.$participant_id.'/'.$annotation['EventMaster']['id'],
							'procure_chronology_details' => strlen($exam_result)? "$exam_result" : '',
							'date_accuracy' => isset($annotation['EventMaster']['event_date_accuracy']) ? $annotation['EventMaster']['event_date_accuracy'] : 'c'
					));
					break;
				default:
					$add_to_tmp_array(array(
							'date'			=> $annotation['EventMaster']['event_date'],
							'event'			=> __($annotation['EventControl']['event_type']),
							'link'			=> '/ClinicalAnnotation/EventMasters/detail/'.$participant_id.'/'.$annotation['EventMaster']['id'],
							'procure_chronology_details' => $annotation['EventMaster']['procure_form_identification'],
							'date_accuracy' => isset($annotation['EventMaster']['event_date_accuracy']) ? $annotation['EventMaster']['event_date_accuracy'] : 'c'
					));
			}
		}
		
		$txs = $this->TreatmentMaster->find('all', array('conditions' => array('TreatmentMaster.participant_id' => $participant_id)));
		foreach($txs as $tx){
			switch($tx['TreatmentControl']['tx_method']) {
				case 'procure follow-up worksheet - treatment':
					$treatment_type = $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Procure followup medical treatment types', $tx['TreatmentDetail']['treatment_type']);
					$treatment_details = array();
					$treatment_details[] = $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Radiotherapy Precisions', $tx['TreatmentDetail']['radiotherpay_precision']);
					$treatment_details[] = $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Treatment site', $tx['TreatmentDetail']['treatment_site']);
					if($tx['TreatmentDetail']['drug_id']) $treatment_details[] = $all_drugs[$tx['TreatmentDetail']['drug_id']];
					$treatment_details = array_filter($treatment_details);
					$treatment_details = implode(' - ', $treatment_details);
					$add_to_tmp_array(array(
							'date'			=> $tx['TreatmentMaster']['start_date'],
							'event'			=> "$treatment_type (".__("start").")",
							'link'			=> '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx['TreatmentMaster']['id'],
							'procure_chronology_details' => $treatment_details,
							'date_accuracy' => $tx['TreatmentMaster']['start_date_accuracy']
					));
					if(!empty($tx['TreatmentMaster']['finish_date'])){
						$add_to_tmp_array(array(
								'date'			=> $tx['TreatmentMaster']['finish_date'],
								'event'			=> "$treatment_type (".__("end").")",
								'link'			=> '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx['TreatmentMaster']['id'],
								'procure_chronology_details' => $treatment_details,
								'date_accuracy' => $tx['TreatmentMaster']['finish_date_accuracy']
						));
					}
					break;
				case 'procure medication worksheet - drug':
					$drug_name = '';
					if($tx['TreatmentDetail']['drug_id']) $drug_name = $all_drugs[$tx['TreatmentDetail']['drug_id']];
					$add_to_tmp_array(array(
							'date'			=> $tx['TreatmentMaster']['start_date'],
							'event'			=> __("drug")." (".__("start").")",
							'link'			=> '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx['TreatmentMaster']['id'],
							'procure_chronology_details' => $drug_name,
							'date_accuracy' => $tx['TreatmentMaster']['start_date_accuracy']
					));
					if(!empty($tx['TreatmentMaster']['finish_date'])){
						$add_to_tmp_array(array(
								'date'			=> $tx['TreatmentMaster']['finish_date'],
								'event'			=> __("drug")." (".__("end").")",
								'link'			=> '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx['TreatmentMaster']['id'],
								'procure_chronology_details' => $drug_name,
								'date_accuracy' => $tx['TreatmentMaster']['finish_date_accuracy']
						));
					}
					break;
				case 'other tumor treatment':
					$treatment_details = array();
					$treatment_details[] = $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Other Tumor Treatment Types', $tx['TreatmentDetail']['treatment_type']);
					$treatment_details[] = $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Other Tumor Sites', $tx['TreatmentDetail']['tumor_site']);
					$treatment_details = array_filter($treatment_details);
					$treatment_details = implode(' - ', $treatment_details);
					$add_to_tmp_array(array(
							'date'			=> $tx['TreatmentMaster']['start_date'],
							'event'			=> __($tx['TreatmentControl']['tx_method'])." (".__("start").")",
							'link'			=> '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx['TreatmentMaster']['id'],
							'procure_chronology_details' => $treatment_details,
							'date_accuracy' => $tx['TreatmentMaster']['start_date_accuracy']
					));
					if(!empty($tx['TreatmentMaster']['finish_date'])){
						$add_to_tmp_array(array(
								'date'			=> $tx['TreatmentMaster']['finish_date'],
								'event'			=> __($tx['TreatmentControl']['tx_method'])." (".__("end").")",
								'link'			=> '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx['TreatmentMaster']['id'],
								'procure_chronology_details' => $treatment_details,
								'date_accuracy' => $tx['TreatmentMaster']['finish_date_accuracy']
						));
					}
					break;
				default:
					$add_to_tmp_array(array(
						'date'			=> $tx['TreatmentMaster']['start_date'],
						'event'			=> __($tx['TreatmentControl']['tx_method']),
						'link'			=> '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx['TreatmentMaster']['id'],
						'procure_chronology_details' => $tx['TreatmentMaster']['procure_form_identification'],
						'date_accuracy' => $tx['TreatmentMaster']['start_date_accuracy']
					));
					break;
			}
		}
		
		$collection_model = AppModel::getInstance('InventoryManagement', 'Collection', true);
		$collections = $collection_model->find('all', array('conditions' => array('Collection.participant_id' => $participant_id), 'recursive' => -1));
		foreach($collections as $collection){
			$add_to_tmp_array(array(
					'date'			=> $collection['Collection']['collection_datetime'],
					'event'			=> __('collection'),
					'link'			=> '/InventoryManagement/Collections/detail/'.$collection['Collection']['id'],
					'procure_chronology_details' => $collection['Collection']['procure_visit'],
					'date_accuracy' => $collection['Collection']['collection_datetime_accuracy']
			));
		}
		
		//sort the tmpArray by key (key = date)
		ksort($tmp_array);
		$tmp_array2 = array();
		foreach($tmp_array as $date_w_accu => $elements){
			$date = substr($date_w_accu, 0, -1);
			if($date == 0){
				$date = '';
			}
			if(isset($tmp_array2[$date])){
				$tmp_array2[$date] = array_merge($tmp_array2[$date], $elements);
			}else{
				$tmp_array2[$date] = $elements;
			}
		}
		$tmp_array = $tmp_array2;
		
		//transfer the tmpArray into $this->request->data
		$this->request->data = array();
		foreach($tmp_array as $key => $values){
			foreach($values as $value){
				$date = $key;
				$time = null;
				if(strpos($date, " ") > 0){
					list($date, $time) = explode(" ", $date);
				}
				$this->request->data[] = array('custom' => array(
						'date' => $date,
						'date_accuracy' => $value['date_accuracy'],
						'time' => $time,
						'event' => $value['event'],
						'procure_chronology_details' => $value['procure_chronology_details'],
						'link' => isset($value['link']) ? $value['link'] : null));
			}
		}
	}
}