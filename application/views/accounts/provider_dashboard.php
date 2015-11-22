<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="shortcut icon" type="image/x-icon" href="<?php echo IMAGE_URL;?>favicon.ico">
	<title><?php echo SITE_TITLE.': Dashboard';?></title>
    
    <link rel="stylesheet" href="<?php echo base_url();?>assets/css/external-fonts.css" type="text/css">
	<link rel="stylesheet" href="<?php echo base_url();?>assets/css/pss.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="<?php echo base_url();?>assets/css/pss.list.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="<?php echo base_url();?>assets/css/pss.shadowbox.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="<?php echo base_url();?>assets/css/pss.pagination.css" type="text/css" media="screen" />
</head>

<body>
<table class='body-table water-mark-bg'>
<?php 
$this->load->view('addons/secure_header', array('__page'=>'Dashboard'));
$this->load->view('addons/provider_top_menu', array('__page'=>'my_dashboard'));
?>

<tr>
  <td>&nbsp;</td>
  <td class='one-column' style='height:calc(80vh - 100px); padding-bottom: 20px;'>

<table class='home-list-table'>
<tr><th class='h3 dark-grey' style='padding-left:10px;border-bottom:1px solid #999;'>Tender Notices</th></tr>

<tr><td><div id='paginationdiv__tender_list' class='page-list-div'>
<div id="tender__1"><?php $this->load->view('tenders/manage_list',array('list'=>$list));?></div>
</div><button type='button' id='refreshlist' name='refreshlist' style='display:none;'></button></td></tr>
<tr><td>
<table><tr><td>
         
<div id='tender_pagination_div' class='pagination' style="margin:0px;padding:0px; display:inline-block;"><div id="tender" class="paginationdiv no-scroll"><div class="previousbtn" style='display:none;'>&#x25c4;</div><div class="selected">1</div><div class="nextbtn">&#x25ba;</div></div><input name="paginationdiv__tender_action" id="paginationdiv__tender_action" type="hidden" value="<?php echo base_url()."lists/load/t/tender";?>" />
<input name="paginationdiv__tender_maxpages" id="paginationdiv__tender_maxpages" type="hidden" value="<?php echo NUM_OF_LISTS_PER_VIEW;?>" />
<input name="paginationdiv__tender_noperlist" id="paginationdiv__tender_noperlist" type="hidden" value="<?php echo NUM_OF_ROWS_PER_PAGE;?>" />
<input name="paginationdiv__tender_showdiv" id="paginationdiv__tender_showdiv" type="hidden" value="paginationdiv__tender_list" />
<input name="paginationdiv__tender_extrafields" id="paginationdiv__tender_extrafields" type="hidden" value="" /></div>

</td><td width='1%' class='filter-list shadowbox closable' data-url='<?php echo base_url().'tenders/list_filter';?>'>FILTER</td></tr></table>
</td></tr>
</table>







</td>
<td>&nbsp;</td>
</tr>

<?php $this->load->view('addons/secure_footer');?>

</table>
<?php echo minify_js('accounts-provider_dashboard', array('jquery-2.1.1.min.js', 'jquery-ui.js', 'jquery.form.js', 'pss.js', 'pss.shadowbox.js', 'pss.pagination.js'));?>
</body>
</html>