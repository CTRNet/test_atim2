<?php 
	echo '
		<div class="actions">
			<ul>
				<li>' . $ajax->link('Detail', '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'], array('update' => 'frame'), NULL, false) . '</li>
				<li class="at">' . $ajax->link('Quality', '/inventorymanagement/quality_controls/listAllQualityControls/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'], array('update' => 'frame'), NULL, false) . '</li>
				<li>' . $ajax->link('Reviews', '/unknown/', array('update' => 'frame'), NULL, false) . '</li>
			</ul>
		</div>
	';
 	
	$structure_links = array(
		'index'=>array(
			'detail' => '/inventorymanagement/quality_controls/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/%%QualityControl.id%%',
		),
		'bottom'=>array(
			'add' => '/inventorymanagement/quality_controls/add/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/',
		),
		
		'ajax'=>array(
			'index'=>array(
				'detail' => 'frame',
			),
			'bottom'=>array(
				'add' => 'frame',
			)
		)
	);
	
	$structures->build($atim_structure, array('type' => 'index','links'=>$structure_links));
	
?>