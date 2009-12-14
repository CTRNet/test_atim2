<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/diagnosis_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['tableId'].'/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/diagnosis_masters/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	
		
	// BUILD FORM
	//print only the form top
	$structures->build($empty_structure, array('links' => array('top' => $structure_links['top']), 'settings' => array('form_bottom' => false, 'actions' => false)));
	
	?>
	<table class="structure" cellspacing="0">
		<tbody>
			<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[DiagnosisMaster][primary_number]' checked='checked' value='0'/>0, <?php echo(__('no primary', null));?></td><td>
			
	<?php
	$final_atim_structure = $atim_structure;
	$final_options = array('data' => $existing_dx[0], 'type' => 'list', 'settings' => array('form_bottom' => false, 'actions' => false, 'pagination' => false));
	$hook_link = $structures->hook('dx_list');
	if( $hook_link ) { require($hook_link); }  
	$structures->build($final_atim_structure, $final_options);
	unset($existing_dx[0]);
	$max_key = 0;
	foreach($existing_dx as $key => $dx){
		?>
		</td>
		</tr>
		<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[DiagnosisMaster][primary_number]' value='<?php echo($key); ?>'/><?php echo($key);?></td><td>
		<?php
		$final_options = array('data' => $existing_dx[$key], 'type' => 'list', 'settings' => array('form_bottom' => false, 'actions' => false, 'pagination' => false));
		$hook_link = $structures->hook('dx_list');
		if( $hook_link ) { require($hook_link); }
		$structures->build($final_atim_structure, $final_options);
		$max_key = $key; 
	}
	?>
	</td></tr>
	<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[DiagnosisMaster][primary_number]' value='<?php echo($max_key + 1); ?>'/><?php echo(($max_key + 1).", ".__('new primary', null));?></td><td></td></tr>
		</tbody>
	</table>
	<?php
	
	// CUSTOM CODE
	
	// Set form structure and option 
	$final_options = array('links'=>$structure_links, 'settings' => array('form_top' => false));
	
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	$structures->build( $final_atim_structure, $final_options );
?>