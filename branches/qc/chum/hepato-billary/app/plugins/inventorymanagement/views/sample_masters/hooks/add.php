
<?php
//cannot test on $this->data alone because some data is already defined
if(!isset($this->data['SampleMaster']['notes'])){
	if($sample_control_id == 2){
		//blood
		$final_options['override']['SampleDetail.qc_hb_sample_code'] = "S";
	}else if($sample_control_id == 3){
		//tissue
		$final_options['override']['SpecimenDetail.supplier_dept'] = "pathology";
		$final_options['override']['SpecimenDetail.reception_by'] = "Urszula Krzemien";
	}
	
	if(isset($preset)){
		foreach($preset as $k1 => $arr){
			foreach($arr as $k2 => $val){
				$final_options['override'][$k1.".".$k2] = $val;
			}
		}
	}
}
