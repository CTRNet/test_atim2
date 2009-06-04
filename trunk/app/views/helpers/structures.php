<?php
	
App::import('component','Acl');

class StructuresHelper extends Helper {
		
	var $helpers = array( 'Html', 'Form', 'Javascript', 'Ajax', 'Paginator','Session' );

	function build( $atim_structure=array(), $options=array() ) {
	
		$return_string = ''; 
		
		// DEFAULT set of options, overridden by PASSED options
		$defaults = array(
			'type'		=>	$this->params['action'],
			
			'settings'	=> array(
				'return'	=> false
			),
			
			'links'		=> array(
				'top'		=> false,
				'index'	=> array(),
				'bottom'	=> array()
			),
			
			'override'	=> array(),
			
			'extras'		=> array()
		);
		
		$options = $this->array_merge_recursive_distinct($defaults,$options);
				
			// Sort the data with ORDER descending, FIELD ascending 
				foreach ( $atim_structure['StructureFormat'] as $key=>$row ) {
					$sort_order_0[$key] = $row['display_column'];
					$sort_order_1[$key] = $row['display_order'];
					$sort_order_2[$key] = $row['StructureField']['model'];
				}
			
			// multisort, PHP array 
				array_multisort( $sort_order_0, SORT_ASC, $sort_order_1, SORT_ASC, $sort_order_2, SORT_ASC, $atim_structure['StructureFormat'] );
			
		if ( $options['links']['top'] ) {
			$return_string .= '
				<form action="'.$this->generate_links_list( $this->data, $options, 'top' ).'" method="post">
					<fieldset>
			';
		}
		
		// run specific TYPE function to build structure
		switch ( $options['type'] ) {
			case 'index':		$options['type'] = 'index';	$return_string .= $this->build_table( $atim_structure, $options );	break;
			case 'table':		$options['type'] = 'index';	$return_string .= $this->build_table( $atim_structure, $options );	break;
			case 'listall':	$options['type'] = 'index';	$return_string .= $this->build_table( $atim_structure, $options );	break;
			
			case 'add':			$options['type'] = 'add';		$return_string .= $this->build_detail( $atim_structure, $options );	break;
			case 'edit':		$options['type'] = 'edit';		$return_string .= $this->build_detail( $atim_structure, $options );	break;
			case 'search':		$options['type'] = 'search';	$return_string .= $this->build_detail( $atim_structure, $options );	break;
			
			case 'tree':		$options['type'] = 'tree';		$return_string .= $this->build_tree( $atim_structure, $options );		break;
			
			default:				$options['type'] = 'detail';	$return_string .= $this->build_detail( $atim_structure, $options );	break;
		}
			
		if ( $options['links']['top'] ) {
			$return_string .= '
					</fieldset>
				</form>
			';
		}
				
		$return_string .= $this->generate_links_list(  $this->data, $options, 'bottom' );
		
		// RETURN or ECHO resulting structure
		if ( $options['settings']['return'] ) { return $return_string; } else { echo $return_string; }
				
	} // end FUNCTION build()


/********************************************************************************************************************************************************************************/


	// FUNCTION 
	function build_detail( $atim_structure, $options ) {
		
		// pr($this->data);
		// pr($atim_structure);
		
		$return_string = '';
			
		$table_index = $this->build_stack( $atim_structure, $options );
		
			// display table...
			$return_string .= '
				<table class="structure detail" cellspacing="0">
				<tbody>
					<tr>
			';
				
				// tack on EXTRAS end, if any
				// $return_string .= $this->display_extras( 'edit', $extras, 'start', count($table_index) );
				
				// each column in table 
				$count_columns = 0;
				foreach ( $table_index as $table_column_key=>$table_column ) {
					
					$count_columns++;
					
					$return_string .= '
						<td class="this_column_'.$count_columns.' total_columns_'.count($table_index).'"> 
						
							<table class="detail" cellspacing="0">
							<tbody>
					';
					
					// each row in column 
					$table_row_count = 0;
					foreach ( $table_column as $table_row_key=>$table_row ) {
						
						/*
						// display heading row, if any...
						if ( $table_row['heading'] ) {
							$return_string .= '
								<tr>
									<td class="heading no_border" colspan="'.( $this->othAuth->user('help_visible')=='yes' ? '3' : '2' ).'">
										<h4>'.$table_row['heading'].'</h4>
									</td>
								</tr>
							';
						}
						*/
						
						$return_string .= '
								<tr>
									<td class="label'.( !$table_row_count && !$table_row['heading'] ? ' no_border' : '' ).'">
										'.$table_row['label'].'
									</td>
									<td class="content'.( $table_row['empty'] ? ' empty' : '' ).( !$table_row_count && !$table_row['heading'] ? ' no_border' : '' ).'">
										'.( $options['links']['top'] ? $table_row['input'] : $table_row['content'] ).'
									</td>
						';
						
						// if 	( $this->othAuth->user('help_visible')=='yes' ) {
						if ( 1==1 ) {
							$return_string .= '
									<td class="help'.( !$table_row_count && !$table_row['heading'] ? ' no_border' : '' ).'">
										'.$table_row['help'].'
									</td>
							';
						}
						
						$return_string .= '
								</tr>
						';
						
						
						$table_row_count++;
						
					} // end ROW 
					
					$return_string .= '
							</tbody>
							</table>
							
						</td>
					';
					
				} // end COLUMN 
				
				// tack on EXTRAS end, if any
				// $return_string .= $this->display_extras( 'edit', $extras, 'end', count($table_index) );
			
			
			if ( $options['type']!='detail' ) {
				$return_string .= '
					</tr>
					<tr>
						<td class="submit">
							<input colspan="'.$table_row_count.'" class="submit" type="submit" value="Submit" />
						</td>
				';
			}
				
			$return_string .= '
					</tr>
				</tbody>
				</table>
			';
			
		return $return_string;
		
	}


/********************************************************************************************************************************************************************************/


	function build_table( $atim_structure, $options ) {
		
		$return_string = '';
		
		$this->Paginator->options(array('url' => $this->params['pass']));
		
			$table_index = array();
			foreach ( $this->data as $key=>$val ) {
				$options['stack']['key'] = $key;
				$table_index[$key] = $this->build_stack( $atim_structure, $options );
				unset($options['stack']);
			}
		
			// start table...
			$return_string .= '
				<table class="structure index" cellspacing="0">
				<tbody>
			';
			
			// header row
			$return_string .= $this->display_header( $table_index, $options );
			
			$column_count = 0;
			if ( count($this->data) ) {
			
				// each column in table 
				foreach ( $this->data as $key=>$val ) {
					
					$return_string .= '
						<tr>
					';
						
					$column_count = 0;
					if ( count($options['links']['index']) ) {
						$return_string .= '
							<td class="id">'.$this->generate_links_list(  $this->data[$key], $options, 'index' ).'</td>
						';
						
						$column_count = 1;
					}
					
					// each column/row in table 
					foreach ( $table_index[$key] as $table_column ) {
						foreach ( $table_column as $table_row ) {
							$return_string .= '
								<td>'.( $options['links']['top'] ? $table_row['input'] : $table_row['content'] ).'</td>
							';
							
							$column_count++;
						}
					}
					
					$return_string .= '
						</tr>
					';
					
				} // end FOREACH
				
			}
			
			// display something nice for NO ROWS msg...
			else {
				$return_string .= '
						<tr>
								<td class="no_data_available"'.( $column_count ? ' colspan="'.$column_count.'"' : '' ).'>'.__( 'core_no_data_available', true ).'</td>
						</tr>
				';
			}
			
			$return_string .= '
					<tr class="pagination">
						<th'.( $column_count ? ' colspan="'.$column_count.'"' : '' ).'>
							'.$this->Paginator->prev( __( 'Prev',true ), NULL, __( 'Prev',true ) ).'
							'.$this->Paginator->counter( array('format' => '%start%-%end% of %count%') ).'
							'.$this->Paginator->next( __( 'Next',true ), NULL, __( 'Next',true ) ).'
						</th>
					</tr>
				</tbody>
				</table>
			';  
			
		return $return_string;
		
	}


/********************************************************************************************************************************************************************************/


