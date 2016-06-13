<?php 
	$structure_links = array(
		'top'=>'/Order/OrderLines/add/'.$atim_menu_variables['Order.id'].'/',
		'bottom'=>array('cancel'=>'/Order/Orders/detail/'.$atim_menu_variables['Order.id'].'/')
	);
	
	$structure_override = $override_data;
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'links'=>$structure_links,
		'override'=>$structure_override,
		'settings'=>array('pagination' => false, 'add_fields' => true, 'del_fields' => true),
		'type'=>'addgrid');
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>