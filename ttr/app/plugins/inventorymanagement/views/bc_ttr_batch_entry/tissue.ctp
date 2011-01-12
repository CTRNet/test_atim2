<?php

	$options = array(
		'type'	=> 'add',
		'settings' => array(
			'header' 		=> __('tissue block', true),
			'actions' 		=> false,
			'form_bottom'	=> false,
			'name_prefix'	=> 'block'
		),
		'links' => array(
			'top' => '/inventorymanagement/bc_ttr_batch_entry/tissue/'.$sample_id.'/')
	);
	
	$structures->build($bc_ttr_be_block, $options);
	
	$options['settings']['name_prefix'] = 'slide';
	$options['settings']['form_top'] = false;
	$options['settings']['form_bottom'] = true;
	$options['settings']['header'] = array("title" => __('tissue slide', true), "description" => "(".__("one slide created per tissue block", true).")");
	$structures->build($bc_ttr_be_slides, $options);
