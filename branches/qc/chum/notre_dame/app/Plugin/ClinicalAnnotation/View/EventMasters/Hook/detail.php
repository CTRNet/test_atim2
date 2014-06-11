<?php 
	
	if(!$display_edit_button) {
		unset($structure_links['bottom']['edit']);
		unset($structure_links['bottom']['delete']);
		unset($final_options['links']['bottom']['edit']);
		unset($final_options['links']['bottom']['delete']);
	}