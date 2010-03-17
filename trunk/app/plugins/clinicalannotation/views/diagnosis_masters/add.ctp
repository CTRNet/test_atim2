<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/diagnosis_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['tableId'].'/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/diagnosis_masters/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	// 1- DIAGNOSTIC DATA
	
	$structure_settings = array(
		'actions'=>false, 
		
		'header' => '1- ' . __('data', null) . ' : ' . __($dx_type, null),
		'form_bottom'=>false);

	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links, 'settings' => $structure_settings);
	
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $final_atim_structure, $final_options );
	
	// 2- SEPARATOR & HEADER
	
	$structure_settings = array(
		'actions'=>false, 

		'header' => '2- ' . __('related diagnoses group', null),
		'separator' => true, 
		'form_top' => false,
		'form_bottom'=>false
	);	

	$structures->build($empty_structure, array('settings'=>$structure_settings));		
	
	// 3- RELATED DIAGNOSTICS
	
	$structure_settings = array(
		'actions'=>false,
		'pagination'=>false,
		'form_bottom' => false,
		'form_top' => false
	);	

	// 3.1- Group n/a	
	
?>

	<table class="structure" cellspacing="0"><tbody>
		<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[DiagnosisMaster][primary_number]' checked='checked' value=''/><?php echo(__('n/a', null));?></td><td>
			
<?php
	
	$final_atim_structure = $atim_structure;
	$final_options = array('data' => $existing_dx[''], 'type' => 'list', 'settings' => $structure_settings);

	$hook_link = $structures->hook('dx_list');
	if( $hook_link ) { require($hook_link); }  

	$structures->build($final_atim_structure, $final_options);

	// 3.2- Groups 1 to n	

	unset($existing_dx['']);
	$max_key = 0;
	foreach($existing_dx as $key => $dx){
?>

		</td></tr>
		<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[DiagnosisMaster][primary_number]' value='<?php echo($key); ?>'/><?php echo(__('group', null) . ' - ' . $key);?></td><td>

<?php

		$final_options = array('data' => $existing_dx[$key], 'type' => 'list', 'settings' => $structure_settings);
		
		$hook_link = $structures->hook('dx_list');
		if( $hook_link ) { require($hook_link); }
		
		$structures->build($final_atim_structure, $final_options);
		$max_key = $key; 
	}

	// 3.3- New group	
	
?>

		</td></tr>
		<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[DiagnosisMaster][primary_number]' value='<?php echo($max_key + 1); ?>'/><?php echo(__('new group', null));?></td><td></td></tr>
	</tbody></table>

<?php
	
	// 4- SUBMIT BUTTON
	
	$structure_settings = array(
		'form_top' => false
	);	

	$structures->build($empty_structure, array('settings'=>$structure_settings, 'links'=>$structure_links));		
		
?>