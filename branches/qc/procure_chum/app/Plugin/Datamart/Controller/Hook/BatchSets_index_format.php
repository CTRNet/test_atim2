<?php

	if(Configure::read('procure_atim_version') == 'CENTRAL') {
		AppController::addWarningMsg(__('only aliquots or participants batchsets will be saved by the banks merge process'));
	}
