<?php 

	$structure_links = array(
		'top'=>"/Order/OrderItems/edit/$is_items_returned/$order_id/$order_line_id/$shipment_id/",
		'bottom'=>array('cancel'=>$url_to_cancel)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
	 	'type' => 'editgrid', 
		'links'=>$structure_links, 
		'settings'=> array('pagination' => false, 'header' => __('order items')),
			'extras' => '<input type="hidden" name="data[url_to_cancel]" value="'.$url_to_cancel.'"/><input type="hidden" name="data[order_item_ids_for_sorting]" value="'.$order_item_ids_for_sorting.'"/>'
	);
	
	
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

