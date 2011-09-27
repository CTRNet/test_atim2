<?php
	ob_start();
	$structures->build($atim_structure, array(
		'type' => 'edit',
		'links' => array('top' => '/inventorymanagement/collections/templateInit/'.$collection_id.'/'.$template['Template']['id']),
		'settings' => array(
			'header' => array('title' => __('template init', true), 'description' => $template['Template']['name']),
			)
		)
	);
	$display = $shell->validationErrors().ob_get_contents();
	ob_end_clean();
	$display = ob_get_contents().$display;
	ob_clean();
	$shell->validationErrors = null;
	echo json_encode(array('goToNext' => isset($goToNext), 'display' => $display));
	