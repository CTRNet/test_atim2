<?php 
	
	//Redirect visit data entry worklfow
	if(isset($_SESSION['procure_clinical_file_update_process'])) $url_to_flash = $_SESSION['procure_clinical_file_update_process']['next_page_url'];
	