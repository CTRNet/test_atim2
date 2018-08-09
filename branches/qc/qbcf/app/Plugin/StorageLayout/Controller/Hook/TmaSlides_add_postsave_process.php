<?php 
	
	$queryToUpdate = "UPDATE tma_slides SET barcode = id WHERE barcode LIKE 'tmp_%';";
	try{
		$this->TmaSlide->query($queryToUpdate);
		$this->TmaSlide->query(str_replace("tma_slides", "tma_slides_revs", $queryToUpdate));
	}catch(Exception $e){
		$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}