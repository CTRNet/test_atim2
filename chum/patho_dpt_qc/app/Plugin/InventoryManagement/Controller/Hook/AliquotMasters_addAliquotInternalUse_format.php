<?php

	if($this->request->data) {
		foreach($this->request->data as &$tmp_data_set) unset($tmp_data_set['ViewAliquot']);
	}
	