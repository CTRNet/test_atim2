<?php
	
	if($copy_source){
		if($copy_links_option == 6 && $copy_src_data['Collection']['uhn_misc_identifier_id']){
			$this->Collection->addWritableField(array('uhn_misc_identifier_id'));
			$this->request->data['Collection']['uhn_misc_identifier_id'] = $copy_src_data['Collection']['uhn_misc_identifier_id'];
		}
	}

?>
