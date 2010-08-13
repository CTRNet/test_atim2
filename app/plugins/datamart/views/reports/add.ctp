<?php
if($this->layout == "ajax"){
	require("add_ajax.php");	
}else{
	require("add_page.php");
}