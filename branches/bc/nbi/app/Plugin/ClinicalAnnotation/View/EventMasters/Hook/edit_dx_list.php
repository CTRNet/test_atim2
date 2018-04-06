<?php
/** **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-04-06
 */

// No diagnosis can be created thus no event can be linked to a diagnosis.
// Hide the diagnosis section.
$displayNextSubForm = false;