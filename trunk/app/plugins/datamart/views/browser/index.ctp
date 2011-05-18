<?php
	$structure_links = array(
		"index" => array(
			'detail' => array(
				'link' => "/datamart/browser/browse/%%BrowsingIndex.root_node_id%%",
				'icon' => 'detail'
			),
			'edit' => "/datamart/browser/edit/%%BrowsingIndex.id%%",
			'delete' => "/datamart/browser/delete/%%BrowsingIndex.id%%"),
		"bottom" => array(
			"new" => "/datamart/browser/browse/"
		));
	$structures->build($atim_structure, array('type' => 'index', 'links' => $structure_links));
?>