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
	$structure_override = array();

	$final_options = array('settings'=>$structure_settings, 'links'=>$structure_links, 'override' => $structure_override);

	// CUSTOM CODE
	$hook_link = $structures->hook('collection_detail');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $empty_structure, $final_options );
	$string_loading = "---".__("loading", true)."---";
	?>
	<table class="structure" cellspacing="0">
			<tbody>
			<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' id="collection_new" name='data[ClinicalCollectionLink][collection_id]' checked='checked' value=''/><?php echo(__('new collection', true)); ?></td></tr>
			<tr><td id="collection_loading" style="text-align: center; display: none;"><div class="loading"><?php echo($string_loading) ?></div></td></tr>
	</tbody></table>
	<div id="collection_frame"></div>
	<table class="structure" cellspacing="0">
		<tbody>
			<tr>
				<td style='text-align: left; padding-left: 10px;'><span
					class="button"> <a id="collection_search" href="#"><?php echo(__('search', true)); ?></a>
				</span></td>
			</tr>
		</tbody>
	</table>
<?php
	 
	$structure_links = array(
		'radiolist' => array(
				'ClinicalCollectionLink.consent_master_id'=>'%%ConsentMaster.id%%'
			),
	);
	$structure_settings['header'] = __('consent', true);
	$structure_settings['separator'] = true;
	//consent
	$final_atim_structure = $atim_structure_consent_detail; 
	$final_options = array('type'=>'radiolist', 'data'=>$consent_data, 'settings'=>$structure_settings, 'links'=>$structure_links);

	// CUSTOM CODE
	$hook_link = $structures->hook('consent_detail');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build($final_atim_structure, $final_options );
	?>
	<table class="structure" cellspacing="0">
			<tbody><tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[ClinicalCollectionLink][consent_master_id]' checked='checked' value=''/>N/A</td></tr>
	</tbody></table>
	<?php
	
	
	

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
	//consent
	$final_atim_structure = $atim_structure_diagnosis_detail; 
	$final_options = array('type'=>'radiolist', 'data'=>$diagnosis_data, 'settings'=>array('form_bottom'=>true, 'form_top'=>true, 'form_inputs'=>false, 'actions'=>true, 'pagination'=>false, 'header' => __('diagnosis', true), 'form_bottom' => false, 'actions' => false, 'separator' => true), 'links'=>$structure_links);

	// CUSTOM CODE
	$hook_link = $structures->hook('diagnosis_detail');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
	?>
	<table class="structure" cellspacing="0" >
			<tbody><tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[ClinicalCollectionLink][diagnosis_master_id]'  checked='checked' value=''/>N/A</td></tr>
	</tbody></table>
	<?php 
	
	$structure_links = array(
		'top'=> '/clinicalannotation/clinical_collection_links/add/'.$atim_menu_variables['Participant.id'].'/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/clinical_collection_links/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	$structures->build($empty_structure, array('settings' => array('form_top' => false, 'form_bottom' => true, 'actions' => true), 'links' => $structure_links));
?>

<div id="popup" class="std_popup question">
	
</div>

<script type="text/javascript">
var ccl = true;
</script>