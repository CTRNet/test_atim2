<?php
	
	$bottom = array();
	if(isset($lab_book_ctrl_id)) $bottom['add lab book (pop-up)'] = '/labbook/lab_book_masters/add/'.$lab_book_ctrl_id.'/1/';
	$bottom['cancel'] = $url_to_cancel;
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'add', 
		'settings' => array('header' => __('realiquoting process', true) . ' - ' . __('lab book selection', true)),
		'links' => array(
			'top' => '/inventorymanagement/aliquot_masters/realiquot/'.$aliquot_id,
			'bottom' => $bottom
		),
		'extras' => '<input type="hidden" name="data[realiquot_from]" value="'.$realiquot_from.'"/>
					<input type="hidden" name="data[0][realiquot_into]" value="'.$realiquot_into.'"/>
					<input type="hidden" name="data[0][ids]" value="'.$ids.'"/>'
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
var labBookPopup = true;
</script>