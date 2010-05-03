<?php
	
App::import('component','Acl');

class StructuresHelper extends Helper {
		
	var $helpers = array( 'Csv', 'Html', 'Form', 'Javascript', 'Ajax', 'Paginator','Session' );
	private static $last_tabindex = 0; 


/********************************************************************************************************************************************************************************/

	
	function hook( $hook_extension='' ) {
		if ( $hook_extension ) $hook_extension = '_'.$hook_extension;
		
		$hook_file = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'views' . DS . $this->params['controller'] . DS . 'hooks' . DS . $this->params['action'].$hook_extension.'.php';
		if ( !file_exists($hook_file) ) $hook_file=false;
		
		return $hook_file;
	}


/********************************************************************************************************************************************************************************/

	
	function build( $atim_structure=array(), $options=array() ) {
		
		$return_string = ''; 

		// DEFAULT set of options, overridden by PASSED options
		$defaults = array(
			'type'		=>	$this->params['action'], // defaults to ACTION
			
			'data'	=> false, // override $this->data values, will not work properly for EDIT forms
			
			'settings'	=> array(
				'return'			=> false, // FALSE echos structure, TRUE returns it as string
				
				// show/hide various structure elements, useful for STACKING multiple structures (for example, to make one BIG form out of multiple smaller forms)
				'actions'		=> true, 
				'header'			=> '',
				'form_top'		=> true, 
				'tabindex'		=> 0, // when setting TAB indexes, add this value to the number, useful for stacked forms
				'form_inputs'	=> true, // if TRUE, use inputs when supposed to, if FALSE use static display values regardless
				'form_bottom'	=> true,
				'separator'		=> false,
				'pagination'	=> true,
				
				'all_fields'	=> false, // FALSE acts on structures datatable settings, TRUE ignores them and displays ALL FIELDS in a form regardless
				'add_fields'	=> false, // if TRUE, adds an "add another" link after form to allow another row to be appended
				'del_fields'	=> false, // if TRUE, add a "remove" link after each row, to allow it to be removed from the form
				
				'columns'		=> array(), // pass inline CSS to any structure COLUMNS
				
				'tree'			=> array() // indicates MULTIPLE atim_structures passed to this class, and which ones to use for which MODEL in each tree ROW
				
			),
			
			'links'		=> array(
				'top'				=> false, // if present, will turn structure into a FORM and this url is used as the FORM action attribute
				'index'			=> array(),
				'bottom'			=> array(),
				
				'tree'			=> array(),
				
				'checklist'		=> array(), // keys are checkbox NAMES (model.field) and values are checkbox VALUES
				'radiolist'		=> array(), // keys are radio button NAMES (model.field) and values are radio button VALUES
				
				'ajax'	=> array( // change any of the above LINKS into AJAX calls instead
					'top'			=> false,
					'index'		=> array(),
					'bottom'		=> array()
				)
			),
			
			'override'	=> array(),
			
			'extras'		=> array() // HTML added to structure blindly, each in own COLUMN
		);
		
		$options = $this->array_merge_recursive_distinct($defaults,$options);
		
		if ( count($options['settings']['tree']) ) {
			foreach ( $atim_structure as $key=>$val ) {
				$atim_structure[$key] = $this->sort_structure( $val );
			}
		} else {
			$atim_structure = $this->sort_structure( $atim_structure );
		}
			
		if ( $options['links']['top'] && $options['settings']['form_top'] ) {
			
			if ( isset($options['links']['ajax']['top']) && $options['links']['ajax']['top'] ) {
				$return_string .= $this->Ajax->form(
					array(
						'type'		=> 'post',    
						'options'	=> array(
							'update'		=> $options['links']['ajax']['top'],
							'url'			=> $options['links']['top']
						)
					)
				);
			}
			
			else {
				$return_string .= '
					<form action="'.$this->generate_links_list( $this->data, $options, 'top' ).'" method="post" enctype="multipart/form-data">
						<fieldset>
				';
			}
		}
		
		if( $options['settings']['separator'] ){
			$return_string .= '<table class="structure" cellspacing="0">
				<tbody>
				<tr><td>
					<hr/>
				</td></tr>
				</tbody></table>';
		}
		
		if( $options['settings']['header'] ){
			$return_string .= '<table class="structure" cellspacing="0">
				<tbody>
				<tr><td>
					<table class="columns details"><tr><td class="heading"><h4>'.$options['settings']['header'].'</h4></td></tr></table>
				</td></tr>
				</tbody></table>';
		}
		
		// run specific TYPE function to build structure
		switch ( $options['type'] ) {
			case 'index':		$options['type'] = 'index';	$return_string .= $this->build_table( $atim_structure, $options );	break;
			case 'table':		$options['type'] = 'index';	$return_string .= $this->build_table( $atim_structure, $options );	break;
			case 'list':		$options['type'] = 'index';	$return_string .= $this->build_table( $atim_structure, $options );	break;
			case 'listall':	$options['type'] = 'index';	$return_string .= $this->build_table( $atim_structure, $options );	break;
			
			case 'checklist':	$options['type'] = 'index';	$return_string .= $this->build_table( $atim_structure, $options );	break;
			case 'radiolist':	$options['type'] = 'index';	$return_string .= $this->build_table( $atim_structure, $options );	break;
			
			case 'grid':		$options['type'] = 'datagrid';	$return_string .= $this->build_table( $atim_structure, $options );	break;
			case 'addgrid':	$options['type'] = 'datagrid';	$return_string .= $this->build_table( $atim_structure, $options );	break;
			case 'editgrid':	$options['type'] = 'datagrid';	$return_string .= $this->build_table( $atim_structure, $options );	break;
			case 'datagrid':	$options['type'] = 'datagrid';	$return_string .= $this->build_table( $atim_structure, $options );	break;
			
			case 'csv':			$options['type'] = 'index';	$return_string .= $this->build_csv( $atim_structure, $options ); $options['settings']['actions'] = false;		break;
			
			case 'add':			$options['type'] = 'add';		$return_string .= $this->build_detail( $atim_structure, $options );	break;
			case 'edit':		$options['type'] = 'edit';		$return_string .= $this->build_detail( $atim_structure, $options );	break;
			case 'search':		$options['type'] = 'search';	$return_string .= $this->build_detail( $atim_structure, $options );	break;
			
			case 'tree':		$options['type'] = 'tree';		$return_string .= $this->build_tree( $atim_structure, $options );		break;
			
			default:				$options['type'] = 'detail';	$return_string .= $this->build_detail( $atim_structure, $options );	break;
		}
		if ( $options['links']['top'] && $options['settings']['form_bottom'] ) {
			if($options['type'] == 'search'){	//search mode
				$link_class = "search";
				$link_label = __("search", null);
			}else{								//other mode
				$link_class = "submit";
				$link_label = __("submit", null);
			}
			$return_string .= '
				</fieldset>
				
				<fieldset class="submit">
					<div>
						<span class="button large">
							<input id="submit_button" class="submit" type="submit" value="Submit" style="display: none;"/>
							<a href="#" onclick="$(\'#submit_button\').click();" class="form '.$link_class.'" tabindex="'.(StructuresHelper::$last_tabindex + 1).'">'.$link_label.'</a>
						</span>
					</div>
			';
		}
		
		if ( $options['links']['top'] && $options['settings']['form_bottom'] ) {
			$return_string .= '
					</fieldset>
				</form>
			';
		}
				
		if ( $options['settings']['actions'] ) {
			$return_string .= $this->generate_links_list(  $this->data, $options, 'bottom' );
		}
		// RETURN or ECHO resulting structure
		if ( $options['settings']['return'] ) { return $return_string; } else { echo $return_string; }
				
	} // end FUNCTION build()


/********************************************************************************************************************************************************************************/

	
	function sort_structure( $atim_structure ) {
		
		if ( count($atim_structure['StructureFormat']) ) {
			// Sort the data with ORDER descending, FIELD ascending 
				foreach ( $atim_structure['StructureFormat'] as $key=>$row ) {
					$sort_order_0[$key] = $row['display_column'];
					$sort_order_1[$key] = $row['display_order'];
					$sort_order_2[$key] = $row['StructureField']['model'];
				}
			
			// multisort, PHP array 
				array_multisort( $sort_order_0, SORT_ASC, $sort_order_1, SORT_ASC, $sort_order_2, SORT_ASC, $atim_structure['StructureFormat'] );
		}
		
		return $atim_structure;
	}
	

/********************************************************************************************************************************************************************************/


