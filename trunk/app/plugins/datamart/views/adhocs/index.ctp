<?php 
	$structure_links = array(
		'bottom'=>array(
			'filter'=>array(
				'all queries'=>'/datamart/adhocs/index',
				'my favourites'=>'/datamart/adhocs/index/favourites',
				'saved searches'=>'/datamart/adhocs/index/saved'
			)
		)
	);
	
	// if SAVED, link to saved controller
	if ( $atim_menu_variables['Param.Type_Of_List']=='saved' ) {
		$structure_links['index'] = array(
			'detail'=>'/datamart/adhoc_saved/search/%%Adhoc.id%%/%%AdhocSaved.id%%'
		);
	}
	
	// otherwise, link as normal
	else {
		$structure_links['index'] = array(
			'detail'=>'/datamart/adhocs/search/'.$atim_menu_variables['Param.Type_Of_List'].'/%%Adhoc.id%%'
		);
	}
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>