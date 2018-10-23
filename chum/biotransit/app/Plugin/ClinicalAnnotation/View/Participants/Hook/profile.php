<?php
/**
 * **********************************************************************
 * CHUM-BioTransit Project
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-10-22
 */
 
unset($structureLinks['bottom']['add identifier']);
$finalOptions['links'] = $structureLinks;
$finalOptions['settings']['actions'] = true;
$isAjax = true;