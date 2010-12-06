<?php
	$structures->build($atim_structure, 
		array(
			'type' => 'batchedit', 
			'links' => array(
				'top' => '/clinicalannotation/Participants/batchEdit'),
			'settings' => array(
				'header' => array(
					'title' => __('participants', true)." - ".__('batch edit', true),
					'description' => sprintf(__('you are about to edit %d element(s)', true), count(explode(",", $this->data[0]['ids'])))
				)
			)
		)
	);
?>