	function build_tree( $atim_structure, $options ) {
		
		$return_string = '';
		
			// start table...
			$return_string .= '
				<table class="structure tree" cellspacing="0">
				<tbody>
			';
			
			if ( count($this->data) ) {
				
				// start root level of UL tree, and call NODE function
				$return_string .= '
					<tr><td>
						<ul id="tree_root">
				';
				
				$return_string .= $this->build_tree_node( $atim_structure, $options, $this->data );
				
				$return_string .= '
						</ul>
					</td></tr>
				';
				
			}
			
			// display something nice for NO ROWS msg...
			else {
				$return_string .= '
						<tr>
								<td class="no_data_available" colspan="'.$column_count.'">'.__( 'core_no_data_available', true ).'</td>
						</tr>
				';
			}
			
			$return_string .= '
				</tbody>
				</table>
			';  
			
		return $return_string;
		
	}
	
	function build_tree_node( $atim_structure, $options, $data=array()) {
		
		foreach ( $data as $data_key=>$data_val ) { 
			
			// unset CHILDREN from data, to not confuse STACK function
			$children = array();
			if ( isset($data_val['children']) ) {
				$children = $data_val['children'];
				unset($data_val['children']);
			}
			
			$return_string .= '
				<li>
			';
				
				// collect LINKS and STACK to be added to LI, must do out of order, as need ID field to use as unique CSS ID in UL/A toggle
				
				$return_string_id = '';
				$return_string_collect = '';
				
				foreach ( $data_val as $model_key=>$model_val ) {
					
					$return_string_id = !$return_string_id ? $model_val['id'] : $return_string_id;
					
					$options['type'] = 'index';
					$options['stack']['data'] = array($model_key=>$model_val);
					$table_index = $this->build_stack( $atim_structure, $options );
					unset($options['stack']);
					
					if ( count($options['links']['index']) ) {
						$return_string_collect .= $this->generate_links_list(  $data_val, $options, 'index' );
					}
					
					foreach ( $table_index as $table_column_key=>$table_column ) {
						foreach ( $table_column as $table_row_key=>$table_row ) {
							$return_string_collect .= ' <span class="divider">|</span> '.( $options['links']['top'] ? $table_row['input'] : $table_row['content'] );
						}
					}
					
				}
				
				// reveal sub ULs if sub ULs exist
				
					if ( count($children) ) {
						$return_string .= '<a class="reveal" href="#" onclick="Effect.toggle(\'tree_'.$return_string_id.'\',\'slide\',{duration:0.25}); return false;">+</a> ';
					} else {
						$return_string .= '<a class="reveal not_allowed" onclick="return false;">+</a> ';
					}
					
					$return_string .= ' <span class="divider">|</span> ';
				
				$return_string .= $return_string_collect;
				
				// create sub-UL, calling this NODE function again, if model has any CHILDREN
				if ( count($children) ) { 
					$return_string .= '
						<ul id="tree_'.$return_string_id.'" style="display:none;">
					';
					
					$return_string .= $this->build_tree_node( $atim_structure, $options, $children );
					
					$return_string .= '
						</ul>
					';
				}
			
			$return_string .= '
				</li>
			';
			
		}
		
		return $return_string; 
	}


/********************************************************************************************************************************************************************************/

	
	// FUNCTION 
	function display_header( $table_index=array(), $options=array() ) {
		
		$return_string = '';
		
		// start header row...
		$return_string .= '
				<tr>
		';
			
		if ( count($options['links']['index']) ) {
			$return_string .= '
					<th class="column_0 id">&nbsp;</th>
			';
		}
		
		// each column/row in table 
		if ( count($table_index) ) {
			
			$column_count = 1;
			foreach ( $table_index[0] as $table_column ) {
				foreach ( $table_column as $table_row ) {
				
					if (  $table_row['type']!='hidden' ) {
						
						$return_string .= '
							<th class="column_'.$column_count.' '.$table_row['field'].'">
						';
						
						// label and help/info marker, if available...
						if ( $table_row['label'] ) {
							
							$sorting_link = $_SERVER['REQUEST_URI'];
							$sorting_link = explode('?', $sorting_link);
							$sorting_link = $sorting_link[0];
							
								$default_sorting_direction = isset($_REQUEST['direction']) ? $_REQUEST['direction'] : 'asc';
								$default_sorting_direction = strtolower($default_sorting_direction);
							
							$sorting_link .= '?sortBy='.$table_row['field'];
							$sorting_link .= '&amp;direction='.( $default_sorting_direction=='asc' ? 'desc' : 'asc' );
							$sorting_link .= isset($_REQUEST['page']) ? '&amp;page='.$_REQUEST['page'] : '';
							
							$return_string .= $this->Paginator->sort($table_row['label'], $table_row['model'].'.'.$table_row['field']);
							
							// if ( $this->othAuth->user('help_visible')=='yes' ) {
								$return_string .= $table_row['help'];
							// }
							
							$column_count++;
						}
						
						
						$return_string .= '
							</th>
						';
						
					} // end NOT HIDDEN
					
				} // end FOREACH
			} // end FOREACH
			
		}
		
		// end header row...
		$return_string .= '
				</tr>
		';
		
		return $return_string;
		
	}



/********************************************************************************************************************************************************************************/

	
	// FUNCTION 
	function display_extras( $options ) {
		
		$return_string = '';
		
		/*
		if ( $extras[ $key ] ) {
			
			$return_string .= '
				<tr>
						<td'.( $colspan>1 ? ' colspan="'.$colspan.'"' : '' ).'>
					
						<table class="'.$options['type'].'" cellspacing="0">
						<tbody>
							
							'.$extras[ $key ].'
							
						</tbody>
						</table>
						
					</td>
				</tr>
			';
			
		}
		*/
		
		return $return_string;
		
	}
	

/********************************************************************************************************************************************************************************/


