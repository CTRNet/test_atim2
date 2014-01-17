-- already commited

INSERT INTO structure_permissible_values (value, language_alias) VALUES("loco-regional+systemic", "loco-regional+systemic");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_hb_recurrence_status"), (SELECT id FROM structure_permissible_values WHERE value="loco-regional+systemic" AND language_alias="loco-regional+systemic"), "", "1");
INSERT INTO i18n (id,en) VALUES ('loco-regional+systemic', 'Loco-Regional+ Systemic');

-- TODO

Bonjour,
Nous avons résolu 2 choses mais il faut faire l'ajustement du lab-Metastasis en  ajoutant en se référant au Cap-report endo-pancreas:
Histologic type (G1,G2,G3)
Mitotic activity .... 
Ki67 labeling index....
Ces informations sont nécessaires pour les métastases hépatiques neuro-endocrines
Merci de relancer!

























