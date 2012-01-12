<?php
	$structure_links = array(
		'top'=>'/'
	);

	echo "<div class='validation hidden' id='timeErr'><ul class='warning'><li>".__("server_client_time_discrepency")."</li></ul></div>";
	$this->Structures->build( $atim_structure, array('type'=>'add', 'links'=>$structure_links) );
	
?>
<script>
var loginPage = true;
</script>