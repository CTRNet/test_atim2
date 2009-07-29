<?php 
	echo '
		<div class="actions">
			<ul>
				<li class="at">'.$ajax->link( 'Detail', '/inventorymanagement/sample_masters/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'], array('update'=>'frame'), NULL, false ).'</li>
				<li>'.$ajax->link( 'Aliquots', '/inventorymanagement/aliquot_masters/listAllSampleAliquots/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'], array('update'=>'frame'), NULL, false ).'</li>
				<li>'.$ajax->link( 'Quality', '/inventorymanagement/quality_controls/listAllQualityControls/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'], array('update'=>'frame'), NULL, false ).'</li>
				<li>'.$ajax->link( 'Reviews', '/unknown/', array('update'=>'frame'), NULL, false ).'</li>
			</ul>
		</div>
	';
 	
	$structure_links = array(
		'top'=>'/inventorymanagement/sample_masters/edit/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'],
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/sample_masters/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id']
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