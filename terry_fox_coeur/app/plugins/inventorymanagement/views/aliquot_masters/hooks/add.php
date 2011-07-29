<?php
foreach($atim_structure['Structure'] as $new_struct) {
	if($new_struct['alias'] == "ad_spec_tiss_blocks"){
		$options_children['override']['AliquotMaster.aliquot_volume_unit'] = "mm³";//counter to eventum 1185
	}
}