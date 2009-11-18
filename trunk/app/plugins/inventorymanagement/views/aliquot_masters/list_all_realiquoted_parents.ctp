<?php
	$structure_links = array(
	'index' => array(
		   'edit' => '/inventorymanagement/aliquot_masters/editAliquotUse/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMasterParent.id%%/%%AliquotUse.id%%',
			'delete' => '/inventorymanagement/aliquot_masters/deleteAliquotUse/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMasterParent.id%%/%%AliquotUse.id%%/1/'
		));

	$structures->build( $atim_structure, array('type'=>'index', 'links'=>$structure_links) );
	
?>