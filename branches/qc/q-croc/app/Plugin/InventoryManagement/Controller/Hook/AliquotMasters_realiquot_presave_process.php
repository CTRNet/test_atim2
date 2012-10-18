<?php
	
	if(empty($errors) && (strpos($child_aliquot_ctrl['AliquotControl']['detail_form_alias'], 'qcroc_ad_tissue_tubes') !== false)) {
		$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		//TODO calculate time in RNA LAter if realiquot to tube requested
	}
	