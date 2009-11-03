	<table class="structure" cellspacing="0">
			<tbody><tr><th style='text-align: left; padding-left: 10px;'>Collection</th></tr>
	</tbody></table>
	<?php 
	$structure_links = array(
		'top'=> '/clinicalannotation/clinical_collection_links/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['ClinicalCollectionLinks.id'],
		'radiolist' => array(
				'ClinicalCollectionLink.collection_id'=>'%%Collection.id%%'
			),
	);
	$structure_settings = array(
		'form_bottom'=>false, 
		'form_inputs'=>false,
		'actions'=>false,
		'pagination'=>false
	);
	
	$structures->build( $atim_structure_collection_detail, array('type'=>'radiolist', 'data'=>$collection_data, 'settings'=>$structure_settings, 'links'=>$structure_links) );
	?>
	<table class="structure" cellspacing="0">
			<tbody><tr><th style='text-align: left; padding-left: 10px; padding-right: 10px;'><hr/>Consent</th></tr>
			<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[ClinicalCollectionLink][consent_master_id]' checked="checked" value=''/>N/A</td></tr>
	</tbody></table>
	<?php 
	$structure_links = array(
		'radiolist' => array(
				'ClinicalCollectionLink.consent_master_id'=>'%%ConsentMaster.id%%'
			),
	);
	
	//consent
	$structures->build( $atim_structure_consent_detail, array('type'=>'radiolist', 'data'=>$consent_data, 'settings'=>$structure_settings, 'links'=>$structure_links) );

	//diag
	$structure_links = array(
		'top'=> '/clinicalannotation/clinical_collection_links/details/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['ClinicalCollectionLinks.id'],
		'radiolist' => array(
				'ClinicalCollectionLink.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%'
			),
		//'bottom'=>array('cancel'=>'/clinicalannotation/clinical_collection_links/listall/'.$atim_menu_variables['Participant.id'].'/')
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/clinical_collection_links/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	?>
	<table class="structure" cellspacing="0" >
			<tbody><tr><th style='text-align: left; padding-left: 10px; padding-right: 10px;'><hr/>Diagnosis</th></tr>
			<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[ClinicalCollectionLink][diagnosis_master_id]' checked="checked" value=''/>N/A</td></tr>
	</tbody></table>
	<?php 
	//consent
	$structures->build( $atim_structure_diagnosis_detail, array('type'=>'radiolist', 'data'=>$diagnosis_data, 'settings'=>array('form_bottom'=>true, 'form_top'=>true, 'form_inputs'=>false, 'actions'=>true, 'pagination'=>false), 'links'=>$structure_links) );

?>