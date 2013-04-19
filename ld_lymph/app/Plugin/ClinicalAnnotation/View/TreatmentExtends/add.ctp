<?php
	
	$structure_links = array(
			'top'=>'/ClinicalAnnotation/TreatmentExtends/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'],
			'bottom'=>array(
					'cancel'=>'/ClinicalAnnotation/TreatmentMasters/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
			)
	);
	
	$structure_settings = array(
			'header' => __('precision', null),
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