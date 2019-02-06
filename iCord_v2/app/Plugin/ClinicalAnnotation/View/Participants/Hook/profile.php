<?php
/**
 * **********************************************************************
 * iCord
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2019-01-31
 */

// Hide the 'participant identifier' section
unset($finalOptions['links']['bottom']['add identifier']);
$finalOptions['settings']['actions'] = true;
$isAjax = true;