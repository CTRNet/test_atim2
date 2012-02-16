<?php
$pkey = "VOA Number";
$child = array();
$master_fields = array(
	"event_control_id" => "@51",
	"participant_id" => $pkey);

$detail_fields = array(
	"08_001_core_id" => "Experimental Data::08_001 Core ID",
	"10_007_core_id" => "Experimental Data::10_007 Core ID",
	"anxa4" => "Experimental Data::ANXA4",
	"areg_clid_hsq045253" => "Experimental Data::AREG CLID: hSQ045253",
	"brca_array_ar" => "Experimental Data::BRCA Array AR",
	"brca_array_b_catenin_m" => "Experimental Data::BRCA Array B_Catenin_M",
	"brca_array_b_catenin_n" => "Experimental Data::BRCA Array B_Catenin_N",
	"brca_array_brca1" => "Experimental Data::BRCA Array BRCA1",
	"brca_array_cd_117" => "Experimental Data::BRCA Array CD 117",
	"brca_array_cd_3" => "Experimental Data::BRCA Array CD 3",
	"brca_array_cyclin_d1" => "Experimental Data::BRCA Array Cyclin D1",
	"brca_array_cycline" => "Experimental Data::BRCA Array CyclinE",
	"brca_array_e2f1" => "Experimental Data::BRCA Array E2F1",
	"brca_array_ecad" => "Experimental Data::BRCA Array Ecad",
	"brca_array_eef1a2" => "Experimental Data::BRCA Array EEF1a2",
	"brca_array_egfr" => "Experimental Data::BRCA Array EGFR",
	"brca_array_er" => "Experimental Data::BRCA Array ER",
	"brca_array_foxp3" => "Experimental Data::BRCA Array FOXP3",
	"brca_array_her2" => "Experimental Data::BRCA Array HER2",
	"brca_array_mip_c_myc_hebo_mrna_mean" => "Experimental Data::BRCA Array MIP_C_Myc HEBO mRNA Mean",
	"brca_array_mip_c_myc_hebo_mrna_row1" => "Experimental Data::BRCA Array MIP_C_Myc HEBO mRNA Row1",
	"brca_array_mip_c_myc_hebo_mrna_row2" => "Experimental Data::BRCA Array MIP_C_Myc HEBO mRNA Row2",
	"brca_array_mip_c_myc_hebo_mrna_sd" => "Experimental Data::BRCA Array MIP_C_Myc HEBO mRNA SD",
	"brca_array_mip_c_myc_mean" => "Experimental Data::BRCA Array MIP_C_Myc Mean",
	"brca_array_mip_c_myc_position128820745" => "Experimental Data::BRCA Array MIP_C_Myc Position128820745",
	"brca_array_mip_c_myc_position128822436" => "Experimental Data::BRCA Array MIP_C_Myc Position128822436",
	"brca_array_mip_c_myc_sd" => "Experimental Data::BRCA Array MIP_C_Myc SD",
	"brca_array_mip_emsy_mean" => "Experimental Data::BRCA Array MIP_EMSY Mean",
	"brca_array_mip_emsy_position75861572" => "Experimental Data::BRCA Array MIP_EMSY Position75861572",
	"brca_array_mip_emsy_position75921347" => "Experimental Data::BRCA Array MIP_EMSY Position75921347",
	"brca_array_mip_emsy_sd" => "Experimental Data::BRCA Array MIP_EMSY SD",
	"brca_array_mip_hace1" => "Experimental Data::BRCA Array MIP_Hace1",
	"brca_array_mip_imp3" => "Experimental Data::BRCA Array MIP_IMP3",
	"brca_array_mip_imp3_bin" => "Experimental Data::BRCA Array MIP_IMP3 Bin",
	"brca_array_mip_imp3_hebo_mrna" => "Experimental Data::BRCA Array MIP_IMP3 HEBO mRNA",
	"brca_array_mip_pik3ca" => "Experimental Data::BRCA Array MIP_PIK3CA",
	"brca_array_p16" => "Experimental Data::BRCA Array p16",
	"brca_array_p21" => "Experimental Data::BRCA Array p21",
	"brca_array_p27" => "Experimental Data::BRCA Array p27",
	"brca_array_p53" => "Experimental Data::BRCA Array p53",
	"brca_array_p63" => "Experimental Data::BRCA Array p63",
	"brca_array_pakt" => "Experimental Data::BRCA Array pAKT",
	"brca_array_pr" => "Experimental Data::BRCA Array PR",
	"brca_array_qrt_pcr_hace1" => "Experimental Data::BRCA Array qRT_PCR_Hace1",
	"brca_array_qrt_pcr_id4_rna" => "Experimental Data::BRCA Array qRT_PCR_ID4 RNA",
	"brca_array_qrt_pcr_pik3ca" => "Experimental Data::BRCA Array qRT_PCR_PIK3CA",
	"brca_array_qrt_pcr_pten" => "Experimental Data::BRCA Array qRT_PCR_PTEN",
	"brca_array_wt1" => "Experimental Data::BRCA Array WT1",
	"brca_array_znf217_position51632374" => "Experimental Data::BRCA Array ZNF217 Position51632374",
	"brca1" => "Experimental Data::BRCA1",
	"brca1_germline_amino_acid" => "Experimental Data::BRCA1 Germline Amino Acid",
	"brca1_germline_nuc_acid" => "Experimental Data::BRCA1 Germline Nuc Acid",
	"brca1_hypermethylation" => "Experimental Data::BRCA1 Hypermethylation",
	"brca1_loh" => "Experimental Data::BRCA1 LOH",
	"brca1_rna" => "Experimental Data::BRCA1 RNA",
	"brca1_somatic_amino_acid" => "Experimental Data::BRCA1 Somatic Amino Acid",
	"brca1_somatic_nuc_acid" => "Experimental Data::BRCA1 Somatic Nuc Acid",
	"brca1_vus" => "Experimental Data::BRCA1 VUS",
	"brca2_germline_amino_acid" => "Experimental Data::BRCA2 Germline Amino Acid",
	"brca2_germline_nuc_acid" => "Experimental Data::BRCA2 Germline Nuc Acid",
	"brca2_loh" => "Experimental Data::BRCA2 LOH",
	"brca2_rna" => "Experimental Data::BRCA2 RNA",
	"brca2_somatic_nuc_acid" => "Experimental Data::BRCA2 Somatic Nuc Acid",
	"brca2_vus" => "Experimental Data::BRCA2 VUS",
	"btc_clid_hsq035992" => "Experimental Data::BTC CLID: hSQ035992",
	"ccl28_clid_hsq013417" => "Experimental Data::CCL28 CLID: hSQ013417",
	"cd20_victoria" => "Experimental Data::CD20 Victoria",
	"cd3_vgh" => "Experimental Data::CD3 VGH",
	"cd3_vgh_rescore" => "Experimental Data::CD3 VGH Rescore",
	"cd3_victoria" => "Experimental Data::CD3 Victoria",
	"cd3_victoria_rescore" => "Experimental Data::CD3 Victoria Rescore",
	"cd74_clid_hsq040723" => "Experimental Data::CD74 CLID: hSQ040723",
	"cd74_clid_hsq045359" => "Experimental Data::CD74 CLID: hSQ045359",
	"cd8_vgh" => "Experimental Data::CD8 VGH",
	"cd8_vgh_rescore" => "Experimental Data::CD8 VGH Rescore",
	"cd8_victoria" => "Experimental Data::CD8 Victoria",
	"cd8_victoria_rescore" => "Experimental Data::CD8 Victoria Rescore",
	"cycline" => "Experimental Data::CyclinE",
	"egfr_clid_hsq010863" => "Experimental Data::EGFR CLID: hSQ010863",
	"egfr_clid_hsq038313" => "Experimental Data::EGFR CLID: hSQ038313",
	"erbb3_clid_hsq001349" => "Experimental Data::ERBB3 CLID: hSQ001349",
	"ereg_clid_hsq025201" => "Experimental Data::EREG CLID: hSQ025201",
	"errfi1_clid_hsq001603" => "Experimental Data::ERRFI1 CLID: hSQ001603",
	"fkbp7_clid_hsq037241" => "Experimental Data::FKBP7 CLID: hSQ037241",
	"foxp3_victoria" => "Experimental Data::FoxP3 Victoria",
	"itgb7_clid_hsq031618" => "Experimental Data::ITGB7 CLID: hSQ031618",
	"kp_ir_pmol_l" => "Experimental Data::KP_IR pmol_l",
	"mda_cmyc_mean" => "Experimental Data::MDA CMyc Mean",
	"mda_cmyc_replicate_1" => "Experimental Data::MDA CMyc Replicate 1",
	"mda_cmyc_replicate_2" => "Experimental Data::MDA CMyc Replicate 2",
	"mda_cmyc_sd" => "Experimental Data::MDA CMyc SD",
	"mdm2" => "Experimental Data::MDM2",
	"mif_clid_hsq038688" => "Experimental Data::MIF CLID: hSQ038688",
	"ndrg1" => "Experimental Data::NDRG1",
	"p10" => "Experimental Data::p10",
	"p16" => "Experimental Data::p16",
	"p21" => "Experimental Data::p21",
	"p27" => "Experimental Data::p27",
	"p53" => "Experimental Data::p53",
	"pakt" => "Experimental Data::pAKT",
	"pde5a_clid_hsq039972" => "Experimental Data::PDE5A CLID: hSQ039972",
	"pde5a_expression_data" => "Experimental Data::PDE5a Expression Data",
	"powerplex" => "Experimental Data::Powerplex",
	"serbp1" => "Experimental Data::SERBP1",
	"spry1_clid_hsq011236" => "Experimental Data::SPRY1 CLID: hSQ011236",
	"spry1_clid_hsq043441" => "Experimental Data::SPRY1 CLID: hSQ043441",
	"spry1_clid_hsq043924" => "Experimental Data::SPRY1 CLID: hSQ043924",
	"spry2_clid_hsq035516" => "Experimental Data::SPRY2 CLID: hSQ035516",
	"spry4_clid_hsq027862" => "Experimental Data::SPRY4 CLID: hSQ027862",
	"tia1_victoria" => "Experimental Data::TIA1 Victoria",
	"tma_agr2_43" => "Experimental Data::TMA_AGR2_43",
	"tma_apoj" => "Experimental Data::TMA_APOJ",
	"tma_arid1a" => "Experimental Data::TMA_ARID1A",
	"tma_beta_catenin_nuclear" => "Experimental Data::TMA_Beta_Catenin Nuclear",
	"tma_birc6" => "Experimental Data::TMA_BIRC6",
	"tma_ca125" => "Experimental Data::TMA_CA125",
	"tma_capg164" => "Experimental Data::TMA_CAPG164",
	"tma_ccl28_intensity" => "Experimental Data::TMA_CCL28 Intensity",
	"tma_ccl28_irs" => "Experimental Data::TMA_CCL28 IRS",
	"tma_ccl28_percent" => "Experimental Data::TMA_CCL28 Percent",
	"tma_cd20" => "Experimental Data::TMA_CD20",
	"tma_cd200" => "Experimental Data::TMA_CD200",
	"tma_cd44v6" => "Experimental Data::TMA_CD44v6",
	"tma_cd74" => "Experimental Data::TMA_CD74",
	"tma_cd8" => "Experimental Data::TMA_CD8",
	"tma_ckit" => "Experimental Data::TMA_cKit",
	"tma_cmyc" => "Experimental Data::TMA_CMyc",
	"tma_cyclind1" => "Experimental Data::TMA_CyclinD1",
	"tma_dal1" => "Experimental Data::TMA_Dal1",
	"tma_dicer" => "Experimental Data::TMA_Dicer",
	"tma_dkk1" => "Experimental Data::TMA_DKK1",
	"tma_drosha" => "Experimental Data::TMA_Drosha",
	"tma_e_cadherin" => "Experimental Data::TMA_E_Cadherin",
	"tma_egfr" => "Experimental Data::TMA_EGFR",
	"tma_epcam" => "Experimental Data::TMA_EpCam",
	"tma_ephb4" => "Experimental Data::TMA_EPHB4",
	"tma_er" => "Experimental Data::TMA_ER",
	"tma_ezh2" => "Experimental Data::TMA_EZH2",
	"tma_ezrin" => "Experimental Data::TMA_Ezrin",
	"tma_fascin" => "Experimental Data::TMA_Fascin",
	"tma_foxl2" => "Experimental Data::TMA_FOXL2",
	"tma_foxp3" => "Experimental Data::TMA_FoxP3",
	"tma_gdf15" => "Experimental Data::TMA_GDF15",
	"tma_gpr54" => "Experimental Data::TMA_GPR54",
	"tma_hacel_sorensen" => "Experimental Data::TMA_Hacel_Sorensen",
	"tma_hdac1" => "Experimental Data::TMA_HDAC1",
	"tma_he4" => "Experimental Data::TMA_HE4",
	"tma_her2" => "Experimental Data::TMA_HER2",
	"tma_hif1_alpha" => "Experimental Data::TMA_HIF1 Alpha",
	"tma_hif1_intensity" => "Experimental Data::TMA_HIF1 Intensity",
	"tma_hif1_irs" => "Experimental Data::TMA_HIF1 IRS",
	"tma_hif1_percent" => "Experimental Data::TMA_HIF1 Percent",
	"tma_hif1a" => "Experimental Data::TMA_HIF1A",
	"tma_hnf_r_soslow" => "Experimental Data::TMA_HNF_R_Soslow",
	"tma_hnf1b_restain" => "Experimental Data::TMA_HNF1B Restain",
	"tma_hsp10" => "Experimental Data::TMA_HSP10",
	"tma_imp3" => "Experimental Data::TMA_IMP3",
	"tma_k_cadherin" => "Experimental Data::TMA_K_Cadherin",
	"tma_ki67" => "Experimental Data::TMA_Ki67",
	"tma_kiss1" => "Experimental Data::TMA_KISS1",
	"tma_laminin_rp_score" => "Experimental Data::TMA_Laminin RP Score",
	"tma_laminin_rp_vessels" => "Experimental Data::TMA_Laminin RP Vessels",
	"tma_lyn" => "Experimental Data::TMA_LYN",
	"tma_mammaglobin_b" => "Experimental Data::TMA_Mammaglobin B",
	"tma_mdm2" => "Experimental Data::TMA_MDM2",
	"tma_mdm2_restain_08_05_09" => "Experimental Data::TMA_MDM2 restain 08.05.09",
	"tma_mesothelin" => "Experimental Data::TMA_Mesothelin",
	"tma_mif" => "Experimental Data::TMA_MIF",
	"tma_mmp7" => "Experimental Data::TMA_MMP7",
	"tma_mps1_intensity" => "Experimental Data::TMA_MPS1 Intensity",
	"tma_mps1_max_percent" => "Experimental Data::TMA_MPS1 Max Percent",
	"tma_mps1_mean_percent" => "Experimental Data::TMA_MPS1 Mean Percent",
	"tma_mps1_nuclear_staining" => "Experimental Data::TMA_MPS1 Nuclear Staining",
	"tma_mras" => "Experimental Data::TMA_MRAS",
	"tma_muc5" => "Experimental Data::TMA_MUC5",
	"tma_muc6" => "Experimental Data::TMA_MUC6",
	"tma_nasp" => "Experimental Data::TMA_NASP",
	"tma_nherf1" => "Experimental Data::TMA_NHERF1",
	"tma_nkap" => "Experimental Data::TMA_NKAP",
	"tma_numb" => "Experimental Data::TMA_NUMB",
	"tma_ogp" => "Experimental Data::TMA_OGP",
	"tma_opn" => "Experimental Data::TMA_OPN",
	"tma_p16" => "Experimental Data::TMA_p16",
	"tma_p21" => "Experimental Data::TMA_p21",
	"tma_p53" => "Experimental Data::TMA_p53",
	"tma_p53_rescore" => "Experimental Data::TMA_p53 Rescore",
	"tma_pax2" => "Experimental Data::TMA_PAX2",
	"tma_pax8" => "Experimental Data::TMA_PAX8",
	"tma_pcad_intensity" => "Experimental Data::TMA_pcad Intensity",
	"tma_pcad_percent_positive" => "Experimental Data::TMA_pcad Percent Positive",
	"tma_pdgfr_beta" => "Experimental Data::TMA_PDGFR Beta",
	"tma_phosphoeif4e" => "Experimental Data::TMA_PhosphoEIF4E",
	"tma_pigr" => "Experimental Data::TMA_PIGR",
	"tma_pkm2" => "Experimental Data::TMA_PKM2",
	"tma_podocalyxin" => "Experimental Data::TMA_Podocalyxin",
	"tma_pr" => "Experimental Data::TMA_PR",
	"tma_ps6rp" => "Experimental Data::TMA_pS6rp",
	"tma_pstat" => "Experimental Data::TMA_PSTAT",
	"tma_pten" => "Experimental Data::TMA_PTEN",
	"tma_pthlh" => "Experimental Data::TMA_PTHLH",
	"tma_rb" => "Experimental Data::TMA_Rb",
	"tma_ret" => "Experimental Data::TMA_Ret",
	"tma_s100" => "Experimental Data::TMA_S100",
	"tma_s100a1" => "Experimental Data::TMA_S100A1",
	"tma_secretory_component_pigr" => "Experimental Data::TMA_Secretory Component_PIGR",
	"tma_skp2" => "Experimental Data::TMA_SKP2",
	"tma_survivin" => "Experimental Data::TMA_Survivin",
	"tma_tff3" => "Experimental Data::TMA_TFF3",
	"tma_tgfb1" => "Experimental Data::TMA_TGFB1",
	"tma_tia1" => "Experimental Data::TMA_TIA1",
	"tma_trka" => "Experimental Data::TMA_TRKA",
	"tma_trkb" => "Experimental Data::TMA_TRKB",
	"tma_vegfr2" => "Experimental Data::TMA_VEGFR2",
	"tma_vimentin" => "Experimental Data::TMA_Vimentin",
	"tma_wt1" => "Experimental Data::TMA_WT1",
	"tro_clid_hsq004393" => "",
	"tro_clid_hsq006530" => "",
	"wdr72_clid_hsq009730" => "",
	"tma_blocks" => "",
	"05_008_brca1_mccluggage_int" => "Experimental Data::05_008 BRCA1 McCluggage Intensity",
	"05_008_brca1_mccluggage_per" => "Experimental Data::05_008 BRCA1 McCluggage Percent",
	"05_008_core_id" => "Experimental Data::05_008 Core ID",
	"tma_parp1" => "Experimental Data::TMA_PARP1",
	"tma_notch1" => "Experimental Data::TMA_Notch1",
	"tma_folr1" => "Experimental Data::TMA_FOLR1",
	"tma_cxcr4" => "Experimental Data::TMA_CXCR4"
	);
	
//see the Model class definition for more info
$model = new MasterDetailModel(3, $pkey, $child, false, "participant_id", $pkey, 'event_masters', $master_fields, 'ovcare_ed_lab_experimental_results', 'event_master_id', $detail_fields);

//we can then attach post read/write functions
$model->custom_data = array();
$model->insert_condition_function = 'preExperimentalDataWrite';

//adding this model to the config
Config::$models['ExperimentalResuls'] = $model;

function preExperimentalDataWrite(Model $m){	
	foreach($m->values as $field => $val) {
		if(strlen($val) > 250) {
			Config::$summary_msg['@@WARNING@@']['Experiment Data #1'][] = "The value [$field] of the field [$val] is too big (more than >250). String will be cutted. [VOA#: ".Config::$current_voa_nbr.' / line: '.$m->line.']';
		}
	}

	return true;
	
}








