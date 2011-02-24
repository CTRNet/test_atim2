<?php
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'add', 
		'settings' => array('header' => __('realiquoting process', true) . ' - ' . __('selection', true)),
		'links' => array('top' => '/inventorymanagement/aliquot_masters/realiquot/'.$aliquot_id),
		'extras' => '<input type="hidden" name="data[realiquot_from]" value="'.$realiquot_from.'"/>'
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if($hook_link){
		require($hook_link); 
	}

	// BUILD FORM
	$structures->build($final_atim_structure, $final_options);			
		
?>
<script>
var realiquotInit = true;
</script>