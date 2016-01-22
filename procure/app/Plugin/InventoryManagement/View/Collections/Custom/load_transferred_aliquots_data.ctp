<?php
	//ATiM PROCURE PROCESSING BANK
	$structure_links = array(
		'top' => '/InventoryManagement/Collections/loadTransferredAliquotsData/0',
		'bottom' => array('cancel' => 'javascript:history.go(-1)')
	);
	if($browse_csv) $structure_links['bottom']['add (with no file)'] =  array('icon' => 'add', 'link' => '/InventoryManagement/Collections/loadTransferredAliquotsData/0');
	
	$final_atim_structure = $atim_structure; 
	$final_options = $browse_csv?
		array('links'=>$structure_links, 'type'=>'add') :
		array('links'=>$structure_links,
			'settings'=>array(
				'pagination' => false,
				'add_fields' => true,
				'del_fields' => true,
				'paste_disabled_fields' => array('AliquotMaster.barcode')),
			'type'=>'addgrid');
	
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	//ATiM PROCURE PROCESSING BANK
?>

<script type="text/javascript">
var copyControl = true;
</script>
