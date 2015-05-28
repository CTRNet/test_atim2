<?php
	/* 
	@author Stephen Fung
	@since 2015-04-29
	Eventum ID: 3217
	Writing storage system code to the view_storage_masters table
	This bug also exist in the core ATiM 2.6.4 version
	*/
	
	if($bool_save_done) {
		
		$this->ViewStorageMaster->tryCatchQuery("UPDATE view_storage_masters SET view_storage_masters.code = view_storage_masters.id WHERE view_storage_masters.id = $storage_master_id;"); 
		
	}