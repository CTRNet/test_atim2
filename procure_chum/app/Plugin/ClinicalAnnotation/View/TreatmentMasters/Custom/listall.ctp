<?php
	
	$structure_links = array('index'=>array('detail'=>'/ClinicalAnnotation/TreatmentMasters/detail/'.$atim_menu_variables['Participant.id'].'/%%TreatmentMaster.id%%/'));
	if(isset($add_link_for_procure_forms)) $structure_links['bottom']['add form'] = $add_link_for_procure_forms;
	if(isset($all_treatment_controls)) {
		// Main Form
		$counter = 0;
		foreach($all_treatment_controls as $new_treatment_controls) {
			$counter++;
			$final_atim_structure = array(); 
			$final_options = array(
				'type' => 'detail', 
				'links'	=> $structure_links,
				'settings' => array(
					'header' => __($new_treatment_controls['TreatmentControl']['tx_method'], null),
					'actions'	=> ((sizeof($all_treatment_controls) == $counter)? true : false)), 
				'extras' => $this->Structures->ajaxIndex('ClinicalAnnotation/TreatmentMasters/listall/'.$atim_menu_variables['Participant.id'].'/'.$new_treatment_controls['TreatmentControl']['id'])
			);
			$this->Structures->build( $final_atim_structure, $final_options );	
		}	
	} else {
		//Specific Treatment List Display
		$final_atim_structure = $atim_structure; 
		$final_options = array(
			'type'=>'index',
			'settings'	=> array('pagination' => true, 'actions' => false),
			'links'=>$structure_links);
		$this->Structures->build( $final_atim_structure, $final_options );
	}
	
?>
	
	
	

