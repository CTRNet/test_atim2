<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */
App::uses('Helper', 'View');

/**
 * Class ShellHelper
 */
class ShellHelper extends AppHelper
{

    public $helpers = array(
        'Html',
        'Session',
        'Structures',
        'Form'
    );

    /**
     *
     * @param array $options
     * @return string
     */
    public function header($options = array())
    {
        $return = '';
        // get/set menu for menu BAR
        $menuArray = $this->menu($options['atim_menu'], array(
            'variables' => $options['atim_menu_variables']
        ));
        $menuForWrapper = $menuArray[0];
        
        // get/set menu for header
        $mainMenu = array();
        $menuArray = $this->menu($options['atim_menu_for_header'], array(
            'variables' => $options['atim_menu_variables']
        ));
        $userForHeader = '';
        $rootMenuForHeader = '';
        if (isset($_SESSION) && isset($_SESSION['Auth']) && isset($_SESSION['Auth']['User']) && count($_SESSION['Auth']['User'])) {
            $loggedIn = true;
            // set HEADER root menu links
            
            $rootMenuForHeader .= '<ul class="root_menu_for_header">';
            $onlineWikiStr = __('online wiki');
            $rootMenuForHeader .= '
				<li>
					' . $this->Html->link("", "http://ctrnet.ca/mediawiki/index.php/", array(
                "target" => "blank",
                "class" => "menu help icon32",
                "title" => $onlineWikiStr
            )) . '
				</li>';
            
            foreach ($menuArray[1] as $key => $menuItem) {
                $htmlAttributes = array();
                $htmlAttributes['class'] = 'menu icon32 ' . $this->Structures->generateLinkClass('plugin ' . $menuItem['Menu']['use_link']);
                $htmlAttributes['title'] = __($menuItem['Menu']['language_title']);
                
                if ($menuItem['Menu']['allowed']) {
                    $rootMenuForHeader .= '
							<!-- ' . $menuItem['Menu']['id'] . ' -->
							<li class="' . ($menuItem['Menu']['at'] ? 'at ' : '') . '">
								' . $this->Html->link("", $menuItem['Menu']['use_link'], $htmlAttributes) . '
							</li>
					';
                } else {
                    $rootMenuForHeader .= '
							<!-- ' . $menuItem['Menu']['id'] . ' -->
							<li class="not_allowed">
								<a class="icon32 not_allowed" title="' . __($menuItem['Menu']['language_title']) . '"></a>
							</li>
					';
                }
            }
            $rootMenuForHeader .= '</ul>';
            
            // set HEADER main menu links
            $rootMenuForHeader .= '<ul class="main_menu_for_header">';
            
