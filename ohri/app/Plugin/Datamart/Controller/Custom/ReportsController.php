<?php

class ReportsControllerCustom extends ReportsController
{

    public function terryFox(array $parameters)
    {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        
        global $tfriReportAllowedValues;
        global $tfriReportWarnings;
        global $newLine;
        
        $newLine = "\n";
        
        $notExportedField = '## Not Exported ##';
        
        $tfriReportWarnings = array();
        $tfriReportAllowedValues = array();
        // Sheet 1
        $tfriReportAllowedValues['vital_status'] = array(
            'alive',
            'dead',
            'unknown',
            'deceased'
        );
        $tfriReportAllowedValues['fam_history'] = array(
            'breast cancer',
            'colon and breast cancer',
            'colon and endometrial cancer',
            'colon cancer',
            'endometrial cancer',
            'no',
            'ovarian and breast cancer',
            'ovarian and colon cancer',
            'ovarian and endometrial cancer',
            'ovarian cancer',
            'precursor of benign ovarian lesions',
            'unknown',
            'ovarian, endometrial and colon cancer'
        );
        $tfriReportAllowedValues['brca_status'] = array(
            'BRCA mutation known but not identified',
            'BRCA1 mutated',
            'BRCA1/2 mutated',
            'BRCA2 mutated',
            'unknown',
            'wild type'
        );
        // Sheet 2 & 4
        $tfriReportAllowedValues['laterality'] = array(
            'bilateral',
            'left',
            'right',
            'unknown',
            'not applicable'
        );
        $tfriReportAllowedValues['histopathology'] = array(
            'high grade serous',
            'low grade serous',
            'mucinous',
            'clear cells',
            'endometrioid',
            'mixed',
            'undifferentiated',
            'serous',
            'other',
            'unknown',
            'non applicable'
        );
        $tfriReportAllowedValues['grade'] = array(
            '0',
            '1',
            '2',
            '3'
        );
        $tfriReportAllowedValues['residual_disease'] = array(
            '1-2cm',
            '<1cm',
            '>2cm',
            'miliary',
            'none',
            'unknown',
            'suboptimal',
            'yes unknown'
        );
        $tfriReportAllowedValues['stage'] = array(
            'Ia',
            'Ib',
            'Ic',
            'IIa',
            'IIb',
            'IIc',
            'IIIa',
            'IIIb',
            'IIIc',
            'IV',
            'unknown',
            'III'
        );
        $tfriReportAllowedValues['fallopian_tube_lesions'] = array(
            'benign tumors',
            'malignant tumors',
            'no',
            'salpingitis',
            'unknown',
            'yes'
        );
        $tfriReportAllowedValues['benign_lesions'] = array(
            'benign or borderline tumours',
            'endometriosis',
            'endosalpingiosis',
            'no',
            'ovarian cysts',
            'unknown'
        );
        $tfriReportAllowedValues['progression_status'] = array(
            'yes',
            'progressive disease',
            'bouncer',
            'no',
            'unknown'
        );
        $tfriReportAllowedValues['tumor_site'] = array(
            'Breast-Breast',
            'Central Nervous System-Brain',
            'Central Nervous System-Other Central Nervous System',
            'Central Nervous System-Spinal Cord',
            'Digestive-Anal',
            'Digestive-Appendix',
            'Digestive-Bile Ducts',
            'Digestive-Colonic',
            'Digestive-Esophageal',
            'Digestive-Gallbladder',
            'Digestive-Liver',
            'Digestive-Other Digestive',
            'Digestive-Pancreas',
            'Digestive-Rectal',
            'Digestive-Small Intestine',
            'Digestive-Stomach',
            'Female Genital-Cervical',
            'Female Genital-Endometrium',
            'Female Genital-Fallopian Tube',
            'Female Genital-Gestational Trophoblastic Neoplasia',
            'Female Genital-Other Female Genital',
            'Female Genital-Ovary',
            'Female Genital-Peritoneal Pelvis Abdomen',
            'Female Genital-Uterine',
            'Female Genital-Vagina',
            'Female Genital-Vulva',
            "Haematological-Hodgkin's Disease",
            'Haematological-Leukemia',
            'Haematological-Lymphoma',
            "Haematological-Non-Hodgkin's Lymphomas",
            'Haematological-Other Haematological',
            'Head & Neck-Larynx',
            'Head & Neck-Lip and Oral Cavity',
            'Head & Neck-Nasal Cavity and Sinuses',
            'Head & Neck-Other Head & Neck',
            'Head & Neck-Pharynx',
            'Head & Neck-Salivary Glands',
            'Head & Neck-Thyroid',
            'Musculoskeletal Sites-Bone',
            'Musculoskeletal Sites-Other Bone',
            'Musculoskeletal Sites-Soft Tissue Sarcoma',
            'Ophthalmic-Eye',
            'Ophthalmic-Other Eye',
            'Other-Gross Metastatic Disease',
            'Other-Primary Unknown',
            'Skin-Melanoma',
            'Skin-Non Melanomas',
            'Skin-Other Skin',
            'Thoracic-Lung',
            'Thoracic-Mesothelioma',
            'Thoracic-Other Thoracic',
            'Urinary Tract-Bladder',
            'Urinary Tract-Kidney',
            'Urinary Tract-Other Urinary Tract',
            'Urinary Tract-Renal Pelvis and Ureter',
            'Urinary Tract-Urethra',
            'not applicable',
            'unknown',
            'ascite'
        );
        // Sheet 3 & 5
        $tfriReportAllowedValues['ct_scan'] = array(
            'negative',
            'positive',
            'unknown'
        );
        $tfriReportAllowedValues['drugs'] = array(
            'cisplatinum',
            'carboplatinum',
            'oxaliplatinum',
            'paclitaxel',
            'topotecan',
            'ectoposide',
            'tamoxifen',
            'doxetaxel',
            'doxorubicin',
            'other',
            'etoposide',
            'gemcitabine',
            'procytox',
            'vinorelbine',
            'cyclophosphamide'
        );
        
        $bankNbrs = array();
        $participantIds = array();
        
        if (array_key_exists('participant_identifier_with_file_upload', $parameters['Participant']) && ! empty($parameters['Participant']['participant_identifier_with_file_upload']['tmp_name'])) {
            // set $DATA array based on contents of uploaded FILE
            $handle = fopen($parameters['Participant']['participant_identifier_with_file_upload']['tmp_name'], "r");
            while (($csvData = fgetcsv($handle, 1000, csv_separator, '"')) !== false) {
                $bankNbrs[] = $csvData[0];
            }
            fclose($handle);
            unset($parameters['Participant']['participant_identifier_with_file_upload']);
        } elseif (array_key_exists('participant_identifier_start', $parameters['Participant'])) {
            // Range
            for ($newBankNbr = $parameters['Participant']['participant_identifier_start']; $newBankNbr <= $parameters['Participant']['participant_identifier_end']; $newBankNbr ++)
                $bankNbrs[] = $newBankNbr;
        } elseif (array_key_exists('participant_identifier', $parameters['Participant'])) {
            $bankNbrs = $parameters['Participant']['participant_identifier'];
        } elseif (array_key_exists('id', $parameters['Participant'])) {
            $participantIds = $parameters['Participant']['id'];
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get participant
        
        $this->Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        $conditions = array();
        if ($participantIds)
            $conditions['Participant.id'] = $participantIds;
        if ($bankNbrs)
            $conditions['Participant.participant_identifier'] = $bankNbrs;
        $participantData = $this->Participant->find('all', array(
            'conditions' => $conditions,
            'order' => array(
                'Participant.id ASC'
            )
        ));
        
        if (empty($participantData)) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => 'terry_fox_report_no_participant'
            );
        } elseif (sizeof($participantData) > 300) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => 'terry_fox_report_too_many_participants'
            );
        }
        
        // terry_fox_export_description
        
        $pidBidAssoc = array();
        $participantIds = array();
        
        if (true) {
            header("Content-Type: application/force-download");
            header("Content-Type: application/octet-stream");
            header("Content-Type: application/download");
            header("Content-Type: text/csv");
            header("Content-disposition:attachment;filename=terry_fox_" . date('YMd_Hi') . '.csv');
        } else {
            $newLine = '<br>';
        }
        
        // *********************************************** SHEET 1 - Patients ***********************************************
        
        {
            $sheet = "SHEET 1 - Patients";
            echo $sheet . "$newLine";
            
            $titleRow = array(
                "Bank",
                "Patient Biobank Number (required & unique)",
                "Date of Birth Date",
                "Date of Birth date accuracy",
                "Death Death",
                "Registered Date of Death Date",
                "Registered Date of Death date accuracy",
                "Suspected Date of Death Date",
                "Suspected Date of Death date accuracy",
                "Date of Last Contact Date",
                "Date of Last Contact date accuracy",
                "family history",
                "BRCA status",
                "notes"
            );
            
            echo implode(csv_separator, $titleRow), "$newLine";
            
            foreach ($participantData as $unit) {
                $participantId = $unit['Participant']['id'];
                $pidBidAssoc[$participantId] = $unit['Participant']['participant_identifier'];
                $participantIds[] = $participantId;
                
                // last_contact_date
                
                $lastContactData = $this->Report->query("SELECT last_contact_date, last_contact_date_accuracy FROM 
					(
						SELECT consent_signed_date AS last_contact_date, consent_signed_date_accuracy AS last_contact_date_accuracy 
						FROM consent_masters WHERE participant_id=" . $participantId . " AND deleted != 1
					UNION
						SELECT start_date AS last_contact_date, start_date_accuracy AS last_contact_date_accuracy 
						FROM treatment_masters WHERE participant_id=" . $participantId . " AND deleted != 1
					UNION
						SELECT dx_date AS last_contact_date, dx_date_accuracy AS last_contact_date_accuracy 
						FROM diagnosis_masters WHERE participant_id=" . $participantId . " AND deleted != 1
					UNION
						SELECT event_date AS last_contact_date, event_date_accuracy AS last_contact_date_accuracy  
						FROM event_masters WHERE participant_id=" . $participantId . " AND deleted != 1
					) AS tmp ORDER BY last_contact_date DESC LIMIT 0, 1;", false);
                $lastContactDate = '';
                $lastContactDateAccuracy = '';
                if (! empty($lastContactData)) {
                    $lastContactDate = $lastContactData[0]['tmp']['last_contact_date'];
                    $lastContactDateAccuracy = empty($lastContactData[0]['tmp']['last_contact_date_accuracy']) ? 'c' : $lastContactData[0]['tmp']['last_contact_date_accuracy'];
                }
                
                // family_history
                
                $famHistoryData = $this->Report->query("SELECT ohri_disease_site FROM family_histories AS FamilyHistory WHERE deleted != 1 AND participant_id=" . $participantId, false);
                $famHistoryDataCount = array_fill_keys(array(
                    'other',
                    'breast',
                    'ovary'
                ), 0);
                foreach ($famHistoryData as $ohriDiseaseSite) {
                    $famHistoryDataCount[$ohriDiseaseSite['FamilyHistory']['ohri_disease_site']] ++;
                }
                $familyHistory = null;
                if ($famHistoryDataCount['ovary'] > 0 && $famHistoryDataCount['breast'] > 0) {
                    $familyHistory = 'ovarian and breast cancer';
                } elseif ($famHistoryDataCount['ovary'] > 0) {
                    $familyHistory = 'ovarian cancer';
                } elseif ($famHistoryDataCount['breast'] > 0) {
                    $familyHistory = 'breast cancer';
                } elseif ($famHistoryDataCount['other'] > 0) {
                    $familyHistory = 'unknown';
                } else {
                    $familyHistory = "";
                }
                
                $brcaData = $this->Report->query("SELECT brca FROM ohri_ed_lab_markers AS EventDetail
						INNER JOIN event_masters ON EventDetail.event_master_id=event_masters.id
						WHERE event_masters.participant_id=" . $participantId . " AND event_masters.deleted != 1
						ORDER BY event_masters.event_date DESC");
                $brcaValue = isset($brcaData[0]['EventDetail']['brca']) ? $brcaData[0]['EventDetail']['brca'] : "";
                
                $this->validateTfriReportValue($unit['Participant']['vital_status'], 'vital_status', "Death Death", $sheet, $pidBidAssoc[$participantId]);
                $this->validateTfriReportValue($familyHistory, 'fam_history', "family history", $sheet, $pidBidAssoc[$participantId]);
                $this->validateTfriReportValue($brcaValue, 'brca_status', "BRCA status", $sheet, $pidBidAssoc[$participantId]);
                
                $line = array();
                $line[] = "OHRI-COEUR";
                $line[] = $unit['Participant']['participant_identifier'];
                $line[] = $unit['Participant']['date_of_birth'];
                $line[] = (! empty($unit['Participant']['date_of_birth']) ? $unit['Participant']['date_of_birth_accuracy'] : '');
                $line[] = $unit['Participant']['vital_status'];
                $line[] = $unit['Participant']['date_of_death'];
                $line[] = (! empty($unit['Participant']['date_of_death']) ? $unit['Participant']['date_of_death_accuracy'] : '');
                $line[] = $notExportedField; // suspected dod : Won't be accessible
                $line[] = $notExportedField; // Suspected Date of Death date accuracy : Won't be accessible
                $line[] = "$lastContactDate";
                $line[] = "$lastContactDateAccuracy";
                $line[] = $familyHistory;
                $line[] = $brcaValue;
                $line[] = $notExportedField; // notes
                
                echo implode(csv_separator, $line), "$newLine";
            }
            unset($participantData);
            
            if (! empty($bankNbrs) && sizeof($bankNbrs) != sizeof($participantIds)) {
                foreach ($bankNbrs as $newBankNbr) {
                    if ($newBankNbr && ! in_array($newBankNbr, $pidBidAssoc))
                        $tfriReportWarnings[$sheet]["Not all Bank# submitted match a participant of your bank"][$newBankNbr] = $newBankNbr;
                }
            }
            
            $this->displayTfriReportWarning($sheet);
            echo "$newLine";
        }
        
        // *********************************************** SHEET 2 - EOC - Diagnosis ***********************************************
        
        {
            $sheet = 'SHEET 2 - EOC - Diagnosis';
            echo "$newLine$newLine$sheet$newLine";
            
            $titleRow = array(
                "Patient Biobank Number (required)",
                "Date of EOC Diagnosis Date",
                "Date of EOC Diagnosis Accuracy",
                "Presence of precursor of benign lesions",
                "fallopian tube lesions",
                "Age at Time of Diagnosis (yr)",
                "Laterality",
                "Histopathology",
                "Grade",
                "FIGO ",
                "Residual Disease",
                "Progression status",
                "Date of Progression/Recurrence Date",
                "Date of Progression/Recurrence Accuracy",
                "Site 1 of Primary Tumor Progression (metastasis)  If Applicable",
                "Site 2 of Primary Tumor Progression (metastasis)  If applicable",
                "progression time (months)",
                "Date of Progression of CA125 Date",
                "Date of Progression of CA125 Accuracy",
                "CA125 progression time (months)",
                "Follow-up from ovarectomy (months)",
                "Survival from diagnosis (months)"
            );
            
            echo implode(csv_separator, $titleRow), "$newLine";
            
            $allEocPrimAndSecDxMstIds = array(
                '-1'
            );
            $allEocDxMstIdFromParticipantId = array();
            
            $data = $this->Report->query("
				SELECT * 
				FROM diagnosis_masters AS DiagnosisMaster
				INNER JOIN ohri_dx_ovaries AS DiagnosisDetail ON DiagnosisMaster.id=DiagnosisDetail.diagnosis_master_id
				INNER JOIN diagnosis_controls AS DiagnosisControl ON DiagnosisControl.id = DiagnosisMaster.diagnosis_control_id
				WHERE DiagnosisMaster.deleted != 1 AND DiagnosisControl.controls_type = 'ovary'
				AND DiagnosisMaster.participant_id IN(" . implode(", ", $participantIds) . ")
				ORDER BY DiagnosisMaster.participant_id ASC");
            foreach ($data as $unit) {
                if ($unit['DiagnosisControl']['category'] != 'primary') {
                    $tfriReportWarnings[$sheet]["EOC defined as secondary: not imported"][$pidBidAssoc[$participantId]] = $pidBidAssoc[$participantId];
                } elseif (isset($allEocDxMstIdFromParticipantId[$unit['DiagnosisMaster']['participant_id']])) {
                    $tfriReportWarnings[$sheet]["EOC primary defined twice: second one not imported"][$pidBidAssoc[$participantId]] = $pidBidAssoc[$participantId];
                } else {
                    $participantId = $unit['DiagnosisMaster']['participant_id'];
                    $eocDiagnosisMasterId = $unit['DiagnosisMaster']['id'];
                    $primAndSecDxMstIdsOfStudiedEoc = array();
                    
                    $allEocPrimAndSecDxMstIds[] = $eocDiagnosisMasterId;
                    $allEocDxMstIdFromParticipantId[$participantId] = $eocDiagnosisMasterId;
                    $primAndSecDxMstIdsOfStudiedEoc[] = $eocDiagnosisMasterId;
                    
                    // Get secondary then progression
                    $secondaryData = $this->Report->query("SELECT * FROM diagnosis_masters AS DiagnosisMaster
						WHERE DiagnosisMaster.deleted=0 AND DiagnosisMaster.primary_id != DiagnosisMaster.id
						AND DiagnosisMaster.primary_id = $eocDiagnosisMasterId
						ORDER BY DiagnosisMaster.dx_date ASC");
                    $secondaryTumors = array();
                    foreach ($secondaryData as $newSecondary) {
                        $primAndSecDxMstIdsOfStudiedEoc[] = $newSecondary['DiagnosisMaster']['id'];
                        $allEocPrimAndSecDxMstIds[] = $newSecondary['DiagnosisMaster']['id'];
                        $key = $newSecondary['DiagnosisMaster']['dx_date'] . '#' . (empty($newSecondary['DiagnosisMaster']['dx_date']) ? '' : (empty($newSecondary['DiagnosisMaster']['dx_date_accuracy']) ? 'c' : $newSecondary['DiagnosisMaster']['dx_date_accuracy']));
                        $secondaryTumors[$key][] = $newSecondary['DiagnosisMaster']['ohri_tumor_site'];
                    }
                    $progressionDate = '';
                    $progressionDateAcc = '';
                    $progressionSite1 = '';
                    $progressionSite2 = '';
                    if (! empty($secondaryTumors)) {
                        $dateAndAccKey = key($secondaryTumors);
                        $keyData = explode('#', $dateAndAccKey);
                        $progressionDate = $keyData[0];
                        $progressionDateAcc = $keyData[1];
                        $progressionSite1 = array_shift($secondaryTumors[$dateAndAccKey]);
                        $progressionSite2 = array_shift($secondaryTumors[$dateAndAccKey]);
                        if (empty($secondaryTumors[$dateAndAccKey]))
                            unset($secondaryTumors[$dateAndAccKey]);
                    }
                    
                    // Get residual disease
                    $residualDisease = '';
                    $txData = $this->Report->query("SELECT residual_disease 
						FROM ohri_txd_surgeries AS TreatmentDetail
						INNER JOIN treatment_masters ON TreatmentDetail.treatment_master_id=treatment_masters.id
						WHERE treatment_masters.deleted = 0 
						AND TreatmentDetail.description = 'ovarectomy'
						AND treatment_masters.diagnosis_master_id IN (" . implode(',', $primAndSecDxMstIdsOfStudiedEoc) . ")", false);
                    if (count($txData) == 1) {
                        $residualDisease = $txData[0]['TreatmentDetail']['residual_disease'];
                    } elseif (count($txData) > 1) {
                        $tfriReportWarnings[$sheet]["Too many ovarectomies to define the residual disease value: data not imported"][$pidBidAssoc[$participantId]] = $pidBidAssoc[$participantId];
                    }
                    $residualDisease = str_replace(array(
                        '< 1cm',
                        '> 2cm',
                        'undefined'
                    ), array(
                        '<1cm',
                        '>2cm',
                        'none',
                        'unknown'
                    ), $residualDisease);
                    
                    // Get ca125 progression
                    $ca125Data = $this->Report->query("
						SELECT * FROM event_masters AS EventMaster
						INNER JOIN ohri_ed_lab_chemistries AS EventDetail ON EventDetail.event_master_id=EventMaster.id
						INNER JOIN event_controls AS EventControl ON EventControl.id = EventMaster.event_control_id
						WHERE EventMaster.deleted=0 AND EventControl.event_type = 'chemistry' AND EventControl.flag_active = 1
						AND EventDetail.ca125_progression = 'y'
						AND EventMaster.diagnosis_master_id IN(" . implode(", ", $primAndSecDxMstIdsOfStudiedEoc) . ")
						ORDER BY EventMaster.participant_id ASC, EventMaster.event_date ASC", false);
                    $ca125Progressions = array();
                    foreach ($ca125Data as $newCa125Progression) {
                        $key = $newCa125Progression['EventMaster']['event_date'] . '#' . (empty($newCa125Progression['EventMaster']['event_date']) ? '' : (empty($newCa125Progression['EventMaster']['event_date_accuracy']) ? 'c' : $newCa125Progression['EventMaster']['event_date_accuracy']));
                        $ca125Progressions[$key] = '';
                    }
                    $ca125ProgressionDate = '';
                    $ca125ProgressionDateAcc = '';
                    if (! empty($ca125Progressions)) {
                        $dateAndAccKey = key($ca125Progressions);
                        $keyData = explode('#', $dateAndAccKey);
                        $ca125ProgressionDate = $keyData[0];
                        $ca125ProgressionDateAcc = $keyData[1];
                        unset($ca125Progressions[$dateAndAccKey]);
                    }
                    
                    // Records first diagnosis line data
                    $this->validateTfriReportValue($unit['DiagnosisDetail']['laterality'], 'laterality', "Laterality", $sheet, $pidBidAssoc[$participantId]);
                    $this->validateTfriReportValue($unit['DiagnosisDetail']['histopathology'], 'histopathology', "Histopathology", $sheet, $pidBidAssoc[$participantId]);
                    $this->validateTfriReportValue($unit['DiagnosisMaster']['tumour_grade'], 'grade', "Grade", $sheet, $pidBidAssoc[$participantId]);
                    $this->validateTfriReportValue($unit['DiagnosisDetail']['figo'], 'stage', "FIGO", $sheet, $pidBidAssoc[$participantId]);
                    $this->validateTfriReportValue($residualDisease, 'residual_disease', "Residual Disease", $sheet, $pidBidAssoc[$participantId]);
                    $this->validateTfriReportValue($progressionSite1, 'tumor_site', "Site 1 of Primary Tumor Progression (metastasis)  If Applicable", $sheet, $pidBidAssoc[$participantId]);
                    $this->validateTfriReportValue($progressionSite2, 'tumor_site', "Site 2 of Primary Tumor Progression (metastasis)  If applicable", $sheet, $pidBidAssoc[$participantId]);
                    $this->validateTfriReportValue($unit['DiagnosisDetail']['fallopian_tube_lesions'], 'fallopian_tube_lesions', "Fallopian tube lesions", $sheet, $pidBidAssoc[$participantId]);
                    $this->validateTfriReportValue($unit['DiagnosisDetail']['precursor_of_benign_lesions'], 'benign_lesions', "Presence of precursor of benign lesions", $sheet, $pidBidAssoc[$participantId]);
                    $this->validateTfriReportValue($unit['DiagnosisDetail']['progression_status'], 'progression_status', "Progression status", $sheet, $pidBidAssoc[$participantId]);
                    
                    $line = array();
                    $line[] = $pidBidAssoc[$participantId];
                    $line[] = $unit['DiagnosisMaster']['dx_date'];
                    $line[] = (! empty($unit['DiagnosisMaster']['dx_date']) ? (empty($unit['DiagnosisMaster']['dx_date_accuracy']) ? 'c' : $unit['DiagnosisMaster']['dx_date_accuracy']) : '');
                    $line[] = $unit['DiagnosisDetail']['precursor_of_benign_lesions'];
                    $line[] = $unit['DiagnosisDetail']['fallopian_tube_lesions'];
                    $line[] = $unit['DiagnosisMaster']['age_at_dx'];
                    $line[] = $unit['DiagnosisDetail']['laterality'];
                    $line[] = $unit['DiagnosisDetail']['histopathology'];
                    $line[] = $unit['DiagnosisMaster']['tumour_grade'];
                    $line[] = $unit['DiagnosisDetail']['figo'];
                    $line[] = $residualDisease;
                    $line[] = $unit['DiagnosisDetail']['progression_status'];
                    $line[] = $progressionDate;
                    $line[] = (! empty($progressionDate) ? $progressionDateAcc : '');
                    $line[] = $progressionSite1;
                    $line[] = $progressionSite2;
                    $line[] = $notExportedField; // progression time (months) : Will be calculated by ctrnet import process
                    $line[] = $ca125ProgressionDate;
                    $line[] = $ca125ProgressionDateAcc;
                    $line[] = $notExportedField; // CA125 progression time (months) : Will be calculated by ctrnet import process
                    $line[] = $notExportedField; // Follow-up from ovarectomy (months) : Will be calculated by ctrnet import process
                    $line[] = $unit['DiagnosisMaster']['survival_time_months'];
                    
                    echo implode(csv_separator, $line), "$newLine";
                    
                    // Records other progressions
                    while (! empty($secondaryTumors)) {
                        reset($secondaryTumors);
                        $dateAndAccKey = key($secondaryTumors);
                        $keyData = explode('#', $dateAndAccKey);
                        
                        $progressionDate = $keyData[0];
                        $progressionDateAcc = $keyData[1];
                        $progressionSite1 = array_shift($secondaryTumors[$dateAndAccKey]);
                        $progressionSite2 = array_shift($secondaryTumors[$dateAndAccKey]);
                        
                        if (empty($secondaryTumors[$dateAndAccKey]))
                            unset($secondaryTumors[$dateAndAccKey]);
                        
                        $this->validateTfriReportValue($progressionSite1, 'tumor_site', "Site 1 of Primary Tumor Progression (metastasis)  If Applicable", $sheet, $pidBidAssoc[$participantId]);
                        $this->validateTfriReportValue($progressionSite2, 'tumor_site', "Site 2 of Primary Tumor Progression (metastasis)  If applicable", $sheet, $pidBidAssoc[$participantId]);
                        
                        $line = array();
                        $line[] = $pidBidAssoc[$participantId];
                        $line[] = $unit['DiagnosisMaster']['dx_date'];
                        $line[] = (! empty($unit['DiagnosisMaster']['dx_date']) ? $unit['DiagnosisMaster']['dx_date_accuracy'] : '');
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = $progressionDate;
                        $line[] = (! empty($progressionDate) ? $progressionDateAcc : '');
                        $line[] = $progressionSite1;
                        $line[] = $progressionSite2;
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        
                        echo implode(csv_separator, $line), "$newLine";
                    }
                    
                    // Records other ca125 progressions
                    while (! empty($ca125Progressions)) {
                        reset($ca125Progressions);
                        $dateAndAccKey = key($ca125Progressions);
                        $keyData = explode('#', $dateAndAccKey);
                        
                        $ca125ProgressionDate = $keyData[0];
                        $ca125ProgressionDateAcc = $keyData[1];
                        
                        unset($ca125Progressions[$dateAndAccKey]);
                        
                        $line = array();
                        $line[] = $pidBidAssoc[$participantId];
                        $line[] = $unit['DiagnosisMaster']['dx_date'];
                        $line[] = (! empty($unit['DiagnosisMaster']['dx_date']) ? $unit['DiagnosisMaster']['dx_date_accuracy'] : '');
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        $line[] = $ca125ProgressionDate;
                        $line[] = $ca125ProgressionDateAcc;
                        $line[] = "";
                        $line[] = "";
                        $line[] = "";
                        
                        echo implode(csv_separator, $line), "$newLine";
                    }
                }
            }
            unset($data);
            
            foreach ($pidBidAssoc as $newParticipantId => $newBankNbr) {
                if (! isset($allEocDxMstIdFromParticipantId[$newParticipantId]))
                    $tfriReportWarnings[$sheet]["Not all participants are linked to an EOC diagnosis"][$newBankNbr] = $newBankNbr;
            }
            
            $this->displayTfriReportWarning($sheet);
            echo "$newLine";
        }
        
        // *********************************************** SHEET 3 - EOC Event ***********************************************
        
        {
            $sheet = "SHEET 3 - EOC";
            echo "$newLine$newLine$sheet$newLine";
            
            $titleRow = array(
                "Patient Biobank Number (required)",
                "Event Type",
                "Date of event (beginning) Date",
                "Date of event (beginning) Accuracy",
                "Date of event (end) Date",
                "Date of event (end) Accuracy",
                "Chemotherapy Precision Drug1",
                "Chemotherapy Precision Drug2",
                "Chemotherapy Precision Drug3",
                "Chemotherapy Precision Drug4",
                "CA125  Precision (U)",
                "CT Scan Precision"
            );
            
            echo implode(csv_separator, $titleRow), "$newLine";
            
            $eocEventFromParticipantId = array();
            
            // CT-Scan
            
            $ctScanData = $this->Report->query("
				SELECT * FROM event_masters AS EventMaster 
				INNER JOIN ohri_ed_clinical_ctscans AS EventDetail ON EventDetail.event_master_id=EventMaster.id
				INNER JOIN event_controls AS EventControl ON EventControl.id = EventMaster.event_control_id 
				WHERE EventMaster.deleted=0 AND EventControl.event_type = 'ctscan' AND EventControl.flag_active = 1
				AND EventMaster.diagnosis_master_id IN(" . implode(", ", $allEocPrimAndSecDxMstIds) . ")
				ORDER BY EventMaster.participant_id ASC, EventMaster.event_date ASC", false);
            foreach ($ctScanData as $index => $unit) {
                $participantId = $unit['EventMaster']['participant_id'];
                $ctScanPrecision = null;
                if ($unit['EventDetail']['response'] == 'unknown') {
                    $ctScanPrecision = 'unknown';
                } elseif ($unit['EventDetail']['response'] == "complete") {
                    $ctScanPrecision = 'negative';
                } elseif (strlen($unit['EventDetail']['response']) > 0) {
                    $ctScanPrecision = 'positive';
                } else {
                    $ctScanPrecision = '';
                }
                $this->validateTfriReportValue($ctScanPrecision, 'ct_scan', "CT Scan Precision", $sheet, $pidBidAssoc[$participantId]);
                $eocEventFromParticipantId[$participantId][] = array(
                    "participant_biobank_id" => $pidBidAssoc[$participantId],
                    "event" => 'CT scan',
                    "event_start" => $unit['EventMaster']['event_date'],
                    "event_start_accuracy" => (empty($unit['EventMaster']['event_date']) ? '' : (empty($unit['EventMaster']['event_date_accuracy']) ? 'c' : $unit['EventMaster']['event_date_accuracy'])),
                    "event_end" => "",
                    "event_end_accuracy" => "",
                    "drug1" => "",
                    "drug2" => "",
                    "drug3" => "",
                    "drug4" => "",
                    "ca125" => "",
                    "ctscan precision" => $ctScanPrecision
                );
            }
            unset($ctScanData);
            
            // CA 125
            
            $ca125Data = $this->Report->query("
				SELECT * FROM event_masters AS EventMaster 
				INNER JOIN ohri_ed_lab_chemistries AS EventDetail ON EventDetail.event_master_id=EventMaster.id
				INNER JOIN event_controls AS EventControl ON EventControl.id = EventMaster.event_control_id 
				WHERE EventMaster.deleted=0 AND EventControl.event_type = 'chemistry' AND EventControl.flag_active = 1
				AND EventMaster.diagnosis_master_id IN(" . implode(", ", $allEocPrimAndSecDxMstIds) . ")
				ORDER BY EventMaster.participant_id ASC, EventMaster.event_date ASC", false);
            foreach ($ca125Data as $index => $unit) {
                $participantId = $unit['EventMaster']['participant_id'];
                $eocEventFromParticipantId[$participantId][] = array(
                    "participant_biobank_id" => $pidBidAssoc[$participantId],
                    "event" => 'CA125',
                    "event_start" => $unit['EventMaster']['event_date'],
                    "event_start_accuracy" => (empty($unit['EventMaster']['event_date']) ? '' : (empty($unit['EventMaster']['event_date_accuracy']) ? 'c' : $unit['EventMaster']['event_date_accuracy'])),
                    "event_end" => "",
                    "event_end_accuracy" => "",
                    "drug1" => "",
                    "drug2" => "",
                    "drug3" => "",
                    "drug4" => "",
                    "ca125" => $unit['EventDetail']['CA125_u_ml'],
                    "ctscan precision" => ""
                );
            }
            unset($ca125Data);
            
            // Biopsy, Surgery
            
            $txData = $this->Report->query("
				SELECT * FROM treatment_masters AS TreatmentMaster 
				INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
				INNER JOIN ohri_txd_surgeries AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
				WHERE TreatmentMaster.deleted=0 AND TreatmentControl.tx_method = 'surgery'
				AND TreatmentMaster.diagnosis_master_id IN(" . implode(", ", $allEocPrimAndSecDxMstIds) . ")
				ORDER BY TreatmentMaster.participant_id ASC, TreatmentMaster.start_date ASC", false);
            foreach ($txData as $index => $unit) {
                $participantId = $unit['TreatmentMaster']['participant_id'];
                $event = '';
                switch ($unit['TreatmentDetail']['description']) {
                    case 'biopsy':
                        $event = 'biopsy';
                        break;
                    case 'ovarectomy':
                        $event = 'surgery(ovarectomy)';
                        break;
                    default:
                        $event = 'surgery(other)';
                }
                $eocEventFromParticipantId[$participantId][] = array(
                    "participant_biobank_id" => $pidBidAssoc[$participantId],
                    "event" => $event,
                    "event_start" => $unit['TreatmentMaster']['start_date'],
                    "event_start_accuracy" => (empty($unit['TreatmentMaster']['start_date']) ? '' : (empty($unit['TreatmentMaster']['start_date_accuracy']) ? 'c' : $unit['TreatmentMaster']['start_date_accuracy'])),
                    "event_end" => "",
                    "event_end_accuracy" => "",
                    "drug1" => "",
                    "drug2" => "",
                    "drug3" => "",
                    "drug4" => "",
                    "ca125" => "",
                    "ctscan precision" => ""
                );
            }
            unset($txData);
            
            // Chemotherapy
            
            $txData = $this->Report->query("
				SELECT * FROM treatment_masters AS TreatmentMaster
				INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
				WHERE TreatmentMaster.deleted=0 AND TreatmentControl.tx_method = 'chemotherapy'
				AND TreatmentMaster.diagnosis_master_id IN(" . implode(", ", $allEocPrimAndSecDxMstIds) . ")
				ORDER BY TreatmentMaster.participant_id ASC, TreatmentMaster.start_date ASC", false);
            foreach ($txData as $index => $unit) {
                $participantId = $unit['TreatmentMaster']['participant_id'];
                $drugData = $this->Report->query("
					SELECT * FROM txe_chemos
					INNER JOIN drugs ON txe_chemos.drug_id=drugs.id
					WHERE txe_chemos.treatment_master_id = " . $unit['TreatmentMaster']['id'] . "
					AND txe_chemos.deleted = 0");
                $drugs = array();
                $newDrug = current($drugData);
                while ($newDrug != null) {
                    $drug = strtolower($newDrug['drugs']['generic_name']);
                    $this->validateTfriReportValue($drug, 'drugs', "Drug", $sheet, $pidBidAssoc[$participantId]);
                    $drugs[] = $drug;
                    $newDrug = next($drugData);
                }
                if (sizeof($drugs) > 4)
                    $tfriReportWarnings[$sheet]["More than 4 drugs associated to a chemo"][$pidBidAssoc[$participantId]] = $pidBidAssoc[$participantId];
                $eocEventFromParticipantId[$participantId][] = array(
                    "participant_biobank_id" => $pidBidAssoc[$participantId],
                    "event" => 'chemotherapy',
                    "event_start" => $unit['TreatmentMaster']['start_date'],
                    "event_start_accuracy" => (empty($unit['TreatmentMaster']['start_date']) ? '' : (empty($unit['TreatmentMaster']['start_date_accuracy']) ? 'c' : $unit['TreatmentMaster']['start_date_accuracy'])),
                    "event_end" => $unit['TreatmentMaster']['finish_date'],
                    "event_end_accuracy" => (empty($unit['TreatmentMaster']['finish_date']) ? '' : (empty($unit['TreatmentMaster']['finish_date_accuracy']) ? 'c' : $unit['TreatmentMaster']['finish_date_accuracy'])),
                    "drug1" => (isset($drugs[0]) ? $drugs[0] : ''),
                    "drug2" => (isset($drugs[1]) ? $drugs[1] : ''),
                    "drug3" => (isset($drugs[2]) ? $drugs[2] : ''),
                    "drug4" => (isset($drugs[3]) ? $drugs[3] : ''),
                    "ca125" => "",
                    "ctscan precision" => ""
                );
            }
            unset($txData);
            
            ksort($eocEventFromParticipantId);
            foreach ($eocEventFromParticipantId as $participantEvents) {
                foreach ($participantEvents as $line)
                    echo implode(csv_separator, $line), "$newLine";
            }
            unset($eocEventFromParticipantId);
            
            $this->displayTfriReportWarning($sheet);
            echo "$newLine";
        }
        
        // *********************************************** SHEET 4 - Other Primary Cancer -Diagnosis ***********************************************
        
        {
            $sheet = 'SHEET 4 - Other Primary Cancer -Diagnosis';
            echo "$newLine$newLine$sheet$newLine";
            
            $titleRow = array(
                "Patient Biobank Number (required)",
                "Date of Diagnosis Date",
                "Date of Diagnosis Accuracy",
                "Tumor Site",
                "Age at Time of Diagnosis (yr)",
                "Laterality",
                "Histopathology",
                "Grade",
                "Stage",
                "Date of Progression/Recurrence	Date",
                "Date of Progression/Recurrence	Accuracy",
                "Site of Tumor Progression (metastasis)  If Applicable",
                "Survival (months)"
            );
            
            echo implode(csv_separator, $titleRow), "$newLine";
            
            $allOtherPrimAndSecDxMstIds = array(
                '-1'
            );
            
            $data = $this->Report->query("
				SELECT *
				FROM diagnosis_masters AS DiagnosisMaster
				INNER JOIN diagnosis_controls AS DiagnosisControl ON DiagnosisControl.id = DiagnosisMaster.diagnosis_control_id
				LEFT JOIN ohri_dx_others AS DiagnosisDetail ON DiagnosisMaster.id=DiagnosisDetail.diagnosis_master_id
				WHERE DiagnosisMaster.deleted != 1 AND DiagnosisControl.controls_type != 'ovary' AND DiagnosisControl.category = 'primary'
				AND DiagnosisMaster.participant_id IN(" . implode(", ", $participantIds) . ")
				ORDER BY DiagnosisMaster.participant_id ASC");
            foreach ($data as $unit) {
                $participantId = $unit['DiagnosisMaster']['participant_id'];
                $otherDiagnosisMasterId = $unit['DiagnosisMaster']['id'];
                
                $allOtherPrimAndSecDxMstIds[] = $otherDiagnosisMasterId;
                
                // Get secondary then progression
                $secondaryData = $this->Report->query("SELECT * FROM diagnosis_masters AS DiagnosisMaster
					WHERE DiagnosisMaster.deleted=0 AND DiagnosisMaster.primary_id != DiagnosisMaster.id
					AND DiagnosisMaster.primary_id = $otherDiagnosisMasterId
					ORDER BY DiagnosisMaster.dx_date ASC");
                $secondaryTumors = array();
                foreach ($secondaryData as $newSecondary) {
                    $allOtherPrimAndSecDxMstIds[] = $newSecondary['DiagnosisMaster']['id'];
                    $key = $newSecondary['DiagnosisMaster']['dx_date'] . '#' . (empty($newSecondary['DiagnosisMaster']['dx_date']) ? '' : (empty($newSecondary['DiagnosisMaster']['dx_date_accuracy']) ? 'c' : $newSecondary['DiagnosisMaster']['dx_date_accuracy']));
                    $secondaryTumors[$key][] = $newSecondary['DiagnosisMaster']['ohri_tumor_site'];
                }
                $progressionDate = '';
                $progressionDateAcc = '';
                $progressionSite = '';
                if (! empty($secondaryTumors)) {
                    $dateAndAccKey = key($secondaryTumors);
                    $keyData = explode('#', $dateAndAccKey);
                    $progressionDate = $keyData[0];
                    $progressionDateAcc = $keyData[1];
                    $progressionSite = array_shift($secondaryTumors[$dateAndAccKey]);
                    if (empty($secondaryTumors[$dateAndAccKey]))
                        unset($secondaryTumors[$dateAndAccKey]);
                }
                
                // Get Stage
                $stage = '';
                if ($unit['DiagnosisMaster']['path_stage_summary']) {
                    $stage = $unit['DiagnosisMaster']['path_stage_summary'];
                } elseif ($unit['DiagnosisMaster']['clinical_stage_summary']) {
                    $stage = $unit['DiagnosisMaster']['clinical_stage_summary'];
                }
                
                // Records first diagnosis line data
                
                $unit['DiagnosisMaster']['ohri_tumor_site'];
                
                $this->validateTfriReportValue($unit['DiagnosisMaster']['ohri_tumor_site'], 'tumor_site', "Tumor Site", $sheet, $pidBidAssoc[$participantId]);
                $this->validateTfriReportValue($unit['DiagnosisDetail']['laterality'], 'laterality', "Laterality", $sheet, $pidBidAssoc[$participantId]);
                $this->validateTfriReportValue($unit['DiagnosisDetail']['histopathology'], 'histopathology', "Histopathology", $sheet, $pidBidAssoc[$participantId]);
                $this->validateTfriReportValue($unit['DiagnosisMaster']['tumour_grade'], 'grade', "Grade", $sheet, $pidBidAssoc[$participantId]);
                $this->validateTfriReportValue($progressionSite, 'tumor_site', "Site of Tumor Progression (metastasis)  If Applicable", $sheet, $pidBidAssoc[$participantId]);
                $this->validateTfriReportValue($stage, 'stage', "Stage", $sheet, $pidBidAssoc[$participantId]);
                
                $line = array();
                $line[] = $pidBidAssoc[$participantId];
                $line[] = $unit['DiagnosisMaster']['dx_date'];
                $line[] = (! empty($unit['DiagnosisMaster']['dx_date']) ? (empty($unit['DiagnosisMaster']['dx_date_accuracy']) ? 'c' : $unit['DiagnosisMaster']['dx_date_accuracy']) : '');
                $line[] = $unit['DiagnosisMaster']['ohri_tumor_site'];
                $line[] = $unit['DiagnosisMaster']['age_at_dx'];
                $line[] = $unit['DiagnosisDetail']['laterality'];
                $line[] = $unit['DiagnosisDetail']['histopathology'];
                $line[] = $unit['DiagnosisMaster']['tumour_grade'];
                $line[] = $stage;
                $line[] = $progressionDate;
                $line[] = (! empty($progressionDate) ? $progressionDateAcc : '');
                $line[] = $progressionSite;
                $line[] = $unit['DiagnosisMaster']['survival_time_months'];
                
                echo implode(csv_separator, $line), "$newLine";
                
                // Records other progressions
                while (! empty($secondaryTumors)) {
                    reset($secondaryTumors);
                    $dateAndAccKey = key($secondaryTumors);
                    $keyData = explode('#', $dateAndAccKey);
                    
                    $progressionDate = $keyData[0];
                    $progressionDateAcc = $keyData[1];
                    $progressionSite = array_shift($secondaryTumors[$dateAndAccKey]);
                    
                    if (empty($secondaryTumors[$dateAndAccKey]))
                        unset($secondaryTumors[$dateAndAccKey]);
                    
                    $this->validateTfriReportValue($progressionSite, 'tumor_site', "Site of Tumor Progression (metastasis)  If Applicable", $sheet, $pidBidAssoc[$participantId]);
                    
                    $line = array();
                    $line[] = $pidBidAssoc[$participantId];
                    $line[] = $unit['DiagnosisMaster']['dx_date'];
                    $line[] = (! empty($unit['DiagnosisMaster']['dx_date']) ? (empty($unit['DiagnosisMaster']['dx_date_accuracy']) ? 'c' : $unit['DiagnosisMaster']['dx_date_accuracy']) : '');
                    $line[] = $unit['DiagnosisMaster']['ohri_tumor_site'];
                    $line[] = "";
                    $line[] = "";
                    $line[] = "";
                    $line[] = "";
                    $line[] = "";
                    $line[] = $progressionDate;
                    $line[] = (! empty($progressionDate) ? $progressionDateAcc : '');
                    $line[] = $progressionSite;
                    $line[] = "";
                    
                    echo implode(csv_separator, $line), "$newLine";
                }
            }
            unset($data);
            
            $this->displayTfriReportWarning($sheet);
            echo "$newLine";
        }
        
        // *********************************************** "SHEET 5 - Other Primary Cancer - Event ***********************************************
        
        {
            $sheet = "SHEET 5 - Other Primary Cancer - Event";
            echo "$newLine$newLine$sheet$newLine";
            
            $titleRow = array(
                "Patient Biobank Number (required)",
                "Event Type",
                "Date of event (beginning) Date",
                "Date of event (beginning) Accuracy",
                "Date of event (end) Date",
                "Date of event (end) Accuracy",
                "Chemotherapy Precision Drug1",
                "Chemotherapy Precision Drug2",
                "Chemotherapy Precision Drug3",
                "Chemotherapy Precision Drug4"
            );
            
            echo implode(csv_separator, $titleRow), "$newLine";
            
            $otherEventFromParticipantId = array();
            
            // Biopsy, Surgery
            
            $txData = $this->Report->query("
				SELECT * FROM treatment_masters AS TreatmentMaster 
				INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
				INNER JOIN ohri_txd_surgeries AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
				WHERE TreatmentMaster.deleted=0 AND TreatmentControl.tx_method = 'surgery'
				AND TreatmentMaster.diagnosis_master_id IN(" . implode(", ", $allOtherPrimAndSecDxMstIds) . ")
				ORDER BY TreatmentMaster.participant_id ASC, TreatmentMaster.start_date ASC", false);
            foreach ($txData as $index => $unit) {
                $participantId = $unit['TreatmentMaster']['participant_id'];
                $event = '';
                switch ($unit['TreatmentDetail']['description']) {
                    case 'biopsy':
                        $event = 'biopsy';
                        break;
                    default:
                        $event = 'surgery';
                }
                $otherEventFromParticipantId[$participantId][] = array(
                    "participant_biobank_id" => $pidBidAssoc[$participantId],
                    "event" => $event,
                    "event_start" => $unit['TreatmentMaster']['start_date'],
                    "event_start_accuracy" => (empty($unit['TreatmentMaster']['start_date']) ? '' : (empty($unit['TreatmentMaster']['start_date_accuracy']) ? 'c' : $unit['TreatmentMaster']['start_date_accuracy'])),
                    "event_end" => "",
                    "event_end_accuracy" => "",
                    "drug1" => "",
                    "drug2" => "",
                    "drug3" => "",
                    "drug4" => ""
                );
            }
            unset($txData);
            
            // Chemotherapy
            
            $txData = $this->Report->query("
					SELECT * FROM treatment_masters AS TreatmentMaster
					INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
					WHERE TreatmentMaster.deleted=0 AND TreatmentControl.tx_method = 'chemotherapy'
					AND TreatmentMaster.diagnosis_master_id IN(" . implode(", ", $allOtherPrimAndSecDxMstIds) . ")
					ORDER BY TreatmentMaster.participant_id ASC, TreatmentMaster.start_date ASC", false);
            foreach ($txData as $index => $unit) {
                $participantId = $unit['TreatmentMaster']['participant_id'];
                $drugData = $this->Report->query("
					SELECT * FROM txe_chemos
					INNER JOIN drugs ON txe_chemos.drug_id=drugs.id
					WHERE txe_chemos.treatment_master_id = " . $unit['TreatmentMaster']['id'] . "
					AND txe_chemos.deleted = 0");
                $drugs = array();
                $newDrug = current($drugData);
                while ($newDrug != null) {
                    $drug = strtolower($newDrug['drugs']['generic_name']);
                    $this->validateTfriReportValue($drug, 'drugs', "Drug", $sheet, $pidBidAssoc[$participantId]);
                    $drugs[] = $drug;
                    $newDrug = next($drugData);
                }
                if (sizeof($drugs) > 4)
                    $tfriReportWarnings[$sheet]["More than 4 drugs associated to a chemo"][$pidBidAssoc[$participantId]] = $pidBidAssoc[$participantId];
                $otherEventFromParticipantId[$participantId][] = array(
                    "participant_biobank_id" => $pidBidAssoc[$participantId],
                    "event" => 'chemotherapy',
                    "event_start" => $unit['TreatmentMaster']['start_date'],
                    "event_start_accuracy" => (empty($unit['TreatmentMaster']['start_date']) ? '' : (empty($unit['TreatmentMaster']['start_date_accuracy']) ? 'c' : $unit['TreatmentMaster']['start_date_accuracy'])),
                    "event_end" => $unit['TreatmentMaster']['finish_date'],
                    "event_end_accuracy" => (empty($unit['TreatmentMaster']['finish_date']) ? '' : (empty($unit['TreatmentMaster']['finish_date_accuracy']) ? 'c' : $unit['TreatmentMaster']['finish_date_accuracy'])),
                    "drug1" => (isset($drugs[0]) ? $drugs[0] : ''),
                    "drug2" => (isset($drugs[1]) ? $drugs[1] : ''),
                    "drug3" => (isset($drugs[2]) ? $drugs[2] : ''),
                    "drug4" => (isset($drugs[3]) ? $drugs[3] : '')
                );
            }
            unset($txData);
            
            // Radiotherapy
            
            $txData = $this->Report->query("
				SELECT * FROM treatment_masters AS TreatmentMaster 
				INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
				WHERE TreatmentMaster.deleted=0 AND TreatmentControl.tx_method = 'radiation'
				AND TreatmentMaster.diagnosis_master_id IN(" . implode(", ", $allOtherPrimAndSecDxMstIds) . ")
				ORDER BY TreatmentMaster.participant_id ASC, TreatmentMaster.start_date ASC", false);
            foreach ($txData as $index => $unit) {
                $participantId = $unit['TreatmentMaster']['participant_id'];
                $event = '';
                $otherEventFromParticipantId[$participantId][] = array(
                    "participant_biobank_id" => $pidBidAssoc[$participantId],
                    "event" => 'radiotherapy',
                    "event_start" => $unit['TreatmentMaster']['start_date'],
                    "event_start_accuracy" => (empty($unit['TreatmentMaster']['start_date']) ? '' : (empty($unit['TreatmentMaster']['start_date_accuracy']) ? 'c' : $unit['TreatmentMaster']['start_date_accuracy'])),
                    "event_end" => $unit['TreatmentMaster']['finish_date'],
                    "event_end_accuracy" => (empty($unit['TreatmentMaster']['finish_date']) ? '' : (empty($unit['TreatmentMaster']['finish_date_accuracy']) ? 'c' : $unit['TreatmentMaster']['finish_date_accuracy'])),
                    "drug1" => "",
                    "drug2" => "",
                    "drug3" => "",
                    "drug4" => ""
                );
            }
            unset($txData);
            
            ksort($otherEventFromParticipantId);
            foreach ($otherEventFromParticipantId as $participantEvents) {
                foreach ($participantEvents as $line)
                    echo implode(csv_separator, $line), "$newLine";
            }
            unset($otherEventFromParticipantId);
            
            $this->displayTfriReportWarning($sheet);
            echo "$newLine";
        }
        exit();
    }

    public function validateTfriReportValue($value, $key, $excelField, $sheet, $participantBankNbr)
    {
        global $tfriReportAllowedValues;
        global $tfriReportWarnings;
        
        if ($value != null && $value != '') {
            if (! in_array($value, $tfriReportAllowedValues[$key])) {
                $tfriReportWarnings[$sheet]["Value '$value' not supported for field '$excelField'"][$participantBankNbr] = $participantBankNbr;
            }
        }
        
        return;
    }

    public function displayTfriReportWarning($sheet)
    {
        global $tfriReportWarnings;
        global $newLine;
        
        echo "$newLine";
        if (isset($tfriReportWarnings[$sheet])) {
            foreach ($tfriReportWarnings[$sheet] as $msg => $participantIds)
                echo "$msg. See Bank# : " . implode(', ', $participantIds) . "$newLine";
        }
        echo "$newLine";
    }
}