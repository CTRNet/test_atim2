<?php
if($data['csv_print']){
	require("storage_layout_csv.ctp");
}else{
	require("storage_layout_html.ctp");
}
?>