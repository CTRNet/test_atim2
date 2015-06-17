<?php
	//ATiM PROCURE PROCESSING BANK
	$structure_links = array(
		'top' => '/InventoryManagement/Collections/add/0',
		'bottom' => array('cancel' => 'javascript:history.go(-1)')
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = $browse_csv?
		array('links'=>$structure_links, 'type'=>'add') :
		array('links'=>$structure_links,
			'settings'=>array('pagination' => false, 'add_fields' => true, 'del_fields' => true),
			'type'=>'addgrid');
	
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	//ATiM PROCURE PROCESSING BANK
?>

<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>
