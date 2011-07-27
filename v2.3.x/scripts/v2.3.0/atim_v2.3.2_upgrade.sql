-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.3.2', NOW(), '> 3310');

UPDATE  collections                 SET collection_datetime_accuracy ='' WHERE collection_datetime_accuracy IS NULL;
UPDATE  collections_revs            SET collection_datetime_accuracy ='' WHERE collection_datetime_accuracy IS NULL;
UPDATE  diagnosis_masters           SET dx_date_accuracy             ='' WHERE dx_date_accuracy             IS NULL;
UPDATE  diagnosis_masters           SET age_at_dx_accuracy           ='' WHERE age_at_dx_accuracy           IS NULL;
UPDATE  diagnosis_masters_revs      SET dx_date_accuracy             ='' WHERE dx_date_accuracy             IS NULL;
UPDATE  diagnosis_masters_revs      SET age_at_dx_accuracy           ='' WHERE age_at_dx_accuracy           IS NULL;
UPDATE  family_histories            SET age_at_dx_accuracy           ='' WHERE age_at_dx_accuracy           IS NULL;
UPDATE  family_histories_revs       SET age_at_dx_accuracy           ='' WHERE age_at_dx_accuracy           IS NULL;
UPDATE  reproductive_histories      SET menopause_age_accuracy       ='' WHERE menopause_age_accuracy       IS NULL;
UPDATE  reproductive_histories      SET age_at_menarche_accuracy     ='' WHERE age_at_menarche_accuracy     IS NULL;
UPDATE  reproductive_histories      SET hysterectomy_age_accuracy    ='' WHERE hysterectomy_age_accuracy    IS NULL;
UPDATE  reproductive_histories      SET first_parturition_accuracy   ='' WHERE first_parturition_accuracy   IS NULL;
UPDATE  reproductive_histories      SET last_parturition_accuracy    ='' WHERE last_parturition_accuracy    IS NULL;
UPDATE  reproductive_histories      SET lnmp_accuracy                ='' WHERE lnmp_accuracy                IS NULL;
UPDATE  reproductive_histories_revs SET menopause_age_accuracy       ='' WHERE menopause_age_accuracy       IS NULL;
UPDATE  reproductive_histories_revs SET age_at_menarche_accuracy     ='' WHERE age_at_menarche_accuracy     IS NULL;
UPDATE  reproductive_histories_revs SET hysterectomy_age_accuracy    ='' WHERE hysterectomy_age_accuracy    IS NULL;
UPDATE  reproductive_histories_revs SET first_parturition_accuracy   ='' WHERE first_parturition_accuracy   IS NULL;
UPDATE  reproductive_histories_revs SET last_parturition_accuracy    ='' WHERE last_parturition_accuracy    IS NULL;
UPDATE  reproductive_histories_revs SET lnmp_accuracy                ='' WHERE lnmp_accuracy                IS NULL;
UPDATE  specimen_details            SET reception_datetime_accuracy  ='' WHERE reception_datetime_accuracy  IS NULL;
UPDATE  specimen_details_revs       SET reception_datetime_accuracy  ='' WHERE reception_datetime_accuracy  IS NULL;
UPDATE  tx_masters                  SET start_date_accuracy          ='' WHERE start_date_accuracy          IS NULL;
UPDATE  tx_masters                  SET finish_date_accuracy         ='' WHERE finish_date_accuracy         IS NULL;
UPDATE  tx_masters_revs             SET start_date_accuracy          ='' WHERE start_date_accuracy          IS NULL;
UPDATE  tx_masters_revs             SET finish_date_accuracy         ='' WHERE finish_date_accuracy         IS NULL;
UPDATE aliquot_internal_uses   SET use_datetime_accuracy                 ='' WHERE  use_datetime_accuracy                 IS NULL;
UPDATE aliquot_masters         SET storage_datetime_accuracy             ='' WHERE  storage_datetime_accuracy             IS NULL;
UPDATE announcements           SET date_accuracy                         ='' WHERE  date_accuracy                         IS NULL;
UPDATE announcements           SET date_start_accuracy                   ='' WHERE  date_start_accuracy                   IS NULL;
UPDATE announcements           SET date_end_accuracy                     ='' WHERE  date_end_accuracy                     IS NULL;
UPDATE consent_masters         SET date_of_referral_accuracy             ='' WHERE  date_of_referral_accuracy             IS NULL;
UPDATE consent_masters         SET date_first_contact_accuracy           ='' WHERE  date_first_contact_accuracy           IS NULL;
UPDATE consent_masters         SET consent_signed_date_accuracy          ='' WHERE  consent_signed_date_accuracy          IS NULL;
UPDATE consent_masters         SET status_date_accuracy                  ='' WHERE  status_date_accuracy                  IS NULL;
UPDATE consent_masters         SET operation_date_accuracy               ='' WHERE  operation_date_accuracy               IS NULL;
UPDATE derivative_details      SET creation_datetime_accuracy            ='' WHERE  creation_datetime_accuracy            IS NULL;
UPDATE derivative_details_revs SET creation_datetime_accuracy            ='' WHERE  creation_datetime_accuracy            IS NULL;
UPDATE event_masters           SET event_date_accuracy                   ='' WHERE  event_date_accuracy                   IS NULL;
UPDATE event_masters           SET date_required_accuracy                ='' WHERE  date_required_accuracy                IS NULL;
UPDATE event_masters           SET date_requested_accuracy               ='' WHERE  date_requested_accuracy               IS NULL;
UPDATE lbd_dna_extractions     SET creation_datetime_accuracy            ='' WHERE  creation_datetime_accuracy            IS NULL;
UPDATE lbd_slide_creations     SET realiquoting_datetime_accuracy        ='' WHERE  realiquoting_datetime_accuracy        IS NULL;
UPDATE misc_identifiers        SET effective_date_accuracy               ='' WHERE  effective_date_accuracy               IS NULL;
UPDATE misc_identifiers        SET expiry_date_accuracy                  ='' WHERE  expiry_date_accuracy                  IS NULL;
UPDATE order_items             SET date_added_accuracy                   ='' WHERE  date_added_accuracy                   IS NULL;
UPDATE order_lines             SET date_required_accuracy                ='' WHERE  date_required_accuracy                IS NULL;
UPDATE orders                  SET date_order_placed_accuracy            ='' WHERE  date_order_placed_accuracy            IS NULL;
UPDATE orders                  SET date_order_completed_accuracy         ='' WHERE  date_order_completed_accuracy         IS NULL;
UPDATE participant_contacts    SET effective_date_accuracy               ='' WHERE  effective_date_accuracy               IS NULL;
UPDATE participant_contacts    SET expiry_date_accuracy                  ='' WHERE  expiry_date_accuracy                  IS NULL;
UPDATE participant_messages    SET date_requested_accuracy               ='' WHERE  date_requested_accuracy               IS NULL;
UPDATE participant_messages    SET due_date_accuracy                     ='' WHERE  due_date_accuracy                     IS NULL;
UPDATE participant_messages    SET expiry_date_accuracy                  ='' WHERE  expiry_date_accuracy                  IS NULL;
UPDATE participants            SET last_chart_checked_date_accuracy      ='' WHERE  last_chart_checked_date_accuracy      IS NULL;
UPDATE protocol_masters        SET expiry_accuracy                       ='' WHERE  expiry_accuracy                       IS NULL;
UPDATE protocol_masters        SET activated_accuracy                    ='' WHERE  activated_accuracy                    IS NULL;
UPDATE quality_ctrls           SET date_accuracy                         ='' WHERE  date_accuracy                         IS NULL;
UPDATE realiquotings           SET realiquoting_datetime_accuracy        ='' WHERE  realiquoting_datetime_accuracy        IS NULL;
UPDATE reproductive_histories  SET date_captured_accuracy                ='' WHERE  date_captured_accuracy                IS NULL;
UPDATE reproductive_histories  SET lnmp_date_accuracy                    ='' WHERE  lnmp_date_accuracy                    IS NULL;
UPDATE rtbforms                SET frmCreated_accuracy                   ='' WHERE  frmCreated_accuracy                   IS NULL;
UPDATE sd_spe_tissues          SET pathology_reception_datetime_accuracy ='' WHERE  pathology_reception_datetime_accuracy IS NULL;
UPDATE shipments               SET datetime_shipped_accuracy             ='' WHERE  datetime_shipped_accuracy             IS NULL;
UPDATE shipments               SET datetime_received_accuracy            ='' WHERE  datetime_received_accuracy            IS NULL;
UPDATE sop_masters             SET expiry_date_accuracy                  ='' WHERE  expiry_date_accuracy                  IS NULL;
UPDATE sop_masters             SET activated_date_accuracy               ='' WHERE  activated_date_accuracy               IS NULL;
UPDATE specimen_review_masters SET review_date_accuracy                  ='' WHERE  review_date_accuracy                  IS NULL;
UPDATE std_tma_blocks          SET creation_datetime_accuracy            ='' WHERE  creation_datetime_accuracy            IS NULL;
UPDATE study_ethics_boards     SET date_accuracy                         ='' WHERE  date_accuracy                         IS NULL;
UPDATE study_fundings          SET date_accuracy                         ='' WHERE  date_accuracy                         IS NULL;
UPDATE study_investigators     SET participation_start_date_accuracy     ='' WHERE  participation_start_date_accuracy     IS NULL;
UPDATE study_investigators     SET participation_end_date_accuracy       ='' WHERE  participation_end_date_accuracy       IS NULL;
UPDATE study_related           SET date_posted_accuracy                  ='' WHERE  date_posted_accuracy                  IS NULL;
UPDATE study_results           SET result_date_accuracy                  ='' WHERE  result_date_accuracy                  IS NULL;
UPDATE study_reviews           SET date_accuracy                         ='' WHERE  date_accuracy                         IS NULL;
UPDATE study_summaries         SET start_date_accuracy                   ='' WHERE  start_date_accuracy                   IS NULL;
UPDATE study_summaries         SET end_date_accuracy                     ='' WHERE  end_date_accuracy                     IS NULL;
UPDATE tma_slides              SET storage_datetime_accuracy             ='' WHERE  storage_datetime_accuracy             IS NULL;

