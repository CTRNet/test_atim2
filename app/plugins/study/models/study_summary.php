<?php

class StudySummary extends StudyAppModel
{
	var $name = 'StudySummary';
	var $useTable = 'study_summaries';
	var $hasMany = array(
						'StudyContact' =>
						 array('className'   => 'StudyContact',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'study_summary_id',
                               'dependent'   => true,
                               'exclusive'   => false,
                               'finderSql'   => ''),
                         'StudyEthicsBoard' =>
						 array('className'   => 'StudyEthicsBoard',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'study_summary_id',
                               'dependent'   => true,
                               'exclusive'   => false,
                               'finderSql'   => ''),
 						'StudyFunding' =>
						 array('className'   => 'StudyFunding',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'study_summary_id',
                               'dependent'   => true,
                               'exclusive'   => false,
                               'finderSql'   => ''),
                         'StudyInvestigator' =>
						 array('className'   => 'StudyInvestigator',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'study_summary_id',
                               'dependent'   => true,
                               'exclusive'   => false,
                               'finderSql'   => ''),
  						'StudyRelated' =>
						 array('className'   => 'StudyRelated',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'study_summary_id',
                               'dependent'   => true,
                               'exclusive'   => false,
                               'finderSql'   => ''),
                         'StudyResult' =>
						 array('className'   => 'StudyResult',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'study_summary_id',
                               'dependent'   => true,
                               'exclusive'   => false,
                               'finderSql'   => ''),
  						'StudyReview' =>
						 array('className'   => 'StudyReview',
                               'conditions'  => '',
                               'order'       => '',
                               'limit'       => '',
                               'foreignKey'  => 'study_summary_id',
                               'dependent'   => true,
                               'exclusive'   => false,
                               'finderSql'   => '')
						);
						
	var $validate = array();
}
?>