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
		'pagination'=>false,
		'header' => __('collection', true)
	);
	
	$structure_override = array();
	
		
	// ************** 1- COLLECTION **************
	
	
	$final_atim_structure = $atim_structure_collection_detail; 
	$final_options = array('type'=>'index', 'data'=>$collection_data, 'settings'=>$structure_settings, 'links'=>$structure_links, 'override' => $structure_override);

	// CUSTOM CODE
	$hook_link = $structures->hook('collection_detail');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options ); 
	
	
	// ************** 2- CONSENT **************
	
	
	$structure_links = array(
		'radiolist' => array(
				'ClinicalCollectionLink.consent_master_id'=>'%%ConsentMaster.id%%'
			),
	);
	$structure_settings['header'] = __('consent', true);
	$structure_settings['form_top'] = false;
	$final_atim_structure = $atim_structure_consent_detail; 
	$final_options = array('type'=>'index', 'data'=>$consent_data, 'settings'=>$structure_settings, 'links'=>$structure_links);

	// CUSTOM CODE
	$hook_link = $structures->hook('consent_detail');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
	$checkNA = true;
	foreach($consent_data as $c_data){
		if($c_data['ConsentMaster']['id'] == $this->data['ClinicalCollectionLink']['consent_master_id']){
			$checkNA = false;		
			break;
		}
	}
	?>
	<table class="structure" cellspacing="0">
			<tbody>
			<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[ClinicalCollectionLink][consent_master_id]' <?php echo($checkNA ? 'checked="checked"' : ''); ?> value=''/>N/A</td></tr>
	</tbody></table>
	<?php

	
	// ************** 3- DIAGNOSIS **************

	
	$structure_links = array(
		'radiolist' => array(
				'ClinicalCollectionLink.diagnosis_master_id'=>'%%DiagnosisMaster.id%%'
			),
	);
	$structure_settings['header'] = __('diagnosis', true);
	$structure_settings['form_top'] = false;
	$final_atim_structure = $atim_structure_diagnosis_detail; 
	$final_options = array('type'=>'index', 'data'=>$diagnosis_data, 'settings'=>$structure_settings, 'links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook('diagnosis_detail');
	if( $hook_link ) { require($hook_link); }	
	
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
	$checkNA = true;
	foreach($diagnosis_data as $dx_data){
		if($dx_data['DiagnosisMaster']['id'] == $this->data['ClinicalCollectionLink']['diagnosis_master_id']){
			$checkNA = false;		
			break;
		}
	}
	?>
	<table class="structure" cellspacing="0" >
			<tbody>
			<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[ClinicalCollectionLink][diagnosis_master_id]' <?php echo($checkNA ? 'checked="checked"' : ''); ?> value=''/>N/A</td></tr>
	</tbody></table>
	<?php
	
	
	// ************** MAIN **************
	
	
	$structure_links = array(
		'top'=> '/clinicalannotation/clinical_collection_links/details/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['ClinicalCollectionLinks.id'],
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/clinical_collection_links/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	$structures->build($empty_structure, array('settings' => array('form_top' => false, 'form_bottom' => true, 'actions' => true), 'links' => $structure_links));
?>