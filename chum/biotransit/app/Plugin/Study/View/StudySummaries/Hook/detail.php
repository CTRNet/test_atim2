<?php
/**
 * **********************************************************************
 * CHUM-BioTransit Project
 * ***********************************************************************
 *
 * Study plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-10-22
 */

// Hide study funding section
$displayStudyFundings = false;
unset($finalOptions['links']['bottom']['add']['study funding']);
unset($structureLinks['bottom']['add']['study funding']);