<?php
/** **********************************************************************
 * UHN Project.
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-05-04
 */

// Set the Participant.last_chart_checked_date (filed hidden in add form) to the current date.

/*
Be sure you hidden the field in Participant.add() page reunning following sql statements build with the form_builder

UPDATE structure_formats 
SET `flag_add`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

*/

$this->request->data['Participant']['last_chart_checked_date'] = '2000-03-01';
$this->request->data['Participant']['last_chart_checked_date_accuracy'] = 'd';
// Force system to keep value.
// If following line is removed, system won't record these fields because these one are not part of the displayed form.
$this->Participant->addWritableField(array(
    'last_chart_checked_date',
    'last_chart_checked_date_accuracy'
));

