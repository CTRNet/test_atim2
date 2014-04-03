<?php

	if($parent_dx && $parent_dx['DiagnosisControl']['controls_type'] == 'lymphoma' && $dx_ctrl['DiagnosisControl']['controls_type'] == 'lymphoma') {
		$this->flash('unable to add a lymphoma secondary to a lymphoma primary', 'javascript:history.back();');
	}

?>