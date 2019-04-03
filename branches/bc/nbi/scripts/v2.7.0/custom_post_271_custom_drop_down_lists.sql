-- -------------------------------------------------------------------------
--
-- BCCA drop down list
--   To load first before custom_post_271.sql
--
-- -------------------------------------------------------------------------


ALTER TABLE structure_permissible_values_customs 
   MODIFY en varchar(300) DEFAULT NULL,
   MODIFY fr varchar(300) DEFAULT NULL;

-- List from "table lookup values" worksheets
-- -------------------------------------------

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_status_at_referral', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_status_at_referral\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_status_at_referral', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_status_at_referral');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("1", "Follow-up: Patient is referred for follow-up of breast cancer that was initially treated elsewhere. No active disease is present.", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "New patient: Patient is referred shortly after diagnosis of breast cancer. May be referred pre or post-operatively.", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "Recurrence: Patient is referred with active disease after a period of remission for breast cancer that was initially treated elsewhere.", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4", "Residual disease: Patient is referred with active disease after an interval of time has elapsed between diagnosis and first visit to the Agency. Disease has never been in complete remission.", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_loc_at_admit & location', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_loc_at_admit & location\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_loc_at_admit & location', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_loc_at_admit & location');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("AB", "ABBOTSFORD 1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AC", "Abbotsford Centre 5", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CA", "CAMPBELL RIVER 2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CK", "CHILLIWACK 3", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CN", "North 6", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CO", "COMOX 2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CR", "CRANBROOK 4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CS", "CRESTON 4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CU", "CUMBERLAND 2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DC", "DAWSON CREEK 6", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FV", "Fraser Valley 3", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KA", "KELOWNA HOSP. 4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KI", "KITIMAT 6", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KS", "KAMLOOPS 4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NA", "NANAIMO 2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NE", "NELSON 4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NK", "NOT KNOWN 1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NW", "NEW WESTMINSTER 1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PA", "PORT ALBERNI 2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PE", "PENTICTON 4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PG", "PRINCE GEORGE 1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PL", "POWELL RIVER 1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PR", "PRINCE RUPERT 6", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SI", "Southern Interior 4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TE", "TERRACE 6", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TR", "TRAIL 4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("VA", "VANCOUVER 1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("VE", "VERNON 4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("VI", "Vancouver Island 2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("WH", "WHITEHORSE 1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("WR", "WHITE ROCK 1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_hsda', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_hsda\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_hsda', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_hsda');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("011", "East Kootenay", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("012", "Kootenay Boundary", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("013", "Okanagan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("014", "Thompson Cariboo Shuswap", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("021", "Fraser East", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("022", "Fraser North", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("023", "Fraser South", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("031", "Richmond", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("032", "Vancouver", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("033", "North Shore/Coast Garibaldi", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("041", "South Vancouver Island", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("042", "Central Vancouver Island", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("043", "North Vancouver Island", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("051", "Northwest", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("052", "Northern Interior", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("053", "Northeast", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("061", "Prov Hlth Serv Authority", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_hlth_auth', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_hlth_auth\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_hlth_auth', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_hlth_auth');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("01", "Interior", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02", "Fraser", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03", "Vancouver Coastal", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04", "Vancouver Island", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05", "Northern", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06", "Prov Health Serv", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_local_health_area', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_local_health_area\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_local_health_area', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_local_health_area');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("001", "Fernie", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("002", "Cranbrook", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("003", "Kimberley", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("004", "Windermere", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("005", "Creston", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("006", "Kootenay Lake", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("007", "Nelson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("009", "Castlegar", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("010", "Arrow Lakes", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("011", "Trail", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("012", "Grand Forks", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("013", "Kettle Valley", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("014", "Southern Okanagan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("015", "Penticton", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("016", "Keremeos", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("017", "Princeton", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("018", "Golden", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("019", "Revelstoke", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("020", "Salmon Arm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("021", "Armstrong-Spallumcheen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("022", "Vernon", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("023", "Central Okanagan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("024", "Kamloops", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("025", "100 Mile House", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("026", "North Thompson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("027", "Cariboo Chilcotin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("028", "Quesnel", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("029", "Lillooet", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("030", "South Cariboo", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("031", "Merritt", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("032", "Hope", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("033", "Chilliwack", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("034", "Abbotsford", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("035", "Langley", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("036", "Fraser South unspecified", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("037", "Delta", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("038", "Richmond", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("039", "Vancouver (see 161 - 169)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("040", "New Westminster", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("041", "Burnaby", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("042", "Maple Ridge", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("043", "Coquitlam", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("044", "North Vancouver", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("045", "West Vancouver-Bowen Is.", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("046", "Sunshine Coast", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("047", "Powell River", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("048", "Howe Sound", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("049", "Bella Coola Valley", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("050", "Queen Charlotte", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("051", "Snow Country", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("052", "Prince Rupert", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("053", "Upper Skeena", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("054", "Smithers", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("055", "Burns Lake", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("056", "Nechako", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("057", "Prince George", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("059", "Peace River South", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("060", "Peace River North", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("061", "Greater Victoria", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("062", "Sooke", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("063", "Saanich", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("064", "Gulf Islands", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("065", "Cowichan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("066", "Lake Cowichan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("067", "Ladysmith", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("068", "Nanaimo", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("069", "Qualicum", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("070", "Alberni", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("071", "Courtenay", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("072", "Campbell River", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("075", "Mission", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("076", "Agassiz-Harrison", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("077", "Summerland", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("078", "Enderby", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("080", "Kitimat", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("081", "Fort Nelson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("083", "Central Coast", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("084", "Vancouver Island West", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("085", "Vancouver Island North", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("087", "Stikine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("088", "Terrace", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("092", "Nisga'a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("094", "Telegraph Creek", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("161", "Vancouver-City Centre", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("162", "Vancouver-Downtown East", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("163", "Vancouver-North East", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("164", "Vancouver-Westside", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("165", "Vancouver-Midtown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("166", "Vancouver-South", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("169", "Vancouver unspecified", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("201", "Surrey", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("202", "South Surrey/White Rock", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("601", "Prov Health Serv", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_family_hx', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_family_hx\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_family_hx', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_family_hx');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "No history of breast cancer in first degree blood relative(s)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "History of bilateral breast cancer in first degree blood relative(s)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "History of unilateral breast cancer in first degree blood relative(s)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "History of breast cancer in first degree blood relative(s); unknown if bilateral or unilateral", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "Unknown history of breast cancer in first degree blood relative(s)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_num_fst_deg_relatives', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_num_fst_deg_relatives\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_num_fst_deg_relatives', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_num_fst_deg_relatives');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "No first degree blood relative(s) with a history of breast cancer", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "One first degree blood relative with a history of breast cancer", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "Two first degree blood relatives with a history of breast cancer", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "Three first degree blood relatives with a history of breast cancer", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4", "Four or more first degree blood relatives with a history of breast cancer", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "History of breast cancer in first degree blood relative(s); number of relatives unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "Unknown history of breast cancer in first degree blood relative(s)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_performance_status', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_performance_status\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_performance_status', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_performance_status');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "Fully active, able to carry on all pre-disease performance without restriction (Karnofsky 90-100)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "Restricted in physically strenuous activity but ambulatory and able to carry out work of a light or sedentary nature, eg. light house work, office work (Karnofsky 70-80)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "Ambulatory and capable of all self-care but unable to carry out any work activities. Up and about more than 50% of waking hours. (Karnofsky 50-60)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "Capable of only limited self-care, confined to bed or chair more than 50% of waking hours (Karnofsky 30-40)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4", "Completely disabled. Cannot carry on any self-care. Totally confined to bed or chair (Karnofsky 10-20)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "Not applicable to site", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "Unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_site', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_site\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_site', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_site');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("C500", "nipple", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("C501", "central", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("C502", "upper-inner quadrant", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("C503", "lower-inner quadrant", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("C504", "upper-outer quadrant", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("C505", "lower-outer quadrant", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("C506", "axillary tail", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("C508", "overlapping lesion", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("C509", "breast, NOS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_M_STG', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_M_STG\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_M_STG', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_M_STG');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "no distant mets", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "distant mets", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("9", "unknown if distant mets present", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_tnm_clin_t', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_tnm_clin_t\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_tnm_clin_t', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_tnm_clin_t');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "no evidence of primary tumour", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "<= 2.0 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1A", "<=0.5 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1B", ">0.5 cm and <= 1.0 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1C", ">1.0 cm and <= 2.0 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1M", "microinvasion 0.1 cm or less", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", ">2.0 cm and <= 5.0 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", ">5.0 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4", "any size, with direct extension to chest wall and/or skin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4A", "extension to chest wall", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4B", "edema, ulceration, and/or ipsilateral satellite nodules", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4C", "cT4a and cT4b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4D", "inflammatory carcinoma", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "no classification recommended", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("IS", "carcinoma in situ", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ISD", "ductal carcinoma in situ", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ISL", "lobular carcinoma in situ", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ISP", "Pagets disease of the nipple, not associated with invasive carcinoma and/or carcinoma in situ", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("X", "primary tumour cannot be assessed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_tnm_clin_m', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_tnm_clin_m\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_tnm_clin_m', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_tnm_clin_m');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "No evidence of distant mets; deposits (<=0.2 mm) of tumor cells in blood, bone marrow or other non-regional nodal tissue", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "Distant metastasis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("X", "Distant metastasis cannot be assessed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_tnm_surg_t', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_tnm_surg_t\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_tnm_surg_t', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_tnm_surg_t');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "no evidence of primary tumour", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "<= 2.0 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1A", "<=0.5 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1B", ">0.5 cm and <= 1.0 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1C", ">1.0 cm and <= 2.0 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1M", "microinvasion 0.1 cm or less", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", ">2.0 cm and <= 5.0 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", ">5.0 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4", "any size, with direct extension to chest wall and/or skin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4A", "extension to chest wall", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4B", "edema, ulceration, and/or ipsilateral satellite nodules", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4C", "cT4a and cT4b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4D", "inflammatory carcinoma", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "no classification recommended", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("IS", "carcinoma in situ", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ISD", "ductal carcinoma in situ", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ISL", "lobular carcinoma in situ", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("X", "primary tumour cannot be assessed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_tnm_surg_n', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_tnm_surg_n\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_tnm_surg_n', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_tnm_surg_n');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "No regional lymph node metastasis identified histologically", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("0i", "manually collected", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("0NI", "no regional lymph node metastases histologically; negative IHC", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("0PI", "Malignant cells in regional lymph node(s) no greater than 0.2 mm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "Micrometastases; or metastases in 1 to 3 axillary lymph nodes; and/or in internal mammary nodes with", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1A", "Metastasis in 1 to 3 axillary lymph nodes", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1B", "Metastasis in int mamm LN with micro disease by sentinal LN", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1C", "(AJCC6) Mets in 1 to 3 ax LN AND in int mamm LN...", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1M", "Only micrometastases (none larger than 2mm)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "Metastases in 4 to 9 axillary lymph nodes; or in clinically detected internal mammary lymph nodes in", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2A", "Mets in 4 to 9 ax LN, at least one deposit > 2.0mm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2B", "Mets in clinically apparent int mamm LN w/o ax LN", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "Metastases in 10 or more axillary lymph nodes; or in infraclavicular (level III axillary) lymph node", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3A", "Metastases in 10 or more axillary lymph nodes (at least one tumor deposit greater than 2.0 mm); or m", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3C", "Metastases in ipsilateral supraclavicular lymph node(s)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("X", "Regional lymph nodes cannot be assessed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_tnm_surg_m', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_tnm_surg_m\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_tnm_surg_m', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_tnm_surg_m');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "No distant metastasis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "Distant metastasis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("X", "Distant metastasis cannot be assessed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_COL_AJCC_T_clin', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_COL_AJCC_T_clin\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_COL_AJCC_T_clin', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_COL_AJCC_T_clin');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("Blank", "Tumour outside the CCR AJCC TNM staging scope", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("Tx", "Primary tumour cannot be assessed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T0", "Site specific meaning", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("Tis", "Tis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TisDCIS", "TisDCIS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TisLCIS", "TisLCIS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TisPagets", "TisPagets", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T1", "T1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T1mic", "T1mic", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T1a", "T1a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T1b", "T1b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T1c", "T1c", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T2", "T2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T2a", "T2a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T2b", "T2b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T2c", "T2c", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T3", "T3", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T3a", "T3a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T3b", "T3b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T4", "T4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T4a", "T4a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T4b", "T4b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T4c", "T4c", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T4d", "T4d", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "AJCC pathologic T unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_COL_AJCC_N_clin', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_COL_AJCC_N_clin\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_COL_AJCC_N_clin', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_COL_AJCC_N_clin');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("Blank", "Blank", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NX", "NX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N0", "N0", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N1", "N1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N2", "N2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N2a", "N2a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N2b", "N2b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N2NOS", "N2NOS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N3", "N3", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N3a", "N3a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N3b", "N3b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N3c", "N3c", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "AJCC clinical N is unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_COL_AJCC_M_clin', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_COL_AJCC_M_clin\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_COL_AJCC_M_clin', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_COL_AJCC_M_clin');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("Blank", "Blank", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MX", "MX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MO", "MO", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("M1", "M1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("M1a", "M1a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("M1b", "M1b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("M1c", "M1c", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "AJCC clinical M unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_COL_AJCC_T_path', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_COL_AJCC_T_path\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_COL_AJCC_T_path', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_COL_AJCC_T_path');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("Blank", "Blank", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("Tx", "Tx", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T0", "T0", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("Tis", "Tis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TisDCIS", "TisDCIS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TisLCIS", "TisLCIS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TisPagets", "TisPagets", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T1", "T1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T1mic", "T1mic", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T1a", "T1a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T1b", "T1b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T1c", "T1c", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T1NOS", "T1NOS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T2", "T2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T2a", "T2a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T2b", "T2b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T2c", "T2c", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T3", "T3", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T3a", "T3a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T3b", "T3b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T4", "T4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T4a", "T4a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T4b", "T4b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T4c", "T4c", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T4d", "T4d", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "AJCC pathologic T unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_COL_AJCC_N_path', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_COL_AJCC_N_path\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_COL_AJCC_N_path', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_COL_AJCC_N_path');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("Blank", "Blank", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NX", "NX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N0", "N0", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N0i", "N0i", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N0i+", "N0i+", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N0mol", "N0mol", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N0mol+", "N0mol+", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N1", "N1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N1mi", "N1mi", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N1a", "N1a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N1b", "N1b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N1c", "N1c", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N1NOS", "N1NOS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N2", "N2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N2a", "N2a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N2b", "N2b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N3", "N3", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N3a", "N3a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N3b", "N3b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N3c", "N3c", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "AJCC pathologic N is unknown.", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_COL_AJCC_M_path', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_COL_AJCC_M_path\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_COL_AJCC_M_path', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_COL_AJCC_M_path');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("Blank", "Blank", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MX", "MX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MO", "MO", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("M1", "M1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("M1a", "M1a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("M1b", "M1b", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("M1c", "M1c", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "AJCC clinical M unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_tum_size', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_tum_size\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_tum_size', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_tum_size');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("000", "no mass/tumour found", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("989", "989 mm or larger", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("990", "microinvasion; microscopic focus of foci only and no size given; described as <1mm; stated as T1mi with no other info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("991", "described as <1 cm; stated as T1b with no other info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("992", "described as <2 cm; or >1 cm; or between 1 cm and 2 cm; stated asT1NOS or T1c with no other info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("993", "described as <3 cm; or >2 cm; or between 2 cm and 3 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("994", "described as <4 cm; or >3 cm; or between 3 cm and 4 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("995", "described as <5 cm; or >4 cm; or between 4 cm and 5 cm; stated as T2 with no other info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("996", "mammographic/xerographic dx only, no size given; clinically not palpable", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("997", "Paget disease of nipple with no demonstrable tumor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("998", "diffuse", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf3', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf3\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf3', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf3');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("000", "all ipsilateral axillary lymph nodes examined negative", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("090", "90 or more nodes positive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("095", "positive aspiration of lymph node(s)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("097", "positive nodes, # unspecified", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("098", "no axillary lymph nodes examined", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("099", "unknown if axillary lymph nodes are positive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf4', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf4\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf4', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf4');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("000", "reg nodes negative on H&E, no IHC or unknown if tested for ITCs by IHC; nodes clin neg, not path examined", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("001", "reg nodes negative on H&E, IHC studies negative for tumor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("002", "reg nodes negative on H&E, IHC studies positive for ITCs <= 0.2 mm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("009", "reg nodes negative on H&E, positive for tumor detected by IHC, size of clusters or mets not stated", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("997", "not applicable: CS lymph nodes (COL_nodes) not coded 000", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf5', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf5\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf5', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf5');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("000", "reg nodes negative on H&E, no RT-PCR MOL studies done (or unknown if done); nodes clin neg, not path examined", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("001", "reg nodes negative on H&E, RT-PCR MOL studies negative for tumor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("002", "reg nodes negative on H&E, RT-PCR MOL studies positive for tumor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("987", "not applicable: CS lymph nodes (COL_nodes) not coded 000", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf6', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf6\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf6', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf6');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("000", "entire tumor reported as invasive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("010", "entire tumor reported as insitu", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("020", "invasive & insitu components present, size of invasive component coded in COL_tum_size", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("030", "invasive & insitu components present, size of entire tumor coded in COL_tum_size & insitu is minimal", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("040", "invasive & insitu components present, size of entire tumor coded in COL_tum_size & insitu is extensive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("050", "invasive & insitu components present, size of entire tumor coded in COL_tum_size & proportions unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("060", "invasive & insitu components present, unknown size of tumor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("987", "unknown if invasive & insitu components present, unknown if tumor size represents mixed or pure tumor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf7', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf7\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf7', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf7');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("030", "score of 3", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("040", "score of 4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("050", "score of 5", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("060", "score of 6", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("070", "score of 7", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("080", "score of 8", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("090", "score of 9", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("110", "low grade, BR grade 1, score not given", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("120", "medium (intermediate) grade, BR grade 2, score not given", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("130", "high grade, BR grade 3, score not given", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("998", "no histologic examination of primary site", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "neither BR grade nor BR score given; unknown or no info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf8', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf8\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf8', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf8');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("000", "score 0", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("010", "score of 1+", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("020", "score of 2+", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("030", "score of 3+", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("997", "test ordered, results not in chart", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("998", "test not done (not ordered and not performed)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "unknown or no info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf9', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf9\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf9', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf9');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("010", "positive/elevated", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("020", "negative/normal", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("030", "borderline; equivocal; indeterminate; undetermined whether positive or negative", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("997", "test ordered, results not in chart", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("998", "test not done (not ordered and not performed)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "unknown or no info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf10', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf10\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf10', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf10');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("980", "ratio of 9.80 or greater", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("991", "ratio of less than 1.00", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("997", "test ordered, results not in chart", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("998", "test not done (not ordered and not performed)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "unknown or no info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf11', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf11\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf11', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf11');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("010", "positive/elevated; amplified", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("020", "negative/normal; not amplified", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("030", "borderline; equivocal; indeterminate; undetermined whether positive or negative", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("997", "test ordered, results not in chart", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("998", "test not done (not ordered and not performed)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "unknown or no info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf12', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf12\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf12', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf12');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("980", "mean of 9.80 or greater", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("991", "mean of less than 1.00", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("997", "test ordered, results not in chart", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("998", "test not done (not ordered and not performed)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "unknown or no info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf13', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf13\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf13', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf13');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("010", "positive/elevated; amplified", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("020", "negative/normal; not amplified", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("030", "borderline; equivocal; indeterminate; undetermined whether positive or negative", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("997", "test ordered, results not in chart", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("998", "test not done (not ordered and not performed)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "unknown or no info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf14', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf14\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf14', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf14');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("010", "positive/elevated; amplified", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("020", "negative/normal; not amplified", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("030", "borderline; equivocal; indeterminate; undetermined whether positive or negative", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("997", "test ordered, results not in chart", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("998", "test not done (not ordered and not performed)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "unknown or no info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf16', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf16\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf16', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf16');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("000", "ER neg, PR neg, Her2 neg (triple negative", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("001", "ER neg, PR neg, Her2 pos", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("010", "ER neg, PR pos, Her2 neg", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("011", "ER neg, PR pos, Her2 pos", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("100", "ER pos, PR neg, Her2 neg", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("101", "ER pos, PR neg, Her2 pos", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("111", "ER pos, PR pos, Her2 pos", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", ">=1 test not performed or unknown if performed; >=1 test with unknown/borderline results; unknown/no info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf19', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf19\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf19', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf19');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("000", "no ipsilateral lymph nodes positive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("010", "no nodes examined pathologically: positive nodes on clinical assessment only", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("015", "no nodes examined pathologically: negative nodes on clinical assessment or no clinical assessment", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("020", "positive FNA only", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("025", "positive FNA AND negative lymph node dissection", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("027", "positive FNA AND positive lymph node dissection", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("030", "positive core bx, incisional only", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("040", "positive core bx, excisional only", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("050", "positive core bx, type not specified", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("060", "positive core bx (incisional, excisional, NOS) AND negative lymph node dissection", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("070", "positive core bx (incisional, excisional, NOS) AND positive lymph node dissection", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("100", "positive SLNBx only (no lymph node dissection)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("110", "positive SLNBx AND negative lymph node dissection", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("120", "positive SLNBx AND positive lymph node dissection", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("123", "positive lymph node dissection only (no SLNBx or FNA or core bx)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("125", "positive lymph node dissection AND negative FNA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("127", "positive lymph node dissection AND negative core bx (incisional, excisional, NOS)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("130", "positive lymph node dissection AND negative SLNBx", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("150", "nodes positive, but method of assessment unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "unknown or no info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf22', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf22\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf22', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf22');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("010", "Oncotype DX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("020", "MammaPrint (MammoPrint)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("030", "other'", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("040", "test performed, type of test unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("998", "test not done (not ordered and not performed)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "unknown or no info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_col_ssf23', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_col_ssf23\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_col_ssf23', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_col_ssf23');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("200", "low risk of recurrence (good prognosis)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("300", "intermediate risk of recurrence", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("400", "high risk of recurrence", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("988", "not applicable: info not collected for this case", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("997", "test ordered, results not in chart", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("998", "test not done (not ordered and not performed)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "unknown or no info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_overlap_lesion_onco', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_overlap_lesion_onco\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_overlap_lesion_onco', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_overlap_lesion_onco');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("01", "inner breast", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02", "outer breast", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03", "upper breast", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04", "lower breast", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "unknown - overlapping lesion of breast, location not specified", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "not applicable - site code not C50.8", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "unknown if primary tumour is an overlapping lesion", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_multicentbrstca_onco', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_multicentbrstca_onco\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_multicentbrstca_onco', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_multicentbrstca_onco');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("00", "unicentric", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01", "multicentric", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "unknown if unicentric or multicentric", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_multifocbrstca_onco', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_multifocbrstca_onco\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_multifocbrstca_onco', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_multifocbrstca_onco');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("00", "unifocal", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01", "multifocal", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "unknown if unifocal or multifocal", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_tum_size', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_tum_size\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_tum_size', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_tum_size');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("000", "no mass/tumour found", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("989", "989 mm or larger", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("990", "microinvasion; microscopic focus of foci only and no size given; described as <1mm; stated as T1mi with no other info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("991", "described as <1 cm; stated as T1b with no other info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("992", "described as <2 cm; or >1 cm; or between 1 cm and 2 cm; stated asT1NOS or T1c with no other info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("993", "described as <3 cm; or >2 cm; or between 2 cm and 3 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("994", "described as <4 cm; or >3 cm; or between 3 cm and 4 cm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("995", "described as <5 cm; or >4 cm; or between 4 cm and 5 cm; stated as T2 with no other info", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("996", "mammographic/xerographic dx only, no size given; clinically not palpable", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("997", "Paget disease of nipple with no demonstrable tumor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("998", "diffuse", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_posnodes', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_posnodes\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_posnodes', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_posnodes');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("90", "90 or more positive nodes", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("95", "positive aspiration or core bx of lymph node(s)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("97", "positive nodes - number unspecified", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("98", "no nodes examined", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "unknown if nodes are positive; n/a", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_totnodes', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_totnodes\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_totnodes', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_totnodes');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "no nodes removed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("95", "aspiration or core bx of nodes only", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("96", "node removal documented as sampling, # unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("97", "node removal documented as dissection, # unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("98", "nodes removed, # unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "unknown if nodes removed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_COL_nodes', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_COL_nodes\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_COL_nodes', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_COL_nodes');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("000", "No regional lymph node involvement. OR isolated tumor cells (ITCs) detected by  immunohistochemistry/immunohistochemical (IHC) methods or molecular methods ONLY.  ", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("050", "Evaluated pathologically: None; no regional lymph node involvement. BUT ITCs detected on routine hematoxylin and eosin (H and E) stains. ", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("130", "Evaluated pathologically: Axillary lymph node(s), ipsilateral, micrometastasis ONLY detected by IHC ONLY. (At least one micrometastasis greater than 0.2 mm  or more than 200 cells  AND all micrometastases less than or equal to 2 mm)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("150", "Evaluated pathologically: Axillary lymph node(s), ipsilateral, micrometastasis ONLY detected or verified on H&E. (At least one micrometastasis greater than 0.2 mm or more than 200 cells AND all micrometastases less than or equal to 2 mm). Micrometastasis, NOS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("155", "Evaluated pathologically: Stated as N1mi with no other information on regional lymph nodes", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("250", "Evaluated pathologically: Movable axillary lymph node(s), ipsilateral, positive with more than micrometastasis. (At least one metastasis greater than 2 mm) ", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("255", "Evaluated clinically: Clinically movable axillary lymph node(s), ipsilateral, positive. (Clinical assessment because of neoadjuvant therapy or no pathology) ", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("257", "Evaluated clinically: Clinically stated only as N1. (Clinical assessment because of neoadjuvant therapy or no pathology)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("258", "Evaluated pathologically: Pathologically stated only as N1 [NOS], no information on which nodes were involved", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("260", "Stated as N1 [NOS] with no other information on regional lymph nodes", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("510", "Evaluated clinically: Fixed/matted ipsilateral axillary nodes clinically (Clinical assessment because of neoadjuvant therapy or no pathology). Stated clinically as N2a (Clinical assessment because of neoadjuvant therapy or no pathology)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("520", "Evaluated pathologically: Fixed/matted ipsilateral axillary nodes clinically with pathologic involvement of lymph nodes WITH at least one metastasis greater than 2 mm", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("600", "Axillary/regional lymph node(s), NOS. Lymph nodes, NOS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("610", "Evaluated clinically: Clinically stated only as N2 [NOS]. (Clinical assessment because of neoadjuvant therapy or no pathology)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("620", "Evaluated pathologically: Pathologically stated only as N2 [NOS]; no information on which nodes were involved", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("720", "Evaluated pathologically: Internal mammary node(s), ipsilateral, positive on sentinel nodes but not clinically apparent. (No positive imaging or clinical exam) WITH axillary lymph node(s), ipsilateral", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("740", "Internal mammary node(s), ipsilateral, clinically apparent (On imaging or clinical exam) WITHOUT axillary lymph node(s), ipsilateral", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("748", "Stated as N2b with no other information on regional lymph nodes", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("750", "Infraclavicular lymph node(s)(subclavicular) (level III axillary nodes) (apical), ipsilateral WITH or WITHOUT axillary nodes(s) WITHOUT internal mammary node(s)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("800", "Supraclavicular node(s), ipsilateral", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("805", "Stated as N3c with no other information on regional lymph nodes", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("810", "Evaluated clinically: Clinically stated only as N3 [NOS].", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("815", "Evaluated pathologically: Pathologically stated only as N3 [NOS]; no information on which nodes were involved", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("820", "Stated as N3, NOS with no other information on regional lymph nodes", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "Unknown; regional lymph nodes not stated.Regional lymph node(s) cannot be assessed. Not documented in patient record", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_COL_nodes_eval', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_COL_nodes_eval\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_COL_nodes_eval', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_COL_nodes_eval');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "no reg nodes removed; eval based on non-invasive clinical evidence; no autopsy evidence used", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "no reg nodes removed; eval based on endocsopic exam or invasive bx; or FNA, core, bx of l.n without removal of primary", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "no reg nodes removed, but evidence derived from autopsy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "any micro assessment of nodes with removal of primary or any micro assessment of a node in the highest N category", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("5", "reg nodes removed AFTER neoadj tx and node eval based on clin evidence, unless path evidence at surgery more extensive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("6", "reg nodes removed AFTER neoadj tx and node eval based on path evidence (more extensive than clin evidence before tx)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("8", "evidence form autopsy only (tumor unsuspected or undiagnosed prior to autopys)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("9", "unknown if lymph nodes removed; not assessed; unknown if assessed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_radiologicconfirmFWL_onco', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_radiologicconfirmFWL_onco\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_radiologicconfirmFWL_onco', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_radiologicconfirmFWL_onco');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("00", "FWL procedure performed, no specimen image done", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01", "FWL procedure performed, specimen image done, and lesion is seen within image", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02", "FWL procedure performed, specimen image done, and lesion is not seen within image", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03", "FWL procedure performed, specimen image done, and image report does not state if the lesion is seen or not", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("66", "FWL procedure performed, specimen image done, but report is not available and result is not available in other chart documentation", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "FWL procedure performed, unknown if specimen image done", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "Not applicable – no FWL procedure performed at initial diagnosis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "Unknown if patient had a FWL procedure performed at initial diagnosis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_recon_final', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_recon_final\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_recon_final', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_recon_final');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("00", "Full mastectomy at initial diagnosis, no breast reconstruction documented", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01", "Full mastectomy at initial diagnosis, breast reconstruction performed prior to first relapse", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02", "Full mastectomy at initial diagnosis, breast reconstruction performed after first relapse", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("66", "Full mastectomy at initial diagnosis, breast reconstruction performed, but unable to determine if performed before or after first relapse", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "Full mastectomy at initial diagnosis, unknown if breast reconstruction performed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "Not applicable – no full mastectomy at initial diagnosis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "Unknown if a full mastectomy was performed OR unknown when a full mastectomy was performed AND there is no information about breast reconstruction", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_surgspecimenoriented_onco', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_surgspecimenoriented_onco\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_surgspecimenoriented_onco', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_surgspecimenoriented_onco');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("00", "Specimen(s) from first open surgical procedure performed as part of the initial treatment plan was not oriented", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01", "Specimen(s) from first open surgical procedure performed as part of the initial treatment plan was oriented", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02", "Multiple specimens from first open surgical procedure performed as part of the initial treatment plan, with at least one specimen oriented and at least one specimen not oriented", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("66", "Unknown if specimen(s) from first open surgical procedure performed as part of the initial treatment plan was oriented (no documentation in reports)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "Unknown if specimen(s) from first open surgical procedure performed as part of the initial treatment plan was oriented (no reports available)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "Not applicable – no open surgical procedure performed at initial diagnosis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "Unknown if patient had open surgical procedure performed on the breast at initial diagnosis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_postr_deepmarg_onco', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_postr_deepmarg_onco\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_postr_deepmarg_onco', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_postr_deepmarg_onco');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("00", "Open surgical procedure performed on the breast at initial diagnosis, with dissection not taken down to the chest wall", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01", "Open surgical procedure performed on the breast at initial diagnosis, with dissection taken down to the chest wall and pectoralis fascia removed (includes total or partial removal)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02", "Open surgical procedure performed on the breast at initial diagnosis, with dissection taken down to the chest wall and pectoralis fascia not removed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03", "Open surgical procedure performed on the breast at initial diagnosis, with dissection taken down to the chest wall and unknown if pectoralis fascia removed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("66", "Open surgical procedure performed on the breast at initial diagnosis, unknown if dissection was taken down to the chest wall (no documentation in reports)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "Open surgical procedure performed on the breast at initial diagnosis, unknown if dissection was taken down to the chest wall (no reports available)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "Not applicable – no open surgical procedure performed on the breast at initial diagnosis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "Unknown if patient had open surgical procedure performed on the breast at initial diagnosis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_ant_tiss_onco', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_ant_tiss_onco\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_ant_tiss_onco', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_ant_tiss_onco');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("00", "No more breast tissue remaining anterior to the surgical cavity in any BCS procedure performed at initial diagnosis in patients whose definitive surgery is BCS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01", "More breast tissue remaining anterior to the surgical cavity in any BCS procedure performed at initial diagnosis in patients whose definitive surgery is BCS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("66", "Amount of breast tissue remaining anterior to the surgical cavity is unknown in all BCS procedures performed at initial diagnosis in patients whose definitive surgery is BCS (no documentation in reports)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "Amount of breast tissue remaining anterior to the surgical cavity is unknown in all BCS procedures performed at initial diagnosis in patients whose definitive surgery is BCS (no reports available)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "Not applicable – no open BCS procedure performed at initial diagnosis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "Unknown if patient had open BCS procedure performed at initial diagnosis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_clipmarkingbxcavity_onco', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_clipmarkingbxcavity_onco\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_clipmarkingbxcavity_onco', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_clipmarkingbxcavity_onco');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("00", "Initial BCS performed, breast cavity not marked with clips", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01", "Initial BCS performed, breast cavity marked with clips", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02", ">1 BCS performed at initial diagnosis, with breast cavity marked with clips in at least 1 of the BCS procedures", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("66", "BCS performed, unknown if breast cavity marked with clips (no documentation in reports)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "BCS performed, unknown if breast cavity marked with clips (no reports available)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "Not applicable – no BCS performed as part of initial treatment plan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "Unknown if BCS performed as part of initial treatment plan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_closeposmargintype_onco', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_closeposmargintype_onco\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_closeposmargintype_onco', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_closeposmargintype_onco');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("00", "No close and/or positive margins", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01", "Close or positive posterior margin only", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02", "Close or positive anterior margin only", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03", "Close or positive posterior and anterior margins only", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04", "Other close or positive margins", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05", "Unspecified close or positive margins", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("66", "Open surgical procedure performed, margin status unknown (no documentation in reports or ambiguous terms only)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "Open surgical procedure performed, margin status unknown (reports not available)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "Not applicable – no open surgical procedure performed at initial diagnosis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "Unknown if patient had open surgical procedure performed on the breast at initial diagnosis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_sentnodes', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_sentnodes\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_sentnodes', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_sentnodes');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "no positive sentinel lymph nodes examined", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("66", "done, results unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "positive, # unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "not done/abandoned", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "unknown if done", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_SLNB', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_SLNB\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_SLNB', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_SLNB');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "SLNBx not done", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "SLNB done, all SLNs negative", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "SLNB done, >=1 SLN positive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("55", "SLNB done, no nodes recovered", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("66", "SLNB done, results unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "SLNB attempted but abandoned because no radioactive or blue sentinel lymph nodes were identified", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "unknown if SLNB done", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_her2_tissuesite', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_her2_tissuesite\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_her2_tissuesite', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_her2_tissuesite');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "No HER2/neu testing with performed at any time", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "HER2 testing performed on primary tumour and/or regional nodes from the initial diagnosis site only", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "HER2 testing performed on metastatic (M1) or relapse site(s) only", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "HER2 testing performed on (1) primary tumour and/or regional nodes AND on (2) tissue from metastatic (M1) or relapse site(s)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "Unknown site of HER2 testing", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "Unknown if HER2 testing was performed at any time", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_her2neulab_initdx', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_her2neulab_initdx\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_her2neulab_initdx', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_her2neulab_initdx');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "no her2 testing done at initial dx", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "her2 testing at initial dx done at BCCA lab", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "her2 testing at initial dx done at outside lab", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "lab where her2 testing done at initial dx unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "unknown if her2 testing done at initial dx", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_her2neulabatrecur_onco', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_her2neulabatrecur_onco\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_her2neulabatrecur_onco', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_her2neulabatrecur_onco');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "no her2 testing performed at recurrence", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "her2 testing at recurrence performed at BCCA lab", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "her2 testing at recurrence performed at an outside lab", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "lab where her2 testing was performed at recurrence unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "not applicable - no recurrence at time of coding", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "unknown if her2 testing was perforomed at recurrence", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_init_finrt', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_init_finrt\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_init_finrt', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_init_finrt');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "no initial breast/chest wall or nodal RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "initial breast/chest wall RT alone", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "initial breast/chest wall RT + regional nodal RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "regional nodal RT alone", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4", "brachy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_trt_region', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_trt_region\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_trt_region', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_trt_region');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("ABD", "ABDOMEN NOS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ABL", "ABDOMEN-LOWER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ABLL", "ABDOMEN-LOWER LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ABLR", "ABDOMEN-LOWER RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ABU", "ABDOMEN-UPPER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ABUL", "ABDOMEN-UPPER LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ABUR", "ABDOMEN-UPPER RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ABW", "ABDOMEN-WHOLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ADR", "ADRENAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ADRB", "ADRENAL-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ADRL", "ADRENAL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ADRR", "ADRENAL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AIS", "AXI+IM+SUPRACLAV", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AISL", "AXI+IM+SUPRACLAV-LT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AISR", "AXI+IM+SUPRACLAV-RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ANK", "ANKLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ANKB", "ANKLE-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ANKL", "ANKLE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ANKR", "ANKLE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ANT", "ANTRUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ANTL", "ANTRUM-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ANTR", "ANTRUM-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ANU", "ANUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ARM", "ARM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ARMB", "ARM-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ARML", "ARM-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ARMR", "ARM-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AXI", "AXILLA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AXIB", "AXILLA-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AXIL", "AXILLA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AXIR", "AXILLA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AXS", "AXILLA + SUPRACLAV NODE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AXSL", "AXILLA + SUPRACLAV N-LT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AXSR", "AXILLA + SUPRACLAV N-RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BAC", "BACK", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BACL", "BACK-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BACR", "BACK-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BAX", "BREAST + AXILLA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BAXL", "BREAST + AXILLA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BAXR", "BREAST + AXILLA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BIL", "BILE DUCT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BLA", "BLADDER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BLAL", "BLADDER-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BLAR", "BLADDER-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BLH", "LOWER HALF BODY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BLI", "BOTH LIP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BLIL", "BOTH LIP-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BLIR", "BOTH LIP-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BON2", "BONE-2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BON3", "BONE-3", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BON4", "BONE-4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BON5", "BONE-5", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BON6", "BONE-6", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BON7", "BONE-7", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BON8", "BONE-8", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BON9", "BONE-9", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BONB", "BONE-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BONL", "BONE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BONM", "BONE-MULTIPLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BONR", "BONE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BPA", "BODY-PARTIAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BPL", "BREAST PARTIAL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BPR", "BREAST PARTIAL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRA", "BRAIN", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRAL", "BRAIN-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRAR", "BRAIN-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRB", "BRAIN BOOST", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRBL", "BRAIN-BOOST-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRBR", "BRAIN-BOOST-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BREP", "BREAST-PARTIAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRF", "BREAST-OFF", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRFB", "BREAST-OFF-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRFL", "BREAST-OFF-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRFR", "BREAST-OFF-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRH", "BRAIN HALF", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRHL", "BRAIN-HALF-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRHR", "BRAIN-HALF-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRIL", "BREAST+IMC-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRIR", "BREAST+IMC-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRO", "BREAST-ON", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BROB", "BREAST-ON-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BROL", "BREAST-ON-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRON", "BRONCHUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BROR", "BREAST-ON-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRP", "BRAIN-PARTIAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRPL", "BRAIN-PARTIAL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRPR", "BRAIN-PARTIAL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRQ", "BRAIN QUARTER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRQL", "BRAIN-QUARTER-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRQR", "BRAIN-QUARTER-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BRW", "BRAIN WHOLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BUC", "BUCCAL MUCOSA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BUCL", "BUCCAL MUCOSA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BUCR", "BUCCAL MUCOSA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BUH", "UPPER HALF BODY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BUT", "BUTTOCKS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BUTB", "BUTTOCKS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BUTL", "BUTTOCKS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BUTR", "BUTTOCKS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CBS", "CEREBROSPINAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CER", "CERVIX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CHE", "CHEST", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CHEL", "CHEST-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CHER", "CHEST-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CHN", "CHEST + NECK", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CHNL", "CHEST + NECK - LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CHNR", "CHEST + NECK - RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CHS", "CHEST + SUPRACLAV NODE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CHSL", "CHEST & SUPRACLAV NODE-LT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CHSR", "CHEST + SUPRACLAV NODE-RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CHW", "CHEST WALL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CHWL", "CHEST WALL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CHWR", "CHEST WALL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CLA", "CLAVICLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CLAB", "CLAVICLE-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CLAL", "CLAVICLE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CLAR", "CLAVICLE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("COC", "COCCYX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("COL", "COLON", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("COLL", "COLON-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("COLR", "COLON-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CSP", "CERVICAL SPINE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CTS", "CERVICAL & THORACIC SPINE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CWIL", "CHEST WALL+IMC-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CWIR", "CHEST WALL+IMC-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EAR", "EAR", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EARB", "EAR-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EARL", "EAR-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EARR", "EAR-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EPI", "EPIGASTRIUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ESL", "ESOPHAGUS-LOWER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ESM", "ESOPHAGUS-MIDDLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ESO", "ESOPHAGUS-NOS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ESU", "ESOPHAGUS-UPPER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ETH", "ETHMOID SINUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EXT", "EXTENDED FIELD", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EYE", "EYE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EYEB", "EYE-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EYEL", "EYE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EYER", "EYE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FAC", "FACE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FACL", "FACE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FACR", "FACE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FAL", "FALLOPIAN TUBES", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FALB", "FALLOPIAN TUBE-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FALL", "FALLOPIAN TUBE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FALR", "FALLOPIAN TUBE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FEM", "FEMUR", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FEMB", "FEMUR-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FEML", "FEMUR-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FEMR", "FEMUR-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FIB", "FIBULA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FIBB", "FIBULA-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FIBL", "FIBULA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FIBR", "FIBULA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FIN", "FINGER (INCLUDES THUMB)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FINB", "FINGER(INCL.THUMB)-BIL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FINL", "FINGER(INCL.THUMB)-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FINR", "FINGER(INCL.THUMB)-RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FLA", "FLANK", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FLAL", "FLANK-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FLAR", "FLANK-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FLO", "FLOOR OF MOUTH", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FLOL", "FLOOR OF MOUTH-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FLOR", "FLOOR OF MOUTH-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FOO", "FOOT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FOOB", "FOOT-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FOOL", "FOOT-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FOOR", "FOOT-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FOS", "POSTERIOR FOSSA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FRO", "FRONTAL SINUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GAL", "GALL BLADDER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GIN", "GINGIVA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GINL", "GINGIVA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GINR", "GINGIVA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HAN", "HAND", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HANB", "HAND-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HANL", "HAND-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HANR", "HAND-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HDN", "HEAD AND NECK", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HDNL", "HEAD AND NECK-Left", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HDNR", "HEAD AND NECK-Right", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HEA", "HEAD", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HEAL", "HEAD-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HEAR", "HEAD-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HEE", "HEEL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HEEB", "HEEL-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HEEL", "HEEL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HEER", "HEEL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HER", "HEART", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HIP", "HIP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HIPB", "HIP-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HIPL", "HIP-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HIPR", "HIP-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HUM", "HUMERUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HUMB", "HUMERUS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HUML", "HUMERUS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HUMR", "HUMERUS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HYP", "HYPOPHARYNX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ICA", "INNER CANTHUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ICAB", "INNER CANTHUS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ICAL", "INNER CANTHUS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ICAR", "INNER CANTHUS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ILI", "ILIUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ILIL", "ILIUM-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ILIR", "ILIUM-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ING", "INGUINAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("INGB", "INGUINAL-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("INGL", "INGUINAL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("INGR", "INGUINAL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("INM", "INT.MAMMARY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("INMB", "INT.MAMMARY-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("INML", "INT.MAMMARY-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("INMR", "INT.MAMMARY-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ISC", "ISCHIUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JAW", "MANDIBLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JAWL", "MANDIBLE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JAWR", "MANDIBLE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KID", "KIDNEY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KIDB", "KIDNEY-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KIDL", "KIDNEY-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KIDR", "KIDNEY-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KNE", "KNEE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KNEB", "KNEE-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KNEL", "KNEE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KNER", "KNEE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LAC", "LACRIMAL GLAND", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LACB", "LACRIMAL GLAND-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LACL", "LACRIMAL GLAND-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LACR", "LACRIMAL GLAND-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LAR", "LARYNX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LEG", "LEG", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LEGB", "LEG-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LEGL", "LEG-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LEGR", "LEG-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LID", "EYELID", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LIDB", "EYELID-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LIDL", "EYELID-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LIDR", "EYELID-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LIV", "LIVER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LLB", "LIMB-LOWER-BONE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LLBL", "LIMB-LOWER-BONE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LLBR", "LIMB-LOWER-BONE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LLI", "LOWER LIP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LLIL", "LOWER LIP-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LLIR", "LOWER LIP-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LSP", "LUMBAR SPINE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LSS", "LUMBOSACRAL SPINE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LUB", "LIMB-UPPER-BONE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LUBL", "LIMB-UPPER-BONE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LUBR", "LIMB-UPPER-BONE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LUN", "LUNG", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LUNB", "LUNG-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LUNL", "LUNG-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LUNR", "LUNG-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MAN", "MANTLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MAX", "MAXILLA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MAXL", "MAXILLA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MAXR", "MAXILLA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MED", "MEDIASTINUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MUL", "MULTIPLE REGIONS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NAC", "NASAL CAVITY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NACL", "NASAL CAVITY-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NACR", "NASAL CAVITY-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NAF", "NASOLABIAL FOLD", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NAS", "NASOPHARYNX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NEC", "NECK (INCLUDES NODES)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NECB", "NECK(INCL.NODES)-BIL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NECL", "NECK(INCL.NODES)-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NECR", "NECK(INCL.NODES)-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NELB", "NECK LOWER-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NELL", "NECK LOWER-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NELR", "NECK LOWER-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NOD", "NODAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NOS", "NOSE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NOSL", "NOSE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NOSR", "NOSE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("OCA", "OUTER CANTHUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("OCAB", "OUTER CANTHUS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("OCAL", "OUTER CANTHUS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("OCAR", "OUTER CANTHUS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ORA", "ORAL CAVITY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ORAL", "ORAL CAVITY-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ORAR", "ORAL CAVITY-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ORB", "ORBIT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ORBB", "ORBIT-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ORBL", "ORBIT-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ORBR", "ORBIT-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ORO", "OROPHARYNX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("OVA", "OVARY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("OVAB", "OVARY-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("OVAL", "OVARY-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("OVAR", "OVARY-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PAH", "PALATE HARD", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PAHL", "PALATE HARD-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PAHR", "PALATE HARD-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PAL", "PALATE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PAN", "PANCREAS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PAO", "PARA-AORTIC", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PAOL", "PARA-AORTIC-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PAOR", "PARA-AORTIC-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PAP", "PARA-AORT&PELVIS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PAR", "PAROTID", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PARB", "PAROTID-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PARL", "PAROTID-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PARR", "PAROTID-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PAS", "PALATE SOFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PASL", "PALATE SOFT-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PASR", "PALATE SOFT-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PBO", "PELVIS BONES, NOS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PBOB", "PELVIS BONES-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PBOL", "PELVIS BONES-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PBOR", "PELVIS BONES-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PEL", "PELVIS, NOS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PELB", "PELVIS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PELL", "PELVIS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PELR", "PELVIS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PEN", "PENIS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PER", "PERINEUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PHA", "PHARYNX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PHAL", "PHARYNX-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PHAR", "PHARYNX-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PIT", "PITUITARY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PLE", "PLEURA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PLEB", "PLEURA - BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PLEL", "PLEURA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PLER", "PLEURA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PLN", "PELVIC LYMPH NODES", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("POL", "PELVIC ORGAN &LYMPH NODES", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PRO", "PROSTATE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PUB", "PUBIS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PUBB", "PUBIS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PUBL", "PUBIS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PUBR", "PUBIS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RAD", "RADIUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RADB", "RADIUS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RADL", "RADIUS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RADR", "RADIUS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("REC", "RECTUM (INCLUDES SIGMOID)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RET", "RETROPERITONEUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RIB", "RIB(S)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RIBB", "RIB(S)-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RIBL", "RIB(S)-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RIBR", "RIB(S)-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SAC", "SACRUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SACL", "SACRUM-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SACR", "SACRUM-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCA", "SCAPULA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCAB", "SCAPULA-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCAL", "SCAPULA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCAR", "SCAPULA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCN", "SUPRACLAVICULAR NODES", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCNB", "SUPRACLAVICULAR NODES-BIL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCNL", "SUPRACLAVICULAR NODES-LT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCNR", "SUPRACLAVICULAR NODES-RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCP", "SCALP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCPB", "SCALP-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCPL", "SCALP-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCPR", "SCALP-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCR", "SCROTUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCRB", "SCROTUM-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCRL", "SCROTUM-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCRR", "SCROTUM-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SHO", "SHOULDER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SHOB", "SHOULDER-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SHOL", "SHOULDER-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SHOR", "SHOULDER-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKI", "SKIN", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKI2", "SKIN-2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKI3", "SKIN-3", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKI4", "SKIN-4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKI5", "SKIN-5", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKI6", "SKIN-6", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKI7", "SKIN-7", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKI8", "SKIN-8", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKI9", "SKIN-9", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKIL", "SKIN-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKIM", "SKIN-MULTIPLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKIR", "SKIN-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKU", "SKULL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKUL", "SKULL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKUR", "SKULL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SPH", "SPHENOID SINUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SPHL", "SPHENOID SINUS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SPHR", "SPHENOID SINUS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SPL", "SPLEEN", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SPN", "SPINE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SPT", "THORACIC & LUMBAR SPINE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("STE", "STERNUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("STO", "STOMACH", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SUB", "SUBMANDIBULAR GLANDS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SUBB", "SUBMANDIBULAR GLAND-BIL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SUBL", "SUBMANDIBULAR GLAND-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SUBR", "SUBMANDIBULAR GLAND-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TES", "TESTIS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TESB", "TESTIS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TESL", "TESTIS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TESR", "TESTIS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("THY", "THYROID", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TIB", "TIBIA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TIBB", "TIBIA-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TIBL", "TIBIA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TIBR", "TIBIA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TNG", "TONGUE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TNGL", "TONGUE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TNGR", "TONGUE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TOE", "TOE(S)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TOEB", "TOE-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TOEL", "TOE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TOER", "TOE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TON", "TONSIL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TONL", "TONSIL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TONR", "TONSIL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TRA", "TRACHEA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TSP", "THORACIC SPINE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("UKN", "UNKNOWN", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ULI", "UPPER LIP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ULIL", "UPPER LIP-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ULIR", "UPPER LIP-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ULN", "ULNA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ULNB", "ULNA-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ULNL", "ULNA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ULNR", "ULNA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("URE", "URETER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("UREL", "URETER-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("URER", "URETER-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("URT", "URETHRA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("USL", "UNSPECIFIED LIP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("UTE", "UTERUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("UTEL", "UTERUS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("UTER", "UTERUS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("UTVA", "UTERUS AND VAGINA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("UVU", "UVULA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("VAG", "VAGINA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("VUL", "VULVA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("WAR", "WALDEYER'S RING", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("WHB", "WHOLE BODY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_tech', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_tech\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_tech', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_tech');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("01", "SINGLE FIELD R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01A", "SINGLE FIELD-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01B", "SINGLE FIELD-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01C", "SINGLE FIELD-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01D", "SINGLE FIELD-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01E", "SINGLE FIELD-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01F", "SINGLE FIELD-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01G", "SINGLE FIELD-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01H", "SINGLE FIELD-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01I", "SINGLE FIELD-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01J", "SINGLE FIELD-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01K", "SINGLE FIELD-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01L", "SINGLE FIELD-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01M", "SINGLE FIELD-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01N", "SINGLE FIELD-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01R", "SINGLE FIELD-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01S", "SINGLE FIELD-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01U", "SINGLE FIELD-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02", "2 FIELDS PARA R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02A", "2 FIELDS PARA-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02B", "2 FIELDS PARA-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02C", "2 FIELDS PARA-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02D", "2 FIELDS PARA-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02E", "2 FIELDS PARA-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02F", "2 FIELDS PARA-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02G", "2 FIELDS PARA-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02H", "2 FIELDS PARA-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02I", "2 FIELDS PARA-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02J", "2 FIELDS PARA-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02K", "2 FIELDS PARA-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02L", "2 FIELDS PARA-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02M", "2 FIELDS PARA-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02N", "2 FIELDS PARA-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02O", "2 FIELDS PARA-O R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02R", "2 FIELDS PARA-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02S", "2 FIELDS PARA-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02U", "2 FIELDS PARA-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03", "2 FIELDS TANG R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03A", "2 FIELDS TANG-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03B", "2 FIELDS TANG-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03C", "2 FIELDS TANG-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03D", "2 FIELDS TANG-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03E", "2 FIELDS TANG-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03F", "2 FIELDS TANG-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03G", "2 FIELDS TANG-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03H", "2 FIELDS TANG-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03I", "2 FIELDS TANG-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03J", "2 FIELDS TANG-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03K", "2 FIELDS TANG-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03L", "2 FIELDS TANG-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03M", "2 FIELDS TANG-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03N", "2 FIELDS TANG-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03R", "2 FIELDS TANG-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03S", "2 FIELDS TANG-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04", "2 FIELDS OTHER R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04A", "2 FIELDS-OTHE-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04B", "2 FIELDS-OTHE-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04C", "2 FIELDS-OTHE-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04D", "2 FIELDS-OTHE-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04E", "2 FIELDS-OTHE-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04F", "2 FIELDS-OTHE-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04G", "2 FIELDS-OTHE-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04H", "2 FIELDS-OTHE-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04I", "2 FIELDS-OTHE-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04J", "2 FIELDS-OTHE-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04K", "2 FIELDS-OTHE-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04L", "2 FIELDS-OTHE-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04M", "2 FIELDS-OTHE-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04N", "2 FIELDS OTHE-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04R", "2 FIELDS-OTHE-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04S", "2 FIELDS OTHE-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04U", "2 FIELDS OTHE-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05", "3 FIELDS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05A", "3 FIELDS-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05B", "3 FIELDS-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05C", "3 FIELDS-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05D", "3 FIELDS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05E", "3 FIELDS-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05F", "3 FIELDS-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05G", "3 FIELDS-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05H", "3 FIELDS-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05I", "3 FIELDS-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05J", "3 FIELDS-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05K", "3 FIELDS-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05L", "3 FIELDS-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05M", "3 FIELDS-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05N", "3 FIELDS-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05R", "3 FIELDS-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05S", "3 FIELDS-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05U", "3 FIELDS-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06", "4 FIELDS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06A", "4 FIELDS-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06B", "4 FIELDS-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06C", "4 FIELDS-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06D", "4 FIELDS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06E", "4 FIELDS-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06F", "4 FIELDS-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06G", "4 FIELDS-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06H", "4 FIELDS-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06I", "4 FIELDS-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06J", "4 FIELDS-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06K", "4 FIELDS-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06L", "4 FIELDS-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06M", "4 FIELDS-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06N", "4 FIELDS-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06R", "4 FIELDS-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06S", "4 FIELDS-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07", "5 FIELDS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07A", "5 FIELDS-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07B", "5 FIELDS-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07C", "5 FIELDS-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07D", "5 FIELDS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07E", "5 FIELDS-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07F", "5 FIELDS-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07G", "5 FIELDS-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07H", "5 FIELDS-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07I", "5 FIELDS-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07J", "5 FIELDS-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07K", "5 FIELDS-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07L", "5 FIELDS-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07M", "5 FIELDS-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07N", "5 FIELDS-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07R", "5 FIELDS-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07S", "5 FIELDS-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08", "BREAST R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08A", "BREAST-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08B", "BREAST-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08C", "BREAST-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08D", "BREAST-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08E", "BREAST-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08F", "BREAST-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08G", "BREAST-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08H", "BREAST-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08I", "BREAST-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08J", "BREAST-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08K", "BREAST-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08L", "BREAST-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08M", "BREAST-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08N", "BREAST-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08R", "BREAST-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08U", "BREAST-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09", "BREAST-CHE WALL R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09A", "BREAST-CH WAL-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09B", "BREAST-CH WAL-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09C", "BREAST-CH WAL-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09D", "BREAST-CH WAL-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09E", "BREAST-CH WAL-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09F", "BREAST-CH WAL-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09G", "BREAST-CH WAL-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09H", "BREAST-CH WAL-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09I", "BREAST-CH WAL-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09J", "BREAST-CH WAL-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09K", "BREAST-CH WAL-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09L", "BREAST-CH WAL-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09M", "BREAST-CH WAL-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09N", "BREAST CH WAL-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09R", "BREAST-CH WAL-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09U", "BREAST-CH WAL-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10", "BREAST-NODAL R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10A", "BREAST-NODAL-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10B", "BREAST-NODAL-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10C", "BREAST-NODAL-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10D", "BREAST-NODAL-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10E", "BREAST-NODAL-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10F", "BREAST-NODAL-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10G", "BREAST-NODAL-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10H", "BREAST-NODAL-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10I", "BREAST-NODAL-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10J", "BREAST-NODAL-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10K", "BREAST-NODAL-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10L", "BREAST-NODAL-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10M", "BREAST-NODAL-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10N", "BREAST NODAL-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11", "BREAST-BOOST R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11A", "BREAST-BOOST-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11B", "BREAST-BOOST-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11C", "BREAST-BOOST-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11D", "BREAST-BOOST-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11E", "BREAST-BOOST-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11F", "BREAST-BOOST-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11G", "BREAST-BOOST-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11H", "BREAST-BOOST-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11I", "BREAST-BOOST-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11J", "BREAST-BOOST-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11K", "BREAST-BOOST-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11L", "BREAST-BOOST-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11M", "BREAST-BOOST-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11N", "BREAST-BOOST-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11R", "BREAST-BOOST-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12", "MULTIPLE FIELD R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12A", "MULT FIELD-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12B", "MULT FIELD-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12C", "MULT FIELD-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12D", "MULT FIELD-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12E", "MULT FIELD-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12F", "MULT FIELD-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12G", "MULT FIELD-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12H", "MULT FIELD-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12I", "MULT FIELD-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12J", "MULT FIELD-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12K", "MULT FIELD-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12L", "MULT FIELD-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12M", "MULT FIELD-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12N", "MULT FIELD-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12R", "MULT FIELD-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13", "CRANIAL IRRADIA R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13A", "CRANIAL IRR-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13B", "CRANIAL IRR-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13C", "CRANIAL IRR-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13D", "CRANIAL IRR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13E", "CRANIAL IRR-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13F", "CRANIAL IRR-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13G", "CRANIAL IRR-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13H", "CRANIAL IRR-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13I", "CRANIAL IRR-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13J", "CRANIAL IRR-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13K", "CRANIAL IRR-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13L", "CRANIAL IRR-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13M", "CRANIAL IRR-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13N", "CRANIAL IRR-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13R", "CRANIAL IRR-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14", "CEREBROSP IRRAD R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14A", "CEREBROSP IRR-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14B", "CEREBROSP IRR-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14C", "CEREBROSP IRR-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14D", "CEREBROSP IRR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14E", "CEREBROSP IRR-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14F", "CEREBROSP IRR-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14G", "CEREBROSP IRR-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14H", "CEREBROSP IRR-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14I", "CEREBROSP IRR-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14J", "CEREBROSP IRR-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14K", "CEREBROSP IRR-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14L", "CEREBROSP IRR-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14M", "CEREBROSP IRR-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14N", "CEREBROSP IRR-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14R", "CEREBROSP IRR-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15", "MANTLE-LONG R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15A", "MANTLE-LONG-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15B", "MANTLE-LONG-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15C", "MANTLE-LONG-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15D", "MANTLE-LONG-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15E", "MANTLE-LONG-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15F", "MANTLE-LONG-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15G", "MANTLE-LONG-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15H", "MANTLE-LONG-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15I", "MANTLE-LONG-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15J", "MANTLE-LONG-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15K", "MANTLE-LONG-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15L", "MANTLE-LONG-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15M", "MANTLE-LONG-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15N", "MANTLE-LONG-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15R", "MANTLE-LONG-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16", "MANTLE-SHORT R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16A", "MANTLE-SHORT-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16B", "MANTLE-SHORT-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16C", "MANTLE-SHORT-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16D", "MANTLE-SHORT-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16E", "MANTLE-SHORT-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16F", "MANTLE-SHORT-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16G", "MANTLE-SHORT-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16H", "MANTLE-SHORT-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16I", "MANTLE-SHORT-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16J", "MANTLE-SHORT-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16K", "MANTLE-SHORT-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16L", "MANTLE-SHORT-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16M", "MANTLE-SHORT-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16N", "MANTLE-SHORT-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16R", "MANTLE-SHORT-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17", "MANTLE-MODIFIED R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17A", "MANTLE-MODIF-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17B", "MANTLE-MODIF-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17C", "MANTLE-MODIF-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17D", "MANTLE-MODIF-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17E", "MANTLE-MODIF-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17F", "MANTLE-MODIF-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17G", "MANTLE-MODIF-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17H", "MANTLE-MODIF-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17I", "MANTLE-MODIF-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17J", "MANTLE-MODIF-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17K", "MANTLE-MODIF-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17L", "MANTLE-MODIF-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17M", "MANTLE-MODIF-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17N", "MANTLE-MODIF-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17R", "MANTLE-MODIF-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18", "ABDOMINAL IRRAD R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18A", "ABDOMINAL IRR-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18B", "ABDOMINAL IRR-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18C", "ABDOMINAL IRR-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18D", "ABDOMINAL IRR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18E", "ABDOMINAL IRR-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18F", "ABDOMINAL IRR-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18G", "ABDOMINAL IRR-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18H", "ABDOMINAL IRR-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18I", "ABDOMINAL IRR-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18J", "ABDOMINAL IRR-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18K", "ABDOMINAL IRR-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18L", "ABDOMINAL IRR-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18M", "ABDOMINAL IRR-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18N", "ABDOMINAL IRR-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18R", "ABDOMINAL IRR-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("19", "2 FIELDS EXT R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("19C", "2 FIELDS EXT-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("19D", "2 FIELDS EXT-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("19I", "2 FIELDS EXT-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("19K", "2 FIELDS EXT-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("19M", "2 FIELDS EXT-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("19N", "2 FIELDS EXT-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21", "ROTATION >=3ARCS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21A", "ROTATION-FULL-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21B", "ROTATION-FULL-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21C", "ROTATION-FULL-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21D", "ROTATION-FULL-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21E", "ROTATION-FULL-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21F", "ROTATION-FULL-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21G", "ROTATION-FULL-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21H", "ROTATION-FULL-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21I", "ROTATION-FULL-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21J", "ROTATION-FULL-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21K", "ROTATION-FULL-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21L", "ROTATION-FULL-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21M", "ROTATION-FULL-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21N", "ROTATION-FULL-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21R", "ROTATION-FULL-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21S", "ROTATION-FULL-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22", "ROTAT-SIN ARC R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22A", "ROT-SIN ARC-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22B", "ROT-SIN ARC-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22C", "ROT-SIN ARC-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22D", "ROT-SIN ARC-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22E", "ROT-SIN ARC-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22F", "ROT-SIN ARC-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22G", "ROT-SIN ARC-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22H", "ROT-SIN ARC-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22I", "ROT-SIN ARC-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22J", "ROT-SIN ARC-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22K", "ROT-SIN ARC-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22L", "ROT-SIN ARC-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22M", "ROT-SIN ARC-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22N", "ROT-SIN ARC-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22R", "ROT-SIN ARC-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23", "ROTAT-DOUB ARC R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23A", "ROT-DOUB ARC-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23B", "ROT-DOUB ARC-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23C", "ROT-DOUB ARC-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23D", "ROT-DOUB ARC-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23E", "ROT-DOUB ARC-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23F", "ROT-DOUB ARC-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23G", "ROT-DOUB ARC-G G", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23H", "ROT-DOUB ARC-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23I", "ROT-DOUB ARC-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23J", "ROT-DOUB ARC-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23K", "ROT-DOUB ARC-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23L", "ROT-DOUB ARC-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23M", "ROT-DOUB ARC-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23N", "ROT-DOUB ARC-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23R", "ROT-DOUB ARC-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24", "ROTAT-COMP ARC R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24A", "ROT-COMP ARC-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24B", "ROT-COMP ARC-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24C", "ROT-COMP ARC-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24D", "ROT-COMP ARC-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24E", "ROT-COMP ARC-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24F", "ROT-COMP ARC-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24G", "ROT-COMP ARC-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24H", "ROT-COMP ARC-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24I", "ROT-COMP ARC-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24J", "ROT-COMP ARC-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24K", "ROT-COMP ARC-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24L", "ROT-COMP ARC-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24M", "ROT-COMP ARC-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24N", "ROT-COMP ARC-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24R", "ROT-COMP ARC-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("25", "INTRACAVITY B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("25O", "INTRACAVITY-O B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("25P", "INTRACAVITY-P B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("25Q", "INTRACAVITY-Q B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("25R", "Intracavity-R B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("25T", "INTRACAVITY-T B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("25V", "INTRACAVITY-V B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("25W", "INTRACAVITY-W B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("25X", "INTRACAVITY-X B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("25Y", "INTRACAVITY-Y B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("25Z", "INTRACAVITY-Z B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("26", "INTERSTIT-SINGL B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("27", "INTERSTIT-2 PL B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("28", "INTERSTIT-VOL B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("29", "SURFACE APPLIC B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31", "WHOLE BODY SURF R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31A", "WHOLE BOD SUR-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31B", "WHOLE BOD SUR-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31C", "WHOLE BOD SUR-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31D", "WHOLE BOD SUR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31E", "WHOLE BOD SUR-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31F", "WHOLE BOD SUR-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31G", "WHOLE BOD SUR-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31H", "WHOLE BOD SUR-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31I", "WHOLE BOD SUR-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31J", "WHOLE BOD SUR-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31K", "WHOLE BOD SUR-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31L", "WHOLE BOD SUR-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31M", "WHOLE BOD SUR-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31N", "WHOLE BOD SUR-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31R", "WHOLE BOD SUR-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31S", "WHOLE BOD SUR-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32", "WHOLE BODY R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32A", "WHOLE BODY-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32B", "WHOLE BODY-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32C", "WHOLE BODY-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32D", "WHOLE BODY-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32E", "WHOLE BODY-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32F", "WHOLE BODY-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32G", "WHOLE BODY-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32H", "WHOLE BODY-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32I", "WHOLE BODY-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32J", "WHOLE BODY-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32K", "WHOLE BODY-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32L", "WHOLE BODY-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32M", "WHOLE BODY-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32N", "WHOLE BODY-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32R", "WHOLE BODY-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32S", "WHOLE BODY-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("33", "UNSEALED ISOTOPE B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34", "BREAST-NODAL-2 R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34A", "BREAST-NODAL-2-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34B", "BREAST-NODAL-2-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34C", "BREAST-NODAL-2-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34D", "BREAST-NODAL-2-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34E", "BREAST-NODAL-2-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34F", "BREAST-NODAL-2-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34G", "BREAST-NODAL-2-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34H", "BREAST-NODAL-2-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34I", "BREAST-NODAL-2-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34J", "BREAST-NODAL-2-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34K", "BREAST-NODAL-2-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34L", "BREAST-NODAL-2-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34M", "BREAST-NODAL-2-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34N", "BREAST-NODAL-2-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34R", "BREAST-NODAL-2-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34U", "BREAST-NODAL-2-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35", "BREAST-NODAL-3 R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35A", "BREAST-NODAL-3-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35B", "BREAST-NODAL-3-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35C", "BREAST-NODAL-3-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35D", "BREAST-NODAL-3-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35E", "BREAST-NODAL-3-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35F", "BREAST-NODAL-3-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35G", "BREAST-NODAL-3-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35H", "BREAST-NODAL-3-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35I", "BREAST-NODAL-3-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35J", "BREAST-NODAL-3-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35K", "BREAST-NODAL-3-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35L", "BREAST-NODAL-3-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35M", "BREAST-NODAL-3-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35N", "BREAST-NODAL-3-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36", "BREAST NO-1 1/2 R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36A", "BR-NODA-1 1/2-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36B", "BR-NODA-1 1/2-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36C", "BR-NODA-1 1/2-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36D", "BR-NODA-1 1/2-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36E", "BR-NODA-1 1/2-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36F", "BR-NODA-1 1/2-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36G", "BR-NODA-1 1/2-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36H", "BR-NODA-1 1/2-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36I", "BR-NODA-1 1/2-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36J", "BR-NODA-1 1/2-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36K", "BR-NODA-1 1/2-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36L", "BR-NODA-1 1/2-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36M", "BR-NODA-1 1/2-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36N", "BR-NODA-1 1/2-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36R", "BR-NODA-1 1/2-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37", "BREAST NO-2 1/2 R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37A", "BR-NODA-2 1/2-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37B", "BR-NODA-2 1/2-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37C", "BR-NODA-2 1/2-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37D", "BR-NODA-2 1/2-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37E", "BR-NODA-2 1/2-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37F", "BR-NODA-2 1/2-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37G", "BR-NODA-2 1/2-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37H", "BR-NODA-2 1/2-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37I", "BR-NODA-2 1/2-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37J", "BR-NODA-2 1/2-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37K", "BR-NODA-2 1/2-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37L", "BR-NODA-2 1/2-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37M", "BR-NODA-2 1/2-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37N", "BR-NODA-2 1/2-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37R", "BR-NODA-2 1/2-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("38", "BR-NODAL-1 R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("38A", "BR-NODAL-1-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("38B", "BR-NODAL-1-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("38D", "BR-NODAL-1-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("38E", "BR-NODAL-1-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("38F", "BR-NODAL-1-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("38H", "BR-NODAL-1-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("38J", "BR-NODAL-1-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("38K", "BR-NODAL-1-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("38M", "BR-NODAL-1-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39", "BR-WIDE TANG R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39A", "BR-WIDE TANG-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39B", "BR-WIDE TANG-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39C", "BR-WIDE TANG-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39D", "BR-WIDE TANG-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39E", "BR-WIDE TANG-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39F", "BR-WIDE TANG-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39G", "BR-WIDE TANG-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39H", "BR-WIDE TANG-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39I", "BR-WIDE TANG-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39J", "BR-WIDE TANG-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39K", "BR-WIDE TANG-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39L", "BR-WIDE TANG-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39M", "BR-WIDE TANG-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39N", "BR-WIDE TANG-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39R", "BR-WIDE TANG-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39U", "BR-WIDE TANG-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40", "6 FIELDS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40A", "6 FIELDS-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40B", "6 FIELDS-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40C", "6 FIELDS-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40D", "6 FIELDS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40E", "6 FIELDS-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40F", "6 FIELDS-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40G", "6 FIELDS-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40H", "6 FIELDS-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40I", "6 FIELDS-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40J", "6 FIELDS-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40K", "6 FIELDS-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40L", "6 FIELDS-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40M", "6 FIELDS-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40N", "6 FIELDS-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40R", "6 FIELDS-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("41", "BR-NODAL-1-SCN R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("41K", "BR-NODAL-1-SCN-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("42", "BR-NODAL-1-AXI R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("42K", "BR-NODAL-1-AXI-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("43", "BR-NODAL-1-IMC R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("43K", "BR-NODAL-1-IMC-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("44", "BR-NODAL-2-SCNA R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("44K", "BR-NODAL-2-SCNA-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("45", "BR-NODAL-2-SCNI R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("45K", "BR-NODAL-2-SCNI-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("46", "BR-NODAL-2-AIM R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("46K", "BR-NODAL-2-AIM-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("47", "BR-NODAL-3-ASI R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("47K", "BR-NODAL-3-ASI-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50", "HOCKEY STICK R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50A", "HOCKEY STICK-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50B", "HOCKEY STICK-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50C", "HOCKEY STICK-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50D", "HOCKEY STICK-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50E", "HOCKEY STICK-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50F", "HOCKEY STICK-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50G", "HOCKEY STICK-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50H", "HOCKEY STICK-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50I", "HOCKEY STICK-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50J", "HOCKEY STICK-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50K", "HOCKEY STICK-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50L", "HOCKEY STICK-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50M", "HOCKEY STICK-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50N", "HOCKEY STICK-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50R", "HOCKEY STICK-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("51", "IMRT-5 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("51K", "IMRT-5 Fields-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("52", "IMRT-1 Field R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("52K", "IMRT-1 Field-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("53", "IMRT-3 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("53K", "IMRT-3 Fields-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("54", "VMAT, 1 ARC R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("54K", "VMAT 1 ARC-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("55", "VMAT, 2 ARCS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("55K", "VMAT, 2 ARCS-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("56", "VMAT, >=3 ARCS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("56K", "VMAT,>=3 ARCS-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("57", "VMAT,Arcs&Fixed F. R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("57K", "VMAT,Arcs&Fixed F-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("58", "VMAT,Arcs & IMRT R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("58K", "VMAT,Arcs & IMRT-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("59", "UNKNOWN R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("60D", "STEREOTACTIC-1AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("61D", "STEREOTACTIC-2AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("62D", "STEREOTACTIC-3AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("63D", "STEREOTACTIC-4AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("64D", "STEREOTACTIC-5AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("65D", "STEREOTACTIC-6AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("66D", "STEREOTACTIC-7AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("67D", "STEREOTACTIC-8AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("68D", "SRT>=9 ARCS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("70D", "SRT-1 BEAM-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("71D", "SRT-2 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("72D", "SRT-3 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("73D", "SRT-4 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("74D", "SRT-5 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("75D", "SRT-6 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("76D", "SRT-7 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77D", "SRT-8 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("78D", "SRT-9 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("79D", "SRT-10 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("80D", "SRT>=11 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("89D", "SRT-COMP R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("90", "IMRT-6 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("91", "IMRT-7 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("91K", "IMRT-7 Fields-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("92", "IMRT-8 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("93", "IMRT=9 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("94", "IMRT-10 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("95", "IMRT-11 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("96", "IMRT-12 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("97", "IMRT>=13 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("98", "IMRT-2 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("98K", "IMRT-2 Fields-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "IMRT-4 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99K", "IMRT-4 Fields-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("A", "WEDGES R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("B", "BOLUS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("C", "COMPENSATOR R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("D", "SHIELDING R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("E", "SUPERFLAB R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("F", "WEDGES + SHIELDING R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("G", "WEDGES+COMPENSATR R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("H", "WEDGES+SUPERFLAB R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("I", "WEDGE+COMPSTR+SHLD R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("J", "WEDGES+BOLUS+SHLD R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("K", "BOOST R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("L", "BOLUS + WEDGE R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("M", "BOLUS + SHIELDING R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N", "SHIELDNG+COMPENSTR R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("O", "INSERT-LSOURCE B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("P", "INSERTION-2CH B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("Q", "INSERT-UTE+2OV B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("R", "SHIELDNG&SUPERFLAB R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("S", "SPLIT PELVIS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("T", "INSERT-UTE+1OV B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("U", "WEDGE+SHLD+SUPERF R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("V", "INSERT-1 OVOID B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("W", "INTRALUMINAL B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("X", "INSERT-2 OVOIDS B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("Y", "INSERT-OBTURATOR B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("Z", "INSERT-CYLINDER B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_initl_chemoreg', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_initl_chemoreg\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_initl_chemoreg', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_initl_chemoreg');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("000", "no initial chemotherapy; pre 2010 br_initl_chemo_type_p00005 code = 8", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("001", "Doxorubicin (Adriamycin) and Cyclophosphamide (BRAJAC or BRAVAC) pre 2010 br_initl_chemo_type_p00005 code = 1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("002", "Doxorubicin (Adriamycin) and Cyclophosphamide, followed by Paclitaxel (BRAJACT) pre 2010 br_initl_chemo_type_p00005 code = 6", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("003", "Dose Dense Therapy w Filgrastim (G-CSF) support: Doxorubicin (Adriamycin) and Cyclophosphamide, followed by Paclitaxel (BRAJACTG)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("004", "Doxorubicin (Adriamycin) and Cyclophosphamide, followed by Paclitaxel and Trastuzumab (BRAJACTT)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("005", "Dose Dense Therapy with Filgrastim (C-CSF) support: Doxorubicin (Adriamycin) and Cyclophosphamide, followed by Paclitaxel and Trastuzumab (BRAJACTTG)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("006", "Doxorubicin (Adriamycinj) and Cyclophosphamide, followed by weekly Paclitaxel (UBRAJACTW, BRAJACTW, UBRALAACTW)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("008", "Oral Cyclophosphamide, Doxorubicin (Adriamycin), Fluoruracil (5FU) (BRAJCAFPO) - deleted May 1, 2015 pre 2010 br_initl_chemo_type_p00005 code = 6", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("009", "Cyclophosphamide, Epirubicin, and Fluorouracil (UBRAJCEF or UBRLACEF or BRINFCEF) pre 2010 br_initl_chemo_type_p00005 code = 5", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("010", "Cyclophosphamide, Epirubicin, Fluorouracil, and Filgrastim (G-CSF) (BRAJCEFG or BRLACEFG or BRINFCEFG)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("011", "Cyclophosphamide (IV), Methotrexate, and Fluorouracil (5FU) (BRAJCMF or BRAVCMF) pre 2010 br_initl_chemo_type_p00005 code = 2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("013", "Cyclophosphamide, Doxorubicin (Adriamycin), and Docetaxel (Taxotere) (UBRAJDAC)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("014", "Docetaxel (Taxotere) and Cyclophosphamide (BRAJDC) (with or without G-CSF)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("015", "Docetaxel (Taxotere), Carboplatin, and Trastuzumab (UBRAJDCT or BRAJDCARBT)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("016", "Docetaxel (Taxotere), and Trastuzumab, and Fluorouracil (5FU), Epirubicin, and Cyclophosphamide ( BRAJDTFEC)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("017", "Fluorouracil (5FU), Epirubicin, and Cyclophosphamide (BRAJFEC) pre 2010 br_initl_chemo_type_p00005 code = 7", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("018", "Fluorouracil (5FU), Epirubicin, Cyclophosphamide, and Docetaxel (Taxotere) (BRAJFECD)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("019", "Fluorouracil (5FU), Epirubicin and Cyclophosphamide, followed by Docetaxel (Taxotere) and Trastuzumab (BRAJFECDT)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("020", "Doxorubicin (Adriamycin) and Cyclophosphamide, followed by Docetaxel (Taxotere) (BRLAACD)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("021", "Doxorubicin (Adriamycin) and Cyclophosphamide, followed by Docetaxel (Taxotere) and Trastuzumab (BRLAACDT)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("026", "Capecitabine (BRAVCAP)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("028", "Docetaxel (Taxotere) and Capecitabine (BRAVDCAP)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("029", "Docetaxel (Taxotere) (BRAVDOC, BRAVPTRAD)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("031", "Gemcitabine (BRAVGEM)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("040", "Trastuzumab, Paclitaxel and Carboplatin (BRAVTPC, BRAVTPCARB)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("045", "Trastuzumab, Docetaxel, and Cyclophosphamide (BRAJTDC)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("885", "Anthracycline and taxane, NOS (eg. epirubicin or adriamycin given with docetaxel or paclitaxel in a protocol not listed)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("886", "Anthracycline, NOS (eg. epirubicin or adriamycin given in a protocol not listed)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("888", "Chemotherapy planned, but regimen is unknown pre 2010 br_initl_chemo_type_p00005 code = 9", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("990", "pre 2010 br_initl_chemo_type_p00005 code = 4: Other Chemotherapy (eg TAC or ECT)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "Unknown if initial chemotherapy planned pre 2010 br_initl_chemo_type_p00005 code = X", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_initl_chemo_type_p00005', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_initl_chemo_type_p00005\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_initl_chemo_type_p00005', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_initl_chemo_type_p00005');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("1", "AC", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "CMF", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "FAC/CAF", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4", "other", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("5", "CEF", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("6", "AC + taxane", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("7", "FEC-100", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("8", "no initial chemo", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("9", "unknown (chemo given but regimen unknown)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("X", "unknown if initial chemo given", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("Blank", "no recorded", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_initl_hormreg', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_initl_hormreg\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_initl_hormreg', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_initl_hormreg');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("000", "No initial hormonal therapy pre 2010 dx br_initl_horm_type_p00005 = 8", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("001", "Anastrozole (Arimidex) (BRAJANAS or BRAVANAS)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("005", "Exemestane (Aromasin) (BRAJEXE or BRAVEXE or BRAVEVEX)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("008", "Exemestane (Aromasin) and medical ovarian ablation (Zoladex/Goserelin; Lupron/Leuprolide; Buserelin/Suprefact; Triptorelin) and RT/surgical ovarian ablation (BRAJEXE / BRAVEXE / BRAVEVEX + both RT/surgical ovarian ablation & medical ovarian ablation)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("009", "Letrozole (Femara) (BRAJLET or BRAVLET)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("012", "Letrozole (Femara) and medical ovarian ablation (Zoladex/Goserelin; Lupron/Leuprolide; Buserelin/Suprefact; Triptorelin) and RT/surgical ovarian ablation (BRAJLET / BRAVLET + both RT/surgical ovarian ablation & medical ovarian ablation)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("014", "Tamoxifen (BRAJTAM or BRAVTAM) pre 2010 dx br_initl_horm_type_p00005 = 1", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("015", "Tamoxifen and ovarian ablation (RT or surgical) (BRAJTAM/BRAVTAM + RT/surgical OA) pre 2010 dx br_initl_horm_type_p00005 = 4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("016", "Tamoxifen and medical ovarian ablation (LHRH agonists such as Zoladex/Goserelin; Lupron/Leuprolide; Buserelin/Suprefact; Triptorelin) (BRAJTAM / BRAVTAM + medical ovarian ablation; or protocol codes BRAJLHRHT or BRAVLHRHT) pre 2010 dx br_initl_horm_type_p00005 = 5", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("018", "Tamoxifen, followed by Anastrozole (Arimidex) (BRAJTAM followed by BRAJANAS)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("021", "Tamoxifen, followed by Exemestane (Aromasin), and ovarian ablation (medical, surgical, and/or RT) (BRAJTAM followed by BRAJEXE, and ovarian ablation [medical, surgical, and/or RT])", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("022", "Tamoxifen, followed by Letrozole (Femara) (BRAJTAM followed by BRAJLET)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("024", "Tamoxifen, followed by an aromatase inhibitor (AI), not otherwise specified (BRAJTAM followed by an AI, NOS)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("025", "Tamoxifen, followed by an aromatase inhibitor (AI), not otherwise specififed, and ovarian ablation (medical, surgical, and/or RT) (BRAJTAM followed by an AI, NOS, and ovarian ablation [medical, surgical, and/or RT])", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("026", "Megestrol (BRAVMEG)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("028", "RT or surgical ovarian ablation alone pre 2010 dx br_initl_horm_type_p00005 = 2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("029", "Medical ovarian ablation alone (Zoladex/Goserelin; Lupron/Leuprolide; Buserelin/Suprefact; Triptorelin) pre 2010 dx br_initl_horm_type_p00005 = 6", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("030", "Other SERM (eg. Raloxifene/Evista; Toremifene/Fareston; Lasofoxifene/Oporia/Fablyn)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("032", "AI, NOS followed by Tamoxifen pre 2010 dx br_initl_horm_type_p00005 = 7", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("033", "AI, NOS alone pre 2010 dx br_initl_horm_type_p00005 = A", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("034", "AI, NOS and ovarian ablation (RT or surgical) pre 2010 dx br_initl_horm_type_p00005 = B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("887", "Other hormonal therapy (eg. Fulvestrant/Faslodex) pre 2010 dx br_initl_horm_type_p00005 = 3", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("888", "Hormonal therapy planned, but regimen is unknown pre 2010 dx br_initl_horm_type_p00005 = 9", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "Unknown if initial hormonal therapy planned pre 2010 dx br_initl_horm_type_p00005 = X or blank", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_initl_horm_type_p00005', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_initl_horm_type_p00005\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_initl_horm_type_p00005', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_initl_horm_type_p00005');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("1", "Tamoxifen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "ovarian ablation (RT or surgical) alone", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "other", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4", "Tamoxifen + ovarian ablation (RT or surgical)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("5", "Tamoxifen + medical ovarian ablation", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("6", "medical ovarian ablation alone", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("7", "aromatase inhibitor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("8", "no initial hormonal therapy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("9", "unknown (hormonal therapy given but type unknown)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("A", "aromatase inhibitor + ovarian ablation (RT or surgical)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("B", "aromatase inhibitor + medical ovarian ablation", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("X", "unknown if initial hormonal therapy given", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("blank", "not recorded", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_initl_targthx', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_initl_targthx\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_initl_targthx', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_initl_targthx');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("000", "No initial targeted therapy Pre 2010 br_immunotherapy_p00005 = 8.", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("001", "Trastuzumab/Herceptin as a single agent targeted therapy (alone or in combination with chemotherapy) Pre 2010 br_immunotherapy_p00005 = 1,2, or 3.", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("003", "Lapatinib/Tykerb/Tyverb alone", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("009", "Everolimus (BRAVEVEX)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("888", "Targeted therapy planned, but regimen is unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("999", "Unknown if initial targeted therapy planned Pre 2010 br_immunotherapy_p00005 = 9 or blank", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_br_immunotherapy_p00005', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_br_immunotherapy_p00005\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_br_immunotherapy_p00005', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_br_immunotherapy_p00005');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("1", "concurrent with other chemo", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "sequential (after other chemo)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "initial, given alone", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("8", "no initial immunotherapy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("9", "unknown if an immunotherapy agent was given", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_phys_specialty', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_phys_specialty\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_phys_specialty', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_phys_specialty');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("00", "General Practice", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01", "Dermatology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02", "Neurology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03", "Psychiatry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04", "Neuropsychiatry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05", "Obstetrics & Gyne", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06", "Ophthalmology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07", "Otolaryngology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08", "General Surgery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09", "Neurosurgery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10", "Orthopaedics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11", "Plastic Surgery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12", "Thor & Card Surgery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13", "Urology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14", "Paed ( Neo-Nata l)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15", "Internal Medicine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16", "Rad ( Onc Rad-16 )", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17", "Pathology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18", "Anesthesiology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("19", "Paed Card-Col 123180", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("20", "Phys Med & Rehab", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21", "Pub Hlth & Comm Med", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22", "Gen Surg 50% GP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23", "MSC After 3 1/3 Fis Yr", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24", "Medical Biochemistry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("25", "Gynecologic Oncology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("26", "Procedural Cardiology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("27", "Paed 50% GP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("28", "F-T Co ( Top 280 )", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("29", "Medical Microbiology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("30", "Chiropractics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31", "Naturopathy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32", "Physiotherapy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("33", "Nuclear Medicine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34", "Osteopathy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35", "Orthoptic Technician", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36", "Hospitals", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37", "Oral Surgery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("38", "Podiatry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39", "Optometry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40", "Dent Surg ( Reg Dent )", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("41", "Dental Mechanics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("42", "Orthodontics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("43", "Periodontics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("44", "Rheumatology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("45", "Haematology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("46", "Gastroenterology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("47", "Nursing Home", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("48", "Respiratory Medicine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("49", "Medical Genetics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50", "Hosp ( Type Prac Code )", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("51", "Haematopathology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("52", "Gen Med ( Prim Nonref )", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("53", "Radiology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("54", "Nurse Practitioner", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("55", "Psychology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("56", "Occupational Therapist", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("57", "Registered Nurse", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("58", "Audiology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("59", "Genetic Counsellor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("60", "Registered Clinical Counsellor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("61", "Registered Dietitian", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("62", "Social Work", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("63", "Emergency Medicine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("64", "Endocrinology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("70", "General Surgical Oncology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("71", "Prof Corp", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("80", "Clinics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("81", "Mr & Mrs ( Non Prof. )", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("82", "Radiation Oncology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("83", "Medical Oncology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("84", "Chemistry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("85", "Scientific", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("86", "Non Patient GP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("87", "Non Patient Spec", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "Neuropsychology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("89", "Occupational Medicine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("90", "Midwifery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("91", "Geriatric Medicine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("92", "Acupuncture", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("93", "Vascular Surgery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("94", "Cardiology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("95", "Nephrology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("96", "Paediatrics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("97", "Traditional Chinese Medicine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("98", "Homeopathy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "Allergy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_clinic_phys', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_clinic_phys\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_clinic_phys', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_clinic_phys');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("AA", "A. Avanessian", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AAT", "A. Al-Tourah", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AB", "A. Barry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ACH", "A.C. Hui", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ACL", "A.C. Lo", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ADF", "A.D. Flores", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AH", "A. Hovan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AJ", "A. Jones", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AJA", "A.J. Attwell", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AJG", "A.J. Goldrick", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AK", "A. Karvat", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AKC", "A.K. Cheung", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AKD", "A.K. David", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AL", "A. Lin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ALA", "A.L. Agranovich", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AMS", "A.M. Shah", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AN", "A. Nichol", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ARF", "A.R. Fowler", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ASA", "A.S. Alexander", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ASY", "A.S. Yee", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AT", "A. Tinker", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AVK", "A.V. Krauze", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AW", "A. Weiss", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("AY", "A. Ye", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BAC", "B.A. Czerkawski", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BAM", "B. A. Masri", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BC", "B. Campbell", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BDA", "B.D. Acker", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BGM", "B.G. McMillan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BH", "B. Haylock", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BL", "B. Lester", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BLE", "B. Lee", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BLM", "B.L. Madsen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BM", "B. Melosky", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BMA", "B.M. Allan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BMO", "B. Mou", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BMS", "B. Maas", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BN", "B. Norris", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BNE", "B. Nelems", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BP", "B. Proctor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BS", "B. Sheehan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BT", "B. Thiessen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BV", "B. Valev", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("BW", "B. Weinerman", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CAF", "C.A. Fitzgerald", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CAG", "C.A. Grafton", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CAL", "C.A. Lohrisch", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CAS", "C.A. Smith", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CB", "C. Blanke", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CC", "C. Campbell", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CCH", "C.C. Ho", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CD", "C. Demetz", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CDB", "C.D. Britten", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CDL", "C.D. Little", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CGM", "C.G. Martens", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CJB", "C.J. Bryce", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CJF", "C.J.H. Fryer", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CJN", "C.J. North", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CK", "C. Kollmannsberger", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CKS", "C. Kim-Sing", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CKW", "C.K. Williams", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CL", "C. Leong", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CLH", "C.L. Holloway", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CLT", "C.L. Toze", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CM", "C. Most", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CMC", "C.M. Coppin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CML", "C.M. Ludgate", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CO", "C. Oja", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("COP", "Comm. Onc.", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CP", "C. Parsons", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CPD", "C.P. Duncan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CRL", "C.R. Lund", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CS", "C. Sigal", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CWL", "C.W. Lee", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DAB", "D.A. Boyes", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DB", "D. Bowman", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DBB", "D.B. Barwich", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DCW", "D.C. Wilson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DDP", "D.D. Panjwani", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DDS", "D.D. Schellenberg", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DEH", "D.E. Hogge", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DER", "D.E. Rheaume", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DF", "D. Finch", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DFL", "D.F. Lee", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DG", "D. Glick", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DH", "D. Hoegler", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DIM", "D.I. McLean", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DJK", "D.J. Klaassen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DJT", "D.J. Thorpe", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DK", "D. Kim", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DLS", "D.L. Saltman", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DLU", "D.L. Uhlman", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DM", "D. Mirchandani", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DMM", "D. Miller", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DO", "D. Osoba", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DP", "D. Petrik", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DR", "D. Reece", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DS", "D. Sauciuc", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DSS", "D.S. Stuart", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DV", "D. Voduc", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("DWF", "D.W. Fenton", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EB", "E. Berthelet", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EC", "E. Conneally", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ECK", "E.C. Kostashuk", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EH", "E. Hadzic", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EJM", "E.J. McMurtrie", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EKB", "E.K. Beardsley", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EKC", "E. Chan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EKW", "E.K. Wong", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EL", "E. Laukkanen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ELH", "E.L.G. Hardy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EMB", "E.M. Brown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ES", "E. Sham", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ESB", "E.S. Bouttell", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ESW", "E.S. Wai", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ET", "E. Tran", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("EWT", "E.W. Taylor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FA", "F. Alfaraj", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FB", "F. Bachand", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FG", "F. Germain", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FHH", "F.H. Hsu", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FJV", "F.J. Vernimmen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FLW", "F.L. Wong", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GB", "G. Bahl", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GBG", "G.B. Goodman", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GC", "G. Campbell", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GDM", "G.D. MacLean", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GG", "G. McGregor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GGD", "G.G. Duncan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GKP", "G.K. Pansegrau", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GLP", "G.L. Phillips", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GMC", "G.M. Crawford", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GMF", "G.M. Fyles", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GN", "G. Newman", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GPB", "G.P. Browman", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GR", "G. Richardson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("GWD", "G.W.K. Donaldson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HAJ", "H.A. Joe", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HAK", "H. Kennecke", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HB", "H. Berry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HC", "H. Carolan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HF", "H. Fung", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HGK", "H.G. Klingemann", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HHP", "H.H. Pai", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HJL", "H.J. Lim", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HJS", "H.J. Sutherland", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HK", "H. Kader", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HKS", "H.K. Silver", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HL", "H. Lui", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HLA", "H.L. Anderson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HLR", "H.L. Rayner", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HM", "H. Martins", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HMG", "H.M. Gough", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HVD", "H.V. Docherty", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HW", "H. Wass", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("HYL", "H.Y. Lau", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("IAO", "I.A. Olivotto", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("IGM", "I.G. Mohamed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("IHP", "I.H. Plenderleith", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ILT", "I.L. Thompson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("INA", "Inactive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("IS", "I. Syndikus", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("IV", "I. Vallieres", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JA", "J. Archer", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JAB", "J.A. Broomfield", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JAC", "J. Crook", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JAS", "J.A. Sutherland", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JAY", "J. Younus", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JB", "J. Bowen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JC", "J. Cox", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JCA", "J. Caon", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JCF", "J.C. Fetterly", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JCL", "J.C. Lavoie", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JDS", "J.D. Shepherd", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JFC", "J.F. Canavan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JG", "J. Goulart", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JH", "J. Hart", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JHC", "J.H. Chritchley", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JHG", "J.H. Goldie", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JHH", "J.H. Hay", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JJ", "J. Jensen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JJA", "J. Jaswal", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JJL", "J.J. Laskin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JJT", "J.J. Travaglini", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JK", "J. Kamra", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JKR", "J.K. Rivers", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JL", "J.T.W. Lim", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JLB", "J.L. Benedet", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JM", "J. Michels", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JMB", "J.M. Bourque", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JMC", "J.M. Connors", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JMF", "J.M. Freund", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JMW", "J.M. Wilde", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JNM", "J.N. Moore", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JNR", "J.N. Rose", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JPL", "J.P. Livergant", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JQC", "J.Q. Cao", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JR", "J. Ragaz", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JRB", "J.R. Brown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JS", "J. D. Shustik", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JSK", "J.S. Kwon", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JSW", "J.S. Wu", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JV", "J. Vergidis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JW", "J. Wilson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JWR", "J.W. Rieke", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("JY", "J. Yun", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KAG", "K.A. Gelmon", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KC", "K. Chu", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KCM", "K.C. Murphy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KDS", "K.D. Swenerton", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KEK", "K.E. Khoo", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KJ", "K. Jasas", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KJG", "K.J. Goddard", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KJS", "K.J. Savage", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KLB", "K.L. Brown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KNC", "K.N. Chi", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KRM", "K.R. Mills", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("KSW", "K.S. Wilson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LF", "L. Fung", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LHL", "L.H. Le", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LHS", "L.H. Sehn", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LM", "L. Martin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LW", "L. Weir", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("LXW", "L. Warshawski", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MA", "M. Abd-el-Malek", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MAA", "M. Almahmudi", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MAD", "M.A. Delorme", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MAF", "M.A. Fortin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MAH", "M.A. Hussain", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MAK", "M.A. Knowling", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MAM", "M.A. Mildenberger", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MAT", "M.A. Taylor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MB", "M. Bertrand", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MCL", "M.C.C. Liu", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MCP", "M.C. Po", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MDH", "M.D. Hafermann", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MDP", "M.D. Peacock", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MFM", "M.F. MANJI", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MH", "M. Heywood", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MJ", "M. Jovanovic", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MJB", "M.J. Barnett", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MJF", "M.J. Follwell", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MJM", "M.J. McLaughlin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MJT", "M.J. Taylor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MK", "M. Keyes", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MKK", "M.K. Khan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MLB", "M.L. Brigden", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MLD", "M.L. Davis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MMM", "M.M. Manji", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MN", "M. Nazerali", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MP", "M. Pomeroy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MR", "M. Reed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MRM", "M.R. McKenzie", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MS", "M. Sia", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MT", "M.T. Turko", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MV", "M. Vlachaki", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MVM", "M.V. MacNeil", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("MWA", "M.W. Ashford", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NAM", "N.A. Macpherson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NB", "N. Bruchovsky", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NJV", "N.J.S. Voss", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NL", "N. Leong", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NLD", "N.L. Davis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NN", "N. Nicolaou", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NS", "N. Shahid", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("NW", "N. Wilson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PAB", "P.A. Blood", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PAG", "P.A. Gfeller-Ingledew", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PAL", "P.A. Leco", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PB", "P. Burgi", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PC", "P. Coy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PD", "P. Dixon", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PG", "P. Graham", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PGK", "P.G. Kenny", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PH", "P. Hoskins", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PJF", "P. J. Froud", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PK", "P. Klimo", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PL", "P. Lim", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PMC", "P.M. Czaykowski", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PRB", "P.R. Band", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PT", "P. Tallos", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("PTT", "P.T. Truong", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RDO", "R.D. Ostlund", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RDW", "R.D. Winston", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("REB", "R.E. Beck", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("REC", "R.E. Cheifetz", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RHC", "R.H. Chowdhury", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RJK", "R.J. Klasa", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RM", "R. Ma", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RMH", "R.M. Halperin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RNF", "R.N. Fairey", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RNM", "R.N. Murray", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RO", "R. Olson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RPS", "R.P.S. Sawhney", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RRL", "R.R. Love", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("RS", "R. Samant", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SA", "S. Alexander", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SAA", "S. Arif", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SAT", "S. Tyldesley", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SBS", "S.B. Sutcliffe", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SCR", "S.C. Rao", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SDL", "S.D. Lucas", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SEO", "S.E. O'Reilly", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SEP", "S.E. Parameswaran", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SFS", "S.F. Souliere", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SG", "S. Gill", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SHN", "S.H. Nantel", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SIA", "S. Atrchian", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SJA", "S.J. Allan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKC", "S.K. Chia", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SKL", "S.K. Loewen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SL", "S. Larsson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SLB", "S.L. Balkwill", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SLE", "S.L. Ellard", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SLG", "S.L. Goldenberg", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SM", "S. Miller", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SMJ", "S.M. Jackson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SNA", "S.N. Ahmed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SNH", "S.N. Hamilton", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SS", "S. Smith", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ST", "S. Thomson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("STY", "S. Tyler", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SV", "S. Vermeulen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SVL", "S. Lefresne", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SXL", "S. Lam", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TAK", "T.A. Koulis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TAP", "T.A. Pickles", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TB", "T. Berrang", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TD", "T. Do", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TE", "T. Ehlen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("THT", "T. Trotter", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TK", "T. Keane", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TN", "T. Nevill", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TS", "T. Shenkier", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TT", "T. Tolcher", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TW", "T. Walia", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("TWC", "T.W. Chan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("UL", "U. Lee", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("VB", "V. Bernstein", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("VEB", "V.E. Basco", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("VG", "V. Goutsouliak", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("VH", "V. Ho", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("VK", "V. Krause", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("VT", "V. Tsang", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("VY", "V. Yau", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("WBK", "W.B. Kwan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("WCM", "W.C. MacDonald", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("WJM", "W.J. Morris", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("WMW", "W.M. Wisbeck", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("WYL", "W.Y. Lam", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("YZ", "Y. Zhou", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ZZZ", " UNKNOWN", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) values ('bc_nbi_bcca_ECE_final', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'bc_nbi_bcca_ECE_final\')');INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('bc_nbi_bcca_ECE_final', 1, 10, 'clinical');SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'bc_nbi_bcca_ECE_final');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "No ECE noted in any positive nodes from initial nodal procedure pathology reports", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "Minimal ECE (=< 1 mm beyond the node capsule) is the maximum amount of ECE noted in any initial nodal pathology report(s)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "Moderate ECE (> 1 to 10 mm beyond the node capsule) is the maximum amount of ECE noted in any initial nodal pathology report(s)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "Extensive ECE (> 10 mm beyond the node capsule) noted in at least one initial nodal pathology report", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4", "ECE present, extent not specified, in any initial nodal pathology report(s)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("66", "Initial nodal procedure performed, but nodal status unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("77", "Initial nodal procedure performed, positive nodes removed, and unknown if ECE present", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88", "Not applicable", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "Unknown if initial nodal procedure was performed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Anterior Tissue Remaining' WHERE name = 'bc_nbi_bcca_br_ant_tiss_onco';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Clips Used' WHERE name = 'bc_nbi_bcca_br_clipmarkingbxcavity_onco';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Close or Pos Margin Type' WHERE name = 'bc_nbi_bcca_br_closeposmargintype_onco';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : HER2 Lab at Recurrence' WHERE name = 'bc_nbi_bcca_br_her2neulabatrecur_onco';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Targ Thx at Init Dx Pre 2010' WHERE name = 'bc_nbi_bcca_br_immunotherapy_p00005';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Initial Chemo Regimen' WHERE name = 'bc_nbi_bcca_br_initl_chemoreg';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Chemo at Init Dx Pre 2010' WHERE name = 'bc_nbi_bcca_br_initl_chemo_type_p00005';

UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Initial Hormone Regimen' WHERE name = 'bc_nbi_bcca_br_initl_hormreg';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Horm at Init Dx Pre 2010' WHERE name = 'bc_nbi_bcca_br_initl_horm_type_p00005';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Initial Targeted Therapy' WHERE name = 'bc_nbi_bcca_br_initl_targthx';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Multicentric Breast Ca' WHERE name = 'bc_nbi_bcca_br_multicentbrstca_onco';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Multifocal Breast Ca' WHERE name = 'bc_nbi_bcca_br_multifocbrstca_onco';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Overlapping Lesion' WHERE name = 'bc_nbi_bcca_br_overlap_lesion_onco';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Posterior or Deep  Margin' WHERE name = 'bc_nbi_bcca_br_postr_deepmarg_onco';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Radiologic Confirm FWL' WHERE name = 'bc_nbi_bcca_br_radiologicconfirmFWL_onco';

UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Surg Specimen Oriented' WHERE name = 'bc_nbi_bcca_br_surgspecimenoriented_onco';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Physician pre 2003' WHERE name = 'bc_nbi_bcca_clinic_phys';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS Clinical M' WHERE name = 'bc_nbi_bcca_COL_AJCC_M_clin';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS Pathologic M' WHERE name = 'bc_nbi_bcca_COL_AJCC_M_path';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS Clinical N' WHERE name = 'bc_nbi_bcca_COL_AJCC_N_clin';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS Pathologic N' WHERE name = 'bc_nbi_bcca_COL_AJCC_N_path';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS Clinical T' WHERE name = 'bc_nbi_bcca_COL_AJCC_T_clin';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS Pathologic T' WHERE name = 'bc_nbi_bcca_COL_AJCC_T_path';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS Reg. LN Invol. at I. Dx' WHERE name = 'bc_nbi_bcca_COL_nodes';

UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS N Cat. Stag. Basis' WHERE name = 'bc_nbi_bcca_COL_nodes_eval';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF3 Pos. Ipsil. ALN' WHERE name = 'bc_nbi_bcca_col_ssf3';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF4 IHC of Reg. LN' WHERE name = 'bc_nbi_bcca_col_ssf4';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF5 MOL Stud. of RLN' WHERE name = 'bc_nbi_bcca_col_ssf5';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF6 Tum. Size-Inv. Comp.' WHERE name = 'bc_nbi_bcca_col_ssf6';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF7 Notting./BR Score/Gr' WHERE name = 'bc_nbi_bcca_col_ssf7';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF8 HER2:  IHC Lab Value' WHERE name = 'bc_nbi_bcca_col_ssf8';

UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF9 HER2 IHC Test Interp.' WHERE name = 'bc_nbi_bcca_col_ssf9';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF10 HER2 FISH Lab Value' WHERE name = 'bc_nbi_bcca_col_ssf10';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF11 HER2 FISH Test Interp.' WHERE name = 'bc_nbi_bcca_col_ssf11';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF12 HER2 CISH Lab Value' WHERE name = 'bc_nbi_bcca_col_ssf12';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF13 HER2 CISH Test Interp.' WHERE name = 'bc_nbi_bcca_col_ssf13';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF14 HER2 Res (Oth/Unk Test)' WHERE name = 'bc_nbi_bcca_col_ssf14';

UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF16 ER, PR, and HER2 Results' WHERE name = 'bc_nbi_bcca_col_ssf16';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF19 Ass. of Pos. Ipsil. ALN' WHERE name = 'bc_nbi_bcca_col_ssf19';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF22 Multigene Sig. Method' WHERE name = 'bc_nbi_bcca_col_ssf22';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : CS SSF23 Multigene Sig. Results' WHERE name = 'bc_nbi_bcca_col_ssf23';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Tumoour size' WHERE name = 'bc_nbi_bcca_col_tum_size';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : ECE' WHERE name = 'bc_nbi_bcca_ECE_final';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Family Histories' WHERE name = 'bc_nbi_bcca_family_hx';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : HER2 Lab at Dx' WHERE name = 'bc_nbi_bcca_her2neulab_initdx';

UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : HER2 Tissue Site' WHERE name = 'bc_nbi_bcca_her2_tissuesite';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Health Authority at Diagnosis' WHERE name = 'bc_nbi_bcca_hlth_auth';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : HSDA at Diagnosis' WHERE name = 'bc_nbi_bcca_hsda';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : RT Boost ' WHERE name = 'bc_nbi_bcca_init_finrt';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Local Health Area at Diagnosis' WHERE name = 'bc_nbi_bcca_local_health_area';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Location at Admit' WHERE name = 'bc_nbi_bcca_loc_at_admit & location';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Metastases' WHERE name = 'bc_nbi_bcca_M_STG';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : # Relatives Br Ca' WHERE name = 'bc_nbi_bcca_num_fst_deg_relatives';

UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Performance Status' WHERE name = 'bc_nbi_bcca_performance_status';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Specialty of the physician' WHERE name = 'bc_nbi_bcca_phys_specialty';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : # Positive Nodes at Init Dx' WHERE name = 'bc_nbi_bcca_posnodes';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Reconstruction Surgery' WHERE name = 'bc_nbi_bcca_recon_final';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : # of Pos Sentinel LN' WHERE name = 'bc_nbi_bcca_sentnodes';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Tumor Site' WHERE name = 'bc_nbi_bcca_site';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Sentinel Lymph Node Bx' WHERE name = 'bc_nbi_bcca_SLNB';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Status at Referral' WHERE name = 'bc_nbi_bcca_status_at_referral';

UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : RT Technique' WHERE name = 'bc_nbi_bcca_tech';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : TNM Clinical M Stage' WHERE name = 'bc_nbi_bcca_tnm_clin_m';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : TNM Clinical T Stage' WHERE name = 'bc_nbi_bcca_tnm_clin_t';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : TNM Pathologic M Stage' WHERE name = 'bc_nbi_bcca_tnm_surg_m';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : TNM Pathologic N Stage' WHERE name = 'bc_nbi_bcca_tnm_surg_n';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : TNM Pathologic T Stage' WHERE name = 'bc_nbi_bcca_tnm_surg_t';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : # Total Nodes' WHERE name = 'bc_nbi_bcca_totnodes';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Treatment Region' WHERE name = 'bc_nbi_bcca_trt_region';
UPDATE structure_permissible_values_custom_controls SET name = 'BCCA Tum. Reg. : Tumour Size' WHERE name = 'bc_nbi_bcca_tum_size';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Anterior Tissue Remaining\')' WHERE domain_name = 'bc_nbi_bcca_br_ant_tiss_onco';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Clips Used\')' WHERE domain_name = 'bc_nbi_bcca_br_clipmarkingbxcavity_onco';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Close or Pos Margin Type\')' WHERE domain_name = 'bc_nbi_bcca_br_closeposmargintype_onco';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : HER2 Lab at Recurrence\')' WHERE domain_name = 'bc_nbi_bcca_br_her2neulabatrecur_onco';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Targ Thx at Init Dx Pre 2010\')' WHERE domain_name = 'bc_nbi_bcca_br_immunotherapy_p00005';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Initial Chemo Regimen\')' WHERE domain_name = 'bc_nbi_bcca_br_initl_chemoreg';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Chemo at Init Dx Pre 2010\')' WHERE domain_name = 'bc_nbi_bcca_br_initl_chemo_type_p00005';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Initial Hormone Regimen\')' WHERE domain_name = 'bc_nbi_bcca_br_initl_hormreg';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Horm at Init Dx Pre 2010\')' WHERE domain_name = 'bc_nbi_bcca_br_initl_horm_type_p00005';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Initial Targeted Therapy\')' WHERE domain_name = 'bc_nbi_bcca_br_initl_targthx';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Multicentric Breast Ca\')' WHERE domain_name = 'bc_nbi_bcca_br_multicentbrstca_onco';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Multifocal Breast Ca\')' WHERE domain_name = 'bc_nbi_bcca_br_multifocbrstca_onco';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Overlapping Lesion\')' WHERE domain_name = 'bc_nbi_bcca_br_overlap_lesion_onco';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Posterior or Deep  Margin\')' WHERE domain_name = 'bc_nbi_bcca_br_postr_deepmarg_onco';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Radiologic Confirm FWL\')' WHERE domain_name = 'bc_nbi_bcca_br_radiologicconfirmFWL_onco';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Surg Specimen Oriented\')' WHERE domain_name = 'bc_nbi_bcca_br_surgspecimenoriented_onco';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Physician pre 2003\')' WHERE domain_name = 'bc_nbi_bcca_clinic_phys';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS Clinical M\')' WHERE domain_name = 'bc_nbi_bcca_COL_AJCC_M_clin';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS Pathologic M\')' WHERE domain_name = 'bc_nbi_bcca_COL_AJCC_M_path';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS Clinical N\')' WHERE domain_name = 'bc_nbi_bcca_COL_AJCC_N_clin';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS Pathologic N\')' WHERE domain_name = 'bc_nbi_bcca_COL_AJCC_N_path';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS Clinical T\')' WHERE domain_name = 'bc_nbi_bcca_COL_AJCC_T_clin';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS Pathologic T\')' WHERE domain_name = 'bc_nbi_bcca_COL_AJCC_T_path';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS Reg. LN Invol. at I. Dx\')' WHERE domain_name = 'bc_nbi_bcca_COL_nodes';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS N Cat. Stag. Basis\')' WHERE domain_name = 'bc_nbi_bcca_COL_nodes_eval';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF3 Pos. Ipsil. ALN\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf3';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF4 IHC of Reg. LN\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf4';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF5 MOL Stud. of RLN\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf5';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF6 Tum. Size-Inv. Comp.\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf6';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF7 Notting./BR Score/Gr\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf7';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF8 HER2:  IHC Lab Value\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf8';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF9 HER2 IHC Test Interp.\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf9';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF10 HER2 FISH Lab Value\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf10';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF11 HER2 FISH Test Interp.\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf11';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF12 HER2 CISH Lab Value\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf12';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF13 HER2 CISH Test Interp.\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf13';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF14 HER2 Res (Oth/Unk Test)\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf14';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF16 ER, PR, and HER2 Results\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf16';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF19 Ass. of Pos. Ipsil. ALN\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf19';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF22 Multigene Sig. Method\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf22';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : CS SSF23 Multigene Sig. Results\')' WHERE domain_name = 'bc_nbi_bcca_col_ssf23';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Tumoour size\')' WHERE domain_name = 'bc_nbi_bcca_col_tum_size';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : ECE\')' WHERE domain_name = 'bc_nbi_bcca_ECE_final';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Family Histories\')' WHERE domain_name = 'bc_nbi_bcca_family_hx';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : HER2 Lab at Dx\')' WHERE domain_name = 'bc_nbi_bcca_her2neulab_initdx';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : HER2 Tissue Site\')' WHERE domain_name = 'bc_nbi_bcca_her2_tissuesite';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Health Authority at Diagnosis\')' WHERE domain_name = 'bc_nbi_bcca_hlth_auth';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : HSDA at Diagnosis\')' WHERE domain_name = 'bc_nbi_bcca_hsda';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : RT Boost \')' WHERE domain_name = 'bc_nbi_bcca_init_finrt';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Local Health Area at Diagnosis\')' WHERE domain_name = 'bc_nbi_bcca_local_health_area';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Location at Admit\')' WHERE domain_name = 'bc_nbi_bcca_loc_at_admit & location';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Metastases\')' WHERE domain_name = 'bc_nbi_bcca_M_STG';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : # Relatives Br Ca\')' WHERE domain_name = 'bc_nbi_bcca_num_fst_deg_relatives';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Performance Status\')' WHERE domain_name = 'bc_nbi_bcca_performance_status';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Specialty of the physician\')' WHERE domain_name = 'bc_nbi_bcca_phys_specialty';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : # Positive Nodes at Init Dx\')' WHERE domain_name = 'bc_nbi_bcca_posnodes';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Reconstruction Surgery\')' WHERE domain_name = 'bc_nbi_bcca_recon_final';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : # of Pos Sentinel LN\')' WHERE domain_name = 'bc_nbi_bcca_sentnodes';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Tumor Site\')' WHERE domain_name = 'bc_nbi_bcca_site';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Sentinel Lymph Node Bx\')' WHERE domain_name = 'bc_nbi_bcca_SLNB';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Status at Referral\')' WHERE domain_name = 'bc_nbi_bcca_status_at_referral';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : RT Technique\')' WHERE domain_name = 'bc_nbi_bcca_tech';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : TNM Clinical M Stage\')' WHERE domain_name = 'bc_nbi_bcca_tnm_clin_m';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : TNM Clinical T Stage\')' WHERE domain_name = 'bc_nbi_bcca_tnm_clin_t';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : TNM Pathologic M Stage\')' WHERE domain_name = 'bc_nbi_bcca_tnm_surg_m';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : TNM Pathologic N Stage\')' WHERE domain_name = 'bc_nbi_bcca_tnm_surg_n';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : TNM Pathologic T Stage\')' WHERE domain_name = 'bc_nbi_bcca_tnm_surg_t';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : # Total Nodes\')' WHERE domain_name = 'bc_nbi_bcca_totnodes';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Treatment Region\')' WHERE domain_name = 'bc_nbi_bcca_trt_region';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Tumour Size\')' WHERE domain_name = 'bc_nbi_bcca_tum_size';

-- List from "Main" worksheets
-- -------------------------------------------

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_ref', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Referred Case\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Referred Case', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Referred Case');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("0", "on referred", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "Referred", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_dataset', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : NHA Case\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : NHA Case', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : NHA Case');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("1", "NHA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "VCC", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_registry_group', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Province of Residence\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Province of Residence', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Province of Residence');
SET @user_id = 2; INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("B", "B.C.", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("Y", "Yukon", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("Blank", "Other", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_diag_type', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Coding Status\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Coding Status', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Coding Status');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("1", "amended (discont. 1/1/2010)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "final referred", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "provisional (referred or non-referred)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4", "final non-referred", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_loc_at_diag', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Postal Code at Diagnosis\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Postal Code at Diagnosis', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Postal Code at Diagnosis');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("5900", "BC", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_cancer_center', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Cancer Center\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Cancer Center', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Cancer Center');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("AC", "Abbotsford", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("CN", "Center for the North", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("FV", "Fraser Valley", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("SI", "Southern Interior", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("VA", "Vancouver", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("VI", "Vancouver Island", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("??", "Unknown, postal code boundaries have changed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_laterality', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Laterality\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Laterality', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Laterality');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("01", "right", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02", "left", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09", "unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_tumour_behavior', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Tumour Behaviour\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Tumour Behaviour', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Tumour Behaviour');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("2", "in situ", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "Invasive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_tumour_grade', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Tumour Grade\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Tumour Grade', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Tumour Grade');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("01", "Grade I Well Differentiated/Differentiated", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02", "Grade II Moderately Diff / Mod Well Diff", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03", "Grade III Poorly Differentiated", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04", "Grade IV Undifferentiated, Anaplastic", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09", "Grade/differentiations unknown, not stated, or not applicable", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_br_grade_type', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Tumour Grade Type\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Tumour Grade Type', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Tumour Grade Type');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("1", "Nuclear", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "Histologic", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("8", "N/A (Grade Unknown)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_UICC_TNM_staging_system', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : UICC TNM staging system\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : UICC TNM staging system', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : UICC TNM staging system');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("74", "1974 (2nd edition)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("78", "1978 (3rd edition)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("87", "1987 (4th edition)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("97", "1997 (5th edition)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02", "2002 (6th edition)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09", "2009 (7th edition)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("Blank", "not recorded", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("bc_nbi_bcca_neg_pos_unknown", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("0", "negative"),("1", "positive"),("9", "unknown");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_bcca_neg_pos_unknown"), (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="negative"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_bcca_neg_pos_unknown"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="positive"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_bcca_neg_pos_unknown"), (SELECT id FROM structure_permissible_values WHERE value="9" AND language_alias="unknown"), "3", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("bc_nbi_bcca_neg_pos_close_unknown", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("0", "negative"),("1", "positive"),("2", "close"), ("9", "unknown");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_bcca_neg_pos_unknown"), (SELECT id FROM structure_permissible_values WHERE value="0" AND language_alias="negative"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_bcca_neg_pos_unknown"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="positive"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_bcca_neg_pos_unknown"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="close"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_bcca_neg_pos_unknown"), (SELECT id FROM structure_permissible_values WHERE value="9" AND language_alias="unknown"), "3", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_nodestat', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Nodal Status\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Nodal Status', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Nodal Status');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("0", "node negative", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "node positive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_SLNB_yes_no
', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : SLN Bx (Y/N)\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : SLN Bx (Y/N)', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : SLN Bx (Y/N)');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("0", "no SLNBx", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "SLNBx", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("8", "SLNBx abandoned/unkn", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_er_status', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : ER Status\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : ER Status', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : ER Status');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("1", "high positive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "moderately positive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "low positive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4", "positive, unspecified", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("5", "negative", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("9", "unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_not_treated', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : No Initial Treatment\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : No Initial Treatment', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : No Initial Treatment');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("1", "Patient refused treatment", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "Malignancy or condition too advanced", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "Patient referred elsewhere", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("4", "other", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99", "Not Applicable (Patient had Treatment)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_localtx', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Local Treatment\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Local Treatment', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Local Treatment');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("0", "no breast surgery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "mastectomy +/- any RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "BCS + any RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "BCS alone", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
	
INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_systx', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Systemic Therapy\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Systemic Therapy', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Systemic Therapy');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("0", "no chemo or HT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "HT, no chemo", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("2", "chemo, no HT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("3", "HT & chemo", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("9", "unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
	
INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_init_chemo', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Chemo: Y/N at Init Dx	\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Chemo: Y/N at Init Dx	', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Chemo: Y/N at Init Dx	');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES("0", "no chemotherapy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "initial chemotherapy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("9", "unknown if initial chemo", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
	
INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_init_horm', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Horm Ther  Y/N at Init Dx\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Horm Ther  Y/N at Init Dx', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Horm Ther  Y/N at Init Dx');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("0", "no initial hormonal therapy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "initial hormonal therapy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("9", "unknown if pt received initial hormonal therapy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_M1atDx', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : M1 at Dx\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : M1 at Dx', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : M1 at Dx');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("0", "No mets at diagnosis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "Mets at diagnosis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("9", "Unknown if M1 at dx", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);		

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_loc_type', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Local Rec Type\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Local Rec Type', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Local Rec Type');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES("V", "invasive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("N", "insitu", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("L", "unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('bc_nbi_bcca_br_initl_targthx_yn', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'BCCA Tum. Reg. : Initial Targ, Ther. Y/N\')');
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('BCCA Tum. Reg. : Initial Targ, Ther. Y/N', 1, 10, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'BCCA Tum. Reg. : Initial Targ, Ther. Y/N');
SET @user_id = 2; 
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES("V", "invasive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("0", "no initial targeted therapy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("1", "initial targeted therapy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("9", "unknown if pt received initial targeted therapy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);	
