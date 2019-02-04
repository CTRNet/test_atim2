<?php
/** **********************************************************************
 * iCord
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2019-01-31
 */
 
// Hide the 'participant identifier' section
unset($final_options['links']['bottom']['add identifier']);
$final_options['settings']['actions'] = true;
$is_ajax = true;