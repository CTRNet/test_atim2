INSERT INTO atim.participants (id, title, first_name, middle_name, last_name, date_of_birth, sex, bc_ttr_phn, notes,  created, created_by, modified, modified_by)
SELECT id, salutation, first_name, usual_name, last_name, date_of_birth, sex, phn, memo,created, created_by, modified, modified_by
FROM participants;