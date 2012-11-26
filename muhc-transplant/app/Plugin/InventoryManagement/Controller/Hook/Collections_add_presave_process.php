<?php

	if($copy_source && $this->request->data['Collection']['collection_property'] != 'independent collection' && $copy_links_option == 6){
		$this->Collection->addWritableField(array('misc_identifier_id'));
		$this->request->data['Collection'] = array_merge($this->request->data['Collection'], array('misc_identifier_id'	=> $copy_src_data['Collection']['misc_identifier_id']));
	}
