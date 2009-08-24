<?php
	
	// SETTINSG
	
	$structure_settings = array(
		'tree'=>array(
			'StorageMaster'		=> 'StorageMaster',
			'AliquotMaster'	=> 'AliquotMaster'
		),
		
		'columns' => array(
			1	=> array( 'width'=>'30%' ),
			10	=> array( 'width'=>'70%' )
		)
	);
	// LINKS
	

	$structure_links = array(
		'tree'=>array(
			'StorageMaster' => array(
				'detail'=>'/storagelayout/storage_masters/detail/%%StorageMaster.id%%/1'
			),
			'AliquotMaster' => array(
				'detail'=>'/inventorymanagement/aliquot_masters/detailAliquot/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%'
			)
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
	
	$structure_extras = array();
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
			tree_root_lis[i].className = true;
		}
		new_at_li.parentNode.className = "at";
	}
</script>