<?php

	$tmp_res = $this->SampleMaster->validatePaxgeneTubesFields($sample_control_data, $this->request->data);
	$submitted_data_validates = (!$tmp_res)? false : $submitted_data_validates;