	// FUNCTION 
	function build_stack( $atim_structure, $options=array() ) {
		
		// for hidden fields, at end of form...
		$model_names_for_hidden_fields = array();
		
		// table array for field display
		$table_index = array();
		
		// intialize variables...
		$tab_key = 0;
		$row_count = 0;
		$field_count = 1;
		
		if ( isset($options['stack']['key']) ) {
			$tab_key = $options['stack']['key'];
			
			$model_suffix = '.'.$options['stack']['key'];
		
			$data = &$this->data[$options['stack']['key']];
		}
		
		else {
			$model_suffix = '.';
			
			if ( isset($options['stack']['data']) ) {
				$data = $options['stack']['data'];
			} else {
				$data = &$this->data;
			}
		}
		
		foreach ( $atim_structure['StructureFormat'] as $field ) {
			
			// if STRUCTURE does not allows multi-columns, display STRUCTURE in one column only
			if ( !isset($atim_structure['Structure']['flag_'.$options['type'].'_columns']) ) $atim_structure['Structure']['flag_'.$options['type'].'_columns'] = 0;
			if ( !$atim_structure['Structure']['flag_'.$options['type'].'_columns'] ) $field['display_column'] = 0;
			
			// if table column doesn't already exist, create it 
			if ( !isset( $table_index[ $field['display_column'] ] ) ) $table_index[ $field['display_column'] ] = array();
			
			// display only if flagged for this type of form in the FORMS datatable...
			if ( in_array( 'allfields', $options['settings'] ) || $field[ 'flag_'.$options['type'] ] ) {
			
				// label and help/info marker, if available...
				if ( ( ($field['flag_override_label'] && $field['language_label']) || ($field['StructureField']['language_label']) ) || ( $field['flag_override_type']=='hidden' || $field['StructureField']['type']=='hidden' ) ) {
					
					// increment row_count, next row of information
					$row_count++;
					$table_index[ $field['display_column'] ][ $row_count ] = array();
					
					// intialize variables...
					$table_index[ $field['display_column'] ][ $row_count ]['model'] = '';
					$table_index[ $field['display_column'] ][ $row_count ]['field'] = '';
					$table_index[ $field['display_column'] ][ $row_count ]['empty'] = 0;
					
					$table_index[ $field['display_column'] ][ $row_count ]['heading'] = '';
					$table_index[ $field['display_column'] ][ $row_count ]['label'] = '';
					$table_index[ $field['display_column'] ][ $row_count ]['tag'] = '';
					$table_index[ $field['display_column'] ][ $row_count ]['help'] = '';
					
					$table_index[ $field['display_column'] ][ $row_count ]['type'] = '';
					$table_index[ $field['display_column'] ][ $row_count ]['input'] = '';
					
					$table_index[ $field['display_column'] ][ $row_count ]['content'] = '';
					
					// place BASIC form info into stack
					$table_index[ $field['display_column'] ][ $row_count ]['model'] = $field['StructureField']['model'];
					$table_index[ $field['display_column'] ][ $row_count ]['field'] = $field['StructureField']['field'];
					$table_index[ $field['display_column'] ][ $row_count ]['type'] = $field['StructureField']['type'];
					
					// place translated HEADING in label column of new row 
					if ( $field['language_heading'] ) $table_index[ $field['display_column'] ][ $row_count ]['heading'] = __( $field['language_heading'], true );
					
					// place translated LABEL in label column of new row 
					// use FIELD's LABEL, or use FORMAT's LABEL if override FLAG is set
					if ( $field['flag_override_label'] ) $field['StructureField']['language_label'] = $field['language_label'];
					if ( $field['StructureField']['language_label'] )  $table_index[ $field['display_column'] ][ $row_count ]['label'] = __( $field['StructureField']['language_label'], true );
					
					/*
					// add CHECK/UNCHECK links to appropriate FORM/FIELD types
					if ( ($options['type']=='add' || $options['type']=='edit' || $options['type']=='search') && ($field['StructureField']['type']=='checklist') ) {
						$table_index[ $field['display_column'] ][ $row_count ]['label'] .= '
							<a href="#" onclick="checkAll(\'form_helper_checklist\'); return false;">'.__( 'core_check', true ).'</a>/<a href="#" onclick="uncheckAll(\'form_helper_checklist\'); return false;">'.__( 'core_uncheck', true ).'</a>
						';
					}
					*/
				}
				
				// display TAG, sub label, use FIELD's TAG, or use FORMAT's TAG if override FLAG is set
					if ( $field['flag_override_tag'] ) $field['StructureField']['language_tag'] = $field['language_tag'];
					if ( $field['StructureField']['language_tag'] ) $table_index[ $field['display_column'] ][ $row_count ]['tag'] = '<span class="tag">'.__( $field['StructureField']['language_tag'], true ).'</span> ';
					
				// LABEL and HELP marker, if available...
					if ( $field['flag_override_label'] && $field['language_label'] ) $field['StructureField']['language_label'] = $field['language_label'];
					if ( $field['StructureField']['language_label'] ) {
						
						/*
						// link classes, for jTip AJAX...
							$html_link_attributes = array(
								'class'=>'jTip',
								'id'=>'jTip_'.$field['StructureField']['field'],
								'name'=>__( $field['StructureField']['language_label'], true )
							);
						*/
						
						// include jTip link or no-help type indicator
							if ( $field['flag_override_help'] && $field['language_help'] ) $field['StructureField']['language_help'] = $field['language_help'];
							if (  $field['StructureField']['language_help'] ) {
								$table_index[ $field['display_column'] ][ $row_count ]['help'] = '<span class="help">?<div>'.__($field['StructureField']['language_help'],true).'</div></span> ';
							} else {
								$table_index[ $field['display_column'] ][ $row_count ]['help'] = '<span class="help error">?</span>';
							}
						
					}
					
				// if FORMAT overrides FIELD type/setting/default, then set that now...
					if ( $field['flag_override_type'] ) $field['StructureField']['type'] = $field['type'];
					if ( $field['flag_override_setting'] ) $field['StructureField']['setting'] = $field['setting'];
					if ( $field['flag_override_default'] ) $field['StructureField']['default'] = $field['default'];
				
				// to avoid PHP ERRORS, set value to NULL if combo not in array...
					if ( !isset($data[$field['StructureField']['model']][$field['StructureField']['field']]) ) $data[$field['StructureField']['model']][$field['StructureField']['field']] = NULL;
					
				// get CONTENT to DISPLAY
				
					$display_value = '';
					
					// set display VALUE, or NO VALUE indicator 
						
						$display_value = $data[ $field['StructureField']['model'] ][ $field['StructureField']['field'] ];
								
							// swap out VALUE for OVERRIDE choice for SELECTS, NO TRANSLATION 
							if ( isset( $override[ $field['StructureField']['model'].'.'.$field['StructureField']['field'] ] ) ) {
								
								// from ARRAY item...
								if ( is_array($override[ $field['StructureField']['model'].'.'.$field['StructureField']['field'] ]) ) {
									foreach ( $override[ $field['StructureField']['model'].'.'.$field['StructureField']['field'] ] as $key=>$value ) {
										
										if ( $key == $display_value ) {
											$display_value = $value;
										}
										
									}
								} 
								
								// for STRING items...
								else {
									$display_value = $override[ $field['StructureField']['model'].'.'.$field['StructureField']['field'] ];
								}
								
							// swap out VALUE for LANG LOOKUP choice for SELECTS 
							// } else if ( $field['type']=='select' ) {
							} else if ( count($field['StructureField']['StructureValueDomain']) && isset($field['StructureField']['StructureValueDomain']['StructurePermissibleValue']) ) {
								
								foreach ( $field['StructureField']['StructureValueDomain']['StructurePermissibleValue'] as $lookup ) {
									if ( $lookup['value'] == $display_value && $lookup['language_alias'] ) {
										$display_value = __( $lookup['language_alias'], true );
									}
								}
								
							}
							
							// format date values a bit...
							if ( $display_value=='0000-00-00' || $display_value=='0000-00-00 00:00:00' || $display_value=='' ) {
								
								// set ZERO date fields to blank
								$display_value = '';
								
							} else if ( $field['StructureField']['type']=='date' || $field['StructureField']['type']=='datetime' ) {
								
									// some older/different versions of PHP do not have cal_info() function, so manually build expected month array
									$cal_info = array();
									$cal_info['abbrevmonths'] = array(
										1 => 'Jan',
						            2 => 'Feb',
						            3 => 'Mar',
						            4 => 'Apr',
						            5 => 'May',
						            6 => 'Jun',
						            7 => 'Jul',
						            8 => 'Aug',
						            9 => 'Sep',
						            10 => 'Oct',
						            11 => 'Nov',
						            12 => 'Dec'
						         );
								
								// format date STRING manually, using PHP's month name array, becuase of UnixTimeStamp's 1970 - 2038 limitation
								
									$calc_date_string = explode( ' ', $display_value );
									
									if ( $field['StructureField']['type']=='datetime' ) {
										$calc_time_string = $calc_date_string[1];
									}
									
									$calc_date_string = explode( '-', $calc_date_string[0] );
								
								// format month INTEGER into an abbreviated month name, lowercase, to use for translation alias
								
									$calc_date_string_month = intval($calc_date_string[1]);
									$calc_date_string_month = $cal_info['abbrevmonths'][ $calc_date_string_month ];
									$calc_date_string_month = strtolower( $calc_date_string_month );
								
								$display_value = __( $calc_date_string_month, true ).( $options['type']!='csv' ? '&nbsp;' : ' ' ).$calc_date_string[2].( $options['type']!='csv' ? '&nbsp;' : ' ' ).$calc_date_string[0]; // date array to nice string, with month translated
								
								if ( $field['StructureField']['type']=='datetime' ) {
									
									// attach TIME to display
									$display_value .= ' '.$calc_time_string;
									
								}
							}
							
					// put display_value into CONTENT array index, ELSE put span tag if value BLANK and INCREMENT empty index 
					
						if ( trim($display_value)!='' ) {
							$table_index[ $field['display_column'] ][ $row_count ]['content'] .= $table_index[ $field['display_column'] ][ $row_count ]['tag'].$display_value.' ';
						} else {
							$table_index[ $field['display_column'] ][ $row_count ]['content'] .= $table_index[ $field['display_column'] ][ $row_count ]['tag'].'<span class="empty">&ndash;</span> ';
							$table_index[ $field['display_column'] ][ $row_count ]['empty']++;
						}
					
				// get INPUT for FORM
					
					// var TOOLS/APPENDS, if any 
					$append_field_tool = '';
					$append_field_display = '';
					$append_field_display_value = '';
					
					// var for html helper array
					$html_element_array = array();
					$html_element_array['class'] = '';
					$html_element_array['tabindex'] = $field_count + ( ( $tab_key+1 )*1000 );
					
					$field['StructureField']['setting'] = trim($field['StructureField']['setting']);
					if ( $field['StructureField']['setting'] ) {	
						
						// parse through FORM_FIELDS setting value, and add to helper array 
						$field['StructureField']['setting'] = explode( ',', $field['StructureField']['setting'] );
						foreach ( $field['StructureField']['setting'] as $setting ) {
							$setting = explode('=', $setting);
							
							// treat some settings different, ELSE use as HTML ATTRIBUTE 
							if ( $setting[0]=='tool' ) {
								$append_field_tool = $setting[1];
							} else if ( $setting[0]=='append' ) {
								$append_field_display = $setting[1];
							} else {
								$html_element_array[ $setting[0] ] = $setting[1];
							}
						}
						
					}
					
					/*
					// tack on APPEND tool value to display value (if any)...
					if ( $options['type']=='detail' && $append_field_display && $display_value ) {
						$append_field_display_value = $this->requestAction( $append_field_display.$display_value );
						$table_index[ $field['display_column'] ][ $row_count ]['content'] .= $append_field_display_value;
					}
					*/
					
					// reset VALUE for form element, display ID value of FORM/FIELD row at HTML comment
					$display_value =  '
							<!-- '.$field['StructureField']['type'].' '.$field['id'].' -->
							';
						
					/*
					// autocomplete (treat as special INPUT) 
					if ( $field['StructureField']['type']=='autocomplete' ) {
						
						if ( $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
							$html_element_array['class'] .= 'readonly';
							$html_element_array['readonly'] ='readonly';
						} else if ( count($field['StructureField']['StructureValidation']) ) {
							$html_element_array['class'] .= 'required';
						}
						
						
						if ( $options['type']=='editgrid' ) { 
							$html_element_array['value'] = $this->data[$field['StructureField']['model']][$field['StructureField']['field']]; 
							$html_elemt_array['id'] = 'editgrid'.$key.$field['StructureField']['model'].$field['StructureField']['field'].'_autoComplete';
						}
						
						$autocomplete_url = $html_element_array['url'].$field['StructureField']['model'].$model_suffix.$field['StructureField']['field'];
						$display_value .=  $this->Ajax->autoComplete( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $autocomplete_url, $html_element_array );
						
					}
					*/
					
					$html_element_array['div'] = false;
					$html_element_array['label'] = false;
					$html_element_array['type'] = $field['StructureField']['type'];
					
					// set error class, based on validators helper info 
					if ( isset($this->validationErrors[ $field['StructureField']['model'] ][ $field['StructureField']['field'] ]) ) $html_element_array['class'] .= 'error ';
					
					if ( isset($field['flag_'.$options['type'].'_readonly']) && $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
						$html_element_array['class'] .= 'readonly ';
						$html_element_array['readonly'] ='readonly ';
					}
					
					if ( count($field['StructureField']['StructureValidation']) ) {
						$html_element_array['class'] .= 'required '; 
					}
					
					if ( $options['type']=='add' && $field['StructureField']['default'] ) { 
						$html_element_array['value'] = $field['StructureField']['default']; 
					}
					
					if ( $options['type']=='editgrid' ) { 
						$html_element_array['value'] = $this->data[$field['StructureField']['model']][$field['StructureField']['field']]; 
					}
					
					if ( isset( $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) { 
						$html_element_array['value'] = $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]; 
					}
					
					$use_cakephp_form_helper = true;
					switch ($field['StructureField']['type']) {
						
						case 'hidden':
							
							$html_element_array['class'] .= 'hidden ';
							break;
							
						case 'number':
							
							$html_element_array['type'] = 'text';
							break;
							
						case 'input':
							
							$html_element_array['type'] = 'text';
							break;
							
						case 'select':
							
							$html_element_array['options'] = array();
							
							if ( $options['type']=='search' || !count($field['StructureField']['StructureValidation']) ) {
								$html_element_array['empty'] = true;
							}
							
							if ( count($field['StructureField']['StructureValueDomain']) && isset($field['StructureField']['StructureValueDomain']['StructurePermissibleValue']) ) {
								foreach ( $field['StructureField']['StructureValueDomain']['StructurePermissibleValue'] as $lookup ) {
									$html_element_array['options'][ $lookup['value'] ] = __( $lookup['language_alias'], true );
								}
							}
							
							break;
							
						case 'date':
						
							if ( $options['type']=='search' ) {
								$display_value .= $this->Form->day($field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_start', NULL, array('id' => $field['StructureField']['model'].$field['StructureField']['field'].'_start-dd'), false);
								$display_value .= $this->Form->month($field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_start', NULL, array('id' => $field['StructureField']['model'].$field['StructureField']['field'].'_start-mm'), false);
								$display_value .= $this->Form->year($field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_start', '1900', NULL, NULL, array('id' => $field['StructureField']['model'].$field['StructureField']['field'].'_start', 'class' => 'w8em split-date divider-dash highlight-days-12 no-transparency'), false);
								$display_value .= ' <span class="tag">'.__('to',true).'</span> ';
								$display_value .= $this->Form->day($field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_end', NULL, array('id' => $field['StructureField']['model'].$field['StructureField']['field'].'_end-dd'), false);
								$display_value .= $this->Form->month($field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_end', NULL, array('id' => $field['StructureField']['model'].$field['StructureField']['field'].'_end-mm'), false);
								$display_value .= $this->Form->year($field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_end', '1900', NULL, NULL, array('id' => $field['StructureField']['model'].$field['StructureField']['field'].'_end', 'class' => 'w8em split-date divider-dash highlight-days-12 no-transparency'), false);
							}
							
							else {
								$display_value .= $this->Form->day($field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], NULL, array('id' => $field['StructureField']['model'].$field['StructureField']['field'].'-dd'), false);
								$display_value .= $this->Form->month($field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], NULL, array('id' => $field['StructureField']['model'].$field['StructureField']['field'].'-mm'), false);
								$display_value .= $this->Form->year($field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], '1900', NULL, NULL, array('id' => $field['StructureField']['model'].$field['StructureField']['field'], 'class' => 'w8em split-date divider-dash highlight-days-12 no-transparency'), false);
							}
							
							$use_cakephp_form_helper = false;
							break;
							
						default:
							
							break;
							
					}
					
					if ( $use_cakephp_form_helper ) {
						$display_value .= $this->Form->input(
							$field['StructureField']['model'].$model_suffix.$field['StructureField']['field'],
							$html_element_array
						);
					}
					
					/*
					// hidden 
					if ( $field['StructureField']['type']=='hidden' ) {
						$html_element_array['class'] .= 'hidden'; // no need for REQUIRED class, as it's hidden and styles would not be seen anyway
						
						if ( $options['type']=='add' && $field['StructureField']['default'] ) { $html_element_array['value'] = $field['StructureField']['default']; } // add default value, if any 
						if ( $options['type']=='editgrid' ) { $html_element_array['value'] = $this->data[$field['StructureField']['model']][$field['StructureField']['field']]; }
						if ( isset( $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) { $html_element_array['value'] = $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]; }
						
						$display_value .=  $this->Form->hidden( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $html_element_array);
					}
					
					// number 
					if ( $field['StructureField']['type']=='number' ) {
						
						if ( $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
							$html_element_array['class'] .= 'readonly';
							$html_element_array['readonly'] ='readonly';
						} else if ( count($field['StructureField']['StructureValidation']) ) {
							$html_element_array['class'] .= 'required';
						}
						
						if ( $options['type']=='add' && $field['StructureField']['default'] ) { $html_element_array['value'] = $field['StructureField']['default']; } // add default value, if any 
						if ( $options['type']=='editgrid' ) { $html_element_array['value'] = $this->data[$field['StructureField']['model']][$field['StructureField']['field']]; }
						if ( isset( $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) { $html_element_array['value'] = $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]; }
						
						if ( $options['type']=='search' ) {
							$html_element_array['value'] = '-9999';
							$display_value .=  $this->Form->input( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_start', $html_element_array );
							
							$html_element_array['value'] = '9999';
							$display_value .=  ' <span class="tag">'.__( 'core_to', true).'</span> ';
							$display_value .=  $this->Form->input( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_end', $html_element_array );
						} else {
							$display_value .=  $this->Form->input( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $html_element_array );
						}
						
					}
					
					// input 
					if ( $field['StructureField']['type']=='input' ) {
						
						if ( $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
							$html_element_array['class'] .= 'readonly';
							$html_element_array['readonly'] ='readonly';
						} else if ( count($field['StructureField']['StructureValidation']) ) {
							$html_element_array['class'] .= 'required';
						}
							$html_element_array['class'] .= 'testing';
						
						if ( $options['type']=='add' && $field['StructureField']['default'] ) { $html_element_array['value'] = $field['StructureField']['default']; } // add default value, if any 
						if ( $options['type']=='editgrid' ) { $html_element_array['value'] = $this->data[$field['StructureField']['model']][$field['StructureField']['field']]; }
						if ( isset( $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) { $html_element_array['value'] = $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]; }
						
						$display_value .=  $this->Form->input( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $html_element_array );
					}
					
					// password 
					if ( $field['StructureField']['type']=='password' ) {
						
						if ( $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
							$html_element_array['class'] .= 'readonly';
							$html_element_array['readonly'] ='readonly';
						} else if ( count($field['StructureField']['StructureValidation']) ) {
							$html_element_array['class'] .= 'required';
						}
						
						if ( $options['type']=='add' && $field['StructureField']['default'] ) { $html_element_array['value'] = $field['StructureField']['default']; } // add default value, if any 
						if ( $options['type']=='editgrid' ) { $html_element_array['value'] = $this->data[$field['StructureField']['model']][$field['StructureField']['field']]; }
						if ( isset( $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) { $html_element_array['value'] = $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]; }
						
						$display_value .=  $this->Form->password( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $html_element_array );
					}
					
					// textarea 
					if ( $field['StructureField']['type']=='textarea' ) {
						
						if ( $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
							$html_element_array['class'] .= 'readonly';
							$html_element_array['readonly'] ='readonly';
						} else if ( count($field['StructureField']['StructureValidation']) ) {
							$html_element_array['class'] .= 'required';
						}
						
						if ( $options['type']=='add' && $field['StructureField']['default'] ) { $html_element_array['value'] = $field['StructureField']['default']; } // add default value, if any 
						if ( $options['type']=='editgrid' ) { $html_element_array['value'] = $this->data[$field['StructureField']['model']][$field['StructureField']['field']]; }
						if ( isset( $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) { $html_element_array['value'] = $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]; }
						
						$display_value .=  $this->Form->textarea( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $html_element_array );
					}
					
					// select 
					if ( $field['StructureField']['type']=='select' ) {
						
						$showEmpty = true; // variable if pulldown can have BLANK/EMPTY fields at top...
						
						if ( $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
							$html_element_array['class'] .= 'readonly';
							$html_element_array['readonly'] ='readonly';
						} else if ( count($field['StructureField']['StructureValidation']) && $options['type']!='search' ) {
							$html_element_array['class'] .= 'required';
							$showEmpty = false;
						}
						
						$field['StructureField']['options_list'] = array(); // start blank option list array 
						
						// use OVERRIDE passed function variable, which should be proper array
						if ( isset( $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) {
							$field['StructureField']['options_list'] = $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']];
							
						// else use standard StructureOption array 
						} else {
							foreach ( $field['StructureField']['StructureOption'] as $lookup ) {
								if ( strtolower($lookup['active'])=='yes' || $this->data[$field['StructureField']['model']][$field['StructureField']['field']]==$lookup['value'] ) {
									$field['StructureField']['options_list'][ $lookup['value'] ] = __( $lookup['language_choice'], true );
								}
							}
						}
						
						// if no select options, but datatable has a VALUE, set option list to that VALUE 
						if ( !count($field['StructureField']['options_list']) && isset($this->data[$field['StructureField']['model']][$field['StructureField']['field']]) ) {
							$field['StructureField']['options_list'][ $this->data[$field['StructureField']['model']][$field['StructureField']['field']] ] = __( $this->data[$field['StructureField']['model']][$field['StructureField']['field']], true );
						}
						
						if ( $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
							
							if ( count( $field['StructureField']['options_list'] )==1 ) {
								$array_values = array_values($field['StructureField']['options_list']);
								$html_element_array['value'] = $array_values[0];
							} else {
								$html_element_array['value'] = isset($field['StructureField']['options_list'][ $this->data[$field['StructureField']['model']][$field['StructureField']['field']] ]) ? $field['StructureField']['options_list'][ $this->data[$field['StructureField']['model']][$field['StructureField']['field']] ] : '';
								$html_element_array['size'] = strlen($html_element_array['value']);
							}
							
							$display_value .= $this->Form->input( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $html_element_array );
							
							$hidden_html_element_array = array();
							$hidden_html_element_array['class'] = 'hidden';
							
							if ( count( $field['StructureField']['options_list'] )==1 ) {
								$array_values = array_keys($field['StructureField']['options_list']);
								$hidden_html_element_array['value'] = $array_values[0];
							} else {
								$hidden_html_element_array['value'] = $this->data[$field['StructureField']['model']][$field['StructureField']['field']];
							}
							
							$display_value .=  $this->Form->hidden( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $hidden_html_element_array);
							
						} else {
						
						
							if ( $options['type']=='add' && $field['StructureField']['default'] ) { 
								$display_value .=  $this->Form->selectTag( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $field['StructureField']['options_list'], $field['StructureField']['default'], $html_element_array, NULL, $showEmpty, NULL ); // add default value, if any 
							} else if ( $options['type']=='editgrid' ) {
								$display_value .=  $this->Form->selectTag( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $field['StructureField']['options_list'], $this->data[$field['StructureField']['model']][$field['StructureField']['field']], $html_element_array, NULL, $showEmpty, NULL  );
							} else {
								$display_value .=  $this->Form->selectTag( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $field['StructureField']['options_list'], NULL, $html_element_array, NULL, $showEmpty, NULL  );
							}
							
						}
						
					}
					
					// radiolist
					if ( $field['StructureField']['type']=='radiolist' ) {
						
						$showEmpty = true; // variable if pulldown can have BLANK/EMPTY fields at top...
						
						if ( $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
							$html_element_array['class'] .= 'readonly';
							$html_element_array['disabled'] ='disabled';
						} else if ( count($field['StructureField']['StructureValidation']) ) {
							$html_element_array['class'] .= 'required';
							$showEmpty = false;
						}
						
						$provided_element = false; // ELEMENT might be passed in as a COMPLETE table/element; this is flag to indicate if found
						$field['StructureField']['options_list'] = array(); // start blank option list array 
						
						// use OVERRIDE passed function variable, which should be proper array
						if ( isset( $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) {
							
							// if OVERRIDE is array, assume it is list of KEY=>VALUES to parse through
							if ( is_array($override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]) ) {
								$field['StructureField']['options_list'] = $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']];
							
							// if is STRING, assume it's a TABLE/ELEMENT that completely overrides FORM HELPER build (like a provided CHECKLIST FORM )...
							} else if ( trim($override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]) ) {
								$display_value .=  $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']];
								$provided_element = true; // set flag to skip render below...
							}
							
						// else use standard StructureOption array 
						} else {
							foreach ( $field['StructureField']['StructureOption'] as $lookup ) {
								$field['StructureField']['options_list'][ $lookup['value'] ] = __( $lookup['language_choice'], true );
							}
						}
						
						// skip if ELEMENT provided above in OVERRIDE
						if ( !$provided_element ) {
							
							if ( $showEmpty && !isset($field['StructureField']['options_list'][0]) ) {
								$display_default = false;
								if ( $options['type']=='add' && !$field['StructureField']['default'] ) { $display_default = true; }
								else if ( !isset($this->data[$field['StructureField']['model']][$field['StructureField']['field']]) || !$this->data[$field['StructureField']['model']][$field['StructureField']['field']] ) { $display_default = true; }
								$display_value .=  '<input style="float: left;" type="radio" class="radio" name="data['.$model_suffix.$field['StructureField']['model'].']['.$field['StructureField']['field'].']" value="" '.( $display_default ? 'checked="checked"' : '' ).' />'.__( 'core_n-a', true ).'<br />';
								// $field['StructureField']['options_list'][0] = __( 'none', true );
							}
							
							foreach ( $field['StructureField']['options_list'] as $element_key=>$element_value ) {
								$display_default = false;
								if ( $options['type']=='add' && $field['StructureField']['default']==$element_key ) { $display_default = true; }
								else if ( isset($this->data[$field['StructureField']['model']][$field['StructureField']['field']]) && $this->data[$field['StructureField']['model']][$field['StructureField']['field']]==$element_key ) { $display_default = true; }
								$display_value .=  '<input style="float: left;" type="radio" class="radio" name="data['.$model_suffix.$field['StructureField']['model'].']['.$field['StructureField']['field'].']" value="'.$element_key.'" '.( $display_default ? 'checked="checked"' : '' ).' />'.$element_value.'<br />';
							}
							
						}
					}
					
					// checklist 
					if ( $field['StructureField']['type']=='checklist' ) {
						
						if ( $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
							$html_element_array['class'] .= 'readonly';
							$html_element_array['disabled'] ='disabled';
						} else if ( count($field['StructureField']['StructureValidation']) ) {
							$html_element_array['class'] .= 'required';
						}
						
						$provided_element = false; // ELEMENT might be passed in as a COMPLETE table/element; this is flag to indicate if found
						$field['StructureField']['options_list'] = array(); // start blank option list array 
						
						// use OVERRIDE passed function variable, which should be proper array
						if ( isset( $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) {
							
							// if OVERRIDE is array, assume it is list of KEY=>VALUES to parse through
							if ( is_array($override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]) ) {
								$field['StructureField']['options_list'] = $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']];
							
							// if is STRING, assume it's a TABLE/ELEMENT that completely overrides FORM HELPER build (like a provided CHECKLIST FORM )...
							} else if ( trim($override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]) ) {
								$display_value .=  $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']];
								$provided_element = true; // set flag to skip render below...
							}
						
						} 
							
						// else use standard StructureOption array 
						else if ( count($field['StructureField']['StructureOption']) ) {
							foreach ( $field['StructureField']['StructureOption'] as $lookup ) {
								$field['StructureField']['options_list'][ $lookup['value'] ] = __( $lookup['language_choice'], true );
							}
						}
						
						// else, if a default value, use THAT as single checkbox
						else if ( $field['StructureField']['default'] ) {
							$field['StructureField']['options_list'][ $field['StructureField']['default'] ] = '';
						}
						
						// skip if ELEMENT provided above in OVERRIDE
						if ( !$provided_element ) {
							
							// if only ONE global element, then single CHECKBOX instead using HTML HELPER
							if ( count($field['StructureField']['options_list'])==1 ) {
								foreach ( $field['StructureField']['options_list'] as $element_key=>$element_value ) {
									$html_element_array['value'] = $element_key;
									$html_element_array['class'] = 'checkbox';
									$display_value .=  '<span class="checkbox">'.$this->Form->checkbox( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $element_value, $html_element_array, NULL ).'</span>'; 
								}
							
							// otherwise, display CHECKLIST, with names as an ARRAY element
							} else {
								foreach ( $field['StructureField']['options_list'] as $element_key=>$element_value ) {
									$display_value .=  '<input style="float: left;" type="checkbox" class="checkbox" name="data['.$model_suffix.$field['StructureField']['model'].']['.$field['StructureField']['field'].'][]" value="'.$element_key.'" '.( ($options['type']=='add' && $field['StructureField']['default']==$element_key) || ( in_array($element_key, $this->data[$model_suffix.$field['StructureField']['model']][$model_suffix.$field['StructureField']['field']]) ) ? 'checked="checked"' : '' ).' />'.$element_value.'<br />';
								}
							}
						}
					}
					
					// datetime 
					if ( $field['StructureField']['type']=='datetime' ) {
						
						$dateFormat = FORM_DATE_FORMAT;
						$timeFormat = FORM_TIME_FORMAT;
						$selected = NULL;
						
						if ( $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
							$html_element_array['class'] .= 'readonly';
							$html_element_array['disabled'] ='disabled';
						}
						
						if ( !$this->data[$field['StructureField']['model']][$field['StructureField']['field']] ) {
							if ( $options['type']=='add' && $field['StructureField']['default'] ) { $selected = $field['StructureField']['default']; }
							else if ( $options['type']=='add' ) { $selected = date('Y-m-d H:i:s'); }
						}
						
						if ( $options['type']=='editgrid' ) { $selected = $this->data[$field['StructureField']['model']][$field['StructureField']['field']]; }
						if ( isset( $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) { $selected = $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]; }
						
						if ( $options['type']=='search' ) {
							$display_value .=  $this->Form->dateTimeOptionTag( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_start', $dateFormat, $timeFormat, NULL, $html_element_array );
							$display_value .=  ' <span class="tag">'.__( 'core_to', true).'</span> ';
							$display_value .=  $this->Form->dateTimeOptionTag( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_end', $dateFormat, $timeFormat, NULL, $html_element_array );
						} else {
							$display_value .=  $this->Form->dateTimeOptionTag( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $dateFormat, $timeFormat, $selected, $html_element_array );
							$display_value .=  $this->DatePicker->picker($field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], array('format'=>'%Y-%m-%d %H:%M'), 'yes');
						}
						
					}
					
					// date 
					if ( $field['StructureField']['type']=='date' ) {
					
						$dateFormat = FORM_DATE_FORMAT;
						$timeFormat = 'NONE';
						$selected = NULL;
						
						if ( $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
							$html_element_array['class'] .= 'readonly';
							$html_element_array['disabled'] ='disabled';
						}
						
						if ( !$this->data[$field['StructureField']['model']][$field['StructureField']['field']] ) {
							if ( $options['type']=='add' && $field['StructureField']['default'] ) { $selected = $field['StructureField']['default']; }
							else if ( $options['type']=='add' ) { $selected = date('Y-m-d H:i:s'); }
						}
						
						if ( $options['type']=='editgrid' ) { $selected = $this->data[$field['StructureField']['model']][$field['StructureField']['field']]; }
						if ( isset( $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) { $selected = $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]; }
						
						if ( $options['type']=='search' ) {
							$display_value .=  $this->Form->dateTimeOptionTag( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_start', $dateFormat, $timeFormat, NULL, $html_element_array );
							$display_value .=  ' <span class="tag">'.__( 'core_to', true).'</span> ';
							$display_value .=  $this->Form->dateTimeOptionTag( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_end', $dateFormat, $timeFormat, NULL, $html_element_array );
						} else {
							$display_value .=  $this->Form->dateTimeOptionTag( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $dateFormat, $timeFormat, $selected, $html_element_array );
							$display_value .=  $this->DatePicker->picker($field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], array('format'=>'%Y-%m-%d'), 'yes');
						}
						
					}
					
					// time 
					if ( $field['StructureField']['type']=='time' ) {
						
						$dateFormat = 'NONE';
						$timeFormat = FORM_TIME_FORMAT;
						$selected = NULL;
						
						if ( $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
							$html_element_array['class'] .= 'readonly';
							$html_element_array['disabled'] ='disabled';
						}
						
						if ( !$this->data[$field['StructureField']['model']][$field['StructureField']['field']] ) {
							if ( $options['type']=='add' && $field['StructureField']['default'] ) { $selected = $field['StructureField']['default']; }
							else if ( $options['type']=='add' ) { $selected = date('Y-m-d H:i:s'); }
						}
						
						if ( $options['type']=='editgrid' ) { $selected = $this->data[$field['StructureField']['model']][$field['StructureField']['field']]; }
						if ( isset( $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) { $selected = $override[$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]; }
						
						if ( $options['type']=='search' ) {
							$display_value .=  $this->Form->dateTimeOptionTag( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_start', $dateFormat, $timeFormat, NULL, $html_element_array );
							$display_value .=  ' <span class="tag">'.__( 'core_to', true).'</span> ';
							$display_value .=  $this->Form->dateTimeOptionTag( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_end', $dateFormat, $timeFormat, NULL, $html_element_array );
						} else {
							$display_value .=  $this->Form->dateTimeOptionTag( $field['StructureField']['model'].$model_suffix.$field['StructureField']['field'], $dateFormat, $timeFormat, $selected, $html_element_array );
						}
						
					}
					*/
					
					/*
					// if there is a TOOL for this field, APPEND! 
					if ( $append_field_tool && $options['type']!='editgrid' ) {
						
						// multiple INPUT entries, using uploaded CSV file
						if ( $append_field_tool=='csv' ) {
							
							// replace NAME of input with ARRAY format name
							// $display_value = preg_replace('/name\=\"data\[([A-Za-z0-9]+)\]\[([A-Za-z0-9]+)\]\"/i','name="data[$1][$2][]"',$display_value);
							$display_value = str_replace(']"','][]"',$display_value);
							
							// wrap FIELD in DIV/P and add JS links to clone/remove P tags
							$display_value = '
								<div id="'.strtolower($field['StructureField']['model'].'_'.$field['StructureField']['field']).'_with_file_upload">
									'.$display_value.'
									<input class="file" type="file" name="data['.$field['StructureField']['model'].']['.$field['StructureField']['field'].'_with_file_upload]" />
								</div>
							';
							
						}
						
						// multiple INPUT entries, with JS add/remove links
						else if ( $append_field_tool=='multiple' ) {
							
							// replace NAME of input with ARRAY format name
							// $display_value = preg_replace('/name\=\"data\[([A-Za-z0-9]+)\]\[([A-Za-z0-9]+)\]\"/i','name="data[$1][$2][]"',$display_value);
							$display_value = str_replace(']"','][]"',$display_value);
							
							// wrap FIELD in DIV/P and add JS links to clone/remove P tags
							$display_value = '
								<div id="'.strtolower($field['StructureField']['model'].'_'.$field['StructureField']['field']).'_with_clone_fields_js">
									<p class="clone">
										'.$display_value.'
										<a href="#" class="ajax_tool clone_remove" onclick="remove_fields(this); return false;">Remove</a>
									</p>
								</div>
								
								<a href="#" class="ajax_tool clone_add" onclick="clone_fields(\''.strtolower($field['StructureField']['model'].'_'.$field['StructureField']['field']).'_with_clone_fields_js\'); return false;">Add Another</a>
							';
							
						}
						
						// any other TOOL
						else {
							$append_field_tool_id = '';
							$append_field_tool_id = str_replace( '.', ' ', $append_field_tool );
							$append_field_tool_id = trim($append_field_tool_id);
							$append_field_tool_id = str_replace( ' ', '_', $append_field_tool_id );
							
							$javascript_inline = '';
							$javascript_inline .= "new Ajax.Updater( '".$append_field_tool_id."', '".$this->Html->Url( $append_field_tool )."', {asynchronous:false, evalScripts:true} );";
							$javascript_inline .= "Effect.toggle('".$append_field_tool_id."','appear',{duration:0.25});";
							
							$display_value .= '
								<a class="tools" onclick="'.$javascript_inline.'">'.__( 'core_tools', true).'</a>
								
								<div class="ajax_tool" id="'.$append_field_tool_id.'" style="display: none;">
								</div>
								
							';
							
						}
						
					}
					*/
					
					/*
					// add EXTRA, if key exists for this form MODEL/FIELD
					if ( isset( $extras[$model_suffix.$field['StructureField']['model'].'.'.$field['StructureField']['field']] ) ) {
						$display_value .= '
							<br /><br />
							'.$extras[$model_suffix.$field['StructureField']['model'].'.'.$field['StructureField']['field']].'
						';
					}
					*/
					
					// put display_value into CONTENT array index, ELSE put span tag if value BLANK and INCREMENT empty index 
						if ( trim($display_value)!='' ) {
							$table_index[ $field['display_column'] ][ $row_count ]['input'] .= $table_index[ $field['display_column'] ][ $row_count ]['tag'].$display_value.' ';
						} else {
							$table_index[ $field['display_column'] ][ $row_count ]['input'] .= $table_index[ $field['display_column'] ][ $row_count ]['tag'].'<span class="empty">-</span> ';
							$table_index[ $field['display_column'] ][ $row_count ]['empty']++;
						}
				
			} // end IF FIELD[DETAIL]
			
			$field_count++;
			
		} // end FOREACH 
		
		ksort($table_index);
		return $table_index;
		
	} // end FUNCTION build_form_stack()
	

/********************************************************************************************************************************************************************************/

	
	// FUNCTION to build one OR more links...
	// MODEL data, LINKS array, LANG array, ADD array list to INCLUDE, SKIP list to NOT include, and ID value to attach, if any 
	// function generate_links_list( $links=array(), $lang=array(), $add=array(), $skip=array(), $id=NULL, $title='', $in_table=0 ) {
	function generate_links_list( $data=array(), $options=array(), $state='index' ) {
			
		$aro_alias = 'Group::'.$this->Session->read('Auth.User.group_id');
		
		$return_string = '';
		
		$return_urls = array();
		$return_links = array();
		
		$links = isset($options['links'][$state]) ? $options['links'][$state] : array();
		$links = !is_array($links) ? array('detail'=>$links) : $links;
		
		// parse through $LINKS array passed to function, make link for each 
		foreach ( $links as $link_name => $link_location ) {
				
			// check on EDIT only 
			$parts = Router::parse($link_location);
			$aco_alias = 'controllers/'.($parts['plugin'] ? Inflector::camelize($parts['plugin']).'/' : '');
			$aco_alias .= ($parts['controller'] ? Inflector::camelize($parts['controller']).'/' : '');
			$aco_alias .= ($parts['action'] ? $parts['action'] : '');
			
			$Acl = new AclComponent();
			
			// if ACO/ARO permissions check succeeds, create link
			if ( strpos($aco_alias,'controllers/Users')!==false || strpos($aco_alias,'controllers/Pages')!==false || $Acl->check($aro_alias, $aco_alias) ) {
			
				// determine TYPE of link, for styling and icon
					$display_class_name = '';
					$display_class_array = array();
					
					/*
					$display_class_array = str_replace('_', ' ', $link_name);
					$display_class_array = str_replace('-', ' ', $display_class_array);
					$display_class_array = str_replace('  ', ' ', $display_class_array);
					$display_class_array = explode( ' ', trim($display_class_array) );
					$display_class_array[0] = strtolower($display_class_array[0]);
					
						if ( isset($display_class_array[1]) ) { $display_class_array[1] = strtolower($display_class_array[1]); }
						else { $display_class_array[1] = 'core'; }
					*/
						
					/* 
						ICONS allowed by FORMS helper, including PLUGINS
						
						- 16x16 icon for main column in tables
						* 24x24 icon for actions bar
						
						- tree 				- data relationship // NEVER in the action bar
						- * detail				- view data; also, the default icon when no other ICON label fits
						* list				- go to a list or table of data
						* add					- create new data
						* edit				- edit or update existing data
						* delete				- delete existing data
						* cancel				- cancel filling out a form or completing a process
						
						* search				- go to a form to do a search
						duplicate			- copy existing data, either to the database directly, or to populate an add form
						* redo					- do an action again; or change complete to different but related data
						* order					- add to ORDER process, or jump to ORDER plugin
						thumbsup				- add to favourites, or in some way MARK data
						thumbsupfaded		- removed from favourites, or in some way UNMARK data
						
						clinicalannotation
						inventorymanagement
						querytools
						toolsmenu
						drugadministration
						formsmanagement
						storagelayout
						ordermanagement
						protocolmanagement
						studymanagement
						administration
						customize
					*/
					
					/*
					$display_class_name = ( $display_class_array[0]=='list' || $display_class_array[0]=='listall' || $display_class_array[0]=='table' || $display_class_array[0]=='editgrid' || $display_class_array[0]=='grid' || $display_class_array[0]=='index' ? 'list' : $display_class_name );
					$display_class_name = ( $display_class_array[0]=='search' || $display_class_array[0]=='look' ? 'search' : $display_class_name );
					$display_class_name = ( $display_class_array[0]=='add' || $display_class_array[0]=='new' || $display_class_array[0]=='create' ? 'add' : $display_class_name );
					$display_class_name = ( $display_class_array[0]=='edit' || $display_class_array[0]=='change' || $display_class_array[0]=='update' ? 'edit' : $display_class_name );
					$display_class_name = ( $display_class_array[0]=='detail' || $display_class_array[0]=='view' || $display_class_array[0]=='profile' || $display_class_array[0]=='see' ? 'detail' : $display_class_name );
					$display_class_name = ( $display_class_array[0]=='delete' || $display_class_array[0]=='remove' ? 'delete' : $display_class_name );
					$display_class_name = ( $display_class_array[0]=='cancel' || $display_class_array[0]=='back' || $display_class_array[0]=='return' ? 'cancel' : $display_class_name );
					$display_class_name = ( $display_class_array[0]=='duplicate' || $display_class_array[0]=='copy' ? 'duplicate' : $display_class_name );
					$display_class_name = ( $display_class_array[0]=='undo' || $display_class_array[0]=='redo' || $display_class_array[0]=='switch' || $display_class_array[0]=='change' ? 'redo' : $display_class_name );
					$display_class_name = ( $display_class_array[0]=='order' || $display_class_array[0]=='shop' || $display_class_array[0]=='ship' || $display_class_array[0]=='buy' || $display_class_array[0]=='cart' ? 'order' : $display_class_name );
					
					$display_class_name = ( $display_class_array[0]=='favourite' || $display_class_array[0]=='mark' || $display_class_array[0]=='label' || $display_class_array[0]=='thumbsup' || $display_class_array[0]=='thumbup' || $display_class_array[0]=='approve' ? 'thumbsup' : $display_class_name );
					$display_class_name = ( $display_class_array[0]=='unfavourite' || $display_class_array[0]=='unmark' || $display_class_array[0]=='unlabel' || $display_class_array[0]=='thumbsupfaded' || $display_class_array[0]=='thumbupfaded' || $display_class_array[0]=='unapprove' || $display_class_array[0]=='disapprove' ? 'thumbsupfaded' : $display_class_name );
					
					if ( $display_class_array[0]=='plugin' ) {
						$display_class_name = ( $display_class_array[1]=='clinicalannotation' ? 'clinicalannotation' : $display_class_name );
						$display_class_name = ( $display_class_array[1]=='inventorymanagement' ? 'inventorymanagement' : $display_class_name );
						$display_class_name = ( $display_class_array[1]=='querytools' ? 'querytools' : $display_class_name );
						$display_class_name = ( $display_class_array[1]=='toolsmenu' ? 'toolsmenu' : $display_class_name );
						
						$display_class_name = ( $display_class_array[1]=='drugadministration' ? 'drugadministration' : $display_class_name );
						$display_class_name = ( $display_class_array[1]=='formsmanagement' ? 'formsmanagement' : $display_class_name );
						$display_class_name = ( $display_class_array[1]=='storagelayout' ? 'storagelayout' : $display_class_name );
						$display_class_name = ( $display_class_array[1]=='ordermanagement' ? 'ordermanagement' : $display_class_name );
						$display_class_name = ( $display_class_array[1]=='protocolmanagement' ? 'protocolmanagement' : $display_class_name );
						$display_class_name = ( $display_class_array[1]=='studymanagement' ? 'studymanagement' : $display_class_name );
						
						$display_class_name = ( $display_class_array[1]=='administration' ? 'administration' : $display_class_name );
						$display_class_name = ( $display_class_array[1]=='customize' ? 'customize' : $display_class_name );
						
						$display_class_name = ( !$display_class_array[1] ? 'detail' : $display_class_name );
					}
					*/
					
					// default, if none
					$display_class_name = $display_class_name ? $display_class_name : 'detail';				
				
				$htmlAttributes = array(
					'class'	=>	'form '.$display_class_name,
					'title'	=>	strip_tags( __($link_name, true) )
				);
				
				// set Javascript confirmation msg...
				if ( $display_class_name=='delete' ) {
					$confirmation_msg = __( 'core_are you sure you want to delete this data?', true );
				} else {
					$confirmation_msg = NULL;
				}
				
				// replace %%MODEL.FIELDNAME%% 
				$link_location = $this->str_replace_link( $link_location, $data );
				
				$return_urls[]		= $this->Html->url( $link_location );
				$return_links[]	= $this->Html->link( __($link_name, true), $link_location, $htmlAttributes, $confirmation_msg, false );
			
			} 
			
			// if ACO/ARO permission check fails, display NOt ALLOWED type link
			else {
				$return_urls[]		= $this->Html->url( '/menus' );
				$return_links[]	= '<a class="not_allowed">'.__($link_name, true).'</a>';
			} // end CHECKMENUPERMISSIONS 
			
		} // end FOREACH 
		
		// ADD title to links bar and wrap in H5
		if ( $state=='bottom' ) { 
			
			$return_string = '
				<div class="actions">
			';
			
			// display SEARCH RESULTS, if any
			if ( isset($_SESSION['ctrapp_core']['search']) && is_array($_SESSION['ctrapp_core']['search']) ) {
				$return_string .= '
						<a class="search_results" href="'.$this->Html->url($_SESSION['ctrapp_core']['search']['url']).'">
							'.$_SESSION['ctrapp_core']['search']['results'].'
						</a>
				';
			}
			
			if ( count($return_links) ) {
				$return_string .= '
					<ul>
						<li>'.implode('</li><li>',$return_links).'</li>
					</ul>
				';
			}
			
			$return_string .= '
				</div>
			';
			
		} else if ( $state=='top' ) {
		
			$return_string = $return_urls[0];
			
		} else if ( $state=='index' ) {
			
			if ( count($return_links) ) {
				$return_string = implode(' ',$return_links);
			}
			
		}
		
		// return
		return $return_string;
		
	} // end FUNCTION generate_links_list()


/********************************************************************************************************************************************************************************/
	
	
	// FUNCTION to replace %%MODEL.FIELDNAME%% in link with MODEL.FIELDNAME value 
	function str_replace_link( $link='', $data=array() ) {
		
		if ( is_array($data) ) {
			foreach ( $data as $model=>$fields ) {
				foreach ( $fields as $field=>$value ) {
					
					// avoid ONETOMANY or HASANDBELONGSOTMANY relationahips 
					if ( !is_array($value) ) {
						
						// find text in LINK href in format of %%MODEL.FIELD%% and replace with that MODEL.FIELD value...
						$link = str_replace( '%%'.$model.'.'.$field.'%%', $value, $link );
						$link = str_replace( '@@'.$model.'.'.$field.'@@', $value, $link );
	
					} // end !IS_ARRAY 
					
				}
			} // end FOREACH
		}
		
		// return
		return $link;
		
	} // end FUNCTION str_replace_link()
	
	
/********************************************************************************************************************************************************************************/
	
	
	function &array_merge_recursive_distinct( &$array1, &$array2 = null) {
	
		$merged = $array1;
		
		if (is_array($array2)) {
		
			foreach ($array2 as $key => $val) {
			
			if (is_array($array2[$key])) {
				$merged[$key] = is_array($merged[$key]) ? $this->array_merge_recursive_distinct($merged[$key], $array2[$key]) : $array2[$key];
			} else {
				$merged[$key] = $val;
			} // end IF/ELSE
			
			} // end FOREACH
		
		} // end IF array
		
		return $merged;
	
	}


}
	
?>