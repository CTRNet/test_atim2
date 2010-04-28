<?php
	$top['top'] = '/clinicalannotation/treatment_masters/postOperativeEdit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/';
	$bottom['bottom']['cancel'] = '/clinicalannotation/treatment_masters/postOperativeDetail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/';
	
	$links = array_merge($top, array('radiolist' => array('TreatmentDetail.lab_report_id'=>'%%EventMaster.id%%')));
	$structure_settings = array(
		'form_bottom'=>false, 
		'form_inputs'=>false,
		'actions'=>false,
		'pagination'=>false,
	);
	$options = array('links' => $links, 'settings' => $structure_settings);
	$structures->build($empty_structure, $options);
	
	printMiddleStructure($this->data, $lab_reports_data, $date_and_summary, "lab_report_id", "lab report", $top, $structures);
	printMiddleStructure($this->data, $imagings_data, $date_and_summary, "imagery_id", "imaging", $top, $structures);
	printMiddleStructure($this->data, $score_fong_data, $score_fong_structure, "fong_score_id", "score de fong", $top, $structures);
	printMiddleStructure($this->data, $score_meld_data, $score_meld_structure, "meld_score_id", "meld score", $top, $structures);
	printMiddleStructure($this->data, $score_gretch_data, $score_gretch_structure, "gretch_score_id", "gretch", $top, $structures);
	printMiddleStructure($this->data, $score_clip_data, $score_clip_structure, "clip_score_id", "clip", $top, $structures);
	printMiddleStructure($this->data, $score_barcelona_data, $score_barcelona_structure, "barcelona_score_id", "barcelona score", $top, $structures);
	printMiddleStructure($this->data, $score_okuda_data, $score_okuda_structure, "okuda_score_id", "okuda score", $top, $structures);
	
	$links = array_merge($top, $bottom);
	$structure_settings = array(
		'form_top' => false,
		'header' => __('cirrhosis', null)
	);
	$options = array('links' => $links, 'settings' => $structure_settings);
	$structures->build($atim_structure, $options);
	
	function printMiddleStructure($main_data, $curr_data, $curr_structure, $id_name, $header_name, $top, $structures_obj){
		$links = array_merge($top, array('radiolist' => array('TreatmentDetail.'.$id_name => '%%EventMaster.id%%')));
		$structure_settings = array(
			'form_top' => false,
			'form_bottom' => false, 
			'form_inputs' => false,
			'actions' => false,
			'pagination' => false,
			'header' => __($header_name, null)
		);
		$checkNA = true;
		foreach($curr_data as &$data_line){
			if($data_line['EventMaster']['id'] == $main_data['TreatmentDetail'][$id_name]){
				$checkNA = false;
				$data_line = array_merge($main_data, $data_line);
			}
		}
		$options = array('links' => $links, 'type' => 'radiolist', 'data' => $curr_data, 'settings' => $structure_settings);
		$structures_obj->build($curr_structure, $options);
		?>
		<table class="structure" cellspacing="0">
				<tbody><tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[TreatmentDetail][<?php echo($id_name); ?>]' <?php echo($checkNA ? "checked='checked'" : ""); ?> value=''/><?php echo(__('n/a', true)); ?></td></tr>
		</tbody></table>
		<?php
	}
?>