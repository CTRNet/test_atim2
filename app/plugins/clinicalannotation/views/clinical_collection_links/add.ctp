<?php
	
	$structure_links = array(
		'top'=> '/clinicalannotation/clinical_collection_links/add/'.$atim_menu_variables['Participant.id'].'/',
		'radiolist' => array(
				'ClinicalCollectionLink.collection_id'=>'%%Collection.id%%'
			),
		//'bottom'=>array('cancel'=>'/clinicalannotation/clinical_collection_links/listall/'.$atim_menu_variables['Participant.id'].'/')
	);
	$structure_settings = array(
		'form_bottom'=>false, 
		'form_inputs'=>false,
		'actions'=>false,
		'pagination'=>false,
		'header' => __('collection', null)
	);
	if(sizeof($collection_data) == 0){
		$doNotPrintSubmit = true;
	}else{
		$final_atim_structure = $atim_structure_collection_detail; 
		$final_options = array('type'=>'radiolist', 'data'=>$collection_data, 'settings'=>$structure_settings, 'links'=>$structure_links);
	
		// CUSTOM CODE
		$hook_link = $structures->hook('collection_detail');
		if( $hook_link ) { require($hook_link); }
			
		// BUILD FORM
		$structures->build( $final_atim_structure, $final_options );
	}
	?>
	<table class="structure" cellspacing="0">
			<tbody><tr><th style='text-align: left; padding-left: 10px; padding-right: 10px;'><hr/>Consent</th></tr>
			<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[ClinicalCollectionLink][consent_master_id]' checked='checked' value=''/>N/A</td></tr>
	</tbody></table>
	<?php 
	$structure_links = array(
		'radiolist' => array(
				'ClinicalCollectionLink.consent_master_id'=>'%%ConsentMaster.id%%'
			),
	);
	unset($structure_settings['header']);
	//consent
	if(sizeof($consent_data) > 0){
		$final_atim_structure = $atim_structure_consent_detail; 
		$final_options = array('type'=>'radiolist', 'data'=>$consent_data, 'settings'=>$structure_settings, 'links'=>$structure_links);
	
		// CUSTOM CODE
		$hook_link = $structures->hook('consent_detail');
		if( $hook_link ) { require($hook_link); }
			
		// BUILD FORM
		$structures->build($final_atim_structure, $final_options );
	}

	//diag
	$structure_links = array(
		'top'=> '/clinicalannotation/clinical_collection_links/add/'.$atim_menu_variables['Participant.id'].'/',
		'radiolist' => array(
				'ClinicalCollectionLink.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%'
			),
		//'bottom'=>array('cancel'=>'/clinicalannotation/clinical_collection_links/listall/'.$atim_menu_variables['Participant.id'].'/')
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/clinical_collection_links/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	if(isset($doNotPrintSubmit)){
		$structure_links['top'] = '';
	}
	?>
	<table class="structure" cellspacing="0" >
			<tbody><tr><th style='text-align: left; padding-left: 10px; padding-right: 10px;'><hr/>Diagnosis</th></tr>
			<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[ClinicalCollectionLink][diagnosis_master_id]'  checked='checked' value=''/>N/A</td></tr>
	</tbody></table>
	<?php 
	//consent
//	$final_atim_structure = $atim_structure_diagnosis_detail; 
//	if(sizeof($diagnosis_data) > 0){
//		$final_options = array('type'=>'radiolist', 'data'=>$diagnosis_data, 'settings'=>array('form_bottom'=>true, 'form_top'=>true, 'form_inputs'=>false, 'actions'=>true, 'pagination'=>false), 'links'=>$structure_links);
//	
//		// CUSTOM CODE
//		$hook_link = $structures->hook('diagnosis_detail');
//		if( $hook_link ) { require($hook_link); }
//			
//		// BUILD FORM
//		$structures->build( $final_atim_structure, $final_options );
//	}else{
//		$final_options = array('data'=> '', 'links'=>$structure_links);
//	
//		// CUSTOM CODE
//		$hook_link = $structures->hook('diagnosis_detail');
//		if( $hook_link ) { require($hook_link); }
//			
//		// BUILD FORM
//		$structures->build( $final_atim_structure, $final_options );
//	}

	if(sizeof($diagnosis_data) > 0){
		$structures->build( $atim_structure_diagnosis_detail, array('type'=>'radiolist', 'data'=>$diagnosis_data, 'settings'=>array('form_bottom'=>true, 'form_top'=>true, 'form_inputs'=>false, 'actions'=>true, 'pagination'=>false), 'links'=>$structure_links) );
	}else{
		$structures->build( $atim_structure_diagnosis_detail, array('data'=> '', 'links'=>$structure_links) );
	}
	pr($atim_structure_diagnosis_detail);
	
?>