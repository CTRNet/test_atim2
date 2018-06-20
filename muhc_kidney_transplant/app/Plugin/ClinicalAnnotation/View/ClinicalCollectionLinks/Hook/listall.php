<?php
/** **********************************************************************
 * CUSM-Kidney Transplant
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-05-28
 */

// No additional object (treatment, etc) coulde be joined to the participant-collection link
// Hide the 'Edit' button
unset($finalOptions['links']['index']['edit']);