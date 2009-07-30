<?php
	echo '
		<div class="actions">
			<ul>
				<li class="at">'.$ajax->link( 'Detail', '/inventorymanagement/aliquot_masters/detailAliquot/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['AliquotMaster.id'], array('update'=>'frame'), NULL, false ).'</li>
				<li>'.$ajax->link( 'Quality', '/inventorymanagement/quality_controls/listAllQualityControls/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['AliquotMaster.id'], array('update'=>'frame'), NULL, false ).'</li>
				<li>'.$ajax->link( 'Reviews', '/unknown/', array('update'=>'frame'), NULL, false ).'</li>
			</ul>
		</div>
	';
	
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/inventorymanagement/aliquot_masters/editAliquot/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['AliquotMaster.id'],
			'delete'=>'/inventorymanagement/aliquot_masters/delete/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['AliquotMaster.id']
		),
		
		'ajax'=>array(
			'bottom'=>array(
				'edit'=>'frame',
				'delete'=>'frame'
			)
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>