	// FUNCTION 
	function build_detail( $atim_structure, $options ) {
		
		$return_string = '';
			
		$table_index = $this->build_stack( $atim_structure, $options );
		
			// display table...
			$return_string .= '
				<table class="structure" cellspacing="0">
				<tbody>
					<tr>
			';
				
				// tack on EXTRAS end, if any
				// $return_string .= $this->display_extras( 'edit', $extras, 'start', count($table_index) );
				
				// each column in table 
				$count_columns = 0;
				foreach ( $table_index as $table_column_key=>$table_column ) {
					
					$count_columns++;
					
					// for each FORM/DETAIL element...
					if ( is_array($table_column) ) {
						
						$return_string .= '
							<td class="this_column_'.$count_columns.' total_columns_'.count($table_index).'"> 
							
								<table class="columns detail" cellspacing="0">
								<tbody>
						';
					
						// each row in column 
						$table_row_count = 0;
						foreach ( $table_column as $table_row_key=>$table_row ) {
							
							// display heading row, if any...
							if ( $table_row['heading'] ) {
								$return_string .= '
									<tr>
										<td class="heading no_border" colspan="'.( show_help ? '3' : '2' ).'">
											<h4>'.$table_row['heading'].'</h4>
										</td>
									</tr>
								';
							}
							
							$return_string .= '
									<tr class="'.$table_row['type'].'">
										<td class="label'.( !$table_row_count && !$table_row['heading'] ? ' no_border' : '' ).'">
											'.$table_row['label'].'
										</td>
										<td class="content'.( $table_row['empty'] ? ' empty' : '' ).( !$table_row_count && !$table_row['heading'] ? ' no_border' : '' ).'">
											'.( $options['links']['top'] && $options['settings']['form_inputs'] ? $table_row['input'] : $table_row['content'] ).'
										</td>
							';
							
							if ( show_help ) {
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
						
					}
					
					// otherwise display EXTRAs...
					else {
						
						$return_string .= '
							<td class="this_column_'.$count_columns.' total_columns_'.count($table_index).'"> 
							
								<table class="columns extra" cellspacing="0">
								<tbody>
									<tr>
										<td>
											'.$table_column.'
										</td>
									</tr>
								</tbody>
								</table>
								
							</td>
						';
						
					}
						
				} // end COLUMN 
				
				// tack on EXTRAS end, if any
				// $return_string .= $this->display_extras( 'edit', $extras, 'end', count($table_index) );
			
			
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
		
		// display table...
		$return_string .= '
			<table class="structure" cellspacing="0">
			<tbody>
				<tr>
		';
			
			// attach PER PAGE pagination param to PASSED params array...
			if ( isset($this->params['named']) && isset($this->params['named']['per']) ) {
				$this->params['pass']['per'] = $this->params['named']['per'];
			}
			
			$this->Paginator->options(array('url' => $this->params['pass']));
			
				if ( is_array($options['data']) ) { $data=$options['data']; }
				else { $data=$this->data; }
				
				$table_structure = array();
				foreach ( $data as $key=>$val ) {
					$options['stack']['key'] = $key;
					$table_structure[$key] = $this->build_stack( $atim_structure, $options );
					unset($options['stack']);
				}
				$structure_count = 0;
				$structure_index = array( 1 => $table_structure ); 
				
				// add EXTRAS, if any
				$structure_index = $this->display_extras( $structure_index, $options );
				
				foreach ( $structure_index as $table_key=>$table_index ) {				
					
					$structure_count++;
					
					// for each FORM/DETAIL element...
					if ( is_array($table_index) ) {
					
						// start table...
						$return_string .= '
							<td class="this_column_'.$structure_count.' total_columns_'.count($structure_index).'">
								
								<table class="columns index" cellspacing="0">
								<tbody>
						';
						
						// header row
						$return_string .= $this->display_header( $table_index, $options );
						
						$column_count = 0;
						if ( count($data) ) {
						
							// each column in table 
							foreach ( $data as $key=>$val ) {
								
								$return_string .= '
									<tr id="table'.$table_key.'row'.$key.'">
								';
									
								$column_count = 0;
								
								if ( count($options['links']['checklist']) ) {
									$return_string .= '
										<td class="checkbox">
									';
									
									foreach ( $options['links']['checklist'] as $checkbox_name=>$checkbox_value ) {
										$checkbox_value = $this->str_replace_link( $checkbox_value, $val );
											$checkbox_form_element = $this->Form->checkbox($checkbox_name, array('value'=>$checkbox_value)); // have to do it TWICE, due to double-model-name error that we couldn't figure out...
 											$checkbox_form_element = $this->Form->checkbox($checkbox_name, array('value'=>$checkbox_value));
										$return_string .= $checkbox_form_element;
									}
									
									$return_string .= '
										</td>
									';
									
									$column_count++;
								}
								
								if ( count($options['links']['radiolist']) ) {
									$return_string .= '
										<td class="radiobutton">
									';
									foreach ( $options['links']['radiolist'] as $radiobutton_name=>$radiobutton_value ) {
										list($tmp_model, $tmp_field) = split("\.", $radiobutton_name);
										$radiobutton_value = $this->str_replace_link( $radiobutton_value, $val );
										$tmp_attributes = array('legend'=>false, 'value'=>false);
										if(isset($val[$tmp_model][$tmp_field]) && $val[$tmp_model][$tmp_field] == $radiobutton_value){
											$tmp_attributes['checked'] = 'checked';
										}
										$return_string .= $this->Form->radio($radiobutton_name, array($radiobutton_value=>''), $tmp_attributes);
									}
									
									$return_string .= '
										</td>
									';
									
									$column_count++;
								}
								
								if ( count($options['links']['index']) ) {
									$return_string .= '
										<td class="id">'.$this->generate_links_list(  $data[$key], $options, 'index' ).'</td>
									';
									
									$column_count++;
								}
								
								// each column/row in table 
								foreach ( $table_index[$key] as $table_column ) {
									foreach ( $table_column as $table_row ) {
										$return_string .= '
											<td>'.( $options['links']['top'] && $options['settings']['form_inputs'] ? $table_row['input'] : $table_row['content'] ).'</td>
										';
										
										$column_count++;
									}
								}
								
								// if OPTIONS set to allow rows to be removed from a GRID, provide link
								if ( $options['type']=='datagrid' && $options['settings']['del_fields'] ) {
									$return_string .= '
											<td class="right">
												<a style="color:red;" href="#" onclick="getElementById(\'table'.$table_key.'row'.$key.'\').parentNode.removeChild(getElementById(\'table'.$table_key.'row'.$key.'\')); return false;" title="'.__( 'click to remove these elements', true ).'">x</a>
											</td>
									';
									
									$column_count++;
								}
								
								$return_string .= '
									</tr>
								';
								
							} // end FOREACH
							
							// if OPTIONS set to allow rows to be added to a GRID, provide link
							if ( $options['type']=='datagrid' && $options['settings']['add_fields'] ) {
								
								$add_another_row_template = '';
								
								$add_another_row_template .= '
									<tr id="table'.$table_key.'row#{id}">
								';
									
								$column_count = 0;
								
								if ( count($options['links']['checklist']) ) {
									$add_another_row_template .= '
										<td class="checkbox">
									';
									
									foreach ( $options['links']['checklist'] as $checkbox_name=>$checkbox_value ) {
										$checkbox_value = $this->str_replace_link( $checkbox_value, '0' );
											$checkbox_form_element = $this->Form->checkbox($checkbox_name, array('value'=>$checkbox_value)); // have to do it TWICE, due to double-model-name error that we couldn't figure out...
 											$checkbox_form_element = $this->Form->checkbox($checkbox_name, array('value'=>$checkbox_value));
										$add_another_row_template .= $checkbox_form_element;
									}
									
									$add_another_row_template .= '
										</td>
									';
									
									$column_count++;
								}
								
								if ( count($options['links']['radiolist']) ) {
									$add_another_row_template .= '
										<td class="radiobutton">
									';
									
									foreach ( $options['links']['radiolist'] as $radiobutton_name=>$radiobutton_value ) {
										$radiobutton_value = $this->str_replace_link( $radiobutton_value, '0' );
										$add_another_row_template .= $this->Form->radio ($radiobutton_name, array($radiobutton_value=>''), array('legend'=>false) );
									}
									
									$add_another_row_template .= '
										</td>
									';
									
									$column_count++;
								}
								
								if ( count($options['links']['index']) ) {
									$add_another_row_template .= '
										<td class="id">'.$this->generate_links_list(  $data['#{id}'], $options, 'index' ).'</td>
									';
									
									$column_count++;
								}
								
								// each column/row in table 
								foreach ( $table_index[ (count($table_index)-1) ] as $table_column ) {
									foreach ( $table_column as $table_row ) {
										
										$table_row['input'] = str_replace('data['.(count($table_index)-1).']','data[#{id}]',$table_row['input']);
										$table_row['input'] = str_replace('id="row'.(count($table_index)-1),'id="row#{id}',$table_row['input']);
										
										$add_another_row_template .= '
											<td>'.( $options['links']['top'] && $options['settings']['form_inputs'] ? $table_row['input'] : $table_row['content'] ).'</td>
										';
										
										$column_count++;
									}
								}
								
								// if OPTIONS set to allow rows to be removed from a GRID, provide link
								if ( $options['type']=='datagrid' && $options['settings']['del_fields'] ) {
									$add_another_row_template .= '
											<td class="right">
												<a style="color:red;" href="#" onclick="getElementById(\'table'.$table_key.'row#{id}\').parentNode.removeChild(getElementById(\'table'.$table_key.'row#{id}\')); return false;" title="'.__( 'click to remove these elements', true ).'">x</a>
											</td>
									';
									
									$column_count++;
								}
								
								$add_another_row_template .= '
									</tr>
								';
								
							}
							
						}
						
						// display something nice for NO ROWS msg...
						else {
							$return_string .= '
									<tr>
											<td class="no_data_available"'.( $column_count ? ' colspan="'.$column_count.'"' : '' ).'>'.__( 'core_no_data_available', true ).'</td>
									</tr>
							';
						}
		
						// if OPTIONS set to allow rows to be added to a GRID, provide link
						if ( $options['type']=='datagrid' && $options['settings']['add_fields'] ) {
							
							$add_another_row_template = preg_replace('/\'/','&quot;',$add_another_row_template);
							$add_another_row_template = preg_replace('/"/',"'",$add_another_row_template);
							$add_another_row_template = str_replace("\n",'',$add_another_row_template);
							$add_another_row_template = str_replace("\r",'',$add_another_row_template);
							$add_another_row_template = preg_replace('/script>/', 's" + "cript>',$add_another_row_template);
							
							$add_another_unique = md5(microtime());
							$add_another_unique_function_name = 'repeat_function_'.$add_another_unique;
							$add_another_unique_next_variable = 'next_'.$add_another_unique;
							$add_another_unique_link_id = 'add_'.$add_another_unique;
							
							$return_string .= '
							</tbody><tfoot>
								<tr id="'.$add_another_unique_link_id.'">
									<td class="right" colspan="'.$column_count.'">
										<a id="addLineLink" style="color:#090; font-weight:bold;" href="#" onclick="'.$add_another_unique_function_name.'(); return false;" title="'.__( 'click to add a line', true ).'">+</a>
									</td>
								</tr>
								</tfoot>
								<script type="text/javascript">
									if( typeof('.$add_another_unique_next_variable.') == "undefined" ){
										var '.$add_another_unique_next_variable.' = "'.count($data).'";
									}else{
										'.$add_another_unique_next_variable.' = "'.count($data).'";
									}
									
									function '.$add_another_unique_function_name.'(){
										var templateLine = "'.$add_another_row_template.'";
										var tbody = $("#'.$add_another_unique_link_id.'").parent().parent().children("tbody:first"); 
										$(tbody).append(templateLine.replace(/#{id}/g, '.$add_another_unique_next_variable.')); 
										'.$add_another_unique_next_variable.'++;
										debug("incr: " + '.$add_another_unique_next_variable.');
										$(tbody).children("tr:last").find(".datepicker").each(function(){
											debug(this.id);
											initDatepicker(this);
										});
										$("form").highlight("td");
										if(window.enableCopyCtrl){
											//if copy control exists, call it
											enableCopyCtrl("table1row" + ('.$add_another_unique_next_variable.'  - 1));
										}
										return false;
									}
								</script>
							';
							
						}
						
						if ( $options['settings']['pagination'] ) {
							$return_string .= '
									<tr class="pagination">
										<th'.( $column_count ? ' colspan="'.$column_count.'"' : '' ).'>
											
											<span class="results">
												'.$this->Paginator->counter( array('format' => '%start%-%end% of %count%') ).'
											</span>
											
											<span class="links">
												'.$this->Paginator->prev( __( 'Prev',true ), NULL, __( 'Prev',true ) ).'
												'.$this->Paginator->numbers().'
												'.$this->Paginator->next( __( 'Next',true ), NULL, __( 'Next',true ) ).'
											</span>
											
											'.$this->Paginator->link( '5', array('page'=>1, 'limit'=>5)).' |
											'.$this->Paginator->link( '10', array('page'=>1, 'limit'=>10)).' |
											'.$this->Paginator->link( '20', array('page'=>1, 'limit'=>20)).' |
											'.$this->Paginator->link( '50', array('page'=>1, 'limit'=>50)).'
											
										</th>
									</tr>
							';
						}
						
						$return_string .= '
								</tfoot>
								</table>
								
							</td>
						';
						
					}
					
					// otherwise display EXTRAs...
					else {
						
						$return_string .= '
							<td class="this_column_'.$structure_count.' total_columns_'.count($structure_index).'"> 
							
								<table class="columns extra" cellspacing="0">
								<tbody>
									<tr>
										<td>
											'.$table_index.'
										</td>
									</tr>
								</tbody>
								</table>
								
							</td>
						';
						
					}
					
				} // end FOREACH
				
		$return_string .= '
				</tr>
			</tbody>
			</table>
		';
				
		return $return_string;
		
	}


/********************************************************************************************************************************************************************************/


	function build_csv( $atim_structure, $options ) {
		
				if ( is_array($options['data']) ) { $data=$options['data']; }
				else { $data=$this->data; }
				
				$table_structure = array();
				foreach ( $data as $key=>$val ) {
					$options['stack']['key'] = $key;
					$table_structure[$key] = $this->build_stack( $atim_structure, $options );
					unset($options['stack']);
				}
				
				$structure_count = 0;
				$structure_index = array( 1 => $table_structure ); 
				
				foreach ( $structure_index as $table_index ) {				
					
					$structure_count++;
					
					// for each FORM/DETAIL element...
					if ( is_array($table_index) ) {
					
						if ( count($data) ) {
							
							// each column in table 
							foreach ( $data as $key=>$val ) {
								
								$line = array();
								
								// each column/row in table 
								foreach ( $table_index[$key] as $table_column ) {
									foreach ( $table_column as $table_row ) {
										
										$line[] = $table_row['plain'];
										
									}
								}
								
								$this->Csv->addRow($line);
								
							} // end FOREACH
							
						}
						
					}
					
				} // end FOREACH
				
		return $this->Csv->render();
		
	}


/********************************************************************************************************************************************************************************/


	function build_tree( $atim_structure, $options ) {
		$return_string = '';
		
		if ( is_array($options['data']) ) { $data=$options['data']; }
		else { $data=$this->data; }
		
		// display table...
		$return_string .= '
			<table class="structure" cellspacing="0">
			<tbody>
				<tr>
		';
		
		$structure_count = 0;
		$structure_index = array( 1 => array() ); 
		
		// add EXTRAS, if any
		$structure_index = $this->display_extras( $structure_index, $options );
		
		foreach ( $structure_index as $column_key=>$table_index ) {
			
			$structure_count++;
			
			$column_inline_styles = '';
			if ( isset($options['settings']['columns'][$column_key]) ) {
				$column_inline_styles .= 'style="';
				foreach ( $options['settings']['columns'][$column_key] as $style_name=>$style_value ) {
					$column_inline_styles .= $style_name.':'.$style_value.';';
				}
				$column_inline_styles .= '"';
			}
			
			// for each FORM/DETAIL element...
			if ( is_array($table_index) ) {
			
				$return_string .= '
					<td column_key="'.$column_key.'" '.$column_inline_styles.' class="this_column_'.$structure_count.' total_columns_'.count($structure_index).'">
				';
				
					// start table...
					$return_string .= '
						<table class="columns tree" cellspacing="0">
						<tbody>
					';
					
					if ( count($data) ) {
						
						// start root level of UL tree, and call NODE function
						$return_string .= '
							<tr><td>
								<ul id="tree_root">
						';
						
						$return_string .= $this->build_tree_node( $atim_structure, $options, $data );
						
						$return_string .= '
								</ul>
							</td></tr>
						';
						
					}
					
					// display something nice for NO ROWS msg...
					else {
						$return_string .= '
								<tr>
										<td class="no_data_available" colspan="1">'.__( 'core_no_data_available', true ).'</td>
								</tr>
						';
					}
					
					$return_string .= '
						</tbody>
						</table>
					';
					
				$return_string .= '
					</td>
				';
						
			}
			
			// otherwise display EXTRAs...
			else {
				
				$return_string .= '
					<td column_key="'.$column_key.'" class="this_column_'.$structure_count.' total_columns_'.count($structure_index).'"> 
					
						<table class="columns extra" cellspacing="0">
						<tbody>
							<tr>
								<td>
									'.$table_index.'
								</td>
							</tr>
						</tbody>
						</table>
						
					</td>
				';
				
			}
			
		} // end FOREACH
				
		$return_string .= '
				</tr>
			</tbody>
			</table>
		';   
			
		return $return_string;
		
	}
	
	function build_tree_node( $atim_structure, $options, $data=array()) {
		
		$return_string = '';
		
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
				
				$return_string_collect = '';
					
					if ( count($options['links']['tree']) ) {
						foreach ( $data_val as $model_name=>$model_array ) {
							if ( isset($options['links']['tree'][$model_name]) ) {
								$tree_options = $options;
								$tree_options['links']['index'] = $options['links']['tree'][$model_name];
								
								$return_string_collect .= $this->generate_links_list(  $data_val, $tree_options, 'index' );
							}
						}
					}
				
					else if ( count($options['links']['index']) ) {
						$return_string_collect .= $this->generate_links_list(  $data_val, $options, 'index' );
					}
				
					$unique_id = mt_rand(1000000, 9999999);
					
					$tree_node_structure = $atim_structure;
					if ( count($options['settings']['tree']) ) {
						foreach ( $data_val as $model_name=>$model_array ) {
							if ( isset($options['settings']['tree'][$model_name]) ) {
								$tree_node_structure = $atim_structure[ $options['settings']['tree'][$model_name] ];
								
								$data_key = $model_array['id']; // so set a UNIQUE id for each set of form elements
							}
						}
					}
					
					$options['type'] = 'index';
					$options['data'] = array( $data_key => $data_val );
					$options['stack']['key'] = $data_key; // required for multiple data submits from TREE
					
					$table_index = $this->build_stack( $tree_node_structure, $options );
					unset($options['stack']);
					
					foreach ( $table_index as $table_column_key=>$table_column ) {
						foreach ( $table_column as $table_row_key=>$table_row ) {
							$return_string_collect .= ' <span class="divider">|</span> '.( $options['links']['top'] && $options['settings']['form_inputs'] ? $table_row['input'] : $table_row['content'] );
						}
					}
				
				// reveal sub ULs if sub ULs exist
				
					if ( count($children) ) {
//						$return_string .= '<a class="reveal" href="#" onclick="Effect.toggle(\'tree_'.$unique_id.'\',\'slide\',{duration:0.25}); return false;">+</a> ';
						$return_string .= '<a class="reveal {\'tree\' : \''.$unique_id.'\'}" href="#" onclick="return false;">+</a> ';
					} else {
						$return_string .= '<a class="reveal not_allowed" onclick="return false;">+</a> ';
					}
					
					$return_string .= ' <span class="divider">|</span> ';
				
				$return_string .= $return_string_collect;
				
				// create sub-UL, calling this NODE function again, if model has any CHILDREN
				if ( count($children) ) { 
					$return_string .= '
						<ul id="tree_'.$unique_id.'" style="display:none;">
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
			
		if ( count($options['links']['checklist']) ) {
			$return_string .= '
					<th class="column_0 checkbox">&nbsp;</th>
			';
		}
		
		if ( count($options['links']['radiolist']) ) {
			$return_string .= '
					<th class="column_0 radiobutton">&nbsp;</th>
			';
		}
		
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
							
							if ( $options['settings']['pagination'] ) {
								$return_string .= $this->Paginator->sort(html_entity_decode($table_row['label'], ENT_QUOTES, "UTF-8"), $table_row['model'].'.'.$table_row['field']);
							} else {
								$return_string .= $table_row['label'];
							}
							
							if ( show_help ) {
								$return_string .= $table_row['help'];
							}
							
							$column_count++;
						}
						
						
						$return_string .= '
							</th>
						';
						
					} // end NOT HIDDEN
					
				} // end FOREACH
			} // end FOREACH
			
		}
		
		if ( $options['type']=='datagrid' && $options['settings']['add_fields'] ) {
			$return_string .= '
				<th>&nbsp;</th>
			';
		}
		
		// end header row...
		$return_string .= '
				</tr>
		';
		
		return $return_string;
		
	}



/********************************************************************************************************************************************************************************/

	
	// FUNCTION 
	function display_extras( $return_array=array(), $options ) {
	
		if ( count($options['extras']) ) {
			foreach ( $options['extras'] as $key=>$val ) {
				
				while ( isset($return_array[$key]) ) {
					$key = $key+1;
				}
				
				$return_array[ $key ] = $val;
				
			}
		}
		
		ksort($return_array);
		
		return $return_array;
		
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
		
		// by default use THIS->DATA, but if data provided through OPTIONS, use that instead
		// data provided through OPTIONS only really useful for display (not for FORMS)
		
			$data = &$this->data;
		
			$model_prefix = '';
			$model_suffix = '.';
			
			if ( isset($options['stack']['key']) ) {
				$tab_key = $options['stack']['key'];
				
				$model_prefix = $options['stack']['key'].'.';
				// $model_suffix = '.'.$options['stack']['key'].'.';
				
				// use DATA passed in through OPTIONS from VIEW
				// OR use DATA juggled in STACKS in this class' BUILD TREE functions
				if ( is_array($options['data']) ) {
					$data = &$options['data'][$options['stack']['key']];
				} 
				
				// use THIS->DATA by default
				else {
					$data = &$this->data[$options['stack']['key']];
				}
			}
			
			else {
				if ( is_array($options['data']) ) {
					$data = $options['data'];
				}
			}
			
		foreach ( $atim_structure['StructureFormat'] as $field ) {
			
			// if STRUCTURE does not allows multi-columns, display STRUCTURE in one column only
			if ( !isset($atim_structure['Structure']['flag_'.$options['type'].'_columns']) ) $atim_structure['Structure']['flag_'.$options['type'].'_columns'] = 0;
			if ( !$atim_structure['Structure']['flag_'.$options['type'].'_columns'] ) $field['display_column'] = 0;
			
			// if table column doesn't already exist, create it 
			if ( !isset( $table_index[ $field['display_column'] ] ) ) $table_index[ $field['display_column'] ] = array();
			
			// display only if flagged for this type of form in the FORMS datatable...
			if ( $options['settings']['all_fields']==true || $field[ 'flag_'.$options['type'] ] ) {
			
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
					$table_index[ $field['display_column'] ][ $row_count ]['plain'] = '';
					
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
					if ( $field['StructureField']['language_tag'] ) $table_index[ $field['display_column'] ][ $row_count ]['tag'] = '<span class="tag">'.__( $field['StructureField']['language_tag'], true).'</span> ';
					
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
								$table_index[ $field['display_column'] ][ $row_count ]['help'] = '<span class="help">&nbsp;<div>'.__($field['StructureField']['language_help'],true).'</div></span> ';
							} else {
								$table_index[ $field['display_column'] ][ $row_count ]['help'] = '<span class="help error">&nbsp;</span>';
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
							if ( isset( $options['override'][ $field['StructureField']['model'].'.'.$field['StructureField']['field'] ] ) ) {
								
								// from ARRAY item...
								if ( is_array($options['override'][ $field['StructureField']['model'].'.'.$field['StructureField']['field'] ]) ) {
									foreach ( $options['override'][ $field['StructureField']['model'].'.'.$field['StructureField']['field'] ] as $key=>$value ) {
										
										if ( $key == $display_value ) {
											$display_value = $value;
										}
										
									}
								} 
								
								// for STRING items...
								else if ( !is_array( $options['override'][ $field['StructureField']['model'].'.'.$field['StructureField']['field'] ] ) ) {
									$display_value = $options['override'][ $field['StructureField']['model'].'.'.$field['StructureField']['field'] ];
								}
								
							// swap out VALUE for LANG LOOKUP choice for SELECTS 
							// } else if ( $field['type']=='select' ) {
							} else if ( count($field['StructureField']['StructureValueDomain']) ) {
								
								// if SOURCE is provided, use provided MODEL::FUNCTION call to retrieve pulldown values
								if ( $field['StructureField']['StructureValueDomain']['source'] ) {
									
									list($pulldown_model,$pulldown_function) = split('::',$field['StructureField']['StructureValueDomain']['source']);
									
									if ( $pulldown_model && App::import('Model',$pulldown_model) ) {
				
										// if model name is PLUGIN.MODEL string, need to split and drop PLUGIN name after import but before NEW
										$pulldown_plugin = NULL;
										if ( strpos($pulldown_model,'.')!==false ) {
											$combined_plugin_model_name = $pulldown_model;
											list($pulldown_plugin,$pulldown_model) = explode('.',$combined_plugin_model_name);
										}
										
										// load MODEL, and override with CUSTOM model if it exists...
											$pulldown_model_object = new $pulldown_model;
											
											$custom_pulldown_model = $pulldown_model.'Custom';
											if ( App::import('Model',$custom_pulldown_model) ) {
												$pulldown_model_object = $$custom_pulldown_model;
											}
										
										// run model::function
										$pulldown_result = $pulldown_model_object->{$pulldown_function}();
										
										// find MATCH in results (it is assumed any translations have happened in the MODEL already)
										foreach ( $pulldown_result as $lookup ) {
											if ( $lookup['value'] == $display_value ) {
												if ( isset($lookup[$options['type']]) ) { $display_value = $lookup[$options['type']]; }
												else { $display_value = $lookup['default']; }
											}
										}
										
									}
									
								}
								
								// use permissible values associated with this value domain instead
								else if ( isset($field['StructureField']['StructureValueDomain']['StructurePermissibleValue']) ) {
								
									foreach ( $field['StructureField']['StructureValueDomain']['StructurePermissibleValue'] as $lookup ) {
										if ( $lookup['value'] == $display_value && $lookup['language_alias'] ) {
											$display_value = __( $lookup['language_alias'], true );
										}
									}
									
								}
								
							}
							
							// format date values a bit...
							if ( $display_value=='0000-00-00' || $display_value=='0000-00-00 00:00:00' || $display_value=='' ) {
								
								// set ZERO date fields to blank
								$display_value = '';
								
							} else if ( $field['StructureField']['type']=='date' || $field['StructureField']['type']=='datetime' ) {
								
								if ( !is_array($display_value) ) {
								
									// some older/different versions of PHP do not have cal_info() function, so manually build expected month array
										$cal_info = array(
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
										$calc_date_string_month = $cal_info[ $calc_date_string_month ];
										$calc_date_string_month = strtolower( $calc_date_string_month );
										$calc_date_string_month = __( $calc_date_string_month, true );
										
										$calc_date_day = $calc_date_string[2];
										
										$calc_date_year = $calc_date_string[0];
										
										$calc_date_divider =  $options['type']!='csv' ? '&nbsp;' : ' ';
										
										// format DATE based on DATE CONFIG, with nice translated month name  �, ��, �
										if ( date_format=='MDY' ) {
											$display_value = $calc_date_string_month.$calc_date_divider.$calc_date_day.$calc_date_divider.$calc_date_year;
										} else if ( date_format=='YMD' ) {
											$display_value = $calc_date_year.$calc_date_divider.$calc_date_string_month.$calc_date_divider.$calc_date_day;
										} else { // default of DATE_FORMAT=='DMY'
											$display_value = $calc_date_day.$calc_date_divider.$calc_date_string_month.$calc_date_divider.$calc_date_year;
										}
										
									if ( $field['StructureField']['type']=='datetime' ) {
										
										// attach TIME to display
										$display_value .= ' '.$calc_time_string;
										
									}
									
								} 
								
								// when DATE fields are validated, different array is returned, but since we don't need a DISPLAY value for FORM date, cheat and just zero it out 
								else {
									$display_value = '';
								}
								
							}else if($field['StructureField']['type'] == "number"
							|| $field['StructureField']['type'] == "integer"
							|| $field['StructureField']['type'] == "integer_positive"
							|| $field['StructureField']['type'] == "float"
							|| $field['StructureField']['type'] == "float_positive"){
								$display_value = StructuresHelper::format_number($display_value);
							}
							
					// put display_value into CONTENT array index, ELSE put span tag if value BLANK and INCREMENT empty index 
						
						$table_index[ $field['display_column'] ][ $row_count ]['plain'] .= str_replace('&nbsp;',' ',$display_value).' ';
						
						if ( trim($display_value)!='' ) {
							$table_index[ $field['display_column'] ][ $row_count ]['content'] .= $table_index[ $field['display_column'] ][ $row_count ]['tag'].$display_value.' ';
						} else {
							$table_index[ $field['display_column'] ][ $row_count ]['content'] .= $table_index[ $field['display_column'] ][ $row_count ]['tag'].'<span class="empty">&ndash;</span> ';
							$table_index[ $field['display_column'] ][ $row_count ]['empty']++;
						}
					
				// get INPUT for FORM
					
					// var TOOLS/APPENDS, if any 
					$append_field_tool = '';
					$append_field_tool_label = 'core tools';
					$append_field_display = '';
					$append_field_display_value = '';
					
					// var for html helper array
					$html_element_array = array();
					$html_element_array['class'] = '';
					$html_element_array['tabindex'] = $options['settings']['tabindex'] + $field_count + ( ( $tab_key+1 )*1000 );
					StructuresHelper::$last_tabindex = $html_element_array['tabindex'];
					
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
							} else if ( $setting[0] == 'tool_label'){
								$append_field_tool_label = $setting[1];
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
							
					$html_element_array['div'] = false;
					$html_element_array['label'] = false;
					$html_element_array['type'] = $field['StructureField']['type'];
					
					// set error class, based on validators helper info 
					if ( isset($this->validationErrors[ $field['StructureField']['model'] ][ $field['StructureField']['field'] ]) ) $html_element_array['class'] .= 'error ';
					
					if ( isset($field['flag_'.$options['type'].'_readonly']) && $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
						$html_element_array['disabled'] = 'disabled';
						$html_element_array['readonly'] = 'readonly';
						$html_element_array['class'] .= 'readonly ';
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
					
					if ( count($options['settings']['tree']) ) { 
						$html_element_array['value'] = $data[$field['StructureField']['model']][$field['StructureField']['field']]; 
					}
					
					if ( !isset( $options['override'][$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) && isset( $options['override'][$field['StructureField']['model'].'.'.$field['StructureField']['field']] ) ) {
						$options['override'][$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] = $options['override'][$field['StructureField']['model'].'.'.$field['StructureField']['field']];
					}
					
					if ( isset( $options['override'][$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) { 
						$html_element_array['value'] = $options['override'][$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]; 
					}
					
					$use_cakephp_form_helper = true;
					switch ($field['StructureField']['type']) {
						
						case 'display':
							
							// [ $options['stack']['key'] ]
							
							if ( count($options['settings']['tree']) ) {
								$display_value .= '<span>'.$data[$field['StructureField']['model']][$field['StructureField']['field']].'</span>';
							} else {
								$display_value .= '<span>'.$this->data[$field['StructureField']['model']][$field['StructureField']['field']].'</span>';
							}
							
							$use_cakephp_form_helper = FALSE;
							break;
							
						case 'hidden':
							
							$html_element_array['class'] .= 'hidden ';
							break;
							
						case 'number':
						case 'integer':
						case 'integer_positive':
						case 'float':
						case 'float_positive':
							
							$html_element_array['type'] = 'text';
							
							if ( $options['type']=='search' ) {
								
								$display_value .= $this->Form->input(
									$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_start',
									$html_element_array
								);
								
								$display_value .= ' <span class="tag">'.__('to',TRUE).'</span> ';
								
								$display_value .= $this->Form->input(
									$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field'].'_end',
									$html_element_array
								);
								
								$use_cakephp_form_helper = FALSE;
							}
							
							break;
							
						case 'input':
							
							$html_element_array['type'] = 'text';
							break;
							
						case 'select':
							
							$html_element_array['options'] = array();
							
							if ( $options['type']=='search' || !count($field['StructureField']['StructureValidation']) ) {
								$html_element_array['empty'] = true;
							}
							
							if ( isset( $options['override'][$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) && is_array( $options['override'][$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) { 
								$html_element_array['options'] = $options['override'][$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']];
								unset($html_element_array['value']);
								
								if ( $options['type']=='editgrid' ) { 
									$html_element_array['value'] = $this->data[$field['StructureField']['model']][$field['StructureField']['field']]; 
								}
								
								if ( count($options['settings']['tree']) ) { 
									$html_element_array['value'] = $data[$field['StructureField']['model']][$field['StructureField']['field']]; 
								}
							}
							
							if ( count($field['StructureField']['StructureValueDomain']) ) {
								
								// if SOURCE is provided, use provided MODEL::FUNCTION call to retrieve pulldown values
								if ( $field['StructureField']['StructureValueDomain']['source'] ) {
									
									list($pulldown_model,$pulldown_function) = split('::',$field['StructureField']['StructureValueDomain']['source']);
									
									if ( $pulldown_model && App::import('Model',$pulldown_model) ) {
				
										// if model name is PLUGIN.MODEL string, need to split and drop PLUGIN name after import but before NEW
										$pulldown_plugin = NULL;
										if ( strpos($pulldown_model,'.')!==false ) {
											$combined_plugin_model_name = $pulldown_model;
											list($pulldown_plugin,$pulldown_model) = explode('.',$combined_plugin_model_name);
										}
										
										// load MODEL, and override with CUSTOM model if it exists...
											$pulldown_model_object = new $pulldown_model;
											
											$custom_pulldown_model = $pulldown_model.'Custom';
											if ( App::import('Model',$custom_pulldown_model) ) {
												$pulldown_model_object = new $$custom_pulldown_model;
											}
										
										// run model::function
										$pulldown_result = $pulldown_model_object->{$pulldown_function}();
										
										// it is assumed any translations have happened in the MODEL already
										foreach ( $pulldown_result as $lookup ) {
											if ( isset($lookup[$options['type']]) ) { $html_element_array['options'][ $lookup['value'] ] = $lookup[$options['type']]; }
											else { $html_element_array['options'][ $lookup['value'] ] = $lookup['default']; }
										}
										
									}
									
								}
								
								// use permissible values associated with this value domain instead
								else if ( isset($field['StructureField']['StructureValueDomain']['StructurePermissibleValue']) ) {
									foreach ( $field['StructureField']['StructureValueDomain']['StructurePermissibleValue'] as $lookup ) {
										$html_element_array['options'][ $lookup['value'] ] = html_entity_decode(__( $lookup['language_alias'], true ), ENT_QUOTES, "UTF-8");
									}
								}
								
							}
							
							break;
							
						case 'radio':
							$html_element_array['options'] = array();
							
							if ( $options['type']=='search' || !count($field['StructureField']['StructureValidation']) ) {
								$html_element_array['empty'] = true;
							}
							
							if ( isset( $options['override'][$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) && is_array( $options['override'][$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) { 
								$html_element_array['options'] = $options['override'][$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']];
								unset($html_element_array['value']);
							}
							
							if ( count($field['StructureField']['StructureValueDomain']) && isset($field['StructureField']['StructureValueDomain']['StructurePermissibleValue']) ) {
								foreach ( $field['StructureField']['StructureValueDomain']['StructurePermissibleValue'] as $lookup ) {
									$html_element_array['options'][ $lookup['value'] ] = __( $lookup['language_alias'], true );
								}
							}
							
							break;
							
						case 'checkbox':
							
							$html_element_array['options'] = array();
							
							if ( $options['type']=='search' || !count($field['StructureField']['StructureValidation']) ) {
								$html_element_array['empty'] = true;
							}
							
							if ( isset( $options['override'][$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) && is_array( $options['override'][$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']] ) ) { 
								$html_element_array['options'] = $options['override'][$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']];
								unset($html_element_array['value']);
							}
							
							if ( count($field['StructureField']['StructureValueDomain']) && isset($field['StructureField']['StructureValueDomain']['StructurePermissibleValue']) ) {
								foreach ( $field['StructureField']['StructureValueDomain']['StructurePermissibleValue'] as $lookup ) {
									$html_element_array['options'][ $lookup['value'] ] = __( $lookup['language_alias'], true );
								}
							}
							
							break;
							
						case 'date':
						case 'datetime':
							// if( !isset($field['flag_'.$options['type'].'_readonly']) ) {
								//use this only if we are not in readonly
								if ( $options['type']=='search' || !count($field['StructureField']['StructureValidation']) ) {
									$html_element_array['empty'] = TRUE;
								}
								
								$model_prefix_css = 'row'.str_replace('.','',$model_prefix);
								$model_suffix_css = str_replace('.','',$model_suffix);
								
								if ( $options['type']=='search' ) {
									$display_value .= $this->get_date_fields($model_prefix, $model_suffix, $field['StructureField'], $html_element_array, $model_prefix_css, $model_suffix_css, "_start", array());
									$display_value .= ' <span class="tag">'.__('to',TRUE).'</span> ';
									$display_value .= $this->get_date_fields($model_prefix, $model_suffix, $field['StructureField'], $html_element_array, $model_prefix_css, $model_suffix_css, "_end", array());
								}else{
									$datetime_array = array();
									if ( isset($options['override'][$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]) ) {
										$datetime_array = StructuresHelper::datetime_to_array($options['override'][$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field']]);
									}else if(isset($this->data) && !empty($this->data) && !isset($this->data[0])&& isset($this->data[$field['StructureField']['model']][$field['StructureField']['field']]) && gettype($this->data[$field['StructureField']['model']][$field['StructureField']['field']]) == "Array"){
										$datetime_array = $this->data[$field['StructureField']['model']][$field['StructureField']['field']];
									}
									$display_value .= $this->get_date_fields($model_prefix, $model_suffix, $field['StructureField'],
									$html_element_array, $model_prefix_css, $model_suffix_css, "", $datetime_array);
										
								}

								$use_cakephp_form_helper = FALSE;
							// }
							break;
							
						case 'autocomplete':
							$html_element_array['type'] = 'text';
							break;
							
						default:
							
							break;
							
					}
					if ( $use_cakephp_form_helper ) {
						if($field['StructureField']['type'] == "autocomplete" 
							&& (!isset($field['flag_'.$options['type'].'_readonly']) || !$field['flag_'.$options['type'].'_readonly'])){
							//autocomplete field, use cakephp autocomplete
							$settings_tmp['tabindex'] = $html_element_array['tabindex'];
							$autocomplete_url = "";
							foreach($field['StructureField']['setting'] as $setting_item){
								if(strpos($setting_item, "url=") === 0){
									//get the url setting
									$autocomplete_url = substr($setting_item, 4);
								}else if(strpos($setting_item, "tool=") === false && strpos($setting_item, "append=") === false){
									//settings that are not url, tool nor append are input settings
									$index = strpos($setting_item, "=");
									if($index > 0){
										$settings_tmp[substr($setting_item, 0, $index)] = substr($setting_item, $index + 1);
									}
								}
							}
							$html_element_array['class'] .= " jqueryAutocomplete {'callback' : 'autoComplete'}";
							$display_value .= $this->Form->input(
								$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field'],
								$html_element_array
							);
						}else{
							$display_value .= $this->Form->input(
								$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field'],
								$html_element_array
							);
						}

						// when a field is DISABLED, pass a HIDDEN field with value to be submitted...
						if ( isset($field['flag_'.$options['type'].'_readonly']) && $field['flag_'.$options['type'].'_readonly'] && $options['type']!='search' ) {
							$html_element_array['type'] = 'hidden';
							$html_element_array['class'] = 'hidden';
							unset($html_element_array['disabled']);
							
							$display_value .= $this->Form->input(
								$model_prefix.$field['StructureField']['model'].$model_suffix.$field['StructureField']['field'],
								$html_element_array
							);
						}
					}
					
					// if there is a TOOL for this field, APPEND! 
					if ( $append_field_tool ) {
						
						// multiple INPUT entries, using uploaded CSV file
						if ( $append_field_tool=='csv' ) {
							if ( $options['type']=='search' ) {
							
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
						}
						
						// multiple INPUT entries, with JS add/remove links
						else if ( $append_field_tool=='multiple' ) {
							if ( $options['type']=='search' ) {
							
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
							$javascript_inline .= "return false;";
							
							
							
							$display_value .= '
								<a href="'.$this->Html->Url( $append_field_tool ).'" class="lightwindow" params="lightwindow_width=800,lightwindow_height=400">'.__($append_field_tool_label, true).'</a>
							';
						}
						
					}
					
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
							$tmpInput = $table_index[ $field['display_column'] ][ $row_count ]['tag'].$display_value.' ';
							if($options['type'] != 'datagrid'){
								$tmpInput = "<span style='white-space: nowrap;'>".$tmpInput."</span>";
							}
							$table_index[ $field['display_column'] ][ $row_count ]['input'] .= $tmpInput;
						} else {
							$table_index[ $field['display_column'] ][ $row_count ]['input'] .= $table_index[ $field['display_column'] ][ $row_count ]['tag'].'<span class="empty">-</span> ';
							$table_index[ $field['display_column'] ][ $row_count ]['empty']++;
						}
				
			} // end IF FIELD[DETAIL]
			
			$field_count++;
			
		} // end FOREACH 
		
		// add EXTRAS, if any (except for TREE/INDEX, handled differently)
			
			if ( $options['type']!='index' && $options['type']!='tree' ) {
				$table_index = $this->display_extras( $table_index, $options );
			}
			
		return $table_index;
		
	} // end FUNCTION build_form_stack()
	

/********************************************************************************************************************************************************************************/


	// FUNCTION 
	function generate_content_wrapper( $atim_content=array(), $options=array() ) {
		
		$return_string = '';
			
			// display table...
			$return_string .= '
				<table class="structure" cellspacing="0">
				<tbody>
					<tr>
			';
				
				// each column in table 
				$count_columns = 0;
				foreach ( $atim_content as $content ) {
					
					$count_columns++;
					
					$return_string .= '
						<td class="this_column_'.$count_columns.' total_columns_'.count($atim_content).'"> 
							
							<table class="columns content" cellspacing="0">
							<tbody>
								<tr>
									<td>
										'.$content.'
									</td>
								</tr>
							</tbody>
							</table>
								
						</td>
					';
					
				} // end COLUMN 
				
			$return_string .= '
					</tr>
				</tbody>
				</table>
			';
			
			$return_string .= $this->generate_links_list( NULL, $options, 'bottom' );
			
		return $return_string;
		
	}


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
		foreach ( $links as $link_name => $link_array ) {
				
			if ( !is_array($link_array) ) {
				$link_array = array( $link_name => $link_array );
			}
			
			$link_results = array();

			$icon = "";
			if(isset($link_array['link'])){
				if(isset($link_array['icon'])){
					$icon = $link_array['icon'];
				}
				$link_array = array( $link_name => $link_array['link'] );
			}
			$prev_icon = $icon;
			foreach ( $link_array as $link_label => &$link_location ) {
				$icon = $prev_icon;
				if(is_array($link_location)){
					if(isset($link_location['icon'])){
						//set requested custom icon
						$icon = $link_location['icon'];
					}
					$link_location = &$link_location['link'];
				}
					
				// if ( !Configure::read("debug") ) {
					// check on EDIT only
					
					$parts = Router::parse($link_location);
					$aco_alias = 'controllers/'.($parts['plugin'] ? Inflector::camelize($parts['plugin']).'/' : '');
					$aco_alias .= ($parts['controller'] ? Inflector::camelize($parts['controller']).'/' : '');
					$aco_alias .= ($parts['action'] ? $parts['action'] : '');
					
					$Acl = new AclComponent();
				// }	
				
				// if ACO/ARO permissions check succeeds, create link
				// if ( Configure::read("debug") || strpos($aco_alias,'controllers/Users')!==false || strpos($aco_alias,'controllers/Pages')!==false || $Acl->check($aro_alias, $aco_alias) ) {
				if ( strpos($aco_alias,'controllers/Users')!==false || strpos($aco_alias,'controllers/Pages')!==false || $Acl->check($aro_alias, $aco_alias) ) {
					
					$display_class_name = $this->generate_link_class($link_name, $link_location);
					$htmlAttributes['title'] = strip_tags( html_entity_decode(__($link_name, true), ENT_QUOTES, "UTF-8") ); 
					
					if(strlen($icon) > 0){
						$htmlAttributes['class'] = 'form '.$icon;
					}else{
						$htmlAttributes['class'] = 'form '.$display_class_name;
					}
					
					// set Javascript confirmation msg...
					if ( $display_class_name=='delete' ) {
						$confirmation_msg = __( 'core_are you sure you want to delete this data?', true );
					} else {
						$confirmation_msg = NULL;
					}
					
					// replace %%MODEL.FIELDNAME%% 
					$link_location = $this->str_replace_link( $link_location, $data );
					
					$return_urls[]		= $this->Html->url( $link_location );
					
					// check AJAX variable, and set link to be AJAX link if exists
						if ( isset($options['links']['ajax'][$state][$link_name]) ) {
							
							// if ajax SETTING is an ARRAY, set helper's OPTIONS based on keys=>values
							if ( is_array($options['links']['ajax'][$state][$link_name]) ) {
								foreach ( $options['links']['ajax'][$state][$link_name] as $html_attribute_key=>$html_attribute_value ) {
									$htmlAttributes[$html_attribute_key] = $html_attribute_value;
								}
							} 
							
							// otherwise if STRING set UPDATE option only
							else {
								$htmlAttributes['json']['update'] = $options['links']['ajax'][$state][$link_name];
							}
							//stuff the ajax information in json format within the class attribute
							$htmlAttributes['class'] .= " ajax {";
							foreach($htmlAttributes['json'] as $key => $val){
								$htmlAttributes['class'] .= "'".$key."' : '".$val."', ";
							}
							$htmlAttributes['class'] = substr($htmlAttributes['class'], 0, strlen($htmlAttributes['class']) - 2)."}";
							unset($htmlAttributes['json']);
						}
				
						$link_results[$link_label]	= $this->Html->link( 
							( $state=='index' ? '&nbsp;' : __($link_label, true) ), 
							$link_location, 
							$htmlAttributes, 
							$confirmation_msg, 
							false 
						);
					
				}
				
				// if ACO/ARO permission check fails, display NOt ALLOWED type link
				else {
					$return_urls[]		= $this->Html->url( '/menus' );
					$link_results[$link_label]	= '<a class="not_allowed">'.__($link_label, true).'</a>';
				} // end CHECKMENUPERMISSIONS
				
			}
			
			if ( count($link_results)==1 && isset($link_results[$link_name]) ) {
				$return_links[$link_name] = $link_results[$link_name];
			}
			
			else {
				
				$links_append = '
							<a class="form popup" href="javascript:return false;">'.__($link_name, TRUE).'</a>
							<!-- container DIV for JS functionality -->
							<div class="filter_menu">
								<ul>
				';
				
				$count = 0;
				$tmpSize = sizeof($link_results) - 1;
				foreach ( $link_results as $link_label=>$link_location ) {
					$class_last_line = "";
					if($count == $tmpSize){
						$class_last_line = " count_last_line";
					}
					$links_append .= '
									<li class="count_'.$count.$class_last_line.'">
										'.$link_location.'
									</li>
					';
					
					$count++;
				}
				
				$links_append .= '
								</ul>
							</div>
				';
				
				$return_links[$link_name] = $links_append;
				
			}
			
		} // end FOREACH 
		
		// ADD title to links bar and wrap in H5
		if ( $state=='bottom' ) { 
			
			$return_string = '
				<div class="actions">
			';
			
			// display SEARCH RESULTS, if any
			if ( isset($_SESSION) && isset($_SESSION['Auth']) && isset($_SESSION['Auth']['User']) && count($_SESSION['Auth']['User']) ) {
				if ( isset($_SESSION['ctrapp_core']['search']) && is_array($_SESSION['ctrapp_core']['search']) ) {
					$return_string .= '
							<div class="search-result-div"><a class="search_results" href="'.$this->Html->url($_SESSION['ctrapp_core']['search']['url']).'">
								'.$_SESSION['ctrapp_core']['search']['results'].'
							</a></div>
					';
				}
			} else {
				unset($_SESSION['ctrapp_core']);
			}
			
			if ( count($return_links) ) {
				$return_string .= '
					<ul><li><ul class="filter">
						<li><div class="bottom_button">'.implode('</div></li><li><div class="bottom_button">',$return_links).'</div></li>
					</ul></li></ul>
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

	
	function generate_link_class( $link_name=NULL, $link_location=NULL ) {
			
		$display_class_name = '';
		$display_class_array = array();
		
		// CODE TO SET CLASS(ES) BASED ON URL GOES HERE!
			
			// determine TYPE of link, for styling and icon
				
				$use_string = $link_name ? $link_name : $link_location;
				
				if ( $link_name ) {
					$use_string = str_replace('core_','',$use_string);
				}
				
				$display_class_array = str_replace('/', ' ', $use_string);
				$display_class_array = str_replace('_', ' ', $display_class_array);
				$display_class_array = str_replace('-', ' ', $display_class_array);
				$display_class_array = str_replace('  ', ' ', $display_class_array);
				$display_class_array = explode( ' ', trim($display_class_array) );
				
					// if URL is passed but no NAME, reduce to words and get LAST word (which should be the action) and use that
					if ( !$link_name && $link_location ) {
						foreach ( $display_class_array as $key=>$val ) {
							if ( strpos($val,'%')!==false || strpos($val,'@')!==false || is_numeric($val) ) {
								unset($display_class_array[$key]);
							} else {
								$display_class_array[$key] = strtolower(trim($val));
							}
						}
					
						$display_class_array = array_reverse($display_class_array);
					}
					
					if ( isset($display_class_array[1]) ) { $display_class_array[1] = strtolower($display_class_array[1]); }
					else { $display_class_array[1] = ''; }
					
					if ( isset($display_class_array[2]) ) { $display_class_array[2] = strtolower($display_class_array[2]); }
					else { $display_class_array[2] = ''; }
				
				// folder (open)
				if ( $display_class_array[0]=='index' )			$display_class_name = 'list';
				if ( $display_class_array[0]=='table' )			$display_class_name = 'list';
				if ( $display_class_array[0]=='tables' )			$display_class_name = 'list';
				if ( $display_class_array[0]=='list' )				$display_class_name = 'list';
				if ( $display_class_array[0]=='lists' )			$display_class_name = 'list';
				if ( $display_class_array[0]=='listall' )			$display_class_name = 'list';
				if ( $display_class_array[0]=='editgrid' )		$display_class_name = 'list';
				if ( $display_class_array[0]=='datagrid' )		$display_class_name = 'list';
				if ( $display_class_array[0]=='grid' )				$display_class_name = 'list';
				if ( $display_class_array[0]=='grids' )			$display_class_name = 'list';
				
				// preview
				if ( $display_class_array[0]=='search' )			$display_class_name = 'search';
				if ( $display_class_array[0]=='look' )				$display_class_name = 'search';
				
				// add
				if ( $display_class_array[0]=='add' )				$display_class_name = 'add';
				if ( $display_class_array[0]=='new' )				$display_class_name = 'add';
				if ( $display_class_array[0]=='create' )			$display_class_name = 'add';
				
				// edit
				if ( $display_class_array[0]=='edit' )				$display_class_name = 'edit';
				if ( $display_class_array[0]=='edits' )			$display_class_name = 'edit';
				if ( $display_class_array[0]=='change' )			$display_class_name = 'edit';
				if ( $display_class_array[0]=='changes' )			$display_class_name = 'edit';
				if ( $display_class_array[0]=='update' )			$display_class_name = 'edit';
				if ( $display_class_array[0]=='updates' )			$display_class_name = 'edit';
				
				// document
				if ( $display_class_array[0]=='detail' )			$display_class_name = 'detail';
				if ( $display_class_array[0]=='details' )			$display_class_name = 'detail';
				if ( $display_class_array[0]=='profile' )			$display_class_name = 'detail';
				if ( $display_class_array[0]=='profiles' )		$display_class_name = 'detail';
				if ( $display_class_array[0]=='view' )				$display_class_name = 'detail';
				if ( $display_class_array[0]=='views' )			$display_class_name = 'detail';
				if ( $display_class_array[0]=='see' )				$display_class_name = 'detail';
				
				// table
				if ( $display_class_array[0]=='grid' )				$display_class_name = 'grid';
				if ( $display_class_array[0]=='datagrid' )		$display_class_name = 'grid';
				if ( $display_class_array[0]=='editgrid' )		$display_class_name = 'grid';
				if ( $display_class_array[0]=='addgrid' )			$display_class_name = 'grid';
				
				// close
				if ( $display_class_array[0]=='delete' )			$display_class_name = 'delete';
				if ( $display_class_array[0]=='remove' )			$display_class_name = 'delete';
				
				// control (rewind)
				if ( $display_class_array[0]=='cancel' )			$display_class_name = 'cancel';
				if ( $display_class_array[0]=='back' )				$display_class_name = 'cancel';
				if ( $display_class_array[0]=='return' )			$display_class_name = 'cancel';
				
				// documents (x3)
				if ( $display_class_array[0]=='duplicate' )		$display_class_name = 'duplicate';
				if ( $display_class_array[0]=='duplicates' )		$display_class_name = 'duplicate';
				if ( $display_class_array[0]=='copy' )				$display_class_name = 'duplicate';
				if ( $display_class_array[0]=='copies' )			$display_class_name = 'duplicate';
				if ( $display_class_array[0]=='return' )			$display_class_name = 'duplicate';
				
				// refresh
				if ( $display_class_array[0]=='undo' )				$display_class_name = 'redo';
				if ( $display_class_array[0]=='redo' )				$display_class_name = 'redo';
				if ( $display_class_array[0]=='switch' )			$display_class_name = 'redo';
				if ( $display_class_array[0]=='switches' )		$display_class_name = 'redo';
				
				// shopping cart
				if ( $display_class_array[0]=='order' )			$display_class_name = 'order';
				if ( $display_class_array[0]=='orders' )			$display_class_name = 'order';
				if ( $display_class_array[0]=='shop' )				$display_class_name = 'order';
				if ( $display_class_array[0]=='shops' )			$display_class_name = 'order';
				if ( $display_class_array[0]=='ship' )				$display_class_name = 'order';
				if ( $display_class_array[0]=='buy' )				$display_class_name = 'order';
				if ( $display_class_array[0]=='cart' )				$display_class_name = 'order';
				if ( $display_class_array[0]=='carts' )			$display_class_name = 'order';
				
				// flag (green)
				if ( $display_class_array[0]=='favourite' )		$display_class_name = 'thumbsup';
				if ( $display_class_array[0]=='favourites' )		$display_class_name = 'thumbsup';
				if ( $display_class_array[0]=='mark' )				$display_class_name = 'thumbsup';
				if ( $display_class_array[0]=='label' )			$display_class_name = 'thumbsup';
				if ( $display_class_array[0]=='labels' )			$display_class_name = 'thumbsup';
				if ( $display_class_array[0]=='thumbsup' )		$display_class_name = 'thumbsup';
				if ( $display_class_array[0]=='thumbup' )			$display_class_name = 'thumbsup';
				if ( $display_class_array[0]=='approve' )			$display_class_name = 'thumbsup';
				
				// flag (black)
				if ( $display_class_array[0]=='unfavourite' )	$display_class_name = 'thumbsdown';
				if ( $display_class_array[0]=='unmark' )			$display_class_name = 'thumbsdown';
				if ( $display_class_array[0]=='unlabel' )			$display_class_name = 'thumbsdown';
				if ( $display_class_array[0]=='thumbsdown' )		$display_class_name = 'thumbsdown';
				if ( $display_class_array[0]=='thumbdown' )		$display_class_name = 'thumbsdown';
				if ( $display_class_array[0]=='unapprove' )		$display_class_name = 'thumbsdown';
				if ( $display_class_array[0]=='disapprove' )		$display_class_name = 'thumbsdown';
				
				// data relationship
				if ( $display_class_array[0]=='tree' )				$display_class_name = 'reveal';
				if ( $display_class_array[0]=='trees' )			$display_class_name = 'reveal';
				if ( $display_class_array[0]=='reveal' )			$display_class_name = 'reveal';
				if ( $display_class_array[0]=='menu' )				$display_class_name = 'reveal';
				if ( $display_class_array[0]=='menus' )			$display_class_name = 'reveal';
				
				// paste
				if ( $display_class_array[0]=='summary' )			$display_class_name = 'summary';
				if ( $display_class_array[0]=='summarize' )		$display_class_name = 'summary';
				if ( $display_class_array[0]=='brief' )			$display_class_name = 'summary';
				if ( $display_class_array[0]=='briefs' )			$display_class_name = 'summary';
				if ( $display_class_array[0]=='abbrev' )			$display_class_name = 'summary';
				
				// tag
				if ( $display_class_array[0]=='filter' )			$display_class_name = 'filter';
				if ( $display_class_array[0]=='filters' )			$display_class_name = 'filter';
				if ( $display_class_array[0]=='restrict' )		$display_class_name = 'filter';
				
				// group
				if ( $display_class_array[0]=='user' )				$display_class_name = 'users';
				if ( $display_class_array[0]=='users' )			$display_class_name = 'users';
				if ( $display_class_array[0]=='group' )			$display_class_name = 'users';
				if ( $display_class_array[0]=='groups' )			$display_class_name = 'users';
				
				// newspaper
				if ( $display_class_array[0]=='news' )				$display_class_name = 'news';
				if ( $display_class_array[0]=='announcement' )	$display_class_name = 'news';
				if ( $display_class_array[0]=='announcements' )	$display_class_name = 'news';
				if ( $display_class_array[0]=='message' )			$display_class_name = 'news';
				if ( $display_class_array[0]=='messages' )		$display_class_name = 'news';
				
				// the following criteria are looking for the plugins
				// they populate the right hand toolbar for the app
				// specific names are needed if you want specific icons - julian / wil - Aug.12'09
				if ( $display_class_array[0]=='plugin' ) {
					if ( $display_class_array[1]=='menus' )													$display_class_name = 'plugin home';
					if ( $display_class_array[1]=='menus' && $display_class_array[2]=='tools' )	$display_class_name = 'plugin tools';
					if ( $display_class_array[1]=='users' && $display_class_array[2]=='logout' )	$display_class_name = 'plugin logout';
					
					if ( $display_class_array[1]=='customize' )												$display_class_name = 'plugin customize';
					
					if ( $display_class_array[1]=='clinicalannotation' )									$display_class_name = 'plugin clinicalannotation';
					if ( $display_class_array[1]=='inventorymanagement' )									$display_class_name = 'plugin inventorymanagement';
					if ( $display_class_array[1]=='datamart' )												$display_class_name = 'plugin datamart';
				
					if ( $display_class_array[1]=='administrate' )											$display_class_name = 'plugin administrate';
					if ( $display_class_array[1]=='drug' )														$display_class_name = 'plugin drug';
					if ( $display_class_array[1]=='rtbform' )													$display_class_name = 'plugin rtbform';
					if ( $display_class_array[1]=='order' )													$display_class_name = 'plugin order';
					if ( $display_class_array[1]=='protocol' )												$display_class_name = 'plugin protocol';
					if ( $display_class_array[1]=='material' )												$display_class_name = 'plugin material';
					if ( $display_class_array[1]=='sop' )														$display_class_name = 'plugin sop';
					if ( $display_class_array[1]=='storagelayout' )											$display_class_name = 'plugin storagelayout';
					if ( $display_class_array[1]=='study' )													$display_class_name = 'plugin study';
					if ( $display_class_array[1]=='pricing' )													$display_class_name = 'plugin pricing';
					if ( $display_class_array[1]=='provider' )													$display_class_name = 'plugin provider';
					if ( $display_class_array[1]=='underdevelopment')	$display_class_name = 'plugin underdev';
					$display_class_name = $display_class_name ?												$display_class_name : 'plugin default';
				}
				
				// document (blank)
				$display_class_name = $display_class_name ?		$display_class_name : 'default';
				
				// if set to DEFAULT but URL has been provided, try again using URL instead!
				if ( $display_class_name=='default' && $link_name && $link_location ) {
					$display_class_name = $this->generate_link_class( NULL, $link_location );
				}

		// return
		return $display_class_name;
		
	} // end FUNCTION generate_link_class()


/********************************************************************************************************************************************************************************/
	
	
	// FUNCTION to replace %%MODEL.FIELDNAME%% in link with MODEL.FIELDNAME value 
	function str_replace_link( $link='', $data=array() ) {
		
		if ( is_array($data) ) {
			foreach ( $data as $model=>$fields ) {
				if ( is_array($fields) ) {
					foreach ( $fields as $field=>$value ) {
						
						// avoid ONETOMANY or HASANDBELONGSOTMANY relationahips 
						if ( !is_array($value) ) {
							
							// find text in LINK href in format of %%MODEL.FIELD%% and replace with that MODEL.FIELD value...
							$link = str_replace( '%%'.$model.'.'.$field.'%%', $value, $link );
							$link = str_replace( '@@'.$model.'.'.$field.'@@', $value, $link );
		
						} // end !IS_ARRAY 
						
					}
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
				if ( !isset($merged[$key]) ) $merged[$key] = array();
				$merged[$key] = is_array($merged[$key]) ? $this->array_merge_recursive_distinct($merged[$key], $array2[$key]) : $array2[$key];
			} else {
				$merged[$key] = $val;
			} // end IF/ELSE
			
			} // end FOREACH
		
		} // end IF array
		
		return $merged;
	
	}
	
	private function get_date_fields($model_prefix, $model_suffix, $structure_field, $html_element_array, $model_prefix_css, $model_suffix_css, $search_suffix, $datetime_array){
		$tmp_datetime_array = array('year' => null, 'month' => null, 'day' => null, 'hour' => "", 'minute' => null, 'meridian' => null);
		$datetime_array = array_merge($tmp_datetime_array, $datetime_array);
		$date = "";
		$my_model_prefix = strlen($model_prefix) > 0 ? "[".substr($model_prefix, 0, 1)."]" : "";
		$date_name_prefix = "data".$my_model_prefix."[".$structure_field['model']."][".$structure_field['field'].$search_suffix."]";
		for($i = 0; $i < 3; ++ $i){
			$tmp_current = substr(date_format, $i, 1);
			if($tmp_current == "Y"){
				$date .= 
					$this->Form->year($model_prefix.$structure_field['model'].$model_suffix.$structure_field['field'].$search_suffix, 
					1900, 
					2100, 
					$datetime_array['year'], 
					am(array('name'=>$date_name_prefix."[year]", 'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix), $html_element_array), 
					$html_element_array['empty']);
			}else if($tmp_current == "M"){
				$date .= 
					$this->Form->month($model_prefix.$structure_field['model'].$model_suffix.$structure_field['field'].$search_suffix, 
					$datetime_array['month'], am(array('name'=>$date_name_prefix."[month]", 'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix.'-mm'), $html_element_array), 
					$html_element_array['empty']);
			}else if($tmp_current == "D"){
				$date .= 
					$this->Form->day($model_prefix.$structure_field['model'].$model_suffix.$structure_field['field'].$search_suffix, 
					$datetime_array['day'], am(array('name'=>$date_name_prefix."[day]", 'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix.'-dd'), $html_element_array), 
					$html_element_array['empty']);
			}else{
				$date .= "UNKNOWN date_format ".date_format;
			}
		}
		
		$date .= '<span style="position: relative;">
				<input type="button" id="'.$model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix.'_button" class="datepicker" value="" tabindex="'.$html_element_array['tabindex'].'"/>
				<img src="'.$this->webroot.'/img/cal.gif" alt="cal" class="fake_datepicker"/>
			</span>';
		
		if ( $structure_field['type']=='datetime' ) {
			$date .= $this->Form->hour($model_prefix.$structure_field['model'].$model_suffix.$structure_field['field'].$search_suffix, false, $datetime_array['hour'], am(array('name'=>$date_name_prefix."[hour]", 'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix.'Hour'), $html_element_array));
			$date .= $this->Form->minute($model_prefix.$structure_field['model'].$model_suffix.$structure_field['field'].$search_suffix, $datetime_array['minute'], am(array('name'=>$date_name_prefix."[min]", 'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix.'Min'), $html_element_array));
			$date .= $this->Form->meridian($model_prefix.$structure_field['model'].$model_suffix.$structure_field['field'].$search_suffix, $datetime_array['meridian'], am(array('name'=>$date_name_prefix."[meridian]", 'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix.'Meridian'), $html_element_array));
		}
		
		return $date;
	}

	/*
	 * Converts a string like yyyy-MM-dd hh:mm:ss to a date array
	 */
	public static function datetime_to_array($datetime){
		$result = array();
		if(strlen($datetime) != 0){
			$date = explode('-', substr($datetime, 0, 10));
			$result['year']		= $date[0];
			$result['month']	= $date[1];
			$result['day']		= $date[2];
			if(strlen($datetime) > 10){
				$time = explode(':', substr($datetime, 11));
				$result['hour']			= $time[0] > 12 ? $time[0] - 12 : $time[0];	
				$result['minute'] 		= $time[1];	
				$result['meridian']		= $time[0] > 12 ? 'pm' : 'am';
			}
		}
		return $result;
	}
	
	public static function format_number($number){
		return decimal_separator == "," ? str_replace(".", ",", $number) : $number;
	}
}
	
?>