<?php 
	$structure_links = array(
		'top'=>'/Order/OrderItems/defineOrderItemsReturned/'.$order_id.'/'.$order_line_id.'/'.$shipment_id.'/',
		'bottom'=>array('cancel'=>$url_to_cancel)
	);
	
	$final_options = array(
		'type' => 'editgrid', 
		'links'=>$structure_links, 
		'settings'=> array('pagination' => false, 'header' => __('order items')),
		'extras' => '<input type="hidden" name="data[url_to_cancel]" value="'.$url_to_cancel.'"/><input type="hidden" name="data[order_item_ids]" value="'.$order_item_ids.'"/>'
	);
	
	$final_atim_structure = $atim_structure;
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
	
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );

?>
<script type="text/javascript">
var copyControl = true;
</script>