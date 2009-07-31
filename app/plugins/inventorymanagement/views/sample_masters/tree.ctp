<?php
	
	// SETTINSG
	
	$structure_settings = array(
		'tree'=>array(
			'SampleMaster'		=> 'SampleMaster',
			'AliquotMaster'	=> 'AliquotMaster'
		),
		
		'columns' => array(
			1	=> array( 'width'=>'30%' ),
			10	=> array( 'width'=>'70%' )
		)
	);
	
	// LINKS
	
		$filter_links = array( 
			'no filter'=>'/inventorymanagement/sample_masters/tree/'.$atim_menu_variables['Collection.id'].'/' 
		);
		
		foreach ( $sample_controls as $sample_control ) {
			$filter_links[ $sample_control['SampleControl']['sample_category'].' - '.$sample_control['SampleControl']['sample_type'] ] = '/inventorymanagement/sample_masters/tree/'.$atim_menu_variables['Collection.id'].'/';
		}

	$structure_links = array(
		'tree'=>array(
			'SampleMaster' => array(
				'detail'=>'/inventorymanagement/sample_masters/detail/'.$atim_menu_variables['Collection.id'].'/%%SampleMaster.id%%'
			),
			'AliquotMaster' => array(
				'detail'=>'/inventorymanagement/aliquot_masters/detailAliquot/'.$atim_menu_variables['Collection.id'].'/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%'
			)
		),
		'bottom' => array(
			'filter' => $filter_links
		),
		
		'ajax' => array(
			'index' => array(
				'detail' => array(
					'update' => 'frame',
					'before' => 'set_at_state_in_tree_root(this)'
				)
			)
		)
	);
	
	// EXTRAS
	
	$structure_extras = array(
		10 => '<div id="frame"></div>'
	);
	
	// BUILD
	
	$structures->build( $atim_structure, array('type'=>'tree', 'settings'=>$structure_settings, 'links'=>$structure_links, 'extras'=>$structure_extras) );
?>
								
<script>
	function set_at_state_in_tree_root( new_at_li ) {
		var tree_root = document.getElementById("tree_root");
		var tree_root_lis = tree_root.getElementsByTagName("li");
		for ( var i=0; i<tree_root_lis.length; i++ ) {
			tree_root_lis[i].className = false;
		}
		new_at_li.parentNode.className = "at";
	}
</script>