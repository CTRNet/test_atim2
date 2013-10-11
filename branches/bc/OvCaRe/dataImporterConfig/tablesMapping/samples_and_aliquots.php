<?php

function loadSamplesAndAliquots() {
	$tissue_matches = array(
		'Abdominal mass' => array('source' => 'abdominal mass', 'laterality' => ''),
		'Abdominal Wall' => array('source' => 'abdominal wall', 'laterality' => ''),
		'Abdominal wall tumour' => array('source' => 'abdominal wall', 'laterality' => ''),
		'Adnexa' => array('source' => 'adnexal', 'laterality' => ''),
		'Adnexal Mass' => array('source' => 'adnexal', 'laterality' => ''),
		'Anterior Vulva' => array('source' => 'vulva', 'laterality' => ''),
		'Anus' => array('source' => 'anus', 'laterality' => ''),
		'Appendix' => array('source' => 'appendix', 'laterality' => ''),
		'Bilateral Tube' => array('source' => 'fallopian tube', 'laterality' => 'bilateral'),
		'Bladder' => array('source' => 'bladder', 'laterality' => ''),
		'Bladder-peritoeum' => array('source' => 'mix', 'laterality' => ''),
		'Brain' => array('source' => 'brain', 'laterality' => ''),
		'Cervis' => array('source' => 'uterine cervix ', 'laterality' => ''),
		'Cervix' => array('source' => 'uterine cervix ', 'laterality' => ''),
		'Colon' => array('source' => 'colon', 'laterality' => ''),
		'Cul de sac' => array('source' => 'cul-de-sac', 'laterality' => ''),
		'cul-de-sac' => array('source' => 'cul-de-sac', 'laterality' => ''),
		'cystic mass' => array('source' => 'other', 'laterality' => ''),
		'Dermoid cyst' => array('source' => 'other', 'laterality' => ''),
		'Descending colon' => array('source' => 'colon', 'laterality' => ''),
		'Distal rectal sigmoid tumour' => array('source' => 'other', 'laterality' => ''),
		'Endometrial' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrial mass' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrial Polyp' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrial polypoid tumour' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium #1' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium #1' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium #2' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium #2' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium #3' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium (polypoid)' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium (polypoid)' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium 1' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium 1' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium 2' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium 2' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium 4' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium cavity' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium Myomentum' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium Polyploid Nodule' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium Polyploid Nodule' => array('source' => 'endometrium', 'laterality' => ''),
		'Fallopian Tube NOS' => array('source' => 'fallopian tube', 'laterality' => ''),
		'Fimbrial Mass' => array('source' => 'other', 'laterality' => ''),
		'Granulosa Cell Tumor' => array('source' => 'other', 'laterality' => ''),
		'Granulosa Cell Tumour' => array('source' => 'other', 'laterality' => ''),
		'Hernia sac' => array('source' => 'hernia sac', 'laterality' => ''),
		'Hernia sac' => array('source' => 'hernia sac', 'laterality' => ''),
		'Large Bowel' => array('source' => 'other', 'laterality' => ''),
		'Larger ovary' => array('source' => 'ovary', 'laterality' => ''),
		'Left (LSO) nodule' => array('source' => 'other', 'laterality' => 'left '),
		'Left Adnexa' => array('source' => 'adnexal', 'laterality' => 'left '),
		'Left Adnexal' => array('source' => 'adnexal', 'laterality' => 'left '),
		'Left External Iliac Lymph Node' => array('source' => 'lymph node', 'laterality' => 'left '),
		'Left external iliac node' => array('source' => 'lymph node', 'laterality' => 'left '),
		'Left Fallopian Tube' => array('source' => 'fallopian tube', 'laterality' => 'left '),
		'Left Fallopian Tube + Left Ovary' => array('source' => 'mix', 'laterality' => 'left '),
		'Left Fallopian Tube fimbria' => array('source' => 'fallopian tube', 'laterality' => 'left '),
		'Left Fimbria' => array('source' => 'other', 'laterality' => 'left '),
		'Left Iliac Lymph Node' => array('source' => 'lymph node', 'laterality' => 'left '),
		'Left labia' => array('source' => 'other', 'laterality' => 'left '),
		'Left Lower Quadrant' => array('source' => 'other', 'laterality' => 'left '),
		'Left Ovarian Mass' => array('source' => 'ovary', 'laterality' => 'left '),
		'Left Ovary' => array('source' => 'ovary', 'laterality' => 'left '),
		'Left Ovary + Tube' => array('source' => 'ovary', 'laterality' => 'left '),
		'Left Ovary 1' => array('source' => 'ovary', 'laterality' => 'left '),
		'Left Ovary 1' => array('source' => 'ovary', 'laterality' => 'left '),
		'Left Ovary 2' => array('source' => 'ovary', 'laterality' => 'left '),
		'Left Ovary 2' => array('source' => 'ovary', 'laterality' => 'left '),
		'Left Ovary/Tube' => array('source' => 'mix', 'laterality' => 'left '),
		'Left Para-Aortic Lymph Node' => array('source' => 'lymph node', 'laterality' => 'left '),
		'left Paratubrae mass' => array('source' => 'other', 'laterality' => 'left '),
		'Left pelvic L. node' => array('source' => 'lymph node', 'laterality' => 'left '),
		'Left Pelvic Lymph Node' => array('source' => 'lymph node', 'laterality' => 'left '),
		'Left Pelvic Node' => array('source' => 'other', 'laterality' => 'left '),
		'Left Pelvic Sidewall' => array('source' => 'other', 'laterality' => 'left '),
		'Left retroperitoneal mass' => array('source' => 'other', 'laterality' => 'left '),
		'Left Uretecic Nodule' => array('source' => 'other', 'laterality' => 'left '),
		'Left Uterosacral' => array('source' => 'other', 'laterality' => 'left '),
		'Leiomyoma' => array('source' => 'other', 'laterality' => ''),
		'Lieomyoma' => array('source' => 'other', 'laterality' => ''),
		'Liver' => array('source' => 'liver', 'laterality' => ''),
		'Lt Ovary 3' => array('source' => 'ovary', 'laterality' => 'left '),
		'Lt ovary/tube' => array('source' => 'mix', 'laterality' => 'left '),
		'Lt ovary/tube' => array('source' => 'mix', 'laterality' => 'left '),
		'Mesentery Transverse Left Colon' => array('source' => 'colon', 'laterality' => 'left '),
		'middle pelvic tumour' => array('source' => 'other', 'laterality' => ''),
		'midline peri-urachal mass' => array('source' => 'other', 'laterality' => ''),
		'Myometrium' => array('source' => 'other', 'laterality' => ''),
		'nerve sheath tumour' => array('source' => 'other', 'laterality' => ''),
		'Nodes' => array('source' => 'other', 'laterality' => ''),
		'Nodes' => array('source' => 'other', 'laterality' => ''),
		'Nodule close to LSO' => array('source' => 'other', 'laterality' => ''),
		'Nodules' => array('source' => 'other', 'laterality' => ''),
		'Nodules ' => array('source' => 'other', 'laterality' => ''),
		'Normal Omentum' => array('source' => 'omentum ', 'laterality' => ''),
		'Normal omentum 3' => array('source' => 'omentum ', 'laterality' => ''),
		'Omental Nodule' => array('source' => 'omentum ', 'laterality' => ''),
		'Omentum' => array('source' => 'omentum ', 'laterality' => ''),
		'Omentum #1' => array('source' => 'omentum ', 'laterality' => ''),
		'Omentum #2' => array('source' => 'omentum ', 'laterality' => ''),
		'Omentum #3' => array('source' => 'omentum ', 'laterality' => ''),
		'Omentum Bx' => array('source' => 'omentum ', 'laterality' => ''),
		'Omentum Bx #1' => array('source' => 'omentum ', 'laterality' => ''),
		'Omentum Bx' => array('source' => 'omentum ', 'laterality' => ''),
		'Ovarian cyst' => array('source' => 'ovary', 'laterality' => ''),
		'Ovarian tumour (R)' => array('source' => 'ovary', 'laterality' => 'right'),
		'Ovary + Tube' => array('source' => 'mix', 'laterality' => ''),
		'Ovary + Tube NOS' => array('source' => 'mix', 'laterality' => ''),
		'Ovary NOS' => array('source' => 'ovary', 'laterality' => ''),
		'Para-aortic node' => array('source' => 'other', 'laterality' => ''),
		'Pelvic Mass' => array('source' => 'pelvic mass', 'laterality' => ''),
		'Pelvic Mass (left)' => array('source' => 'pelvic mass', 'laterality' => 'left '),
		'Pelvic Node' => array('source' => 'other', 'laterality' => ''),
		'Pelvic Side Wall' => array('source' => 'other', 'laterality' => ''),
		'Pelvic Tumour' => array('source' => 'other', 'laterality' => ''),
		'Pelvic-Abdominal' => array('source' => 'other', 'laterality' => ''),
		'Pelvic-Abdominal Sidewall' => array('source' => 'other', 'laterality' => ''),
		'Pelvis' => array('source' => 'other', 'laterality' => ''),
		'Peritoneal Nodule' => array('source' => 'peritoneum', 'laterality' => ''),
		'Peritoneal Tumor Wall' => array('source' => 'peritoneum', 'laterality' => ''),
		'Peritoneal Tumour' => array('source' => 'peritoneum', 'laterality' => ''),
		'Post Liver Tumour' => array('source' => 'other', 'laterality' => ''),
		'Posterior cul-de-sac' => array('source' => 'cul-de-sac', 'laterality' => ''),
		'Recto sigmoid serosa' => array('source' => 'sigmoid', 'laterality' => ''),
		'Rectosigmoid' => array('source' => 'sigmoid', 'laterality' => ''),
		'Rectovagina' => array('source' => 'vagina', 'laterality' => ''),
		'retroperitoneal ' => array('source' => 'peritoneum', 'laterality' => ''),
		'Retroperitoneum' => array('source' => 'peritoneum', 'laterality' => ''),
		'Retrouterine' => array('source' => 'other', 'laterality' => ''),
		'Right Adnexal' => array('source' => 'adnexal', 'laterality' => ''),
		'Right Adnexal Mass' => array('source' => 'adnexal', 'laterality' => ''),
		'right and left ovary' => array('source' => 'ovary', 'laterality' => 'bilateral'),
		'Right Broad Ligament Fibroid' => array('source' => 'other', 'laterality' => 'right'),
		'Right Colon' => array('source' => 'colon', 'laterality' => 'right'),
		'Right Fallopian Tube' => array('source' => 'fallopian tube', 'laterality' => 'right'),
		'Right Fallopian Tube + Ovary' => array('source' => 'mix', 'laterality' => 'right'),
		'Right Fallopian Tube + Right Ovary' => array('source' => 'mix', 'laterality' => 'right'),
		'Right Flank' => array('source' => 'other', 'laterality' => 'right'),
		'Right Groin mass' => array('source' => 'other', 'laterality' => 'right'),
		'Right Inguinal Node' => array('source' => 'other', 'laterality' => 'right'),
		'Right Lower Quadrant' => array('source' => 'other', 'laterality' => 'right'),
		'Right Ovarian Cyst' => array('source' => 'ovary', 'laterality' => 'right'),
		'Right Ovary' => array('source' => 'ovary', 'laterality' => 'right'),
		'Right Ovary + Right Tube' => array('source' => 'mix', 'laterality' => 'right'),
		'Right Ovary + Tube' => array('source' => 'mix', 'laterality' => 'right'),
		'Right Ovary 3' => array('source' => 'ovary', 'laterality' => 'right'),
		'Right Ovary 3' => array('source' => 'ovary', 'laterality' => 'right'),
		'Right Ovary 4' => array('source' => 'ovary', 'laterality' => 'right'),
		'Right Paracolonic Gutter' => array('source' => 'other', 'laterality' => 'right'),
		'Right Pelvic Lymph Node' => array('source' => 'lymph node', 'laterality' => 'right'),
		'Right Pelvic Mass' => array('source' => 'pelvis', 'laterality' => 'right'),
		'Right Pelvic Node' => array('source' => 'pelvis', 'laterality' => 'right'),
		'Right Pelvic Ovary Mass' => array('source' => 'pelvis', 'laterality' => 'right'),
		'Right Pelvic Sidewall' => array('source' => 'pelvis', 'laterality' => 'right'),
		'Right Pelvis' => array('source' => 'pelvis', 'laterality' => 'right'),
		'Right Retroperitonium' => array('source' => 'other', 'laterality' => 'right'),
		'Right Shoulder' => array('source' => 'other', 'laterality' => 'right'),
		'Right Uretecic Nodule' => array('source' => 'other', 'laterality' => 'right'),
		'Right uterosacral' => array('source' => 'uterus', 'laterality' => 'right'),
		'Right Utero-Sacral' => array('source' => 'uterus', 'laterality' => 'right'),
		'Right Uterus Node' => array('source' => 'uterus', 'laterality' => 'right'),
		'Rt ovary + tube #1' => array('source' => 'mix', 'laterality' => 'right'),
		'Rt ovary + tube #2' => array('source' => 'mix', 'laterality' => 'right'),
		'Rt Ovary 1' => array('source' => 'ovary', 'laterality' => 'right'),
		'Rt Ovary 2' => array('source' => 'ovary', 'laterality' => 'right'),
		'RT Pelvic Side wall' => array('source' => 'other', 'laterality' => 'right'),
		'Rt tube/Ovary #2' => array('source' => 'mix', 'laterality' => 'right'),
		'Rt tube/Ovary #3' => array('source' => 'mix', 'laterality' => 'right'),
		'Sigmoid Colon' => array('source' => 'colon', 'laterality' => ''),
		'Sigmoid Tumour' => array('source' => 'colon', 'laterality' => ''),
		'Small Bowel' => array('source' => 'small bowel', 'laterality' => ''),
		'Small Bowel Mesentary' => array('source' => 'small bowel', 'laterality' => ''),
		'Small bowel mesentary tumour' => array('source' => 'small bowel', 'laterality' => ''),
		'Small Bowel Tumour' => array('source' => 'small bowel', 'laterality' => ''),
		'Small Intestine' => array('source' => 'small intestin', 'laterality' => ''),
		'Smaller ovary' => array('source' => 'ovary', 'laterality' => ''),
		'Spetum' => array('source' => 'other', 'laterality' => ''),
		'Splenic Flexure Tumour' => array('source' => 'other', 'laterality' => ''),
		'Splenic Flexure TumourEndometrium' => array('source' => 'mix', 'laterality' => ''),
		'Stomach' => array('source' => 'stomach', 'laterality' => ''),
		'Transverse Colon' => array('source' => 'colon', 'laterality' => ''),
		'transverse mesentary, Right upper quadrant' => array('source' => 'other', 'laterality' => ''),
		'Tumour' => array('source' => 'other', 'laterality' => ''),
		'Tumour nodule' => array('source' => 'other', 'laterality' => ''),
		'Umbilical Mass' => array('source' => 'other', 'laterality' => ''),
		'Umbilicus Nodule' => array('source' => 'other', 'laterality' => ''),
		'Upper Abdomen' => array('source' => 'other', 'laterality' => ''),
		'Uterine Cavity' => array('source' => 'uterus', 'laterality' => ''),
		'Uterine Cervix' => array('source' => 'uterus', 'laterality' => ''),
		'Uterine Fibroid' => array('source' => 'uterus', 'laterality' => ''),
		'Uterosacral Ligament' => array('source' => 'uterus', 'laterality' => ''),
		'Uterus' => array('source' => 'uterus', 'laterality' => ''),
		'Uterus + Left Tube + Ovary' => array('source' => 'mix', 'laterality' => ''),
		'Uterus + Ovaries + Tubes' => array('source' => 'mix', 'laterality' => ''),
		'Uterus + Tubes + Ovaries' => array('source' => 'mix', 'laterality' => ''),
		'Uterus leiomyoma' => array('source' => 'uterus', 'laterality' => ''),
		'Uterus malignant' => array('source' => 'uterus', 'laterality' => ''),
		'Uterus Nodule' => array('source' => 'uterus', 'laterality' => ''),
		'Uterus/Endometrium' => array('source' => 'mix', 'laterality' => ''),
		'Vaginal' => array('source' => 'vagina', 'laterality' => ''),
		'Vulva' => array('source' => 'vulva', 'laterality' => ''));
	$tmp_tissue_matches = $tissue_matches;
	$tissue_matches = array();
	foreach($tmp_tissue_matches as $key => $data) $tissue_matches[strtolower($key)] = $data;
	unset($tmp_tissue_matches);
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path);
	$sheets_keys = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_keys[$tmp['name']] = $key;
	
	//===============================================================================================================
	// PARSE WORKSHEET : SpecimenQualityControl
	//===============================================================================================================
	
	$studied_voa_nbr = null;
	$specimen_review = array();
	$specimen_review_from_aliquot_label = array();
	$worksheet_name = 'SpecimenQualityControl';
	foreach($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			if($new_line_data['VOA Number']) $studied_voa_nbr = $new_line_data['VOA Number'];
			if(!$studied_voa_nbr) die('ERR 37372882372332');
			// Specimen Review
			$patho_reviewer = $new_line_data['Specimen Quality Control::Pathology Reviewer'];
			if(strlen($patho_reviewer)) {
				if(!isset($specimen_review[$studied_voa_nbr][$patho_reviewer] )) {
					$specimen_review[$studied_voa_nbr][$patho_reviewer] = array(
						'SpecimenReviewMaster' => array(
							'specimen_review_control_id' => Config::$reviews_controls['specimen_review_control_id']),
						'SpecimenReviewDetail' => array(
							'pathology_reviewer' => $patho_reviewer),
						'specimen_review_detail_tablename' => Config::$reviews_controls['specimen_review_detail_tablename'],
						'AliquotReviews' => array()
					);
				} 
				// Aliquot Review
				$aliquot_label = $new_line_data['Specimen Quality Control::Sample Identifier'];
				if(isset($specimen_review[$studied_voa_nbr][$patho_reviewer]['AliquotReviews'][$aliquot_label])) die('ERR 8837228282');
				if(!in_array($new_line_data['Specimen Quality Control::Reviewed Grade'], array('Ungraded','Not Assessed',''))) die('ERR 38837833');
				$cellularity_subjective = $new_line_data['Specimen Quality Control::Cellularity Subjective'];
				$cellularity_subjective_notes = '';
				if($cellularity_subjective) {
					if(!preg_match('/^%{0,1}([0-9]{1,2})%{0,1}([\ -]{1,3}(.+)){0,1}$/', $new_line_data['Specimen Quality Control::Cellularity Subjective'], $matches)) die('ERR 773737373 '.$new_line_data['Specimen Quality Control::Cellularity Subjective']);
					$cellularity_subjective = $matches[1];
					if(isset($matches[3])) $cellularity_subjective_notes = $matches[3];
				}
				$specimen_review[$studied_voa_nbr][$patho_reviewer]['AliquotReviews'][$aliquot_label] = array(
					'AliquotReviewMaster' => array('aliquot_review_control_id' => Config::$reviews_controls['aliquot_review_control_id']),
					'AliquotReviewDetail' => array(
						'cellularity_assessor' => $new_line_data['Specimen Quality Control::Cellularity Assessor'],
						'cellularity_subjective_prct' => $cellularity_subjective,
						'reviewed_pathology' => $new_line_data['Specimen Quality Control::Reviewed Pathology'],
						'notes' => $cellularity_subjective_notes),
					'aliquot_review_detail_tablename' => Config::$reviews_controls['aliquot_review_detail_tablename']	
				);
				$specimen_review_from_aliquot_label[$aliquot_label] = array('key1' => $studied_voa_nbr, 'key2' => $patho_reviewer);
		 	} else if(strlen($new_line_data['Specimen Quality Control::Cellularity Assessor'].$new_line_data['Specimen Quality Control::Cellularity Subjective'].$new_line_data['Specimen Quality Control::Reviewed Grade'].$new_line_data['Specimen Quality Control::Reviewed Pathology'].$new_line_data['Specimen Quality Control::Sample Identifier'])) {
		 			die('ERR 3872372837283');
	 		}
		}
	}
	
	//===============================================================================================================
	// PARSE WORKSHEET : SpecimenRelease
	//===============================================================================================================
	
	$studied_voa_nbr = null;
	$released_aliquots = array();
	$worksheet_name = 'SpecimenRelease';
	foreach($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);		
			if($new_line_data['VOA Number']) $studied_voa_nbr = $new_line_data['VOA Number'];
			if(!$studied_voa_nbr) die('ERR 37372882372332');
			$aliquot_label = $new_line_data['Specimen Release::Sample Indentifier'];
			if($aliquot_label) {
				if(!isset($released_aliquots[$studied_voa_nbr][$aliquot_label])) {
					$date_field = 'Specimen Release::Date';
					$release_data = getDateAndAccuracy($new_line_data[$date_field], 'InventoryManagement Release', $date_field, $excel_line_counter);
					$release_data['requestor'] = $new_line_data['Specimen Release::Requestor'];
					foreach(array('Specimen Release::Section Thickness','Specimen Release::Number of Sections','Specimen Release::Volume') as $field) if(!preg_match('/^[0-9]*$/', $new_line_data[$field]))die('ERR 838298934743 '.$field.' '.v);
					$release_data['ovcare_tissue_section_thickness'] = $new_line_data['Specimen Release::Section Thickness'];
					$release_data['ovcare_tissue_section_numbers'] = $new_line_data['Specimen Release::Number of Sections'];
					$release_data['used_volume'] = $new_line_data['Specimen Release::Volume'];
					$released_aliquots[$studied_voa_nbr][$aliquot_label] = $release_data;
				} else {
					die('ERR838372837283 '.$excel_line_counter);
					Config::$summary_msg['InventoryManagement Release']['@@ERROR@@']["Aliquot released twice"][] = "Aliquot $aliquot_label has been releazed twice [Worksheet $worksheet_name / line: $excel_line_counter]";
				}
			} else if(strlen($new_line_data['Specimen Release::Date'].$new_line_data['Specimen Release::Requestor'].$new_line_data['Specimen Release::Volume'].$new_line_data['Specimen Release::Section Thickness'].$new_line_data['Specimen Release::Number of Sections'])) {
				die('ERR 388738384 '.$excel_line_counter);
			}
		}
	}
	
	//===============================================================================================================
	// PARSE WORKSHEET : SpecimenAccural
	//===============================================================================================================		
				
	$comments_used_to_define_released_aliquots = array();
	$comments_used_to_define_not_banked_aliquots = array();

	$studied_voa_nbr = null;
	$collection_data = array();
	$tmp_sample_code = 0;
	$aliquot_master_id = 0;
	$worksheet_name = 'SpecimenAccural';
	foreach($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			if($new_line_data['VOA Number']) {
				if(!is_null($studied_voa_nbr)) recordCollection($collection_data, $studied_voa_nbr);
				$collection_data = array('samples' => array(), 'notes' => array());
				$studied_voa_nbr = $new_line_data['VOA Number'];
			} else if(!$studied_voa_nbr) die('ERR 37372882372332.2');
			
			
if(!isset(Config::$voas_to_ids[$studied_voa_nbr])) continue;
			
			//Get Data
			$file_anatomic_location = str_replace(array("\n", 'N/A', '?'), array('','',''), $new_line_data['Specimen Accrual::Anatomic Location']);
			$file_comments = $new_line_data['Specimen Accrual::Comments'];
			//'Specimen Accrual::Ischaemia Time'
			//'Specimen Accrual::Released'
			$file_aliquot_label = $new_line_data['Specimen Accrual::Sample Identifier'];
			if(!$file_aliquot_label) $file_aliquot_label = $studied_voa_nbr.' #?#';
			$file_specimen_type = $new_line_data['Specimen Accrual::Specimen Type'];
			if($file_specimen_type) {
				//SPECIMEN TYPE => Imported: Sample and aliquot created
				$aliquot_master_id++;
				$in_stock = 'yes';
				$realeased = false;
				//Define aliquot released or not
				$relase_precision = null;
				if($new_line_data['Specimen Accrual::Released'] == 'Yes') {
					$realeased = true;
					$in_stock = 'no';
				} else if(preg_match('/(([Tt]o|[Ff]or).{1,10}([Gg]ilks|[Nn]elson|[Pp]ress|[Cc]lara|[Ss]teve))|(^[Ff]or\ )|(^[Gg]iven)/', $file_comments, $matches)) {
					$realeased = true;
					$in_stock = 'no';
					$relase_precision = $matches['3'];
					$comments_used_to_define_released_aliquots[$file_comments][] = $excel_line_counter;
				} else if(preg_match('/(([Nn]ot\ +in\ +bank)|([Mm][Ii]ssing)|([Nn]ot banked)|(^[Nn]ot frozen)|(^[Nn]o frozen vials)|(^lost vial))/', $file_comments)) {
					$in_stock = 'no';
					$comments_used_to_define_not_banked_aliquots[$file_comments][] = $excel_line_counter;
				}
				//Manage QC & Internal Uses
				$aliquot_internal_uses = array();
				if(isset($released_aliquots[$studied_voa_nbr]) && isset($released_aliquots[$studied_voa_nbr][$file_aliquot_label])) {
					$aliquot_internal_uses['aliquot_master_id'] = $aliquot_master_id;
					$aliquot_internal_uses['use_code'] = 'To '.($released_aliquots[$studied_voa_nbr][$file_aliquot_label]['requestor']? $released_aliquots[$studied_voa_nbr][$file_aliquot_label]['requestor'] : '?');
					$aliquot_internal_uses['type'] = 'release';
					$aliquot_internal_uses['use_datetime'] = $released_aliquots[$studied_voa_nbr][$file_aliquot_label]['date'];
					$aliquot_internal_uses['use_datetime_accuracy'] = ($released_aliquots[$studied_voa_nbr][$file_aliquot_label]['accuracy'] == 'c')? 'h' : $released_aliquots[$studied_voa_nbr][$file_aliquot_label]['accuracy'];				
					$aliquot_internal_uses['ovcare_tissue_section_thickness'] = $released_aliquots[$studied_voa_nbr][$file_aliquot_label]['ovcare_tissue_section_thickness'];
					$aliquot_internal_uses['ovcare_tissue_section_numbers'] = $released_aliquots[$studied_voa_nbr][$file_aliquot_label]['ovcare_tissue_section_numbers'];	
					$aliquot_internal_uses['used_volume'] = $released_aliquots[$studied_voa_nbr][$file_aliquot_label]['used_volume'];
					unset($released_aliquots[$studied_voa_nbr][$file_aliquot_label]);
					if(empty($released_aliquots[$studied_voa_nbr])) unset($released_aliquots[$studied_voa_nbr]);
				} else if($realeased) {
					$aliquot_internal_uses['aliquot_master_id'] = $aliquot_master_id;
					$aliquot_internal_uses['use_code'] = 'To '.($relase_precision? $relase_precision : '?');
					$aliquot_internal_uses['type'] = 'release';
					$aliquot_internal_uses['use_details'] = $file_comments;	
					$aliquot_internal_uses['used_volume'] = null;
				}
				// Gett additional info
				$file_ischemia_time = str_replace('?', '', $new_line_data['Specimen Accrual::Ischaemia Time']);
				if(!preg_match('/^[0-9]*$/', $file_ischemia_time))die('ERR 38833728 79823 ');
				//Add samples
				switch($file_specimen_type) {
					case 'FFPE - Tumour':
					case 'FFPE - Normal':
					case 'MolFix':
					case 'MolFix - Tumour':
					case 'MolFix - Normal':
					case 'Frozen - Tumour':
					case 'Frozen - Normal':
						$tissue_source = 'other';
						$tissue_laterality = '';
						if(!isset($tissue_matches[strtolower($file_anatomic_location)])) {
							if($file_anatomic_location) Config::$summary_msg['InventoryManagement Specimen']['@@WARNING@@']["Tissue Anatomic Location Unsupported"][] = "Tissue anatomic location [$file_anatomic_location] is not supported. [Worksheet $worksheet_name / line: $excel_line_counter]";
						} else {
							$tissue_source = $tissue_matches[strtolower($file_anatomic_location)]['source'];
							$tissue_laterality = $tissue_matches[strtolower($file_anatomic_location)]['laterality'];
						}
						$tissue_nature = preg_match('/Tumour/', $file_specimen_type)? 'tumour' : (preg_match('/Normal/', $file_specimen_type)? 'normal': '');
						if($tissue_nature != 'tumour' &&  preg_match('/[Tt]umo[u]{0,1]r/',$file_anatomic_location )) {
							Config::$summary_msg['InventoryManagement Specimen']['@@WARNING@@']["Tissue Nature Mismatch"][] = "Tissue nature is defined as $tissue_nature in tissue specimen type but as tumour in anatomic location. [Worksheet $worksheet_name / line: $excel_line_counter]";
						}
						$ovcare_tissue_source_precision = '';
						$aliquot_notes = $file_comments? array($file_comments) : array();
						$sample_notes = '';
						if($file_anatomic_location) {
							if(preg_match('/(.+)\ ([#]{0,1}[0-9])$/', $file_anatomic_location, $matches)) {
								$ovcare_tissue_source_precision = $matches[1];
								$sample_notes = $file_anatomic_location;
							} else {
								$ovcare_tissue_source_precision = $file_anatomic_location;
							}
						}
						$tmp_specimen_key = md5($tissue_source.$file_anatomic_location.$tissue_laterality.$tissue_nature.$file_ischemia_time);
						if(!isset($collection_data['samples'][$tmp_specimen_key])) {
							//Create sample
							$tmp_sample_code++;
							$collection_data['samples'][$tmp_specimen_key] = array(
								'SampleMaster' => array(									
									'sample_code' => 'tmp'.$tmp_sample_code,
									'sample_control_id' => Config::$sample_aliquot_controls['tissue']['sample_control_id'],
									'initial_specimen_sample_type' => 'tissue',
									'notes' => $sample_notes),
								'SpecimenDetail' => array(),
								'SampleDetail' => array(
									'tissue_source' => $tissue_source,
									'ovcare_tissue_source_precision' => $ovcare_tissue_source_precision,
									'tissue_laterality' => $tissue_laterality,
									'ovcare_tissue_type' => $tissue_nature,
									'ovcare_ischemia_time_mn' => $file_ischemia_time),
								'detail_tablename' => Config::$sample_aliquot_controls['tissue']['detail_tablename'],
								'Aliquots' => array(),
								'Derivatives' => array(),
								'SpecimenReviews' => array()
							);
						}	
						//Create aliquot
						$aliquot_type = 'tube';
						$aliquot_details = array();
						if(!preg_match('/^Frozen/', $file_specimen_type)) {
							$aliquot_type = 'block';
							$aliquot_details['block_type'] = 'paraffin';
						}
						if($aliquot_internal_uses && $aliquot_internal_uses['used_volume']) {
							Config::$summary_msg['InventoryManagement Specimen']['@@WARNING@@']['Tissue Volume Released'][] = "A released volume is associated to a tissue. See aliquot $file_aliquot_label. [Worksheet $worksheet_name / line: $excel_line_counter]";
							unset($aliquot_internal_uses['used_volume']);
						}
						$collection_data['samples'][$tmp_specimen_key]['Aliquots'][$aliquot_master_id] = array(
							'AliquotMaster' => array(
								'id' => $aliquot_master_id,
								'barcode' => $aliquot_master_id,
								'aliquot_label' => $file_aliquot_label,
								'aliquot_control_id' => Config::$sample_aliquot_controls['tissue']['aliquots'][$aliquot_type]['aliquot_control_id'],
								'in_stock' => $in_stock,							
								'use_counter' => (empty($aliquot_internal_uses)? '0' : 1),
								'notes' => implode(' || ', $aliquot_notes)),
							'AliquotDetail' => array_merge(array('aliquot_master_id' => $aliquot_master_id), $aliquot_details),
							'detail_tablename' => Config::$sample_aliquot_controls['tissue']['aliquots'][$aliquot_type]['detail_tablename'],					
							'InternalUses' => $aliquot_internal_uses); //aliquot_internal_uses
						//Add specimen Review
						if(isset($specimen_review_from_aliquot_label[$file_aliquot_label])) {
							$patho_reviewer = $specimen_review_from_aliquot_label[$file_aliquot_label]['key2'];
							if($studied_voa_nbr != $specimen_review_from_aliquot_label[$file_aliquot_label]['key1']) die('ERR88339ddsdds938 '.$excel_line_counter);
							if(!isset($specimen_review[$studied_voa_nbr][$patho_reviewer]['AliquotReviews'][$file_aliquot_label])) die('ERR88339ddsdds938 '.$excel_line_counter);
							if(!isset($collection_data['samples'][$tmp_specimen_key]['SpecimenReviews'][$patho_reviewer])) $collection_data['samples'][$tmp_specimen_key]['SpecimenReviews'][$patho_reviewer] = $specimen_review[$studied_voa_nbr][$patho_reviewer];
							$collection_data['samples'][$tmp_specimen_key]['SpecimenReviews'][$patho_reviewer]['AliquotReviews'][$file_aliquot_label]['AliquotReviewMaster']['aliquot_master_id'] = $aliquot_master_id;
							$collection_data['samples'][$tmp_specimen_key]['Aliquots'][$aliquot_master_id]['AliquotMaster']['use_counter']++;
							unset($specimen_review_from_aliquot_label[$file_aliquot_label]);
						}					
						break;

					case 'Cell Block':
					case 'Cryostasis':
						Config::$summary_msg['InventoryManagement Specimen']['@@WARNING@@']["Specimen Type not supported: No aliquot created"][] = "Specimen Type $file_specimen_type is not supported. [Worksheet $worksheet_name / line: $excel_line_counter]";
						break;
	
					case 'Ascites':
						if($file_anatomic_location && $file_anatomic_location != 'Ascites') Config::$summary_msg['InventoryManagement Specimen']['@@ERROR@@']["Specimen Type & Anatomic Location Mismatch"][] = "Specimen Type [$file_specimen_type] and anatomic location [$file_anatomic_location] does not match. [Worksheet $worksheet_name / line: $excel_line_counter]";
						Config::$summary_msg['InventoryManagement Specimen']['@@ERROR@@']["Ascite won't be migrated"][] = "Specimen Type [$file_specimen_type] should be all released. Not be imported. See Note '$file_comments'. [Worksheet $worksheet_name / line: $excel_line_counter]";
						break;
							
					
						// Select structure_alias, model, field from view_structure_formats_simplified where structure_alias IN ('aliquot_masters','ad_spec_tubes', 'ovcare_tissue_tube_storage_method') AND flag_detail = '1';
					
					case 'Frozen - Buffy Coat':
					case 'Frozen - Serum':
					case 'Frozen - Plasma':
						if($file_anatomic_location && $file_anatomic_location != 'Blood') Config::$summary_msg['InventoryManagement Specimen']['@@ERROR@@']["Specimen Type & Anatomic Location Mismatch"][] = "Specimen Type [$file_specimen_type] and anatomic location [$file_anatomic_location] does not match. [Worksheet $worksheet_name / line: $excel_line_counter]";
						$aliquot_notes = $file_comments? array($file_comments) : array();
						$tmp_specimen_key = md5(($file_specimen_type == 'Frozen - Serum'? 'blood1' : 'blood2').$file_ischemia_time);
						if(!isset($collection_data['samples'][$tmp_specimen_key])) {
							//Create sample
							$tmp_sample_code++;
							$collection_data['samples'][$tmp_specimen_key] = array(
								'SampleMaster' => array(
									'sample_code' => 'tmp'.$tmp_sample_code,
									'sample_control_id' => Config::$sample_aliquot_controls['blood']['sample_control_id'],
									'initial_specimen_sample_type' => 'blood'),
								'SpecimenDetail' => array(),
								'SampleDetail' => array(
									'ovcare_ischemia_time_mn' => $file_ischemia_time),
								'detail_tablename' => Config::$sample_aliquot_controls['blood']['detail_tablename'],
								'Aliquots' => array(),
								'Derivatives' => array()
							);
						}
						$derivative_type = str_replace(array('Frozen - Serum', 'Frozen - Buffy Coat','Frozen - Plasma'), array('serum', 'blood cell', 'plasma'), $file_specimen_type);
						if(!isset($collection_data['samples'][$tmp_specimen_key]['Derivatives'][$derivative_type] )) {
							$tmp_sample_code++;
							$collection_data['samples'][$tmp_specimen_key]['Derivatives'][$derivative_type] = array(
								'SampleMaster' => array(
									'sample_code' => 'tmp'.$tmp_sample_code,
									'sample_control_id' => Config::$sample_aliquot_controls[$derivative_type]['sample_control_id'],
									'initial_specimen_sample_type' => 'blood',
									'parent_sample_type' => 'blood'),
								'DerivativeDetail' => array(),
								'SampleDetail' => array(),
								'detail_tablename' => Config::$sample_aliquot_controls[$derivative_type]['detail_tablename'],
								'Aliquots' => array()
							);
						}
						//Create aliquot			
						$aliquot_type = 'tube';					
						$collection_data['samples'][$tmp_specimen_key]['Derivatives'][$derivative_type]['Aliquots'][$aliquot_master_id] = array(
							'AliquotMaster' => array(
								'id' => $aliquot_master_id,
								'barcode' => $aliquot_master_id,
								'aliquot_label' => $file_aliquot_label,
								'aliquot_control_id' => Config::$sample_aliquot_controls[$derivative_type]['aliquots']['tube']['aliquot_control_id'],
								'in_stock' => $in_stock,
								'use_counter' => (empty($aliquot_internal_uses)? '0' : 1),
								'notes' => implode(' || ', $aliquot_notes)),
							'AliquotDetail' => array('aliquot_master_id' => $aliquot_master_id),
							'detail_tablename' => Config::$sample_aliquot_controls[$derivative_type]['aliquots']['tube']['detail_tablename'],
							'InternalUses' => $aliquot_internal_uses); //aliquot_internal_uses
						break;
						
					case 'Frozen - Saliva':
						if($file_anatomic_location && $file_anatomic_location != 'Saliva') Config::$summary_msg['InventoryManagement Specimen']['@@ERROR@@']["Specimen Type & Anatomic Location Mismatch"][] = "Specimen Type [$file_specimen_type] and anatomic location [$file_anatomic_location] does not match. [Worksheet $worksheet_name / line: $excel_line_counter]";
						$aliquot_notes = $file_comments? array($file_comments) : array();
						$tmp_specimen_key = md5('Saliva'.$file_ischemia_time);
						if(!isset($collection_data['samples'][$tmp_specimen_key])) {
							//Create sample
							$tmp_sample_code++;
							$collection_data['samples'][$tmp_specimen_key] = array(
								'SampleMaster' => array(
									'sample_code' => 'tmp'.$tmp_sample_code,
									'sample_control_id' => Config::$sample_aliquot_controls['saliva']['sample_control_id'],
									'initial_specimen_sample_type' => 'saliva'),
								'SpecimenDetail' => array(),
								'SampleDetail' => array(
									'ovcare_ischemia_time_mn' => $file_ischemia_time),
								'detail_tablename' => Config::$sample_aliquot_controls['saliva']['detail_tablename'],
								'Aliquots' => array(),
								'Derivatives' => array());
						}
						//Create aliquot
						$aliquot_type = 'tube';
						$collection_data['samples'][$tmp_specimen_key]['Aliquots'][$aliquot_master_id] = array(
							'AliquotMaster' => array(
								'id' => $aliquot_master_id,
								'barcode' => $aliquot_master_id,
								'aliquot_label' => $file_aliquot_label,
								'aliquot_control_id' => Config::$sample_aliquot_controls['saliva']['aliquots']['tube']['aliquot_control_id'],
								'in_stock' => $in_stock,
								'use_counter' => (empty($aliquot_internal_uses)? '0' : 1),
								'notes' => implode(' || ', $aliquot_notes)),
							'AliquotDetail' => array('aliquot_master_id' => $aliquot_master_id),
							'detail_tablename' => Config::$sample_aliquot_controls['saliva']['aliquots']['tube']['detail_tablename'],
							'InternalUses' => $aliquot_internal_uses); //aliquot_internal_uses
						break;
	
				default:
						die('ERR 34837227368268232 '.$file_specimen_type);				
				}
			} else {		
				//NO SPECIMEN TYPE => Not imported
				if($file_comments) $collection_data['notes'][] = $file_comments;
				if($new_line_data['Specimen Accrual::Sample Identifier']) {
					Config::$summary_msg['InventoryManagement Specimen']['@@WARNING@@']["No Specimen Type but a Sample Identifier exists: No aliquot created"][] = "See aliquot '".$new_line_data['Specimen Accrual::Sample Identifier']."'. [Worksheet $worksheet_name / line: $excel_line_counter]";
				}
				if($file_anatomic_location) {
					Config::$summary_msg['InventoryManagement Specimen']['@@WARNING@@']["No Specimen Type but a Sample Anatomic Location: No aliquot created"][] = "$file_anatomic_location... [Worksheet $worksheet_name / line: $excel_line_counter]";
				}
			}
		}
	}
	
	// add migration summaries / results
	foreach($specimen_review_from_aliquot_label as $aliquot_label => $data) Config::$summary_msg['InventoryManagement Specimen']['@@WARNING@@']['Specimen Quality Control Un-migrated'][] = 'see Sample Indentifier'.$aliquot_label;
	foreach($released_aliquots as $voa_nbr => $data1) {
		foreach($data1 as $aliquot_label => $data2) Config::$summary_msg['InventoryManagement Specimen']['@@WARNING@@']['Specimen Release Un-migrated'][] = 'see Sample Indentifier'.$aliquot_label;
	}
	foreach($comments_used_to_define_released_aliquots as $comment => $lines)
		Config::$summary_msg['InventoryManagement Specimen']['@@MESSAGE@@']['Specimen defined as realeased based on comment'][] = "... associated comment '$comment'. See lines ".implode(', ', $lines);
	foreach($comments_used_to_define_not_banked_aliquots as $comment => $lines)
		Config::$summary_msg['InventoryManagement Specimen']['@@MESSAGE@@']['Specimen defined as not banked based on comment'][] = "... associated comment '$comment'. See lines ".implode(', ', $lines);
	
	return;
}	
	
