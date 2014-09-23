<?php
	
	$structure_links = array(
		'top'=>'/ClinicalAnnotation/FamilyHistories/add/'.$atim_menu_variables['Participant.id'].'/',
		'bottom'=>array(
			'cancel'=>'/ClinicalAnnotation/FamilyHistories/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structure_settings = array(
		'pagination' => false,
		'add_fields' => true,
		'del_fields' => true
	);
	
	$final_atim_structure = $atim_structure;
	$final_options = array(
		'links' => $structure_links, 
		'type' => 'addgrid',
		'settings'=> $structure_settings);
	
	$hook_link = $this->Structures->hook();
	if( $hook_link ) {
		require($hook_link);
	}
	
	$this->Structures->build( $final_atim_structure,  $final_options);
	
?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>