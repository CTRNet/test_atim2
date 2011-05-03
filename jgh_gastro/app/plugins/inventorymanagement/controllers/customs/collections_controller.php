<?php

class CollectionsControllerCustom extends CollectionsController {
	
	function generateLabel($data) {
		return $this->data['Collection']['project'] . 
			'-' . 
			(empty($this->data['Collection']['collection_datetime']['year'])? '00': substr($this->data['Collection']['collection_datetime']['year'], 2));
	}
	
}

?>