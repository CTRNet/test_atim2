<?php 
	$structure_links = array(
		'bottom'=>array(
			'filter'=>array(
				'all queries'=>'/Datamart/adhocs/index',
				'my favourites'=>'/Datamart/adhocs/index/favourites',
//				'saved searches'=>'/Datamart/adhocs/index/saved'
			)
		)
	);
	
	// if SAVED, link to saved controller
	if ( $atim_menu_variables['Param.Type_Of_List']=='saved' ) {
		$structure_links['index'] = array(
			'detail'=>'/Datamart/adhoc_saved/search/%%Adhoc.id%%/%%AdhocSaved.id%%'
		);
	}
	
	// otherwise, link as normal
	else {
		$structure_links['index'] = array(
			'detail'=>'/Datamart/adhocs/search/'.$atim_menu_variables['Param.Type_Of_List'].'/%%Adhoc.id%%'
		);
	}
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>