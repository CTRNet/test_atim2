<?php 
	echo '
		<script type="text/javascript">
			'.$ajax->remoteFunction(     
				array(         
					// 'url'		=> '/menus/update?alias=/inventorymanagement/sample_masters/detail/inv_CAN_22-1/ascite/specimen&'.implode('&',$atim_menu_variables),         
					'url'	=> '/menus/update?alias='.($atim_menu_variables['Menu.alias']).'&Collection.id='.($atim_menu_variables['Collection.id']).'&SampleMaster.id='.($atim_menu_variables['SampleMaster.id']),
					'update'	=> 'menu'
				) 
			).'
		</script>
	';
	
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/inventorymanagement/sample_masters/tree/'.$atim_menu_variables['Collection.id'].'/',
			'edit'=>'/inventorymanagement/sample_masters/edit/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/',
			'delete'=>'/inventorymanagement/sample_masters/delete/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>