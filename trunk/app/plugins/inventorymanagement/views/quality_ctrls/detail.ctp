<?php

	$structure_links = array(
		'index'=>array(
			'detail'=>'/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
			'delete'=>'/inventorymanagement/aliquot_masters/deleteAliquotUse/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/%%AliquotUse.id%%/3/%%QualityCtrl.id%%/'
		),
		'bottom'=>array(
			'edit' => '/inventorymanagement/quality_ctrls/edit/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['QualityCtrl.id'].'/',
			'delete' => '/inventorymanagement/quality_ctrls/delete/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['QualityCtrl.id'].'/',
			'add tested aliquots'=>'/inventorymanagement/quality_ctrls/addTestedAliquots/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['QualityCtrl.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('settings' => array('actions' => false)) );
	?>
	<table class="structure" cellspacing="0">
		<tbody><tr><th style='text-align: left; padding-left: 10px; padding-right: 10px;'><hr/><?php echo(__('tested aliquots', null)); ?></th></tr>
	</tbody></table>
	<?php
	$structures->build( $quality_ctrl_structure, array('type' => 'index', 'data' => $quality_ctrl_data, 'links' => $structure_links) );
?>