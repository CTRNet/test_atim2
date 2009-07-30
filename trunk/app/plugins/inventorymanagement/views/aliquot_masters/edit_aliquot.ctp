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
		'top'=>'/inventorymanagement/aliquot_masters/edit/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['AliquotMaster.id'],
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/aliquot_masters/detailAliquot/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['AliquotMaster.id']
		),
		
		'ajax'=>array(
			'top'=>'frame',
			'bottom'=>array(
				'cancel'=>'frame'
			)
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>