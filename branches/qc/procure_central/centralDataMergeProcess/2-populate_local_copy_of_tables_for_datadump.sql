
SET FOREIGN_KEY_CHECKS = 0;		
		
-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table ad_blocks
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE ad_blocks;
INSERT INTO ad_blocks (
    aliquot_master_id,
    block_type,
    procure_freezing_type,
    patho_dpt_block_code,
    procure_freezing_ending_time,
    procure_origin_of_slice,
    procure_dimensions,
    time_spent_collection_to_freezing_end_mn,
    procure_classification
)
(
  SELECT
    aliquot_master_id,
    block_type,
    procure_freezing_type,
    patho_dpt_block_code,
    procure_freezing_ending_time,
    procure_origin_of_slice,
    procure_dimensions,
    time_spent_collection_to_freezing_end_mn,
    procure_classification
  FROM 
    %%local_procure_prod_database%%.ad_blocks
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table ad_tissue_slides
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE ad_tissue_slides;
INSERT INTO ad_tissue_slides (
    aliquot_master_id,
    immunochemistry,
    procure_stain
)
(
  SELECT
    aliquot_master_id,
    immunochemistry,
    procure_stain
  FROM 
    %%local_procure_prod_database%%.ad_tissue_slides
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table ad_tubes
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE ad_tubes;
INSERT INTO ad_tubes (
    aliquot_master_id,
    lot_number,
    concentration,
    concentration_unit,
    cell_count,
    cell_count_unit,
    cell_viability,
    hemolysis_signs,
    procure_deprecated_field_expiration_date,
    procure_tube_weight_gr,
    procure_total_quantity_ug,
    procure_concentration_nanodrop,
    procure_concentration_unit_nanodrop,
    procure_total_quantity_ug_nanodrop,
    procure_time_at_minus_80_days,
    procure_date_at_minus_80,
    procure_date_at_minus_80_accuracy
)
(
  SELECT
    aliquot_master_id,
    lot_number,
    concentration,
    concentration_unit,
    cell_count,
    cell_count_unit,
    cell_viability,
    hemolysis_signs,
    procure_deprecated_field_expiration_date,
    procure_tube_weight_gr,
    procure_total_quantity_ug,
    procure_concentration_nanodrop,
    procure_concentration_unit_nanodrop,
    procure_total_quantity_ug_nanodrop,
    procure_time_at_minus_80_days,
    procure_date_at_minus_80,
    procure_date_at_minus_80_accuracy
  FROM 
    %%local_procure_prod_database%%.ad_tubes
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table ad_tissue_cores
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE ad_tissue_cores;
INSERT INTO ad_tissue_cores (
    aliquot_master_id
)
(
  SELECT
    aliquot_master_id
  FROM 
    %%local_procure_prod_database%%.ad_tissue_cores
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table ad_whatman_papers
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE ad_whatman_papers;
INSERT INTO ad_whatman_papers (
    aliquot_master_id,
    used_blood_volume,
    used_blood_volume_unit,
    procure_card_sealed_date,
    procure_card_sealed_date_accuracy,
    procure_card_completed_datetime,
    procure_card_completed_datetime_accuracy
)
(
  SELECT
    aliquot_master_id,
    used_blood_volume,
    used_blood_volume_unit,
    procure_card_sealed_date,
    procure_card_sealed_date_accuracy,
    procure_card_completed_datetime,
    procure_card_completed_datetime_accuracy
  FROM 
    %%local_procure_prod_database%%.ad_whatman_papers
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table aliquot_controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE aliquot_controls;
INSERT INTO aliquot_controls (
    id,
    sample_control_id,
    aliquot_type,
    aliquot_type_precision,
    detail_form_alias,
    detail_tablename,
    volume_unit,
    flag_active,
    comment,
    display_order,
    databrowser_label
)
(
  SELECT
    id,
    sample_control_id,
    aliquot_type,
    aliquot_type_precision,
    detail_form_alias,
    detail_tablename,
    volume_unit,
    flag_active,
    comment,
    display_order,
    databrowser_label
  FROM 
    %%local_procure_prod_database%%.aliquot_controls
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table aliquot_internal_uses
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE aliquot_internal_uses;
INSERT INTO aliquot_internal_uses (
    id,
    aliquot_master_id,
    type,
    use_code,
    use_details,
    used_volume,
    use_datetime,
    use_datetime_accuracy,
    duration,
    duration_unit,
    used_by,
    study_summary_id,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_created_by_bank
)
(
  SELECT
    id,
    aliquot_master_id,
    type,
    use_code,
    use_details,
    used_volume,
    use_datetime,
    use_datetime_accuracy,
    duration,
    duration_unit,
    used_by,
    study_summary_id,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_created_by_bank
  FROM 
    %%local_procure_prod_database%%.aliquot_internal_uses
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table aliquot_masters
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE aliquot_masters;
INSERT INTO aliquot_masters (
    id,
    barcode,
    aliquot_label,
    aliquot_control_id,
    collection_id,
    sample_master_id,
    sop_master_id,
    initial_volume,
    current_volume,
    in_stock,
    in_stock_detail,
    use_counter,
    study_summary_id,
    storage_datetime,
    storage_datetime_accuracy,
    storage_master_id,
    storage_coord_x,
    storage_coord_y,
    product_code,
    notes,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_created_by_bank
)
(
  SELECT
    id,
    barcode,
    aliquot_label,
    aliquot_control_id,
    collection_id,
    sample_master_id,
    sop_master_id,
    initial_volume,
    current_volume,
    in_stock,
    in_stock_detail,
    use_counter,
    study_summary_id,
    storage_datetime,
    storage_datetime_accuracy,
    storage_master_id,
    storage_coord_x,
    storage_coord_y,
    product_code,
    notes,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_created_by_bank
  FROM 
    %%local_procure_prod_database%%.aliquot_masters
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table aliquot_masters_revs
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE aliquot_masters_revs;
INSERT INTO aliquot_masters_revs (
    id,
    barcode,
    aliquot_label,
    aliquot_control_id,
    collection_id,
    sample_master_id,
    sop_master_id,
    initial_volume,
    current_volume,
    in_stock,
    in_stock_detail,
    use_counter,
    study_summary_id,
    storage_datetime,
    storage_datetime_accuracy,
    storage_master_id,
    storage_coord_x,
    storage_coord_y,
    product_code,
    notes,
    modified_by,
    version_id,
    version_created,
    procure_created_by_bank
)
(
  SELECT
    id,
    barcode,
    aliquot_label,
    aliquot_control_id,
    collection_id,
    sample_master_id,
    sop_master_id,
    initial_volume,
    current_volume,
    in_stock,
    in_stock_detail,
    use_counter,
    study_summary_id,
    storage_datetime,
    storage_datetime_accuracy,
    storage_master_id,
    storage_coord_x,
    storage_coord_y,
    product_code,
    notes,
    modified_by,
    version_id,
    version_created,
    procure_created_by_bank
  FROM 
    %%local_procure_prod_database%%.aliquot_masters_revs
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table aliquot_review_controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE aliquot_review_controls;
INSERT INTO aliquot_review_controls (
    id,
    review_type,
    flag_active,
    detail_form_alias,
    detail_tablename,
    aliquot_type_restriction,
    databrowser_label
)
(
  SELECT
    id,
    review_type,
    flag_active,
    detail_form_alias,
    detail_tablename,
    aliquot_type_restriction,
    databrowser_label
  FROM 
    %%local_procure_prod_database%%.aliquot_review_controls
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table aliquot_review_masters
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE aliquot_review_masters;
INSERT INTO aliquot_review_masters (
    id,
    aliquot_review_control_id,
    specimen_review_master_id,
    aliquot_master_id,
    review_code,
    basis_of_specimen_review,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_created_by_bank
)
(
  SELECT
    id,
    aliquot_review_control_id,
    specimen_review_master_id,
    aliquot_master_id,
    review_code,
    basis_of_specimen_review,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_created_by_bank
  FROM 
    %%local_procure_prod_database%%.aliquot_review_masters
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table collections
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE collections;
INSERT INTO collections (
    id,
    acquisition_label,
    bank_id,
    collection_site,
    collection_datetime,
    collection_datetime_accuracy,
    sop_master_id,
    collection_property,
    collection_notes,
    participant_id,
    diagnosis_master_id,
    consent_master_id,
    treatment_master_id,
    event_master_id,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_deprecated_field_procure_patient_identity_verified,
    procure_visit,
    procure_collected_by_bank,
    collection_protocol_id,
    template_id
)
(
  SELECT
    id,
    acquisition_label,
    bank_id,
    collection_site,
    collection_datetime,
    collection_datetime_accuracy,
    sop_master_id,
    collection_property,
    collection_notes,
    participant_id,
    diagnosis_master_id,
    consent_master_id,
    treatment_master_id,
    event_master_id,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_deprecated_field_procure_patient_identity_verified,
    procure_visit,
    procure_collected_by_bank,
    collection_protocol_id,
    template_id
  FROM 
    %%local_procure_prod_database%%.collections
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table consent_controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE consent_controls;
INSERT INTO consent_controls (
    id,
    controls_type,
    flag_active,
    detail_form_alias,
    detail_tablename,
    display_order,
    databrowser_label
)
(
  SELECT
    id,
    controls_type,
    flag_active,
    detail_form_alias,
    detail_tablename,
    display_order,
    databrowser_label
  FROM 
    %%local_procure_prod_database%%.consent_controls
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table consent_masters
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE consent_masters;
INSERT INTO consent_masters (
    id,
    date_of_referral,
    date_of_referral_accuracy,
    route_of_referral,
    date_first_contact,
    date_first_contact_accuracy,
    consent_signed_date,
    consent_signed_date_accuracy,
    form_version,
    reason_denied,
    consent_status,
    process_status,
    status_date,
    status_date_accuracy,
    surgeon,
    operation_date,
    operation_date_accuracy,
    facility,
    notes,
    consent_method,
    translator_indicator,
    translator_signature,
    consent_person,
    facility_other,
    acquisition_id,
    participant_id,
    consent_control_id,
    type,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_deprecated_field_procure_form_identification,
    procure_language,
    study_summary_id,
    procure_created_by_bank
)
(
  SELECT
    id,
    date_of_referral,
    date_of_referral_accuracy,
    route_of_referral,
    date_first_contact,
    date_first_contact_accuracy,
    consent_signed_date,
    consent_signed_date_accuracy,
    form_version,
    reason_denied,
    consent_status,
    process_status,
    status_date,
    status_date_accuracy,
    surgeon,
    operation_date,
    operation_date_accuracy,
    facility,
    notes,
    consent_method,
    translator_indicator,
    translator_signature,
    consent_person,
    facility_other,
    acquisition_id,
    participant_id,
    consent_control_id,
    type,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_deprecated_field_procure_form_identification,
    procure_language,
    study_summary_id,
    procure_created_by_bank
  FROM 
    %%local_procure_prod_database%%.consent_masters
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table derivative_details
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE derivative_details;
INSERT INTO derivative_details (
    sample_master_id,
    creation_site,
    creation_by,
    creation_datetime,
    lab_book_master_id,
    sync_with_lab_book,
    creation_datetime_accuracy
)
(
  SELECT
    sample_master_id,
    creation_site,
    creation_by,
    creation_datetime,
    lab_book_master_id,
    sync_with_lab_book,
    creation_datetime_accuracy
  FROM 
    %%local_procure_prod_database%%.derivative_details
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table diagnosis_controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE diagnosis_controls;
INSERT INTO diagnosis_controls (
    id,
    category,
    controls_type,
    flag_active,
    detail_form_alias,
    detail_tablename,
    display_order,
    databrowser_label,
    flag_compare_with_cap
)
(
  SELECT
    id,
    category,
    controls_type,
    flag_active,
    detail_form_alias,
    detail_tablename,
    display_order,
    databrowser_label,
    flag_compare_with_cap
  FROM 
    %%local_procure_prod_database%%.diagnosis_controls
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table drugs
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE drugs;
INSERT INTO drugs (
    id,
    generic_name,
    trade_name,
    type,
    description,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_study
)
(
  SELECT
    id,
    generic_name,
    trade_name,
    type,
    description,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_study
  FROM 
    %%local_procure_prod_database%%.drugs
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table event_controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE event_controls;
INSERT INTO event_controls (
    id,
    disease_site,
    event_group,
    event_type,
    flag_active,
    detail_form_alias,
    detail_tablename,
    display_order,
    databrowser_label,
    flag_use_for_ccl,
    use_addgrid,
    use_detail_form_for_index
)
(
  SELECT
    id,
    disease_site,
    event_group,
    event_type,
    flag_active,
    detail_form_alias,
    detail_tablename,
    display_order,
    databrowser_label,
    flag_use_for_ccl,
    use_addgrid,
    use_detail_form_for_index
  FROM 
    %%local_procure_prod_database%%.event_controls
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table event_masters
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE event_masters;
INSERT INTO event_masters (
    id,
    event_control_id,
    event_status,
    event_summary,
    event_date,
    event_date_accuracy,
    information_source,
    urgency,
    date_required,
    date_required_accuracy,
    date_requested,
    date_requested_accuracy,
    reference_number,
    created,
    created_by,
    modified,
    modified_by,
    participant_id,
    diagnosis_master_id,
    deleted,
    procure_deprecated_field_procure_form_identification,
    procure_created_by_bank
)
(
  SELECT
    id,
    event_control_id,
    event_status,
    event_summary,
    event_date,
    event_date_accuracy,
    information_source,
    urgency,
    date_required,
    date_required_accuracy,
    date_requested,
    date_requested_accuracy,
    reference_number,
    created,
    created_by,
    modified,
    modified_by,
    participant_id,
    diagnosis_master_id,
    deleted,
    procure_deprecated_field_procure_form_identification,
    procure_created_by_bank
  FROM 
    %%local_procure_prod_database%%.event_masters
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table misc_identifier_controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE misc_identifier_controls;
INSERT INTO misc_identifier_controls (
    id,
    misc_identifier_name,
    flag_active,
    display_order,
    autoincrement_name,
    misc_identifier_format,
    flag_once_per_participant,
    flag_confidential,
    flag_unique,
    pad_to_length,
    reg_exp_validation,
    user_readable_format,
    flag_link_to_study
)
(
  SELECT
    id,
    misc_identifier_name,
    flag_active,
    display_order,
    autoincrement_name,
    misc_identifier_format,
    flag_once_per_participant,
    flag_confidential,
    flag_unique,
    pad_to_length,
    reg_exp_validation,
    user_readable_format,
    flag_link_to_study
  FROM 
    %%local_procure_prod_database%%.misc_identifier_controls
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table misc_identifiers
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE misc_identifiers;
INSERT INTO misc_identifiers (
    id,
    identifier_value,
    misc_identifier_control_id,
    effective_date,
    effective_date_accuracy,
    expiry_date,
    expiry_date_accuracy,
    notes,
    participant_id,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    tmp_deleted,
    flag_unique,
    study_summary_id
)
(
  SELECT
    id,
    identifier_value,
    misc_identifier_control_id,
    effective_date,
    effective_date_accuracy,
    expiry_date,
    expiry_date_accuracy,
    notes,
    participant_id,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    tmp_deleted,
    flag_unique,
    study_summary_id
  FROM 
    %%local_procure_prod_database%%.misc_identifiers
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table orders
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE orders;
INSERT INTO orders (
    id,
    order_number,
    short_title,
    description,
    date_order_placed,
    date_order_placed_accuracy,
    date_order_completed,
    date_order_completed_accuracy,
    processing_status,
    comments,
    created,
    created_by,
    modified,
    modified_by,
    default_study_summary_id,
    institution,
    contact,
    default_required_date,
    deleted,
    default_required_date_accuracy,
    procure_created_by_bank
)
(
  SELECT
    id,
    order_number,
    short_title,
    description,
    date_order_placed,
    date_order_placed_accuracy,
    date_order_completed,
    date_order_completed_accuracy,
    processing_status,
    comments,
    created,
    created_by,
    modified,
    modified_by,
    default_study_summary_id,
    institution,
    contact,
    default_required_date,
    deleted,
    default_required_date_accuracy,
    procure_created_by_bank
  FROM 
    %%local_procure_prod_database%%.orders
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table order_items
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE order_items;
INSERT INTO order_items (
    id,
    date_added,
    date_added_accuracy,
    added_by,
    status,
    created,
    created_by,
    modified,
    modified_by,
    order_line_id,
    shipment_id,
    aliquot_master_id,
    deleted,
    order_id,
    procure_shipping_aliquot_label,
    date_returned,
    date_returned_accuracy,
    reason_returned,
    reception_by,
    tma_slide_id,
    procure_created_by_bank,
    order_item_shipping_label
)
(
  SELECT
    id,
    date_added,
    date_added_accuracy,
    added_by,
    status,
    created,
    created_by,
    modified,
    modified_by,
    order_line_id,
    shipment_id,
    aliquot_master_id,
    deleted,
    order_id,
    procure_shipping_aliquot_label,
    date_returned,
    date_returned_accuracy,
    reason_returned,
    reception_by,
    tma_slide_id,
    procure_created_by_bank,
    order_item_shipping_label
  FROM 
    %%local_procure_prod_database%%.order_items
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table order_lines
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE order_lines;
INSERT INTO order_lines (
    id,
    quantity_ordered,
    min_quantity_ordered,
    quantity_unit,
    date_required,
    date_required_accuracy,
    status,
    created,
    created_by,
    modified,
    modified_by,
    sample_control_id,
    aliquot_control_id,
    product_type_precision,
    order_id,
    study_summary_id,
    deleted,
    is_tma_slide
)
(
  SELECT
    id,
    quantity_ordered,
    min_quantity_ordered,
    quantity_unit,
    date_required,
    date_required_accuracy,
    status,
    created,
    created_by,
    modified,
    modified_by,
    sample_control_id,
    aliquot_control_id,
    product_type_precision,
    order_id,
    study_summary_id,
    deleted,
    is_tma_slide
  FROM 
    %%local_procure_prod_database%%.order_lines
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table participants
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE participants;
INSERT INTO participants (
    id,
    title,
    first_name,
    middle_name,
    last_name,
    date_of_birth,
    date_of_birth_accuracy,
    marital_status,
    language_preferred,
    sex,
    race,
    vital_status,
    notes,
    date_of_death,
    date_of_death_accuracy,
    procure_cause_of_death,
    cod_icd10_code,
    secondary_cod_icd10_code,
    cod_confirmation_source,
    participant_identifier,
    last_chart_checked_date,
    last_chart_checked_date_accuracy,
    last_modification,
    last_modification_ds_id,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_patient_withdrawn,
    procure_patient_refusal_withdrawal_date,
    procure_patient_refusal_withdrawal_date_accuracy,
    procure_patient_refusal_withdrawal_reason,
    procure_transferred_participant,
    procure_participant_attribution_number,
    procure_last_modification_by_bank,
    procure_last_contact,
    procure_last_contact_accuracy,
    procure_last_contact_details,
    procure_next_collections_refusal,
    procure_next_visits_refusal,
    procure_refusal_to_be_contacted,
    procure_clinical_file_update_refusal,
    procure_contact_lost
)
(
  SELECT
    id,
    title,
    first_name,
    middle_name,
    last_name,
    date_of_birth,
    date_of_birth_accuracy,
    marital_status,
    language_preferred,
    sex,
    race,
    vital_status,
    notes,
    date_of_death,
    date_of_death_accuracy,
    procure_cause_of_death,
    cod_icd10_code,
    secondary_cod_icd10_code,
    cod_confirmation_source,
    participant_identifier,
    last_chart_checked_date,
    last_chart_checked_date_accuracy,
    last_modification,
    last_modification_ds_id,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_patient_withdrawn,
    procure_patient_refusal_withdrawal_date,
    procure_patient_refusal_withdrawal_date_accuracy,
    procure_patient_refusal_withdrawal_reason,
    procure_transferred_participant,
    procure_participant_attribution_number,
    procure_last_modification_by_bank,
    procure_last_contact,
    procure_last_contact_accuracy,
    procure_last_contact_details,
    procure_next_collections_refusal,
    procure_next_visits_refusal,
    procure_refusal_to_be_contacted,
    procure_clinical_file_update_refusal,
    procure_contact_lost
  FROM 
    %%local_procure_prod_database%%.participants
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table parent_to_derivative_sample_controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE parent_to_derivative_sample_controls;
INSERT INTO parent_to_derivative_sample_controls (
    id,
    parent_sample_control_id,
    derivative_sample_control_id,
    flag_active,
    lab_book_control_id
)
(
  SELECT
    id,
    parent_sample_control_id,
    derivative_sample_control_id,
    flag_active,
    lab_book_control_id
  FROM 
    %%local_procure_prod_database%%.parent_to_derivative_sample_controls
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table procure_cd_sigantures
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE procure_cd_sigantures;
INSERT INTO procure_cd_sigantures (
    consent_master_id,
    revised_date,
    revised_date_accuracy,
    procure_deprecated_field_patient_identity_verified,
    ps1_biological_material_use,
    ps1_use_of_urine,
    ps1_use_of_blood,
    ps1_research_other_disease,
    ps1_urine_blood_use_for_followup,
    ps1_stop_followup,
    ps1_stop_followup_date,
    ps1_allow_questionnaire,
    ps1_stop_questionnaire,
    ps1_stop_questionnaire_date,
    ps1_contact_for_additional_data,
    ps1_inform_significant_discovery,
    ps1_inform_discovery_on_other_disease,
    ps2_tissue,
    ps2_blood,
    ps2_urine,
    ps2_followup,
    ps2_questionnaire,
    ps2_contact_for_additional_data,
    ps2_inform_significant_discovery,
    ps2_contact_in_case_of_death,
    ps2_witness,
    ps2_complete,
    ps4_contact_for_more_info,
    ps4_contact_if_scientific_discovery,
    ps4_study_on_other_diseases,
    ps4_contact_if_discovery_on_other_diseases,
    ps4_other_contacts_in_case_of_death
)
(
  SELECT
    consent_master_id,
    revised_date,
    revised_date_accuracy,
    procure_deprecated_field_patient_identity_verified,
    ps1_biological_material_use,
    ps1_use_of_urine,
    ps1_use_of_blood,
    ps1_research_other_disease,
    ps1_urine_blood_use_for_followup,
    ps1_stop_followup,
    ps1_stop_followup_date,
    ps1_allow_questionnaire,
    ps1_stop_questionnaire,
    ps1_stop_questionnaire_date,
    ps1_contact_for_additional_data,
    ps1_inform_significant_discovery,
    ps1_inform_discovery_on_other_disease,
    ps2_tissue,
    ps2_blood,
    ps2_urine,
    ps2_followup,
    ps2_questionnaire,
    ps2_contact_for_additional_data,
    ps2_inform_significant_discovery,
    ps2_contact_in_case_of_death,
    ps2_witness,
    ps2_complete,
    ps4_contact_for_more_info,
    ps4_contact_if_scientific_discovery,
    ps4_study_on_other_diseases,
    ps4_contact_if_discovery_on_other_diseases,
    ps4_other_contacts_in_case_of_death
  FROM 
    %%local_procure_prod_database%%.procure_cd_sigantures
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table procure_ar_tissue_slides
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE procure_ar_tissue_slides;
INSERT INTO procure_ar_tissue_slides (
    aliquot_review_master_id,
    gleason_grade,
    gleason_sum,
    tissue_type,
    tumor_pct,
    tumor_size_length_mm,
    tumor_size_width_mm
)
(
  SELECT
    aliquot_review_master_id,
    gleason_grade,
    gleason_sum,
    tissue_type,
    tumor_pct,
    tumor_size_length_mm,
    tumor_size_width_mm
  FROM 
    %%local_procure_prod_database%%.procure_ar_tissue_slides
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table procure_ed_clinical_exams
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE procure_ed_clinical_exams;
INSERT INTO procure_ed_clinical_exams (
    type,
    event_master_id,
    results,
    site_precision,
    progression_comorbidity,
    clinical_relapse
)
(
  SELECT
    type,
    event_master_id,
    results,
    site_precision,
    progression_comorbidity,
    clinical_relapse
  FROM 
    %%local_procure_prod_database%%.procure_ed_clinical_exams
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table procure_ed_clinical_notes
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE procure_ed_clinical_notes;
INSERT INTO procure_ed_clinical_notes (
    event_master_id,
    type
)
(
  SELECT
    event_master_id,
    type
  FROM 
    %%local_procure_prod_database%%.procure_ed_clinical_notes
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table procure_ed_laboratories
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE procure_ed_laboratories;
INSERT INTO procure_ed_laboratories (
    psa_total_ngml,
    event_master_id,
    biochemical_relapse,
    testosterone_nmoll,
    procure_deprecated_field_psa_free_ngml,
    bcr_definition_precision,
    system_biochemical_relapse
)
(
  SELECT
    psa_total_ngml,
    event_master_id,
    biochemical_relapse,
    testosterone_nmoll,
    procure_deprecated_field_psa_free_ngml,
    bcr_definition_precision,
    system_biochemical_relapse
  FROM 
    %%local_procure_prod_database%%.procure_ed_laboratories
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table procure_ed_lab_pathologies
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE procure_ed_lab_pathologies;
INSERT INTO procure_ed_lab_pathologies (
    path_number,
    pathologist_name,
    prostate_weight_gr,
    prostate_length_cm,
    prostate_width_cm,
    prostate_thickness_cm,
    right_seminal_vesicle_length_cm,
    right_seminal_vesicle_width_cm,
    right_seminal_vesicle_thickness_cm,
    left_seminal_vesicle_length_cm,
    left_seminal_vesicle_width_cm,
    left_seminal_vesicle_thickness_cm,
    histology,
    histology_other_precision,
    tumour_location_right_anterior,
    tumour_location_left_anterior,
    tumour_location_right_posterior,
    tumour_location_left_posterior,
    tumour_location_apex,
    tumour_location_base,
    tumour_location_bladder_neck,
    tumour_volume,
    histologic_grade_primary_pattern,
    histologic_grade_secondary_pattern,
    histologic_grade_tertiary_pattern,
    histologic_grade_gleason_score,
    margins,
    margins_focal_or_extensive,
    margins_extensive_anterior_left,
    margins_extensive_anterior_right,
    margins_extensive_posterior_left,
    margins_extensive_posterior_right,
    margins_extensive_apical_anterior_left,
    margins_extensive_apical_anterior_right,
    margins_extensive_apical_posterior_left,
    margins_extensive_apical_posterior_right,
    margins_extensive_bladder_neck,
    margins_extensive_base,
    margins_gleason_score,
    extra_prostatic_extension,
    extra_prostatic_extension_precision,
    extra_prostatic_extension_right_anterior,
    extra_prostatic_extension_left_anterior,
    extra_prostatic_extension_right_posterior,
    extra_prostatic_extension_left_posterior,
    extra_prostatic_extension_apex,
    extra_prostatic_extension_base,
    extra_prostatic_extension_bladder_neck,
    extra_prostatic_extension_seminal_vesicles,
    pathologic_staging_version,
    pathologic_staging_pt,
    pathologic_staging_pn_collected,
    pathologic_staging_pn,
    pathologic_staging_pn_lymph_node_examined,
    pathologic_staging_pn_lymph_node_involved,
    pathologic_staging_pm,
    event_master_id
)
(
  SELECT
    path_number,
    pathologist_name,
    prostate_weight_gr,
    prostate_length_cm,
    prostate_width_cm,
    prostate_thickness_cm,
    right_seminal_vesicle_length_cm,
    right_seminal_vesicle_width_cm,
    right_seminal_vesicle_thickness_cm,
    left_seminal_vesicle_length_cm,
    left_seminal_vesicle_width_cm,
    left_seminal_vesicle_thickness_cm,
    histology,
    histology_other_precision,
    tumour_location_right_anterior,
    tumour_location_left_anterior,
    tumour_location_right_posterior,
    tumour_location_left_posterior,
    tumour_location_apex,
    tumour_location_base,
    tumour_location_bladder_neck,
    tumour_volume,
    histologic_grade_primary_pattern,
    histologic_grade_secondary_pattern,
    histologic_grade_tertiary_pattern,
    histologic_grade_gleason_score,
    margins,
    margins_focal_or_extensive,
    margins_extensive_anterior_left,
    margins_extensive_anterior_right,
    margins_extensive_posterior_left,
    margins_extensive_posterior_right,
    margins_extensive_apical_anterior_left,
    margins_extensive_apical_anterior_right,
    margins_extensive_apical_posterior_left,
    margins_extensive_apical_posterior_right,
    margins_extensive_bladder_neck,
    margins_extensive_base,
    margins_gleason_score,
    extra_prostatic_extension,
    extra_prostatic_extension_precision,
    extra_prostatic_extension_right_anterior,
    extra_prostatic_extension_left_anterior,
    extra_prostatic_extension_right_posterior,
    extra_prostatic_extension_left_posterior,
    extra_prostatic_extension_apex,
    extra_prostatic_extension_base,
    extra_prostatic_extension_bladder_neck,
    extra_prostatic_extension_seminal_vesicles,
    pathologic_staging_version,
    pathologic_staging_pt,
    pathologic_staging_pn_collected,
    pathologic_staging_pn,
    pathologic_staging_pn_lymph_node_examined,
    pathologic_staging_pn_lymph_node_involved,
    pathologic_staging_pm,
    event_master_id
  FROM 
    %%local_procure_prod_database%%.procure_ed_lab_pathologies
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table procure_ed_other_tumor_diagnosis
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE procure_ed_other_tumor_diagnosis;
INSERT INTO procure_ed_other_tumor_diagnosis (
    event_master_id,
    tumor_site
)
(
  SELECT
    event_master_id,
    tumor_site
  FROM 
    %%local_procure_prod_database%%.procure_ed_other_tumor_diagnosis
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table procure_ed_prostate_cancer_diagnosis
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE procure_ed_prostate_cancer_diagnosis;
INSERT INTO procure_ed_prostate_cancer_diagnosis (
    procure_deprecated_field_data_collection_date,
    procure_deprecated_field_data_collection_date_accuracy,
    procure_deprecated_field_patient_identity_verified,
    biopsy_pre_surgery_date,
    biopsy_pre_surgery_date_accuracy,
    procure_deprecated_aps_pre_surgery_total_ng_ml,
    procure_deprecated_aps_pre_surgery_free_ng_ml,
    procure_deprecated_field_aps_pre_surgery_date,
    procure_deprecated_field_aps_pre_surgery_date_accuracy,
    collected_cores_nbr,
    nbr_of_cores_with_cancer,
    histologic_grade_primary_pattern,
    histologic_grade_secondary_pattern,
    histologic_grade_gleason_total,
    procure_deprecated_field_biopsies_before,
    procure_deprecated_field_biopsy_date,
    procure_deprecated_field_biopsy_date_accuracy,
    event_master_id,
    affected_core_localisation,
    affected_core_total_percentage,
    highest_gleason_score_observed,
    highest_gleason_score_percentage
)
(
  SELECT
    procure_deprecated_field_data_collection_date,
    procure_deprecated_field_data_collection_date_accuracy,
    procure_deprecated_field_patient_identity_verified,
    biopsy_pre_surgery_date,
    biopsy_pre_surgery_date_accuracy,
    procure_deprecated_aps_pre_surgery_total_ng_ml,
    procure_deprecated_aps_pre_surgery_free_ng_ml,
    procure_deprecated_field_aps_pre_surgery_date,
    procure_deprecated_field_aps_pre_surgery_date_accuracy,
    collected_cores_nbr,
    nbr_of_cores_with_cancer,
    histologic_grade_primary_pattern,
    histologic_grade_secondary_pattern,
    histologic_grade_gleason_total,
    procure_deprecated_field_biopsies_before,
    procure_deprecated_field_biopsy_date,
    procure_deprecated_field_biopsy_date_accuracy,
    event_master_id,
    affected_core_localisation,
    affected_core_total_percentage,
    highest_gleason_score_observed,
    highest_gleason_score_percentage
  FROM 
    %%local_procure_prod_database%%.procure_ed_prostate_cancer_diagnosis
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table procure_ed_questionnaires
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE procure_ed_questionnaires;
INSERT INTO procure_ed_questionnaires (
    procure_deprecated_field_patient_identity_verified,
    delivery_date,
    delivery_date_accuracy,
    delivery_site_method,
    method_to_complete,
    recovery_date,
    recovery_date_accuracy,
    recovery_method,
    verification_date,
    verification_date_accuracy,
    revision_date,
    revision_date_accuracy,
    revision_method,
    version,
    version_date,
    spent_time_delivery_to_recovery,
    event_master_id,
    complete
)
(
  SELECT
    procure_deprecated_field_patient_identity_verified,
    delivery_date,
    delivery_date_accuracy,
    delivery_site_method,
    method_to_complete,
    recovery_date,
    recovery_date_accuracy,
    recovery_method,
    verification_date,
    verification_date_accuracy,
    revision_date,
    revision_date_accuracy,
    revision_method,
    version,
    version_date,
    spent_time_delivery_to_recovery,
    event_master_id,
    complete
  FROM 
    %%local_procure_prod_database%%.procure_ed_questionnaires
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table procure_ed_visits
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE procure_ed_visits;
INSERT INTO procure_ed_visits (
    procure_deprecated_field_patient_identity_verified,
    procure_deprecated_field_biochemical_recurrence,
    procure_deprecated_field_clinical_recurrence,
    procure_deprecated_field_clinical_recurrence_type,
    procure_deprecated_field_surgery_for_metastases,
    procure_deprecated_field_surgery_site,
    procure_deprecated_field_surgery_date,
    surgery_date_accuracy,
    event_master_id,
    procure_deprecated_field_clinical_recurrence_site_bones,
    procure_deprecated_field_clinical_recurrence_site_liver,
    procure_deprecated_field_clinical_recurrence_site_lungs,
    procure_deprecated_field_clinical_recurrence_site_others,
    refusing_treatments,
    method,
    medication_for_prostate_cancer,
    medication_for_benign_prostatic_hyperplasia,
    medication_for_prostatitis,
    prescribed_drugs_for_other_diseases,
    list_of_drugs_for_other_diseases,
    photocopy_of_drugs_for_other_diseases,
    dosages_of_drugs_for_other_diseases,
    open_sale_drugs
)
(
  SELECT
    procure_deprecated_field_patient_identity_verified,
    procure_deprecated_field_biochemical_recurrence,
    procure_deprecated_field_clinical_recurrence,
    procure_deprecated_field_clinical_recurrence_type,
    procure_deprecated_field_surgery_for_metastases,
    procure_deprecated_field_surgery_site,
    procure_deprecated_field_surgery_date,
    surgery_date_accuracy,
    event_master_id,
    procure_deprecated_field_clinical_recurrence_site_bones,
    procure_deprecated_field_clinical_recurrence_site_liver,
    procure_deprecated_field_clinical_recurrence_site_lungs,
    procure_deprecated_field_clinical_recurrence_site_others,
    refusing_treatments,
    method,
    medication_for_prostate_cancer,
    medication_for_benign_prostatic_hyperplasia,
    medication_for_prostatitis,
    prescribed_drugs_for_other_diseases,
    list_of_drugs_for_other_diseases,
    photocopy_of_drugs_for_other_diseases,
    dosages_of_drugs_for_other_diseases,
    open_sale_drugs
  FROM 
    %%local_procure_prod_database%%.procure_ed_visits
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table procure_spr_prostate
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE procure_spr_prostate;
INSERT INTO procure_spr_prostate (
    specimen_review_master_id
)
(
  SELECT
    specimen_review_master_id
  FROM 
    %%local_procure_prod_database%%.procure_spr_prostate
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table procure_txd_treatments
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE procure_txd_treatments;
INSERT INTO procure_txd_treatments (
    treatment_type,
    dosage,
    treatment_master_id,
    procure_deprecated_field_drug_id,
    treatment_site,
    treatment_precision,
    treatment_combination,
    procure_deprecated_field_treatment_line,
    duration,
    surgery_type
)
(
  SELECT
    treatment_type,
    dosage,
    treatment_master_id,
    procure_deprecated_field_drug_id,
    treatment_site,
    treatment_precision,
    treatment_combination,
    procure_deprecated_field_treatment_line,
    duration,
    surgery_type
  FROM 
    %%local_procure_prod_database%%.procure_txd_treatments
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table quality_ctrls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE quality_ctrls;
INSERT INTO quality_ctrls (
    id,
    qc_code,
    sample_master_id,
    type,
    qc_type_precision,
    tool,
    run_id,
    run_by,
    date,
    date_accuracy,
    score,
    unit,
    conclusion,
    notes,
    aliquot_master_id,
    used_volume,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_appended_spectras,
    procure_analysis_by,
    procure_created_by_bank,
    procure_concentration,
    procure_concentration_unit
)
(
  SELECT
    id,
    qc_code,
    sample_master_id,
    type,
    qc_type_precision,
    tool,
    run_id,
    run_by,
    date,
    date_accuracy,
    score,
    unit,
    conclusion,
    notes,
    aliquot_master_id,
    used_volume,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_appended_spectras,
    procure_analysis_by,
    procure_created_by_bank,
    procure_concentration,
    procure_concentration_unit
  FROM 
    %%local_procure_prod_database%%.quality_ctrls
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table realiquotings
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE realiquotings;
INSERT INTO realiquotings (
    id,
    parent_aliquot_master_id,
    child_aliquot_master_id,
    parent_used_volume,
    realiquoting_datetime,
    realiquoting_datetime_accuracy,
    realiquoted_by,
    lab_book_master_id,
    sync_with_lab_book,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_central_is_transfer
)
(
  SELECT
    id,
    parent_aliquot_master_id,
    child_aliquot_master_id,
    parent_used_volume,
    realiquoting_datetime,
    realiquoting_datetime_accuracy,
    realiquoted_by,
    lab_book_master_id,
    sync_with_lab_book,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_central_is_transfer
  FROM 
    %%local_procure_prod_database%%.realiquotings
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table sample_controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE sample_controls;
INSERT INTO sample_controls (
    id,
    sample_type,
    sample_category,
    detail_form_alias,
    detail_tablename,
    display_order,
    databrowser_label
)
(
  SELECT
    id,
    sample_type,
    sample_category,
    detail_form_alias,
    detail_tablename,
    display_order,
    databrowser_label
  FROM 
    %%local_procure_prod_database%%.sample_controls
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table sample_masters
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE sample_masters;
INSERT INTO sample_masters (
    id,
    sample_code,
    sample_control_id,
    initial_specimen_sample_id,
    initial_specimen_sample_type,
    collection_id,
    parent_id,
    parent_sample_type,
    sop_master_id,
    product_code,
    is_problematic,
    notes,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_created_by_bank
)
(
  SELECT
    id,
    sample_code,
    sample_control_id,
    initial_specimen_sample_id,
    initial_specimen_sample_type,
    collection_id,
    parent_id,
    parent_sample_type,
    sop_master_id,
    product_code,
    is_problematic,
    notes,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_created_by_bank
  FROM 
    %%local_procure_prod_database%%.sample_masters
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table sd_der_amp_rnas
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE sd_der_amp_rnas;
INSERT INTO sd_der_amp_rnas (
    sample_master_id
)
(
  SELECT
    sample_master_id
  FROM 
    %%local_procure_prod_database%%.sd_der_amp_rnas
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table sd_der_buffy_coats
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE sd_der_buffy_coats;
INSERT INTO sd_der_buffy_coats (
    sample_master_id
)
(
  SELECT
    sample_master_id
  FROM 
    %%local_procure_prod_database%%.sd_der_buffy_coats
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table sd_der_cdnas
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE sd_der_cdnas;
INSERT INTO sd_der_cdnas (
    sample_master_id
)
(
  SELECT
    sample_master_id
  FROM 
    %%local_procure_prod_database%%.sd_der_cdnas
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table sd_der_dnas
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE sd_der_dnas;
INSERT INTO sd_der_dnas (
    sample_master_id
)
(
  SELECT
    sample_master_id
  FROM 
    %%local_procure_prod_database%%.sd_der_dnas
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table sd_der_pbmcs
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE sd_der_pbmcs;
INSERT INTO sd_der_pbmcs (
    sample_master_id,
    procure_blood_volume_used_ml
)
(
  SELECT
    sample_master_id,
    procure_blood_volume_used_ml
  FROM 
    %%local_procure_prod_database%%.sd_der_pbmcs
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table sd_der_plasmas
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE sd_der_plasmas;
INSERT INTO sd_der_plasmas (
    sample_master_id
)
(
  SELECT
    sample_master_id
  FROM 
    %%local_procure_prod_database%%.sd_der_plasmas
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table sd_der_rnas
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE sd_der_rnas;
INSERT INTO sd_der_rnas (
    sample_master_id
)
(
  SELECT
    sample_master_id
  FROM 
    %%local_procure_prod_database%%.sd_der_rnas
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table sd_der_serums
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE sd_der_serums;
INSERT INTO sd_der_serums (
    sample_master_id
)
(
  SELECT
    sample_master_id
  FROM 
    %%local_procure_prod_database%%.sd_der_serums
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table sd_der_urine_cents
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE sd_der_urine_cents;
INSERT INTO sd_der_urine_cents (
    sample_master_id,
    procure_deprecated_field_processed_at_reception,
    procure_deprecated_field_conserved_at_4,
    procure_deprecated_field_time_at_4,
    procure_deprecated_field_aspect_after_refrigeration,
    procure_deprecated_field_other_aspect_after_refrigeration,
    procure_deprecated_field_aspect_after_centrifugation,
    procure_deprecated_field_other_aspect_after_centrifugation,
    procure_pellet_aspect_after_centrifugation,
    procure_other_pellet_aspect_after_centrifugation,
    procure_approximatif_pellet_volume_ml,
    procure_deprecated_field_procure_pellet_volume_ml,
    procure_concentrated
)
(
  SELECT
    sample_master_id,
    procure_deprecated_field_processed_at_reception,
    procure_deprecated_field_conserved_at_4,
    procure_deprecated_field_time_at_4,
    procure_deprecated_field_aspect_after_refrigeration,
    procure_deprecated_field_other_aspect_after_refrigeration,
    procure_deprecated_field_aspect_after_centrifugation,
    procure_deprecated_field_other_aspect_after_centrifugation,
    procure_pellet_aspect_after_centrifugation,
    procure_other_pellet_aspect_after_centrifugation,
    procure_approximatif_pellet_volume_ml,
    procure_deprecated_field_procure_pellet_volume_ml,
    procure_concentrated
  FROM 
    %%local_procure_prod_database%%.sd_der_urine_cents
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table sd_spe_bloods
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE sd_spe_bloods;
INSERT INTO sd_spe_bloods (
    sample_master_id,
    blood_type,
    collected_tube_nbr,
    collected_volume,
    collected_volume_unit,
    procure_collection_site,
    procure_deprecated_field_collection_without_incident,
    procure_deprecated_field_tubes_inverted_8_10_times,
    procure_deprecated_field_tubes_correclty_stored
)
(
  SELECT
    sample_master_id,
    blood_type,
    collected_tube_nbr,
    collected_volume,
    collected_volume_unit,
    procure_collection_site,
    procure_deprecated_field_collection_without_incident,
    procure_deprecated_field_tubes_inverted_8_10_times,
    procure_deprecated_field_tubes_correclty_stored
  FROM 
    %%local_procure_prod_database%%.sd_spe_bloods
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table sd_spe_tissues
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE sd_spe_tissues;
INSERT INTO sd_spe_tissues (
    sample_master_id,
    tissue_source,
    tissue_nature,
    tissue_laterality,
    pathology_reception_datetime,
    pathology_reception_datetime_accuracy,
    tissue_size,
    tissue_size_unit,
    tissue_weight,
    tissue_weight_unit,
    procure_tissue_identification,
    procure_prostatectomy_type,
    procure_prostatectomy_beginning_time,
    procure_prostatectomy_resection_time,
    procure_surgeon_name,
    procure_sample_number,
    procure_transfer_to_pathology_on_ice,
    procure_transfer_to_pathology_time,
    procure_arrival_in_pathology_time,
    procure_pathologist_name,
    procure_report_number,
    procure_reference_to_biopsy_report,
    procure_ink_external_color,
    procure_prostate_slicing_beginning_time,
    procure_number_of_slides_collected,
    procure_number_of_slides_collected_for_procure,
    procure_prostate_slicing_ending_time,
    prostate_fixation_time,
    procure_lymph_nodes_fixation_time,
    procure_fixation_process_duration_hr
)
(
  SELECT
    sample_master_id,
    tissue_source,
    tissue_nature,
    tissue_laterality,
    pathology_reception_datetime,
    pathology_reception_datetime_accuracy,
    tissue_size,
    tissue_size_unit,
    tissue_weight,
    tissue_weight_unit,
    procure_tissue_identification,
    procure_prostatectomy_type,
    procure_prostatectomy_beginning_time,
    procure_prostatectomy_resection_time,
    procure_surgeon_name,
    procure_sample_number,
    procure_transfer_to_pathology_on_ice,
    procure_transfer_to_pathology_time,
    procure_arrival_in_pathology_time,
    procure_pathologist_name,
    procure_report_number,
    procure_reference_to_biopsy_report,
    procure_ink_external_color,
    procure_prostate_slicing_beginning_time,
    procure_number_of_slides_collected,
    procure_number_of_slides_collected_for_procure,
    procure_prostate_slicing_ending_time,
    prostate_fixation_time,
    procure_lymph_nodes_fixation_time,
    procure_fixation_process_duration_hr
  FROM 
    %%local_procure_prod_database%%.sd_spe_tissues
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table sd_spe_urines
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE sd_spe_urines;
INSERT INTO sd_spe_urines (
    sample_master_id,
    urine_aspect,
    collected_volume,
    collected_volume_unit,
    pellet_signs,
    pellet_volume,
    pellet_volume_unit,
    procure_other_urine_aspect,
    procure_hematuria,
    procure_collected_via_catheter
)
(
  SELECT
    sample_master_id,
    urine_aspect,
    collected_volume,
    collected_volume_unit,
    pellet_signs,
    pellet_volume,
    pellet_volume_unit,
    procure_other_urine_aspect,
    procure_hematuria,
    procure_collected_via_catheter
  FROM 
    %%local_procure_prod_database%%.sd_spe_urines
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table shipments
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE shipments;
INSERT INTO shipments (
    id,
    shipment_code,
    recipient,
    facility,
    delivery_street_address,
    delivery_city,
    delivery_province,
    delivery_postal_code,
    delivery_country,
    delivery_phone_number,
    delivery_department_or_door,
    delivery_notes,
    shipping_company,
    shipping_account_nbr,
    tracking,
    datetime_shipped,
    datetime_shipped_accuracy,
    datetime_received,
    datetime_received_accuracy,
    shipped_by,
    created,
    created_by,
    modified,
    modified_by,
    order_id,
    deleted,
    procure_shipping_conditions,
    procure_created_by_bank
)
(
  SELECT
    id,
    shipment_code,
    recipient,
    facility,
    delivery_street_address,
    delivery_city,
    delivery_province,
    delivery_postal_code,
    delivery_country,
    delivery_phone_number,
    delivery_department_or_door,
    delivery_notes,
    shipping_company,
    shipping_account_nbr,
    tracking,
    datetime_shipped,
    datetime_shipped_accuracy,
    datetime_received,
    datetime_received_accuracy,
    shipped_by,
    created,
    created_by,
    modified,
    modified_by,
    order_id,
    deleted,
    procure_shipping_conditions,
    procure_created_by_bank
  FROM 
    %%local_procure_prod_database%%.shipments
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table source_aliquots
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE source_aliquots;
INSERT INTO source_aliquots (
    id,
    sample_master_id,
    aliquot_master_id,
    used_volume,
    created,
    created_by,
    modified,
    modified_by,
    deleted
)
(
  SELECT
    id,
    sample_master_id,
    aliquot_master_id,
    used_volume,
    created,
    created_by,
    modified,
    modified_by,
    deleted
  FROM 
    %%local_procure_prod_database%%.source_aliquots
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table specimen_details
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE specimen_details;
INSERT INTO specimen_details (
    sample_master_id,
    supplier_dept,
    time_at_room_temp_mn,
    reception_by,
    reception_datetime,
    reception_datetime_accuracy,
    procure_refrigeration_time
)
(
  SELECT
    sample_master_id,
    supplier_dept,
    time_at_room_temp_mn,
    reception_by,
    reception_datetime,
    reception_datetime_accuracy,
    procure_refrigeration_time
  FROM 
    %%local_procure_prod_database%%.specimen_details
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table specimen_review_controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE specimen_review_controls;
INSERT INTO specimen_review_controls (
    id,
    sample_control_id,
    aliquot_review_control_id,
    review_type,
    flag_active,
    detail_form_alias,
    detail_tablename,
    databrowser_label
)
(
  SELECT
    id,
    sample_control_id,
    aliquot_review_control_id,
    review_type,
    flag_active,
    detail_form_alias,
    detail_tablename,
    databrowser_label
  FROM 
    %%local_procure_prod_database%%.specimen_review_controls
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table specimen_review_masters
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE specimen_review_masters;
INSERT INTO specimen_review_masters (
    id,
    specimen_review_control_id,
    collection_id,
    sample_master_id,
    review_code,
    review_date,
    review_date_accuracy,
    review_status,
    pathologist,
    notes,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_created_by_bank
)
(
  SELECT
    id,
    specimen_review_control_id,
    collection_id,
    sample_master_id,
    review_code,
    review_date,
    review_date_accuracy,
    review_status,
    pathologist,
    notes,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_created_by_bank
  FROM 
    %%local_procure_prod_database%%.specimen_review_masters
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table std_boxs
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE std_boxs;
INSERT INTO std_boxs (
    storage_master_id
)
(
  SELECT
    storage_master_id
  FROM 
    %%local_procure_prod_database%%.std_boxs
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table std_cupboards
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE std_cupboards;
INSERT INTO std_cupboards (
    storage_master_id
)
(
  SELECT
    storage_master_id
  FROM 
    %%local_procure_prod_database%%.std_cupboards
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table std_customs
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE std_customs;
INSERT INTO std_customs (
    storage_master_id
)
(
  SELECT
    storage_master_id
  FROM 
    %%local_procure_prod_database%%.std_customs
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table std_freezers
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE std_freezers;
INSERT INTO std_freezers (
    storage_master_id
)
(
  SELECT
    storage_master_id
  FROM 
    %%local_procure_prod_database%%.std_freezers
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table std_fridges
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE std_fridges;
INSERT INTO std_fridges (
    storage_master_id
)
(
  SELECT
    storage_master_id
  FROM 
    %%local_procure_prod_database%%.std_fridges
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table std_incubators
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE std_incubators;
INSERT INTO std_incubators (
    storage_master_id,
    oxygen_perc,
    carbonic_gaz_perc
)
(
  SELECT
    storage_master_id,
    oxygen_perc,
    carbonic_gaz_perc
  FROM 
    %%local_procure_prod_database%%.std_incubators
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table std_nitro_locates
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE std_nitro_locates;
INSERT INTO std_nitro_locates (
    storage_master_id
)
(
  SELECT
    storage_master_id
  FROM 
    %%local_procure_prod_database%%.std_nitro_locates
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table std_racks
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE std_racks;
INSERT INTO std_racks (
    storage_master_id
)
(
  SELECT
    storage_master_id
  FROM 
    %%local_procure_prod_database%%.std_racks
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table std_rooms
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE std_rooms;
INSERT INTO std_rooms (
    storage_master_id,
    laboratory,
    floor
)
(
  SELECT
    storage_master_id,
    laboratory,
    floor
  FROM 
    %%local_procure_prod_database%%.std_rooms
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table std_shelfs
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE std_shelfs;
INSERT INTO std_shelfs (
    storage_master_id
)
(
  SELECT
    storage_master_id
  FROM 
    %%local_procure_prod_database%%.std_shelfs
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table std_tma_blocks
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE std_tma_blocks;
INSERT INTO std_tma_blocks (
    storage_master_id,
    sop_master_id,
    product_code,
    creation_datetime,
    creation_datetime_accuracy
)
(
  SELECT
    storage_master_id,
    sop_master_id,
    product_code,
    creation_datetime,
    creation_datetime_accuracy
  FROM 
    %%local_procure_prod_database%%.std_tma_blocks
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table storage_controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE storage_controls;
INSERT INTO storage_controls (
    id,
    storage_type,
    horizontal_increment,
    permute_x_y,
    number_of_positions,
    coord_x_title,
    coord_x_type,
    coord_x_size,
    display_x_size,
    reverse_x_numbering,
    coord_y_title,
    coord_y_type,
    coord_y_size,
    display_y_size,
    reverse_y_numbering,
    set_temperature,
    is_tma_block,
    flag_active,
    detail_form_alias,
    detail_tablename,
    databrowser_label,
    check_conflicts,
    deleted,
    storage_type_en,
    storage_type_fr
)
(
  SELECT
    id,
    storage_type,
    horizontal_increment,
    permute_x_y,
    number_of_positions,
    coord_x_title,
    coord_x_type,
    coord_x_size,
    display_x_size,
    reverse_x_numbering,
    coord_y_title,
    coord_y_type,
    coord_y_size,
    display_y_size,
    reverse_y_numbering,
    set_temperature,
    is_tma_block,
    flag_active,
    detail_form_alias,
    detail_tablename,
    databrowser_label,
    check_conflicts,
    deleted,
    storage_type_en,
    storage_type_fr
  FROM 
    %%local_procure_prod_database%%.storage_controls
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table storage_masters
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE storage_masters;
INSERT INTO storage_masters (
    id,
    code,
    storage_control_id,
    parent_id,
    lft,
    rght,
    barcode,
    short_label,
    selection_label,
    storage_status,
    parent_storage_coord_x,
    parent_storage_coord_y,
    temperature,
    temp_unit,
    notes,
    created,
    created_by,
    modified,
    modified_by,
    deleted
)
(
  SELECT
    id,
    code,
    storage_control_id,
    parent_id,
    lft,
    rght,
    barcode,
    short_label,
    selection_label,
    storage_status,
    parent_storage_coord_x,
    parent_storage_coord_y,
    temperature,
    temp_unit,
    notes,
    created,
    created_by,
    modified,
    modified_by,
    deleted
  FROM 
    %%local_procure_prod_database%%.storage_masters
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table storage_masters_revs
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE storage_masters_revs;
INSERT INTO storage_masters_revs (
    id,
    code,
    storage_control_id,
    parent_id,
    lft,
    rght,
    barcode,
    short_label,
    selection_label,
    storage_status,
    parent_storage_coord_x,
    parent_storage_coord_y,
    temperature,
    temp_unit,
    notes,
    modified_by,
    version_id,
    version_created
)
(
  SELECT
    id,
    code,
    storage_control_id,
    parent_id,
    lft,
    rght,
    barcode,
    short_label,
    selection_label,
    storage_status,
    parent_storage_coord_x,
    parent_storage_coord_y,
    temperature,
    temp_unit,
    notes,
    modified_by,
    version_id,
    version_created
  FROM 
    %%local_procure_prod_database%%.storage_masters_revs
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table structure_permissible_values
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE structure_permissible_values;
INSERT INTO structure_permissible_values (
    id,
    value,
    language_alias
)
(
  SELECT
    id,
    value,
    language_alias
  FROM 
    %%local_procure_prod_database%%.structure_permissible_values
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table structure_permissible_values_custom_controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE structure_permissible_values_custom_controls;
INSERT INTO structure_permissible_values_custom_controls (
    id,
    name,
    flag_active,
    values_max_length,
    category,
    values_used_as_input_counter,
    values_counter
)
(
  SELECT
    id,
    name,
    flag_active,
    values_max_length,
    category,
    values_used_as_input_counter,
    values_counter
  FROM 
    %%local_procure_prod_database%%.structure_permissible_values_custom_controls
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table structure_permissible_values_customs
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE structure_permissible_values_customs;
INSERT INTO structure_permissible_values_customs (
    id,
    control_id,
    value,
    en,
    fr,
    display_order,
    use_as_input,
    created,
    created_by,
    modified,
    modified_by,
    deleted
)
(
  SELECT
    id,
    control_id,
    value,
    en,
    fr,
    display_order,
    use_as_input,
    created,
    created_by,
    modified,
    modified_by,
    deleted
  FROM 
    %%local_procure_prod_database%%.structure_permissible_values_customs
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table structure_value_domains
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE structure_value_domains;
INSERT INTO structure_value_domains (
    id,
    domain_name,
    override,
    category,
    source
)
(
  SELECT
    id,
    domain_name,
    override,
    category,
    source
  FROM 
    %%local_procure_prod_database%%.structure_value_domains
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table structure_value_domains_permissible_values
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE structure_value_domains_permissible_values;
INSERT INTO structure_value_domains_permissible_values (
    id,
    structure_value_domain_id,
    structure_permissible_value_id,
    display_order,
    flag_active,
    use_as_input
)
(
  SELECT
    id,
    structure_value_domain_id,
    structure_permissible_value_id,
    display_order,
    flag_active,
    use_as_input
  FROM 
    %%local_procure_prod_database%%.structure_value_domains_permissible_values
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table study_summaries
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE study_summaries;
INSERT INTO study_summaries (
    id,
    disease_site,
    study_type,
    study_science,
    study_use,
    title,
    start_date,
    start_date_accuracy,
    end_date,
    end_date_accuracy,
    summary,
    abstract,
    hypothesis,
    approach,
    analysis,
    significance,
    additional_clinical,
    created,
    created_by,
    modified,
    modified_by,
    path_to_file,
    deleted,
    procure_principal_investigator,
    procure_organization,
    procure_address_street,
    procure_address_city,
    procure_address_province,
    procure_address_country,
    procure_address_postal,
    procure_phone_number,
    procure_fax_number,
    procure_email,
    procure_award_committee_approval,
    procure_reference_ethics_committee_approval,
    procure_site_ethics_committee_convenience_ps1,
    procure_site_ethics_committee_convenience_ps4,
    procure_site_ethics_committee_convenience_ps2,
    procure_site_ethics_committee_convenience_ps3,
    procure_created_by_bank
)
(
  SELECT
    id,
    disease_site,
    study_type,
    study_science,
    study_use,
    title,
    start_date,
    start_date_accuracy,
    end_date,
    end_date_accuracy,
    summary,
    abstract,
    hypothesis,
    approach,
    analysis,
    significance,
    additional_clinical,
    created,
    created_by,
    modified,
    modified_by,
    path_to_file,
    deleted,
    procure_principal_investigator,
    procure_organization,
    procure_address_street,
    procure_address_city,
    procure_address_province,
    procure_address_country,
    procure_address_postal,
    procure_phone_number,
    procure_fax_number,
    procure_email,
    procure_award_committee_approval,
    procure_reference_ethics_committee_approval,
    procure_site_ethics_committee_convenience_ps1,
    procure_site_ethics_committee_convenience_ps4,
    procure_site_ethics_committee_convenience_ps2,
    procure_site_ethics_committee_convenience_ps3,
    procure_created_by_bank
  FROM 
    %%local_procure_prod_database%%.study_summaries
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table tma_slides
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE tma_slides;
INSERT INTO tma_slides (
    id,
    tma_block_storage_master_id,
    barcode,
    product_code,
    sop_master_id,
    immunochemistry,
    picture_path,
    storage_datetime,
    storage_datetime_accuracy,
    storage_master_id,
    storage_coord_x,
    storage_coord_y,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    study_summary_id,
    in_stock,
    in_stock_detail,
    procure_created_by_bank,
    procure_stain
)
(
  SELECT
    id,
    tma_block_storage_master_id,
    barcode,
    product_code,
    sop_master_id,
    immunochemistry,
    picture_path,
    storage_datetime,
    storage_datetime_accuracy,
    storage_master_id,
    storage_coord_x,
    storage_coord_y,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    study_summary_id,
    in_stock,
    in_stock_detail,
    procure_created_by_bank,
    procure_stain
  FROM 
    %%local_procure_prod_database%%.tma_slides
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table treatment_controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE treatment_controls;
INSERT INTO treatment_controls (
    id,
    tx_method,
    disease_site,
    flag_active,
    detail_tablename,
    detail_form_alias,
    display_order,
    applied_protocol_control_id,
    extended_data_import_process,
    databrowser_label,
    flag_use_for_ccl,
    treatment_extend_control_id,
    use_addgrid,
    use_detail_form_for_index
)
(
  SELECT
    id,
    tx_method,
    disease_site,
    flag_active,
    detail_tablename,
    detail_form_alias,
    display_order,
    applied_protocol_control_id,
    extended_data_import_process,
    databrowser_label,
    flag_use_for_ccl,
    treatment_extend_control_id,
    use_addgrid,
    use_detail_form_for_index
  FROM 
    %%local_procure_prod_database%%.treatment_controls
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table treatment_extend_controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE treatment_extend_controls;
INSERT INTO treatment_extend_controls (
    id,
    detail_tablename,
    detail_form_alias,
    flag_active,
    type,
    databrowser_label
)
(
  SELECT
    id,
    detail_tablename,
    detail_form_alias,
    flag_active,
    type,
    databrowser_label
  FROM 
    %%local_procure_prod_database%%.treatment_extend_controls
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table treatment_masters
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE treatment_masters;
INSERT INTO treatment_masters (
    id,
    treatment_control_id,
    tx_intent,
    target_site_icdo,
    start_date,
    start_date_accuracy,
    finish_date,
    finish_date_accuracy,
    information_source,
    facility,
    notes,
    protocol_master_id,
    participant_id,
    diagnosis_master_id,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_deprecated_field_procure_form_identification,
    procure_created_by_bank,
    procure_drug_id
)
(
  SELECT
    id,
    treatment_control_id,
    tx_intent,
    target_site_icdo,
    start_date,
    start_date_accuracy,
    finish_date,
    finish_date_accuracy,
    information_source,
    facility,
    notes,
    protocol_master_id,
    participant_id,
    diagnosis_master_id,
    created,
    created_by,
    modified,
    modified_by,
    deleted,
    procure_deprecated_field_procure_form_identification,
    procure_created_by_bank,
    procure_drug_id
  FROM 
    %%local_procure_prod_database%%.treatment_masters
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- Table versions
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

TRUNCATE TABLE versions;
INSERT INTO versions (
    id,
    version_number,
    date_installed,
    trunk_build_number,
    permissions_regenerated,
    branch_build_number,
    site_branch_build_number
)
(
  SELECT
    id,
    version_number,
    date_installed,
    trunk_build_number,
    permissions_regenerated,
    branch_build_number,
    site_branch_build_number
  FROM 
    %%local_procure_prod_database%%.versions
);


-- -----------------------------------------------------------------------------------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;		