function recordCollection($collection_data, $voa) {
	if(!isset(Config::$voas_to_ids[$voa])) die('ERR 4747387432');
	$collection_id = Config::$voas_to_ids[$voa]['collection_id'];

	//Add collection notes
	if($collection_data['notes']) {
		$query = "UPDATE collections SET collection_notes = '".str_replace("'", "''", implode(' || ', $collection_data['notes']))."' WHERE id = $collection_id;";
		mysqli_query(Config::$db_connection, $query) or die("record [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		mysqli_query(Config::$db_connection, str_replace('collections','collections_revs',$query)) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	}
	
	if(empty($collection_data['samples'])) {
		Config::$summary_msg['InventoryManagement Specimen']['@@WARNING@@']['Empty collection (no sample created)'][] = "Collection note will be copied to participant notes. See VOA# ".$voa;
		return;
	}
	
	//Add samples
	foreach($collection_data['samples'] as $new_specimen_and_derivatives) {	
		//New specimen		
		$specimen_sample_master_id = customInsertRecord(array_merge($new_specimen_and_derivatives['SampleMaster'], array('collection_id' => $collection_id)), 'sample_masters');
		customInsertRecord(array_merge($new_specimen_and_derivatives['SampleDetail'], array('sample_master_id' => $specimen_sample_master_id)), $new_specimen_and_derivatives['detail_tablename'], true);
		customInsertRecord(array_merge($new_specimen_and_derivatives['SpecimenDetail'], array('sample_master_id' => $specimen_sample_master_id)), 'specimen_details', true);
		recordAliquots($new_specimen_and_derivatives['Aliquots'], $collection_id, $specimen_sample_master_id);
		//Specimen Review
		if(isset($new_specimen_and_derivatives['SpecimenReviews'])) {		
			foreach($new_specimen_and_derivatives['SpecimenReviews'] as $specimen_review) {
				$specimen_review_master_id = customInsertRecord(array_merge($specimen_review['SpecimenReviewMaster'], array('collection_id' => $collection_id, 'sample_master_id' => $specimen_sample_master_id)), 'specimen_review_masters');
				customInsertRecord(array_merge($specimen_review['SpecimenReviewDetail'], array('specimen_review_master_id' => $specimen_review_master_id)), $specimen_review['specimen_review_detail_tablename'], true);
				foreach($specimen_review['AliquotReviews'] as $aliquot_review) {
					$aliquot_review_master_id = customInsertRecord(array_merge($aliquot_review['AliquotReviewMaster'], array('specimen_review_master_id' => $specimen_review_master_id)), 'aliquot_review_masters');
					customInsertRecord(array_merge($aliquot_review['AliquotReviewDetail'], array('aliquot_review_master_id' => $aliquot_review_master_id)), $aliquot_review['aliquot_review_detail_tablename'], true);
				}
			}
		}
		//Derivatives
		foreach($new_specimen_and_derivatives['Derivatives'] as $new_derivative) {
			$derivative_sample_master_id = customInsertRecord(array_merge($new_derivative['SampleMaster'], array('collection_id' => $collection_id, 'parent_id' => $specimen_sample_master_id, 'initial_specimen_sample_id' => $specimen_sample_master_id)), 'sample_masters');
			customInsertRecord(array_merge($new_derivative['SampleDetail'], array('sample_master_id' => $derivative_sample_master_id)), $new_derivative['detail_tablename'], true);
			customInsertRecord(array_merge($new_derivative['DerivativeDetail'], array('sample_master_id' => $derivative_sample_master_id)), 'derivative_details', true);
			recordAliquots($new_derivative['Aliquots'], $collection_id, $derivative_sample_master_id);
		}
	}
}

function recordAliquots($aliquots, $collection_id, $sample_master_id) {
	foreach($aliquots as $new_aliquot) {
		$aliquot_master_id = $new_aliquot['AliquotMaster']['id'];
		$aliquot_master_id = customInsertRecord(array_merge($new_aliquot['AliquotMaster'], array('collection_id' => $collection_id, 'sample_master_id' => $sample_master_id)), 'aliquot_masters', false);
		customInsertRecord(array_merge($new_aliquot['AliquotDetail'], array('aliquot_master_id' => $aliquot_master_id)), $new_aliquot['detail_tablename'], true);
		if(!empty($new_aliquot['InternalUses'])) {
			customInsertRecord($new_aliquot['InternalUses'], 'aliquot_internal_uses');
		}
	}
}

?>