<?php 
	$structure_links = array(
		'index'=>array(
			'detail'=>'/datamart/adhocs/search/'.$atim_menu_variables['Param.Type_Of_List'].'/%%Adhoc.id%%'
		),
		'bottom'=>array(
			'filter'=>array(
				'all queries'=>'/datamart/adhocs/index',
				'my favourites'=>'/datamart/adhocs/index/favourites',
				'saved searches'=>'/datamart/adhocs/index/saved'
			)
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>