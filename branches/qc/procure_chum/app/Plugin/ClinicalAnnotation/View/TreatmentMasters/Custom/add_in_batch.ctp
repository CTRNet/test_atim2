<?php 
 	$structure_links = array(
		'top' => '/ClinicalAnnotation/TreatmentMasters/addInBatch/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentControl.id'].'/1',
		'bottom' => array('cancel'=>'/ClinicalAnnotation/TreatmentMasters/listall/'.$atim_menu_variables['Participant.id']));
			
 	$structure_override = array();
	$structure_settings = array('pagination' => false, 'add_fields' => true, 'del_fields' => true, 'header' => $tx_header);
	$final_options = array('links' => $structure_links, 'type' => 'addgrid', 'settings'=> $structure_settings);
	if(isset($default_procure_form_identification)) $final_options['override']['TreatmentMaster.procure_form_identification'] = $default_procure_form_identification;
	
	$this->Structures->build($atim_structure, $final_options);
?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>
