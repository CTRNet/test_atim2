<?php

if($csv_creation == '2') {
	//Export for review: reformat DisplayData.label
	foreach($data['children'] as &$tmp_children) {
		if($tmp_children['DisplayData']['type'] == 'AliquotMaster' && $tmp_children['sample_master_dup']['qc_tf_is_tma_sample_control'] == 'n') {
			$new_label = $tmp_children['DisplayData']['label'];
			if(preg_match('/^p#([0-9]+)\ \[.*(.*)\ ([TNUB])(\ \(.+\)){0,1}\]$/', $new_label, $matches)) {
				$new_label = $matches[1]."_".$matches[3];
			}
			$tmp_children['DisplayData']['label'] = $new_label;
		}
	}
}

