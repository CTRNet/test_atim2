<?php
/** **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-04-06
 */

// Field AliquotReviewMaster.review_code has been removed from the form
// but no default value exists for this field in db.
// Force system to set a default value.
foreach($aliquotReviewData as &$tmpAliquotReviewData) {
    $tmpAliquotReviewData['AliquotReviewMaster']['review_code'] = 'n/a';
}
// review_code is not a field displayed into the form. Force the 
// system to writte the value into the database.
$this->AliquotReviewMaster->addWritableField(array(
    'review_code'
));