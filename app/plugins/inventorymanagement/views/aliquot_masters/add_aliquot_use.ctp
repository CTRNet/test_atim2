<<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/aliquot_masters/addAliquotUse/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'] . '/' . $atim_menu_variables['AliquotUse.use_definition'],
		'bottom' => array('cancel' => '/inventorymanagement/aliquot_masters/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.initial_specimen_sample_id'].'/'.$atim_menu_variables['AliquotMaster.id'].'/'
		)
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'type' => 'add');
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );			
?>
<div id="popup" class="std_popup question">
	<div style="background: #FFF;">
		<h4><?php __("the used volume is higher than the remaining volume"); ?></h4>
		<p>
		<?php __("do you wish to proceed?"); ?>
		</p>
		<span class="button confirm">
			<a class="form detail">Yes</a>
		</span>
		<span class="button close">
			<a class="form delete">No</a>
		</span>
	</div>
</div>

<script type="text/javascript">
aliquotVolumeCheck = true;
</script>