
<?php

// Add preset data
if(isset($preset)) {
	foreach($preset as $k1 => $arr){
		foreach($arr as $k2 => $val){
			$final_options['override'][$k1.".".$k2] = $val;
		}
	}
}

?>