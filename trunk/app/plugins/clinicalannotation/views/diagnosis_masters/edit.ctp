<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/diagnosis_masters/edit/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/diagnosis_masters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/'
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'settings' => array('form_top' => false));
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	//print only the form top
	$structures->build($empty_structure, array('links' => array('top' => $structure_links['top']), 'settings' => array('form_bottom' => false, 'actions' => false)));
	
	?>
	<table class="structure" cellspacing="0">
		<tbody>
			<tr><td style='text-align: left; padding-left: 10px;'><input type='radio' name='data[DiagnosisMaster][primary_number]' checked='checked' value='0'/>0, <?php echo(__('no primary', null));?></td><td>
			
	<?php
	$structures->build($atim_structure, array('data' => $existing_dx[0], 'type' => 'list', 'settings' => array('form_bottom' => false, 'actions' => false, 'pagination' => false)));
	unset($existing_dx[0]);
	$max_key = 0;
	$own_primary = false;//do not print a new number if the current dx is the only one having it's current number
	foreach($existing_dx as $key => $dx){
		if(sizeof($existing_dx[$key]) == 0){
			$own_primary = true;
		}
		$checked = "";
		if($this->data['DiagnosisMaster']['primary_number'] == $key){
			$checked = " checked='checked' ";
		}
		?>
		</td>
		</tr>
		<tr><td style='text-align: left; padding-left: 10px;'>
				<input type='radio' name='data[DiagnosisMaster][primary_number]' value='<?php echo($key); ?>' <?php echo($checked); ?>/><?php echo($key);?>
			</td><td>
		<?php
		$structures->build($atim_structure, array('data' => $existing_dx[$key], 'type' => 'list', 'settings' => array('form_bottom' => false, 'actions' => false, 'pagination' => false)));
		$max_key = $key; 
	}
	?>
	</td></tr>
	<?php if(!$own_primary){ ?>
	<tr><td style='text-align: left; padding-left: 10px;'>
		<input type='radio' name='data[DiagnosisMaster][primary_number]' value='<?php echo($max_key + 1); ?>'/><?php echo(($max_key + 1).", ".__('new primary', null));?>
		</td><td></td></tr>
	<?php } ?>
		</tbody>
	</table>
	<?php
	$structures->build( $final_atim_structure, $final_options );
?>