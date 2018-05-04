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

// Redirect to collection creation
$urlToFlash = '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $this->Participant->getLastInsertID();