            foreach ($menuArray[2] as $key => $menuItem) {
                $htmlAttributes = array();
                $htmlAttributes['class'] = 'menu icon32 ' . $this->Structures->generateLinkClass('plugin ' . $menuItem['Menu']['use_link']);
                $htmlAttributes['title'] = __($menuItem['Menu']['language_title']);
                
                if ($menuItem['Menu']['allowed']) {
                    $rootMenuForHeader .= '
							<!-- ' . $menuItem['Menu']['id'] . ' -->
							<li class="' . $menuItem['Menu']['id'] . '">
								' . $this->Html->link("", $menuItem['Menu']['use_link'], $htmlAttributes);
                    if (array_key_exists($menuItem['Menu']['id'], $options['atim_sub_menu_for_header'])) {
                        // sub items (level 3)
                        $subMenu = '';
                        foreach ($options['atim_sub_menu_for_header'][$menuItem['Menu']['id']] as $subMenuItem) {
                            if ($subMenuItem['Menu']['flag_active']) {
                                $htmlAttributes = array();
                                $htmlAttributes['class'] = 'icon32 ' . $this->Structures->generateLinkClass('plugin ' . $subMenuItem['Menu']['use_link']);
                                $htmlAttributes['title'] = __($subMenuItem['Menu']['language_title']);
                                if (AppController::checkLinkPermission($subMenuItem['Menu']['use_link'])) {
                                    $subMenu .= '<li class="sub_menu">' . $this->Html->link("", $subMenuItem['Menu']['use_link'], $htmlAttributes) . "</li>";
                                }
                            }
                        }
                        if (! empty($subMenu)) {
                            $rootMenuForHeader .= '<ul class="sub_menu_for_header ' . $menuItem['Menu']['id'] . '">' . $subMenu . '</ul>';
                        }
                    }
                    
                    $rootMenuForHeader .= '		
						</li>
					';
                } else {
                    $rootMenuForHeader .= '
							<!-- ' . $menuItem['Menu']['id'] . ' -->
							<li>
								<a class="icon32 not_allowed" title="' . __($menuItem['Menu']['language_title']) . '"></a>
							</li>
					';
                }
            }
            $rootMenuForHeader .= '</ul>';
        } else {
            $loggedIn = false;
        }
        $return .= "<fieldset class='mainFieldset'>"; // the fieldset is present to manage the display for wide forms such as addgrids
        $headerClass = (Configure::read("IsTest")) ? "test" : "prod";
        $return .= '
			<!-- start #header -->
			<div id="header"><div>
				<h1>' . __('core_appname') . '</h1>
				<h2 class = "' . $headerClass . '">' . __('core_installname') . ($headerClass == "test" ? ' - ' . __('test') : '') . '</h2>
				' . $rootMenuForHeader . '
			</div></div>
			<!-- end #header -->
			
		';
        if ($loggedIn) {
            // display DEFAULT menu
            if (empty($menuForWrapper)) {
                $menuForWrapper = "";
            }
            $return .= '
				<!-- start #menu -->
				<div id="menu">
					' . $menuForWrapper . '
				</div>
				<!-- end #menu -->
			';
        } else {
            // display hardcoded LOGIN menu
            $return .= '
				<!-- start #menu -->
				<div id="menu">
						
					<div class="menu level_0">
						<ul class="total_count_1">
							<li class="at count_0 root">' . $this->Html->link('<span class="icon32 rm5px login"></span>' . __('Login'), '/', array(
                'title' => __('Login'),
                'escape' => false,
                'class' => 'MainTitle'
            )) . '</li>
						</ul>
					</div>
					
				</div>
				<!-- end #menu -->
			';
        }
        
        // display any VALIDATION ERRORS
        
        $return .= '<div class="validationWrapper">' . $this->validationHtml() . '</div>	
			<!-- start #wrapper -->
			<div class="outerWrapper">
				<div id="wrapper" class="wrapper plugin_' . (isset($this->request->params['plugin']) ? $this->request->params['plugin'] : 'none') . ' controller_' . $this->request->params['controller'] . ' action_' . $this->request->params['action'] . '">
		';
        
        return $return;
    }

    /**
     *
     * @param $class
     * @param $msg
     * @param null $collapsable
     * @return string
     */
    public function getValidationLine($class, $msg, $collapsable = null)
    {
        $result = '<li><span class="icon16 ' . $class . ' mr5px"></span>' . $msg;
        if ($collapsable) {
            $result .= ' <a href="#" class="warningMoreInfo">[+]</a><pre class="hidden warningMoreInfo">' . print_r($collapsable, true) . '</pre>';
        }
        return $result . '</li>';
    }

    /**
     *
     * @return string
     */
    public function validationHtml()
    {
        $displayErrorsHtml = $this->validationErrors();
        
        $confirmMsgHtml = "";
        if (isset($_SESSION['ctrapp_core']['confirm_msg'])) {
            $confirmMsgHtml = '<ul class="confirm"><li><span class="icon16 confirm mr5px"></span>' . $_SESSION['ctrapp_core']['confirm_msg'] . '</li></ul>';
            unset($_SESSION['ctrapp_core']['confirm_msg']);
        }
        if (isset($_SESSION['ctrapp_core']['warning_trace_msg']) && count($_SESSION['ctrapp_core']['warning_trace_msg'])) {
            $confirmMsgHtml .= '<ul class="warning">';
            foreach ($_SESSION['ctrapp_core']['warning_trace_msg'] as $traceMsg) {
                if (isset($traceMsg['msg']) && isset($traceMsg['trace']) && is_array($traceMsg['trace'])) {
                    $confirmMsgHtml .= $this->getValidationLine('warning', $traceMsg['msg'], $traceMsg['trace']);
                } else {
                    $confirmMsgHtml .= '<li><span class="icon16 warning mr5px"></span>' . $traceMsg . '</li>';
                }
            }
            $confirmMsgHtml .= '</ul>';
            $_SESSION['ctrapp_core']['warning_trace_msg'] = array();
        }
        
        if (isset($_SESSION['ctrapp_core']['error_msg']) && count($_SESSION['ctrapp_core']['error_msg'])) {
            $confirmMsgHtml .= '<ul class="error">';
            foreach ($_SESSION['ctrapp_core']['error_msg'] as $traceMsg) {
                $confirmMsgHtml .= '<li><span class="icon16 delete mr5px"></span>' . $traceMsg . '</li>';
            }
            $confirmMsgHtml .= '</ul>';
            $_SESSION['ctrapp_core']['error_msg'] = array();
        }
        foreach (array(
            'confirm' => 'confirm',
            'warning_no_trace' => 'warning',
            'info' => 'info',
            'error' => 'delete'
        ) as $type => $class) {
            if (isset($_SESSION['ctrapp_core'][$type . '_msg']) && count($_SESSION['ctrapp_core'][$type . '_msg']) > 0) {
                $confirmMsgHtml .= '<ul class="' . $class . '">';
                foreach ($_SESSION['ctrapp_core'][$type . '_msg'] as $msg => $count) {
                    if ($count > 1) {
                        $msg .= " (" . $count . ")";
                    }
                    $confirmMsgHtml .= $this->getValidationLine($class, $msg);
                }
                
                $confirmMsgHtml .= '</ul>';
                $_SESSION['ctrapp_core'][$type . '_msg'] = array();
            }
        }
        
        $return = "";
        if ($displayErrorsHtml != null || strlen($confirmMsgHtml) > 0 && (! $this->request->is('ajax') || $_SESSION['ctrapp_core']['force_msg_display_in_popup'])) {
            $return .= '
				<!-- start #validation -->
				<div class="validation">
					' . $displayErrorsHtml . $confirmMsgHtml . '
				</div>
				<!-- end #validation -->
				';
        }
        
        $_SESSION['ctrapp_core']['force_msg_display_in_popup'] = false;
        
        return $return;
    }

    /**
     *
     * @return string
     */
    public function validationErrors()
    {
        $result = "";
        $displayErrors = array();
        $formatStr = '<li><span class="icon16 delete mr5px"></span>%s</li>';
        foreach ($this->_View->validationErrors as $model) {
            foreach ($model as $field) {
                if (is_array($field)) {
                    foreach ($field as $fieldUnit) {
                        $displayErrors[] = sprintf($formatStr, __($fieldUnit));
                    }
                } else {
                    $displayErrors[] = sprintf($formatStr, __($field));
                }
            }
        }
        if ($displayErrors) {
            $result = '<ul class="error">
						' . implode('', array_unique($displayErrors)) . '
					</ul>';
        }
        return $result;
    }

    /**
     *
     * @param array $options
     * @return string
     */
    public function footer($options = array())
    {
        $return = '';
        
        $return .= '
		   		</div>
		   </div>
		   
			<!-- end #wrapper -->
			
			<!-- start #footer -->
			<div id="footer">
						' . $this->Html->link(__('core_footer_about'), '/Pages/about/') . ' | ' . $this->Html->link(__('core_footer_installation'), '/Pages/installation/') . ' | ' . $this->Html->link(__('core_footer_credits'), '/Pages/credits/') . '<br/>
						' . __('core_copyright') . ' &copy; ' . date('Y') . ' ' . $this->Html->link(__('core_ctrnet'), 'https://www.ctrnet.ca/') . '<br/>
						' . __('core_app_version') . '
			</div>
			<!-- end #footer -->
			</fieldset>
		';
        
        return $return;
    }

    /**
     *
     * @param array $atimMenu
     * @param array $options
     * @return array
     */
    public function menu($atimMenu = array(), $options = array())
    {
        $pageTitle = array();
        if (! isset($this->pageTitle)) {
            $this->pageTitle = '';
        }
        
        $returnHtml = array();
        $rootMenuArray = array();
        $mainMenuArray = array();
        
        if (count($atimMenu)) {
            
            $summaries = array();
            if (! isset($options['variables'])) {
                $options['variables'] = array();
            }
            
            if (isset($_SESSION) && isset($_SESSION['Auth']) && isset($_SESSION['Auth']['User']) && count($_SESSION['Auth']['User'])) {
                
                $count = 0;
                $totalCount = 0;
                $isRoot = false; // used to remove unneeded ROOT menu items from displaying in bar
                if (is_array($atimMenu)) {
                    foreach ($atimMenu as $menu) {
                        $activeItem = '';
                        $summaryItem = '';
                        $appendMenu = '';
                        
                        // save BASE array (main menu) for display in header
                        if ($count == (count($atimMenu) - 1)) {
                            $rootMenuArray = $menu;
                        } elseif ($count == (count($atimMenu) - 2)) {
                            $mainMenuArray = $menu;
                        }
                        
                        if (! $isRoot) {
                            
                            $subCount = 0;
                            foreach ($menu as &$menuItem) {
                                
                                if ($menuItem['Menu']['use_link'] && count($options['variables'])) {
                                    foreach ($options['variables'] as $k => $v) {
                                        $menuItem['Menu']['use_link'] = str_replace('%%' . $k . '%%', $v, $menuItem['Menu']['use_link']);
                                    }
                                }
                                
                                if ($menuItem['Menu']['at'] && $menuItem['Menu']['use_summary']) {
                                    $fetchedSummary = $this->fetchSummary($menuItem['Menu']['use_summary'], $options);
                                    $summaries[] = $fetchedSummary['long'];
                                    $menuItem['Menu']['use_summary'] = isset($fetchedSummary['page_title']) ? $fetchedSummary['page_title'] : "";
                                }
                                
                                if ($menuItem['Menu']['at']) {
                                    $isRoot = $menuItem['Menu']['is_root'];
                                    
                                    $summaryItem = $menuItem['Menu']['use_summary'] ? null : array(
                                        'class' => 'without_summary'
                                    );
                                    
                                    if ($menuItem['Menu']['use_summary']) {
                                        $word = __(trim($menuItem['Menu']['language_title']));
                                        $untranslated = strpos($word, "<span class='untranslated'>") === 0;
                                        if ($untranslated) {
                                            $word = substr(trim($word), 27, - 7);
                                        }
                                        $maxLength = 30;
                                        if (strlen($word) > $maxLength) {
                                            $word = '<span class="incompleteMenuTitle" title="' . htmlentities($word, ENT_QUOTES) . '">' . substr($word, 0, - 1 * (strlen($word) - $maxLength)) . "..." . '</span>';
                                        }
                                        $word = $untranslated ? '<span class="untranslated">' . $word . '</span>' : $word;
                                        
                                        if ($isRoot) {
                                            $class = ' menu ' . $this->Structures->generateLinkClass('plugin ' . $menuItem['Menu']['use_link']);
                                            $activeItem = $this->Html->link(html_entity_decode('<span class="icon32 mr5px ' . $class . '" style="vertical-align: bottom;"></span><span style="display: inline-block">' . $menuItem['Menu']['use_summary'] . '<br/><span class="menuSubTitle">&nbsp;&lfloor; ' . $word . '</span></span>', ENT_QUOTES, "UTF-8"), $menuItem['Menu']['use_link'], array(
                                                'escape' => false,
                                                'title' => $title,
                                                'class' => 'mainTitle'
                                            ));
                                        } else {
                                            $activeItem = '
                                                                                                            <span class="mainTitle">' . $menuItem['Menu']['use_summary'] . '</span>
                                                                                                            <br/>&nbsp;&lfloor; <span class="menuSubTitle">' . $word . '</span>
                                                                                                    ';
                                        }
                                        
                                        $pageTitle[] = $menuItem['Menu']['use_summary'];
                                    } else {
                                        
                                        if ($isRoot) {
                                            $title = html_entity_decode(__($menuItem['Menu']['language_title']), ENT_QUOTES, "UTF-8");
                                            
                                            // $activeItem = $menuItem['Menu']['allowed'] ? $this->Html->link( __($menuItem['Menu']['language_title']), $menuItem['Menu']['use_link'], $htmlAttributes ) : __($menuItem['Menu']['language_title']);
                                            
                                            if (! $menuItem['Menu']['allowed']) {
                                                $activeItem = '<a class="icon32 mr5px not_allowed" title="' . __($menuItem['Menu']['language_title']) . '">' . __($menuItem['Menu']['language_title']) . '</a>';
                                            } else {
                                                // $htmlAttributes
                                                $class = ' menu ' . $this->Structures->generateLinkClass('plugin ' . $menuItem['Menu']['use_link']);
                                                $activeItem = $this->Html->link(html_entity_decode('<span class="icon32 mr5px ' . $class . '"></span>' . __($menuItem['Menu']['language_title']), ENT_QUOTES, "UTF-8"), $menuItem['Menu']['use_link'], array(
                                                    'escape' => false,
                                                    'title' => $title,
                                                    'class' => 'mainTitle'
                                                ));
                                            }
                                        } else {
                                            $activeItem = '<span class="mainTitle">' . __($menuItem['Menu']['language_title']) . '</span>';
                                        }
                                        
                                        $pageTitle[] = __($menuItem['Menu']['language_title']);
                                    }
                                }
                                
                                $title = html_entity_decode(__($menuItem['Menu']['language_title']), ENT_QUOTES, "UTF-8");
                                if (! $menuItem['Menu']['is_root'] && $menuItem['Menu']['flag_submenu']) {
                                    if ($menuItem['Menu']['allowed']) {
                                        $appendMenu .= '
                                                                                                            <!-- ' . $menuItem['Menu']['id'] . ' -->
                                                                                                            <li class="' . ($menuItem['Menu']['at'] ? 'at ' : '') . 'count_' . $subCount . '">
                                                                                                                    ' . $this->Html->link('<span class="icon16 list"></span><span class="menuLabel">' . $title . '</span>', $menuItem['Menu']['use_link'], array(
                                            'escape' => false,
                                            'title' => $title
                                        )) . '
                                                                                                            </li>
                                                                                            ';
                                    } else {
                                        $appendMenu .= '
                                                                                                            <!-- ' . $menuItem['Menu']['id'] . ' -->
                                                                                                            <li class="not_allowed count_' . $subCount . '">
                                                                                                                    <a title="' . $title . '"><span class="icon16 not_allowed"></span><span class="menuLabel">' . $title . '</span></a>
                                                                                                            </li>
                                                                                                                                            ';
                                    }
                                    $subCount ++;
                                }
                            }
                            
                            if (Configure::read('debug')) {
                                foreach ($menu as $menuItem) {
                                    if (preg_match('/%%[\w.]+%%/', $menuItem['Menu']['use_link'])) {
                                        AppController::addWarningMsg('DEBUG: bad link detected [' . $menuItem['Menu']['use_link'] . ']');
                                    }
                                }
                            }
                            
                            // append FLYOUT menus to all menu bar TABS except ROOT tab
                            if (! $isRoot) {
                                $appendMenu = '
                                                                                            <div class="menu level_1">
                                                                                                    <ul>
                                                                                                            ' . $appendMenu . '
                                                                                                    </ul>
                                                                                            </div>
                                                                            ';
                            } else {
                                $appendMenu = '';
                            }
                            
                            $returnHtml[] = '
                                                                            <li class="at count_' . $count . ($isRoot ? ' root' : '') . '">
                                                                                    ' . $activeItem . '
                                                                                    ' . $appendMenu . '
                                                                            </li>
                                                                    ';
                            
                            // increment number of VISIBLE menu bar tabs
                            $totalCount ++;
                        }
                        
                        // increment number to TOTAL menu array items
                        $count ++;
                    }
                }
            }
            
            // if summary info has been provided AND config variable allows it, provide expandable tab
            
            $returnSummary = '';
            $summaries = array_filter($summaries);
            if (SHOW_SUMMARY && count($summaries)) {
                $returnSummary .= '
					<ul id="summary">
						<li>
							<span class="summaryBtn">' . __('summary', null) . '</span>
							
							<ul>
				';
                
                $summaryCount = 0;
                foreach ($summaries as $summary) {
                    $returnSummary .= '
								<li class="count_' . $summaryCount . '">
									' . $summary . '
								</li>
					';
                    
                    $summaryCount ++;
                }
                
                $returnSummary .= '
							</ul>
							
						</li>
					</ul>
				';
            }
        }
        
        if ($returnHtml) {
            $returnHtml = '
				<div class="menu level_0">
					<ul class="total_count_' . $totalCount . '">
						' . implode('', array_reverse($returnHtml)) . '
					</ul>
					
					' . $returnSummary . '
				</div>
			';
        }
        
        // reverse-sort the Page Title array, and set pageTitle
        if (strlen($this->pageTitle) == 0) {
            $this->pageTitle = implode(' &laquo; ', $pageTitle);
        }
        
        $returnArray = array(
            $returnHtml,
            $rootMenuArray,
            $mainMenuArray
        );
        return $returnArray;
    }

    /**
     * Builds 2 summaries, one for the menu tabs (short) and one for the summary button (long)
     *
     * @param unknown_type $summary
     * @param unknown_type $options
     * @return array('short' => short summary, 'long' => long summary)
     */
    public function fetchSummary($summary, $options)
    {
        $result = array(
            "short" => null,
            "long" => null
        );
        if ($summary) {
            // get StructureField model, to swap out permissible values if needed
            App::uses('StructureField', 'Model');
            $structureFieldsModel = new StructureField();
            
            list ($model, $function) = explode('::', $summary);
            
            if (! $function) {
                $function = 'summary';
            }
            
            if ($model) {
                // if model name is PLUGIN.MODEL string, need to split and drop PLUGIN name after import but before NEW
                $plugin = null;
                if (strpos($model, '.') !== false) {
                    $pluginModelName = $model;
                    list ($plugin, $model) = explode('.', $pluginModelName);
                }
                
                // load MODEL, and override with CUSTOM model if it exists...
                $summaryModel = AppModel::getInstance($plugin, $model, true);
                $summaryResult = $summaryModel->{$function}($options['variables']);
                
                if ($summaryResult) {
                    // short---
                    if (isset($summaryResult['menu']) && is_array($summaryResult['menu'])) {
                        $parts = array(
                            trim($summaryResult['menu'][0]) . " ",
                            isset($summaryResult['menu'][1]) ? trim($summaryResult['menu'][1]) : ''
                        );
                        $totalLength = 0;
                        $resultStr = "";
                        $maxLength = 22;
                        foreach ($parts as $part) {
                            $untranslated = strpos($part, "<span class='untranslated'>") === 0;
                            if ($untranslated) {
                                $part = substr(trim($part), 27, - 7);
                            }
                            $totalLength += strlen($part);
                            if ($totalLength > $maxLength) {
                                $part = substr($part, 0, - 1 * ($totalLength - $maxLength)) . "...";
                            }
                            $resultStr .= $untranslated ? '<span class="untranslated">' . $part . '</span>' : $part;
                            if ($totalLength > $maxLength) {
                                $result['page_title'] = $resultStr;
                                $resultStr = '<span class="incompleteMenuTitle" title="' . htmlentities(implode("", $parts), ENT_QUOTES) . '">' . $resultStr . '</span>';
                                break;
                            }
                        }
                        $result['short'] = $resultStr;
                        if (! isset($result['page_title'])) {
                            $result['page_title'] = $resultStr;
                        }
                    } else {
                        $result['short'] = false;
                    }
                    // --------
                    
                    // long---
                    $summaryLong = "";
                    if (isset($summaryResult['title']) && is_array($summaryResult['title'])) {
                        $summaryLong = '
							' . __($summaryResult['title'][0]) . '
							<span class="list_header">' . $summaryResult['title'][1] . '</span>
						';
                    }
                    
                    if (isset($summaryResult['data']) && isset($summaryResult['structure alias'])) {
                        $structure = StructuresComponent::$singleton->get('form', $summaryResult['structure alias']);
                        $summaryLong .= $this->Structures->build($structure, array(
                            'type' => 'summary',
                            'data' => $summaryResult['data'],
                            'settings' => array(
                                'return' => true,
                                'actions' => false
                            )
                        ));
                    } elseif (isset($summaryResult['description']) && is_array($summaryResult['description'])) {
                        if (Configure::read('debug') > 0) {
                            AppController::addWarningMsg(__("the sumarty for model [%s] function [%s] is using the depreacted description way instead of a structure", $model, $function));
                        }
                        $summaryLong .= '
							<dl>
						';
                        foreach ($summaryResult['description'] as $k => $v) {
                            
                            // if provided VALUE is an array, it should be a select-option that needs to be looked up and translated...
                            if (is_array($v)) {
                                $v = $structureFieldsModel->findPermissibleValue($plugin, $model, $v);
                            }
                            
                            $summaryLong .= '
									<dt>' . __($k) . '</dt>
									<dd>' . ($v ? $v : '-') . '</dd>
							';
                        }
                        $summaryLong .= '
							</dl>
						';
                    }
                    $result['long'] = strlen($summaryLong) > 0 ? $summaryLong : false;
                    // -------
                }
            }
        }
        return $result;
    }
}