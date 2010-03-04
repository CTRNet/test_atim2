<?php
if(isset($data['csv_print']) && $data['csv_print']){
	require("storage_layout_csv.ctp");
}else{
	require("storage_layout_html.ctp");
}
?>