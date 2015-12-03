<?php
	
	// --------------------------------------------------------------------------------
	// Save Participant Identifier
	// -------------------------------------------------------------------------------- 
	$query_to_update = "UPDATE tma_slides SET tma_slides.barcode = tma_slides.id WHERE tma_slides.barcode IS NULL OR tma_slides.barcode LIKE 'tmp-%';";
	$this->TmaSlide->tryCatchQuery($query_to_update);
	$this->TmaSlide->tryCatchQuery(str_replace("tma_slides", "tma_slides_revs", $query_to_update));
