<?php
	$structure_links = array(
		"index" => array(
			'detail' => "/datamart/browser/browse/%%BrowsingIndex.root_node_id%%",
			'edit' => "/datamart/browser/edit/%%BrowsingIndex.id%%",
			'save' => array('link' => "/datamart/browser/save/%%BrowsingIndex.id%%", 'icon' => 'disk'),
			'delete' => "/datamart/browser/delete/%%BrowsingIndex.id%%"),
		"bottom" => array(
			"new" => "/datamart/browser/browse/"
		)
	);
	
	$settings = array(
			'header' => array('title' => __('temporary browsing', true), 'description' => __('unsaved browsing trees that are automatically deleted when there are more than x', true)),
			'form_bottom' => false,
			'actions'	=> false,
			'pagination' => false
	);
	
	$structures->build($atim_structure, array('data' => $tmp_browsing, 'type' => 'index', 'links' => $structure_links, 'settings' => $settings));
	
	$settings = array(
		'header' => array('title' => __('saved browsing', true), 'description' => __('saved browsing trees', true)),
		'form_top' => false
	);
	unset($structure_links['index']['save']);
	$structures->build($atim_structure, array('data' => $this->data, 'type' => 'index', 'links' => $structure_links, 'settings' => $settings));
?>