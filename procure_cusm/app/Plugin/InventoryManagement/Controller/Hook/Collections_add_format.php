<?php 
	
	if(!$collection_id && !$copy_source) {
		$this->flash(__('a created collection should be linked to a participant'), "javascript:history.back();", 5);
		return;
	}
	