<?php
if(isset($aliquot_label)){
	$final_options['override']['AliquotMaster.qc_lady_label'] = $aliquot_label;
}else{
	$final_options['override']['AliquotMaster.qc_lady_label'] = "N/A";
}
?>