ALTER TABLE	 aliquot_internal_uses       	MODIFY	 use_datetime_accuracy                 	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 aliquot_masters             	MODIFY	 storage_datetime_accuracy             	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 announcements               	MODIFY	 date_accuracy                         	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 date_start_accuracy                   	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 date_end_accuracy                     	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 collections                 	MODIFY	 collection_datetime_accuracy          	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 collections_revs            	MODIFY	 collection_datetime_accuracy          	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 consent_masters             	MODIFY	 date_of_referral_accuracy             	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 date_first_contact_accuracy           	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 consent_signed_date_accuracy          	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 status_date_accuracy                  	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 operation_date_accuracy               	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 derivative_details          	MODIFY	 creation_datetime_accuracy            	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 derivative_details_revs     	MODIFY	 creation_datetime_accuracy            	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 diagnosis_masters           	MODIFY	 dx_date_accuracy                      	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 age_at_dx_accuracy                    	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 diagnosis_masters_revs      	MODIFY	 dx_date_accuracy                      	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 age_at_dx_accuracy                    	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 event_masters               	MODIFY	 event_date_accuracy                   	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 date_required_accuracy                	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 date_requested_accuracy               	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 family_histories            	MODIFY	 age_at_dx_accuracy                    	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 family_histories_revs       	MODIFY	 age_at_dx_accuracy                    	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 lbd_dna_extractions         	MODIFY	 creation_datetime_accuracy            	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 lbd_slide_creations         	MODIFY	 realiquoting_datetime_accuracy        	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 misc_identifiers            	MODIFY	 effective_date_accuracy               	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 expiry_date_accuracy                  	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 order_items                 	MODIFY	 date_added_accuracy                   	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 order_lines                 	MODIFY	 date_required_accuracy                	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 orders                      	MODIFY	 date_order_placed_accuracy            	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 date_order_completed_accuracy         	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 participant_contacts        	MODIFY	 effective_date_accuracy               	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 expiry_date_accuracy                  	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 participant_messages        	MODIFY	 date_requested_accuracy               	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 due_date_accuracy                     	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 expiry_date_accuracy                  	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 participants                	MODIFY	 last_chart_checked_date_accuracy      	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 protocol_masters            	MODIFY	 expiry_accuracy                       	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 activated_accuracy                    	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 quality_ctrls               	MODIFY	 date_accuracy                         	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 realiquotings               	MODIFY	 realiquoting_datetime_accuracy        	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 reproductive_histories      	MODIFY	 date_captured_accuracy                	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 menopause_age_accuracy                	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 age_at_menarche_accuracy              	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 hysterectomy_age_accuracy             	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 first_parturition_accuracy            	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 last_parturition_accuracy             	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 lnmp_date_accuracy                    	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 lnmp_accuracy                         	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 reproductive_histories_revs 	MODIFY	 menopause_age_accuracy                	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 age_at_menarche_accuracy              	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 hysterectomy_age_accuracy             	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 first_parturition_accuracy            	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 last_parturition_accuracy             	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 lnmp_accuracy                         	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 rtbforms                    	MODIFY	 frmCreated_accuracy                   	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 sd_spe_tissues              	MODIFY	 pathology_reception_datetime_accuracy 	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 shipments                   	MODIFY	 datetime_shipped_accuracy             	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 datetime_received_accuracy            	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 sop_masters                 	MODIFY	 expiry_date_accuracy                  	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 activated_date_accuracy               	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 specimen_details            	MODIFY	 reception_datetime_accuracy           	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 specimen_details_revs       	MODIFY	 reception_datetime_accuracy           	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 specimen_review_masters     	MODIFY	 review_date_accuracy                  	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 std_tma_blocks              	MODIFY	 creation_datetime_accuracy            	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 study_ethics_boards         	MODIFY	 date_accuracy                         	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 study_fundings              	MODIFY	 date_accuracy                         	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 study_investigators         	MODIFY	 participation_start_date_accuracy     	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 participation_end_date_accuracy       	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 study_related               	MODIFY	 date_posted_accuracy                  	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 study_results               	MODIFY	 result_date_accuracy                  	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 study_reviews               	MODIFY	 date_accuracy                         	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 study_summaries             	MODIFY	 start_date_accuracy                   	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 end_date_accuracy                     	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 tma_slides                  	MODIFY	 storage_datetime_accuracy             	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 tx_masters                  	MODIFY	 start_date_accuracy                   	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 finish_date_accuracy                  	CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE	 tx_masters_revs             	MODIFY	 start_date_accuracy                   	CHAR(1) NOT NULL DEFAULT '',
		MODIFY	 finish_date_accuracy                  	CHAR(1) NOT NULL DEFAULT '';
