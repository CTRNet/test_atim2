<?php

	$tmp_res = $this->SampleMaster->validatePaxgeneTubesFields(array('SampleControl' => $sample_data['SampleControl']), $this->request->data);
	$submitted_data_validates = (!$tmp_res)? false : $submitted_data_validates;
