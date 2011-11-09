<?php

	if($dx_master_data['DiagnosisControl']['controls_type'] == 'lymphoma') {
		unset($this->viewVars['child_controls_list']['Secondary - Lymphoma']);
	}

?>